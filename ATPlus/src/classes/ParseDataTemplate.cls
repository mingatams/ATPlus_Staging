public class ParseDataTemplate implements Database.Batchable<sObject>{
    public final String Query;
    public final String flagStr;
    public Integer IMUpdateCount = 0;
    public Integer IMCreateCount = 0;
    public Integer MasterStandardIndicatorscount = 0;
    public Integer MasterCustomIndicatorCount = 0;
    public Integer MasterCustomSubindicatorCount = 0;
    public Integer IMIndicatorCount = 0;
    public integer skippedIMIndicatorCount = 0;
    public Integer CreatedResultsCount = 0;
    public Integer skippedResultsCount = 0;
    
    
    Public ParseDataTemplate(){
        Query = ' Select ID, NAME, IM_ID__C,    IM_AWARD_NUMBER__C, Program_Element_code__c, PROGRAM_ELEMENT__C, INDICATOR__C, INDICATOR_ID__C, REPORTING_FREQUENCY__C, '+   
                ' DATA_CATEGORY__C, FISCAL_YEAR__C, TIME_PERIOD__C, IS_PROCESSED__C, COMMENTS__C, OUNAME__C, IMPLEMENTING_MECHANISM_ID__C, '+   
                ' REPORTING_PERIOD_ID__C, MASTER_INDICATOR_CODE__C, MASTER_INDICATOR_NAME__C,   VALUE_AND_TEXT__C, START_DATE__C, END_DATE__C, '+   
                ' VALUE__C, ORGANIZATION_ID__C, ORGUNIT_INDICATOR_MASTER_ID__C, ORGUNIT_INDICATOR_ID__C, USAID_INDICATOR_ID__C, ISERROR__C, indCode__c, '+  
                ' AWARD_ID__C, GENERATE_PERIODS__C, INDICATOR_RESULTS_ID__C, AWARD_DOCUMENT__C, Actual__c, BaseLine__c, Target__c, Indicator_Source__c, Indicator_Type__c, ' +
                ' Temp_Custom_Indicator_code__c, Temp_Custom_Master_Indicator_code__c, ouCode__c ' +
                ' from Data_template__c '+
                ' where is_processed__c = false and isError__c = false';
    }
    Public ParseDataTemplate(String fs, string sc) {
        if (sc.equalsIgnoreCase('custom')){
            Query = ' Select ID, NAME, IM_ID__C,    IM_AWARD_NUMBER__C, Program_Element_code__c, PROGRAM_ELEMENT__C, INDICATOR__C, INDICATOR_ID__C, REPORTING_FREQUENCY__C, '+   
                ' DATA_CATEGORY__C, FISCAL_YEAR__C, TIME_PERIOD__C, IS_PROCESSED__C, COMMENTS__C, OUNAME__C, IMPLEMENTING_MECHANISM_ID__C, '+   
                ' REPORTING_PERIOD_ID__C, MASTER_INDICATOR_CODE__C, MASTER_INDICATOR_NAME__C,   VALUE_AND_TEXT__C, START_DATE__C, END_DATE__C, '+   
                ' VALUE__C, ORGANIZATION_ID__C, ORGUNIT_INDICATOR_MASTER_ID__C, ORGUNIT_INDICATOR_ID__C, USAID_INDICATOR_ID__C, ISERROR__C, indCode__c, '+  
                ' AWARD_ID__C, GENERATE_PERIODS__C, INDICATOR_RESULTS_ID__C, AWARD_DOCUMENT__C, Actual__c, BaseLine__c, Target__c, Indicator_Source__c, Indicator_Type__c,  ' +
                ' Temp_Custom_Indicator_code__c, Temp_Custom_Master_Indicator_code__c, ouCode__c ' +
                ' from Data_template__c '+
                ' where is_processed__c = false and isError__c = false and Indicator_Id__c = \'Custom\'';
         } else if (sc.equalsIgnoreCase('standard')){
             Query = ' Select ID, NAME, IM_ID__C,    IM_AWARD_NUMBER__C, Program_Element_code__c, PROGRAM_ELEMENT__C, INDICATOR__C, INDICATOR_ID__C, REPORTING_FREQUENCY__C, '+   
                ' DATA_CATEGORY__C, FISCAL_YEAR__C, TIME_PERIOD__C, IS_PROCESSED__C, COMMENTS__C, OUNAME__C, IMPLEMENTING_MECHANISM_ID__C, '+   
                ' REPORTING_PERIOD_ID__C, MASTER_INDICATOR_CODE__C, MASTER_INDICATOR_NAME__C,   VALUE_AND_TEXT__C, START_DATE__C, END_DATE__C, '+   
                ' VALUE__C, ORGANIZATION_ID__C, ORGUNIT_INDICATOR_MASTER_ID__C, ORGUNIT_INDICATOR_ID__C, USAID_INDICATOR_ID__C, ISERROR__C, indCode__c, '+  
                ' AWARD_ID__C, GENERATE_PERIODS__C, INDICATOR_RESULTS_ID__C, AWARD_DOCUMENT__C, Actual__c, BaseLine__c, Target__c, Indicator_Source__c, Indicator_Type__c,  ' +
                ' Temp_Custom_Indicator_code__c, Temp_Custom_Master_Indicator_code__c, ouCode__c ' +
                ' from Data_template__c '+
                ' where is_processed__c = false and isError__c = false and Indicator_Id__c != \'Custom\'';
         } else if(sc.equalsIgnoreCase('all')){
             Query = ' Select ID, NAME, IM_ID__C,    IM_AWARD_NUMBER__C, Program_Element_code__c, PROGRAM_ELEMENT__C, INDICATOR__C, INDICATOR_ID__C, REPORTING_FREQUENCY__C, '+   
                ' DATA_CATEGORY__C, FISCAL_YEAR__C, TIME_PERIOD__C, IS_PROCESSED__C, COMMENTS__C, OUNAME__C, IMPLEMENTING_MECHANISM_ID__C, '+   
                ' REPORTING_PERIOD_ID__C, MASTER_INDICATOR_CODE__C, MASTER_INDICATOR_NAME__C,   VALUE_AND_TEXT__C, START_DATE__C, END_DATE__C, '+   
                ' VALUE__C, ORGANIZATION_ID__C, ORGUNIT_INDICATOR_MASTER_ID__C, ORGUNIT_INDICATOR_ID__C, USAID_INDICATOR_ID__C, ISERROR__C, indCode__c, '+  
                ' AWARD_ID__C, GENERATE_PERIODS__C, INDICATOR_RESULTS_ID__C, AWARD_DOCUMENT__C, Actual__c, BaseLine__c, Target__c, Indicator_Source__c, Indicator_Type__c,  ' +
                ' Temp_Custom_Indicator_code__c, Temp_Custom_Master_Indicator_code__c, ouCode__c ' +
                ' from Data_template__c '+
                ' where is_processed__c = false and isError__c = false';
         }       
       flagStr = fs;
    }
    
    Public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    Public void execute(Database.BatchableContext BC, List<Data_template__c> scope){
        clsGlobalUtility GU = new clsGlobalUtility();
        DataTemplateTriggerHelper dtth = new DataTemplateTriggerHelper();
        Map<String,string> imRecTypesMap = GU.getRecordTypeByObject('Implementing_Mechanism__c');
        Map<String,string> orgIndicatorRecTypesMap = GU.getRecordTypeByObject('OrgUnit_Indicator__c');
        
        Map<string,Data_Template__c> imIds = new Map<string,Data_Template__c>();
        Map<string,Data_Template__c> imDocs = new Map<string,Data_Template__c>();
        Map<string,Data_Template__c> masterIndsubIndCodes = new Map<string,Data_Template__c>();
        Map<string,Data_Template__c> customMasterIndNames = new Map<string,Data_Template__c>();
        Map<string,Data_Template__c> customMasterSubIndNames = new Map<string,Data_Template__c>();
        List<Implementing_Mechanism__c> imUpdateList = new List<Implementing_Mechanism__c>();
        List<Implementing_Mechanism__c> imInsertList = new List<Implementing_Mechanism__c>();
        Map<string,Data_Template__c> uniqueChildInds = new Map<string,Data_Template__c>();
        Map<string,Data_Template__c> uniqueResults = new Map<string,Data_Template__c>();
        
        List<OrgUnit_Indicator__c> newMasterInds = new List<OrgUnit_Indicator__c>();
        List<OrgUnit_Indicator__c> newChildInds = new List<OrgUnit_Indicator__c>();
        List<Indicator_Results__c> newResults = new List<Indicator_Results__c>();
        
        Map<string,OrgUnit_Indicator__c> eCustomOrgInds = new Map<string,OrgUnit_Indicator__c>();
        set<string> uniqueOrgUnits = new set<string>();
        for (Data_template__c dt: scope){
            uniqueOrgUnits.add(dt.ouCode__c);
        }
        for(OrgUnit_Indicator__c oind: [Select Id, Name, indCode__c, sIndcode__c, indName__c, sindName__c From OrgUnit_Indicator__c
                                     Where ouCode__c in :uniqueOrgUnits and Implementing_Mechanism_Id__c = null 
                                     and custom__c = true
                                     and sindName__c = null
                                     and RecordType.Name = 'Master']){
           
                eCustomOrgInds.put(oind.indName__c,oind);
                
        }
        
        Map<string,OrgUnit_Indicator__c> eCustomSubOrgInds = new Map<string,OrgUnit_Indicator__c>();
        for(OrgUnit_Indicator__c oind: [Select Id, Name, indCode__c, sIndcode__c, indName__c, sindName__c From OrgUnit_Indicator__c
                                     Where ouCode__c in :uniqueOrgUnits and Implementing_Mechanism_Id__c = null 
                                     and custom__c = true
                                     and sIndName__c != null
                                     and RecordType.Name = 'Master']){
           
                eCustomSubOrgInds.put(oind.sindName__c,oind);
                
        }
        
        if (flagStr.equalsIgnoreCase('Master')){
            for (Data_template__c dt: scope){            
                if(dt.Implementing_Mechanism_Id__c != null){
                    imIds.put(dt.Implementing_Mechanism_Id__c,dt);
                    IMUpdateCount = IMUpdateCount +1;
                } else {
                    if (dt.IM_Award_Number__c != null){
                        imDocs.put(dt.IM_Award_Number__c,dt);  
                        IMCreateCount = IMCreateCount +1;
                    }                  
                }                
            }
           
            if(!imIds.isEmpty()){
                MAp<Id,Implementing_Mechanism__c> existingIMS = new Map<Id,Implementing_Mechanism__c>([Select Id, Name, Award_Id__c,RecordTypeId, ouId__c, Document__c  
                                                   From Implementing_Mechanism__c
                                                   Where (Id in : imIds.keySet()                                                   
                                                   Or Document__c in :imIds.keySet())
                                                   and ouCode__c in :uniqueOrgUnits]);
              //  for(Implementing_Mechanism__c im: [Select Id, Name, Award_Id__c,RecordTypeId, ouId__c, Document__c  
              //                                     From Implementing_Mechanism__c
              //                                     Where Id in : imIds.keySet()
              //                                     Or Document__c in :imIds.keySet()]){
              for(String imIdOrAward : imIds.keySet()){
                    if (existingIMS.containsKey(imIdOrAward)){
                        Implementing_Mechanism__c im =  existingIMS.get(imIdOrAward); 
                        im.RecordTypeId =  imRecTypesMap.get('Advanced');
                        im.Award_Id__c = imIds.get(imIdOrAward).Award_Id__c; 
                        im.Reporting_Level__c = 'Implementing Mechanism'; 
                        im.start_date__c = imIds.get(imIdOrAward).Start_Date__c;
                        im.end_date__c = imIds.get(imIdOrAward).End_Date__c; 
                        im.Award_Number__c = imIds.get(imIdOrAward).Award_Document__c; 
                        im.indicators_established__c = true;                               
                        imUpdateList.add(im);  
                  //  } else {                               
                  //      imUpsertList.add(new Implementing_Mechanism__c(RecordTypeId = imRecTypesMap.get('Advanced'),
                  //                                                  ouId__c = imIds.get(imIdOrAward).Organization_Id__c,
                  //                                                  Reporting_Level__c = 'Implementing Mechanism',
                  //                                                  Award_Id__c = imIds.get(imIdOrAward).Award_Id__c, 
                  //                                                  start_date__c = imIds.get(imIdOrAward).Start_Date__c,
                  //                                                  end_date__c = imIds.get(imIdOrAward).End_Date__c));                               
                    }
                }       
            }
            if (!imDocs.isEmpty()){
                MAp<String,Implementing_Mechanism__c> existingIMSByDocs = new Map<String,Implementing_Mechanism__c>();
                for(Implementing_Mechanism__c im1: [Select Id, Name, Award_Id__c,RecordTypeId, ouId__c, Document__c,
                                                    Award_Number__c      
                                                   From Implementing_Mechanism__c
                                                   Where Award_Number__c in :imDocs.keySet()
                                                   and ouCode__c in :uniqueOrgUnits
                                                  ]){
                                                  
                         existingIMSByDocs.put(im1.Award_Number__c,im1);                                 
                }                                  
                for(String dtIm: imDocs.keySet()){
                    if(!existingIMSByDocs.containsKey(dtIm)){
                        imInsertList.add(new Implementing_Mechanism__c(RecordTypeId = imRecTypesMap.get('Advanced'),
                                                                    Implementing_Mechanism_Name__c = 'N/A',    
                                                                    ouId__c = imDocs.get(dtIm).Organization_Id__c,
                                                                    Reporting_Level__c = 'Implementing Mechanism',
                                                                    Award_Id__c = imDocs.get(dtIm).Award_Id__c, 
                                                                    Award_Number__c = imDocs.get(dtIm).IM_Award_Number__c,
                                                                    start_date__c = imDocs.get(dtIm).Start_Date__c,
                                                                    indicators_established__c = true,
                                                                    end_date__c = imDocs.get(dtIm).End_Date__c));
                    }                                                
                }        
            }
            if(!imUpdateList.isEmpty()){
                update imUpdateList;
            }
            
            if(!imInsertList.isEmpty()){
               // ApplicationConstants.bypassIMCreateVendorTriggerLogic = true;
                insert imInsertList;
            }
             
            
            
        } else if(flagStr.equalsIgnoreCase('MasterInd')){
            for (Data_template__c dt: scope){
                if(dt.OrgUnit_Indicator_Master_Id__c == null){
                    if(dt.Indicator_Id__c.trim().equalsIgnoreCase('custom')){
                        if(dt.Temp_Custom_Master_Indicator_code__c != null && dt.Temp_Custom_Master_Indicator_code__c != ''
                        && dt.Temp_Custom_Master_Indicator_code__c != dt.Temp_Custom_Indicator_code__c){
                            if(!eCustomSubOrgInds.containsKey(dt.indicator__c)){
                                customMasterSubIndNames.put(dt.Temp_Custom_Indicator_code__c,dt);
                                MasterCustomSubindicatorCount = MasterCustomSubindicatorCount + 1;
                            }    
                            if(!eCustomOrgInds.containsKey(dt.Master_Indicator_Name__c) && (dt.Temp_Custom_Master_Indicator_code__c == null || dt.Temp_Custom_Master_Indicator_code__c == '')){
                                customMasterIndNames.put(dt.Temp_Custom_Master_Indicator_code__c,dt);
                                MasterCustomIndicatorCount = MasterCustomIndicatorCount + 1;
                            }    
                        } else { 
                            if(!eCustomOrgInds.containsKey(dt.indicator__c)){   
                                customMasterIndNames.put(dt.Temp_Custom_Indicator_code__c,dt);
                                MasterCustomIndicatorCount = MasterCustomIndicatorCount + 1;
                            }    
                        }                    
                    } else {                  
                        masterIndsubIndCodes.put(dt.indicator_Id__c,dt);
                        MasterStandardIndicatorscount = MasterStandardIndicatorscount + 1;
                    }
                }
            }
            system.debug('Master Ind Sub Ind Codes::'+masterIndsubIndCodes); 
            
            if (!masterIndsubIndCodes.isEmpty()){
                Map<string,OrgUnit_Indicator__c> eOrgInds = new Map<string,OrgUnit_Indicator__c>();
                for(OrgUnit_Indicator__c oind: [Select Id, Name, indCode__c, sIndcode__c From OrgUnit_Indicator__c
                                             Where ouCode__c in :uniqueOrgUnits and Implementing_Mechanism_Id__c = null 
                                             and custom__c = false
                                             and RecordType.Name = 'Master']){
                    if(oind.sIndcode__c != null && oind.sIndcode__c != '' ){
                        eOrgInds.put(oind.sIndcode__c,oind);
                    } else {
                        eOrgInds.put(oind.indcode__c,oind);
                    }    
                }
                for(Data_Template__c dtmi: masterIndsubIndCodes.values()){
                  if(eOrgInds.isEmpty() || !eOrgInds.containsKey(dtmi.Indicator_Id__c) || !eOrgInds.containsKey(dtmi.Master_Indicator_Code__c)){                  
                    if (dtmi.Master_Indicator_Code__c != null && dtmi.Master_Indicator_Code__c != '' 
                        && dtmi.Master_Indicator_Code__c != dtmi.Indicator_Id__c){
                        newMasterInds.add(new OrgUnit_Indicator__c(RecordTypeId = orgIndicatorRecTypesMap.get('Master'),
                                                                    ouId__c = dtmi.Organization_Id__c,
                                                                    USAID_Indicator_Id__c = dtmi.USAID_Indicator_Id__c,
                                                                   // prCode__c = dtmi.Program_Element__c.trim().split(' ')[0],
                                                                   // prName__c = dtmi.Program_Element__c.trim().split(' ')[1],
                                                                    prCode__c = dtmi.Program_Element_Code__c.trim(),
                                                                    prName__c = dtmi.Program_Element__c.trim(),
                                                                    indCode__c = dtmi.Master_Indicator_Code__c,
                                                                    indName__c = dtmi.Master_Indicator_Name__c,
                                                                    sIndCode__c = dtmi.indicator_Id__c,
                                                                    IM_Indicators_Established__c = true,
                                                                    Name = dtmi.indicator_Id__c,
                                                                  //  source__c = 'STANDARD',
                                                                    source__c = dtmi.Indicator_Source__c,  
                                                                    sIndName__c = dtmi.indicator__c ));
                    } else {
                            newMasterInds.add(new OrgUnit_Indicator__c(RecordTypeId = orgIndicatorRecTypesMap.get('Master'),
                                                                    ouId__c = dtmi.Organization_Id__c,
                                                                    USAID_Indicator_Id__c = dtmi.USAID_Indicator_Id__c,
                                                                   // prCode__c = dtmi.Program_Element__c.trim().split(' ')[0],
                                                                   // prName__c = dtmi.Program_Element__c.trim().split(' ')[1],
                                                                   prCode__c = dtmi.Program_Element_Code__c.trim(),
                                                                    prName__c = dtmi.Program_Element__c.trim(),
                                                                   // source__c = 'STANDARD',
                                                                   source__c = dtmi.Indicator_Source__c,
                                                                   IM_Indicators_Established__c = true,
                                                                   Name =  dtmi.indicator_Id__c,                                                               
                                                                    indCode__c = dtmi.indicator_Id__c,
                                                                    indName__c = dtmi.indicator__c ));                                                                
                   }  
                 }                                                 
                }            
            }
            Map<string,string> customIndcodes = new Map<string,string>();
            if (!customMasterIndNames.isEmpty()){
             //   Map<string,OrgUnit_Indicator__c> eCustomOrgInds = new Map<string,OrgUnit_Indicator__c>();
             //   for(OrgUnit_Indicator__c oind: [Select Id, Name, indCode__c, sIndcode__c, indName__c, sindName__c From OrgUnit_Indicator__c
             //                                Where ouCode__c = 'Rwanda' and Implementing_Mechanism_Id__c = null 
             //                                and custom__c = true
             //                                and sindName__c = null
             //                                and RecordType.Name = 'Master']){
             //      
              //          eCustomOrgInds.put(oind.indName__c,oind);
              //          
               // }
                customIndcodes = dtth.prepareCustomIndicatorCodes(customMasterIndNames);
               
                for(Data_Template__c dtmi: customMasterIndNames.values()){
                   // system.debug('Data Template Id::'+dtmi.Id);
                   // system.debug('Custom Indicator codes::'+customIndcodes);
                   // system.debug('Master Indicator Name::'+dtmi.Master_indicator_Name__c);
                   // system.debug('Custom Indicator codes::'+customIndcodes.get(dtmi.Master_indicator_Name__c));
                   // system.debug('Custom Indicator codes::'+customSubIndCodes.get(dtmi.indicator__c));
                   if(eCustomOrgInds.isEmpty() || !eCustomOrgInds.containsKey(dtmi.indicator__c)){
                    newMasterInds.add(new OrgUnit_Indicator__c(RecordTypeId = orgIndicatorRecTypesMap.get('Master'),
                                                                    ouId__c = dtmi.Organization_Id__c, 
                                                                    custom__c = true,
                                                                   // prCode__c = dtmi.Program_Element__c.trim().split(' ')[0],
                                                                   // prName__c = dtmi.Program_Element__c.trim().split(' ')[1], 
                                                                   prCode__c = dtmi.Program_Element_Code__c.trim(),
                                                                    prName__c = dtmi.Program_Element__c.trim(),
                                                                    IM_Indicators_Established__c = true,
                                                                    source__c = dtmi.Indicator_Source__c != null && dtmi.Indicator_Source__c != '' ? dtmi.Indicator_Source__c : 'STANDARD',
                                                                    Name = dtmi.Temp_Custom_Master_Indicator_code__c != null ? customIndcodes.get(dtmi.Temp_Custom_Master_Indicator_code__c) : customIndcodes.get(dtmi.Temp_Custom_Indicator_code__c),                                                                                                                                   
                                                                    indCode__c = dtmi.Temp_Custom_Master_Indicator_code__c != null ? customIndcodes.get(dtmi.Temp_Custom_Master_Indicator_code__c) : customIndcodes.get(dtmi.Temp_Custom_Indicator_code__c),                                                                    
                                                                    indName__c = dtmi.Master_indicator_Name__c != null ? dtmi.Master_indicator_Name__c : dtmi.indicator__c));
                   }                                                                                                                     
                }
            }
            
            if (!customMasterSubIndNames.isEmpty()){
                if (!eCustomOrgInds.isEmpty()){
                    for(OrgUnit_Indicator__c cInd: eCustomOrgInds.values()){
                        customIndcodes.put(cInd.indName__c, cInd.indCode__c);
                    }
                }
                Map<string,string> customSubIndCodes = dtth.prepareCustomSubIndicatorCodes(customMasterSubIndNames,customIndcodes);
              //  Map<string,OrgUnit_Indicator__c> eCustomSubOrgInds = new Map<string,OrgUnit_Indicator__c>();
              //  for(OrgUnit_Indicator__c oind: [Select Id, Name, indCode__c, sIndcode__c, indName__c, sindName__c From OrgUnit_Indicator__c
              //                               Where ouCode__c = 'Rwanda' and Implementing_Mechanism_Id__c = null 
              //                               and custom__c = true
              //                               and sIndName__c != null
              //                               and RecordType.Name = 'Master']){
               //    
                //        eCustomSubOrgInds.put(oind.sindName__c,oind);
                        
               // }
                for(Data_Template__c dtmi: customMasterSubIndNames.values()){
                  //  system.debug('Data Template Id::'+dtmi.Id);
                  //  system.debug('Custom Indicator codes::'+customIndcodes);
                  //  system.debug('Master Indicator Name::'+dtmi.Master_indicator_Name__c);
                  //  system.debug('Custom Indicator codes::'+customIndcodes.get(dtmi.Master_indicator_Name__c));
                  //  system.debug('Custom Indicator codes::'+customSubIndCodes.get(dtmi.indicator__c));
                  if(eCustomSubOrgInds.isEmpty() || !eCustomSubOrgInds.containsKey(dtmi.indicator__c)){
                    newMasterInds.add(new OrgUnit_Indicator__c(RecordTypeId = orgIndicatorRecTypesMap.get('Master'),
                                                                    ouId__c = dtmi.Organization_Id__c, 
                                                                    custom__c = true,
                                                                    IM_Indicators_Established__c = true,
                                                                    source__c = dtmi.Indicator_Source__c != null && dtmi.Indicator_Source__c != '' ? dtmi.Indicator_Source__c : dtmi.Master_Indicator_Code__c != null ? 'STANDARD' :'STANDARD',
                                                                    Name = customSubIndCodes.get(dtmi.Temp_Custom_Indicator_code__c),
                                                                   // prCode__c = dtmi.Program_Element__c.trim().split(' ')[0],
                                                                   // prName__c = dtmi.Program_Element__c.trim().split(' ')[1],    
                                                                   prCode__c = dtmi.Program_Element_Code__c.trim(),
                                                                    prName__c = dtmi.Program_Element__c.trim(),                                                                                                                               
                                                                    indCode__c = dtmi.Master_indicator_Code__c != null ? dtmi.Master_indicator_Code__c : 
                                                                    customIndcodes.containsKey(dtmi.Temp_Custom_Master_Indicator_code__c) ? customIndcodes.get(dtmi.Temp_Custom_Master_Indicator_code__c) : customIndcodes.get(dtmi.Master_indicator_Name__c),                                                                    
                                                                    indName__c = dtmi.Master_indicator_Name__c,
                                                                    sIndCode__c = customSubIndCodes.get(dtmi.Temp_Custom_Indicator_code__c),
                                                                    sIndName__c = dtmi.indicator__c)); 
                  }                                                                                                                     
                }
            }
            
            if(!newMasterInds.isEmpty()){
                insert newMasterInds;
            }       
        } else if(flagStr.equalsIgnoreCase('Child')){
            set<Id> masterIndIds = new set<Id>();
            for (Data_template__c dt: scope){
                if(dt.Implementing_Mechanism_Id__c != null && dt.OrgUnit_Indicator_Master_Id__c != null){
                    uniqueChildInds.put((string)dt.Implementing_Mechanism_Id__c+(string)dt.OrgUnit_Indicator_Master_Id__c,dt);
                    masterIndIds.add(dt.OrgUnit_Indicator_Master_Id__c);
                    IMIndicatorCount  = IMIndicatorCount + 1;
                } else {
                    skippedIMIndicatorCount = skippedIMIndicatorCount + 1;
                }
            }
            if (!uniqueChildInds.isEmpty()){
                Map<Id,OrgUnit_Indicator__c> masterIndMap = new Map<Id,OrgUnit_Indicator__c>([Select Id, Name, indCode__c,
                                                                    indName__c, sindCode__c, sIndName__c, custom__c, source__c
                                                                    From OrgUnit_Indicator__c
                                                                    Where Id in :masterIndIds]);
                for(Data_Template__c dtc: uniqueChildInds.values()){
                    if(dtc.Indicator_Id__c != 'custom'){
                        if (dtc.Master_Indicator_Code__c != null && dtc.Master_Indicator_Code__c != ''
                            && dtc.Master_Indicator_Code__c != dtc.Indicator_Id__c){
                            newChildInds.add(new OrgUnit_Indicator__c(RecordTypeId = orgIndicatorRecTypesMap.get('Implementing Mechanism'),
                                                              ouId__c = dtc.Organization_Id__c,
                                                              Organization_Indicator_Id__c = dtc.OrgUnit_Indicator_Master_Id__c,
                                                              Implementing_Mechanism_Id__c = dtc.Implementing_Mechanism_Id__c, 
                                                              USAID_Indicator_Id__c = dtc.USAID_Indicator_Id__c,
                                                             // prCode__c = dtc.Program_Element__c.trim().split(' ')[0],
                                                             // prName__c = dtc.Program_Element__c.trim().split(' ')[1], 
                                                             prCode__c = dtc.Program_Element_Code__c.trim(),
                                                                    prName__c = dtc.Program_Element__c.trim(),
                                                             // source__c = 'STANDARD',    
                                                              Collection_Frequency__c = dtc.Reporting_Frequency__c.equalsIgnoreCase('annual') ? 'Annual' :
                                                                                        dtc.Reporting_Frequency__c.equalsIgnoreCase('Half Year/Semi-annual') ? 'Semi-Annual' :                                                                                                                                                                  
                                                                                        dtc.Reporting_Frequency__c.equalsIgnoreCase('quarterly') ? 'Quarterly' : '',
                                                              source__c = dtc.Indicator_Source__c,
                                                              Name = dtc.indicator_Id__c,
                                                              indCode__c = dtc.Master_Indicator_Code__c,                                                                    
                                                              indName__c = dtc.Master_Indicator_Name__c,
                                                              sIndCode__c = dtc.indicator_Id__c,
                                                              sIndName__c = dtc.indicator__c)); 
                        } else {
                            newChildInds.add(new OrgUnit_Indicator__c(RecordTypeId = orgIndicatorRecTypesMap.get('Implementing Mechanism'),
                                                              ouId__c = dtc.Organization_Id__c,
                                                              Organization_Indicator_Id__c = dtc.OrgUnit_Indicator_Master_Id__c,
                                                              Implementing_Mechanism_Id__c = dtc.Implementing_Mechanism_Id__c,
                                                              USAID_Indicator_Id__c = dtc.USAID_Indicator_Id__c, 
                                                            //  prCode__c = dtc.Program_Element__c.trim().split(' ')[0],
                                                            //  prName__c = dtc.Program_Element__c.trim().split(' ')[1], 
                                                            prCode__c = dtc.Program_Element_Code__c.trim(),
                                                                    prName__c = dtc.Program_Element__c.trim(),  
                                                              Collection_Frequency__c = dtc.Reporting_Frequency__c.equalsIgnoreCase('annual') ? 'Annual' :
                                                                                        dtc.Reporting_Frequency__c.equalsIgnoreCase('Half Year/Semi-annual') ? 'Semi-Annual' :                                                                                                                                                                  
                                                                                        dtc.Reporting_Frequency__c.equalsIgnoreCase('quarterly') ? 'Quarterly' : '',                                                                                                                                                                                             
                                                             // source__c = 'STANDARD',
                                                              source__c = dtc.Indicator_Source__c,
                                                              Name = dtc.indicator_Id__c,
                                                              indCode__c = dtc.indicator_Id__c,                                                                    
                                                              indName__c = dtc.indicator__c
                                                              ));
                        }                                         
                    } else {
                        if (dtc.Master_Indicator_Name__c != null && dtc.Master_Indicator_Name__c != ''
                            && dtc.Master_Indicator_Name__c != dtc.Indicator__c ){
                            newChildInds.add(new OrgUnit_Indicator__c(RecordTypeId = orgIndicatorRecTypesMap.get('Implementing Mechanism'),
                                                              ouId__c = dtc.Organization_Id__c,
                                                              Organization_Indicator_Id__c = dtc.OrgUnit_Indicator_Master_Id__c,  
                                                              Implementing_Mechanism_Id__c = dtc.Implementing_Mechanism_Id__c,
                                                              source__c = masterIndMap.get(dtc.OrgUnit_Indicator_Master_Id__c).source__c,
                                                            //  source__c = 'CUSTOM',
                                                            //  source__c = dtc.Master_Indicator_code__c != null && dtc.Master_Indicator_code__c != '' ? 'STANDARD' :'STANDARD',
                                                              Collection_Frequency__c = dtc.Reporting_Frequency__c.equalsIgnoreCase('annual') ? 'Annual' :
                                                                                        dtc.Reporting_Frequency__c.equalsIgnoreCase('Half Year/Semi-annual') ? 'Semi-Annual' :                                                                                                                                                                  
                                                                                        dtc.Reporting_Frequency__c.equalsIgnoreCase('quarterly') ? 'Quarterly' : '',
                                                             // prCode__c = dtc.Program_Element__c.trim().split(' ')[0],
                                                             // prName__c = dtc.Program_Element__c.trim().split(' ')[1],
                                                              prCode__c = dtc.Program_Element_Code__c.trim(),
                                                                    prName__c = dtc.Program_Element__c.trim(),
                                                              Name = masterIndMap.get(dtc.OrgUnit_Indicator_Master_Id__c).sindCode__c,
                                                              custom__c = masterIndMap.get(dtc.OrgUnit_Indicator_Master_Id__c).custom__c,                                                                                                                                                                                                                                                             
                                                              indCode__c = masterIndMap.get(dtc.OrgUnit_Indicator_Master_Id__c).indCode__c,                                                                    
                                                              indName__c = masterIndMap.get(dtc.OrgUnit_Indicator_Master_Id__c).indName__c,
                                                              sIndCode__c = masterIndMap.get(dtc.OrgUnit_Indicator_Master_Id__c).sindCode__c,
                                                              sIndName__c = masterIndMap.get(dtc.OrgUnit_Indicator_Master_Id__c).sindName__c)); 
                        } else {
                            newChildInds.add(new OrgUnit_Indicator__c(RecordTypeId = orgIndicatorRecTypesMap.get('Implementing Mechanism'),
                                                              ouId__c = dtc.Organization_Id__c,
                                                              Organization_Indicator_Id__c = dtc.OrgUnit_Indicator_Master_Id__c,
                                                              Implementing_Mechanism_Id__c = dtc.Implementing_Mechanism_Id__c,
                                                             // prCode__c = dtc.Program_Element__c.trim().split(' ')[0],
                                                             // prName__c = dtc.Program_Element__c.trim().split(' ')[1],                                                              
                                                             prCode__c = dtc.Program_Element_Code__c.trim(),
                                                                    prName__c = dtc.Program_Element__c.trim(),
                                                            //  source__c = 'CUSTOM',
                                                              source__c = masterIndMap.get(dtc.OrgUnit_Indicator_Master_Id__c).source__c,
                                                           // source__c = dtc.Master_Indicator_code__c != null && dtc.Master_Indicator_code__c != '' ? 'STANDARD' :'STANDARD',
                                                              Collection_Frequency__c = dtc.Reporting_Frequency__c.equalsIgnoreCase('annual') ? 'Annual' :
                                                                                        dtc.Reporting_Frequency__c.equalsIgnoreCase('Half Year/Semi-annual') ? 'Semi-Annual' :                                                                                                                                                                  
                                                                                        dtc.Reporting_Frequency__c.equalsIgnoreCase('quarterly') ? 'Quarterly' : '',
                                                              Name = masterIndMap.get(dtc.OrgUnit_Indicator_Master_Id__c).indCode__c,
                                                              custom__c = masterIndMap.get(dtc.OrgUnit_Indicator_Master_Id__c).custom__c,
                                                              indCode__c = masterIndMap.get(dtc.OrgUnit_Indicator_Master_Id__c).indCode__c,                                                                    
                                                              indName__c = masterIndMap.get(dtc.OrgUnit_Indicator_Master_Id__c).indName__c
                                                              ));
                        }
                    }                                          
                }
            }
            if(!newChildInds.isEmpty()){
                insert newChildInds;
            }
            
        } else if(flagStr.equalsIgnoreCase('Results')){
          //  Map<String,Double> baselineMap = new Map<String,Double>();
          //  Map<String,Double> targetsMap = new Map<String,Double>();
          //  Map<String,Double> actualsMap = new Map<String,Double>();
            //List<Indicator_Results__c> newResults =  new List<Indicator_Results__c>();
            for (Data_template__c dt: scope){
                if(dt.Reporting_Period_Id__c != null && dt.OrgUnit_Indicator_Id__c != null){
                    uniqueResults.put((string)dt.Reporting_Period_Id__c+(string)dt.OrgUnit_Indicator_Id__c,dt);
                    CreatedResultsCount = CreatedResultsCount + 1;                    
                } else {
                    skippedResultsCount = skippedResultsCount + 1;
                }
                
           /*     if (dt.Data_Category__c.equalsIgnoreCase('BaseLine')){
                    baselineMap.put((string)dt.Reporting_Period_Id__c+(string)dt.OrgUnit_Indicator_Id__c,dt.value__c);
                } else if (dt.Data_Category__c.equalsIgnoreCase('Target')){
                    targetsMap.put((string)dt.Reporting_Period_Id__c+(string)dt.OrgUnit_Indicator_Id__c,dt.value__c);
                } else if (dt.Data_Category__c.equalsIgnoreCase('Actual')){
                    actualsMap.put((string)dt.Reporting_Period_Id__c+(string)dt.OrgUnit_Indicator_Id__c,dt.value__c);
                } */
                
            }    
            
            
            for(Data_Template__c dtr : uniqueResults.values()){
                newResults.add(new Indicator_Results__c(Organization_Indicator_Id__c = dtr.OrgUnit_Indicator_Id__c,
                                                        Name = dtr.indCode__c,
                                                        Organization_Indicator_Master_Id__c = dtr.OrgUnit_Indicator_Master_Id__c,
                                                        Implementing_Mechanism_Id__c = dtr.Implementing_Mechanism_Id__c,
                                                        Reporting_Period_Id__c = dtr.Reporting_Period_Id__c,
                                                     /*   BaseLine__c = baselineMap.get((string)dtr.Reporting_Period_Id__c+(string)dtr.OrgUnit_Indicator_Id__c),
                                                        target__c = targetsMap.get((string)dtr.Reporting_Period_Id__c+(string)dtr.OrgUnit_Indicator_Id__c),
                                                        Actual__c = actualsMap.get((string)dtr.Reporting_Period_Id__c+(string)dtr.OrgUnit_Indicator_Id__c)) */
                                                        BaseLine__c = dtr.Baseline__c,
                                                        target__c = dtr.target__c,
                                                        Actual__c = dtr.actual__c));
            
            }
            
            if(!newResults.isEmpty()){
                insert newResults;
            }
        }
        
        upsert scope;
        
        
       
    
    }
    
    Public void finish(Database.BatchableContext BC){
        system.debug('***********************************************************');        
        system.debug('Number of IMs UPdated:::'+IMUpdateCount);
        system.debug('Number of IMs Created:::'+IMCreateCount);
        system.debug('Number of Master Standard Indicators:::'+MasterStandardIndicatorscount);
        system.debug('Number of Master Custom Indicators:::'+MasterCustomIndicatorCount);
        system.debug('Number of Master Custom Sub Indicators:::'+MasterCustomSubindicatorCount);
        system.debug('Number of IM Indicators Created:::' +IMIndicatorCount);
        system.debug('Number of IM Indicators skipped:::'+skippedIMIndicatorCount);
        system.debug('Number of Results Inserted:::'+CreatedResultsCount);
        system.debug('Number of Results Skipped:::'+skippedResultsCount);
        system.debug('***********************************************************');
    
    
    
    }
    
}