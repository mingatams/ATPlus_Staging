public with sharing class clsReportingPeriod {
    clsGlobalUtility GU = new clsGlobalUtility();
    
    public void createRFGoalReportingPeriod(Map<Id,CDCSGoal__c> rfGoals, Map<Id, CDCSLink__c> cLinks){      
        if(!rfGoals.isEmpty() && !cLinks.isEmpty()){
            createReportingPeriods(rfGoals.keySet(),'CDCSGoal__c','Goal_Id__c','Annual',null,null,rfGoals,cLinks);
        }
    }
    
    public void RFDOReportingPeriod(Map<Id,Do__c> rfDos, Map<Id, CDCSLink__c> cLinks){
        Map<Id, CDCSGoal__c> goalsByDo = new Map<Id, CDCSGoal__c>();
        set<Id> uniqueGoalIds = new set<Id>();
        if(!rfDos.isEmpty()){
            for(Do__c d: rfDos.values()){
                uniqueGoalIds.add(d.CDCS_Goal__c);
            }
            for(Do__c d: rfDos.values()){
                Map<Id,CDCSGoal__c> goalsMap = new Map<Id, CDCSGoal__c>();
                if(goalsMap.containsKey(d.CDCS_Goal__c)){
                    goalsByDo.put(d.Id,goalsMap.get(d.CDCS_Goal__c));
                }
            }
        }
        
        if(!rfDos.isEmpty() && !goalsByDo.isEmpty()){
            createReportingPeriods(rfDos.keySet(),'DO__c','DO_Id__c','Annual',null,null,goalsByDo,cLinks);
        }       
    }
    
    public void RFIRReportingPeriod(Map<Id,IR__c> rfIrs, Map<Id, CDCSLink__c> cLinks){
        Map<Id, CDCSGoal__c> goalsByIr = new Map<Id, CDCSGoal__c>();
        set<Id> uniqueGoalIds = new set<Id>();
        if(!rfIrs.isEmpty()){
            for(IR__c ir: rfIrs.values()){
                uniqueGoalIds.add(ir.Goal_Sid__c);
            }
            for(IR__c ir: rfIrs.values()){
                Map<Id,CDCSGoal__c> goalsMap = new Map<Id, CDCSGoal__c>();
                if(goalsMap.containsKey(ir.Goal_Sid__c)){
                    goalsByIr.put(ir.Id,goalsMap.get(ir.Goal_Sid__c));
                }
            }
        }
        
        if(!rfIrs.isEmpty() && !goalsByIr.isEmpty()){
            createReportingPeriods(rfIrs.keySet(),'IR__c','Ir_Id__c','Annual',null,null,goalsByIr,cLinks);
        }       
    }
    
    public void RFSIRReportingPeriod(Map<Id,Sub_IR__c> rfSirs, Map<Id, CDCSLink__c> cLinks){
        Map<Id, CDCSGoal__c> goalsBySir = new Map<Id, CDCSGoal__c>();
        set<Id> uniqueGoalIds = new set<Id>();
        if(!rfSirs.isEmpty()){
            for(Sub_IR__c sir: rfSirs.values()){
                uniqueGoalIds.add(sir.Goal_Sid__c);
            }
            for(Sub_IR__c sir: rfSirs.values()){
                Map<Id,CDCSGoal__c> goalsMap = new Map<Id, CDCSGoal__c>();
                if(goalsMap.containsKey(sir.Goal_Sid__c)){
                    goalsBySir.put(sir.Id,goalsMap.get(sir.Goal_Sid__c));
                }
            }
        }
        
        if(!rfSirs.isEmpty() && !goalsBySir.isEmpty()){
            createReportingPeriods(rfSirs.keySet(),'Sub_Ir__c','SIR_Id__c','Annual',null,null,goalsBySir,cLinks);
        }       
    }
    
    
    public void createLFGoalReportingPeriod(Map<Id,LF_Goal__c> lfGoals, Map<Id, LogFrame_Tree__c> lfLinks){
        Map<Id,Project__c> projectsbyLFgoal = new Map<Id,Project__c>();
        set<Id> uniqueProjectIds = new set<Id>();
        if (!lfGoals.isEmpty()){
            for(LF_Goal__c lfg: lfGoals.values()){
                uniqueProjectIds.add(lfg.Project_Id__c);
            }           
            for(LF_Goal__c lfg: lfGoals.values()){
                Map<Id,Project__c> projectsMap  = getActiveProjects(uniqueProjectIds);
                if(projectsMap.containsKey(lfg.Project_Id__c)){
                    projectsbyLFgoal.put(lfg.Id,projectsMap.get(lfg.Project_Id__c));
                }   
            }
            
        }
        if(!lfGoals.isEmpty() && !projectsbyLFgoal.isEmpty()){
            createReportingPeriods(lfGoals.keySet(),'LF_Goal__c','LF_Goal_Id__c','Annual',projectsbyLFgoal,lfLinks,null,null);
        }
    }
    
    public void createLFPurposeReportingPeriod(Map<Id,LF_Purpose__c> lfPurposes, Map<Id, LogFrame_Tree__c> lfLinks){
        Map<Id,Project__c> projectsbyLFPurpose = new Map<Id,Project__c>();
        set<Id> uniqueProjectIds = new set<Id>();
        if (!lfPurposes.isEmpty()){
            for(LF_Purpose__c lfp: lfPurposes.values()){
                uniqueProjectIds.add(lfp.Project_Id__c);
            }           
            for(LF_Purpose__c lfp: lfPurposes.values()){
                Map<Id,Project__c> projectsMap  = getActiveProjects(uniqueProjectIds);
                if(projectsMap.containsKey(lfp.Project_Id__c)){
                    projectsbyLFPurpose.put(lfp.Id,projectsMap.get(lfp.Project_Id__c));
                }   
            }
        }
        if(!lfPurposes.isEmpty() && !projectsbyLFPurpose.isEmpty()){
            createReportingPeriods(lfPurposes.keySet(),'LF_Purpose__c','LF_Purpose_Id__c','Annual',projectsbyLFPurpose,lfLinks,null,null);
        }
    }
    
    public void createLFSubPurposeReportingPeriod(Map<Id,LF_SubPurpose__c> lfSubPurposes, Map<Id, LogFrame_Tree__c> lfLinks){
        Map<Id,Project__c> projectsbyLFSubPurpose = new Map<Id,Project__c>();
        set<Id> uniqueProjectIds = new set<Id>();
        if (!lfSubPurposes.isEmpty()){
            for(LF_SubPurpose__c lfsp: lfSubPurposes.values()){
                uniqueProjectIds.add(lfsp.Project_Id__c);
            }           
            for(LF_SubPurpose__c lfsp: lfSubPurposes.values()){
                Map<Id,Project__c> projectsMap  = getActiveProjects(uniqueProjectIds);
                if(projectsMap.containsKey(lfsp.Project_Id__c)){
                    projectsbyLFSubPurpose.put(lfsp.Id,projectsMap.get(lfsp.Project_Id__c));
                }   
            }
        }
        if(!lfSubPurposes.isEmpty() && !projectsbyLFSubPurpose.isEmpty()){
            createReportingPeriods(lfSubPurposes.keySet(),'LF_SubPurpose__c','LF_SubPurpose_Id__c','Annual',projectsbyLFSubPurpose,lfLinks,null,null);
        }
    }
    public void createLFOutputReportingPeriod(Map<Id,LF_Output__c> lfOutputs, Map<Id, LogFrame_Tree__c> lfLinks){
        Map<Id,Project__c> projectsbyLFOutput = new Map<Id,Project__c>();
        set<Id> uniqueProjectIds = new set<Id>();
        if (!lfOutputs.isEmpty()){
            for(LF_Output__c lfo: lfOutputs.values()){
                uniqueProjectIds.add(lfo.Project_Id__c);
            }           
            for(LF_Output__c lfo: lfOutputs.values()){
                Map<Id,Project__c> projectsMap  = getActiveProjects(uniqueProjectIds);
                if(projectsMap.containsKey(lfo.Project_Id__c)){
                    projectsbyLFOutput.put(lfo.Id,projectsMap.get(lfo.Project_Id__c));
                }   
            }
        }
        if(!lfOutputs.isEmpty() && !projectsbyLFOutput.isEmpty()){
            createReportingPeriods(lfOutputs.keySet(),'LF_Output__c','LF_Output_Id__c','Annual',projectsbyLFOutput,lfLinks,null,null);
        }
    }
    public void createLFInputReportingPeriod(Map<Id,LF_Input__c> lfInputs, Map<Id, LogFrame_Tree__c> lfLinks){
        Map<Id,Project__c> projectsbyLFInput = new Map<Id,Project__c>();
        set<Id> uniqueProjectIds = new set<Id>();
        if (!lfInputs.isEmpty()){
            for(LF_Input__c lfi: lfInputs.values()){
                uniqueProjectIds.add(lfi.Project_Id__c);
            }           
            for(LF_Input__c lfi: lfInputs.values()){
                Map<Id,Project__c> projectsMap  = getActiveProjects(uniqueProjectIds);
                if(projectsMap.containsKey(lfi.Project_Id__c)){
                    projectsbyLFInput.put(lfi.Id,projectsMap.get(lfi.Project_Id__c));
                }   
            }
        }
        if(!lfInputs.isEmpty() && !projectsbyLFInput.isEmpty()){
            createReportingPeriods(lfInputs.keySet(),'LF_Input__c','LF_Input_Id__c','Annual',projectsbyLFInput,lfLinks,null,null);
        }
    }
    
    private Map<Id, Project__c> getActiveProjects(set<Id> projectIds){
        List<SObject> projects = GU.lookup(projectIds, 'Id', 'Project__c');
        Map<Id,Project__c> projectsMap = new Map<Id,Project__c>();
        for(Sobject sObj: projects){
            Project__c proj = (Project__c) sObj;
            if (proj.start_Date__c != null && proj.End_Date__c != null){
                projectsMap.put(proj.Id, proj);
            }
        }
        return projectsMap;
    }
    
    
    public string createReportingPeriods(Set<Id> objIds, String objName,String whereCol,
                                        string periodicity, Map<Id,Project__c> projectsMap,                                         
                                        Map<Id, LogFrame_Tree__c> lfLinks, Map<Id,CDCSGoal__c> rfGoals, Map<Id, CDCSLink__c> cLinks ){
        if (objIds.isEmpty() || periodicity==null){
            return null;
        }
        List<LF_Reporting_Period__c> lfRPList = new List<LF_Reporting_Period__c>();        
        List<RF_Reporting_Period__c> rfRPList = new List<RF_Reporting_Period__c>();
        
        Map<String,LF_Reporting_Period__c> lfrpExistMap = new Map<String,LF_Reporting_Period__c>();
        Map<String,RF_Reporting_Period__c> rfrpExistMap = new Map<String,RF_Reporting_Period__c>();
        Map<String,String> recordTypes = new Map<String,String>();
        
        List<SObject> soList; 
        if (objName.startsWith('LF')){
            soList = GU.lookup(objIds,whereCol,'LF_Reporting_Period__c');
            recordTypes = GU.getRecordTypeByObject('LF_Reporting_Period__c');           
        } else {
            soList = GU.lookup(objIds,whereCol,'RF_Reporting_Period__c');
            recordTypes = GU.getRecordTypeByObject('RF_Reporting_Period__c');
        }
        for(SObject ob: soList){
            if (objName.startsWith('LF')){
                LF_Reporting_Period__c lfrp = (LF_Reporting_Period__c)ob;
                lfrpExistMap.put(lfrp.Name,lfrp);
            } else {
                RF_Reporting_Period__c rfrp = (RF_Reporting_Period__c)ob;
                rfrpExistMap.put(rfrp.Name,rfrp);
            }               
        }
        try{        
            for(Id recordId: objIds){
                Date qrtrStartDate;
                Date qrtrEndDate;
                if (objName.startsWith('LF')){
                    if(projectsMap.containsKey(recordId)){
                        qrtrStartDate = date.newInstance(projectsMap.get(recordId).start_Date__c.year()-1, 10, 1);
                        qrtrEndDate = date.newInstance(projectsMap.get(recordId).End_Date__c.year(), 09, 30);
                    }   
                } else {
                    if(rfGoals.containsKey(recordId)){
                        qrtrStartDate = date.newInstance(Integer.valueOf(rfGoals.get(recordId).Start_Year__c)-1, 10, 1);
                        qrtrEndDate = date.newInstance(Integer.valueOf(rfGoals.get(recordId).End_Year__c), 09, 30);
                    }   
                }
                if (qrtrStartDate != null){
                    Date repPeriod = qrtrStartDate;
                    Boolean initialPass = true;
                    while(repPeriod <= qrtrEndDate ){    
                        LF_Reporting_Period__c lfrp = new LF_Reporting_Period__c();
                        RF_Reporting_Period__c rfrp = new RF_Reporting_Period__c();
                        if (objName.equalsIgnoreCase('CDCSGoal__c')){
                            rfrp.Goal_Id__c = recordId;                    
                            rfrp.RecordTypeId=recordTypes.get('RF Goal');   
                            rfrp.CDCS_Link_Id__c = cLinks.get(recordId).Id;
                            rfrp.ouId__c = cLinks.get(recordId).ouId__c;                   
                        } else if (objName.equalsIgnoreCase('DO__c')){
                            rfrp.DO_Id__c = recordId;                        
                            rfrp.RecordTypeId=recordTypes.get('RF DO');
                            rfrp.CDCS_Link_Id__c = cLinks.get(recordId).Id;
                            rfrp.ouId__c = cLinks.get(recordId).ouId__c;
                        } else if (objName.equalsIgnoreCase('IR__c')){
                            rfrp.IR_Id__c = recordId;                        
                            rfrp.RecordTypeId=recordTypes.get('RF IR');
                            rfrp.CDCS_Link_Id__c = cLinks.get(recordId).Id;
                            rfrp.ouId__c = cLinks.get(recordId).ouId__c;
                        } else if (objName.equalsIgnoreCase('Sub_IR__c')){
                            rfrp.SIR_Id__c = recordId;                        
                            rfrp.RecordTypeId=recordTypes.get('RF SUB IR');
                            rfrp.CDCS_Link_Id__c = cLinks.get(recordId).Id;
                            rfrp.ouId__c = cLinks.get(recordId).ouId__c;
                        } else if (objName.equalsIgnoreCase('LF_Goal__c')){
                            lfrp.LF_Goal_Id__c = recordId;                        
                            lfrp.RecordTypeId=recordTypes.get('LF Goal');
                            lfrp.LogFrame_Tree_Id__c = lfLinks.get(recordId).Id;
                            lfrp.ouId__c = lfLinks.get(recordId).ouId__c;
                        } else if (objName.equalsIgnoreCase('LF_Purpose__c')){
                            lfrp.LF_Purpose_Id__c = recordId;                        
                            lfrp.RecordTypeId=recordTypes.get('LF Purpose');
                            lfrp.LogFrame_Tree_Id__c = lfLinks.get(recordId).Id;
                            lfrp.ouId__c = lfLinks.get(recordId).ouId__c;
                        } else if (objName.equalsIgnoreCase('LF_SubPurpose__c')){
                            lfrp.LF_SubPurpose_Id__c = recordId;                        
                            lfrp.RecordTypeId=recordTypes.get('LF Sub-Purpose');
                            lfrp.LogFrame_Tree_Id__c = lfLinks.get(recordId).Id;
                            lfrp.ouId__c = lfLinks.get(recordId).ouId__c;
                        } else if (objName.equalsIgnoreCase('LF_Output__c')){
                            lfrp.LF_Output_Id__c = recordId;                        
                            lfrp.RecordTypeId=recordTypes.get('LF Output');
                            lfrp.LogFrame_Tree_Id__c = lfLinks.get(recordId).Id;
                            lfrp.ouId__c = lfLinks.get(recordId).ouId__c;
                        } else if (objName.equalsIgnoreCase('LF_Input__c')){
                            lfrp.LF_Input_Id__c = recordId;                        
                            lfrp.RecordTypeId=recordTypes.get('LF Input');
                            lfrp.LogFrame_Tree_Id__c = lfLinks.get(recordId).Id;
                            lfrp.ouId__c = lfLinks.get(recordId).ouId__c;
                        }                    
                       
                       String fiscalPeriod;
                       Integer fiscalYear;
                        if (objName.startsWith('LF')){
                            fiscalPeriod = getFiscalPeriodx(periodicity,repPeriod);
                            fiscalYear = getFiscalYear(fiscalPeriod,repPeriod,initialPass);
                            initialPass=false;
                            lfrp.Fiscal_Period__c=fiscalPeriod;
                            lfrp.Name= string.valueOf(fiscalYear)+'-'+ fiscalPeriod;
                            lfrp.Fiscal_Year__c= string.valueOf(fiscalYear);
                            lfrp.Status__c='Draft';
                            lfrp.Start_Date__c=repPeriod;
                            lfrp.End_Date__c=qrtrEndDate>getPeriodEndDate(repPeriod,fiscalPeriod,fiscalYear) ? getPeriodEndDate(repPeriod,fiscalPeriod,fiscalYear):qrtrEndDate;
                            if(!lfrpExistMap.containsKey(string.valueOf(fiscalYear)+'-'+ fiscalPeriod)) {
                                lfRPList.add(lfrp);
                            }   
                        } else {
                         
                            fiscalPeriod = getFiscalPeriodx(periodicity,repPeriod);
                            fiscalYear = getFiscalYear(fiscalPeriod,repPeriod,initialPass);
                            initialPass = false;
                            rfrp.Fiscal_Period__c=fiscalPeriod;
                            rfrp.Name= string.valueOf(fiscalYear)+'-'+ fiscalPeriod;
                            rfrp.Fiscal_Year__c=string.valueOf(fiscalYear);
                            rfrp.Status__c='Draft';
                            rfrp.Start_Date__c=repPeriod;
                            rfrp.End_Date__c=qrtrEndDate>getPeriodEndDate(repPeriod,fiscalPeriod,fiscalYear) ? getPeriodEndDate(repPeriod,fiscalPeriod,fiscalYear):qrtrEndDate;
                            if(!rfrpExistMap.containsKey(string.valueOf(fiscalYear)+'-'+ fiscalPeriod)) {
                                rfRPList.add(rfrp);
                            }  
                        }
                        
                      System.debug('Calculated End Date::' +getPeriodEndDate(repPeriod,fiscalPeriod,fiscalYear));
                      repPeriod = getPeriodEndDate(repPeriod,fiscalPeriod,fiscalYear).addDays(1);
                    }//end for
                }
                
            }
            
            if (!lfRPList.isEmpty()){
                insert lfRPList;    
                system.debug('Reporting Periods -'+lfRPList);
            }
            
            if (!rfRPList.isEmpty()){
                insert rfRPList;    
                system.debug('Reporting Periods -'+rfRPList);
            }
            
         /*   if (objName.equalsIgnoreCase('CDCSGoal__c')){
                List<CDCSGoal__c> goals = new List<CDCSGoal__c>();
                for(CDCSGoal__c cg: rfGoals.values()){  
                    if(cg.start_date__c != null && cg.end_date__c != null){
                        cg.Reporting_Periods_Established__c = true;
                        goals.add(cg);              
                    }   
                }
                upsert goals;                              
            } else if (objName.equalsIgnoreCase('DO__c')){
                List<Do__c> dos = new List<Do__c>();
                for(Do__c d: rfDos){
                    if(rfGoals.containsKey(d.Goal_sId__c)){
                        d.Reporting_Periods_Established__c = true;
                        dos.add(d);
                    }
                }
                upsert dos;                
            } else if (objName.equalsIgnoreCase('IR__c')){
                List<IR__c> irs = new List<IR__c>();
                for(IR__c ir: rfIrs){
                    if(rfGoals.containsKey(ir.Goal_sId__c)){
                        ir.Reporting_Periods_Established__c = true;
                        irs.add(ir);
                    }
                }
                upsert irs;       
            } else if (objName.equalsIgnoreCase('Sub_IR__c')){
                List<Sub_IR__c> sirs = new List<Sub_IR__c>();
                for(Sub_IR__c sir: rfSIrs){
                    if(rfGoals.containsKey(sir.Goal_sId__c)){
                        sir.Reporting_Periods_Established__c = true;
                        sirs.add(sir);
                    }
                }
                upsert sirs;    
            } else if (objName.equalsIgnoreCase('LF_Goal__c')){
                List<LF_Goal__c> lfGoals = new List<LF_Goal__c>();
                for(LF_Goal__c lfGoal: lfGoals){
                    if(projectsMap.containsKey(lfGoal.LF_Goal_Id__c)){
                        lfGoal.Reporting_Periods_Established__c = true;
                        lfGoals.add(lfGoal);
                    }
                }
                upsert lfGoals;   
            } else if (objName.equalsIgnoreCase('LF_Purpose__c')){
                List<LF_Purpose__c> lfPurposes = new List<LF_Purpose__c>();
                for(LF_Purpose__c lfPurpose: lfPurposes){
                    if(projectsMap.containsKey(lfPurpose.LF_Goal_Id__c)){
                        lfPurpose.Reporting_Periods_Established__c = true;
                        lfPurposes.add(lfPurpose);
                    }
                }
                upsert lfPurposes;  
            } else if (objName.equalsIgnoreCase('LF_SubPurpose__c')){
                List<LF_SubPurpose__c> lfSPurposes = new List<LF_SubPurpose__c>();
                for(LF_SubPurpose__c lfSPurpose: lfSPurposes){
                    if(projectsMap.containsKey(lfSPurpose.LF_Goal_Id__c)){
                        lfSPurpose.Reporting_Periods_Established__c = true;
                        lfSPurposes.add(lfSPurpose);
                    }
                }
                upsert lfSPurposes;   
            } else if (objName.equalsIgnoreCase('LF_Output__c')){
                List<LF_Output__c> lfOutputs = new List<LF_Output__c>();
                for(LF_Output__c lfOutput: lfOutputs){
                    if(projectsMap.containsKey(lfOutput.LF_Goal_Id__c)){
                        lfOutput.Reporting_Periods_Established__c = true;
                        lfOutputs.add(lfOutput);
                    }
                }
                upsert lfOutputs;    
            } else if (objName.equalsIgnoreCase('LF_Input__c')){
                List<LF_Input__c> lfInputs = new List<LF_Input__c>();
                for(LF_Input__c lfInput: lfInputs){
                    if(projectsMap.containsKey(lfInput.LF_Goal_Id__c)){
                        lfInput.Reporting_Periods_Established__c = true;
                        lfInputs.add(lfInput);
                    }
                }
                upsert lfInputs;   
            } */
            
          return '';  
        } catch(Exception e){
            system.debug('Query Exception occured in createLFReportingPeriod -'+e.getStackTraceString());
                 e.setMessage('Could not create Reporting Period for Component -'+objIds+'\\n'+'Error -'+e.getMessage()+' occured in class clsREportingPeriod at line number -'+e.getLineNumber() );
                 throw(e);
        }
    }
    
    public string createIMReportingPeriods(Map<Id, Implementing_Mechanism__c> imMap){
            if (imMap.isEmpty())
                return null;
            
            //Implementing_Mechanism__c im = new Implementing_Mechanism__c();
            Map<String,String> recordTypes = new Map<String,String>();
            Set<Id> flagUpdateIms = new set<Id>(); 
            recordTypes = GU.getRecordTypeByObject('Reporting_Period__c');
            String objName = 'Implementing_Mechanism__c';
            String whereCol;
            Date sDate;
            Date eDate;
           
            
            List<Reporting_Period__c> rpList = new List<Reporting_Period__c>();
            
            Map<String,Reporting_Period__c> rpExistMap = new Map<String,Reporting_Period__c>();
            List<SObject> soList = GU.lookup(imMap.keySet(),'Implementing_Mechanism_Id__c','Reporting_Period__c');
            for(SObject ob: soList){
                Reporting_Period__c rp = (Reporting_Period__c)ob;
                rpExistMap.put(rp.Implementing_Mechanism_Id__c+rp.Name,rp);         
            }
            system.debug('IM Map in ReportingPeriod Creation::'+imMap);
            try{
                for(Implementing_Mechanism__c im: imMap.values()){
                    if(im.Start_Date__c != null && im.End_Date__c != null){
                        Date qrtrStartDate = im.Start_Date__c;
                        Date qrtrEndDate = im.End_Date__c;
                       integer j=2;
                       if (im.Reporting_Frequency__c=='Quarterly')
                           j=3;
                       else if(im.Reporting_Frequency__c=='Semi-Annual')
                           j=6;
                       else if(im.Reporting_Frequency__c=='Annual')
                           j=12;
                       flagUpdateIms.add(im.Id);    
                        
                        
                        Boolean initialPass = true;
                        for(integer i=1;i<=3;i=i+1) {
                            String Frequency;
                            if( i==1) Frequency = 'Quarterly';
                            else if(i==2) Frequency = 'Semi-Annual';
                            else if(i==3) Frequency = 'Annual';
                            
                            Date repPeriod =qrtrStartDate;
                            while(repPeriod <= qrtrEndDate ){     
                                Reporting_Period__c rp = new Reporting_Period__c();
                         
                                if (objName.equalsIgnoreCase('Implementing_Mechanism__c')){ 
                                    rp.Implementing_Mechanism_Id__c=im.Id;
                                    rp.RecordTypeId=recordTypes.get('Implementing Mechanism');                      
                                }                           
                                
                                String fiscalPeriod = getFiscalPeriodx(Frequency,repPeriod);
                                Integer fiscalYear = getFiscalYear(fiscalPeriod,repPeriod,initialPass);
                                initialPass = false;
                                rp.Fiscal_Period__c=fiscalPeriod;
                                rp.ouId__c = im.ouId__c;
                                rp.Name= string.valueOf(fiscalYear)+'-'+ fiscalPeriod;
                                rp.Fiscal_Year__c=string.valueOf(fiscalYear);
                                rp.Status__c='Draft';
                                rp.Start_Date__c=repPeriod;
                                Date dDate = qrtrEndDate>getPeriodEndDate(repPeriod,fiscalPeriod,fiscalYear) ? getPeriodEndDate(repPeriod,fiscalPeriod,fiscalYear):qrtrEndDate;
                                rp.End_Date__c= dDate;
                                
                                rp.Close_Date__c = dDate.addMonths(1); 
                                if(!rpExistMap.containsKey(im.Id+string.valueOf(fiscalYear)+'-'+ fiscalPeriod)) {            
                                    rpList.add(rp);
                                }
                                repPeriod = getPeriodEndDate(repPeriod,fiscalPeriod,fiscalYear).addDays(1);
                            }
                        }//end for
                    }   
                }
                if(!rpList.isEmpty()) {
                    insert rpList;
                    system.debug('Reporting Periods -'+rpList);
                }   
                
                List<SObject> imSoList = GU.lookup(flagUpdateIms,'ID','Implementing_Mechanism__c');
                    
                if (objName.equalsIgnoreCase('Implementing_Mechanism__c')) {
                    List<Implementing_Mechanism__c> imList = new List<Implementing_Mechanism__c>();
                    
                    for(SObject so: imSoList){
                        Implementing_Mechanism__c im = (Implementing_Mechanism__c) so;
                        if (!im.Reporting_Periods_Established__c){
                            ApplicationConstants.bypassIMSharingRulesTriggerLogic = true;
                            ApplicationConstants.bypassIMCreateVendorTriggerLogic = true;
                           //system.debug('Implementing Mechanism Record_::'+im);
                            im.Reporting_Periods_Established__c = true;
                            
                            imList.add(im);
                        }
                    }
                    if(!imList.isEmpty()){
                        ApplicationConstants.bypassIMCreateVendorTriggerLogic = true;
                        ApplicationConstants.bypassIMSharingRulesTriggerLogic = true;
                        upsert imList;
                    }                   
                }   
               return null;
            } catch(Exception e){
                 system.debug('Query Exception occured in createIMReportingPeriods -'+e.getStackTraceString());
                 e.setMessage('Could not create Reporting Periods for IMs - \\n'+'Error -'+e.getMessage()+' occured in class createRepPeriod by Id at line number -'+e.getLineNumber() );
                 throw(e);
            }
           // return null;
    }//end createRepPeriod
    
    /* ********************** End Of New Methods *******************************/
    
    
    
    public String createRepPeriod(String objId, String objName, 
                    String whereCol, 
                    String periodicity, Integer sYear, Integer eYear,CDCSLink__c cLink, LogFrame_Tree__c lfLink){
        if (objId==null || periodicity==null){
            return null;
        }   
        
        List<LF_Reporting_Period__c> lfRPList = new List<LF_Reporting_Period__c>();
        List<RF_Reporting_Period__c> rfRPList = new List<RF_Reporting_Period__c>();
      //  Date qrtrStartDate=getStartDate(periodicity,date.newInstance(sYear-1, 10, 1));  
        Date qrtrStartDate=date.newInstance(sYear-1, 10, 1);
        Date qrtrEndDate=date.newInstance(eYear, 09, 30);     
      //  Date qrtrEndDate=getEndDate(periodicity,date.newInstance(eYear, 09, 30));         
        Date repPeriod =qrtrStartDate;
        Map<String,LF_Reporting_Period__c> lfrpExistMap = new Map<String,LF_Reporting_Period__c>();
        Map<String,RF_Reporting_Period__c> rfrpExistMap = new Map<String,RF_Reporting_Period__c>();
        Map<String,String> recordTypes = new Map<String,String>();
        List<SObject> soList;
        if (objName.startsWith('LF')){
            soList = GU.lookup(objId,whereCol,'LF_Reporting_Period__c');
            recordTypes = GU.getRecordTypeByObject('LF_Reporting_Period__c');           
        } else {
            soList = GU.lookup(objId,whereCol,'RF_Reporting_Period__c');
            recordTypes = GU.getRecordTypeByObject('RF_Reporting_Period__c');
        }
        for(SObject ob: soList){
            if (objName.startsWith('LF')){
                LF_Reporting_Period__c lfrp = (LF_Reporting_Period__c)ob;
                lfrpExistMap.put(lfrp.Name,lfrp);
            } else {
                RF_Reporting_Period__c rfrp = (RF_Reporting_Period__c)ob;
                rfrpExistMap.put(rfrp.Name,rfrp);
            }               
        }
        try{
             //   for(integer i=1;i<=act.Activity_Start_Date__c.daysBetween(act.Activity_End_Date__c);i++){
               integer j=2;
               if (periodicity=='Quarterly')
                   j=3;
               else if(periodicity=='Semi-Annual')
                   j=6;
               else if(periodicity=='Annual')
                   j=12;
           
             //  for(integer i=1;i<=qrtrStartDate.monthsBetween(qrtrEndDate);i=i+j){
             Boolean initialPass = true;
                while(repPeriod <= qrtrEndDate ){    
                    LF_Reporting_Period__c lfrp = new LF_Reporting_Period__c();
                    RF_Reporting_Period__c rfrp = new RF_Reporting_Period__c();
                    if (objName.equalsIgnoreCase('CDCSGoal__c')){
                        rfrp.Goal_Id__c = objId;
                    //  rfrp.RecordTypeId=GU.getRecordTypeId('RF_Reporting_Period__c','RF Goal');
                        rfrp.RecordTypeId=recordTypes.get('RF Goal');   
                        rfrp.CDCS_Link_Id__c = cLink.Id;
                        rfrp.ouId__c = cLink.ouId__c;                   
                    } else if (objName.equalsIgnoreCase('DO__c')){
                        rfrp.DO_Id__c = objId;
                        //rfrp.RecordTypeId=GU.getRecordTypeId('RF_Reporting_Period__c','RF DO');
                        rfrp.RecordTypeId=recordTypes.get('RF DO');
                        rfrp.CDCS_Link_Id__c = cLink.Id;
                        rfrp.ouId__c = cLink.ouId__c;
                    } else if (objName.equalsIgnoreCase('IR__c')){
                        rfrp.IR_Id__c = objId;
                        //rfrp.RecordTypeId=GU.getRecordTypeId('RF_Reporting_Period__c','RF IR');
                        rfrp.RecordTypeId=recordTypes.get('RF IR');
                        rfrp.CDCS_Link_Id__c = cLink.Id;
                        rfrp.ouId__c = cLink.ouId__c;
                    } else if (objName.equalsIgnoreCase('Sub_IR__c')){
                        rfrp.SIR_Id__c = objId;
                        //rfrp.RecordTypeId=GU.getRecordTypeId('RF_Reporting_Period__c','RF SUB IR');
                        rfrp.RecordTypeId=recordTypes.get('RF SUB IR');
                        rfrp.CDCS_Link_Id__c = cLink.Id;
                        rfrp.ouId__c = cLink.ouId__c;
                    } else if (objName.equalsIgnoreCase('LF_Goal__c')){
                        lfrp.LF_Goal_Id__c = objId;
                        //lfrp.RecordTypeId=GU.getRecordTypeId('LF_Reporting_Period__c','LF Goal');
                        lfrp.RecordTypeId=recordTypes.get('LF Goal');
                        lfrp.LogFrame_Tree_Id__c = lfLink.Id;
                        lfrp.ouId__c = lfLink.ouId__c;
                    } else if (objName.equalsIgnoreCase('LF_Purpose__c')){
                        lfrp.LF_Purpose_Id__c = objId;
                        //lfrp.RecordTypeId=GU.getRecordTypeId('LF_Reporting_Period__c','LF Purpose');
                        lfrp.RecordTypeId=recordTypes.get('LF Purpose');
                        lfrp.LogFrame_Tree_Id__c = lfLink.Id;
                        lfrp.ouId__c = lfLink.ouId__c;
                    } else if (objName.equalsIgnoreCase('LF_SubPurpose__c')){
                        lfrp.LF_SubPurpose_Id__c = objId;
                        //lfrp.RecordTypeId=GU.getRecordTypeId('LF_Reporting_Period__c','LF Sub-Purpose');
                        lfrp.RecordTypeId=recordTypes.get('LF Sub-Purpose');
                        lfrp.LogFrame_Tree_Id__c = lfLink.Id;
                        lfrp.ouId__c = lfLink.ouId__c;
                    } else if (objName.equalsIgnoreCase('LF_Output__c')){
                        lfrp.LF_Output_Id__c = objId;
                        //lfrp.RecordTypeId=GU.getRecordTypeId('LF_Reporting_Period__c','LF Output');
                        lfrp.RecordTypeId=recordTypes.get('LF Output');
                        lfrp.LogFrame_Tree_Id__c = lfLink.Id;
                        lfrp.ouId__c = lfLink.ouId__c;
                    } else if (objName.equalsIgnoreCase('LF_Input__c')){
                        lfrp.LF_Input_Id__c = objId;
                        //lfrp.RecordTypeId=GU.getRecordTypeId('LF_Reporting_Period__c','LF Input');
                        lfrp.RecordTypeId=recordTypes.get('LF Input');
                        lfrp.LogFrame_Tree_Id__c = lfLink.Id;
                        lfrp.ouId__c = lfLink.ouId__c;
                    }
                    
                   // rp.Activity_Id__c=typeCastObj.Id;
                   String fiscalPeriod;
                   Integer fiscalYear;
                    if (objName.startsWith('LF')){
                     /*   String fiscalPeriod = getFiscalPeriod(periodicity,repPeriod);
                        lfrp.Fiscal_Period__c=fiscalPeriod;
                        lfrp.Name= fiscalPeriod+'-'+repPeriod.year();
                        lfrp.Fiscal_Year__c=String.Valueof(repPeriod.year());
                        lfrp.Status__c='Draft';
                        lfrp.Start_Date__c=getStartDate(periodicity,repPeriod);
                        lfrp.End_Date__c=getEndDate(periodicity,repPeriod); */
                        fiscalPeriod = getFiscalPeriodx(periodicity,repPeriod);
                        fiscalYear = getFiscalYear(fiscalPeriod,repPeriod,initialPass);
                        initialPass=false;
                        lfrp.Fiscal_Period__c=fiscalPeriod;
                        lfrp.Name= string.valueOf(fiscalYear)+'-'+ fiscalPeriod;
                        lfrp.Fiscal_Year__c= string.valueOf(fiscalYear);
                        lfrp.Status__c='Draft';
                        lfrp.Start_Date__c=repPeriod;
                        lfrp.End_Date__c=qrtrEndDate>getPeriodEndDate(repPeriod,fiscalPeriod,fiscalYear) ? getPeriodEndDate(repPeriod,fiscalPeriod,fiscalYear):qrtrEndDate;
                        if(!lfrpExistMap.containsKey(string.valueOf(fiscalYear)+'-'+ fiscalPeriod)) {
                            lfRPList.add(lfrp);
                        }   
                    } else {
                     /*   String fiscalPeriod = getFiscalPeriod(periodicity,repPeriod);
                        rfrp.Fiscal_Period__c=fiscalPeriod;
                        rfrp.Name= fiscalPeriod+'-'+repPeriod.year();
                        rfrp.Fiscal_Year__c=String.Valueof(repPeriod.year());
                        rfrp.Status__c='Draft';
                        rfrp.Start_Date__c=getStartDate(periodicity,repPeriod);
                        rfrp.End_Date__c=getEndDate(periodicity,repPeriod);
                        if(!rfrpExistMap.containsKey(fiscalPeriod+'-'+repPeriod.year())) {
                            rfRPList.add(rfrp);
                        } */
                        fiscalPeriod = getFiscalPeriodx(periodicity,repPeriod);
                        fiscalYear = getFiscalYear(fiscalPeriod,repPeriod,initialPass);
                        initialPass = false;
                        rfrp.Fiscal_Period__c=fiscalPeriod;
                        rfrp.Name= string.valueOf(fiscalYear)+'-'+ fiscalPeriod;
                        rfrp.Fiscal_Year__c=string.valueOf(fiscalYear);
                        rfrp.Status__c='Draft';
                        rfrp.Start_Date__c=repPeriod;
                        rfrp.End_Date__c=qrtrEndDate>getPeriodEndDate(repPeriod,fiscalPeriod,fiscalYear) ? getPeriodEndDate(repPeriod,fiscalPeriod,fiscalYear):qrtrEndDate;
                        if(!rfrpExistMap.containsKey(string.valueOf(fiscalYear)+'-'+ fiscalPeriod)) {
                            rfRPList.add(rfrp);
                        }  
                    }
                                            
                  //  repPeriod = repPeriod.addMonths(j);
                  System.debug('Calculated End Date::' +getPeriodEndDate(repPeriod,fiscalPeriod,fiscalYear));
                  repPeriod = getPeriodEndDate(repPeriod,fiscalPeriod,fiscalYear).addDays(1);
                   // Activity_Start_Date__c Activity_End_Date__c
                }//end for
                if (!lfRPList.isEmpty()){
                    insert lfRPList;    
                    system.debug('Reporting Periods -'+lfRPList);
                }
                
                if (!rfRPList.isEmpty()){
                    insert rfRPList;    
                    system.debug('Reporting Periods -'+rfRPList);
                }
                
                
                if (objName.equalsIgnoreCase('CDCSGoal__c')){
                    CDCSGoal__c goal = (CDCSGoal__c)GU.lookup(objId, 'CDCSGoal__c');
                    if(!goal.Reporting_Periods_Established__c){
                        goal.Reporting_Periods_Established__c = true;  
                        ApplicationConstants.byPassGoalAfterUpdate = true;
                        ApplicationConstants.byPassGoalBeforeUpsertQowner = true;
                        upsert goal;
                        ApplicationConstants.byPassGoalAfterUpdate = false;
                        ApplicationConstants.byPassGoalBeforeUpsertQowner = false;
                    }               
                } else if (objName.equalsIgnoreCase('DO__c')){
                    DO__c doo = (DO__c)GU.lookup(objId, 'DO__c');
                    if (!doo.Reporting_Periods_Established__c){
                        doo.Reporting_Periods_Established__c = true;
                        upsert doo;
                    }   
                } else if (objName.equalsIgnoreCase('IR__c')){
                    IR__c ir = (IR__c)GU.lookup(objId, 'IR__c');
                    if (!ir.Reporting_Periods_Established__c){
                        ir.Reporting_Periods_Established__c = true;
                        system.debug('IR Record::'+ir);
                        upsert ir;
                    }       
                } else if (objName.equalsIgnoreCase('Sub_IR__c')){
                    Sub_IR__c sir = (Sub_IR__c)GU.lookup(objId, 'Sub_IR__c');
                    if (!sir.Reporting_Periods_Established__c){
                        sir.Reporting_Periods_Established__c = true;
                        upsert sir;
                    }   
                } else if (objName.equalsIgnoreCase('LF_Goal__c')){
                    LF_Goal__c lgoal = (LF_Goal__c)GU.lookup(objId, 'LF_Goal__c');
                    if (!lgoal.Reporting_Periods_Established__c){
                        lgoal.Reporting_Periods_Established__c = true;
                        ApplicationConstants.byPassLFGoalAfterUpdate = true;
                        ApplicationConstants.byPassLFGoalBeforeUpsertQOwner = true;
                        upsert lgoal;
                        ApplicationConstants.byPassLFGoalAfterUpdate = false;
                        ApplicationConstants.byPassLFGoalBeforeUpsertQOwner = false;
                    }   
                } else if (objName.equalsIgnoreCase('LF_Purpose__c')){
                    LF_Purpose__c purpose = (LF_Purpose__c)GU.lookup(objId, 'LF_Purpose__c');
                    if (!purpose.Reporting_Periods_Established__c){
                        purpose.Reporting_Periods_Established__c = true;
                        upsert purpose;
                    }   
                } else if (objName.equalsIgnoreCase('LF_SubPurpose__c')){
                    LF_SubPurpose__c spurpose = (LF_SubPurpose__c)GU.lookup(objId, 'LF_SubPurpose__c');
                    if (!spurpose.Reporting_Periods_Established__c){
                        spurpose.Reporting_Periods_Established__c = true;
                        upsert spurpose;
                    }   
                } else if (objName.equalsIgnoreCase('LF_Output__c')){
                    LF_Output__c output = (LF_Output__c)GU.lookup(objId, 'LF_Output__c');
                    if (!output.Reporting_Periods_Established__c){
                        output.Reporting_Periods_Established__c = true;
                        upsert output;
                    }   
                } else if (objName.equalsIgnoreCase('LF_Input__c')){
                    LF_Input__c input = (LF_Input__c)GU.lookup(objId, 'LF_Input__c');
                    if (!input.Reporting_Periods_Established__c){
                        input.Reporting_Periods_Established__c = true;
                        upsert input;
                    }   
                } 
                
                return null;
            }catch(Exception e){
                 system.debug('Query Exception occured in createIM -'+e.getStackTraceString());
                 e.setMessage('Could not create Reporting Period for Activity -'+objId+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
                 throw(e);
            }
            return null;
    } 
    
    public String createRepPeriod(String recId){
            if (recId == null)
                return null;
            
            Activity__c act = new Activity__c();
            Implementing_Mechanism__c im = new Implementing_Mechanism__c();
            Map<String,String> recordTypes = new Map<String,String>();
            recordTypes = GU.getRecordTypeByObject('Reporting_Period__c');
            String objName = 'Implementing_Mechanism__c';
            String whereCol;
            Date sDate;
            Date eDate;
           
            if(objName.equalsIgnoreCase('Implementing_Mechanism__c')){
                im = (Implementing_Mechanism__c) GU.lookup(recId,'Implementing_Mechanism__c');
                sDate = im.Start_Date__c;
                eDate = im.End_Date__c;
                whereCol = 'Implementing_Mechanism_Id__c';
            }
            
            //if (act==null || im==null || im.Reporting_Frequency__c == null || sDate == null || eDate == null)
            if (act==null || im==null || sDate == null || eDate == null)
                 return null;
            List<Reporting_Period__c> rpList = new List<Reporting_Period__c>();             
            
            Date qrtrStartDate=sDate;
            Date qrtrEndDate=eDate;
            
            
            Map<String,Reporting_Period__c> rpExistMap = new Map<String,Reporting_Period__c>();
            List<SObject> soList = GU.lookup(recId,whereCol,'Reporting_Period__c');
            for(SObject ob: soList){
                Reporting_Period__c rp = (Reporting_Period__c)ob;
                rpExistMap.put(rp.Name,rp);         
            }
            system.debug('StartDate-'+qrtrStartDate+'-End Date-'+qrtrEndDate);
            try{
               integer j=2;
               if (im.Reporting_Frequency__c=='Quarterly')
                   j=3;
               else if(im.Reporting_Frequency__c=='Semi-Annual')
                   j=6;
               else if(im.Reporting_Frequency__c=='Annual')
                   j=12;
                   
                //List<String> Frequency = new List<String>();
                //Frequency[0] = 'Quarterly';
                //Frequency[1] = 'Semi-Annual';
                //Frequency[2] = 'Annual';
                
                Boolean initialPass = true;
                for(integer i=1;i<=3;i=i+1)
                {
                String Frequency;
                if( i==1)
                Frequency = 'Quarterly';
                else if(i==2)
                Frequency = 'Semi-Annual';
                else if(i==3)
                Frequency = 'Annual';
                
                Date repPeriod =qrtrStartDate;
                while(repPeriod <= qrtrEndDate ){     
                    Reporting_Period__c rp = new Reporting_Period__c();
             
                    if (objName.equalsIgnoreCase('Implementing_Mechanism__c')){ 
                        rp.Implementing_Mechanism_Id__c=im.Id;
                        rp.RecordTypeId=recordTypes.get('Implementing Mechanism');                      
                    }
                    
                    
                    String fiscalPeriod = getFiscalPeriodx(Frequency,repPeriod);
                    Integer fiscalYear = getFiscalYear(fiscalPeriod,repPeriod,initialPass);
                    initialPass = false;
                    rp.Fiscal_Period__c=fiscalPeriod;
                    rp.ouId__c = im.ouId__c;
                    rp.Name= string.valueOf(fiscalYear)+'-'+ fiscalPeriod;
                    rp.Fiscal_Year__c=string.valueOf(fiscalYear);
                    rp.Status__c='Draft';
                    rp.Start_Date__c=repPeriod;
                    Date dDate = qrtrEndDate>getPeriodEndDate(repPeriod,fiscalPeriod,fiscalYear) ? getPeriodEndDate(repPeriod,fiscalPeriod,fiscalYear):qrtrEndDate;
                    rp.End_Date__c= dDate;
                    
                    rp.Close_Date__c = dDate.addMonths(1); 
                    if(!rpExistMap.containsKey(string.valueOf(fiscalYear)+'-'+ fiscalPeriod)) {            
                        rpList.add(rp);
                    }
                    repPeriod = getPeriodEndDate(repPeriod,fiscalPeriod,fiscalYear).addDays(1);
                }
                }//end for
                insert rpList;
                system.debug('Reporting Periods -'+rpList);
                if (objName.equalsIgnoreCase('Activity__c')){
            
                } else if (objName.equalsIgnoreCase('Implementing_Mechanism__c')) {
                    if (!im.Reporting_Periods_Established__c){
                        ApplicationConstants.bypassIMSharingRulesTriggerLogic = true;
                        ApplicationConstants.bypassIMCreateVendorTriggerLogic = true;
                        im.Reporting_Periods_Established__c = true;
                        update im;
                    }   
                }   
                return null;
            }catch(Exception e){
                 system.debug('Query Exception occured in createIM -'+e.getStackTraceString());
                 e.setMessage('Could not create Reporting Period for Activity -'+im.Name+'\\n'+'Error -'+e.getMessage()+' occured in class createRepPeriod by Id at line number -'+e.getLineNumber() );
                 throw(e);
            }
            return null;
    }//end createRepPeriod
    
    private Date getPeriodEndDate(Date StartDate, String fiscalPeriod, Integer fiscalYear){     
        
        if (fiscalPeriod.equalsIgnoreCase('Q1'))
            return  date.newinstance(fiscalYear-1, 12, 31);
        if (fiscalPeriod.equalsIgnoreCase('Q2') || fiscalPeriod.equalsIgnoreCase('SA1'))    
            return  date.newinstance(fiscalYear, 3, 31);
        if (fiscalPeriod.equalsIgnoreCase('Q3'))    
            return  date.newinstance(fiscalYear, 6, 30);
        if (fiscalPeriod.equalsIgnoreCase('Q4')  || fiscalPeriod.equalsIgnoreCase('SA2') || fiscalPeriod.equalsIgnoreCase('Annual'))    
            return  date.newinstance(fiscalYear, 9, 30); 
        
        return null;    
            
    }
    
    
    private String getFiscalPeriodx(String periodicity, Date startDate){
        if (startDate ==null)
                return null;
        
        
        if (periodicity=='Quarterly' && startDate.month() > 9)
            return 'Q1';
        if (periodicity=='Quarterly' && startDate.month() > 6 && startDate.month() < 10)
            return 'Q4';
        if (periodicity=='Quarterly' && startDate.month() > 3 && startDate.month() < 7)
            return 'Q3';    
        if (periodicity=='Quarterly' && startDate.month() < 4)
            return 'Q2';
        if (periodicity=='Semi-Annual' && startDate.month() > 3 && startDate.month() < 10)
            return 'SA2';
        if (periodicity=='Semi-Annual' && (startDate.month() < 4 || startDate.month() > 9))
            return 'SA1'; 
        
        return 'Annual';     
        
    }
    
    private Integer getFiscalYear(String fiscalPeriod,  Date StartDate, Boolean initialPass){
        if (StartDate ==null)
            return null;        
        if (fiscalPeriod.equalsIgnoreCase('Q1') || 
            (fiscalPeriod.equalsIgnoreCase('SA1') && StartDate.month() > 9) || 
            (fiscalPeriod.equalsIgnoreCase('Annual') && StartDate.month() > 9))
            return StartDate.Year()+1;
        return  StartDate.year();
    }
    
   
}