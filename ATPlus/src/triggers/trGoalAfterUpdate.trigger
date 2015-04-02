trigger trGoalAfterUpdate on CDCSGoal__c (after insert, after update) { 
    Map<String,CDCSGoal__c> goalsMap = new Map<String,CDCSGoal__c>();
    List<CDCSLINK__c> cLinkList = new List<CDCSLINK__c>();
    Map<String,CDCSLINK__c> eLinkMap = new Map<String,CDCSLINK__c>();
    clsGlobalUtility GU = new clsGlobalUtility();
    
    if(!ApplicationConstants.byPassGoalAfterUpdate){
    List<CDCSLINK__c> eLinkList = new List<CDCSLINK__c>([Select id, CDCSGoal_Id__c From CDCSLINK__c where Link_Type__c =: 'Primary']);
       
   for(CDCSLINK__c el : eLinkList){
    eLinkMap.put((String)el.CDCSGoal_Id__c,el);
   } 
   
    if (Trigger.isInsert){
        for(CDCSGoal__c goal: Trigger.new){
            goalsMap.put(goal.Id,goal);
            CDCSLINK__c cLink = new CDCSLINK__c(CDCSGoal_Id__c = goal.Id,Link_Type__c = 'Primary', ownerID=goal.ownerId);
            cLinkList.add(cLink);              
        }   
    } else if(Trigger.isUpdate) {        
        for(CDCSGoal__c goal: Trigger.old){
            goalsMap.put(goal.Id,goal);
            CDCSLINK__c cLink = new CDCSLINK__c();
            if (eLinkMap.containsKey(goal.Id)){
                cLink = eLinkMap.get(goal.Id);                  
            }       
            CDCSGoal__c goalNew = Trigger.newMap.get(goal.Id);
            cLink.CDCSGoal_Id__c = goal.Id;
            cLink.Link_Type__c = 'Primary';            
            cLink.ownerId = goal.ownerId;            
            cLinkList.add(cLink); 
        }       
       
       
    }
    
    if (Trigger.isInsert || Trigger.isUpdate){
        upsert cLinkList;
    }
    Map<String,CDCSLINK__c> linksMap = GU.getCDCSLinkForRFElement(goalsMap.keySet(),'CDCSGoal__c');
    for(String key: goalsMap.keySet()){
        clsReportingPeriod reptPeriod = new clsReportingPeriod(); 
        CDCSGoal__c g = new CDCSGoal__c();
        //g = goalsMap.get(key);
        g = Trigger.newMap.get(key);
        CDCSLink__c cl = linksMap.get(g.Id);
        //System.debug('Goal Record:::' +g);
        if (g.Start_Year__c != null && g.End_Year__c != null ){
            reptPeriod.createRepPeriod((String)g.Id,'CDCSGoal__c','Goal_Id__c','Annual',Integer.valueOf((String)g.Start_Year__c),Integer.valueOf((String)g.End_Year__c),cl,null);
        }       
    }
    
 }   

}