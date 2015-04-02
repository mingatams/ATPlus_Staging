@IsTest
public with sharing class ClsTestManageIndReportingTargets  {
 
 @IsTest  public static void  testManageIndTargetsIMR(){
 clsGlobalUtility GU = new clsGlobalUtility();
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());             
        Implementing_Mechanism__c IMId= testIndicatorUtil.getIMRecordForOrgId(OrgUnitId);
        System.debug('IMID ***' +orgUnitId +' ** '+ IMId);
       
      IMId.start_Date__c = date.newinstance(2010, 2, 17);
      IMId.End_Date__c = date.newinstance(2014, 6, 10);
      IMId.Reporting_Level__c='Implementing Mechanism';
      String IMRecordTypeId = GU.getRecordTypeId('Implementing_Mechanism__c', 'Advanced');   
      IMId.RecordTypeid =IMRecordTypeId;     
       upsert IMId;
 
        testIndicatorUtil.updateIMForOrgId(orgUnitId,'Implementing Mechanism','');        
         System.debug('IMID ***'+ IMId.Id);        
         
     
         List<Reporting_Period__c>  rpList = new List<Reporting_Period__c>([Select Id,Name, Frequency__c,Reporting_Level__c,Implementing_Mechanism_Id__c,recordTypeId,Status__c, Start_Date__c, End_Date__c, Close_Date__c From Reporting_Period__c Where Implementing_Mechanism_Id__c = :IMId.Id limit 2]);
          upsert rpList;    
  
   
       system.debug('Reporting Period From test method:::'+rpList.size() );
     
      List<OrgUnit_Indicator__c> orgUnitIndicatorMaster=   testIndicatorUtil.getIndicatorsForOrgId(OrgUnitId,testIndicatorUtil.getUSAIDIndicatorRecords());

     
     List<OrgUnit_Indicator__c> orgUnitIndicator = new List<OrgUnit_Indicator__c>();
     
     String  recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'Implementing Mechanism');
    Integer orgCount = 0;
       for(OrgUnit_Indicator__c orgList: orgUnitIndicatorMaster){

if(orgCount <=1){
         orgUnitIndicator .add(new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgUnitId, source__c=orgList.source__c,indcode__c=orgList.indCode__c,indName__c= orgList.indName__c,Implementing_Mechanism_Id__c =IMId.Id,sindcode__c= orgList.sindCode__c,sindName__c= orgList.sindName__c,Organization_Indicator_Id__c=orgList.Id,Collection_Frequency__c='Quarterly'));            
     }
     orgCount =orgCount +1;
     
       }
       
       System.Debug('OrgUnit Size **** ' +orgUnitIndicator.size());
    upsert orgUnitIndicator;
      
  
          List<Indicator_Results__c> irList  = new List<Indicator_Results__c>();
   String recType1 =   GU.getRecordTypeId('Indicator_Results__c', 'Implementing Mechanism');
   Integer count =0;
   for (Reporting_Period__c rp: rpList){ 
   if(count ==0){
       for (OrgUnit_Indicator__c ci: orgUnitIndicator){
      
           irList.add(new Indicator_Results__c(RecordTypeId=recType1,Reporting_Period_Id__c=rp.Id,Organization_Indicator_Master_Id__c=ci.Organization_Indicator_Id__c,Organization_Indicator_Id__c= ci.Id,Implementing_MEchanism_Id__c= IMId.Id, Baseline__c=100.00,target__c=200.00,Actual__c=300.00));
           
           }
            count=count+1;
           }
       }        
 
     
    insert irList;
     System.Debug('getIndicatorResultByIM*** ' + irList);
            
         
        String IndicatorId;
         String subIndicatorId;
      
      
        System.Test.startTest();
        System.Test.setCurrentPage(new PAgereference('/apex/vfIMIndicatorReportingDetails'));
        ApexPages.currentPage().getParameters().put('id',IMId.Id); 
        Reporting_Period__c test = new Reporting_Period__c();
      ClsManageIndicatorReportingTargets controllerr = new  ClsManageIndicatorReportingTargets(test);
      ApexPages.StandardController sc = new ApexPages.standardController(test );
      ClsManageIndicatorReportingTargets controllers = new  ClsManageIndicatorReportingTargets(sc);
      
        ClsManageIndicatorReportingTargets controller = new  ClsManageIndicatorReportingTargets();
         controller.selectedYear='2012';
        
        controller.getPeriods();      
        controller.getTasksForIM();
        controller.prepResultsTree();
        controller.prepResultsTreeChange();
       
         controller.saveXMLString='{"reporIndId":"a0gJ0000002gijZIAQ_a11J0000000N1fwIAC_1.1.1-1","reportingPeriod":"2008-Q1","status":"Draft","baseline":"22.00","target":"33.00","actuals":"","difference":"","rating":"","partnerNotes":"","missionNotes":"","indCode":"1.1.1-1","subIndCode":"","indResultId":"","unitOfMeasures":"","Indicator":"","undefined":"1.1.1-1 Number of students trained on counterterrorism finance by USG programs"}-,{"reporIndId":"a0gJ0000002gijaIAA_a11J0000000N1fwIAC_1.1.1-1","reportingPeriod":"2008-Q2","status":"Draft","baseline":"22.00","target":"33.00","actuals":"","difference":"","rating":"","partnerNotes":"","missionNotes":"","indCode":"1.1.1-1","subIndCode":"","indResultId":"","unitOfMeasures":"","Indicator":"","undefined":"1.1.1-1 Number of students trained on counterterrorism finance by USG programs"}';
       
        controller.doSaveTargets();
         controller.doSavePublishTargets();
    
        controller.cancel();
        controller.cancelGo();
        controller.CancelNGo();
        controller.cancelSave();
         controller.selectedYear=null;
        controller.prepResultsTreeChange();
        controller.prepResultsTree();
        System.Test.stopTest();   
        
     
        
        
    }  
    }