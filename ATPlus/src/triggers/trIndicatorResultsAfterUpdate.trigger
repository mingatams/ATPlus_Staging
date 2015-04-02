trigger trIndicatorResultsAfterUpdate on Indicator_Results__c (after insert) {
    Set<Id> orgIndicatorIds = new Set<Id>(); 
    Set<Id> orgMasterIndicatorIds = new Set<Id>();
    Set<Id> imReportingPeriods = new Set<Id>();
    List<OrgUnit_Indicator__c> updOrgIndicators = new List<OrgUnit_Indicator__c>();
    List<Reporting_Period__c> updIMPeriods = new List<Reporting_Period__c>();
    ClsFlagSetupUtility FSU = new ClsFlagSetupUtility();
    String orgUnit;
    if (!ApplicationConstants.bypassIndicatorResultsAfterUpdate){
        if (Trigger.isInsert || Trigger.isUpdate){
            for(Indicator_Results__c iResult: Trigger.new){     
                orgIndicatorIds.add(iResult.Organization_Indicator_Id__c);
                orgMasterIndicatorIds.add(iResult.Organization_Indicator_Master_Id__c);
                imReportingPeriods.add(iResult.Reporting_Period_Id__c);
                orgUnit = iResult.ouCode__c;
            }
            
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
                ApplicationConstants.bypassOrgUnitIndicatorUpsertShare = true;
                ApplicationConstants.bypassOrganizationIndicatorBeforeUpsertQOwner = true;
                update updOrgIndicators;
                ApplicationConstants.bypassOrgUnitIndicatorUpsertShare = false;
                ApplicationConstants.bypassOrganizationIndicatorBeforeUpsertQOwner = false;
            } 
            
         //   FSU.setupIMPeriodsCounterMaps(imReportingPeriods);
         //   for(Id rpId: imReportingPeriods){
         //       updIMPeriods.add(FSU.setupIMPeriodFlags(rpId));
         //   }
            
         //   if (!updIMPeriods.isEmpty()){
         //       ApplicationConstants.bypassReportingPeriodApprovalLogic = true;
         //       ApplicationConstants.bypassReportingPeriodBeforeUpsertQOwner = true;
         //       update updIMPeriods;
         //       ApplicationConstants.bypassReportingPeriodApprovalLogic = false;
         //       ApplicationConstants.bypassReportingPeriodBeforeUpsertQOwner = false;
         //   }       
            
        }
    }    
}