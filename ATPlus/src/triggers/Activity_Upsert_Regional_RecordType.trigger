trigger Activity_Upsert_Regional_RecordType on Activity__c  (before insert,before update) {
 //This code displays the record type based on the mission type
    Id regionalRT=Schema.SObjectType.Activity__c.getRecordTypeInfosByName().get('Regional').getRecordTypeId();
    Id globalRT=Schema.SObjectType.Activity__c.getRecordTypeInfosByName().get('Global').getRecordTypeId();
    
   // System.debug('Reginal RT ID:' +regionalRT);
    if (!trigger.new.isEmpty()) {
       // System.debug('Inside Trigger New:::');
        for(Activity__c  a : trigger.new){
       // system.debug('In Trigger outside condition: '+a.Mission_Type__c);
            If(a.Mission_Type__c == 'Regional'){
                a.RecordTypeId = regionalRT;
       // system.debug('Regional'+a.Mission_Type__c);
            } else if(a.Mission_Type__c == 'Global'){
                a.RecordTypeId = globalRT;
            } else{
                 a.RecordTypeId = null;
       //  system.debug('National is null');
            }
        }
    }  
    
       // System.debug('Reginal RT ID:' +regionalRT);
    if (!trigger.new.isEmpty()) {
       // System.debug('Inside Trigger New:::');
        for(Activity__c  a : trigger.new){
       // system.debug('In Trigger outside condition: '+a.Mission_Type__c);
            If(((String)a.ouType__c).contains('Regional')){
                a.RecordTypeId = regionalRT;
       // system.debug('Regional'+a.Mission_Type__c);
            } else if(((String)a.ouType__c).contains('Pillar')){
                a.RecordTypeId = globalRT;
            } else{
                 a.RecordTypeId = null;
       //  system.debug('National is null');
            }
        }
    }  
    
    


}