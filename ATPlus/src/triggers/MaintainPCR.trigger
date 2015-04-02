trigger MaintainPCR on Location1__c (after delete, after insert, after update) {
    List<Project_Region__c> toUpsert = new List<Project_Region__c>();
    
    Set<String> keys = new Set<String>();
    
    Set<Id> ProjectIDs = new Set<Id>();
    if (Trigger.isDelete || Trigger.IsUpdate) {
        for (Location1__c loc : Trigger.old) {
        	ProjectIDs.add(loc.Project_Code__c);
        }
    }
    else if (Trigger.IsInsert || Trigger.IsUpdate) {
        for (Location1__c loc : Trigger.new) {
        	ProjectIDs.add(loc.Project_Code__c);
        }
    }
    
    List<AggregateResult> results = new List<AggregateResult>([SELECT COUNT(Id) cnt, Project_Code__c, Activity_Location_Province__c, Activity_Location_Country__c FROM Location1__c WHERE (Project_Code__c in :ProjectIDs) AND (Activity_Location_Province__c != null) AND (Activity_Location_Country__c != null) GROUP BY Activity_Location_Country__c, Activity_Location_Province__c, Project_Code__c]);
    
    for (AggregateResult res : results) {
    	String country = (String)res.get('Activity_Location_Country__c');
    	String province = (String)res.get('Activity_Location_Province__c');
    	String projectId = (String)res.get('Project_Code__c');
    	Integer cnt = (Integer)res.get('cnt');
    	
    	String key = projectId + ':' + country + ':' + province;
    	keys.add(key);
    	
    	Project_Region__c pcr = new Project_Region__c();
        pcr.Project__c = projectId;
        pcr.Country__c = country;
        pcr.Region__c = province;
        pcr.Locations__c = cnt;
        pcr.Key__c = key;
        
        toUpsert.add(pcr);
    }
        
    if (!toUpsert.IsEmpty()) {
        Database.upsert(toUpsert, Schema.Project_Region__c.Key__c);
    }
    
    List<Project_Region__c> toDelete = new List<Project_Region__c>([SELECT Id FROM Project_Region__c WHERE (Project__c in :ProjectIDs) AND (Key__c not in :keys)]);
    if (!toDelete.IsEmpty()) delete toDelete;
    
}