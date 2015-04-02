trigger trOrganizationIndicatorBeforeUpsertQOwner on OrgUnit_Indicator__c (before insert, before update) {
    //Trigger assigns Queue as a Owner based on the Org Unit Name in this Record.
// Making Queue the Owner Logic                                   
    Set<String> records = new Set<String> () ;                                  
    Set<String> QueueNames = new Set<String> () ;                                   
    Map<String,String> GroupIds = New Map<String,String> () ;                                   
    Map<String,String> MapQueueNames  = New Map<String,String> () ;   
    ClsGlobalUtility GU = new ClsGlobalUtility();
    String whereStr;
    String andStr;
    String inValues;
    Map<String,String> masterOUcodeMap = new Map<String,String>();
    
    
    if(!ApplicationConstants.bypassOrganizationIndicatorBeforeUpsertQOwner){                              
                                        
    for (OrgUnit_Indicator__c cd : trigger.new)                                   
    {   
        if (cd.ouCode__c != null){                                
            records.add(cd.ouCode__c);
        }    
        System.debug('Organization Indicator Id:::' +cd.Organization_Indicator_Id__c);
        if (cd.Organization_Indicator_Id__c != null){ 
            if (inValues == null){
                inValues = '\'' +cd.Organization_Indicator_Id__c  + '\' ';
            } else {
                inValues += ', \'' +cd.Organization_Indicator_Id__c  + '\' ';
            }
        }          
    }  
    
    
    
    System.debug('Invalues :::' +inValues);
     
    if (records.isEmpty()){
        Id recType = GU.getRecordTypeId('OrgUnit_Indicator__c','Master');
        if (inValues != null){
            whereStr  = ' Where Organization_Indicator_Id__c in (' +inValues  +')';
            andStr = ' AND RecordTypeId = \'' +recType + '\'';
        
            List<SObject> sObjList = GU.lookupWithFilter(whereStr+andStr, 'OrgUnit_Indicator__c');
            for(SObject sObj: sObjList){
                OrgUnit_Indicator__c oInd = (OrgUnit_Indicator__c)sObj;
                records.add(oInd.ouCode__c);
                masterOUcodeMap.put(oInd.Id,oInd.ouCode__c);
            }
        }       
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
            for    (OrgUnit_Indicator__c cd :  trigger.new )                             
            {                           
                try                     
                {                       
                    if ( GroupIds.get(cd.ouCode__c) == null )                   
                    {      
                        if (GroupIds.get(masterOUcodeMap.get(cd.Organization_Indicator_Id__c)) == null){             
                            cd.addError('Please Create a Queue for ' +cd.ouCode__c );
                        } else {
                            cd.OwnerId = GroupIds.get(masterOUcodeMap.get(cd.Organization_Indicator_Id__c));
                        }                  
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
}