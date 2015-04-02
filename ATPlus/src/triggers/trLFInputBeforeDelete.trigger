trigger trLFInputBeforeDelete on LF_Input__c (before delete) {
    Map<String,LF_Input__c> inputsMap = new Map<String,LF_Input__c>();

    for(LF_Input__c input: Trigger.old){
        inputsMap.put(input.Id,input); 
    }
    

    List<LogFrame_Tree__c> eLinkList = new List<LogFrame_Tree__c>([Select id, LF_Input_Id__c From LogFrame_Tree__c where LF_Input_Id__c in :inputsMap.keySet() and Link_Type__c ='Primary Output']);

    if (!eLinkList.isEmpty()){
        delete eLinkList;
    }
}