public with sharing class OperatingUnits {
    public Map<Id, OperatingUnit__c> operatingUnitMap {get; private set;}
    
    public ReportMetadata__c[] reports {get; private set;}
    
    public OperatingUnit__c[] operatingUnits {
        get {
            return operatingUnitMap.values();
        }
    }
    
    public OperatingUnits() {
        initOpUnits();
        initReports();
    }
    
    public void initOpUnits() {
        operatingUnitMap = new Map<Id, OperatingUnit__c>([SELECT Name, Parent__c FROM OperatingUnit__c]);
    }
    
    private void initReports() {
        reports = [SELECT Name, ReportId__c, IconFileName__c FROM ReportMetadata__c WHERE IsActive__c = true];
    }
    
    @RemoteAction
    public static Result getOperatingUnitsHierarchy() {
        Result r = new Result();
        r.operatingUnitMap = new Map<Id, OperatingUnit__c>([SELECT Name, Parent__c FROM OperatingUnit__c]);
        r.topLevelOpUnits = new Id[0];
        for(OperatingUnit__c ou : r.operatingUnitMap.values()) {
            if(String.isBlank(ou.Parent__c)) {
                r.topLevelOpUnits.add(ou.Id);
            }
        }
        return r;
    }
    
    public class Result {
        public Map<Id, OperatingUnit__c> operatingUnitMap;
        public Id[] topLevelOpUnits;
    }
}