trigger trOrganizationIndicatorAfterDelete on OrgUnit_Indicator__c (after delete) {
    ClsGlobalUtility GU = new ClsGlobalUtility();
    ClsFlagSetupUtility FSU = new ClsFlagSetupUtility();
    //Map<String,String> recTypesMap = GU.getRecordTypeByObject('OrgUnit_Indicator__c');
    Map<ID,OrgUnit_Indicator__c> oIndMap = new Map<Id,OrgUnit_Indicator__c>();
    set<ID> oIndMasterIds = new Set<Id>();
    OrgUnit_Indicator__c oInd = new OrgUnit_Indicator__c();
   // Map<String,String> recTypesMapRev = new Map<String,String>();
   // for(String Key: recTypesMap.keySet()){
   //     recTypesMapRev.put(recTypesMap.get(Key),Key);       
   // }   
    if (!ApplicationConstants.bypassOrgUnitIndicatorAfterDelete) { 
        if (Trigger.isDelete && Trigger.isAfter){
            System.debug('I am from the Organization Indicator Delete'+Trigger.old);
            
            for(OrgUnit_Indicator__c oi: Trigger.old){
                oIndMap.put(oi.Id,oi);
                oIndMasterIds.add(oi.Organization_Indicator_Id__c);        
            }
            
            FSU.indicatorsEstablishedFlagSetup(oIndMap);  
        }
    }    
}