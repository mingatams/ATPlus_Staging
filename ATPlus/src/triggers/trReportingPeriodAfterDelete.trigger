trigger trReportingPeriodAfterDelete on Reporting_Period__c (after delete) {
    ClsGlobalUtility GU = new ClsGlobalUtility();
    Map<String,String> recTypesMap = GU.getRecordTypeByObject('Reporting_Period__c');
    Reporting_Period__c rPeriod = new Reporting_Period__c();
    Map<String,String> recTypesMapRev = new Map<String,String>();
    for(String Key: recTypesMap.keySet()){
        recTypesMapRev.put(recTypesMap.get(Key),Key);       
    }
    if (Trigger.isDelete){
        System.debug('I am from the Organization Indicator Delete'+Trigger.old);
        rPeriod = Trigger.old[0];
        
        if (recTypesMapRev.get(rPeriod.RecordTypeId).equalsIgnoreCase('Activity')){
            Activity__c act = (Activity__c)GU.lookup(rPeriod.Activity_Id__c, 'Activity__c');
            List<SObject> sObjList = GU.lookup(rPeriod.Activity_Id__c, 'Activity_Id__c', 'Reporting_Period__c');
            if (sObjList.isEmpty()){
             //   act.Reporting_Periods_Established__c = false;
             //   upsert act;
            }           
        
        } else if (recTypesMapRev.get(rPeriod.RecordTypeId).equalsIgnoreCase('Implementing Mechanism')) {
            Implementing_Mechanism__c im = (Implementing_Mechanism__c)GU.lookup(rPeriod.Implementing_Mechanism_Id__c, 'Implementing_Mechanism__c');
            List<SObject> sObjList = GU.lookup(rPeriod.Implementing_Mechanism_Id__c, 'Implementing_Mechanism_Id__c', 'Reporting_Period__c');
            if (sObjList.isEmpty()){
                im.Reporting_Periods_Established__c = false;
                ApplicationConstants.bypassIMSharingRulesTriggerLogic = true;
                upsert im;
            }
        }
    }
}