trigger populateExistingReferences on Data_template__c (before insert,before update) {
    set<string> uniqueOrgUnits = new Set<string>();
    set<string> uniqueStdIndCodes = new set<string>();
    set<string> docsNewIMs = new set<string>();
    List<Data_Template__c> scopeTemplates = new List<Data_Template__c>();
   // if (Trigger.isInsert){
   //     scopeTemplates = trigger.new;
   // } else if(Trigger.isUpdate){
   //     scopeTemplates = trigger.old;
   // }
        
    Map<string,OrgUnit__c> existingOrgUnits = new Map<string,OrgUnit__c>();
    Map<string,Map<string,Award__c>> existingAwards = new Map<string,Map<string,Award__c>>();
    Map<string,Map<string,Implementing_Mechanism__c>> existingIMs = new Map<string,Map<string,Implementing_Mechanism__c>>();
    Map<string,Map<string,OrgUnit_Indicator__c>> existingMasterIndicators = new Map<string,Map<string,OrgUnit_Indicator__c>>();
    Map<string,Map<string,OrgUnit_Indicator__c>> existingIMIndicators = new Map<string,Map<string,OrgUnit_Indicator__c>>();
    Map<string,Map<string,Reporting_Period__c>> existingIMPeriods = new Map<string,Map<string,Reporting_Period__c>>();
    Map<string,Indicator_Results__c> existingIMResults = new Map<string,Indicator_Results__c>();
    
    Map<string,USAID_Indicator__c> existingUSAIDIndicators = new Map<string,USAID_Indicator__c>();
    DataTemplateTriggerHelper dtth = new DataTemplateTriggerHelper();
    for(Data_Template__c dt: trigger.new){
        if(dt.ouCode__c != null && dt.ouCode__c != ''){
            uniqueOrgUnits.add(dt.ouCode__c);
        }    
        if (dt.Indicator_ID__c != null && dt.Indicator_ID__c != '' && dt.Indicator_ID__c != 'Custom'){
            uniqueStdIndCodes.add(dt.Indicator_ID__c);
        }   
        if((dt.IM_Id__c == null || dt.IM_Id__c == '') && dt.IM_AWARD_Number__c != null && dt.IM_AWARD_Number__c != ''){
            docsNewIMs.add(dt.IM_AWARD_Number__c);
        } 
    }
    
    system.debug('Unique OrgUnit Names::' +uniqueOrgUnits);
    system.debug('Unique Indicator codes ::' +uniqueStdIndCodes);
    if (!uniqueOrgUnits.isEmpty()){        
        existingOrgUnits = dtth.getExistingOrgUnits(uniqueOrgUnits);
        existingAwards = dtth.getExistingAwards(uniqueOrgUnits);
        existingIMs = dtth.getExistingImplementingMechanisms(uniqueOrgUnits,docsNewIMs);
        existingMasterIndicators = dtth.getExistingMasterIndicators(uniqueOrgUnits);
        existingIMIndicators = dtth.getExistingChildIndicators(uniqueOrgUnits,docsNewIMs);
        existingIMPeriods = dtth.getExistingReportingPeriods(uniqueOrgUnits,docsNewIMs);
        existingIMResults = dtth.getExistingIndicatorResults(uniqueOrgUnits,docsNewIMs);
    }
    
    if (!uniqueStdIndCodes.isEmpty()){        
        existingUSAIDIndicators = dtth.getExistingStandardIndicators(uniqueStdIndCodes);
    } 
    
    // Update Existing References back on Data Template Or build corresponding error message.
    for(Data_Template__c dt: trigger.new){
        if(dt.Time_Period__c != null && dt.Time_Period__c.equalsIgnoreCase('Annual')){
            dt.Time_Period__c = 'Annual';
        }
        if(existingOrgUnits.containsKey(dt.ouCode__c)){
            dt.Organization_Id__c = existingOrgUnits.get(dt.ouCode__c).Id;
            if(existingUSAIDIndicators.containsKey(dt.Indicator_Id__c) || dt.Indicator_Id__c == 'Custom' ){
                if (dt.Indicator_Id__c != 'Custom' ){
                    dt.USAID_Indicator_Id__c = existingUSAIDIndicators.get(dt.Indicator_Id__c).Id;
                }    
                if(!existingAwards.isEmpty() && existingAwards.containsKey(dt.ouCode__c)){
                    Map<string,Award__c> eAwards = existingAwards.get(dt.ouCode__c);
                    if (eAwards.containsKey(dt.IM_Award_Number__c)){
                        dt.Award_Id__c = eAwards.get(dt.IM_Award_Number__c).Id;
                    }    
                        if(!existingIMs.isEmpty() && existingIMs.containsKey(dt.ouCode__c)){
                            Map<string, Implementing_Mechanism__c> eIMs = existingIMs.get(dt.ouCode__c);                            
                            if(eIMs.containsKey(dt.IM_Award_Number__c) || eIMs.containsKey(dt.IM_ID__c)){
                                dt.Implementing_Mechanism_Id__c = eIMs.containsKey(dt.IM_ID__c) ? 
                                                                    eIMs.get(dt.IM_ID__c).Id : 
                                                                    eIMs.get(dt.IM_Award_Number__c).Id;
                                if(eIMs.containsKey(dt.IM_Award_Number__c)){
                                    dt.IM_Id__c = eIMs.get(dt.IM_Award_Number__c).Name;
                                }       
                                system.debug('Reporting Period IM ID:::'+dt.IM_Id__c);  
                                if(dt.Time_Period__c != null){                           
                                if(!existingIMPeriods.isEmpty() && (existingIMPeriods.containsKey(dt.ouCode__c+'::'+dt.IM_Award_Number__c) ||
                                                                existingIMPeriods.containsKey(dt.ouCode__c+'::'+dt.IM_ID__c) )){
                                    Map<string, Reporting_Period__c> ePeriods = existingIMPeriods.containsKey(dt.ouCode__c+'::'+dt.IM_ID__c) ?
                                                                        existingIMPeriods.get(dt.ouCode__c+'::'+dt.IM_ID__c) :                                
                                                                        existingIMPeriods.get(dt.ouCode__c+'::'+dt.IM_Award_Number__c);
                                    String dtPeriodName = dtth.getDTPeriodName(dt);                                        
                                    if(ePeriods.containsKey(dtPeriodName)){
                                        dt.Reporting_Period_Id__c = ePeriods.get(dtPeriodName).Id;
                                        if(existingIMResults.containsKey(dt.ouCode__c+'::'+dt.IM_Award_Number__c+'::'+dt.Indicator_Id__c+'::'+dtPeriodName)){
                                            dt.Indicator_Results_Id__c = existingIMResults.get(dt.ouCode__c+'::'+dt.IM_Award_Number__c+'::'+dt.Indicator_Id__c+'::'+dtPeriodName).Id;
                                        }
                                        if(existingIMResults.containsKey(dt.ouCode__c+'::'+dt.IM_Id__c+'::'+dt.Indicator_Id__c+'::'+dtPeriodName)){
                                            dt.Indicator_Results_Id__c = existingIMResults.get(dt.ouCode__c+'::'+dt.IM_Id__c+'::'+dt.Indicator_Id__c+'::'+dtPeriodName).Id;
                                        }
                                        if(existingIMResults.containsKey(dt.ouCode__c+'::'+dt.IM_Award_Number__c+'::'+dt.Indicator__c+'::'+dtPeriodName)){
                                            dt.Indicator_Results_Id__c = existingIMResults.get(dt.ouCode__c+'::'+dt.IM_Award_Number__c+'::'+dt.Indicator__c+'::'+dtPeriodName).Id;
                                        }
                                        if(existingIMResults.containsKey(dt.ouCode__c+'::'+dt.IM_Id__c+'::'+dt.Indicator__c+'::'+dtPeriodName)){
                                            dt.Indicator_Results_Id__c = existingIMResults.get(dt.ouCode__c+'::'+dt.IM_Id__c+'::'+dt.Indicator__c+'::'+dtPeriodName).Id; 
                                        
                                        
                                        }                                        
                                    }
                                   }                             
                                } else {
                                    dt.Generate_Periods__c = true;
                                }                                   
                            }
                        }
                        
                        if(existingMasterIndicators.containsKey(dt.ouCode__c)){
                            Map<string, OrgUnit_Indicator__c> eMInds = existingMasterIndicators.get(dt.ouCode__c);
                            if(dt.Indicator_ID__c.trim().equalsIgnoreCase('custom')){
                                if(eMInds.containsKey(dt.Indicator__c)){
                                    dt.OrgUnit_Indicator_Master_Id__c = eMInds.get(dt.Indicator__c).Id;
                                }
                            } else {
                                if(eMInds.containsKey(dt.Indicator_ID__c)){
                                    dt.OrgUnit_Indicator_Master_Id__c = eMInds.get(dt.Indicator_ID__c).Id;
                                }
                            }    
                        }
                        
                        if(existingIMIndicators.containsKey(dt.ouCode__c+'::'+dt.IM_Award_Number__c) || 
                           existingIMIndicators.containsKey(dt.ouCode__c+'::'+dt.IM_ID__c) ){
                            Map<string, OrgUnit_Indicator__c> eCInds = existingIMIndicators.containsKey(dt.ouCode__c+'::'+dt.IM_Award_Number__c) ?
                                                                        existingIMIndicators.get(dt.ouCode__c+'::'+dt.IM_Award_Number__c) :
                                                                        existingIMIndicators.get(dt.ouCode__c+'::'+dt.IM_ID__c);
                            if(dt.Indicator_ID__c.trim().equalsIgnoreCase('custom')){
                                if(eCInds.containsKey(dt.Indicator__c)){
                                    dt.OrgUnit_Indicator_Id__c = eCInds.get(dt.Indicator__c).Id;
                                }
                            } else {
                                if(eCInds.containsKey(dt.Indicator_ID__c)){
                                    dt.OrgUnit_Indicator_Id__c = eCInds.get(dt.Indicator_ID__c).Id;
                                }
                            }    
                        }
                        
                  //  } else {
                  //      dt.Comments__c = 'Award by Document Not found.';
                  //      dt.isError__c = true;
                  //      dt.is_Processed__c = true;
                  //  }
                } else {
                    dt.Comments__c = 'Awards Not found for Organization';
                    dt.isError__c = true;
                    dt.is_Processed__c= true;
                }   
            } else {
                dt.Comments__c = 'Standard Indicator Not Found';
                dt.isError__c = true;
                dt.is_Processed__c= true;
            }            
        } else {
            dt.Comments__c = 'No OrgUnit';
            dt.isError__c = true;
            dt.is_Processed__c= true;
        }
    } 
    
    
    
    
}