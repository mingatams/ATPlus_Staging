trigger trRFIndicatorResultAfterUpdate on RF_Indicator_Result__c (after update) {
    Set<Id> orgIndicatorIds = new Set<Id>(); 
    Set<Id> orgMasterIndicatorIds = new Set<Id>();
    Set<Id> rfReportingPeriods = new Set<Id>();
    List<OrgUnit_Indicator__c> updOrgIndicators = new List<OrgUnit_Indicator__c>();
    List<RF_Reporting_Period__c> updRFPeriods = new List<RF_Reporting_Period__c>();
    ClsFlagSetupUtility FSU = new ClsFlagSetupUtility();
    String orgUnit;
    
    if (Trigger.isUpdate){
        for(RF_Indicator_Result__c rfResult: Trigger.new){      
            orgIndicatorIds.add(rfResult.Organization_Indicator_Id__c);
            orgMasterIndicatorIds.add(rfResult.Organization_Indicator_Master_Id__c);
            rfReportingPeriods.add(rfResult.RF_Reporting_Period_Id__c);
            orgUnit = rfResult.ouCode__c;
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
            update updOrgIndicators;
        }
        
        FSU.setupRFPeriodsCounterMaps(rfReportingPeriods);
        for(Id rpId: rfReportingPeriods){
            updRFPeriods.add(FSU.setupRFPeriodFlags(rpId));
        }
        
        if (!updRFPeriods.isEmpty()){
            update updRFPeriods;
        }       
        
    }
}