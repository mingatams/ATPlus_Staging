trigger trRFReportingPeriodAfterDelete on RF_Reporting_Period__c (after delete) {
    
    ClsGlobalUtility GU = new ClsGlobalUtility();
    Map<String,String> recTypesMap = GU.getRecordTypeByObject('RF_Reporting_Period__c');
    RF_Reporting_Period__c oInd = new RF_Reporting_Period__c();
    Map<String,String> recTypesMapRev = new Map<String,String>();
    for(String Key: recTypesMap.keySet()){
        recTypesMapRev.put(recTypesMap.get(Key),Key);       
    }
    if (Trigger.isDelete){
        System.debug('I am from the Organization Indicator Delete'+Trigger.old);
        oInd = Trigger.old[0];
        
        if (recTypesMapRev.get(oInd.RecordTypeId).equalsIgnoreCase('RF Goal')){
            CDCSGoal__c goal = (CDCSGoal__c)GU.lookup(oInd.Goal_Id__c, 'CDCSGoal__c');
            List<SObject> sObjList = GU.lookup(oInd.Goal_Id__c, 'Goal_Id__c', 'RF_Reporting_Period__c');
            if (sObjList.isEmpty()){
                goal.Indicators_Established__c = false;
                upsert goal;
            }   
            
        } else if (recTypesMapRev.get(oInd.RecordTypeId).equalsIgnoreCase('RF DO')) {
            DO__c doo = (DO__c)GU.lookup(oInd.DO_Id__c, 'DO__c');
            List<SObject> sObjList = GU.lookup(oInd.DO_Id__c, 'DO_Id__c', 'RF_Reporting_Period__c');
            if (sObjList.isEmpty()){
                doo.Indicators_Established__c = false;
                upsert doo;
            }
            
        } else if (recTypesMapRev.get(oInd.RecordTypeId).equalsIgnoreCase('RF IR')) {
            IR__c ir = (IR__c)GU.lookup(oInd.IR_Id__c, 'IR__c');
            List<SObject> sObjList = GU.lookup(oInd.IR_Id__c, 'IR_Id__c', 'RF_Reporting_Period__c');
            if (sObjList.isEmpty()){
                ir.Indicators_Established__c = false;
                upsert ir;
            }
        } else if (recTypesMapRev.get(oInd.RecordTypeId).equalsIgnoreCase('RF SUB IR')) {
            Sub_IR__c sir = (Sub_IR__c)GU.lookup(oInd.SIR_Id__c, 'Sub_IR__c');
            List<SObject> sObjList = GU.lookup(oInd.SIR_Id__c, 'SIR_Id__c', 'RF_Reporting_Period__c');
            if (sObjList.isEmpty()){
                sir.Indicators_Established__c = false;
                upsert sir;
            }
        }
    }

}