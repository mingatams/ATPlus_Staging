trigger trLFPurposeBeforeDelete on LF_Purpose__c (before delete) {
    Map<String,LF_Purpose__c> purposesMap = new Map<String,LF_Purpose__c>();

    for(LF_Purpose__c purpose: Trigger.old){
        purposesMap.put(purpose.Id,purpose); 
    }
    

    List<LogFrame_Tree__c> eLinkList = new List<LogFrame_Tree__c>([Select id, LF_purpose_Id__c From LogFrame_Tree__c where LF_purpose_Id__c in :purposesMap.keySet() and Link_Type__c = 'Primary Goal' ]);

    if (!eLinkList.isEmpty()){
        delete eLinkList;
    }

}