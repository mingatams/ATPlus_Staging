trigger trBeforeDeleteSIR on Sub_IR__c (Before delete) {
    
    List<CDCSLINK__c> linkDeleteList = new List<CDCSLINK__c>(); 
    //system.debug('Delete List::::');
    Set<String> sirIds = new Set<String>();
    try{
        
        for(Sub_IR__c sir : Trigger.old){           
            sirIds.add(sir.Id);
        }   
        system.debug('Delete List1::::'+sirIds);
        linkDeleteList = [Select Id From CDCSLINK__c where SIR_Id__c in :sirIds];
        system.debug('Delete List::::'+linkDeleteList);
        delete linkDeleteList; 
        
    } 
    Catch(exception e){
        
    }
        
}