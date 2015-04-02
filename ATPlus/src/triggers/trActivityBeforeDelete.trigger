trigger trActivityBeforeDelete on Activity__c (before delete) {
    List<Portfolio_RF_Linkage__c> portfolioLinkDelList = new List<Portfolio_RF_Linkage__c>();   
    
    Set<String> actIds = new Set<String>();
    try{
        
        for(Activity__c act:Trigger.Old){
            actIds.add(act.Id);
        }   
        
        portfolioLinkDelList = [Select Id From Portfolio_RF_Linkage__c where Activity_Id__c in :actIds];
        
        delete portfolioLinkDelList;
    } Catch(exception e){
        
    }   

}