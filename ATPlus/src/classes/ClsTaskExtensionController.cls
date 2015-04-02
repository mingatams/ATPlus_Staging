/** Extension Controller used to set default value for  IM Number while creating Task*/
public class ClsTaskExtensionController {
  public ClsTaskExtensionController (ApexPages.StandardController controller) {
    Activity__c task=(Activity__c)controller.getRecord();  
  // task.Implementing_Mechanism__c =ApexPages.currentPage().getParameters().get('id');
  
  } 
  
   /** Test Method */      
 @IsTest(SeeAllData=true) public static void testTaskExtensionController() {
   ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        Test.StartTest();              
        String imId=testIndicatorUtil.getIMForOrgId(OrgUnitId);
        String projId=testIndicatorUtil.getProjectForOrgId(OrgUnitId);
        String actvId = testIndicatorUtil.getTask(imId,projId)  ;
         Activity__c testTask =  [select Id,Name from  Activity__c where id = :actvId ];
        ApexPages.StandardController thecontroller = new ApexPages.StandardController(testTask );
        ClsTaskExtensionController  controller = new ClsTaskExtensionController(thecontroller);
        Test.Stoptest(); 
 }
}