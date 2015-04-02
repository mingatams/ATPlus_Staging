trigger TR_UPDATE_SUB_IR_SearchSettings on SUB_IR__c (before insert, before update) {
 Integer spos, nlen;
    set<String> irNames = new set<String>();
    Map<String,IR__c> irMap = new Map<String,IR__c>();
    
    
    for(SUB_IR__c xSIR: trigger.new){       
        String code = ((String)xSIR.Name).trim();
        if (code.length() <= 12){
            String irRegX = '^([sS][uU][bB]-[iI][rR].*[1-9]\\.[1-9]\\.[1-9])';
            Pattern irPattern = Pattern.compile(irRegX); 
            Matcher irMatcher = irPattern.matcher(code);
            if (irMatcher.matches()){
                Integer matchLength = irMatcher.group().length();
                code = ('SUB-IR ' + irMatcher.group().substring(matchLength-5,matchLength)).toUpperCase();      
                xSIR.Name = ('SUB-IR ' + irMatcher.group().substring(matchLength-5,matchLength)).toUpperCase();
            } else {
                xSIR.Name.addError('Please enter in the this format SUB-IR 1.1.1, SUB-IR 1.1.2 ..');
            }
        } else {
            xSIR.Name.addError('Please enter in the this format SUB-IR 1.1.1, SUB-IR 1.1.2 .. . Maximum allowed characters are 12');
        }
        String title = (String)xSIR.SIR_Title__c;
        
    /*    if(((String)xSIR.name).length() > 65){      
        xSIR.Name.addError('Maximum number of characters (65) exceeded for S.I.R.Name.');
        }
        
      if (xSIR.name.contains(' | ')){
        spos = xSIR.name.indexOf(' | ')+3;
        nlen = xSIR.name.length();
        title = xSIR.name.substring(spos, nlen);
        xSIR.SIR_title__c = title;
        } 
        
        xSIR.SIR_title__c = title;
        xSIR.name = code + ' | ' + title;*/
        xSIR.SIR_Code__c = code;
      //  xSIR.SIR_Name__c = code + ' | ' + title;
        xSIR.Unique_name__c = xSIR.ouCode__c+ ' - ' + xSIR.SIR_Code__c;
        irNames.add(xSIR.IR_Id__c);
    }
    
    
    //System.Debug('Group Map:::'+groupMap);
    List<IR__c> irList = new List<IR__c>([Select  DO_Id__c, do_Code__c, do_Title__c, ir_Code__c, ir_Title__c  From IR__c Where id in :irNames]); 
    for(IR__c d : irList){
        irMap.put(d.Id,d);
    }    
    
    for(SUB_IR__c xSIR: trigger.new){
               
        if (irMap.containsKey((String)xSIR.IR_Id__c)){
            IR__c  xir = irMap.get((String)xSIR.IR_Id__c);       
           // xSIR.do_code__c = xIR.do_Code__c;
           // xSIR.do_title__c = xIR.do_title__c;

           // xSIR.ir_code__c = xIR.ir_Code__c;
           // xSIR.ir_title__c = xIR.ir_title__c;
        //  CDCSLINK__c cLink = new CDCSLINK__c(Do_Name__c = xdo.Id, IR_Name__c = xIR.Id, Link_Type__c = 'Primary IR' );
        //  cLinkList.add(cLink);   
                
        }
    }   
    
    //SUB_IR__c xSIR = trigger.new[0];
    //String code = xSIR.SIR_Code__c;
    //String title = xSIR.name;
    

    //SIR
  // if (xSIR.name.contains(' | '))
  //  {
  //      spos = xSIR.name.indexOf(' | ')+3;
  //      nlen = xSIR.name.length();
  //      title = xSIR.name.substring(spos, nlen);
  //      xSIR.SIR_title__c = title;
  //  }
  
   // xSIR.SIR_title__c = title;
   // xSIR.name = code + ' | ' + title;
    
    //DO & IR 
    
    //Queue Logic                                                                       
    Set<String> records = new Set<String> () ;                                                                      
    Set<String> QueueNames = new Set<String> () ;                                                                       
    Map<String,String> GroupIds = New Map<String,String> () ;                                                                       
    Map<String,String> MapQueueNames  = New Map<String,String> () ;                                                                     
                                                                            
    for (SUB_IR__c x : trigger.new)                                                                     
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
            for    (SUB_IR__c  x:  trigger.new )                                                                
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