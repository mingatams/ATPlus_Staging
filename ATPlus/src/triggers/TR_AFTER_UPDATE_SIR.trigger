trigger TR_AFTER_UPDATE_SIR on Sub_IR__c (after insert, after update) {
   // set<String> doNames = new Set<String>();
    set<String> irNames = new set<String>();
    set<String> sirIds = new set<String>();
   // Map<String,DO__c> doMap = new Map<String,DO__c>();
    Map<String,IR__c> irMap = new Map<String,IR__c>();
    List<CDCSLINK__c> cLinkList = new List<CDCSLINK__c>();
    Map<String,CDCSLINK__c> eLinkMap = new Map<String,CDCSLINK__c>();
    Map<String,Sub_IR__c> sirsMap = new Map<String,Sub_IR__c>();
    clsGlobalUtility GU = new clsGlobalUtility();
    
    if (Trigger.isInsert){
        for(SUB_IR__c xSIR: Trigger.new){       
            irNames.add(xSIR.IR_Id__c);  
        } 
    } else if(Trigger.isUpdate) {
        System.debug('Record is in the update Mode::');
        for(SUB_IR__c xSIR: Trigger.old){
            sirIds.add(xSIR.Id);    
            irNames.add(xSIR.IR_id__c);    
        }    
    }
    List<IR__c> irList = new List<IR__c>([Select  Goal_Id__c, DO_Id__c, do_Code__c, do_Title__c, ir_Code__c, ir_Title__c From IR__c Where id in :irNames]); 
    List<CDCSLINK__c> eLinkList = new List<CDCSLINK__c>([Select id, IR_Id__c, DO_Code__c, SIR_Id__c From CDCSLINK__c where SIR_Id__c in :sirIds and Link_Type__c =: 'Primary IR']);
    
    for(IR__c d : irList){
    //	doNames.add(d.Do_Id__c);
        irMap.put(d.Id,d);
    }       
   /* List<Do__c> doList = new List<Do__c>([Select DO_Id__c, do_Code__c, do_Title__c From Do__c Where id in :doNames]);
    for(Do__c dd : doList){    	
        doMap.put(dd.Id,dd);
    } */
    
    for(CDCSLINK__c el : eLinkList){
        eLinkMap.put((String)el.DO_Code__c+(String)el.IR_Id__c+(String)el.SIR_ID__c,el);
    }
   if(Trigger.isInsert){ 
	    for(SUB_IR__c xSIR: trigger.new){        
	        if (irMap.containsKey((String)xSIR.IR_Id__c)){
	            IR__c  xir = irMap.get((String)xSIR.IR_Id__c);                       
	            CDCSLINK__c cLink = new CDCSLINK__c(CDCSGoal_Id__c = xir.Goal_Id__c, DO_Id__c = xir.DO_ID__c, IR_Id__c = xIR.Id, SIR_Id__c = xSIR.id, Link_Type__c = 'Primary IR', ownerID=xSIR.ownerId );
	            cLinkList.add(cLink);   
	            sirsMap.put(xSIR.Id,xSIR);	                
	        }
	    } 
   }  else if(Trigger.isUpdate) {
        System.debug('Record is in the update Mode2::');
        for(Sub_IR__c xSIR: Trigger.old){ 
        	sirsMap.put(xSIR.Id,xSIR);       
            if (irMap.containsKey((String)xSIR.Ir_id__c)){
                IR__c  xIr = irMap.get((String)xSIR.Ir_id__c); 
                CDCSLINK__c cLink = new CDCSLINK__c();
                if (eLinkMap.containsKey((String)xIR.DO_Code__c+(String)xSIR.IR_Id__c+(String)xSIR.Id)){ 
                    System.debug('Found eLink...::'+xSIR.IR_Id__c);            
                    cLink = eLinkMap.get((String)xIR.DO_Code__c+(String)xSIR.IR_Id__c+(String)xSIR.Id);              
                    
                }                 
                Sub_IR__c xSIRNew =new Sub_IR__c();
                xSIRNew = Trigger.newMap.get(xSIR.id);
                cLink.CDCSGoal_Id__c = xIr.Goal_Id__c;
                cLink.DO_Id__c = xIr.Do_Id__c;
                cLink.IR_Id__c = xIr.Id;
                cLink.SIR_ID__c = xSIRNew.Id;
                cLink.Link_Type__c = 'Primary IR';
                cLink.ownerId = xSIRNew.ownerId;
                
                cLinkList.add(cLink);   
                    
            }
        }
        
    }      
    if (trigger.isInsert || trigger.isUpdate){
        upsert cLinkList;
    }
    Map<String,CDCSLINK__c> linksMap = GU.getCDCSLinkForRFElement(sirsMap.keySet(),'Sub_IR__c');
    for(String key: sirsMap.keySet()){
    	clsReportingPeriod reptPeriod = new clsReportingPeriod();
    	Sub_IR__c sir = new Sub_IR__c();
    	//sir = sirsMap.get(key);
    	sir = Trigger.newMap.get(key);
    	CDCSGoal__c goal = (CDCSGoal__c) GU.lookup(sir.Goal_Sid__c,'CDCSGoal__c');
    	CDCSLink__c cl = linksMap.get(sir.Id); 
    	//system.debug('Goal Start Date::' +goal.Start_Year__c);
    	if (goal.Start_Year__c != null && goal.End_Year__c != null){
    		reptPeriod.createRepPeriod((String)sir.Id,'Sub_IR__c','SIR_Id__c','Annual',Integer.valueOf((String)goal.Start_Year__c),Integer.valueOf((String)goal.End_Year__c),cl,null);
    	}		
    } 
}