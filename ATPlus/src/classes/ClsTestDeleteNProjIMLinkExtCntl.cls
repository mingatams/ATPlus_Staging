@IsTest(SeeAllData=true)
public with sharing class ClsTestDeleteNProjIMLinkExtCntl  {
  
    
    public static testMethod void testProjectFactsheet() {    
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        Test.StartTest();
         CDCSGoal__c rfGoal= [select Id,Name from CDCSGoal__c where ouId__c = :OrgUnitId];
         ApexPages.StandardController thecontroller = new ApexPages.StandardController(rfGoal);
        ClsDeleteControllerExt controller = new ClsDeleteControllerExt(thecontroller);
        controller.currentRequestURL='/apex/vfProjectFactsheet';       
        controller.customDelete();            
        controller.getHasErrorMessages();
        Test.StopTest();
    
      
    }

 public static testMethod void testIMProjectFactsheet() {
       ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        Test.StartTest();
         CDCSGoal__c rfGoal= [select Id,Name from CDCSGoal__c where ouId__c = :OrgUnitId];
         ApexPages.StandardController thecontroller = new ApexPages.StandardController(rfGoal);
        ClsDeleteControllerExt controller = new ClsDeleteControllerExt(thecontroller);
        controller.currentRequestURL='/apex/vfIMProjectFactsheet';       
        controller.customDelete();            
        controller.getHasErrorMessages();
        Test.StopTest();
    
    
      
    }
    
     public static testMethod void testIMBasicDetailFactSheet() {
       ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        Test.StartTest();
         CDCSGoal__c rfGoal= [select Id,Name from CDCSGoal__c where ouId__c = :OrgUnitId];
         ApexPages.StandardController thecontroller = new ApexPages.StandardController(rfGoal);
        ClsDeleteControllerExt controller = new ClsDeleteControllerExt(thecontroller);
        controller.currentRequestURL='/apex/vfIMBasicDetailFactSheet';        
        controller.customDelete();            
        controller.getHasErrorMessages();
        Test.StopTest();
    
    
      
    }
    
     public static testMethod void testOrgDetailFactSheet() {
       ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        Test.StartTest();
         CDCSGoal__c rfGoal= [select Id,Name from CDCSGoal__c where ouId__c = :OrgUnitId];
         ApexPages.StandardController thecontroller = new ApexPages.StandardController(rfGoal);
        ClsDeleteControllerExt controller = new ClsDeleteControllerExt(thecontroller);
        controller.currentRequestURL='/apex/vfOrgDetailFactSheet';        
        controller.customDelete();            
        controller.getHasErrorMessages();
        Test.StopTest();
    
    
      
    }
    
     public static testMethod void testDeleteNullObject() {
     ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        Test.StartTest();
         CDCSGoal__c rfGoal= [select Id,Name from CDCSGoal__c where ouId__c = :OrgUnitId];
         ApexPages.StandardController thecontroller = new ApexPages.StandardController(rfGoal);  
          ClsDeleteControllerExt controller = new ClsDeleteControllerExt(thecontroller);
          controller.currentRequestURL=''; 
          controller.deleUrl ='delUrl'; 
          controller.customDelete();    
        controller.getHasErrorMessages();
        Test.StopTest();
    
      
    }
    
       public static testMethod void testRelatedListExist() {
     ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        Test.StartTest();
         CDCSGoal__c rfGoal= [select Id,Name from CDCSGoal__c where ouId__c = :OrgUnitId];
          String rfDOId =  testIndicatorUtil.getRFDOForGoal(rfGoal.id);
           
         ApexPages.StandardController thecontroller = new ApexPages.StandardController(rfGoal);  
          ClsDeleteControllerExt controller = new ClsDeleteControllerExt(thecontroller);
         
          controller.customDelete();    
        controller.getHasErrorMessages();
        Test.StopTest();
    
      
    }
    
       public static testMethod void testErrorObject() {
    
        Test.StartTest();
         CDCSGoal__c rfGoal= new CDCSGoal__c();
         ApexPages.StandardController thecontroller = new ApexPages.StandardController(rfGoal);  
          ClsDeleteControllerExt controller = new ClsDeleteControllerExt(thecontroller);     
          controller.customDelete();    
           controller.getHasErrorMessages();
           Test.StopTest();
         
    }
    
    
    
     public static testMethod void testProjectIMLinkExtController() {      
       
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        Test.StartTest();
        String IMId= testIndicatorUtil.getIMForOrgId(OrgUnitId);
        String projectId =  testIndicatorUtil.getProjectForOrgId(OrgUnitId);
        
        Project__c  imLink=[select Id,Name from Project__c where id = :projectId ];         
        ApexPages.StandardController thecontroller = new ApexPages.StandardController(imLink);
        ClsProjectIMLinkExtController  controller1 = new ClsProjectIMLinkExtController(thecontroller);  
        ClsProjectIMLinkExtController controller = new ClsProjectIMLinkExtController();
        ApexPages.currentPage().getParameters().put('Id',IMId); 
        ApexPages.currentPage().getParameters().put('retURL','www.saleforce.com');
        controller.cancel();         
        controller1.saveAndReturn();            
       
        Test.StopTest();
    
      
    }
  
}