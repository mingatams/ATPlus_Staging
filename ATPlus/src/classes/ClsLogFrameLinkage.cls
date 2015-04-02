public with sharing class ClsLogFrameLinkage {
    
    public string inputRecId{get;set;}
    public Project__c proj{get;set;} 
    public Map<String,List<LF_Goal__c>> projectLGoalMap{get;set;}
    public Map<String,List<LF_Purpose__c>> goalPurposeMap{get;set;}
    public Map<String,List<LF_SubPurpose__c>> purposeSubPurposeMap{get;set;}
    public Map<String,List<LF_Output__c>> purposeSubPurposeOutputMap{get;set;}
    public Map<String,List<LF_Input__c>> outputInputMap{get;set;}
    public Map<String,ClsLogFrameUtility.TreeNode> recMap{get;set;}
    
    ClsGlobalUtility GU = new ClsGlobalUtility();
    ClsLogFrameUtility LFU;
    
    public ClsLogFrameLinkage(){
        inputRecId = ApexPages.currentPage().getParameters().get('id');
        //proj = new Project__c();
        proj = (Project__c)GU.lookup((Id)inputRecId,'Project__c');
        LFU = new ClsLogFrameUtility(proj);
        
        projectLGoalMap = new Map<String,List<LF_Goal__c>>();       
        goalPurposeMap = new Map<String,List<LF_Purpose__c>>();
        purposeSubPurposeMap = new Map<String,List<LF_SubPurpose__c>>();
        purposeSubPurposeOutputMap = new Map<String,List<LF_Output__c>>();
        outputInputMap = new Map<String,List<LF_Input__c>>();       
        recMap = new Map<String,ClsLogFrameUtility.TreeNode>();
        
        system.debug('Before Goal MAp');
        projectLGoalMap = LFU.getLogFrameGoalMap();
        system.debug('After Goal MAp');
        goalPurposeMap = LFU.getLogFramePurposeMap();
        system.debug('After DO MAp');
        purposeSubPurposeMap = LFU.getLogFrameSubPurposeMap();
        system.debug('After IR MAp');
        purposeSubPurposeOutputMap = LFU.getLogFrameOutputMap();
        system.debug('After SIR MAp');
        outputInputMap = LFU.getLogFrameInputMap();
        system.debug('After SIR MAp');
        recMap = LFU.getLogFrameParentChildMap();
        system.debug('After REC MAp' +recMap);
        
    }
    
    
    @IsTest public static void testClsLogFrameLinkage() {
        //  clsReportingPeriod CRP = new clsReportingPeriod();
          ClsTestUtility testIndicatorUtil = new ClsTestUtility(); 
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
          String projectId = testIndicatorUtil.getProjectForOrgId(OrgUnitId);          
          String lfGoalId = testIndicatorUtil.getLFGoalForProjectId(projectId);
          String lfPurposeId = testIndicatorUtil.getLFPurposeForGoal(lfGoalId);
          String lfSubPurposeId = testIndicatorUtil.getLFSubPurpose(lfPurposeId);          
          String lfOutputId = testIndicatorUtil.getLFOutputP(lfPurposeId);
          String lfOutputId1 = testIndicatorUtil.getLFOutput(lfSubPurposeId);
          String lfInputId = testIndicatorUtil.getLFInput(lfOutputId);
          String lfInputId1 = testIndicatorUtil.getLFInput(lfOutputId1);
         // testIndicatorUtil.updateProjectForOrgId(OrgUnitId);
         // testIndicatorUtil.updateLFGoalForProjectId(projectId);
          
          ApexPages.currentPage().getParameters().put('id', projectId);            
          ClsLogFrameLinkage CLF = new ClsLogFrameLinkage(); 
      
     }
    

}