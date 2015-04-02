trigger TR_AFTER_UPDATE_IR on IR__c (after insert, after update) {
    
    set<String> doNames = new set<String>();
    set<String> irIds = new set<String>();
    Map<String,DO__c> doMap = new Map<String,DO__c>();
    List<CDCSLINK__c> cLinkList = new List<CDCSLINK__c>();
    Map<String,CDCSLINK__c> eLinkMap = new Map<String,CDCSLINK__c>();
    Map<String,IR__c> irsMap = new Map<String,IR__c>();
    clsGlobalUtility GU = new clsGlobalUtility();
    
    if (Trigger.isInsert){
        for(IR__c xIR: Trigger.new){
            irIds.add(xIR.Id);    
            doNames.add(xIR.do_id__c);
            irsMap.put(xIR.Id,xIR);    
        }   
    } else if(Trigger.isUpdate) {
        System.debug('Record is in the update Mode::');
        for(IR__c xIR: Trigger.old){
            irIds.add(xIR.Id);    
            doNames.add(xIR.do_id__c); 
            irsMap.put(xIR.Id,xIR);   
        }
    }
    
    
    List<DO__c> doList = new List<DO__c>([Select Id, CDCS_Goal__c,do_Code__c, do_Title__c From do__c Where id in :doNames]); 
    List<CDCSLINK__c> eLinkList = new List<CDCSLINK__c>([Select id, IR_Id__c, DO_Id__c From CDCSLINK__c where IR_Id__c in :irIds and Link_Type__c =: 'Primary DO']);
    for(DO__c d : doList){
        doMap.put(d.Id,d);
    }
    for(CDCSLINK__c el : eLinkList){
        eLinkMap.put((String)el.DO_Id__c+(String)el.IR_Id__c,el);
    }    
    
    if(Trigger.isInsert){
        for(IR__c xIR: Trigger.new){        
            if (doMap.containsKey((String)xIR.do_id__c)){
                DO__c  xdo = doMap.get((String)xIR.do_id__c); 
                CDCSLINK__c cLink = new CDCSLINK__c(CDCSGoal_Id__c = xdo.CDCS_Goal__c, DO_Id__c = xdo.Id, IR_Id__c = xIR.Id, Link_Type__c = 'Primary DO', ownerId=xIR.ownerId); 
                
                cLinkList.add(cLink);   
                    
            }
        }
    } else if(Trigger.isUpdate) {
        System.debug('Record is in the update Mode2::');
        for(IR__c xIR: Trigger.old){        
            if (doMap.containsKey((String)xIR.do_id__c)){
                DO__c  xdo = doMap.get((String)xIR.do_id__c); 
                CDCSLINK__c cLink = new CDCSLINK__c();
                if (eLinkMap.containsKey((String)xIR.Do_Id__c+(String)xIR.Id)){ 
                    System.debug('Found eLink...::'+xIR.do_id__c);            
                    cLink = eLinkMap.get((String)xIR.do_id__c+(String)xIR.Id);              
                    
                }                 
                IR__c xIRNew =new IR__c();
                xIRNew = Trigger.newMap.get(xIR.id);
                cLink.DO_Id__c = xIRNew.Do_Id__c;
                cLink.IR_ID__c = xIRNew.Id;
                cLink.CDCSGoal_Id__c = xIRNew.Goal_Id__c;
                cLink.Link_Type__c = 'Primary DO';
                cLink.ownerId = xIRNew.ownerId;
                
                cLinkList.add(cLink);   
                    
            }
        }
        
    }       
    if (trigger.isInsert || trigger.isUpdate){
        upsert cLinkList;
    }  
    Map<String,CDCSLINK__c> linksMap = GU.getCDCSLinkForRFElement(irsMap.keySet(),'IR__c');
    for(String key: irsMap.keySet()){
    	clsReportingPeriod reptPeriod = new clsReportingPeriod();
    	IR__c ir = new IR__c();
    	//ir = irsMap.get(key);
    	ir = Trigger.newMap.get(key);
    	CDCSGoal__c goal = (CDCSGoal__c) GU.lookup(ir.Goal_Sid__c,'CDCSGoal__c');
    	CDCSLink__c cl = linksMap.get(ir.Id);
    	//system.debug('Goal Start Date::' +goal.Start_Year__c);
    	if (goal.Start_Year__c != null && goal.End_Year__c != null){
    		reptPeriod.createRepPeriod((String)ir.Id,'IR__c','IR_Id__c','Annual',Integer.valueOf((String)goal.Start_Year__c),Integer.valueOf((String)goal.End_Year__c),cl,null);
    	}		
    } 
}