public with sharing class ClsDispatcherProjectNew {
    public ClsDispatcherProjectNew(ApexPages.StandardController controller) {
    this.controller = controller;
  }
    
    public String defaultURL{get;set;}
    public PageReference getRedir() {
        String retUrl = ApexPages.currentPage().getParameters().get('retURL');
        system.debug('Return URL from previous Page:::' +retUrl);
        return null;
  }
 
  private final ApexPages.StandardController controller;
  /** Test Method */      
 @IsTest(SeeAllData=true) public static void testDispatcherProjectNew() {
 
    ClsTestUtility testIndicatorUtil = new ClsTestUtility();            
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        Test.StartTest();
        String IMId= testIndicatorUtil.getIMForOrgIdNRecordType(OrgUnitId,'Advanced');
         ApexPages.currentPage().getParameters().put('retURL','www.salesforce.com'); 
        
        Implementing_Mechanism__c  imLink=[select Id,Name from Implementing_Mechanism__c where id = :IMId];         
        ApexPages.StandardController thecontroller = new ApexPages.StandardController(imLink);
      
        ClsDispatcherProjectNew  controller = new ClsDispatcherProjectNew(thecontroller );
       controller.defaultURL='www.salesforce.com';
        controller.getRedir();         
       
       
        Test.StopTest();
    
 }
}