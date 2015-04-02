public with sharing class ClsResultsFrameworkLinkage {
    public string inputRecId{get;set;}
    public Project__c proj{get;set;} 
    public Map<String,List<CDCSGoal__c>> projectGoalMap{get;set;}
    public Map<String,List<DO__c>> goalDOMap{get;set;}
    public Map<String,List<IR__c>> doIRMap{get;set;}
    public Map<String,List<Sub_IR__c>> irSIRMap{get;set;}
    public Map<String,ClsResultsFrameworkUtility.TreeNode> recMap{get;set;} 
    
    ClsGlobalUtility GU = new ClsGlobalUtility();
    ClsResultsFrameworkUtility RFU;
    
    public ClsResultsFrameworkLinkage(){
        inputRecId = ApexPages.currentPage().getParameters().get('id');
        //proj = new Project__c();
        proj = (Project__c)GU.lookup((Id)inputRecId,'Project__c');
        RFU = new ClsResultsFrameworkUtility(proj);
        
        projectGoalMap = new Map<String,List<CDCSGoal__c>>();       
        goalDOMap = new Map<String,List<DO__c>>();
        doIRMap = new Map<String,List<IR__c>>();
        irSIRMap = new Map<String,List<Sub_IR__c>>();
        recMap = new Map<String,ClsResultsFrameworkUtility.TreeNode>();
        
        system.debug('Before Goal MAp');
        projectGoalMap = RFU.getResultsFrameworkGoalMap();
        system.debug('After Goal MAp');
        goalDOMap = RFU.getResultsFrameworkDoMap();
        system.debug('After DO MAp');
        doIRMap = RFU.getResultsFrameworkIRMap();
        system.debug('After IR MAp');
        irSIRMap = RFU.getResultsFrameworkSIRMap();
        system.debug('After SIR MAp');
        recMap = RFU.getResultsFrameworkParentChildMap();
        system.debug('After REC MAp' +recMap);
        
    }   
    
    @IsTest public static void testClsResultsFrameworkLinkage() {
        
        ClsTestUtility testIndicatorUtil = new ClsTestUtility(); 
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        String projectId = testIndicatorUtil.getProjectForOrgId(OrgUnitId); 
        String rfGoalId = testIndicatorUtil.getRFGoalForOrgId(OrgUnitId);
       // String id1 = testIndicatorUtil.getPortfolioRFLinks(projectId,rfGoalId,'Goal');
        String rfDoId = testIndicatorUtil.getRFDOForGoal(rfGoalId);
        String id2 = testIndicatorUtil.getPortfolioRFLinks(projectId,rfGoalId,rfDoId,null,null,'Do');
        String rfIrId = testIndicatorUtil.getRFIRForDO(rfDoId);
        String id3 = testIndicatorUtil.getPortfolioRFLinks(projectId,rfGoalId,rfDoId,rfIrId,null,'IR');
        String rfSirId = testIndicatorUtil.getRFSubIRForIR(rfIrId);
        String id4 = testIndicatorUtil.getPortfolioRFLinks(projectId,rfGoalId,rfDoId,rfIrId,rfSirId,'SIR');
        
        ApexPages.currentPage().getParameters().put('id', projectId); 
        ClsResultsFrameworkLinkage RFL = new ClsResultsFrameworkLinkage();
      //  Map<String,List<CDCSGoal__c>> goalMap = RFL.getResultsFrameworkGoalMap();
      //  Map<String,List<DO__c>> goalDOMap = RFL.getResultsFrameworkDoMap();
      //  Map<String,List<IR__c>> doIRMap = RFL.getResultsFrameworkIRMap();
      //  Map<String,List<Sub_IR__c>> irSIRMap = RFL.getResultsFrameworkSIRMap();
       // Map<String,ClsResultsFrameworkUtility.TreeNode> recMap = RFU.getResultsFrameworkParentChildMap();
    }
    
}