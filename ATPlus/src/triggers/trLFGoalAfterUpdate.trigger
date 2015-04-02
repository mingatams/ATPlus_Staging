trigger trLFGoalAfterUpdate on LF_Goal__c (after insert, after update) {
    Map<String,LF_Goal__c> lfGoalsMap = new Map<String,LF_Goal__c>();
    List<LogFrame_Tree__c> cLinkList = new List<LogFrame_Tree__c>();
    Map<String,LogFrame_Tree__c> eLinkMap = new Map<String,LogFrame_Tree__c>();
    
    clsGlobalUtility GU = new clsGlobalUtility();
    if (!ApplicationConstants.byPassLFGoalAfterUpdate){
    List<LogFrame_Tree__c> eLinkList = new List<LogFrame_Tree__c>([Select id, LF_Goal_Id__c From LogFrame_Tree__c where Link_Type__c =: 'Primary']);
    for(LogFrame_Tree__c el : eLinkList){
        eLinkMap.put((String)el.LF_Goal_Id__c,el);
    }
    
    if (Trigger.isInsert){
        for(LF_Goal__c lGoal: Trigger.new){
            lfGoalsMap.put(lGoal.Id,lGoal); 
            LogFrame_Tree__c cLink = new LogFrame_Tree__c(LF_Goal_Id__c = lGoal.Id,  Link_Type__c = 'Primary' );
            cLinkList.add(cLink); 
        }   
    } else if(Trigger.isUpdate) {        
        for(LF_Goal__c lGoal: Trigger.old){
            lfGoalsMap.put(lGoal.Id,lGoal);
            
            LogFrame_Tree__c cLink = new LogFrame_Tree__c();
            if (eLinkMap.containsKey(lGoal.Id)){
                cLink = eLinkMap.get(lGoal.Id);                 
            }       
            LF_Goal__c lGoalNew = Trigger.newMap.get(lGoal.Id);
            cLink.LF_Goal_Id__c = lGoal.Id;
            cLink.Link_Type__c = 'Primary'; 
           // cLink.Goal__c = lGoalNew.Goal__c;           
           // cLink.ownerId = lGoalNew.ownerId;            
            cLinkList.add(cLink);
             
        } 
    }
    
    if (Trigger.isInsert || Trigger.isUpdate){
        upsert cLinkList;
    }
    Map<String,LogFrame_Tree__c> linksMap = GU.getLogFrameLinkForLFElement(lfGoalsMap.keySet(),'LF_Goal__c');
    for(String key: lfGoalsMap.keySet()){
        clsReportingPeriod reptPeriod = new clsReportingPeriod();
        LF_Goal__c lGoal = new LF_Goal__c();
       // lGoal = lfGoalsMap.get(key);
        lGoal = Trigger.newMap.get(key);
        LogFrame_Tree__c cl = linksMap.get(lGoal.Id);
        Project__c proj = (Project__c) GU.lookup(lGoal.Project_Id__c,'Project__c'); 
        if (proj.Start_Date__c != null && proj.End_Date__c != null){      
            reptPeriod.createRepPeriod((String)lGoal.Id,'LF_Goal__c','LF_Goal_Id__c','Annual',proj.Start_Date__c.year(),proj.End_Date__c.year(),null,cl);
        }     
    } 
   } 

}