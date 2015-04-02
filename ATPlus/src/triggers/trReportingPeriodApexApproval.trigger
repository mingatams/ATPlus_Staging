trigger trReportingPeriodApexApproval on Reporting_Period__c ( after insert, after update) {
    clsGlobalUtility GU = new clsGlobalUtility();
    
    Set<Id> imIds = new Set<Id>();
    Map<Id,List<User>> approvers = new Map<Id,List<User>>();     
    Map<Id,List<User>> partners = new Map<Id,List<User>>(); 
    
    
    
    List<String> NextApproverIds = new  List<String> () ;  
   // List<String> PartnerUserIds = new  List<String> () ; 
    List<String> ApproverEmailIds = new  List<String> () ;
    List<String> PartnerEmailIds = new  List<String> () ;
    //map<id,list<Id>> mapAORCORIds = new map<id,list<Id>>();
    //map<id,list<Id>> mapPartnerIds = new map<id,list<Id>>();
    //set<id>Ids = new set<Id>();
    //String EmailBody  = '';
    //string strRpId;
    //boolean baselineTarget = true;
    
    
         
    
    Map<String, EmailTemplate> templatesMap = new Map<String,EmailTemplate>();
    
   // Map<String, EmailTemplate> templatesMap = new Map<String,EmailTemplate>([Select Name, Id From EmailTemplate]);
    system.debug('Templates Map::::'+templatesMap );
    if (!ApplicationConstants.bypassReportingPeriodApprovalLogic){
    
        Id rtId = [select Id,name from RecordType where SObjectType='Implementing_Mechanism__c' and name='Advanced' limit 1].id;
       // profile p = [select id,name from profile where name='System Administrator(c)' limit 1];    
        User adminUser = new User();
        adminUser = [select id,email from user where profile.Name = 'System Administrator(c)'  and name = 'User Batch' limit 1];
        List<EmailTemplate> templateList = new List<EmailTemplate>([Select Name, Id From EmailTemplate]);
        for(EmailTemplate t: templateList ){
        templatesMap.put(t.Name,t);
    }
        
        
        for(Reporting_Period__c rp: Trigger.new){
            imIds.add(rp.Implementing_Mechanism_Id__c);    
        }
        
        Map<Id,Implementing_Mechanism__c> MapIMRecId;
        if (!imIds.isEmpty()){
            MapIMRecId = new map<Id,Implementing_Mechanism__c>([select id ,name,RecordtypeId,Status__c from Implementing_Mechanism__c where Id in :imIds]);
            approvers = getIMTaskApproverRecs(imIds);
            partners =  getIMPartnerUserRecs(imIds);
            
            for ( Reporting_Period__c rp: Trigger.new ) {
                Reporting_Period__c rpOld;
                if(Trigger.isUpdate){
                    rpOld = System.Trigger.oldMap.get(rp.Id);  
                } else {
                    rpOld =rp;
                }         
                
                
                
                /* Following logic is to set template and notify corresponding users on Reportinf Period Submission */
                If(rp.status__c == 'Submitted'){
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for approval.');
                    req1.setObjectId(rp.id);
                    system.debug('Approvers:::' +approvers);
                    if (approvers.containsKey(rp.Implementing_Mechanism_Id__c)){
                        for(User u: approvers.get(rp.Implementing_Mechanism_Id__c)){
                           system.debug('Approvers User:::' +u); 
                           ApproverEmailIds.add(u.Email); 
                         //  NextApproverIds.add(u.Id);
                        }
                        NextApproverIds.add(rp.ownerId);
                       req1.setNextApproverIds(NextApproverIds);                                              
                    }        
                    
                    System.debug('Next Approver Ids::::' +NextApproverIds);     
                    System.debug('Reporting Period before Submit approval process:::' +rp); 
                    
                    System.debug('Approval Process Request1 :::::' +req1);
                  //  System.debug('Next Approver Ids From Request::::' +req1.getNextApproverIds());
                    Approval.ProcessResult result = Approval.process(req1); 
                    System.assert(result.isSuccess());   
                    
                    EmailTemplate template = new EmailTemplate();
                    if(templatesMap.containsKey('Partner Submitted Email Template')){
                        template = templatesMap.get('Partner Submitted Email Template');
                    }
                    
                    if (template != null && !ApproverEmailIds.isEmpty()){                    
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setToAddresses(ApproverEmailIds); 
                        System.debug('Submitted Template Id::::' +template.Id);
                        System.debug('Submitted Template::::' +template);
                        mail.setTemplateId(template.Id); 
                        mail.setTargetObjectId(adminUser.id);
                        mail.setSaveAsActivity(false);   
                        mail.setWhatId(rp.Id);
                        try{                
                           Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                           System.debug('Request Submit Email Sent to Approvers ***'+mail); 
                        }catch(EmailException e) {                
                           System.debug(e.getMessage()); 
                        }                     
                    }
                }
                
                
                If (rp.Status__c =='open' && rpOld.Status__c =='Submitted') {            
                    System.Debug('Inside Rejected***** ');
                    if (partners.containsKey(rp.Implementing_Mechanism_Id__c)){
                        for(User u: partners.get(rp.Implementing_Mechanism_Id__c)){
                           PartnerEmailIds.add(u.Email);                       
                        }                   
                    }
                    
                    EmailTemplate template = new EmailTemplate();
                    if(templatesMap.containsKey('Partner Reject Email Template')){
                        template = templatesMap.get('Partner Reject Email Template');
                    }
                     
                    if (template != null && !PartnerEmailIds.isEmpty()){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setToAddresses(PartnerEmailIds);
                        mail.setTemplateId(template.Id); 
                        mail.setTargetObjectId(adminUser.id);  
                        mail.setSaveAsActivity(false);  
                        mail.setWhatId(rp.Id);   
                        System.debug(' Rejected Sent to Partners Failed***'+mail); 
                        try {                
                          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                          System.debug(' Rejected Sent to Partners ***'+mail); 
                        } catch(EmailException e) {                
                            System.debug(e.getMessage()); 
                        }
                    }
                }
                /**  Status Rejected action End */
                
                /**  For Status Open and Extend action */  
                If (rp.Status__c == 'Open' && rpOld.Status__c != 'Submitted' && (rp.Status__c != rpOld.Status__c || rp.Close_Date__c != rpOld.Close_Date__c) &&   rp.Actuals_Recorded__c == false ) {                 
                    System.Debug('Inside Open***** ');
                    if (partners.containsKey(rp.Implementing_Mechanism_Id__c)){
                        for(User u: partners.get(rp.Implementing_Mechanism_Id__c)){
                           PartnerEmailIds.add(u.Email);                       
                        }                   
                    }
                    
                    String openExtendTemplate = 'Partner Email Template1';
                     if(rp.Close_Date__c != rpOld.Close_Date__c){
                       openExtendTemplate = 'Partner Extended Email  Template'; //Due date Extended Template
                     }
                    
                    EmailTemplate template = new EmailTemplate();
                    if(templatesMap.containsKey(openExtendTemplate)){
                        template = templatesMap.get(openExtendTemplate);
                    } 
                    
                    if (template != null && !PartnerEmailIds.isEmpty()){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                         mail.setToAddresses(PartnerEmailIds);
                         // mail.setToAddresses(email);
                         mail.setTemplateId(template.Id); 
                         mail.setTargetObjectId(adminUser.id);  
                         mail.setSaveAsActivity(false);  
                         mail.setWhatId(rp.Id);                
                         try {                
                             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                             System.debug(' Open and Extend  Email Sent to Partners ***'+mail); 
                         }catch(EmailException e) {                
                            System.debug(e.getMessage()); 
                         }
                    }
                } 
                /**  Status Open and Extend action End */
                
                
                
                /** For Status Approved or Rejected  && ! NextApproverIds.isEmpty()*/  
                If (rp.Status__c == 'Approved' ) {                 
                    System.Debug('Inside Approved***** ');
                     if (partners.containsKey(rp.Implementing_Mechanism_Id__c)){
                        for(User u: partners.get(rp.Implementing_Mechanism_Id__c)){
                           PartnerEmailIds.add(u.Email);                       
                        }                   
                    }               
                    
                    EmailTemplate template = new EmailTemplate();
                    if(templatesMap.containsKey('Partner Email Template1')){
                        template = templatesMap.get('Partner Email Template1');
                    }     
                                    
                    if (template != null && !PartnerEmailIds.isEmpty()){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();                     
                        mail.setToAddresses(PartnerEmailIds);  
                        //mail.setToAddresses(email);              
                        mail.setTemplateId(template.Id); 
                        mail.settargetObjectId(adminUser.id);  
                        mail.setSaveAsActivity(false);
                        mail.setWhatId(rp.Id);              
                        try {                
                          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                          System.debug('Approved or Rejected Email Sent to Partners ***'+mail); 
                        }catch(EmailException e) {                
                            System.debug(e.getMessage()); 
                            System.debug('Approved or Rejected Email Sent to Partners Failed ***'+mail); 
                        }                
                    }
                } 
                /**  Status Approved or Rejected End */
            }
        }        
    }    
    private Map<Id,List<User>> getIMTaskApproverRecs(Set<Id> recIds){
        if (recIds.isEmpty() == null) return null;
        String whereStr = ' Where Id IN ' + GU.prepareINclause(recIDs);        
        List<String> approverUserIds = new List<String>();
        List<SObject> sObjList = GU.lookupWithFilter(whereStr,'Implementing_Mechanism__c');
        Map<ID,List<User>> imUsersMap = new Map<ID,List<User>>();
        Set<Id> allUserIds = new Set<Id>();
        //List<String> allUserIds = new List<String>();
        for(SObject sObj:sObjList){
           // List<String> tempList = new List<String>();
            Implementing_Mechanism__c im = (Implementing_Mechanism__c) sObj;
            
            if (im.COR__c != null){
                allUserIds.add(im.COR__c);                                 
            }
            
            if (im.AOR__c != null ){
                allUserIds.add(im.AOR__c);                                 
            }           
            
            
            if (im.Alternate_AOR__c != null){
                allUserIds.add(im.Alternate_AOR__c);                                  
            }
            
            if (im.Alternate_COR__c != null){
                allUserIds.add(im.Alternate_COR__c);
            }
            //imUsersMap.put(im.Id,tempList); 
        } 
        System.debug('All User Ids::' +allUserIds);
        Map<Id,User> userMap = new Map<Id,User>([Select Id, Name, Email From User where ID IN :allUserIds and isActive = true]);        
       
       // String userQuery = 'Select Id, Name, Email From User where ID IN '+prepareINclause(allUserIds);
       //  System.debug('User Query String::' +userQuery);
      //  for(User u: Database.query(userQuery)){
      //      userMap.put(u.Id,u);
      //  }
        System.debug('Users Map::' +userMap);
        for(SObject sObj:sObjList){
            List<User> tempList = new List<USer>();
            Implementing_Mechanism__c im = (Implementing_Mechanism__c) sObj;
            Boolean userSelected = false;
          //  if (im.COR__c != null && !userSelected && userMap.containsKey(im.COR__c)){
            if (im.COR__c != null && userMap.containsKey(im.COR__c)){
                tempList.add(userMap.get(im.COR__c));   
              //  userSelected = true;              
            }
            
         //   if (im.AOR__c != null && !userSelected && userMap.containsKey(im.AOR__c)){
            if (im.AOR__c != null && userMap.containsKey(im.AOR__c)){
                tempList.add(userMap.get(im.AOR__c)); 
            //    userSelected = true;                
            }            
            
            
         //   if (im.Alternate_AOR__c != null && !userSelected && userMap.containsKey(im.Alternate_AOR__c)){
            if (im.Alternate_AOR__c != null && userMap.containsKey(im.Alternate_AOR__c)){
                tempList.add(userMap.get(im.Alternate_AOR__c));  
           //     userSelected = true;                 
            }
            
          //  if (im.Alternate_COR__c != null && !userSelected && userMap.containsKey(im.Alternate_COR__c)){
            if (im.Alternate_COR__c != null && userMap.containsKey(im.Alternate_COR__c)){
                tempList.add(userMap.get(im.Alternate_COR__c));
              //  userSelected = true;                   
            }
            System.debug('Temp List of Users::' +tempList);
            imUsersMap.put(im.Id,tempList); 
        }
        
        System.debug('IM User Map Before Return::' +imUsersMap);      
        return imUsersMap;  
   }
  
   private Map<ID,List<User>> getIMPartnerUserRecs(Set<Id> recIds){
        if (recIds.isEmpty() == null) return null;
        String whereStr = ' Where Id IN ' +GU.prepareINclause(recIDs);        
        List<String> approverUserIds = new List<String>();
        List<SObject> sObjList = GU.lookupWithFilter(whereStr,'Implementing_Mechanism__c');
        Map<ID,List<User>> imUsersMap = new Map<ID,List<User>>();
        Set<Id> allUserIds = new Set<Id>();
       
        
        for(SObject sObj:sObjList){            
            Implementing_Mechanism__c im = (Implementing_Mechanism__c) sObj;
            if (im.Partner_User_1__c != null){
                allUserIds.add(im.Partner_User_1__c);
                                                
            }
             if (im.Partner_User_2__c != null){
                allUserIds.add(im.Partner_User_2__c);                 
            }
             if (im.Partner_User_3__c != null){
                allUserIds.add(im.Partner_User_3__c);                 
            }
             if (im.Partner_User_4__c != null){
                allUserIds.add(im.Partner_User_4__c);                 
            }
            //allUserIds.addAll(tempList);
           // imUsersMap.put(im.Id,tempList); 
        } 
        
        Map<Id,User> userMap = new Map<Id,User>([Select Id, Name, Email From User where ID in: allUserIds]);
        
        for(SObject sObj:sObjList){
            List<User> tempList = new List<User>();
            Implementing_Mechanism__c im = (Implementing_Mechanism__c) sObj;
            if (im.Partner_User_1__c != null){
                tempList.add(userMap.get(im.Partner_User_1__c));                                
            }
             if (im.Partner_User_2__c != null){
                tempList.add(userMap.get(im.Partner_User_2__c));                 
            }
             if (im.Partner_User_3__c != null){
                tempList.add(userMap.get(im.Partner_User_3__c));                 
            }
             if (im.Partner_User_4__c != null){
                tempList.add(userMap.get(im.Partner_User_4__c));                 
            }
            imUsersMap.put(im.Id,tempList);
        }
         
        return imUsersMap;
        
   }
 
  }