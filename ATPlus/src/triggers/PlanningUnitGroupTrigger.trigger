trigger PlanningUnitGroupTrigger on Planning_Unit_Group__c (after insert, after update, before insert, before delete) {
	new PlanningUnitGroupTriggerHelper().Process();
}