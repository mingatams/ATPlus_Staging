trigger trLFGoalBeforeDelete on LF_Goal__c (before delete) {
    Map<String,LF_Goal__c> goalsMap = new Map<String,LF_Goal__c>();

    for(LF_Goal__c goal: Trigger.old){
        goalsMap.put(goal.Id,goal); 
    }
    

    List<LogFrame_Tree__c> eLinkList = new List<LogFrame_Tree__c>([Select id, LF_Goal_Id__c From LogFrame_Tree__c where LF_Goal_Id__c in :goalsMap.keySet() and Link_Type__c = 'Primary']);

    if (!eLinkList.isEmpty()){
        delete eLinkList;
    }
}