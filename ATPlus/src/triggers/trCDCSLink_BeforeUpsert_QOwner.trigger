trigger trCDCSLink_BeforeUpsert_QOwner on CDCSLINK__c (before insert, before update) {


//Trigger assigns Queue as a Owner based on the Org Unit Name in this Record.
// Making Queue the Owner Logic                                   
    Set<String> records = new Set<String> () ;                                  
    Set<String> QueueNames = new Set<String> () ;                                   
    Map<String,String> GroupIds = New Map<String,String> () ;                                   
    Map<String,String> MapQueueNames  = New Map<String,String> () ;                                 
                                        
    for (CDCSLINK__c cd : trigger.new)                                   
    {                                   
        records.add(cd.ouCode__c);           
    }                                   
     system.debug('Record Values::' +records);                                   
    If(records.size() > 0)                                  
    {                                   
        try                             
        {   
        // Get all the Org Units for these records.                            
            OrgUnit__c[] OrgUnit = [SELECT  ouId__c,ouCode__c, Queue_Name__c  FROM   OrgUnit__c                             
                            WHERE  ouCode__c IN: records ];         
                                        
            for ( OrgUnit__c ou: OrgUnit)                           
            {                           
                QueueNames.add(ou.Queue_Name__c);                       
                MapQueueNames.put(ou.Queue_Name__c,ou.ouCode__c);                       
            }                               
                                        
            system.debug('QueueNames ==> '+QueueNames);                             

        // Getting all the Group Records for the Org Unit Queues
                                                
            Group[] lstGroup =  [SELECT Id,Name FROM   Group                            
                            WHERE type='Queue' and Name IN: QueueNames ] ;          
                                        
            system.debug('lstGroup ==> '+lstGroup);                             
        // Populating OrgUnitID and Group Record ID into a Map. 
        // This will let you retrieve a Group Record(Queue Record)for a given Org Unit.

            for ( Group g: lstGroup )                           
            {                           
                GroupIds.put(MapQueueNames.get(g.Name),g.Id);                       
            }                           
                                        
            system.debug('GroupIds ==> '+GroupIds);                             
                                        
            // Update the Owner Ids                         
            for    (CDCSLINK__c cd :  trigger.new )                             
            {                           
                try                     
                {                       
                    if ( GroupIds.get(cd.ouCode__c) == null )                   
                    {                   
                        cd.addError('Please Create a Queue for ' +cd.ouCode__c );               
                    }                   
                    else                    
                    {                   
                        cd.OwnerId = GroupIds.get(cd.ouCode__c);                
                    }                   
                    system.Debug(' test ==> ');                 
                }                       
                Catch ( exception e)                        
                {                       
                    system.Debug(' test ca ==> ');                  
                    cd.addError('Please Create a Mission and Queue for ' +cd.ouCode__c );                   
                }                       
            }                           
        }                               
        Catch (exception e )                                
        {                               
        }                               
    }                                   


}