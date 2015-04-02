trigger trOrgUnitGeographyBeforeUpsert on orgUnitGeography__c (before insert, before update) {

    for (orgUnitGeography__c rec : trigger.new) {
        rec.Name = rec.orgUnitCode__c + ' | ' + rec.cntryCode__c + ' | ' + rec.cntryName__c;
        rec.uniqueRecordName__c = rec.orgUnitCode__c + ' | ' + rec.cntryCode__c;
        
    }
    

}