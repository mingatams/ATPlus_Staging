global class ClsReportingPeriodPartnerReminders implements Database.Batchable<Sobject> {
    global final String Query;  
    global final String open_Status='Open'; 
    global final Date todayPlus45Days;
    global final Date weekPlus45Days;
    
    global final Date todayPlus30Days;
    global final Date weekPlus30Days;
    
    global final Date todayPlus15Days;
    global final Date weekPlus15Days;
    
    global final Date todayPlus7Days;
    global final Date weekPlus7Days;
    
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
    
    global ClsReportingPeriodPartnerReminders(){      
     todayPlus45Days = Date.today().addDays(45);
     weekPlus45Days = Date.today().addDays(52);
     
     todayPlus30Days = Date.today().addDays(30);
     weekPlus30Days = Date.today().addDays(37);
     
         
     todayPlus15Days = Date.today().addDays(15);
     weekPlus15Days = Date.today().addDays(22);
     
     todayPlus7Days = Date.today().addDays(7);
     weekPlus7Days = Date.today().addDays(15);
     
     Query = 'select id ,name,start_Date__c,end_date__c,status__c,Implementing_Mechanism_Id__c,Fiscal_Year__c,Fiscal_Period__c, ' 
             +' Close_Date__c from Reporting_Period__c where Status__c =:open_Status and '
             +' ((Close_Date__c  >=  :todayPlus45Days and Close_Date__c  <=  :weekPlus45Days)' 
             +' OR (Close_Date__c  >=  :todayPlus30Days and Close_Date__c  <=  :weekPlus30Days)'
             +' OR (Close_Date__c  >=  :todayPlus15Days and Close_Date__c  <=  :weekPlus15Days)'
             +' OR (Close_Date__c  >=  :todayPlus7Days and Close_Date__c  <=  :weekPlus7Days))';
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
        
        imPartnerIdsMap = GU.getIMPartnerUserRecs(Ids);
    
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
                    
                
                EmailTemplate template = templateMap.get('ReportingPeriodSubmitReminder');
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
    
    @IsTest public static void testClsReportingPeriodPartnerReminders() {
          ClsTestUtility testIndicatorUtil = new ClsTestUtility();  
          
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());          
          String imId = testIndicatorUtil.getIMForOrgId(OrgUnitId);
          testIndicatorUtil.updateIMForOrgId(OrgUnitId,'Quarterly','Implementing Mechanism');
          List<Reporting_Period__c> rpList =  testIndicatorUtil.getReportingPeriods(imId);
         // String etId = testIndicatorUtil.getEmailTemplateId('ReportingPeriodPublishReminder');  
         
          List<OrgUnit_Indicator__c> masterInd = testIndicatorUtil.getCustomIndicatorRecordsForOrgId(OrgUnitId);
          List<OrgUnit_Indicator__c> childInd = testIndicatorUtil.getCustomIndicatorsForType(OrgUnitId,imId,'IM',masterInd);
                 
          
          List<Indicator_Results__c> irList;
          List<Reporting_Period__c> rpList1;
          Test.startTest();
          
          irList = testIndicatorUtil.getIndicatorResultByIM(rpList,childInd,imId);
          ApplicationConstants.bypassReportingPeriodApprovalLogic = true;                
          rpList1 =  testIndicatorUtil.getReportingPeriods(imId,rpList,'Open');
          
          ClsReportingPeriodPartnerReminders CRP = new ClsReportingPeriodPartnerReminders();
          ID batchprocessid2 = Database.executeBatch(CRP,200);  
          
          
          Test.stopTest();         
          
          
     } 
    
}