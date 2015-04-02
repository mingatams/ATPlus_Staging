trigger trbeforeDeleteDO on DO__c (before delete) {
    List<CDCSLINK__c> linkDeleteList = new List<CDCSLINK__c>();
    Set<String> doIds = new Set<String>();
    try{
        for(DO__c d:Trigger.old){
            doIds.add(d.Id);
        }
        linkDeleteList = [Select Id From CDCSLINK__c where DO_Id__c in :doIds];
        
        delete linkDeleteList;
    } Catch(exception e){
        
    }   
    
}