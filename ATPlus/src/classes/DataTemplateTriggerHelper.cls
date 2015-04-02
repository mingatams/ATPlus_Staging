public class DataTemplateTriggerHelper{

    public DataTemplateTriggerHelper(){
    }
    
    
    public Map<string,OrgUnit__c> getExistingOrgUnits(set<string> uniqueOrgunitNames){
        if (uniqueOrgunitNames.isEmpty()){
            return null;
        }
        Map<string,OrgUnit__c> rexistingOrgUnits = new Map<string,OrgUnit__c>();
        for(OrgUnit__c ou: [Select Id, Name, ouDisplayName__c, oucode__c, ouName__c From OrgUnit__c Where ouCode__c in: uniqueOrgunitNames]){
            rexistingOrgUnits.put(ou.ouCode__c,ou);
        }
        System.debug('Existing OrgUnits::'+rexistingOrgUnits);
        return rexistingOrgUnits;
    }
    
    public Map<string,USAID_Indicator__c> getExistingStandardIndicators(set<string> uniqueStdIndCdes){
        if(uniqueStdIndCdes.isEMpty()){
            return null;
        }
        Map<string,USAID_Indicator__c> rexistingStdIndicators = new Map<string,USAID_Indicator__c>();
        for(USAID_Indicator__c stdInd: [Select Id, Name, indCode__c,indName__c, sIndCode__c, sIndName__c 
                                            From USAID_Indicator__c 
                                            where indCode__c in :uniqueStdIndCdes
                                            OR sIndCode__c in :uniqueStdIndCdes]){
            if(stdInd.sIndCode__c != null && stdInd.sIndCode__c != '')  {                              
                rexistingStdIndicators.put(stdInd.sIndCode__c,stdInd);
            } else {
                rexistingStdIndicators.put(stdInd.indCode__c,stdInd);
            }    
        }
        System.debug('Existing USAID Indicators::'+rexistingStdIndicators);
        return rexistingStdIndicators;
    }
    
    public Map<string,Map<string,Award__c>> getExistingAwards(set<string> uniqueOrgunitNames){
        if (uniqueOrgunitNames.isEmpty()){
            return null;
        }
        Map<string,Map<string,Award__c>> rexistingAwards = new Map<string,Map<string,Award__c>>();
        for(Award__c award: [Select Id, Name, Award_Number__c, DocNum__c, startdate__c, EndDate__c, Mission_Name__c, OrgUnit_Code__c 
                             From Award__c 
                             where OrgUnit_Code__c in :uniqueOrgunitNames ]){
                             
            Map<string,Award__c> tempMap = new Map<string,Award__c>();
            if(rexistingAwards.containsKey(award.OrgUnit_Code__c)){    
                tempMap = rexistingAwards.get(award.OrgUnit_Code__c);   
            }
            if (award.DocNum__c != null && award.DocNum__c != ''){
                tempMap.put(award.DocNum__c,award);
                rexistingAwards.put(award.OrgUnit_Code__c,tempMap);
            }                                      
            
        }
        System.debug('Existing Awards::'+rexistingAwards);
        return rexistingAwards;
    }
    
    public Map<string,Map<string,ImpleMenting_Mechanism__c>> getExistingImplementingMechanisms(set<string> uniqueOrgunitNames,set<string> docsNewIMs){
        if (uniqueOrgunitNames.isEmpty()){
            return null;
        }
        Map<string,Map<string,Implementing_Mechanism__c>> rexistingIMs = new Map<string,Map<string,Implementing_Mechanism__c>>();
        for(Implementing_Mechanism__c im: [Select Id, Name, Award_Key__c, Document__c, Award_Id__c,ouCode__c, ouName__c, Award_Number__c 
                                            From Implementing_Mechanism__c 
                                            where ouCode__c in :uniqueOrgunitNames
                                            ]){
            Map<string,Implementing_Mechanism__c> tempMap = new Map<string,Implementing_Mechanism__c>();
            if(rexistingIMs.containsKey(im.ouCode__c)){    
                tempMap = rexistingIMs.get(im.ouCode__c);   
            }
            if(docsNewIMs.contains(im.Award_Number__c)){
                tempMap.put(im.Award_Number__c,im);
            } else {
                tempMap.put(im.Name,im);
            }                                      
            rexistingIMs.put(im.ouCode__c,tempMap);
        }
        System.debug('Existing Ims:'+rexistingIMs);
        return rexistingIMs;
    } 
    
    public Map<string,Map<string,orgUnit_Indicator__c>> getExistingMasterIndicators(set<string> uniqueOrgunitNames){
        if (uniqueOrgunitNames.isEmpty()){
            return null;
        }
        Map<string,Map<string,orgUnit_Indicator__c>> rexistingMassterInds = new Map<string,Map<string,orgUnit_Indicator__c>>();
        for(orgUnit_Indicator__c oim: [Select Id, Name, indCode__c, indName__c, sIndCode__c, sIndName__c,oucode__c, ouName__c,Custom__c
                                           From OrgUnit_Indicator__c 
                                           Where ouCode__c in :uniqueOrgunitNames
                                             and RecordType.Name = 'Master'
                                            ]){
            Map<string,orgUnit_Indicator__c > tempMap = new Map<string,orgUnit_Indicator__c >();
            if(rexistingMassterInds.containsKey(oim.ouCode__c)){    
                tempMap = rexistingMassterInds.get(oim.ouCode__c);   
            }
            if (oim.custom__c){
                if(oim.sIndName__c != null && oim.sIndName__c != ''){
                    tempMap.put(oim.sIndName__c,oim);
                } else {
                    tempMap.put(oim.indName__c,oim);
                }
            } else {
                if(oim.sIndCode__c != null && oim.sIndCode__c != ''){
                    tempMap.put(oim.sIndCode__c,oim);
                } else {
                    tempMap.put(oim.indCode__c,oim);
                }
            }                                          
            rexistingMassterInds.put(oim.ouCode__c,tempMap);
        }
        System.debug('Existing Master Indicators:'+rexistingMassterInds);
        return rexistingMassterInds;
    } 
    
    public Map<string,Map<string,orgUnit_Indicator__c>> getExistingChildIndicators(set<string> uniqueOrgunitNames,
                                                                                   set<string> docsNewIMs){
        if (uniqueOrgunitNames.isEmpty()){
            return null;
        }
        Map<string,Map<string,orgUnit_Indicator__c>> rexistingChildInds = new Map<string,Map<string,orgUnit_Indicator__c>>();
        for(orgUnit_Indicator__c oic: [Select Id, Name, indCode__c, indName__c, sIndCode__c, sIndName__c, ouCode__c,ouName__c,
                                            Custom__c,Implementing_Mechanism_Id__r.Name, Implementing_Mechanism_Id__r.Award_Number__c 
                                           From OrgUnit_Indicator__c 
                                           Where ouCode__c in :uniqueOrgunitNames
                                             and RecordType.Name = 'Implementing Mechanism'
                                            ]){
            Map<string,orgUnit_Indicator__c > tempMap = new Map<string,orgUnit_Indicator__c >();
            string mapKey;
           // if(oic.Implementing_Mechanism_Id__r.Document__c != null && oic.Implementing_Mechanism_Id__r.Document__c != ''){
           if (docsNewIMs.contains(oic.Implementing_Mechanism_Id__r.Award_Number__c)){
                mapKey = oic.ouCode__c +'::'+oic.Implementing_Mechanism_Id__r.Award_Number__c;
            } else {
                mapKey = oic.ouCode__c +'::'+oic.Implementing_Mechanism_Id__r.Name;
            }
            if(rexistingChildInds.containsKey(mapKey)){    
                tempMap = rexistingChildInds.get(mapKey);   
            }
            if (oic.custom__c){
                if(oic.sIndName__c != null && oic.sIndName__c != ''){
                    tempMap.put(oic.sIndName__c,oic);
                } else {
                    tempMap.put(oic.indName__c,oic);
                }
            } else {
                if(oic.sIndCode__c != null && oic.sIndCode__c != ''){
                    tempMap.put(oic.sIndCode__c,oic);
                } else {
                    tempMap.put(oic.indCode__c,oic);
                }
            }                                          
            rexistingChildInds.put(mapKey,tempMap);
        }
        System.debug('Existing Child Indicators:'+rexistingChildInds);
        return rexistingChildInds;
    }
    
    public Map<string,Map<string,Reporting_Period__c>> getExistingReportingPeriods(set<string> uniqueOrgunitNames,
                                                                                    set<string> docsNewIMs){
        if (uniqueOrgunitNames.isEmpty()){
            return null;
        }
        Map<string,Map<string,Reporting_Period__c>> rexistingPeriods = new Map<string,Map<string,Reporting_Period__c>>();
        for(Reporting_Period__c rp: [Select Id, Name, ouCode__c,ouName__c, Implementing_Mechanism_Id__r.Name, 
                                        Implementing_Mechanism_Id__r.Award_Number__c
                                         From Reporting_Period__c 
                                         where ouCode__c in : uniqueOrgunitNames
                                         And Implementing_Mechanism_Id__c != null 
                                         ]){
            Map<string,Reporting_Period__c> tempMap = new Map<string,Reporting_Period__c>();
            string mapKey;
           // if(rp.Implementing_Mechanism_Id__r.Document__c != null && rp.Implementing_Mechanism_Id__r.Document__c != ''){
            if(docsNewIMs.contains(rp.Implementing_Mechanism_Id__r.Award_Number__c)){
                mapKey = rp.ouCode__c +'::'+rp.Implementing_Mechanism_Id__r.Award_Number__c;
            } else {
                mapKey = rp.ouCode__c +'::'+rp.Implementing_Mechanism_Id__r.Name;
            }
            if(rexistingPeriods.containsKey(mapKey)){    
                tempMap = rexistingPeriods.get(mapKey);   
            }
            tempMap.put(rp.Name,rp);                                         
            rexistingPeriods.put(mapKey,tempMap);
        }
        System.debug('Existing Reporting Periods:'+rexistingPeriods);
        return rexistingPeriods;
    }
    
    public Map<string,Indicator_Results__c> getExistingIndicatorResults(set<string> uniqueOrgunitNames,
                                                                        set<string> docsNewIMs){
        if (uniqueOrgunitNames.isEmpty()){
            return null;
        }
        Map<string,Indicator_Results__c> rexistingResults = new Map<string,Indicator_Results__c>();
        for(Indicator_Results__c ir: [Select Id, Name, Implementing_Mechanism_Id__r.ouName__c,ouCode__c,ouName__c,
                                       Implementing_Mechanism_Id__r.Name,Implementing_Mechanism_Id__r.Award_Number__c,
                                       Reporting_Period_Name__c, 
                                       Organization_Indicator_Id__r.indCode__c, Organization_Indicator_Id__r.indName__c,
                                       Organization_Indicator_Id__r.sindCode__c, Organization_Indicator_Id__r.sindName__c,
                                       Organization_Indicator_Id__r.custom__c
                                    From Indicator_Results__c 
                                    Where ouCode__c in :uniqueOrgunitNames
                                    And Implementing_Mechanism_Id__c != null]){
           // Map<string,Indicator_Results__c> tempMap = new Map<string,Indicator_Results__c>();            
            string mapKey;
            if (ir.Organization_Indicator_Id__r.custom__c){
                if(ir.Organization_Indicator_Id__r.sindName__c != null && ir.Organization_Indicator_Id__r.sindName__c != ''){
                   // if(ir.Implementing_Mechanism_Id__r.Document__c != null && ir.Implementing_Mechanism_Id__r.Document__c != ''){
                    if(docsNewIMs.contains(ir.Implementing_Mechanism_Id__r.Award_Number__c)){
                        mapKey = ir.ouCode__c +'::'+ir.Implementing_Mechanism_Id__r.Award_Number__c +'::'+ir.Organization_Indicator_Id__r.sindName__c +'::'+ir.Reporting_Period_Name__c;
                    } else {
                        mapKey = ir.ouCode__c +'::'+ir.Implementing_Mechanism_Id__r.Name+'::'+ir.Organization_Indicator_Id__r.sindName__c +'::'+ir.Reporting_Period_Name__c;
                    }
                 } else {
                   //  if(ir.Implementing_Mechanism_Id__r.Document__c != null && ir.Implementing_Mechanism_Id__r.Document__c != ''){
                   if(docsNewIMs.contains(ir.Implementing_Mechanism_Id__r.Award_Number__c)){
                        mapKey = ir.ouCode__c +'::'+ir.Implementing_Mechanism_Id__r.Award_Number__c +'::'+ir.Organization_Indicator_Id__r.indName__c +'::'+ir.Reporting_Period_Name__c;
                    } else {
                        mapKey = ir.ouCode__c +'::'+ir.Implementing_Mechanism_Id__r.Name+'::'+ir.Organization_Indicator_Id__r.indName__c +'::'+ir.Reporting_Period_Name__c;
                    }
                 }  
            } else {
                 if(ir.Organization_Indicator_Id__r.sindCode__c != null && ir.Organization_Indicator_Id__r.sindCode__c != ''){
                   // if(ir.Implementing_Mechanism_Id__r.Document__c != null && ir.Implementing_Mechanism_Id__r.Document__c != ''){
                    if(docsNewIMs.contains(ir.Implementing_Mechanism_Id__r.Award_Number__c)){   
                        mapKey = ir.ouCode__c +'::'+ir.Implementing_Mechanism_Id__r.Award_Number__c +'::'+ir.Organization_Indicator_Id__r.sindCode__c +'::'+ir.Reporting_Period_Name__c;
                    } else {
                        mapKey = ir.ouCode__c +'::'+ir.Implementing_Mechanism_Id__r.Name+'::'+ir.Organization_Indicator_Id__r.sindCode__c +'::'+ir.Reporting_Period_Name__c;
                    }
                 } else {
                   //  if(ir.Implementing_Mechanism_Id__r.Document__c != null && ir.Implementing_Mechanism_Id__r.Document__c != ''){
                   if(docsNewIMs.contains(ir.Implementing_Mechanism_Id__r.Award_Number__c)){
                        mapKey = ir.ouCode__c +'::'+ir.Implementing_Mechanism_Id__r.Award_Number__c +'::'+ir.Organization_Indicator_Id__r.indCode__c +'::'+ir.Reporting_Period_Name__c;
                    } else {
                        mapKey = ir.ouCode__c +'::'+ir.Implementing_Mechanism_Id__r.Name+'::'+ir.Organization_Indicator_Id__r.indCode__c +'::'+ir.Reporting_Period_Name__c;
                    }
                 } 
            
            }    
            if(!rexistingResults.containsKey(mapKey)){    
                rexistingResults.put(mapKey,ir);  
            }

                                                                    
            
        }
        System.debug('Existing Reporting Periods:'+rexistingResults);
        return rexistingResults;
    }
        
    public Map<String,String> prepareCustomIndicatorCodes(Map<string,Data_Template__c> custIndicatorNames){
        if (custIndicatorNames.isEmpty()){
            return null;
        }
        set<string> uniquePes = new set<string>();
        string ouName;
        for(Data_Template__c dt1: custIndicatorNames.values() ){
            if(dt1.Program_Element_Code__c != null && dt1.Program_Element_Code__c != ''){
               // uniquePes.add(dt1.Program_Element__c.split(' ')[0]);
               uniquePes.add(dt1.Program_Element_code__c.trim());
            }
            ouName = dt1.ouCode__c;
        }
        Map<string,Integer> peMostIndexes = new Map<string,Integer>();
        if(!uniquePes.isEmpty()){
            for(OrgUnit_Indicator__c oi: [Select Id, Name, IndCode__c, indName__c,prCode__c 
                                            From OrgUnit_Indicator__c 
                                            Where prCode__c in :uniquePes
                                            and sindCode__c = null
                                            and custom__c = true
                                            and RecordType.Name = 'Master'
                                            and ouCode__c = :ouName
                                            Order by IndCode__c]){
                system.debug('Organization C Indicators:::' +oi);                             
                peMostIndexes.put(oi.prCode__c, Integer.valueof(oi.IndCode__c.split('-Z')[1]));                                
            
            }
        }
        Map<string,string> indCodes = new Map<string,string>();
        
        Integer indIndex = 1;
        
        for(String keyStr: custIndicatorNames.keySet()){
            Data_Template__c dt = custIndicatorNames.get(keyStr);
            //String pe = dt.Program_Element__c.split(' ')[0];
            String pe = dt.Program_Element_Code__c.trim();
            Integer nextIndex = peMostIndexes.containsKey(pe) ? peMostIndexes.get(pe) + 1 : 1;            
            String nextIndexStr =  nextIndex < 9 ? '0'+ string.valueOf(nextIndex): string.valueOf(nextIndex);  
            String indCode = pe + '-Z' + nextIndexStr;
            
            peMostIndexes.put(pe,nextIndex);
            indCodes.put(keyStr,indCode);
        }    
        
        return indCodes;    
    
    } 
    
    public Map<String,String> prepareCustomSubIndicatorCodes(Map<string,Data_Template__c> custSubIndicatorNames,
                                                                Map<string,String> custIndicatorCodes){
        if (custSubIndicatorNames.isEmpty()){
            return null;
        }
        
        Map<string,string> subIndCodes = new Map<string,string>();
        Map<string,string> mostRecentSubIndex = new Map<string,string>();
        
        for(Data_Template__c dt : custSubIndicatorNames.values()){
           // String pe = dt.Program_Element__c.split(' ')[0];
           String pe = dt.Program_Element_code__c.trim();
            String indCode = dt.Master_Indicator_Code__c != null ? dt.Master_Indicator_Code__c+'Z': 
            custIndicatorCodes.containsKey(dt.Temp_Custom_Master_Indicator_code__c)? custIndicatorCodes.get(dt.Temp_Custom_Master_Indicator_code__c) : custIndicatorCodes.get(dt.Master_Indicator_Name__c);
            String subIndCode;
            String nextIndex;
            if(mostRecentSubIndex.containsKey(dt.Temp_Custom_Master_Indicator_code__c)){
                nextIndex = getNextSubIndex(mostRecentSubIndex.get(dt.Temp_Custom_Master_Indicator_code__c));
            } else {
                nextIndex = 'a';
            }
            subIndCode = indCode + nextIndex;
            mostRecentSubIndex.put(dt.Temp_Custom_Master_Indicator_code__c,nextIndex);
            subIndCodes.put(dt.Temp_Custom_Indicator_code__c,subIndCode);
        }    
        
        return subIndCodes;    
    
    }
    
    private string getNextSubIndex(string currIndex){
        
        if (currIndex == 'a'){
            return 'b';
        } else if(currIndex == 'b'){
            return 'c';
        } else if(currIndex == 'c'){
            return 'd';
        } else if(currIndex == 'd'){
            return 'e';
        } else if(currIndex == 'e'){
            return 'f';
        } else if(currIndex == 'f'){
            return 'g';
        } else if(currIndex == 'g'){
            return 'h';
        } else if(currIndex == 'h'){
            return 'i';
        } else if(currIndex == 'i'){
            return 'j';
        } else if(currIndex == 'j'){
            return 'k';
        } else if(currIndex == 'k'){
            return 'l';
        } else if(currIndex == 'l'){
            return 'm';
        } else if(currIndex == 'm'){
            return 'n';
        } else if(currIndex == 'n'){
            return 'o';
        } else if(currIndex == 'o'){
            return 'p';
        } else if(currIndex == 'p'){
            return 'q';
        } else if(currIndex == 'q'){
            return 'r';
        } else if(currIndex == 'r'){
            return 's';
        } else if(currIndex == 's'){
            return 't';
        } else if(currIndex == 't'){
            return 'u';
        } else if(currIndex == 'u'){
            return 'v';
        } else if(currIndex == 'v'){
            return 'w';
        } else if(currIndex == 'w'){
            return 'x';
        } else if(currIndex == 'x'){
            return 'y';
        } else if(currIndex == 'y'){
            return 'z';
        }
        return '';   
        
    }
       
    public String getDTPeriodName(Data_Template__c dtf){
        string repPeriod;
        if (dtf.Fiscal_Year__c.startsWith('FY')){
            if (dtf.time_Period__c.startsWith('H')){
                repPeriod = dtf.Fiscal_Year__c.substring(2).trim() + '-SA' +dtf.Time_Period__c.substring(1).trim();
            } else {
                repPeriod = dtf.Fiscal_Year__c.substring(2).trim() + '-' +dtf.Time_Period__c.trim();
            }
        } else {
            if (dtf.time_Period__c.startsWith('H')){
                repPeriod = dtf.Fiscal_Year__c.trim() + '-SA' +dtf.Time_Period__c.substring(1).trim();
            } else {
                repPeriod = dtf.Fiscal_Year__c.trim() + '-' +dtf.Time_Period__c.trim();
            }
        }
        system.debug('REporting Period Name:::'+repPeriod);
        return repPeriod;
    }
    
   /* private set<string> uniqueOrgunitNames = new set<string>();
    private set<string> uniqueIndicatorCodes = new set<string>();
    private Map<string,Data_Template__c> uniqueCustomIndicatorNames = new Map<string,Data_Template__c>();
    private set<string> uniqueAwardDocuments = new set<string>();
    
    clsGlobalUtility GU = new clsGlobalUtility();
    Map<String,string> imRecTypesMap = GU.getRecordTypeByObject('Implementing_Mechanism__c');
    Map<String,string> orgIndicatorRecTypesMap = GU.getRecordTypeByObject('OrgUnit_Indicator__c');
    
    Map<string,Award__c> awardsMap = new Map<string,Award__c>();
    Map<string,USAID_Indicator__c> usaidIndicatorsMap = new Map<string,USAID_Indicator__c>(); 
    Map<string,OrgUnit__c> orgUnitsByName = new Map<string,OrgUnit__c>();
    Map<string,Implementing_Mechanism__c> implementingMechanismsByDoc = new Map<string,Implementing_Mechanism__c>();
    Map<string,Map<string,OrgUnit_Indicator__c>> masterStdIndicatorsByOrg = new Map<string,Map<string,OrgUnit_Indicator__c>>();
    Map<string,Map<string,OrgUnit_Indicator__c>> masterCustomIndicatorsByOrg = new Map<string,Map<string,OrgUnit_Indicator__c>>();
    
    
    public DataTemplateTriggerHelper(set<string> uniqueOrgunitNames, 
                                     set<string> uniqueAwardDocuments, 
                                     set<string> uniqueIndicatorCodes,
                                     Map<string,Data_Template__c> uniqueCustomIndicatorNames ){
        this.uniqueOrgunitNames = uniqueOrgunitNames;
        this.uniqueAwardDocuments = uniqueAwardDocuments;
        this.uniqueIndicatorCodes = uniqueIndicatorCodes;
        this.uniqueCustomIndicatorNames  = uniqueCustomIndicatorNames;
        getOrgUnits();
        getAwards();
        getUsaidIndicators();
        getImplementingMechanismsByAward();
        createImplementingMechanisms();
        getImplementingMechanismsByAward();
        getMasterOrgUnitIndicators();
        createMasterStdOrgUnitIndicators();
        createMasterCustomOrgUnitIndicators();
        getMasterOrgUnitIndicators();
        
    }

    public void getOrgUnits(){
         
         for(OrgUnit__c ou: [Select Id, Name, ouDisplayName__c, ouName__c 
                             From OrgUnit__c 
                             Where ouName__c in: uniqueOrgUnitNames]){
                orgUnitsByName.put(ou.ouName__c, ou);
         }
    }
    
    private void getAwards(){    
        for(Award__c award: [Select Id, Name, AWARD_KEY__c, DocNum__c, Award_Number__c, EndDate__c, StartDate__c,
                                    Mission_Name__c, OrgUnit_Name__c 
                             From Award__c
                             Where DocNum__c in : uniqueAwardDocuments
                             And Implementing_Mechanism__c = null ]){
            awardsMap.put(award.DocNum__c,award);    
        }
        //return awardsMap;
    }
    
    public void getUsaidIndicators(){
        for(USAID_Indicator__c uIndicator: [Select Id, Name, indCode__c,indName__c, sIndCode__c, sIndName__c 
                                                From USAID_Indicator__c 
                                                where indCode__c in :uniqueIndicatorCodes
                                                OR sIndCode__c in :uniqueIndicatorCodes]){
            if (uIndicator.sIndCode__c != null && uIndicator.sIndCode__c != '')  {                              
                usaidIndicatorsMap.put(uIndicator.sIndCode__c, uIndicator);
            } else {
                usaidIndicatorsMap.put(uIndicator.indCode__c, uIndicator);   
            }        
        }
    
    }
    
    public void getImplementingMechanismsByAward(){ 
        
        for(Implementing_Mechanism__c im: [Select Id, Name, Award_Key__c, Document__c, Award_Id__c,ouName__c 
                                                From Implementing_Mechanism__c 
                                                where Document__c in :uniqueAwardDocuments]){
            implementingMechanismsByDoc.put(im.Document__c, im);
            
        }
    }
    
    public void createImplementingMechanisms(){
        List<Implementing_Mechanism__c> newIms = new List<Implementing_Mechanism__c>();
        for(string awardDoc: uniqueAwardDocuments ){
            if (!implementingMechanismsByDoc.containsKey(awardDoc)){
                if(awardsMap.containsKey(awardDoc)){
                    newIms.add(new Implementing_Mechanism__c( RecordTypeId = imRecTypesMap.get('Advanced'),
                                                              ouId__c = orgUnitsByName.get(awardsMap.get(awardDoc).Mission_Name__c).Id,
                                                              Award_Id__c = awardsMap.get(awardDoc).Id
                                                             ));
                }
            }    
        }
        
        if(!newIms.isEmpty()){
            insert newIms;
        }
    }
    
    
    private void getMasterOrgUnitIndicators(){
        for(OrgUnit_Indicator__c mastInd: [Select Id, Name, indCode__c, indName__c, sIndCode__c, sIndName__c, ouName__c,Custom__c
                                           From OrgUnit_Indicator__c 
                                           Where ouName__c in :uniqueOrgUnitNames
                                             and RecordTypeId = :orgIndicatorRecTypesMap.get('Master')]){
            if(mastInd.custom__c){                                 
                Map<string,OrgUnit_Indicator__c> tempStdMap = new Map<string,OrgUnit_Indicator__c>();                                 
                if(masterStdIndicatorsByOrg.containsKey(mastInd.ouName__c)){
                    tempStdMap =  masterStdIndicatorsByOrg.get(mastInd.ouName__c);  
                }  
                if (mastInd.sIndCode__c != null && mastInd.sIndCode__c != ''){ 
                    tempStdMap.put(mastInd.sIndCode__c,mastInd);                                   
                } else {
                    tempStdMap.put(mastInd.indCode__c,mastInd);
                }    
                masterStdIndicatorsByOrg.put(mastInd.ouName__c,tempStdMap);
           } else {
               Map<string,OrgUnit_Indicator__c> tempCustomMap = new Map<string,OrgUnit_Indicator__c>();                                 
                if(masterCustomIndicatorsByOrg.containsKey(mastInd.ouName__c)){
                    tempCustomMap =  masterCustomIndicatorsByOrg.get(mastInd.ouName__c);  
                }  
                if (mastInd.sIndName__c != null && mastInd.sIndName__c != ''){ 
                    tempCustomMap.put(mastInd.sIndName__c,mastInd);                                   
                } else {
                    tempCustomMap.put(mastInd.indName__c,mastInd);
                }    
                masterCustomIndicatorsByOrg.put(mastInd.ouName__c,tempCustomMap);
           
           }     
            
        }
    
    }
    
    public void createMasterStdOrgUnitIndicators(){
        List<OrgUnit_Indicator__c> newStdMasterInds  = new List<OrgUnit_Indicator__c>();
        for(string orgName : uniqueOrgunitNames){            
            Map<string,OrgUnit_Indicator__c> existMasterStdInds = masterStdIndicatorsByOrg.containsKey(orgName)? masterStdIndicatorsByOrg.get(orgName) : new Map<string,OrgUnit_Indicator__c>();            
            for(string stdIndicator: uniqueIndicatorCodes){
                if(usaidIndicatorsMap.containsKey(stdIndicator) && !existMasterStdInds.containsKey(stdIndicator)){
                    if (usaidIndicatorsMap.get(stdIndicator).sIndCode__c != null){
                        newStdMasterInds.add(new OrgUnit_Indicator__c( RecordTypeId = orgIndicatorRecTypesMap.get('Master'),
                                                                  ouId__c = orgunitsByName.get(orgName).Id,
                                                                  USAID_Indicator_Id__c = usaidIndicatorsMap.get(stdIndicator).Id,
                                                                  indCode__c = usaidIndicatorsMap.get(stdIndicator).indCode__c,
                                                                  indName__c = usaidIndicatorsMap.get(stdIndicator).indName__c,
                                                                  sIndCode__c = usaidIndicatorsMap.get(stdIndicator).sIndCode__c,
                                                                  sIndName__c = usaidIndicatorsMap.get(stdIndicator).sIndName__c
                                                                ));
                    } else {
                        newStdMasterInds.add(new OrgUnit_Indicator__c( RecordTypeId = orgIndicatorRecTypesMap.get('Master'),
                                                                  ouId__c = orgunitsByName.get(orgName).Id,
                                                                  USAID_Indicator_Id__c = usaidIndicatorsMap.get(stdIndicator).Id,
                                                                  indCode__c = usaidIndicatorsMap.get(stdIndicator).indCode__c,
                                                                  indName__c = usaidIndicatorsMap.get(stdIndicator).indName__c
                                                                  ));
                    }                                            
                }
            }
        }
        
        if (!newStdMasterInds.isEmpty()){
            insert newStdMasterInds;
        }        
    
    }    
    
    public void createMasterCustomOrgUnitIndicators(){
        List<OrgUnit_Indicator__c> newCustomMasterInds  = new List<OrgUnit_Indicator__c>();
        
        for(string orgName : uniqueOrgunitNames){ 
            Map<string,string> indnameVsCode = new Map<string,string>();      
            Integer indCount = 1;
            Integer subIndCount = 1;     
            Map<string,OrgUnit_Indicator__c> existMasterCustomInds = masterCustomIndicatorsByOrg.containsKey(orgName)? masterCustomIndicatorsByOrg.get(orgName) : new Map<string,OrgUnit_Indicator__c>();            
            for(string customIndicatorName: uniqueCustomIndicatorNames.keySet()){
                Data_Template__c dt = uniqueCustomIndicatorNames.get(customIndicatorName);
               // string pe =  dt.Program_Element__c.trim().split(' ')[0];
               string pe =  dt.Program_Element_Code__c.trim();
                string indcode;
                string subIndCode;
                if (!indnameVsCode.containsKey(customIndicatorName)){
                    if(dt.Master_Indicator_Name__c == null && dt.Master_Indicator_Name__c == ''){                        
                        indcode = pe + '-Z' +indCount; 
                        indCount += 1;
                        subIndCount = 1;
                    } else {   
                        indCode = indnameVsCode.get(dt.Master_Indicator_Name__c);                     
                        subIndCode = indnameVsCode.containsKey(dt.Master_Indicator_Name__c)? indnameVsCode.get(dt.Master_Indicator_Name__c) + '-' +subIndCount : pe + '--' +subIndCount;
                        subIndCount += 1;
                    }      
                } 
                if(!existMasterCustomInds.containsKey(customIndicatorName)){
                    if (dt.Master_Indicator_Name__c == null && dt.Master_Indicator_Name__c == ''){                     
                    
                        newCustomMasterInds.add(new OrgUnit_Indicator__c( RecordTypeId = orgIndicatorRecTypesMap.get('Master'),
                                                                  ouId__c = orgunitsByName.get(orgName).Id,
                                                                 // USAID_Indicator_Id__c = usaidIndicatorsMap.get(stdIndicator).Id,
                                                                  indCode__c = indcode,
                                                                  indName__c = dt.indicator__c,
                                                                  custom__c = true
                                                                  ));
                    } else {
                        newCustomMasterInds.add(new OrgUnit_Indicator__c( RecordTypeId = orgIndicatorRecTypesMap.get('Master'),
                                                                  ouId__c = orgunitsByName.get(orgName).Id,
                                                                //  USAID_Indicator_Id__c = usaidIndicatorsMap.get(stdIndicator).Id,
                                                                  indCode__c = indCode,
                                                                  indName__c = dt.Master_Indicator_Name__c,
                                                                  sIndCode__c = subIndCode,
                                                                  sIndName__c = dt.Indicator__c,
                                                                  custom__c = true
                                                                ));
                        
                    }                                            
                }           
             }   
        }
        
        if (!newCustomMasterInds.isEmpty()){
            insert newCustomMasterInds;
        }        
    
    } */

}