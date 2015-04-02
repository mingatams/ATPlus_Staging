trigger PlanningUnitUserTrigger on Planning_Unit_User__c (after insert, before delete) {
	new PlanningUnitUserTriggerHelper().Process();
}