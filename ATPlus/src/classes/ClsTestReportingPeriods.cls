@IsTest 
 public class ClsTestReportingPeriods { 
      
      Static ClsTestUtility testIndicatorUtil = new ClsTestUtility();     
     
     
 /** Test Method */      
     @IsTest public static void testClsReportingPeriodController() {
         // clsReportingPeriod CRP = new clsReportingPeriod();
          
          //createRecords(); 
          
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
          String rfGoadId =  testIndicatorUtil.getRFGoalForOrgId(OrgUnitId);
          testIndicatorUtil.updateRFGoalForOrgId(OrgUnitId);
          String rfDOId =  testIndicatorUtil.getRFDOForGoal(rfGoadId);
          String rfIRId =  testIndicatorUtil.getRFIRForDO(rfDOId);  
          
          List<RF_Reporting_Period__c> rfRPList;
          
          test.startTest();
          rfRPList = testIndicatorUtil.getRFReportingPeriods(rfGoadId,'Goal');  
          delete rfRPList;            
          rfRPList= testIndicatorUtil.getRFReportingPeriods(rfDOId,'Do');
          delete rfRPList;
          rfRPList= testIndicatorUtil.getRFReportingPeriods(rfIRId ,'IR');
          
          delete rfRPList;
          test.stopTest();
      
     }  
    
  
     /** Test Method */      
     @IsTest public static void testClsReportingPeriodController1() {      
          
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
          String rfGoadId =  testIndicatorUtil.getRFGoalForOrgId(OrgUnitId);          
          String rfDOId =  testIndicatorUtil.getRFDOForGoal(rfGoadId);
          String rfIRId =  testIndicatorUtil.getRFIRForDO(rfDOId);
          testIndicatorUtil.updateRFGoalForOrgId(OrgUnitId);
          String rfSubIRId =  testIndicatorUtil.getRFSubIRForIR(rfIRId); 
          
          List<RF_Reporting_Period__c> rfRPList;
          
          test.startTest();
          rfRPList = testIndicatorUtil.getRFReportingPeriods(rfSubIRId,'SIR');
          delete rfRPList;
          test.stopTest();      
          
      
     }
     
     /** Test Method */      
     @IsTest public static void testClsReportingPeriodController2() {
         // clsReportingPeriod CRP = new clsReportingPeriod();
        //  ClsTestUtility testIndicatorUtil = new ClsTestUtility();             
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
          String projectId = testIndicatorUtil.getProjectForOrgId(OrgUnitId);
          test.startTest();
          testIndicatorUtil.updateProjectForOrgId(OrgUnitId);          
          String lfGoalId = testIndicatorUtil.updateLFGoalForProjectId(projectId);
          String lfPurposeId = testIndicatorUtil.getLFPurposeForGoal(lfGoalId);
          String lfSubPurposeId = testIndicatorUtil.getLFSubPurpose(lfPurposeId);          
          
          test.stopTest();   
          
          List<LF_Reporting_Period__c> lfRPList;
          lfRPList = testIndicatorUtil.getLFReportingPeriods(lfGoalId,'Goal');
          delete lfRPList;
          lfRPList=testIndicatorUtil.getLFReportingPeriods(lfPurposeId,'Purpose');
          delete lfRPList;
          lfRPList=testIndicatorUtil.getLFReportingPeriods(lfSubPurposeId,'SubPurpose');
          
          delete lfRPList;
      
     }
     
     @IsTest public static void testClsReportingPeriodController3() {
        //  clsReportingPeriod CRP = new clsReportingPeriod();
        //  ClsTestUtility testIndicatorUtil = new ClsTestUtility(); 
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
          String projectId = testIndicatorUtil.getProjectForOrgId(OrgUnitId);          
          String lfGoalId = testIndicatorUtil.getLFGoalForProjectId(projectId);
          String lfPurposeId = testIndicatorUtil.getLFPurposeForGoal(lfGoalId);
          String lfSubPurposeId = testIndicatorUtil.getLFSubPurpose(lfPurposeId);
          Test.startTest();          
          testIndicatorUtil.updateProjectForOrgId(OrgUnitId);
          String lfOutputId = testIndicatorUtil.getLFOutputP(lfPurposeId);
          String lfOutputId1 = testIndicatorUtil.getLFOutput(lfSubPurposeId);
          //String lfInputId = testIndicatorUtil.getLFInput(lfOutputId);
          //String lfInputId1 = testIndicatorUtil.getLFInput(lfOutputId1);
          List<LF_Reporting_Period__c> lfRPList;
          lfRPList = testIndicatorUtil.getLFReportingPeriods(lfOutputId1,'Output');
          
          
          delete lfRPList;
          Test.stopTest();
          
      
     }
     
     @IsTest public static void testClsReportingPeriodController4() {
        //  clsReportingPeriod CRP = new clsReportingPeriod();
        //  ClsTestUtility testIndicatorUtil = new ClsTestUtility(); 
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
          String projectId = testIndicatorUtil.getProjectForOrgId(OrgUnitId);          
          String lfGoalId = testIndicatorUtil.getLFGoalForProjectId(projectId);
          String lfPurposeId = testIndicatorUtil.getLFPurposeForGoal(lfGoalId);
          String lfSubPurposeId = testIndicatorUtil.getLFSubPurpose(lfPurposeId);
          String lfOutputId = testIndicatorUtil.getLFOutputP(lfPurposeId);
          String lfOutputId1 = testIndicatorUtil.getLFOutput(lfSubPurposeId);
          Test.startTest();         
          testIndicatorUtil.updateProjectForOrgId(OrgUnitId);          
          String lfInputId = testIndicatorUtil.getLFInput(lfOutputId);
          String lfInputId1 = testIndicatorUtil.getLFInput(lfOutputId1);
          
          List<LF_Reporting_Period__c> lfRPList;
          lfRPList = testIndicatorUtil.getLFReportingPeriods(lfInputId,'Output');
          
          
          delete lfRPList;
          Test.stopTest();         
      
     }
     
     @IsTest public static void testClsReportingPeriodController5() {
          clsReportingPeriod CRP = new clsReportingPeriod();
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
          String imId = testIndicatorUtil.getIMForOrgId(OrgUnitId);
          Test.startTest();         
          testIndicatorUtil.updateIMForOrgId(OrgUnitId,'Quarterly','Implementing Mechanism');
          testIndicatorUtil.updateIMForOrgId(OrgUnitId,'Annual','Implementing Mechanism');
            
          //CRP.createRepPeriod(imId);        
         // String taskId = testIndicatorUtil.getLFInput(lfOutputId);
         // String lfInputId1 = testIndicatorUtil.getLFInput(lfOutputId1);
          Test.stopTest();         
      
     }
     
     @IsTest public static void testClsReportingPeriodController6() {
          clsReportingPeriod CRP = new clsReportingPeriod();
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
          String projectId = testIndicatorUtil.getProjectForOrgId(OrgUnitId);
          String imId = testIndicatorUtil.getIMForOrgId(OrgUnitId);
          Test.startTest();         
          testIndicatorUtil.updateIMForOrgId(OrgUnitId,'Semi-Annual','Task');
          String taskId = testIndicatorUtil.getTask(imId,projectId);
            
          //CRP.createRepPeriod(imId);        
         // String taskId = testIndicatorUtil.getLFInput(lfOutputId);
         // String lfInputId1 = testIndicatorUtil.getLFInput(lfOutputId1);
          Test.stopTest();         
      
     }
     
     @IsTest public static void testClsReportingPeriodCORReminders() {
         // ClsTestUtility testIndicatorUtil = new ClsTestUtility();  
          
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());          
          String imId = testIndicatorUtil.getIMForOrgId(OrgUnitId);
          testIndicatorUtil.updateIMForOrgId(OrgUnitId,'Quarterly','Implementing Mechanism');
          List<Reporting_Period__c> rpList =  testIndicatorUtil.getReportingPeriods(imId);
         // String etId = testIndicatorUtil.getEmailTemplateId('ReportingPeriodPublishReminder');       
          
          ClsReportingPeriodCORReminders CRP = new ClsReportingPeriodCORReminders();
          ID batchprocessid2 = Database.executeBatch(CRP,200);
      
     } 
     
      
     
 }