trigger trLFSubPurposeBeforeDelete on LF_SubPurpose__c (before delete) {
    Map<String,LF_SubPurpose__c> SubPurposesMap = new Map<String,LF_SubPurpose__c>();

    for(LF_SubPurpose__c SubPurpose: Trigger.old){
        SubPurposesMap.put(SubPurpose.Id,SubPurpose); 
    }
    

    List<LogFrame_Tree__c> eLinkList = new List<LogFrame_Tree__c>([Select id, LF_SubPurpose_Id__c From LogFrame_Tree__c where LF_SubPurpose_Id__c in :SubPurposesMap.keySet() and Link_Type__c = 'Primary Purpose']);

    if (!eLinkList.isEmpty()){
        delete eLinkList;
    }
}