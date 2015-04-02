trigger trLFOutputBeforeDelete on LF_Output__c (before delete) {
    Map<String,LF_Output__c> outputsMap = new Map<String,LF_Output__c>();

    for(LF_Output__c output: Trigger.old){
        outputsMap.put(output.Id,output); 
    }
    

    List<LogFrame_Tree__c> eLinkList = new List<LogFrame_Tree__c>([Select id, LF_Output_Id__c From LogFrame_Tree__c where LF_Output_Id__c in :outputsMap.keySet() and Link_Type__c IN ('Primary Sub-Purpose', 'Primary Purpose Output')]);

    if (!eLinkList.isEmpty()){
        delete eLinkList;
    }
}