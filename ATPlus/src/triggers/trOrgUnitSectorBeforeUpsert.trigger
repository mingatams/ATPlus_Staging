trigger trOrgUnitSectorBeforeUpsert on orgUnitSector__c (before insert, before update) {

    for (orgUnitSector__c rec : trigger.new) {
        rec.Name = rec.secCode__c + ' | ' + rec.secName__c;
        
    }
    

}