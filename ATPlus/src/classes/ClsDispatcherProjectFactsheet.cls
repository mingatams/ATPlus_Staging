public with sharing class ClsDispatcherProjectFactsheet {
    public ClsDispatcherProjectFactsheet(ApexPages.StandardController controller) {
    this.controller = controller;
  }
    
    public String defaultURL{get;set;}
    public PageReference getRedir() {
        defaultURL = '/a0c/o';
        String retURL = 'a0c/o';
        clsGlobalUtility GU = new clsGlobalUtility();
        Project__c proj = (Project__c)controller.getRecord();
        proj = (Project__c)GU.lookup(proj.Id,'Project__c');
        system.debug('Project Record:::'+proj);
        String recordType = GU.getRecordType('Project__c',proj.RecordTypeId);
        PageReference newPage;  
        
        Try{
            if (recordType.equalsIgnoreCase('IM Project')){
                newPage = new PageReference('/apex/vfIMProjectFactsheet?Id='+proj.Id);
            } else {
                newPage = new PageReference('/apex/vfProjectFactsheet?Id='+proj.Id);
            }  
            newPage.getParameters().put('nooverride', '1');
            newPage.getParameters().put('retURL', retURL);
            return newPage.setRedirect(true);
        }catch(Exception e){
          system.debug('Project Factsheet Dispatcher Error -'+e.getMessage());
          return null;
        }
  }
 
  private final ApexPages.StandardController controller;
  
  @IsTest public static void testClsDispatcherProjectFactsheet() {
  
      ClsTestUtility testIndicatorUtil = new ClsTestUtility();
      String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
      Project__c proj = testIndicatorUtil.getIMProjectRecordForOrgId(OrgUnitId);
      ApexPages.currentPage().getParameters().put('id',proj.Id);
      ApexPages.StandardController sc5 = new ApexPages.StandardController(proj);
      ClsDispatcherProjectFactsheet CDP = new ClsDispatcherProjectFactsheet(sc5);
      CDP.getRedir();
  
      Project__c proj1 = testIndicatorUtil.getProjectRecordForOrgId(OrgUnitId);
      ApexPages.currentPage().getParameters().put('id',proj1.Id);
       sc5 = new ApexPages.StandardController(proj1);
      ClsDispatcherProjectFactsheet CDP1 = new ClsDispatcherProjectFactsheet(sc5);
      CDP1.getRedir();
  }

  
}