trigger TR_UPDATE_IR_SearchSettings on IR__c (before insert, before update) {
  Integer spos, nlen;
    set<String> doNames = new set<String>();
    Map<String,DO__c> doMap = new Map<String,DO__c>();
    //List<CDCSLINK__c> cLinkList = new List<CDCSLINK__c>();
    
    for(IR__c xIR: Trigger.new){
        String code = ((String)xIR.Name).trim();
        if (code.length() <= 11){
            String irRegX; 
            if (xIR.Do_Code__c.startsWith('DO') ){
                irRegX = '^([iI].*[rR].*[1-9]\\.[1-9])';
            } else {
                irRegX = '^([sS][oO].*[iI].*[rR].*[1-9]\\.[1-9])';
            }    
            Pattern irPattern = Pattern.compile(irRegX); 
            Matcher irMatcher = irPattern.matcher(code);
            if (irMatcher.matches()){
                Integer matchLength = irMatcher.group().length();
                system.debug('Macher Group:'+irMatcher.group());
                if (xIR.Do_Code__c.startsWith('DO') ){
                    code = ('IR ' + irMatcher.group().substring(matchLength-3,matchLength)).toUpperCase();      
                    xIR.Name = ('IR ' + irMatcher.group().substring(matchLength-3,matchLength)).toUpperCase();
                } else {
                    system.debug('Macher Before:'+irMatcher.group(0).substring(matchLength-6,matchLength));
                    code = ('SO IR ' + irMatcher.group().substring(matchLength-3,matchLength)).toUpperCase();      
                    xIR.Name = ('SO IR ' + irMatcher.group().substring(matchLength-3,matchLength)).toUpperCase();
                }    
            } else {
                xIR.Name.addError('Please enter in the this format IR 1.1, IR 1.2, SO IR 1.1....');
            }
        } else {
            xIR.Name.addError('Please enter in the this format IR 1.1, IR 1.2, SO IR 1.1.. . Maximum allowed characters are 11');
        }
        
        String title = (String)xIR.IR_Title__c;
    
    /* if(((String)XIR.name).length() > 65){        
        xIR.Name.addError('Maximum number of characters (65) exceeded for I.R.Name. ');
    }
    
        if (xIR.name.contains(' | ')){
            spos = xIR.name.indexOf(' | ')+3;
            nlen = xIR.name.length();
            title = xIR.name.substring(spos, nlen);
            xIR.IR_title__c = title;
        }
  
        xIR.IR_title__c = title;
        xIR.name = code + ' | ' + title; */
        xIR.IR_Code__c = code;
        xIR.Unique_Name__c = xIR.ouCode__c+ ' - ' + xIR.do_Code__c+ ' - ' + xIR.IR_Code__c;
        doNames.add(xIR.do_Id__c);    
    } 
    
    List<DO__c> doList = new List<DO__c>([Select Id, do_Code__c, do_Title__c From do__c Where id in :doNames]); 
    for(DO__c d : doList){
        doMap.put(d.Id,d);
    }    
    
    for(IR__c xIR: Trigger.new){        
        if (doMap.containsKey((String)xIR.do_Id__c)){
            DO__c  xdo = doMap.get((String)xIR.do_Id__c);     
        //    xIR.do_code__c = xdo.do_Code__c;
        //    xIR.do_title__c = xdo.do_title__c;          
        //  CDCSLINK__c cLink = new CDCSLINK__c(Do_Name__c = xdo.Id, IR_Name__c = xIR.Id, Link_Type__c = 'Primary IR' );
        //  cLinkList.add(cLink);   
                
        }
    }   
   // if (trigger.isInsert){
   //   upsert cLinkList;
   // } 
   
    //Queue Logic                                                               
    Set<String> records = new Set<String> () ;                                                              
    Set<String> QueueNames = new Set<String> () ;                                                               
    Map<String,String> GroupIds = New Map<String,String> () ;                                                               
    Map<String,String> MapQueueNames  = New Map<String,String> () ;                                                             
                                                                    
    for (IR__c x : trigger.new)                                                             
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
            for    (IR__c  x:  trigger.new )                                                        
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