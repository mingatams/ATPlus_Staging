trigger TR_UPDATE_DO_SearchSettings on DO__c (before insert, before update) {
    
    DO__c xDO = trigger.new[0];
    String code = ((String)xDO.Name).trim();
    if (code.length() <= 6){
	    String doRegX = '^([dDsS].*[oO].*[1-9])';
	    Pattern doPattern = Pattern.compile(doRegX); 
	    Matcher doMatcher = doPattern.matcher(code);
	    if (doMatcher.matches()){
	    	Integer matchLength = doMatcher.group().length();
	    	code = (doMatcher.group().substring(0, 1) + 'O ' + doMatcher.group().substring(matchLength-1,matchLength)).toUpperCase();    	
	    	xDO.Name = (doMatcher.group().substring(0, 1) + 'O ' + doMatcher.group().substring(matchLength-1,matchLength)).toUpperCase();
	    } else {
	    	xDO.Name.addError('Please enter in the this format DO1, DO2.. or SO 1, SO 2..');
	    }
    } else {
    	xDO.Name.addError('Please enter in the this format DO1, DO2.. or SO 1, SO 2.. . Maximum allowed characters are 6 ');
    }
    String title = (String)xDO.DO_Title__c;
    /*if(((String)XDO.name).length() > 65){    	
    	xDO.Name.addError('Maximum number of characters (65) exceeded for D.O.Name. ');
    }
    
    Integer spos, nlen;

 // Script that strips the Code out of name and puts it into Title.
    if (xDO.name.contains(' | '))
    {
        spos = xDO.name.indexOf(' | ')+3;
        nlen = xDO.name.length();
        title = xDO.name.substring(spos, nlen);
        xDO.DO_title__c = title;
    }
  
    xDO.DO_title__c = title;
    xDO.name = code + ' | ' + title; */
    xdO.DO_Code__c = code;
    xDo.Unique_name__c = xDo.ouCode__c+ ' - ' + xDO.DO_Code__c; 
    
    //OpUnit
 /*   String ou_id = xDO.opUnit_Name__c;    
    
    
    OpUnit__c  o = [Select  OpUnit_Code__c, OpUnit_Title__c From OpUnit__c Where id =: ou_id];
    xDo.OpUnit_code__c = o.opunit_Code__c;
    xDo.OpUnit_title__c = o.opunit_title__c;

    xDo.Unique_name__c = xDo.opUnit_code__c + ' - ' + xDO.DO_Code__c; */

    //Queue Logic                                                       
    Set<String> records = new Set<String> () ;                                                      
    Set<String> QueueNames = new Set<String> () ;                                                       
    Map<String,String> GroupIds = New Map<String,String> () ;                                                       
    Map<String,String> MapQueueNames  = New Map<String,String> () ;                                                     
                                                            
    for (DO__c x : trigger.new)                                                     
    {                                                       
        records.add(x.ouCode__c);                                                   
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
            for    (DO__c  x:  trigger.new )                                                
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
                    x.addError('Please Create a Mission and Queue for ' +x.ouCode__c );                                     
                }                                           
            }                                               
        }                                                   
        Catch (exception e )                                                    
        {                                                   
        }                                                   
    }                                                       
        
}