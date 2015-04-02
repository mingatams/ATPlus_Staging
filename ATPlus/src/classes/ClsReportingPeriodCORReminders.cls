global class ClsReportingPeriodCORReminders implements Database.Batchable<Sobject>{
    
    global final String Query;  
    global final String draft_Status='Draft'; 
    global final Date todayPlus15Days;
    clsGlobalUtility GU = new clsGlobalUtility();
    Map<Id,List<User>> imPartnerIdsMap = new Map<Id,List<USer>>(); 
    List<Reporting_period__c> lstRecsToUpdate = new list<Reporting_period__c>();
    List<String> PartnerUserIds = new  List<String> () ; 
    List<String> PartnerEmailIds = new  List<String> () ;
    map<id,List<id>> mapIds = new map<id,list<id>>();
    set<id>  Ids = new set<Id>();
    String EmailBody  = '';
    
    boolean sendMail =false;
    String RPName;
    String IMName;    
    String ImMechName;
    Date Date_30;
    Date Date_15;
    Date Date_5;
    Date Date_1;
    Date Date_0;
    Integer daysBeforeDue;      
    
    global ClsReportingPeriodCORReminders(){      
     
     todayPlus15Days = Date.today().addDays(14);
     
     
     Query = 'select id ,name,start_Date__c,end_date__c,status__c,Implementing_Mechanism_Id__c,Fiscal_Year__c,Fiscal_Period__c, ' 
             +' Close_Date__c from reporting_period__c where status__c =:draft_Status and start_date__c <=  :todayPlus15Days' ;
       System.debug(' Query==> '+ Query);  
    }  
   
    global Database.QueryLocator start(Database.BatchableContext BC) {  
        return Database.getQueryLocator(query);  
    }  
  
    global void execute(Database.BatchableContext BC, List<SObject> scope) {    
         
        
        set<Id> allUserIds = new Set<Id>();
        Map<Id,List<User>> imUserMap = new Map<Id,List<User>>();
        Map<String,EmailTemplate> templateMap = new Map<String,EmailTemplate>([Select Name, id from EmailTemplate]);
        profile p = [select id,name from profile where name='System Administrator(c)' limit 1];
        user adminUser = [select id,email from user where profileId=:p.id limit 1]; 
        for(Sobject so: scope){
            Reporting_Period__c rp = (Reporting_Period__c)so;
            ids.add(rp.Implementing_Mechanism_Id__c);               
        }   
        
        imPartnerIdsMap = GU.getIMTaskApproverRecs(Ids);
    
        Map<Id,Implementing_Mechanism__c> MapIMRecId = new map<Id,Implementing_Mechanism__c>();
        
        if (!ids.isEmpty()){
            MapIMRecId = new map<Id,Implementing_Mechanism__c>([select id ,name,RecordtypeId, Partner_User_1__c, Partner_User_2__c, Partner_User_3__c, Partner_User_4__c from Implementing_Mechanism__c where Id in : Ids]);
        }    
        
        if(!imPartnerIdsMap.isEmpty()){
            for(Sobject so: scope){
                Reporting_Period__c rp = (Reporting_Period__c)so;
              //  Implementing_Mechanism__c im = MapIMRecId.get(rp.Implementing_Mechanism_Id__c);
                List<String> emailIds = new List<String>();
                for(User u: imPartnerIdsMap.get(rp.Implementing_Mechanism_Id__c)){
                    emailIds.add(u.email);
                }         
                    
                
                EmailTemplate template = templateMap.get('ReportingPeriodPublishReminder');
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();                
                mail.setToAddresses(emailIds);
                mail.setSenderDisplayName('AidTracker Help'); 
                if (template != null)
                    mail.setTemplateId(template.Id);   
                mail.setSaveAsActivity(false);  
                mail.setBccSender(false);
                mail.setUseSignature(false);
                mail.setWhatId(rp.Id); 
                mail.setTargetObjectId(adminUser.id);  
                mail.setSaveAsActivity(false);
               // mail.setSubject('AIDtracker IP Deadline is Approaching:  '+RPName );    
               // mail.setplaintextBody(Message);    
                try {   
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                } catch (EmailException e) {
                    System.debug(e.getMessage());
                }
                
            }           
            
        }   
        
        
       
  }  //End Execute
  
    global void finish(Database.BatchableContext BC) {  
   
    }  
    
   
   

}