public with sharing class AidTrackerMapPreviewController {
    public String orgUnitCode {get;set;}
    public OrgUnit__c ou {get;set;}
    public String sfdcURL{get;set;} 
     
    public AidTrackerMapPreviewController(){
        String uRoleId = UserInfo.getUserRoleId();
        sfdcURL = URL.getSalesforceBaseUrl().toExternalForm();
     //   system.debug('Role Id :::' +uRoleId);
        UserRole ur = [Select Name From UserRole where Id = :uRoleId];
        String orgUnitName;
        if (((String)ur.Name).contains(' | ')){
            orgUnitName = ((String)ur.Name).split(' | ')[0];
        } else {
            orgUnitName = 'Root';
        }    
     //   system.debug('Role Id Name Trunc:::' +orgUnitName);
        ou = new OrgUnit__c(); 
        if (orgUnitName == 'Root' || orgUnitName == 'AID' ){
            orgUnitCode = '';            
        } else {
           // OrgUnit__c ou = [Select ouCode__c From OrgUnit__c where ouName__c = :orgUnitName];
           // orgUnitCode = '?m='+(String)ou.ouCode__c;
           orgUnitCode = '?m='+orgUnitName.trim();
           ou = [Select Id, ouCode__c From OrgUnit__c where ouCode__c = :orgUnitName.trim()];
        }
        
        system.debug('OrgUnit Code :::' +orgUnitCode);  
     
     
     
        
    }
}