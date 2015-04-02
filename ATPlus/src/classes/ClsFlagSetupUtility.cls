public with sharing class ClsFlagSetupUtility {
    clsGlobalUtility GU = new clsGlobalUtility();
    private String userOrgUnit;
    private OrgUnit__c orgUnit;
    private Map<String,Integer> rfResultsMap = new Map<String,Integer>();
    private Map<String,Integer> rfTargetsMap = new Map<String,Integer>();
    private Map<String,Integer> rfActualsMap = new Map<String,Integer>();
    
    private Map<String,Integer> lfResultsMap = new Map<String,Integer>();
    private Map<String,Integer> lfTargetsMap = new Map<String,Integer>();
    private Map<String,Integer> lfActualsMap = new Map<String,Integer>();
    
    private Map<String,Integer> imResultsMap = new Map<String,Integer>();
    private Map<String,Integer> imTargetsMap = new Map<String,Integer>();
    private Map<String,Integer> imActualsMap = new Map<String,Integer>();
    
    private Map<String,Integer> rfRPResultsMap = new Map<String,Integer>();
    private Map<String,Integer> rfRPTargetsMap = new Map<String,Integer>();
    private Map<String,Integer> rfRPActualsMap = new Map<String,Integer>();
    
    private Map<String,Integer> lfRPResultsMap = new Map<String,Integer>();
    private Map<String,Integer> lfRPTargetsMap = new Map<String,Integer>();
    private Map<String,Integer> lfRPActualsMap = new Map<String,Integer>();
    
    private Map<String,Integer> imRPResultsMap = new Map<String,Integer>();
    private Map<String,Integer> imRPTargetsMap = new Map<String,Integer>();
    private Map<String,Integer> imRPActualsMap = new Map<String,Integer>(); 
    
    private Map<String,OrgUnit_Indicator__c> orgUnitIndicators = new Map<String,OrgUnit_Indicator__c>();
    private Map<String,RF_Reporting_Period__c> rfPeriods = new Map<String,RF_Reporting_Period__c>();
    private Map<String,LF_Reporting_Period__c> lfPeriods = new Map<String,LF_Reporting_Period__c>();
    private Map<String,Reporting_Period__c> imPeriods = new Map<String,Reporting_Period__c>();  
    
    private set<Id> oruUnits = new set<Id>();
    private set<Id> rfGoals = new set<Id>();
    private set<Id> rfDOs = new set<Id>();
    private set<Id> rfIRs = new set<Id>();
    private set<Id> rfSIRs = new set<Id>();
        
    private set<Id> lfGoals = new set<Id>();
    private set<Id> lfPurposes = new set<Id>();
    private set<Id> lfSubPurposes = new set<Id>();
    private set<Id> lfOutputs = new set<Id>();
    private set<Id> lfInputs = new set<Id>();
    
    private set<Id> oiMasters = new set<Id>();              
    private set<Id> ims = new set<Id>();
    
    private Map<Id,OrgUnit__c> orgUnitsMap = new Map<Id,OrgUnit__c>();
    private Map<Id,CDCSGoal__c> rfGoalsMap = new Map<Id,CDCSGoal__c>();
    private Map<Id,DO__c> rfDOsMap = new Map<Id,DO__c>();
    private Map<Id,IR__c> rfIRsMap = new Map<Id,IR__c>();
    private Map<Id,Sub_IR__c> rfSIRsMap = new Map<Id,Sub_IR__c>();
        
    private Map<Id,LF_Goal__c> lfGoalsMap = new Map<Id,LF_Goal__c>();
    private Map<Id,LF_Purpose__c> lfPurposesMap = new Map<Id,LF_Purpose__c>();
    private Map<Id,LF_SubPurpose__c> lfSubPurposesMap = new Map<Id,LF_SubPurpose__c>();
    private Map<Id,LF_Output__c> lfOutputsMap = new Map<Id,LF_Output__c>();
    private Map<Id,LF_Input__c> lfInputsMap = new Map<Id,LF_Input__c>();
    
                    
    private Map<Id,Implementing_Mechanism__c> imsMap = new Map<Id,Implementing_Mechanism__c>();
    
    private Map<Id,OrgUnit_Indicator__c> oiMastersMap = new Map<Id,OrgUnit_Indicator__c>();
    
    private Map<String, Integer> recordOIcountMap = new Map<String,Integer>();
    
    
    public void ClsFlagSetupUtility(){      
    }
    
    public void setupOrgUnit(String orgUnit){
        userOrgUnit = orgUnit;      
    }
    
    public void setupResultsCounterMaps(Set<Id> OrgUnitIds, Boolean isMasterIndicators){
        
        //userOrgUnit = GU.getUserRole();
        system.debug('User Role From FlagSeupUtility:::'+userOrgUnit);
        String fStr = ' WHERE ouCode__c = \'' +userOrgUnit + '\'';
        List<SObject> ouIndicators =  GU.lookupWithFilter(fStr,'OrgUnit_Indicator__c'); 
        for(SObject sObj: ouIndicators){
            OrgUnit_Indicator__c oInd = (OrgUnit_Indicator__c)sObj;
            orgUnitIndicators.put(oInd.Id,oInd);            
        } 
        
        String queryRFResultsStr;
        String queryRFTargetsStr;
        String queryRFActualsStr;
        
        String queryLFResultsStr;
        String queryLFTargetsStr;
        String queryLFActualsStr;
        
        String queryIMResultsStr;
        String queryIMTargetsStr;
        String queryIMActualsStr;
                
        if (!orgUnitIds.isEmpty()){         
            if (isMasterIndicators){
                queryRFResultsStr = 'Select Organization_Indicator_Master_Id__c oIndId, count(Id) cnt From RF_Indicator_Result__c WHERE Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and Organization_Indicator_Master_Id__c in '+GU.prepareINclause(orgUnitIds)+' group By Organization_Indicator_Master_Id__c';
                queryRFTargetsStr = 'Select Organization_Indicator_Master_Id__c oIndId, count(Id) cnt From RF_Indicator_Result__c WHERE Target__c != null and Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and Organization_Indicator_Master_Id__c in '+GU.prepareINclause(orgUnitIds)+' group By Organization_Indicator_Master_Id__c';
                queryRFActualsStr = 'Select Organization_Indicator_Master_Id__c oIndId, count(Id) cnt From RF_Indicator_Result__c WHERE Actual__c != null and Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and Organization_Indicator_Master_Id__c in '+GU.prepareINclause(orgUnitIds)+' group By Organization_Indicator_Master_Id__c';
                
                queryLFResultsStr = 'Select Organization_Indicator_Master_Id__c oIndId, count(Id) cnt From LF_Indicator_Result__c WHERE Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and Organization_Indicator_Master_Id__c in '+GU.prepareINclause(orgUnitIds)+' group By Organization_Indicator_Master_Id__c';
                queryLFTargetsStr = 'Select Organization_Indicator_Master_Id__c oIndId, count(Id) cnt From LF_Indicator_Result__c WHERE Target__c != null and Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and Organization_Indicator_Master_Id__c in '+GU.prepareINclause(orgUnitIds)+' group By Organization_Indicator_Master_Id__c';
                queryLFActualsStr = 'Select Organization_Indicator_Master_Id__c oIndId, count(Id) cnt From LF_Indicator_Result__c WHERE Actual__c != null and Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and Organization_Indicator_Master_Id__c in '+GU.prepareINclause(orgUnitIds)+' group By Organization_Indicator_Master_Id__c';
                
                queryIMResultsStr = 'Select Organization_Indicator_Master_Id__c oIndId, count(Id) cnt From Indicator_Results__c WHERE Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and Organization_Indicator_Master_Id__c in '+GU.prepareINclause(orgUnitIds)+' group By Organization_Indicator_Master_Id__c';
                queryIMTargetsStr = 'Select Organization_Indicator_Master_Id__c oIndId, count(Id) cnt From Indicator_Results__c WHERE Target__c != null and Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and Organization_Indicator_Master_Id__c in '+GU.prepareINclause(orgUnitIds)+' group By Organization_Indicator_Master_Id__c';
                queryIMActualsStr = 'Select Organization_Indicator_Master_Id__c oIndId, count(ID) cnt From Indicator_Results__c WHERE Actual__c != null and Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and Organization_Indicator_Master_Id__c in '+GU.prepareINclause(orgUnitIds)+' group By Organization_Indicator_Master_Id__c';
                
            } else {
                queryRFResultsStr = 'Select Organization_Indicator_Id__c oIndId, count(Id) cnt From RF_Indicator_Result__c  WHERE Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and Organization_Indicator_Id__c in '+GU.prepareINclause(orgUnitIds) +' group By Organization_Indicator_Id__c';
                queryRFTargetsStr = 'Select Organization_Indicator_Id__c oIndId, count(Id) cnt From RF_Indicator_Result__c  WHERE Target__c != null and Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and Organization_Indicator_Id__c in '+GU.prepareINclause(orgUnitIds) +' group By Organization_Indicator_Id__c';
                queryRFActualsStr = 'Select Organization_Indicator_Id__c oIndId, count(Id) cnt From RF_Indicator_Result__c  WHERE Actual__c != null and Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and Organization_Indicator_Id__c in '+GU.prepareINclause(orgUnitIds) +' group By Organization_Indicator_Id__c';
                
                queryLFResultsStr = 'Select Organization_Indicator_Id__c oIndId, count(Id) cnt From LF_Indicator_Result__c  WHERE Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and Organization_Indicator_Id__c in '+GU.prepareINclause(orgUnitIds) +' group By Organization_Indicator_Id__c';
                queryLFTargetsStr = 'Select Organization_Indicator_Id__c oIndId, count(Id) cnt From LF_Indicator_Result__c  WHERE Target__c != null and Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and Organization_Indicator_Id__c in '+GU.prepareINclause(orgUnitIds) +' group By Organization_Indicator_Id__c';
                queryLFActualsStr = 'Select Organization_Indicator_Id__c oIndId, count(Id) cnt From LF_Indicator_Result__c  WHERE Actual__c != null and Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and Organization_Indicator_Id__c in '+GU.prepareINclause(orgUnitIds) +' group By Organization_Indicator_Id__c';
                
                queryIMResultsStr = 'Select Organization_Indicator_Id__c oIndId, count(Id) cnt From Indicator_Results__c  WHERE Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and Organization_Indicator_Id__c in '+GU.prepareINclause(orgUnitIds) +' group By Organization_Indicator_Id__c';
                queryIMTargetsStr = 'Select Organization_Indicator_Id__c oIndId, count(Id) cnt From Indicator_Results__c  WHERE Target__c != null and Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and Organization_Indicator_Id__c in '+GU.prepareINclause(orgUnitIds) +' group By Organization_Indicator_Id__c';
                queryIMActualsStr = 'Select Organization_Indicator_Id__c oIndId, count(Id) cnt From Indicator_Results__c  WHERE Actual__c != null and Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and Organization_Indicator_Id__c in '+GU.prepareINclause(orgUnitIds) +' group By Organization_Indicator_Id__c';
                
                
            }   
            
            System.debug('Results Query String::' +queryRFResultsStr);
            for (AggregateResult c : Database.query(queryRFResultsStr)) {
                rfResultsMap.put((String)c.get('oIndId'),(Integer)c.get('cnt'));                
            }
            System.debug('Results Query String::' +queryRFTargetsStr);          
            for (AggregateResult c : Database.query(queryRFTargetsStr)) {
                rfTargetsMap.put((String)c.get('oIndId'),(Integer)c.get('cnt'));                
            }
            System.debug('Results Query String::' +queryRFActualsStr);          
            for (AggregateResult c : Database.query(queryRFActualsStr)) {
                rfActualsMap.put((String)c.get('oIndId'),(Integer)c.get('cnt'));                
            }
            
            
            for (AggregateResult c : Database.query(queryLFResultsStr)) {
                lfResultsMap.put((String)c.get('oIndId'),(Integer)c.get('cnt'));                
            }           
            for (AggregateResult c : Database.query(queryLFTargetsStr)) {
                lfTargetsMap.put((String)c.get('oIndId'),(Integer)c.get('cnt'));                
            }           
            for (AggregateResult c : Database.query(queryLFActualsStr)) {
                lfActualsMap.put((String)c.get('oIndId'),(Integer)c.get('cnt'));                
            }
            
            
            for (AggregateResult c : Database.query(queryIMResultsStr)) {
                imResultsMap.put((String)c.get('oIndId'),(Integer)c.get('cnt'));                
            }           
            for (AggregateResult c : Database.query(queryIMTargetsStr)) {
                imTargetsMap.put((String)c.get('oIndId'),(Integer)c.get('cnt'));                
            }           
            for (AggregateResult c : Database.query(queryIMActualsStr)) {
                imActualsMap.put((String)c.get('oIndId'),(Integer)c.get('cnt'));                
            }
            
            
        }
        
    }
    
    public void setupRFPeriodsCounterMaps(Set<Id> periodIds){
        
        String fStr = ' WHERE ouCode__c = \'' +userOrgUnit + '\'';
        List<SObject> rPeriods =  GU.lookupWithFilter(fStr,'RF_Reporting_Period__c');   
        for(SObject sObj: rPeriods){
            RF_Reporting_Period__c rPeriod = (RF_Reporting_Period__c)sObj;
            rfPeriods.put(rPeriod.Id,rPeriod);          
        }
        
        String queryRFRPResultsStr;
        String queryRFRPTargetsStr;
        String queryRFRPActualsStr;
        
        queryRFRPResultsStr = 'Select RF_Reporting_Period_Id__c rpId, count(Id) cnt From RF_Indicator_Result__c  WHERE Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and RF_Reporting_Period_Id__c in '+GU.prepareINclause(periodIds) +' group By RF_Reporting_Period_Id__c';
        queryRFRPTargetsStr = 'Select RF_Reporting_Period_Id__c rpId, count(Id) cnt From RF_Indicator_Result__c  WHERE Target__c != null and Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and RF_Reporting_Period_Id__c in '+GU.prepareINclause(periodIds) +' group By RF_Reporting_Period_Id__c';
        queryRFRPActualsStr = 'Select RF_Reporting_Period_Id__c rpId, count(Id) cnt From RF_Indicator_Result__c  WHERE Actual__c != null and Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and RF_Reporting_Period_Id__c in '+GU.prepareINclause(periodIds) +' group By RF_Reporting_Period_Id__c';
        
        
        System.debug('Results Query String::' +queryRFRPResultsStr);
        for (AggregateResult c : Database.query(queryRFRPResultsStr)) {
            rfRPResultsMap.put((String)c.get('rpId'),(Integer)c.get('cnt'));                
        }
        System.debug('Results Query String::' +queryRFRPTargetsStr);            
        for (AggregateResult c : Database.query(queryRFRPTargetsStr)) {
            rfRPTargetsMap.put((String)c.get('rpId'),(Integer)c.get('cnt'));                
        }
        System.debug('Results Query String::' +queryRFRPActualsStr);            
        for (AggregateResult c : Database.query(queryRFRPActualsStr)) {
            rfRPActualsMap.put((String)c.get('rpId'),(Integer)c.get('cnt'));                
        }       
                
    }
    
    public void setupLFPeriodsCounterMaps(Set<Id> periodIds){
        String fStr = ' WHERE ouCode__c = \'' +userOrgUnit + '\'';
        List<SObject> lPeriods =  GU.lookupWithFilter(fStr,'LF_Reporting_Period__c');   
        for(SObject sObj: lPeriods){
            LF_Reporting_Period__c lPeriod = (LF_Reporting_Period__c)sObj;
            lfPeriods.put(lPeriod.Id,lPeriod);          
        }
        
        String queryLFRPResultsStr;
        String queryLFRPTargetsStr;
        String queryLFRPActualsStr;
        
        queryLFRPResultsStr = 'Select LF_Reporting_Period_Id__c rpId, count(Id) cnt From LF_Indicator_Result__c  WHERE Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and LF_Reporting_Period_Id__c in '+GU.prepareINclause(periodIds) +' group By LF_Reporting_Period_Id__c';
        queryLFRPTargetsStr = 'Select LF_Reporting_Period_Id__c rpId, count(Id) cnt From LF_Indicator_Result__c  WHERE Target__c != null and Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and LF_Reporting_Period_Id__c in '+GU.prepareINclause(periodIds) +' group By LF_Reporting_Period_Id__c';
        queryLFRPActualsStr = 'Select LF_Reporting_Period_Id__c rpId, count(Id) cnt From LF_Indicator_Result__c  WHERE Actual__c != null and Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and LF_Reporting_Period_Id__c in '+GU.prepareINclause(periodIds) +' group By LF_Reporting_Period_Id__c';
        
        for (AggregateResult c : Database.query(queryLFRPResultsStr)) {
            lfRPResultsMap.put((String)c.get('rpId'),(Integer)c.get('cnt'));                
        }           
        for (AggregateResult c : Database.query(queryLFRPTargetsStr)) {
            lfRPTargetsMap.put((String)c.get('rpId'),(Integer)c.get('cnt'));                
        }           
        for (AggregateResult c : Database.query(queryLFRPActualsStr)) {
            lfRPActualsMap.put((String)c.get('rpId'),(Integer)c.get('cnt'));                
        }
        
    }
    
    public void setupIMPeriodsCounterMaps(Set<Id> periodIds){
        String fStr = ' WHERE ouCode__c = \'' +userOrgUnit + '\'';
        List<SObject> iPeriods =  GU.lookupWithFilter(fStr,'Reporting_Period__c');  
        for(SObject sObj: iPeriods){
            Reporting_Period__c iPeriod = (Reporting_Period__c)sObj;
            imPeriods.put(iPeriod.Id,iPeriod);          
        }       
        
        String queryIMRPResultsStr;
        String queryIMRPTargetsStr;
        String queryIMRPActualsStr;     
        
        queryIMRPResultsStr = 'Select Reporting_Period_Id__c rpId, count(Id) cnt From Indicator_Results__c  WHERE Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and Reporting_Period_Id__c in '+GU.prepareINclause(periodIds) +' group By Reporting_Period_Id__c';
        queryIMRPTargetsStr = 'Select Reporting_Period_Id__c rpId, count(Id) cnt From Indicator_Results__c  WHERE Target__c != null and Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and Reporting_Period_Id__c in '+GU.prepareINclause(periodIds) +' group By Reporting_Period_Id__c';
        queryIMRPActualsStr = 'Select Reporting_Period_Id__c rpId, count(Id) cnt From Indicator_Results__c  WHERE Actual__c != null and Organization_Indicator_Id__r.ouCode__c = \''+ userOrgUnit+ '\' and Reporting_Period_Id__c in '+GU.prepareINclause(periodIds) +' group By Reporting_Period_Id__c';
        
        for (AggregateResult c : Database.query(queryIMRPResultsStr)) {
            imRPResultsMap.put((String)c.get('rpId'),(Integer)c.get('cnt'));                
        }           
        for (AggregateResult c : Database.query(queryIMRPTargetsStr)) {
            imRPTargetsMap.put((String)c.get('rpId'),(Integer)c.get('cnt'));                
        }           
        for (AggregateResult c : Database.query(queryIMRPActualsStr)) {
            imRPActualsMap.put((String)c.get('rpId'),(Integer)c.get('cnt'));                
        }
        
    }
    public OrgUnit_Indicator__c setupIndicatorFlags(Id orgUnitId){
        OrgUnit_Indicator__c oInd = orgUnitIndicators.get(orgUnitId);
        oInd.Results_Established__c = isIndicatorResultsFlag(orgUnitId);
        oInd.Targets_Established__c = isIndicatorTargetsFlag(orgUnitId);
        oInd.Actuals_Recorded__c = isIndicatorActualsFlag(orgUnitId);
        
        return oInd;
    }
    
    
    public RF_Reporting_Period__c setupRFPeriodFlags(Id periodId){
        RF_Reporting_Period__c rPeriod = rfPeriods.get(periodId);
        rPeriod.Results_Established__c = isPeriodResultsFlag(periodId,'RF_Reporting_Period__c');
        rPeriod.Targets_Established__c = isPeriodTargetsFlag(periodId,'RF_Reporting_Period__c');
        rPeriod.Actuals_Recorded__c = isPeriodActualsFlag(periodId,'RF_Reporting_Period__c');
        
        return rPeriod;
    }   
    
    public LF_Reporting_Period__c setupLFPeriodFlags(Id periodId){
        LF_Reporting_Period__c lPeriod = lfPeriods.get(periodId);
        lPeriod.Results_Established__c = isPeriodResultsFlag(periodId,'LF_Reporting_Period__c');
        lPeriod.Targets_Established__c = isPeriodTargetsFlag(periodId,'LF_Reporting_Period__c');
        lPeriod.Actuals_Recorded__c = isPeriodActualsFlag(periodId,'LF_Reporting_Period__c');
        
        return lPeriod;
    }
    
    public Reporting_Period__c setupIMPeriodFlags(Id periodId){
        Reporting_Period__c iPeriod = imPeriods.get(periodId);
        iPeriod.Results_Established__c = isPeriodResultsFlag(periodId,'Reporting_Period__c');
        iPeriod.Targets_Established__c = isPeriodTargetsFlag(periodId,'Reporting_Period__c');
        iPeriod.Actuals_Recorded__c = isPeriodActualsFlag(periodId,'Reporting_Period__c');      
        return iPeriod;
    }
    
    public void indicatorsEstablishedFlagSetup(Map<Id,OrgUnit_Indicator__c> oIndMap){   
        
        Map<String,String> recTypesMap = GU.getRecordTypeByObject('OrgUnit_Indicator__c');
        Map<String,String> recTypesMapRev = new Map<String,String>();
        for(String Key: recTypesMap.keySet()){
            recTypesMapRev.put(recTypesMap.get(Key),Key);       
        }   
        
        
        String queryStr;
        String filterStr;
        for(OrgUnit_Indicator__c oInd:oIndMap.values()){
            if(oInd.Organization_Indicator_Id__c != null){
                oiMasters.add(oInd.Organization_Indicator_Id__c);
            }
            
            if (recTypesMapRev.get(oInd.RecordTypeId).equalsIgnoreCase('Master')){
                oruUnits.add(oInd.ouId__c);             
            } else if(recTypesMapRev.get(oInd.RecordTypeId).equalsIgnoreCase('RF Goal')) {
                rfGoals.add(oInd.Goal_Id__c);                               
            } else if(recTypesMapRev.get(oInd.RecordTypeId).equalsIgnoreCase('RF DO')) {
                rfDos.add(oInd.Do_Id__c);               
            } else if(recTypesMapRev.get(oInd.RecordTypeId).equalsIgnoreCase('RF IR')) {
                rfIRs.add(oInd.IR_Id__c);
            } else if(recTypesMapRev.get(oInd.RecordTypeId).equalsIgnoreCase('RF SUB IR')) {
                rfSIRs.add(oInd.SIR_Id__c);
            } else if(recTypesMapRev.get(oInd.RecordTypeId).equalsIgnoreCase('LF Goal')) {
                lfGoals.add(oInd.LF_Goal_Id__c);
            } else if(recTypesMapRev.get(oInd.RecordTypeId).equalsIgnoreCase('LF Purpose')) {
                lfPurposes.add(oInd.LF_Purpose_Id__c);
            } else if(recTypesMapRev.get(oInd.RecordTypeId).equalsIgnoreCase('LF Sub-Purpose')) {
                lfSubPurposes.add(oInd.LF_SubPurpose_Id__c);
            } else if(recTypesMapRev.get(oInd.RecordTypeId).equalsIgnoreCase('LF Output')) {
                lfOutputs.add(oInd.LF_Output_Id__c);
            } else if(recTypesMapRev.get(oInd.RecordTypeId).equalsIgnoreCase('LF Input')) {
                lfInputs.add(oInd.LF_Input_Id__c);
            } else if(recTypesMapRev.get(oInd.RecordTypeId).equalsIgnoreCase('Implementing Mechanism')) {
                ims.add(oInd.Implementing_Mechanism_Id__c);
            } 
            
        }       
        
        //String queryStr;      
        //String filterStr;
        if(!oruUnits.isEmpty()){
            queryStr = 'Select ouId__c mId, count(Id) cnt from OrgUnit_Indicator__c where ouId__c in ' +GU.prepareINclause(oruUnits) + 'Group by ouId__c' ;
            for(AggregateResult ar : Database.query(queryStr)){
                recordOIcountMap.put((String)ar.get('mId'),(Integer)ar.get('cnt'));
            }
            filterStr = ' Where Id in ' + GU.prepareINclause(oruUnits); 
            List<SObject> sObjList = GU.lookupWithFilter(filterStr,'OrgUnit__c');   
            for(SObject so: sObjList){
                OrgUnit__c ou = (OrgUnit__c) so;
                if (!recordOIcountMap.containsKey(ou.Id)){                  
                    ou.Indicators_Established__c = false;
                    orgUnitsMap.put(ou.Id,ou);
                }               
            }
            ApplicationConstants.bypassOrgUnitIndicatorAfterDelete = true;
            ApplicationConstants.bypassOrgUnitIndicatorUpsertShare = true;
            upsert orgUnitsMap.values();
            ApplicationConstants.bypassOrgUnitIndicatorAfterDelete = false;
            ApplicationConstants.bypassOrgUnitIndicatorUpsertShare = false;
        }
        
        if(!rfGoals.isEmpty()){
            queryStr = 'Select Goal_Id__c mId, count(Id) cnt from OrgUnit_Indicator__c where Goal_Id__c in ' +GU.prepareINclause(rfGoals) + 'Group by Goal_Id__c' ;
            for(AggregateResult ar : Database.query(queryStr)){
                recordOIcountMap.put((String)ar.get('mId'),(Integer)ar.get('cnt'));
            }
            filterStr = ' Where Id in ' + GU.prepareINclause(rfGoals);  
            List<SObject> sObjList = GU.lookupWithFilter(filterStr,'CDCSGoal__c');  
            for(SObject so: sObjList){
                CDCSGoal__c g = (CDCSGoal__c) so;
                if (!recordOIcountMap.containsKey(g.Id)){                   
                    g.Indicators_Established__c = false;
                    rfGoalsMap.put(g.Id,g);
                }               
            }
            ApplicationConstants.byPassGoalAfterUpdate = true;
            ApplicationConstants.byPassGoalBeforeUpsertQowner = true;
            upsert rfGoalsMap.values();
            ApplicationConstants.byPassGoalAfterUpdate = false;
            ApplicationConstants.byPassGoalBeforeUpsertQowner = false;
        }
        
        if(!rfDos.isEmpty()){
            queryStr = 'Select Do_Id__c mId, count(Id) cnt from OrgUnit_Indicator__c where Do_Id__c in ' +GU.prepareINclause(rfDos) + 'Group by Do_Id__c' ;
            for(AggregateResult ar : Database.query(queryStr)){
                recordOIcountMap.put((String)ar.get('mId'),(Integer)ar.get('cnt'));
            }
            filterStr = ' Where Id in ' + GU.prepareINclause(rfDos);    
            List<SObject> sObjList = GU.lookupWithFilter(filterStr,'Do__c');    
            for(SObject so: sObjList){
                DO__c d = (DO__c) so;
                if (!recordOIcountMap.containsKey(d.Id)){                   
                    d.Indicators_Established__c = false;
                    rfDosMap.put(d.Id,d);   
                }               
            }
            upsert rfDosMap.values();
        }
        
        if(!rfIRs.isEmpty()){
            queryStr = 'Select IR_Id__c mId, count(Id) cnt from OrgUnit_Indicator__c where IR_Id__c in ' +GU.prepareINclause(rfIRs) + 'Group by IR_Id__c' ;
            for(AggregateResult ar : Database.query(queryStr)){
                recordOIcountMap.put((String)ar.get('mId'),(Integer)ar.get('cnt'));
            }
            filterStr = ' Where Id in ' + GU.prepareINclause(rfIRs);    
            List<SObject> sObjList = GU.lookupWithFilter(filterStr,'IR__c');    
            for(SObject so: sObjList){
                IR__c i = (IR__c) so;
                if (!recordOIcountMap.containsKey(i.Id)){                   
                    i.Indicators_Established__c = false;
                    rfIRsMap.put(i.Id,i);   
                }                   
            }
            upsert rfIRsMap.values();
        }
        
        if(!rfSIRs.isEmpty()){
            queryStr = 'Select SIR_Id__c mId, count(Id) cnt from OrgUnit_Indicator__c where SIR_Id__c in ' +GU.prepareINclause(rfSIRs) + 'Group by SIR_Id__c' ;
            for(AggregateResult ar : Database.query(queryStr)){
                recordOIcountMap.put((String)ar.get('mId'),(Integer)ar.get('cnt'));
            }
            filterStr = ' Where Id in ' + GU.prepareINclause(rfSIRs);   
            List<SObject> sObjList = GU.lookupWithFilter(filterStr,'Sub_IR__c');    
            for(SObject so: sObjList){
                Sub_IR__c sir = (Sub_IR__c) so; 
                if (!recordOIcountMap.containsKey(sir.Id)){                 
                    sir.Indicators_Established__c = false;
                    rfSIRsMap.put(sir.Id,sir);  
                }               
            }
            upsert rfSIRsMap.values();
        }
        
        
        if(!lfGoals.isEmpty()){
            queryStr = 'Select LF_Goal_Id__c mId, count(Id) cnt from OrgUnit_Indicator__c where LF_Goal_Id__c in ' +GU.prepareINclause(lfGoals) + 'Group by LF_Goal_Id__c' ;
            for(AggregateResult ar : Database.query(queryStr)){
                recordOIcountMap.put((String)ar.get('mId'),(Integer)ar.get('cnt'));
            }
            filterStr = ' Where Id in ' + GU.prepareINclause(lfGoals);  
            List<SObject> sObjList = GU.lookupWithFilter(filterStr,'LF_Goal__c');   
            for(SObject so: sObjList){
                LF_Goal__c lg = (LF_Goal__c) so;
                if (!recordOIcountMap.containsKey(lg.Id)){                  
                    lg.Indicators_Established__c = false;
                    lfGoalsMap.put(lg.Id,lg);   
                }                   
            }
            ApplicationConstants.byPassLFGoalBeforeUpsertQOwner = true;
            ApplicationConstants.byPassLFGoalAfterUpdate = true;
            upsert lfGoalsMap.values();
            ApplicationConstants.byPassLFGoalBeforeUpsertQOwner = false;
            ApplicationConstants.byPassLFGoalAfterUpdate = false;
        }
        
        if(!lfPurposes.isEmpty()){
            queryStr = 'Select LF_Purpose_Id__c mId, count(Id) cnt from OrgUnit_Indicator__c where LF_Purpose_Id__c in ' +GU.prepareINclause(lfPurposes) + 'Group by LF_Purpose_Id__c' ;
            for(AggregateResult ar : Database.query(queryStr)){
                recordOIcountMap.put((String)ar.get('mId'),(Integer)ar.get('cnt'));
            }
            filterStr = ' Where Id in ' + GU.prepareINclause(lfPurposes);   
            List<SObject> sObjList = GU.lookupWithFilter(filterStr,'LF_Purpose__c');    
            for(SObject so: sObjList){
                LF_Purpose__c lp = (LF_Purpose__c) so;
                if (!recordOIcountMap.containsKey(lp.Id)){                  
                    lp.Indicators_Established__c = false;
                    lfPurposesMap.put(lp.Id,lp);    
                }                   
            }
            upsert lfPurposesMap.values();
        }
        
        if(!lfSubPurposes.isEmpty()){
            queryStr = 'Select LF_SubPurpose_Id__c mId, count(Id) cnt from OrgUnit_Indicator__c where LF_SubPurpose_Id__c in ' +GU.prepareINclause(lfSubPurposes) + 'Group by LF_SubPurpose_Id__c' ;
            for(AggregateResult ar : Database.query(queryStr)){
                recordOIcountMap.put((String)ar.get('mId'),(Integer)ar.get('cnt'));
            }
            filterStr = ' Where Id in ' + GU.prepareINclause(lfSubPurposes);    
            List<SObject> sObjList = GU.lookupWithFilter(filterStr,'LF_SubPurpose__c'); 
            for(SObject so: sObjList){
                LF_SubPurpose__c lsp = (LF_SubPurpose__c) so;   
                if (!recordOIcountMap.containsKey(lsp.Id)){                 
                    lsp.Indicators_Established__c = false;
                    lfSubPurposesMap.put(lsp.Id,lsp);   
                }               
            }
            upsert lfSubPurposesMap.values();
        }
        
        if(!lfOutputs.isEmpty()){
            queryStr = 'Select LF_Output_Id__c mId, count(Id) cnt from OrgUnit_Indicator__c where LF_Output_Id__c in ' +GU.prepareINclause(lfOutputs) + 'Group by LF_Output_Id__c' ;
            for(AggregateResult ar : Database.query(queryStr)){
                recordOIcountMap.put((String)ar.get('mId'),(Integer)ar.get('cnt'));
            }
            filterStr = ' Where Id in ' + GU.prepareINclause(lfOutputs);    
            List<SObject> sObjList = GU.lookupWithFilter(filterStr,'LF_Output__c'); 
            for(SObject so: sObjList){
                LF_Output__c lo = (LF_Output__c) so;
                if (!recordOIcountMap.containsKey(lo.Id)){                  
                    lo.Indicators_Established__c = false;
                    lfOutputsMap.put(lo.Id,lo); 
                }               
            }
            upsert lfOutputsMap.values();
        }
        
        if(!lfInputs.isEmpty()){
            queryStr = 'Select LF_Input_Id__c mId, count(Id) cnt from OrgUnit_Indicator__c where LF_Input_Id__c in ' +GU.prepareINclause(lfInputs) + 'Group by LF_Input_Id__c' ;
            for(AggregateResult ar : Database.query(queryStr)){
                recordOIcountMap.put((String)ar.get('mId'),(Integer)ar.get('cnt'));
            }
            filterStr = ' Where Id in ' + GU.prepareINclause(lfInputs); 
            List<SObject> sObjList = GU.lookupWithFilter(filterStr,'LF_Input__c');  
            for(SObject so: sObjList){
                LF_Input__c li = (LF_Input__c) so;  
                if (!recordOIcountMap.containsKey(li.Id)){                  
                    li.Indicators_Established__c = false;
                    lfInputsMap.put(li.Id,li);  
                }               
            }
            upsert lfInputsMap.values();
        }
        
        if(!ims.isEmpty()){
            queryStr = 'Select Implementing_Mechanism_Id__c mId, count(Id) cnt from OrgUnit_Indicator__c where Implementing_Mechanism_Id__c in ' +GU.prepareINclause(ims) + 'Group by Implementing_Mechanism_Id__c' ;
            for(AggregateResult ar : Database.query(queryStr)){
                recordOIcountMap.put((String)ar.get('mId'),(Integer)ar.get('cnt'));
            }
            filterStr = ' Where Id in ' + GU.prepareINclause(ims);  
            List<SObject> sObjList = GU.lookupWithFilter(filterStr,'Implementing_Mechanism__c');    
            for(SObject so: sObjList){
                Implementing_Mechanism__c im = (Implementing_Mechanism__c) so;  
                if (!recordOIcountMap.containsKey(im.Id)){                  
                    im.Indicators_Established__c = false;
                    imsMap.put(im.Id,im);   
                }
            }
            upsert imsMap.values();
        }
        
        
        if(!oiMasters.isEmpty()){
            queryStr = 'Select Organization_Indicator_Id__c mId, count(Id) cnt from OrgUnit_Indicator__c where Organization_Indicator_Id__c in ' +GU.prepareINclause(oiMasters) + 'Group by Organization_Indicator_Id__c' ;
            for(AggregateResult ar : Database.query(queryStr)){
                recordOIcountMap.put((String)ar.get('mId'),(Integer)ar.get('cnt'));
            }
            filterStr = ' Where Id in ' + GU.prepareINclause(oiMasters);    
            List<SObject> sObjList = GU.lookupWithFilter(filterStr,'OrgUnit_Indicator__c'); 
            filterStr = ' Where Organization_Indicator_Id__c in ' + GU.prepareINclause(oiMasters);  
            List<SObject> sObjListMasterChilds = GU.lookupWithFilter(filterStr,'OrgUnit_Indicator__c');
            Map<Id,OrgUnit_Indicator__c> childMap = new Map<Id,OrgUnit_Indicator__c>();
            for(SObject so: sObjListMasterChilds){
                OrgUnit_Indicator__c oimc = (OrgUnit_Indicator__c) so;
                childMap.put(oimc.Id,oimc);
            }
            for(SObject so: sObjList){
                OrgUnit_Indicator__c oim = (OrgUnit_Indicator__c) so;
                if (!recordOIcountMap.containsKey(oim.Id)){                 
                    oim.LF_Indicators_Established__c = false;
                    oim.RF_Indicators_Established__c = false;
                    oim.IM_Indicators_Established__c = false;
                    oiMastersMap.put(oim.Id,oim);   
                } else {
                    Boolean rfIndicators = false;
                    Boolean lfIndicators = false;
                    Boolean imIndicators = false;
                    for(SObject soc: sObjListMasterChilds){
                        OrgUnit_Indicator__c oimc = (OrgUnit_Indicator__c) soc;
                        if (oimc.Organization_Indicator_Id__c == oim.Id){
                            if (recTypesMapRev.get(oimc.RecordTypeId).startsWith('RF')){
                                rfIndicators = true;
                            } else if (recTypesMapRev.get(oimc.RecordTypeId).startsWith('LF')){
                                lfIndicators = true;
                            } else {
                                imIndicators = true;
                            }                           
                        }
                    }
                    if (!rfIndicators) {
                        oim.RF_Indicators_Established__c = false;
                    }       
                    
                    if (!lfIndicators) {
                        oim.LF_Indicators_Established__c = false;
                    }
                    
                    if (!imIndicators) {
                        oim.IM_Indicators_Established__c = false;
                    }   
                    
                    if (!rfIndicators || !lfIndicators || !imIndicators){
                        oiMastersMap.put(oim.Id,oim);       
                    }   
                }               
            }
            upsert oiMastersMap.values();
        }
        
                
        
    }
    
    
    
    
    private Boolean isIndicatorResultsFlag(Id orgUnitId){
        if (rfResultsMap.containsKey(orgUnitId) || lfResultsMap.containsKey(orgUnitId) || imResultsMap.containsKey(orgUnitId))
            return true;
            
        return false;
    }
    
    private Boolean isIndicatorTargetsFlag(Id orgUnitId){
        if (rfTargetsMap.containsKey(orgUnitId) || lfTargetsMap.containsKey(orgUnitId) || imTargetsMap.containsKey(orgUnitId))
            return true;
            
        return false;
    }
    
    private Boolean isIndicatorActualsFlag(Id orgUnitId){
        if (rfActualsMap.containsKey(orgUnitId) || lfActualsMap.containsKey(orgUnitId) || imActualsMap.containsKey(orgUnitId))
            return true;
            
        return false;
    }
    
    private Boolean isPeriodResultsFlag(Id periodId, string type){
        if (type.equalsIgnoreCase('RF_Reporting_Period__c')){
            if (rfRPResultsMap.containsKey(periodId)) return true;
        }
        
        if (type.equalsIgnoreCase('LF_Reporting_Period__c')){
            if (lfRPResultsMap.containsKey(periodId)) return true;
        }
        
        if (type.equalsIgnoreCase('Reporting_Period__c')){
            if (imRPResultsMap.containsKey(periodId)) return true;
        }
        
        return false;
    }
    
    private Boolean isPeriodTargetsFlag(Id periodId, string type){
        if (type.equalsIgnoreCase('RF_Reporting_Period__c')){
            if (rfRPTargetsMap.containsKey(periodId)) return true;
        }
        
        if (type.equalsIgnoreCase('LF_Reporting_Period__c')){
            if (lfRPTargetsMap.containsKey(periodId)) return true;
        }
        
        if (type.equalsIgnoreCase('Reporting_Period__c')){
            if (imRPTargetsMap.containsKey(periodId)) return true;
        }
        
        return false;
    }
    
    
    private Boolean isPeriodActualsFlag(Id periodId, string type){
        if (type.equalsIgnoreCase('RF_Reporting_Period__c')){
            if (rfRPActualsMap.containsKey(periodId)) return true;
        }
        
        if (type.equalsIgnoreCase('LF_Reporting_Period__c')){
            if (lfRPActualsMap.containsKey(periodId)) return true;
        }
        
        if (type.equalsIgnoreCase('Reporting_Period__c')){
            if (imRPActualsMap.containsKey(periodId)) return true;
        }
        
        return false;
    }
    
    
    
    

}