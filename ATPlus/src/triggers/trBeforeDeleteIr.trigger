trigger trBeforeDeleteIr on IR__c (before delete) {   
    List<CDCSLINK__c> linkDeleteList = new List<CDCSLINK__c>();
    Set<String> irIds = new Set<String>();
    try{
        for(IR__c ir : trigger.old){
            irIds.add(ir.Id);
        }
        linkDeleteList = [Select Id From CDCSLINK__c where IR_Id__c in :irIds];
        
        delete linkDeleteList;
    } Catch(exception e){
        
    }   
}