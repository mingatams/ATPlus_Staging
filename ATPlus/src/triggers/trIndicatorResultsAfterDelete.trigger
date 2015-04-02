trigger trIndicatorResultsAfterDelete on Indicator_Results__c (after delete) {
    Set<Id> orgIndicatorIds = new Set<Id>(); 
    Set<Id> orgMasterIndicatorIds = new Set<Id>();
    Set<Id> imReportingPeriods = new Set<Id>();
    List<OrgUnit_Indicator__c> updOrgIndicators = new List<OrgUnit_Indicator__c>();
    List<Reporting_Period__c> updIMPeriods = new List<Reporting_Period__c>();
    ClsFlagSetupUtility FSU = new ClsFlagSetupUtility();
    String orgUnit;
    String orgUnitIndId;
    clsGlobalUtility GU = new clsGlobalUtility();
    
    if(!ApplicationConstants.bypassIndicatorResultsAfterDelete){
    if (Trigger.isDelete){
        for(Indicator_Results__c iResult: Trigger.old){     
            orgIndicatorIds.add(iResult.Organization_Indicator_Id__c);
            orgMasterIndicatorIds.add(iResult.Organization_Indicator_Master_Id__c);
            imReportingPeriods.add(iResult.Reporting_Period_Id__c);
            //orgUnit = iResult.Organization_Indicator_Id__r.ouCode__c;
            orgUnitIndId =  iResult.Organization_Indicator_Id__c ;
        }
        
        
        OrgUnit_Indicator__c oi = (OrgUnit_Indicator__c) GU.lookup(orgUnitIndId,'OrgUnit_Indicator__c');        
        orgUnit = oi.ouCode__c;
        FSU.setupOrgUnit(orgUnit);
        FSU.setupResultsCounterMaps(orgIndicatorIds, false);
        for(Id ouId: orgIndicatorIds){
            updOrgIndicators.add(FSU.setupIndicatorFlags(ouId));
        }       
        
        FSU.setupResultsCounterMaps(orgMasterIndicatorIds, true);
        for(Id ouId: orgMasterIndicatorIds){
            updOrgIndicators.add(FSU.setupIndicatorFlags(ouId));
        }
        
        if (!updOrgIndicators.isEmpty()){
            system.debug('Update List::'+updOrgIndicators);
            
            ApplicationConstants.bypassOrgUnitIndicatorAfterDelete = true;
            ApplicationConstants.bypassOrgUnitIndicatorUpsertShare = true;
            ApplicationConstants.bypassOrganizationIndicatorBeforeUpsertQOwner = true;
            update updOrgIndicators;
            ApplicationConstants.bypassOrgUnitIndicatorAfterDelete = false;
            ApplicationConstants.bypassOrgUnitIndicatorUpsertShare = false;
            ApplicationConstants.bypassOrganizationIndicatorBeforeUpsertQOwner = false;
        }
        
        FSU.setupIMPeriodsCounterMaps(imReportingPeriods);
        for(Id rpId: imReportingPeriods){
            updIMPeriods.add(FSU.setupIMPeriodFlags(rpId));
        }
        
        if (!updIMPeriods.isEmpty()){
            ApplicationConstants.bypassReportingPeriodApprovalLogic = true;
            ApplicationConstants.bypassReportingPeriodBeforeUpsertQOwner = true;
            update updIMPeriods;
            
            ApplicationConstants.bypassReportingPeriodApprovalLogic = false;
            ApplicationConstants.bypassReportingPeriodBeforeUpsertQOwner = false;
        }       
        
    }
   } 
}