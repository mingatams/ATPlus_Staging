trigger trLFIndicatorResultAfterDelete on LF_Indicator_Result__c (after delete) {
    Set<Id> orgIndicatorIds = new Set<Id>(); 
    Set<Id> orgMasterIndicatorIds = new Set<Id>();
    Set<Id> lfReportingPeriods = new Set<Id>();
    List<OrgUnit_Indicator__c> updOrgIndicators = new List<OrgUnit_Indicator__c>();
    List<LF_Reporting_Period__c> updLFPeriods = new List<LF_Reporting_Period__c>();
    ClsFlagSetupUtility FSU = new ClsFlagSetupUtility();
    String orgUnit;
    String orgUnitIndId;
    clsGlobalUtility GU = new clsGlobalUtility();
    
    if (Trigger.isDelete){
        for(LF_Indicator_Result__c lfResult: Trigger.old){      
            orgIndicatorIds.add(lfResult.Organization_Indicator_Id__c);
            orgMasterIndicatorIds.add(lfResult.Organization_Indicator_Master_Id__c);
            lfReportingPeriods.add(lfResult.LF_Reporting_Period_Id__c);
            //orgUnit = lfResult.Organization_Indicator_Id__r.ouCode__c;
            orgUnitIndId =  lfResult.Organization_Indicator_Id__c ;
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
            update updOrgIndicators;
        }
        
        FSU.setupLFPeriodsCounterMaps(lfReportingPeriods);
        for(Id rpId: lfReportingPeriods){
            updLFPeriods.add(FSU.setupLFPeriodFlags(rpId));
        }
        
        if (!updLFPeriods.isEmpty()){
            update updLFPeriods;
        }       
        
    }
}