global class clsReportingPeriodStatusBatch implements Database.Batchable<Sobject>  {  
    global final String Query;  
    global final String Publish='Publish'; 
    global final Date todayPlusmonth;
    clsGlobalUtility GU = new clsGlobalUtility();
    List<Reporting_period__c> lstRecsToUpdate = new list<Reporting_period__c>();
    List<String> PartnerUserIds = new  List<String> () ; 
    List<String> PartnerEmailIds = new  List<String> () ;
    map<id,List<id>> mapIds = new map<id,list<id>>();
    set<id>  Ids = new set<Id>();
    String EmailBody  = '';
     string status ;
    global clsReportingPeriodStatusBatch(){
     if (Date.today().month() == 1 || Date.today().month() == 3 || Date.today().month() == 5 || Date.today().month() == 7 || Date.today().month() == 8 || Date.today().month() == 10 || Date.today().month() == 12){
        todayPlusmonth = Date.today().addDays(31);
     } else if (Date.today().month() == 4 || Date.today().month() == 6 || Date.today().month() == 9 ||Date.today().month() == 11){
        todayPlusmonth = Date.today().addDays(30);
     }  else if(Date.isLeapYear(Date.today().year())){
        todayPlusmonth = Date.today().addDays(29);
     } else {
        todayPlusmonth = Date.today().addDays(28);
     }
              
       
     Query = 'select id ,name,start_Date__c,end_date__c,status__c,Implementing_Mechanism_Id__c, '
             +' Fiscal_Year__c,Fiscal_Period__c from reporting_period__c where status__c =:Publish and End_Date__c = :todayPlusmonth' ;
       System.debug(' Query==> '+ Query);  
    }  
  
    global Database.QueryLocator start(Database.BatchableContext BC) {  
        return Database.getQueryLocator(query);  
    }  
  
    global void execute(Database.BatchableContext BC, List<SObject> scope) {  
         
       // List<Reporting_period__c> lstRPRecs = new list<Reporting_period__c>( [select id ,name,start_Date__c,end_date__c,status__c,Implementing_Mechanism_Id__c,Fiscal_Year__c,Fiscal_Period__c from Reporting_period__c where status__c =:'Publish']);  
        //System.debug(' lstRPRecs ==> '+ lstRPRecs );    
                
            for(SObject so : scope){
                Reporting_Period__c rp = (Reporting_Period__c)so;               
                ids.add(rp.Implementing_Mechanism_Id__c);
                        
                Date startDate = date.valueOf(rp.start_Date__c);            
                Date endDate = date.valueOf(rp.end_date__c);  
                date today=date.valueOf(system.today() );
                
                system.debug('startDate  '+startDate);
                system.debug('endDate '+endDate );
                system.debug('today '+today);
                
               // If (today > startdate && today < enddate ){
                
                rp.status__c = 'Open';
                status = rp.status__c ;
                lstRecsToUpdate.add(rp);
                system.debug('lstRecsToUpdate '+lstRecsToUpdate);
            }
               
       /*     Map<Id,Implementing_Mechanism__c> MapIMRecId = new map<Id,Implementing_Mechanism__c>([select id ,name,RecordtypeId from Implementing_Mechanism__c where Id in :Ids]);           
            mapIds= GU.getIMPartnerUsers(Ids);    
                 
             for(Id i : Ids){
             PartnerUserIds = mapIds.get(i);
             } */      
           // }
        
        Update lstRecsToUpdate;
        /*
        If(!PartnerUserIds.isEmpty()){   
          for ( User u: [Select Email from user where id IN: PartnerUserIds ] ) {
                PartnerEmailIds.add(u.Email); 
                 system.debug('PartnerEmailIds==>'+PartnerEmailIds);
            }
         } 
       
       
     If(!PartnerEmailIds.isEmpty() ){
       If(status =='Open'){
        for(Reporting_period__c rp : lstRecsToUpdate){
         
         Map<Id,Implementing_Mechanism__c> MapIMRecId = new map<Id,Implementing_Mechanism__c>([select id ,name,RecordtypeId from Implementing_Mechanism__c where Id=:rp.Implementing_Mechanism_Id__c]);           
          String StartDt = rp.start_Date__c.Day() +'/'+ rp.start_Date__c.Month() +'/'+ rp.start_Date__c.Year() ;
          String EndDt = rp.End_Date__c.Day() +'/'+ rp.End_Date__c.Month() +'/'+ rp.End_Date__c.Year() ;
         
          EmailBody  = 'Dear Partner, <br/> The '+rp.Fiscal_Year__c+' '+rp.Fiscal_Period__c+' reporting period is now in Open Status. Please enter Actuals for the corresponding Indicators. <br/> <br/> IM Name: ' + MapIMRecId.get(rp.Implementing_Mechanism_Id__c).name  +'<br/>' ; 
          EmailBody  += '<br/> Please click on the following link to enter indicator results for the reporting period:<br/> <a href=https://cs10.salesforce.com/'+rp.Id+'>Click here</a>' ;
          EmailBody  += ' <br/><br/> Thank You, <br/> AIDtracker Customer Support Team. ';
         }
          system.debug('Sending email to PartnerEmailIds =='+PartnerEmailIds);          
                
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();      
       // string[] email = new string[]{'rbabu@credence-llc.com'};
        mail.setToAddresses(PartnerEmailIds);   
        mail.setSenderDisplayName('Salesforce Support');    
        mail.setSaveAsActivity(false);  
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setSubject('New Reporting Period is in Open Status ');    
       mail.setHtmlBody(EmailBody);    
       
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
      }//End If
    }   //End If
    */
       
  }  //End Execute
  
    global void finish(Database.BatchableContext BC) {  
   
    }  
    
    @IsTest public static void testclsReportingPeriodStatusBatch() {
          ClsTestUtility testIndicatorUtil = new ClsTestUtility();  
          
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());          
          String imId = testIndicatorUtil.getIMForOrgId(OrgUnitId);
          testIndicatorUtil.updateIMForOrgId(OrgUnitId,'Quarterly','Implementing Mechanism');
          List<Reporting_Period__c> rpList =  testIndicatorUtil.getReportingPeriods(imId);
         // String etId = testIndicatorUtil.getEmailTemplateId('ReportingPeriodPublishReminder');  
         
       //   String masterInd = testIndicatorUtil.getCustomIndicatorForOrgId(OrgUnitId);
       //   OrgUnit_Indicator__c childInd = testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,imId,'IM');        
          
          
          Test.startTest();
          
        //  List<Indicator_Results__c> irList = testIndicatorUtil.getIndicatorResultByIM(rpList,masterInd,childInd.Id,imId);
          ApplicationConstants.bypassReportingPeriodApprovalLogic = true;       
          List<Reporting_Period__c> rpList1 =  testIndicatorUtil.getReportingPeriods(imId,rpList,'Publish');
          
          clsReportingPeriodStatusBatch CRP = new clsReportingPeriodStatusBatch();
          ID batchprocessid2 = Database.executeBatch(CRP,200);
          Test.stopTest();
     } 
    
}