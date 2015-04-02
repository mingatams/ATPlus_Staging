trigger trGoalBeforeUpsertQowner on CDCSGoal__c (before insert, before update) {
    //Trigger assigns Queue as a record owner based on the org Unit name in the Project Record
   
   //Queue Logic                                                                        
    Set<String> records = new Set<String> () ;                                                                      
    Set<String> QueueNames = new Set<String> () ;                                                                       
    Map<String,String> GroupIds = New Map<String,String> () ;                                                                       
    Map<String,String> MapQueueNames  = New Map<String,String> () ;                                                                     
    if(!ApplicationConstants.byPassGoalBeforeUpsertQowner){                                                                        
    for (CDCSGoal__c x : trigger.new)                                                                       
    {                                                                       
        records.add(x.ouCode__c);
       // if (x.Start_Year__c != null && x.End_Year__c != null){
       //   x.Name = (String)x.ouName__c +' (Results Framework)';
       // }                                                                   
    }                                                                       
                                                                            
    If(records.size() > 0)                                                                      
    {                                                                       
        try                                                                 
        {                                                                   
            OrgUnit__c[] OrgUnit = [SELECT  ouId__c,ouCode__c, Queue_Name__c  FROM   OrgUnit__c                                                                 
                            WHERE  ouCode__c IN: records ];                                             
                                                                            
            for ( OrgUnit__c ou: OrgUnit)                                                               
            {                                                               
                QueueNames.add(ou.Queue_Name__c);                                                           
                MapQueueNames.put(ou.Queue_Name__c,ou.ouCode__c);                                                           
            }                                                                   
                                                                            
            system.debug('QueueNames ==> '+QueueNames);                                                                 
                                                                            
            Group[] lstGroup =  [SELECT Id,Name FROM   Group                                                                
                            WHERE type='Queue' and Name IN: QueueNames ] ;                                              
                                                                            
            system.debug('lstGroup ==> '+lstGroup);                                                                 
                                                                            
            for ( Group g: lstGroup )                                                               
            {                                                               
                GroupIds.put(MapQueueNames.get(g.Name),g.Id);                                                           
            }                                                               
                                                                            
            system.debug('GroupIds ==> '+GroupIds);                                                                 
                                                                            
            // Update the Owner Ids                                                             
            for    (CDCSGoal__c  x:  trigger.new )                                                              
            {                                                               
                try                                                         
                {                                                           
                    if ( GroupIds.get(x.ouCode__c) == null )                                                        
                    {                                                       
                        x.addError('Please Create a Queue for ' +x.ouCode__c );                                                 
                    }                                                       
                    else                                                        
                    {                                                       
                        x.OwnerId = GroupIds.get(x.ouCode__c);                                                  
                    }                                                       
                    system.Debug(' test ==> ');                                                     
                }                                                           
                Catch ( exception e)                                                            
                {                                                           
                    system.Debug(' test ca ==> ');                                                      
                    x.addError('Please Create an OrgUnit and Queue for ' +x.ouCode__c );                                                        
                }                                                           
            }                                                               
        }                                                                   
        Catch (exception e )                                                                    
        {                                                                   
        }                                                                   
    }  
   }                                  
}