@IsTest(SeeAllData=true)
public with sharing class ClsTestTabController  {
  
    
    public static testMethod void testTabController() {    
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        Test.StartTest();
        
        ClsLogFrameOverview clsFrameOver= new ClsLogFrameOverview ();
          ClsTabController controller3 = new ClsTabController(clsFrameOver); 
          
         ClsResultsFrameWorkOverview  clsFrameOver4= new ClsResultsFrameWorkOverview ();
          ClsTabController controller4 = new ClsTabController(clsFrameOver4);   
          
            ClsManageIndicatorTargets  clsFrameOver5= new ClsManageIndicatorTargets ();
          ClsTabController controller5 = new ClsTabController(clsFrameOver5);   
       
          
         CDCSGoal__c rfGoal= [select Id,Name from CDCSGoal__c where ouId__c = :OrgUnitId];
               
         ApexPages.StandardController thecontroller = new ApexPages.StandardController(rfGoal);
        ClsTabController controller1 = new ClsTabController(thecontroller);  
        
          ApexPages.currentPage().getParameters().put('Id',OrgUnitId ); 
            ClsOrgUnitIndicatorSController clsFrameOver6= new ClsOrgUnitIndicatorSController ();
          ClsTabController controller6 = new ClsTabController(clsFrameOver6);  
          
          ClsTabController  contol = new ClsTabController();
        ApexPages.currentPage().getParameters().put('Id',rfGoal.id);  
         ClsTabController controller = new ClsTabController(thecontroller); 
        controller.previousURL=null; 
       controller.selectedTab='Goal'; 
       String selecTab=controller.selectedTab;    
        controller.selectTab();
        controller.doAction();
      PageReference pageRef =new  PageReference('/apex/VFOrgUnitTab');
        Test.setCurrentPage(pageRef);
        controller.redirectPage();
        Test.StopTest();
    }
    
       
    public static testMethod void testNoPreviousUrlForTab() {    
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        Test.StartTest();
         CDCSGoal__c rfGoal= [select Id,Name from CDCSGoal__c where ouId__c = :OrgUnitId];
         ApexPages.currentPage().getParameters().put('Id',rfGoal.id);        
         ApexPages.StandardController thecontroller = new ApexPages.StandardController(rfGoal);
        ClsTabController controller = new ClsTabController(thecontroller); 
        controller.previousURL='www.salesforce.com';       
        controller.doAction();
          PageReference pageRef =new  PageReference('/apex/VFGoalTab');
        Test.setCurrentPage(pageRef);
        controller.redirectPage();
        Test.StopTest();
    }
    
        public static testMethod void testTabController1() {    
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        Test.StartTest();
        
        ClsLogFrameOverview clsFrameOver= new ClsLogFrameOverview ();
          ClsTabController controller3 = new ClsTabController(clsFrameOver); 
          
         ClsResultsFrameWorkOverview  clsFrameOver4= new ClsResultsFrameWorkOverview ();
          ClsTabController controller4 = new ClsTabController(clsFrameOver4);   
          
            ClsManageIndicatorTargets  clsFrameOver5= new ClsManageIndicatorTargets ();
          ClsTabController controller5 = new ClsTabController(clsFrameOver5);   
          
           ApexPages.currentPage().getParameters().put('Id',OrgUnitId ); 
            ClsOrgUnitIndicatorSController clsFrameOver6= new ClsOrgUnitIndicatorSController ();
          ClsTabController1 controller6 = new ClsTabController1(clsFrameOver6);      
          
         CDCSGoal__c rfGoal= [select Id,Name from CDCSGoal__c where ouId__c = :OrgUnitId];
          
         ApexPages.StandardController thecontroller = new ApexPages.StandardController(rfGoal);
        
         ApexPages.currentPage().getParameters().put('Id',rfGoal.id);      
         ClsTabController1 controller = new ClsTabController1(thecontroller); 
        controller.previousURL1=null; 
        controller.aId =OrgUnitId ;
        PageReference pageRef =new  PageReference('/apex/VFOrgUnitTab');
        Test.setCurrentPage(pageRef);
       controller.selectedTab1='Goal';    
        String selecTab=controller.selectedTab1; 
        controller.selectTab();
        controller.doAction();
      
       
        Test.StopTest();
    }
    
       
    public static testMethod void testNoPreviousUrlForTab1() {    
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        Test.StartTest();
         CDCSGoal__c rfGoal= [select Id,Name from CDCSGoal__c where ouId__c = :OrgUnitId];
         ApexPages.currentPage().getParameters().put('Id',rfGoal.id);        
         ApexPages.StandardController thecontroller = new ApexPages.StandardController(rfGoal);
        ClsTabController1 controller = new ClsTabController1(thecontroller); 
        controller.previousURL1='www.salesforce.com';       
        controller.doAction();
          PageReference pageRef =new  PageReference('/apex/VFGoalTab');
        Test.setCurrentPage(pageRef);
        //controller.redirectPage();
        Test.StopTest();
    }
    
    
    
 }