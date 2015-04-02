trigger trLFReportingPeriodAfterDelete on LF_Reporting_Period__c (after delete) {
	ClsGlobalUtility GU = new ClsGlobalUtility();
	Map<String,String> recTypesMap = GU.getRecordTypeByObject('LF_Reporting_Period__c');
	LF_Reporting_Period__c lPeriod = new LF_Reporting_Period__c();
	Map<String,String> recTypesMapRev = new Map<String,String>();
	for(String Key: recTypesMap.keySet()){
		recTypesMapRev.put(recTypesMap.get(Key),Key);		
	}
	if (Trigger.isDelete){
		System.debug('I am from the Organization Indicator Delete'+Trigger.old);
		lPeriod = Trigger.old[0];
		
		if (recTypesMapRev.get(lPeriod.RecordTypeId).equalsIgnoreCase('LF Goal'))	{
			LF_Goal__c lgoal = (LF_Goal__c)GU.lookup(lPeriod.LF_Goal_Id__c, 'LF_Goal__c');
			List<SObject> sObjList = GU.lookup(lPeriod.LF_Goal_Id__c, 'LF_Goal_Id__c', 'LF_Reporting_Period__c');
			if (sObjList.isEmpty()){
				lgoal.Indicators_Established__c = false;
				upsert lgoal;
			}
		} else if (recTypesMapRev.get(lPeriod.RecordTypeId).equalsIgnoreCase('LF Purpose'))	{
			LF_Purpose__c lPurpose = (LF_Purpose__c)GU.lookup(lPeriod.LF_Purpose_Id__c, 'LF_Purpose__c');
			List<SObject> sObjList = GU.lookup(lPeriod.LF_Purpose_Id__c, 'LF_Purpose_Id__c', 'LF_Reporting_Period__c');
			if (sObjList.isEmpty()){
				lPurpose.Indicators_Established__c = false;
				upsert lPurpose;
			}
		} else if (recTypesMapRev.get(lPeriod.RecordTypeId).equalsIgnoreCase('LF Sub-Purpose'))	{
			LF_SubPurpose__c lsPurpose = (LF_SubPurpose__c)GU.lookup(lPeriod.LF_SubPurpose_Id__c, 'LF_SubPurpose__c');
			List<SObject> sObjList = GU.lookup(lPeriod.LF_SubPurpose_Id__c, 'LF_SubPurpose_Id__c', 'LF_Reporting_Period__c');
			if (sObjList.isEmpty()){
				lsPurpose.Indicators_Established__c = false;
				upsert lsPurpose;
			}
		} else if (recTypesMapRev.get(lPeriod.RecordTypeId).equalsIgnoreCase('LF Output'))	{
			LF_Output__c lOutput = (LF_Output__c)GU.lookup(lPeriod.LF_Output_Id__c, 'LF_Output__c');
			List<SObject> sObjList = GU.lookup(lPeriod.LF_Output_Id__c, 'LF_Output_Id__c', 'LF_Reporting_Period__c');
			if (sObjList.isEmpty()){
				lOutput.Indicators_Established__c = false;
				upsert lOutput;
			}
		} else if (recTypesMapRev.get(lPeriod.RecordTypeId).equalsIgnoreCase('LF Input'))	{
			LF_Input__c lInput = (LF_Input__c)GU.lookup(lPeriod.LF_Input_Id__c, 'LF_Input__c');
			List<SObject> sObjList = GU.lookup(lPeriod.LF_Input_Id__c, 'LF_Input_Id__c', 'LF_Reporting_Period__c');
			if (sObjList.isEmpty()){
				lInput.Indicators_Established__c = false;
				upsert lInput;
			}
		} 
	}

}