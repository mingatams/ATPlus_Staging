trigger FiscalYearTrigger on FiscalYear__c (before insert, after update) {
    
    Map<Decimal, FiscalYear__c> newYears = new Map<Decimal, FiscalYear__c>();
    Id activeId = null;
    for( FiscalYear__c fy : [SELECT ID FROM FiscalYear__c WHERE isActive__c = TRUE] ){
        activeId = fy.id;
    }
    for(FiscalYear__c newYear : Trigger.new) {
        //Ensure the name is meaningful
        /*
        if(newYear.Name == null) {
            newYear.Name = newYear.Year__c;
        }
        */
        newYears.put(newYear.Year__c, newYear);
        //Only one year can be active at a time
        if(newYear.IsActive__c) {
            if(activeId != null && activeId != newYear.id) {
                newYear.addError('Only one year can be active');
            } else {
                activeId = newYear.Id;
            }
        }
    }
    if(activeId != null) {
        FiscalYear__c[] activeYears = [SELECT IsActive__c FROM FiscalYear__c WHERE IsActive__c = true AND Id != :activeId];
        for(FiscalYear__c year : activeYears) {
            year.IsActive__c = false;
        }
        update activeYears;
    }
    
    //Only one record for each year can exist
    if(Trigger.isInsert) {
        Boolean fyFlag = false;
        for( FiscalYear__c fy : trigger.new ){
            if( fyFlag == FALSE && fy.IsActive__c == TRUE ){
                fyFlag = TRUE;
            }else if( fyFlag == TRUE && fy.IsActive__c == TRUE ){
                fy.addError('Only one year can be active');
            }
        }
        FiscalYear__c[] duplicateYears = [SELECT Year__c FROM FiscalYear__c WHERE Year__c IN :newYears.keySet()];
        for(FiscalYear__c newYear : duplicateYears) {
            newYears.get(newYear.Year__c).addError('The year '+newYear.Year__c+' already exists');
        }
    }
}