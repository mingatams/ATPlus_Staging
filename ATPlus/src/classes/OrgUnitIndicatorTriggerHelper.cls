public class OrgUnitIndicatorTriggerHelper{
    public OrgUnitIndicatorTriggerHelper(){
    
    }
    public static void ReportingPeriodFlags(Map<Id,OrgUnit_Indicator__c> newMap){
        Map<Id,set<string>> imDistinctFreqs = new Map<Id,set<string>>();
        Id imRecordTypeId = Schema.SObjectType.OrgUnit_Indicator__c.getRecordTypeInfosByName().get('Implementing Mechanism').getRecordTypeId();

        for(OrgUnit_Indicator__c oInd: newMap.values()){
            set<string> tempFreqs = new Set<string>();
            if(imRecordTypeId == oInd.RecordTypeId){
                if (imDistinctFreqs.containsKey(oInd.Implementing_Mechanism_id__c)){
                    tempFreqs = imDistinctFreqs.get(oInd.Implementing_Mechanism_id__c);
                }
                tempFreqs.add(oInd.collection_frequency__c);
                imDistinctFreqs.put(oInd.Implementing_Mechanism_id__c,tempFreqs);
            }
        }   
        List<Reporting_Period__c> updPeriods = new List<Reporting_Period__c>();
        for(Reporting_Period__c rp: [Select Id, Name, indicators_established__c,Frequency__c,Implementing_mechanism_id__c
                                     From Reporting_Period__c 
                                     Where Implementing_mechanism_id__c in : imDistinctFreqs.keySet()]){
            if(imDistinctFreqs.containsKey(rp.Implementing_mechanism_id__c)){
                if(imDistinctFreqs.get(rp.Implementing_mechanism_id__c).contains(rp.frequency__c)){
                    rp.indicators_established__c = true;
                    updPeriods.add(rp);
                }
            }                             
            
        }   
        
        if (!updPeriods.isEmpty()){
            ApplicationConstants.bypassReportingPeriodBeforeUpsertQOwner = true;
            ApplicationConstants.bypassReportingPeriodApprovalLogic = true;
            List<Database.SaveResult> SR =  Database.update(updPeriods,false);
            ApplicationConstants.bypassReportingPeriodBeforeUpsertQOwner = false;
            ApplicationConstants.bypassReportingPeriodApprovalLogic = false;
        }
    
    }
    
    
    
    public static void ReportingPeriodFlagsAfterOrgIndicatorDelete(Map<Id,OrgUnit_Indicator__c> oldMap){
        Map<Id,set<string>> imDistinctFreqs = new Map<Id,set<string>>();
        Id imRecordTypeId = Schema.SObjectType.OrgUnit_Indicator__c.getRecordTypeInfosByName().get('Implementing Mechanism').getRecordTypeId();

        for(OrgUnit_Indicator__c oInd: oldMap.values()){
            set<string> tempFreqs = new Set<string>();
            if(imRecordTypeId == oInd.RecordTypeId){
                if (imDistinctFreqs.containsKey(oInd.Implementing_Mechanism_id__c)){
                    tempFreqs = imDistinctFreqs.get(oInd.Implementing_Mechanism_id__c);
                }
                tempFreqs.add(oInd.collection_frequency__c);
                imDistinctFreqs.put(oInd.Implementing_Mechanism_id__c,tempFreqs);
            }
        }   
        
        Map<Id,set<string>> remainIMDistinctFreqs = new Map<Id,set<string>>();
        for(OrgUnit_Indicator__c oInd: [Select Id, Name, Implementing_mechanism_id__c, Collection_Frequency__c, 
                                        RecordTypeId
                                        From OrgUnit_Indicator__c
                                        Where Implementing_mechanism_id__c in : imDistinctFreqs.keySet()]){
            set<string> tempFreqs = new Set<string>();
            if(imRecordTypeId == oInd.RecordTypeId){
                if (remainIMDistinctFreqs.containsKey(oInd.Implementing_Mechanism_id__c)){
                    tempFreqs = remainIMDistinctFreqs.get(oInd.Implementing_Mechanism_id__c);
                }
                tempFreqs.add(oInd.collection_frequency__c);
                remainIMDistinctFreqs.put(oInd.Implementing_Mechanism_id__c,tempFreqs);
            }
        
        }
        
        List<Reporting_Period__c> updPeriods = new List<Reporting_Period__c>();
        for(Reporting_Period__c rp: [Select Id, Name, indicators_established__c,Frequency__c,Implementing_mechanism_id__c
                                     From Reporting_Period__c 
                                     Where Implementing_mechanism_id__c in : imDistinctFreqs.keySet()]){
            if(imDistinctFreqs.containsKey(rp.Implementing_mechanism_id__c)){
                if(imDistinctFreqs.get(rp.Implementing_mechanism_id__c).contains(rp.frequency__c) && 
                    !remainIMDistinctFreqs.get(rp.Implementing_mechanism_id__c).contains(rp.frequency__c) ){
                    rp.indicators_established__c = false;
                    updPeriods.add(rp);
                }
            }                             
            
        }   
        
        if (!updPeriods.isEmpty()){
            List<Database.SaveResult> SR =  Database.update(updPeriods,false);
        }      
    
    }
    

}