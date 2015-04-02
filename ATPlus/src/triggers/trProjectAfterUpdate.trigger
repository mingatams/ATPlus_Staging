trigger trProjectAfterUpdate on Project__c (after insert, after update) {
    
    Map<String,Project__c> projectssMap = new Map<String,Project__c>();
    clsGlobalUtility GU = new clsGlobalUtility();
    if (Trigger.isInsert){
        for(Project__c proj: Trigger.new){
            projectssMap.put(proj.Id,proj);  
        }   
    } else if(Trigger.isUpdate) {        
        for(Project__c proj: Trigger.old){
            projectssMap.put(proj.Id,proj); 
        } 
    }

  /*  for(String key: projectssMap.keySet()){
        clsReportingPeriod reptPeriod = new clsReportingPeriod();
        Project__c proj = new Project__c();
        proj = projectssMap.get(key);       
        reptPeriod.createRepPeriod((String)proj.Id,'Project__c','Project_Id__c','Annual',proj.Start_Date__c.year(),proj.End_Date__c.year());  
    } */

}