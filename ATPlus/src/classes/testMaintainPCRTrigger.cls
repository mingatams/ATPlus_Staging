public with sharing class testMaintainPCRTrigger {
   	static testMethod void testMaintainPCRTrigger() {
    	Test.startTest();
    	for (Location1__c loc : [select Id from Location1__c limit 10]) {
    	loc.Name = 'dgdgdfgdf';
    	loc.Activity__c = 'a0Id0000004V0hl';
    	//insert loc;
    	update loc;
    	}
    	Test.stopTest();
    }
}