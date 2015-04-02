public with sharing class ClsResultsFrameWorkOverview {
    public string paramId{get;set;}
    public CDCSGoal__c goal {get;set;}
    public Map<String, List<DO__c>> goalDoMap {get;set;}
    public Map<String, List<IR__c>> doIrMap {get;set;}
    public Map<String, List<Sub_IR__c>> irSirMap {get;set;}
    public String selectedRow{get;set;}
    public Boolean noResults{get;set;}
    
    public Map<String,TreeNode> recMap{get;set;}
    
    //public Map<String,List<RF_Indicator_Result__c>> resultsMap{get;set;}
    public Map<String,Indicators> resultsMap{get;set;}
    public List<Indicators> resultsList{get;set;}
    public TreeNode goalNode {get;set;}
    
    
    
    public ClsResultsFrameWorkOverview(){
        ClsGlobalUtility GU = new ClsGlobalUtility();
        try{        
            if (ApexPages.currentPage().getParameters().get('id')!=null){   
                paramId = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
            }
            
            List<Sobject> sObjList = GU.lookup(paramId, 'CDCSGoal_Id__c', 'CDCSLINK__c');
            set<Id> doIds = new set<Id>();
            set<Id> irIds = new set<Id>();
            set<Id> sirIds = new set<Id>();
            String filterStr;
            for(Sobject so: sObjList){
                CDCSLINK__c  cLink = (CDCSLINK__c) so;
                if (cLink.DO_Id__c != null){
                    doIds.add(cLink.DO_Id__c);                      
                }
                if (cLink.IR_Id__c != null){
                    irIds.add(cLink.IR_Id__c);                      
                }
                if (cLink.SIR_Id__c != null){
                    sirIds.add(cLink.SIR_Id__c);                        
                }               
            }
            
            goal = (CDCSGoal__c)GU.lookup(ParamId,'CDCSGoal__c');
            System.debug('Before DOs');
            goalDoMap = new Map<String, List<DO__c>>(); 
            if (!doIds.isEmpty()){
                filterStr = ' WHERE Id IN ' +prepInString(doIds) +' order by DO_Code__c '; 
                List<Sobject> sObjList1 = GU.lookupWithFilter(filterStr,'DO__c');   
                                
                for(Sobject so: sObjList1){
                    DO__c doo = (DO__c) so;
                    List<DO__c> tDoList = new List<DO__c>();
                    
                    if (goalDoMap != null){
                        if (goalDoMap.containsKey((String)doo.CDCS_Goal__c)){                           
                            tDoList = goalDoMap.get(doo.CDCS_Goal__c);                              
                        }                               
                    } 
                    tDoList.add(doo);               
                    goalDoMap.put((String)doo.CDCS_Goal__c,tDoList);
                }   
            }
            
            doIrMap = new Map<String,List<IR__c>>();
            if (!irIds.isEmpty()){
                System.debug('Before IRs');
                filterStr = ' WHERE Id IN ' +prepInString(irIds) +' order by IR_Code__c '; 
                List<Sobject> sObjList2 = GU.lookupWithFilter(filterStr,'IR__c');
                
                for(Sobject so: sObjList2){
                    IR__c ir = (IR__c) so;              
                    List<IR__c> tIrList = new List<IR__c>();
                    if (!doIrMap.isEmpty() && doIrMap.containsKey(ir.Do_Id__c)){
                         tIrList = doIrMap.get(ir.DO_Id__c);                    
                    } 
                    tIrList.add(ir);                
                    doIrMap.put(ir.DO_Id__c,tIrList);
                }   
            }
            
            irSirMap = new Map<String,List<Sub_IR__c>>();
            if (!sirIds.isEmpty()){
                System.debug('Before sIRs');
                filterStr = ' WHERE Id IN ' +prepInString(sirIds) +' order by SIR_Code__c '; 
                List<Sobject> sObjList3 = GU.lookupWithFilter(filterStr,'Sub_IR__c');
                
                for(Sobject so: sObjList3){
                    Sub_IR__c sir = (Sub_IR__c) so;
                    List<Sub_IR__c> tSirList = new List<Sub_IR__c>();
                    if (!irSirMap.isEmpty() && irSirMap.containsKey(sir.ir_Id__c)){
                         tSirList = irSirMap.get(sir.ir_Id__c);                 
                    } 
                    tSirList.add(sir);              
                    irSirMap.put(sir.ir_Id__c,tSirList);
                }   
            }
            
            recMap = new Map<String,Treenode>();
            goalNode = new TreeNode();
            goalNode.nodeId = goal.Id;
            goalNode.nodeName = goal.Goal_Statement__c;
            goalNode.indEstablished = goal.Indicators_Established__c;
            goalNode.periodsEstablished = goal.Reporting_Periods_Established__c;
            system.debug('Goal Do Map:::' +goalDoMap);
            if (goalDoMap.containsKey(goal.Id)){
                for(DO__c d: goalDoMap.get(goal.Id)){
                    goalNode.hasChildren = true;
                    TreeNode doNode = new TreeNode();
                    doNode.nodeId = d.Id;
                    doNode.nodeName = d.DO_Name__c;
                    doNode.indEstablished = d.Indicators_Established__c;
                    doNode.periodsEstablished = d.Reporting_Periods_Established__c;
                    system.debug('DO IR Map:::' +doIrMap);
                    if (doIrMap.containsKey(d.Id)){             
                        for(IR__c i: doIrMap.get(d.Id)){
                            doNode.hasChildren = true;                  
                            TreeNode irNode = new TreeNode();
                            irNode.nodeId = i.Id;
                            irNode.nodeName = i.IR_Name__c;
                            irNode.indEstablished = i.Indicators_Established__c;
                            irNode.periodsEstablished = i.Reporting_Periods_Established__c;
                            system.debug('IR SUB IR Map:::' +irSirMap);
                            if (irSirMap.containsKey(i.Id)){    
                                for(Sub_IR__c si: irSirMap.get(i.Id)){
                                    irNode.hasChildren = true;
                                    TreeNode sirNode = new TreeNode();
                                    sirNode.nodeId = si.Id;
                                    sirNode.nodeName = si.SIR_Name__c;
                                    sirNode.indEstablished = si.Indicators_Established__c;
                                    sirNode.periodsEstablished = si.Reporting_Periods_Established__c;
                                    irNode.children.add(sirNode); 
                                    recMap.put(i.Id,irNode);    
                                }                               
                            } else {
                                recMap.put(i.Id, new TreeNode());
                            }   
                            doNode.children.add(irNode);
                            recMap.put(d.Id,doNode);                        
                        }
                    } else {
                        recMap.put(d.Id, new TreeNode());
                    }   
                    goalNode.children.add(doNode);
                    recMap.put(goal.Id,goalNode);
                }
            } else {
                recMap.put(goal.Id, new TreeNode());
            }
            system.debug('RecMap:::' +recMap);
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
    
        if (objName.equalsIgnoreCase('CDCSGoal__c')){
             filterStr = ' where CDCS_Goals__c = \'' +selectedRow +'\' order by IndCode__c, RF_Reporting_Period_Id__c';
             indFilterStr = ' where Goal_Id__c = \'' +selectedRow +'\' order by IndCode__c, sindCode__c';
        } else if (objName.equalsIgnoreCase('do__c')){
             filterStr = ' where DO_Id__c = \'' +selectedRow +'\' order by IndCode__c, RF_Reporting_Period_Id__c';
             indFilterStr = ' where DO_Id__c = \'' +selectedRow +'\' order by IndCode__c, sindCode__c';
        } else if (objName.equalsIgnoreCase('ir__c')){
             filterStr = ' where IR_Id__c = \'' +selectedRow +'\' order by IndCode__c, RF_Reporting_Period_Id__c';
             indFilterStr = ' where IR_Id__c = \'' +selectedRow +'\' order by IndCode__c, sindCode__c';
        } else if (objName.equalsIgnoreCase('sub_ir__c')){
             filterStr = ' where Sub_IR_Id__c = \'' +selectedRow +'\' order by IndCode__c, RF_Reporting_Period_Id__c';
             indFilterStr = ' where SIR_Id__c = \'' +selectedRow +'\' order by IndCode__c, sindCode__c';
        }
        
        List<SObject> indSObjList = GU.lookupWithFilter(indFilterStr, 'OrgUnit_Indicator__c');
        List<SObject> sObjList = GU.lookupWithFilter(filterStr, 'RF_Indicator_Result__c');
        //resultsMap = new Map<String,List<RF_Indicator_Result__c>>();
        resultsMap = new Map<String,Indicators>();
        resultsList = new List<Indicators>();
        for(Sobject so: sObjList){
            RF_Indicator_Result__c rir = (RF_Indicator_Result__c)so;
            Indicators ind = new Indicators();
            List<RF_Indicator_Result__c> tempList = new List<RF_Indicator_Result__c>();
            if (resultsMap.containsKey(rir.indCode__c)){
                tempList = resultsMap.get(rir.indCode__c).iResults;             
            }
            ind.indCode = rir.indCode__c;
            ind.indName = rir.indName__c;
            tempList.add(rir);
            ind.iResults = tempList;
        /*  Indicators ind = new Indicators();
            Map<String,IndicatorResults> tempMap = new Map<String,IndicatorResults>();
            if (resultsMap.containsKey(rir.indCode__c)){
                ind = resultsMap.get(rir.indCode__c);
                tempMap = ind.iResults;
                
            }
            
            ind.indCode = rir.indCode__c;
            ind.indName = rir.indName__c;
            if (!tempMap.containsKey(rir.RF_Reporting_Period_Id__c)){
                tempMap.put((String)rir.RF_Reporting_Period_Id__c,new IndicatorResults((String)rir.RF_Reporting_Period_Id__c,rir.Reporting_Period_Name__c,
                                            rir.baseline__c,rir.target__c,rir.actual__c,rir.Variance__c));
            }
            ind.iResults = tempMap; */
            //resultsMap.put(rir.indCode__c, tempList);
            resultsMap.put(rir.indCode__c, ind);
        }
        //resultsList = resultsMap.values();
       /* List<String> resultsKeyList = new List<String>();
        resultsKeyList.addAll(resultsMap.keySet());
        resultsKeyList.sort();
        for(String ks: resultsKeyList){
            resultsList.add(resultsMap.get(ks));
        } */
        
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
        public Boolean hasChildren{
            get {
                if (this.children.isEmpty())
                    return false;               
                return true;
            }
            private set;
        }
        
        /* Default Constructor of the calss TreeNode */
        public TreeNode(){
        /*public TreeNode(String nId,String nName,Boolean indFlag, Boolean periodsFlag){
            nodeId = nId;
            nodeName = nName;
            indEstablished = indFlag;
            periodsEstablished = periodsFlag; */
            children = new List<TreeNode>();
            this.hasChildren = false;
        }   
        
        
        /* End of Default constructor of the calss TreeNode */
    }
    
    public class Indicators{
        public String indCode{get;set;}
        public String indName{get;set;}
        public Boolean resultsEstablished{get;set;}
        public List<RF_Indicator_Result__c> iResults{get;set;}
        
        public Indicators(){
            iResults = new List<RF_Indicator_Result__c>();
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
    
    
    @IsTest public static void testClsResultsFrameWorkOverview() {
        //  clsReportingPeriod CRP = new clsReportingPeriod();
          ClsTestUtility testIndicatorUtil = new ClsTestUtility(); 
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
          CDCSGoal__c goal = testIndicatorUtil.getRFGoalRecordForOrgId(OrgUnitId);
          // Do__c doo = testIndicatorUtil.getRFDORecordForRFGoal(goal.Id); 
         // IR__c irr = testIndicatorUtil.getRFIRRecordForRFDo(doo.Id);
         // Sub_IR__c sir = testIndicatorUtil.getRFSIRRecordForRFIR(irr.Id);
          testIndicatorUtil.updateRFGoalForOrgId(OrgUnitId);
          
          OrgUnit_Indicator__c masterInd = testIndicatorUtil.getCustomIndicatorRecordForOrgId(OrgUnitId);
          OrgUnit_Indicator__c childInd = testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,goal.Id,'RFGoal');
          List<RF_Reporting_Period__c> rfRPList = testIndicatorUtil.getRFReportingPeriods(goal.Id,'Goal');
          RF_Reporting_Period__c rfRP = rfRPList[0];
          RF_Indicator_Result__c irId = testIndicatorUtil.getRFIndicatorResultRecordByRFGoal(rfRP.Id,masterInd.Id,childInd.Id,goal.Id);
          
          ApexPages.currentPage().getParameters().put('id', goal.Id);            
          ClsResultsFrameWorkOverview CRF = new ClsResultsFrameWorkOverview(); 
          CRF.selectedRow = goal.Id;         
          CRF.getResults(); 
          
          system.test.startTest();
          upsert irId;
          upsert rfRP;
          upsert childInd;  
          upsert masterInd;
          delete irId;
          delete rfRP;
          delete childInd;
          delete masterInd; 
          system.test.stopTest();
          
      
     }
    

}