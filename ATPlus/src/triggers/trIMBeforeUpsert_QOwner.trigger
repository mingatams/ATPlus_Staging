trigger trIMBeforeUpsert_QOwner on Implementing_Mechanism__c (before Insert,Before Update) {
 /*
       Set<String> OrgUnits= new Set<String> () ;
   Set<String> QueueNames = new Set<String> () ;
   Map<String,String> GroupIds = New Map<String,String> () ;
   Map<String,String> MapQueueNames  = New Map<String,String> () ;
   try{
   for(Implementing_Mechanism__c I : trigger.new){
    OrgUnits.add(i.ouID__c);
   }
   
     If(OrgUnits.size() > 0){
     
      OrgUnit__c[] OUnits=[SELECT id,ouCode__c,ouDisplayName__c,ouName__c,Queue_Name__c 
                     FROM  OrgUnit__c WHERE id IN: OrgUNits];
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
          GroupIds.put(MapQueueNames.get(g.Name),g.Id); 
        } 
       
       system.debug('GroupIds ==> '+GroupIds);     
        // Update the OWner Ids
        
        for(Implementing_Mechanism__c i : trigger.new){
         try{
           if (GroupIds.get(i.ouid__r.queue_Name__c) == null ){
            i.addError('Please Create a Mission and Queue for ' + i.ouID__r.ouName__c );
           }else {
           
             i.OwnerId = GroupIds.get(i.ouid__r.queue_Name__c);
           }
          system.Debug(' test ==> ');
         } Catch ( exception e) {
           system.Debug(' test ce ==> ');
           i.addError('Please Create a Mission and Queue for ' + i.ouID__c );
         } 
        }
                 
     } 
     }Catch (exception e ){
     
     }
      */
      

   //Trigger assigns Queue as a record owner based on the org Unit name in the IM Record
   
   Set<String> OrgUnits= new Set<String> () ;
   Set<String> QueueNames = new Set<String> () ;
   Map<String,String> GroupIds = New Map<String,String> () ;
   Map<String,String> MapQueueNames  = New Map<String,String> () ;
   Map<String,String> org_Qname  = New Map<String,String> () ;
   
   for(Implementing_Mechanism__c IM : trigger.new){
    OrgUnits.add(IM.ouID__c);
   }
   
    If(OrgUnits.size() > 0){
     
      OrgUnit__c[] OUnits=[SELECT id,ouCode__c,ouDisplayName__c,ouName__c,Queue_Name__c 
                     FROM  OrgUnit__c WHERE id IN: OrgUNits];
        for ( OrgUnit__c ou: OUnits  ) {
          QueueNames.add(ou.Queue_Name__c); 
          MapQueueNames.put(ou.ouName__c,ou.Queue_Name__c); 
          org_Qname.put(ou.Queue_Name__c,ou.Id);  
        }       
          system.debug('QueueNames ==> '+QueueNames);   
        
      Group[] lstGroup =  [SELECT Id,Name 
                            FROM Group 
                          WHERE type='Queue' and Name IN: org_Qname.keyset()] ;
              system.debug('lstGroup ==> '+lstGroup);    
           for ( Group g: lstGroup ) {
           system.debug('g.name'+g.name);
              GroupIds.put(org_Qname.get(g.Name),g.Id); 
           } 
       
              system.debug('GroupIds ==> '+GroupIds);     
        // Update the OWner Ids
          for(Implementing_Mechanism__c I : trigger.new){
            if( GroupIds.get(i.ouId__c) != null ) {
               I.OwnerId = GroupIds.get(I.ouId__c) ;
               }
        }
                 
    }
   
}