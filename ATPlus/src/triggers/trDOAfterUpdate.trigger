trigger trDOAfterUpdate on DO__c (after insert, after update) {
	Map<String,DO__c> dosMap = new Map<String,DO__c>();
	
    List<CDCSLINK__c> cLinkList = new List<CDCSLINK__c>();
    Map<String,CDCSLINK__c> eLinkMap = new Map<String,CDCSLINK__c>();
	
	clsGlobalUtility GU = new clsGlobalUtility();
	if (Trigger.isInsert){
        for(DO__c doo: Trigger.new){
            dosMap.put(doo.Id,doo);  
        }   
    } else if(Trigger.isUpdate) {        
        for(DO__c doo: Trigger.old){
            dosMap.put(doo.Id,doo); 
        } 
    }
    
   // CDCSGoal__c goal = [Select Id, do_Code__c, do_Title__c From do__c Where id in :doNames]; 
    List<CDCSLINK__c> eLinkList = new List<CDCSLINK__c>([Select id, CDCSGoal_Id__c, DO_Id__c From CDCSLINK__c where DO_Id__c in :dosMap.keySet() and Link_Type__c =: 'Primary Goal']);
    
    for(CDCSLINK__c el : eLinkList){
        eLinkMap.put((String)el.CDCSGoal_Id__c+(String)el.DO_Id__c,el);
    }    
    
    if(Trigger.isInsert){
        for(DO__c xdo: Trigger.new){
        	CDCSLINK__c cLink = new CDCSLINK__c(CDCSGoal_Id__c = xdo.CDCS_Goal__c,DO_Id__c = xdo.Id, Link_Type__c = 'Primary Goal', ownerId=xdo.ownerId); 
            cLinkList.add(cLink);
        }
    } else if(Trigger.isUpdate) {
        System.debug('Record is in the update Mode2::');
        for(DO__c xdo: Trigger.old){
            CDCSLINK__c cLink = new CDCSLINK__c();
            if (eLinkMap.containsKey((String)xdo.CDCS_Goal__c+(String)xdo.Id)){ 
                System.debug('Found eLink...::'+xdo.CDCS_Goal__c);            
                cLink = eLinkMap.get((String)xdo.CDCS_Goal__c+(String)xdo.Id);              
                
            }                 
            DO__c xdoNew =new DO__c();
            xdoNew = Trigger.newMap.get(xdo.id);
            cLink.DO_Id__c = xdoNew.Id;
            cLink.CDCSGoal_Id__c = xdoNew.CDCS_Goal__c;
            cLink.Link_Type__c = 'Primary Goal';
            cLink.ownerId = xdoNew.ownerId;            
            cLinkList.add(cLink);
        }
        
    }       
    if (trigger.isInsert || trigger.isUpdate){
        upsert cLinkList;
    }
    
    Map<String,CDCSLINK__c> linksMap = GU.getCDCSLinkForRFElement(dosMap.keySet(),'DO__c');
    for(String key: dosMap.keySet()){
    	clsReportingPeriod reptPeriod = new clsReportingPeriod();
    	DO__c doo = new DO__c();
    	//doo = dosMap.get(key);
    	doo = Trigger.newMap.get(key);
    	CDCSGoal__c goal = (CDCSGoal__c) GU.lookup(doo.CDCS_Goal__c,'CDCSGoal__c');
    	CDCSLink__c cl = linksMap.get(doo.Id);
    	system.debug('Goal Start Date::' +goal.Start_Year__c);
    	if (goal.Start_Year__c != null && goal.End_Year__c != null){
    		reptPeriod.createRepPeriod((String)doo.Id,'DO__c','DO_Id__c','Annual',Integer.valueOf((String)goal.Start_Year__c),Integer.valueOf((String)goal.End_Year__c),cl,null);
    	}		
    }

}