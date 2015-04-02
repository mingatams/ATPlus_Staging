trigger trActivityBeforeUpsert_QOwner on Activity__c (before Insert,Before update) {
   
  
    /*
   //The following code asigns queue as a owner of the record based on the Queue_Name__c value in the activity
   Set<String> OrgUnits= new Set<String> () ;
   Set<String> QueueNames = new Set<String> () ;
   Map<String,String> GroupIds = New Map<String,String> () ;
   Map<String,String> MapQueueNames  = New Map<String,String> () ;
   for(Activity__c a : trigger.new){
    OrgUnits.add(a.ouName__c);
   }
   
   
    If(OrgUnits.size() > 0){
     try{
      OrgUnit__c[] OUnits=[SELECT id,ouCode__c,ouDisplayName__c,ouName__c,Queue_Name__c 
                     FROM  OrgUnit__c WHERE ouName__c IN: OrgUNits];
        for ( OrgUnit__c ou: OUnits  ) {
          QueueNames.add(ou.Queue_Name__c); 
          MapQueueNames.put(ou.ouName__c,ou.Queue_Name__c); 
          system.debug('MapQueueNames'+MapQueueNames); 
        }       
        system.debug('QueueNames ==> '+QueueNames);   
                
      Group[] lstGroup =  [SELECT Id,Name 
                            FROM Group 
                          WHERE type='Queue' and Name IN: QueueNames ] ;
      system.debug('lstGroup ==> '+lstGroup);    
        for ( Group g: lstGroup ) {
          GroupIds.put(g.Name,g.Id); 
        } 
       
       system.debug('GroupIds ==> '+GroupIds);     
        // Update the OWner Ids
        
        for(Activity__c a : trigger.new){
         
             a.OwnerId = GroupIds.get(a.Queue_name__c);
        }
                 
     } Catch (exception e ){
     
     }
      
    }
    */
    
   
  
    
   //The following code asigns queue as a owner of the record based on the Queue_Name__c value in the activity

     
   Set<String> projectids= new Set<String> () ;
   Set<String> QueueNames = new Set<String> () ;
   Map<String,String> GroupIds = New Map<String,String> () ;
   Map<String,String> MapQueueName  = New Map<String,String> () ;
   for(Activity__c a : trigger.new){
    projectids.add(a.Project_Code__c);
   }
   
   Project__c[] pList = [select id,ownerid from project__c where id in: projectids];
   
   for(project__c p: pList){
   mapQueueName.put(p.id,p.ownerid);
   }
        
        for(Activity__c a : trigger.new){
         
             a.OwnerId = mapQueueName.get(a.project_Code__c);
        }
                 
     
   
   
}