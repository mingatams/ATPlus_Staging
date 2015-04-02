trigger AAPlanTrigger on AAPlan__c (before insert, after insert, after update) {
	new AAPlanTriggerHelper().Process();
}