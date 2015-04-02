trigger PlanningUnitTrigger on OperatingUnit__c (after insert) {
	new PlanningUnitTriggerHelper().Process();
}