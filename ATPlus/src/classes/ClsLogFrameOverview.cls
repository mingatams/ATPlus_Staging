public with sharing class ClsLogFrameOverview {
    public string paramId{get;set;}
    public String navigationLink { get; set;}  
    public Map<String, List<LF_Goal__c>> projectGoalMap {get;set;}
    public Map<String, List<LF_Purpose__c>> goalPurposeMap {get;set;}
    public Map<String, List<LF_SubPurpose__c>> purposeSubPurposeMap {get;set;}
    public Map<String, List<LF_Output__c>> pspOutputMap {get;set;}  
    public Map<String, List<LF_Input__c>> outputInputMap {get;set;}
    
    public String selectedRow{get;set;}
    public Boolean noResults{get;set;}
    public Map<String,Indicators> resultsMap{get;set;}
    public List<Indicators> resultsList{get;set;}
    
    public Project__c project {get;set;}
    public Map<String,TreeNode> recMap{get;set;}      
    
    
    public ClsLogFrameOverview(){    
        ClsGlobalUtility GU = new ClsGlobalUtility();
        try{            
            if (ApexPages.currentPage().getParameters().get('id')!=null){   
                paramId = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
            }
            if(paramId != null)
            navigationLink= GU.createBreadCrumps(paramId);  
            
            List<Sobject> sObjList = GU.lookup(paramId, 'Project_Id__c', 'LogFrame_Tree__c');
            set<Id> goalIds = new set<Id>();
            set<Id> purposeIds = new set<Id>();
            set<Id> spurposeIds = new set<Id>();
            set<Id> outputIds = new set<Id>();
            set<Id> inputIds = new set<Id>();
            String filterStr;
            
            for(Sobject so: sObjList){
                LogFrame_Tree__c  cLink = (LogFrame_Tree__c) so;
                if (cLink.LF_Goal_Id__c != null){
                    goalIds.add(cLink.LF_Goal_Id__c);                       
                }
                if (cLink.LF_Purpose_Id__c != null){
                    purposeIds.add(cLink.LF_Purpose_Id__c);                     
                }
                if (cLink.LF_SubPurpose_Id__c != null){
                    spurposeIds.add(cLink.LF_SubPurpose_Id__c);                     
                }           
                if (cLink.LF_Output_Id__c != null){
                    outputIds.add(cLink.LF_Output_Id__c);                       
                }
                if (cLink.LF_Input_Id__c != null){
                    inputIds.add(cLink.LF_Input_Id__c);                     
                }   
            }
            
            project = (Project__c)GU.lookup(ParamId,'Project__c');          
            projectGoalMap = new Map<String, List<LF_Goal__c>>();
            goalPurposeMap = new Map<String, List<LF_Purpose__c>>(); 
            purposeSubPurposeMap = new Map<String, List<LF_SubPurpose__c>>(); 
            pspOutputMap = new Map<String, List<LF_Output__c>>();   
            outputInputMap = new Map<String, List<LF_Input__c>>(); 
            if (!goalIds.isEmpty()){
                filterStr = ' WHERE Id IN ' +prepInString(goalIds); 
                List<Sobject> sObjList1 = GU.lookupWithFilter(filterStr,'LF_Goal__c');
                
                for(Sobject so: sObjList1){
                    LF_Goal__c goal = (LF_Goal__c) so;
                    List<LF_Goal__c> tGoalList = new List<LF_Goal__c>();
                    
                    if (projectGoalMap != null){
                        if (projectGoalMap.containsKey((String)goal.project_Id__c)){                            
                            tGoalList = projectGoalMap.get(goal.project_Id__c);                             
                        }                               
                    } 
                    tGoalList.add(goal);                
                    projectGoalMap.put((String)goal.project_Id__c,tGoalList);
                }
            }
            
            
            if (!purposeIds.isEmpty()){
                filterStr = ' WHERE Id IN ' +prepInString(purposeIds); 
                List<Sobject> sObjList2 = GU.lookupWithFilter(filterStr,'LF_Purpose__c');
                
                for(Sobject so: sObjList2){
                    LF_Purpose__c purpose = (LF_Purpose__c) so;
                    List<LF_Purpose__c> tPurposeList = new List<LF_Purpose__c>();
                    
                    if (goalPurposeMap != null){
                        if (goalPurposeMap.containsKey((String)purpose.LF_Goal_Id__c)){                         
                            tPurposeList = goalPurposeMap.get(purpose.LF_Goal_Id__c);                               
                        }                               
                    } 
                    tPurposeList.add(purpose);              
                    goalPurposeMap.put((String)purpose.LF_Goal_Id__c,tPurposeList);
                }
            }
            
            
            if (!spurposeIds.isEmpty()){
                filterStr = ' WHERE Id IN ' +prepInString(spurposeIds); 
                List<Sobject> sObjList3 = GU.lookupWithFilter(filterStr,'LF_SubPurpose__c');
                
                for(Sobject so: sObjList3){
                    LF_SubPurpose__c spurpose = (LF_SubPurpose__c) so;
                    List<LF_SubPurpose__c> tsPurposeList = new List<LF_SubPurpose__c>();
                    
                    if (purposeSubPurposeMap != null){
                        if (purposeSubPurposeMap.containsKey((String)spurpose.LF_Purpose_Id__c)){                           
                            tsPurposeList = purposeSubPurposeMap.get(spurpose.LF_Purpose_Id__c);                                
                        }                               
                    } 
                    tsPurposeList.add(spurpose);                
                    purposeSubPurposeMap.put((String)spurpose.LF_Purpose_Id__c,tsPurposeList);
                }
            }
            
            if (!outputIds.isEmpty()){
                filterStr = ' WHERE Id IN ' +prepInString(outputIds); 
                List<Sobject> sObjList4 = GU.lookupWithFilter(filterStr,'LF_Output__c');
                
                for(Sobject so: sObjList4){
                    LF_Output__c output = (LF_Output__c) so;
                    List<LF_Output__c> tOutputList = new List<LF_Output__c>();
                    
                    if (pspOutputMap != null){
                        if (output.LF_SubPurpose_Id__c == null){
                            if (pspOutputMap.containsKey((String)output.LF_Purpose_Id__c)){                         
                                tOutputList = pspOutputMap.get(output.LF_Purpose_Id__c);                                
                            }                           
                        } else {
                            if (pspOutputMap.containsKey((String)output.LF_SubPurpose_Id__c)){                          
                                tOutputList = pspOutputMap.get(output.LF_SubPurpose_Id__c);                             
                            }                           
                        }
                                                        
                    } 
                    if (output.LF_SubPurpose_Id__c == null){                        
                        tOutputList.add(output);                
                        pspOutputMap.put((String)output.LF_Purpose_Id__c,tOutputList);  
                    } else {                        
                        tOutputList.add(output);                
                        pspOutputMap.put((String)output.LF_SubPurpose_Id__c,tOutputList);
                    }
                    
                }
            }
            
            if (!inputIds.isEmpty()){
                filterStr = ' WHERE Id IN ' +prepInString(inputIds); 
                List<Sobject> sObjList5 = GU.lookupWithFilter(filterStr,'LF_Input__c');
                
                for(Sobject so: sObjList5){
                    LF_Input__c input = (LF_Input__c) so;
                    List<LF_Input__c> tinputList = new List<LF_Input__c>();
                    
                    if (outputInputMap != null){
                        if (outputInputMap.containsKey((String)input.LF_Output_Id__c)){                         
                            tinputList = outputInputMap.get(input.LF_Output_Id__c);                             
                        }                               
                    } 
                    tinputList.add(input);              
                    outputInputMap.put((String)input.LF_Output_Id__c,tinputList);
                }
            }
            
            system.debug('Purpose Sub Purpose Map:::' +purposeSubPurposeMap.size());
            recMap = new Map<String,Treenode>();
            TreeNode projectNode = new TreeNode(project.Id,project.Public_Name__c,false,false);         
            if(projectGoalMap.containsKey(project.Id)){
                for(LF_Goal__c g: projectGoalMap.get(project.Id)){
                    projectNode.hasChildren = true;
                    TreeNode goalNode = new TreeNode(g.Id,g.LF_Goal_Name__c,g.Indicators_Established__c,g.Reporting_Periods_Established__c);                    
                    if(goalPurposeMap.containsKey(g.Id) ){
                        for(LF_Purpose__c p: goalPurposeMap.get(g.Id)){
                            goalNode.hasChildren = true;
                            TreeNode purposeNode = new TreeNode(p.Id,p.LF_Purpose_Name__c,p.Indicators_Established__c,p.Reporting_Periods_Established__c);
                            
                            if(pspOutputMap.containsKey(p.Id)){
                                for(LF_Output__c o:pspOutputMap.get(p.Id)){
                                    purposeNode.hasChildSiblings = true;
                                    TreeNode outputNode = new TreeNode(o.Id,o.LF_Purpose_Name__c,o.Indicators_Established__c,o.Reporting_Periods_Established__c);                                           
                                    if(outputInputMap.containsKey(o.Id)){
                                        for(LF_Input__c i:outputInputMap.get(o.Id)){
                                            outputNode.hasChildren = true;
                                            TreeNode inputNode = new TreeNode(i.Id,i.LF_Purpose_Name__c,i.Indicators_Established__c,i.Reporting_Periods_Established__c);                                                    
                                            
                                            outputNode.children.add(inputNode);
                                            recMap.put(o.Id,outputNode);    
                                        }                                               
                                    } else {
                                        recMap.put(o.Id, new TreeNode());
                                    }
                                    purposeNode.children.add(outputNode);
                                    if (!purposeSubPurposeMap.containsKey(p.Id)){
                                        recMap.put(p.Id,purposeNode);
                                    }   
                                }
                            }                       
                                                    
                            if(purposeSubPurposeMap.containsKey(p.Id)){
                                system.debug('Inside Purpose Subpurpose Map');
                                for(LF_SubPurpose__c sp: purposeSubPurposeMap.get(p.Id)){                                
                                    system.debug('Before Has Children::');
                                    purposeNode.hasChildren = true;
                                    TreeNode subPurposeNode = new TreeNode(sp.Id,sp.LF_Purpose_Name__c,sp.Indicators_Established__c,sp.Reporting_Periods_Established__c);                                   
                                    if(pspOutputMap.containsKey(sp.Id)){
                                        for(LF_Output__c o:pspOutputMap.get(sp.Id)){
                                            subPurposeNode.hasChildren = true;
                                            TreeNode outputNode = new TreeNode(o.Id,o.LF_Purpose_Name__c,o.Indicators_Established__c,o.Reporting_Periods_Established__c);                                           
                                            if(outputInputMap.containsKey(o.Id)){
                                                for(LF_Input__c i:outputInputMap.get(o.Id)){
                                                    outputNode.hasChildren = true;
                                                    TreeNode inputNode = new TreeNode(i.Id,i.LF_Purpose_Name__c,i.Indicators_Established__c,i.Reporting_Periods_Established__c);                                                    
                                                    
                                                    outputNode.children.add(inputNode);
                                                    recMap.put(o.Id,outputNode);    
                                                }                                               
                                            } else {
                                                recMap.put(o.Id, new TreeNode());
                                            }
                                            subPurposeNode.children.add(outputNode);
                                            recMap.put(sp.Id,subPurposeNode);
                                        }
                                    } else {
                                        recMap.put(sp.Id, new TreeNode()); 
                                    }
                                    purposeNode.children.add(subPurposeNode);
                                    recMap.put(p.Id,purposeNode);                                   
                                }                               
                            } else {
                                if (!pspOutputMap.containsKey(p.Id)){
                                    recMap.put(p.Id, new TreeNode());
                                }   
                            }
                            goalNode.children.add(purposeNode);
                            recMap.put(g.Id,goalNode);
                        }                       
                    } else {
                        recMap.put(g.Id, new TreeNode());
                    }
                    projectNode.children.add(goalNode);
                    recMap.put(project.Id,projectNode); 
                }               
            } else {
                recMap.put(project.Id, new TreeNode());
            }
            
            
            
            
        } catch(Exception e){
            System.debug('Error Message'+e.getMessage());           
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Loading the LogFrame Table. Please contact your System Admin.'));
            
        }
        
    }
    
    public void getResults(){
        system.debug('Selected Row::::' +selectedRow);
        
        ClsGlobalUtility GU = new ClsGlobalUtility();
        String objName = GU.getObjectNameById(selectedRow);
        String filterStr;
        String indFilterStr;
    
        if (objName.equalsIgnoreCase('LF_Goal__c')){
             filterStr = ' where LF_Goal_Id__c = \'' +selectedRow +'\' order by LF_Reporting_Period_Id__c';
             indFilterStr = ' where LF_Goal_Id__c = \'' +selectedRow +'\' order by IndCode__c, sindCode__c';
        } else if (objName.equalsIgnoreCase('LF_Purpose__c')){
             filterStr = ' where LF_Purpose_Id__c = \'' +selectedRow +'\' order by LF_Reporting_Period_Id__c';
             indFilterStr = ' where LF_Purpose_Id__c = \'' +selectedRow +'\' order by IndCode__c, sindCode__c';
        } else if (objName.equalsIgnoreCase('LF_SubPurpose__c')){
             filterStr = ' where LF_SubPurpose_Id__c = \'' +selectedRow +'\' order by LF_Reporting_Period_Id__c';
             indFilterStr = ' where LF_SubPurpose_Id__c = \'' +selectedRow +'\' order by IndCode__c, sindCode__c';
        } else if (objName.equalsIgnoreCase('LF_Output__c')){
             filterStr = ' where LF_Output__c = \'' +selectedRow +'\' order by LF_Reporting_Period_Id__c';
             indFilterStr = ' where LF_Output_Id__c = \'' +selectedRow +'\' order by IndCode__c, sindCode__c';
        } else if (objName.equalsIgnoreCase('LF_Input__c')){
             filterStr = ' where LF_Input__c = \'' +selectedRow +'\' order by LF_Reporting_Period_Id__c';
             indFilterStr = ' where LF_Input_Id__c = \'' +selectedRow +'\' order by IndCode__c, sindCode__c';
        }
        
        List<SObject> indSObjList = GU.lookupWithFilter(indFilterStr, 'OrgUnit_Indicator__c');
        List<SObject> sObjList = GU.lookupWithFilter(filterStr, 'LF_Indicator_Result__c');      
        resultsMap = new Map<String,Indicators>();
        resultsList = new List<Indicators>();
        for(Sobject so: sObjList){
            LF_Indicator_Result__c lir = (LF_Indicator_Result__c)so;
            Indicators ind = new Indicators();
            List<LF_Indicator_Result__c> tempList = new List<LF_Indicator_Result__c>();
            if (resultsMap.containsKey(lir.indCode__c)){
                tempList = resultsMap.get(lir.indCode__c).iResults;             
            }
            ind.indCode = lir.indCode__c;
            ind.indName = lir.indName__c;
            tempList.add(lir);
            ind.iResults = tempList;            
            resultsMap.put(lir.indCode__c, ind);
        }
       // resultsList = resultsMap.values();
       
       for(Sobject so: indSObjList){
            OrgUnit_Indicator__c oind = (OrgUnit_Indicator__c)so;
            Indicators ind = new Indicators();
            if (resultsMap.containsKey(oind.Name)){
                ind = resultsMap.get(oind.Name);
                ind.resultsEstablished = true;
            } else {
                ind.indCode = oind.Name;
                if (oind.sindCode__c != null && oind.sindCode__c != ''){
                    ind.indName = oind.sindName__c;
                } else {
                    ind.indName = oind.indName__c;
                }    
                ind.resultsEstablished = false;
            }
            resultsList.add(ind);
        }
       
        if (resultsList.isEmpty()){
            noResults = true;
        } else {
            noResults = false;
        }
        system.debug('Results Map::::' +resultsMap);
    }
    
    
    private String prepInString(Set<Id> ids){
        if (ids.isEmpty())
            return null;
        
        String inValues;
        for(ID id: ids){
            if (inValues == null){
                inValues = '\'' +id +'\'';
            } else {
                inValues += ', \'' + id + '\'';
            }            
        }       
        return '( '+inValues +' )';
    }
    
    
    public class TreeNode{
        public String nodeId{get; set;}
        public String nodeName{get;set;}
        public Boolean indEstablished{get;set;}
        public Boolean periodsEstablished{get;set;}
        public List<TreeNode> children {get;set;}
      /*  public Boolean hasChildren{
            get {
                if (this.children.isEmpty())
                    return false;               
                return true;
            }
            private set;
        } */
        public Boolean hasChildren{get;set;}
        public Boolean hasChildSiblings{get;set;}
        
        /* Default Constructor of the calss TreeNode */
        public TreeNode(){
            children = new List<TreeNode>();
            this.hasChildren = false;
            this.hasChildSiblings = false;  
        }
        
        public TreeNode(String nId, String nname, Boolean indEst, Boolean repEst){        
            children = new List<TreeNode>();
            this.hasChildren = false;
            this.hasChildSiblings = false;
            this.nodeId = nId;
            this.nodeName = nName;
            this.indEstablished = indEst;
            this.periodsEstablished = repEst;            
        }   
        
        
        /* End of Default constructor of the calss TreeNode */
    }
    
    
    
    
    public class Indicators{
        public String indCode{get;set;}
        public String indName{get;set;}
        public Boolean resultsEstablished{get;set;}
        public List<LF_Indicator_Result__c> iResults{get;set;}
        
        public Indicators(){
            iResults = new List<LF_Indicator_Result__c>();
        }
                
    }
    
    public class IndicatorResults{
        public String repPeriodID{get;set;}
        public String repPeriodName{get;set;}
        public String baseLine{get;set;}
        public String target{get;set;}
        public String actual{get;set;}
        public String difference{get;set;}
        
        public IndicatorResults(String idc, String name, Decimal baseline, Decimal target, Decimal actual,Decimal diff){
            this.repPeriodID = idc;
            this.repPeriodName = name;
            this.baseLine = String.valueOf(baseline);
            this.target = String.valueOf(target);
            this.actual = String.valueOf(actual);           
            this.difference = String.valueOf(diff);
            
        }
        
    }
    
    @IsTest public static void testClsLogFrameOverview() {
        //  clsReportingPeriod CRP = new clsReportingPeriod();
          ClsTestUtility testIndicatorUtil = new ClsTestUtility(); 
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
          String projectId = testIndicatorUtil.getProjectForOrgId(OrgUnitId);          
          LF_Goal__c lfGoalId = testIndicatorUtil.getLFGoalRecordForProjectId(projectId);
          LF_Purpose__c lfPurposeId = testIndicatorUtil.getLFPurposeRecordForLFgoal(lfGoalId.Id);
          LF_SubPurpose__c lfSubPurposeId = testIndicatorUtil.getLFSubPurposeRecordForLFPurpose(lfPurposeId.Id);          
          LF_Output__c lfOutputId = testIndicatorUtil.getLFOutputRecordForLFPurpose(lfPurposeId.Id);
          LF_Output__c lfOutputId1 = testIndicatorUtil.getLFOutputRecordForLFSubPurpose(lfSubPurposeId.Id);
          LF_Input__c lfInputId = testIndicatorUtil.getLFInputRecordForLFOutput(lfOutputId.Id);
          LF_Input__c lfInputId1 = testIndicatorUtil.getLFInputRecordForLFOutput(lfOutputId1.Id);
         // testIndicatorUtil.updateProjectForOrgId(OrgUnitId);
         // testIndicatorUtil.updateLFGoalForProjectId(projectId);
          
          ApexPages.currentPage().getParameters().put('id', projectId);            
          ClsLogFrameOverview CLF = new ClsLogFrameOverview();   
          system.test.startTest();
          delete lfInputId1;
          delete lfInputId ;
          delete lfOutputId1;
          delete lfOutputId;
          delete lfSubPurposeId;
          delete lfPurposeId;
          delete lfGoalId;
          
          system.test.stopTest();    
         
          
      
     }
     
     @IsTest public static void testClsLogFrameOverview1() {
        //  clsReportingPeriod CRP = new clsReportingPeriod();
          ClsTestUtility testIndicatorUtil = new ClsTestUtility(); 
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
          String projectId = testIndicatorUtil.getProjectForOrgId(OrgUnitId);          
          String lfGoalId = testIndicatorUtil.getLFGoalForProjectId(projectId);          
          testIndicatorUtil.updateProjectForOrgId(OrgUnitId);
          testIndicatorUtil.updateLFGoalForProjectId(projectId);
          OrgUnit_Indicator__c masterInd = testIndicatorUtil.getCustomIndicatorRecordForOrgId(OrgUnitId);
          OrgUnit_Indicator__c childInd = testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,lfGoalId,'LFGoal');
          List<LF_Reporting_Period__c> lfRPList = testIndicatorUtil.getLFReportingPeriods(lfGoalId);
          LF_Reporting_Period__c lfRP = lfRPList[0];
          LF_Indicator_Result__c irId = testIndicatorUtil.getLFIndicatorResultRecordByLFGoal(lfRP.Id,masterInd.Id,childInd.Id,lfGoalId);
          
          ApexPages.currentPage().getParameters().put('id', projectId);            
          ClsLogFrameOverview CLF = new ClsLogFrameOverview(); 
          CLF.selectedRow = lfGoalId;         
          CLF.getResults();    
          
          
          system.test.startTest();
          upsert irId;
          upsert lfRP;
          upsert childInd;  
          upsert masterInd;
          delete irId;
          delete lfRP;
          delete childInd;
          delete masterInd; 
          system.test.stopTest();
          
      
     }
    
    
}