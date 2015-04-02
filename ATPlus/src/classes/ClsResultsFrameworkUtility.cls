public with sharing class ClsResultsFrameworkUtility {  
    public set<Id> goalIds{get;set;}
    public set<Id> doIds{get;set;}
    public set<Id> irIds{get;set;}
    public set<Id> sirIds{get;set;}
    public Project__c proj{get;set;}
    
    private Map<String,List<CDCSGoal__c>> projectGoalMap = new Map<String,List<CDCSGoal__c>>();
    private Map<String,List<DO__c>> goalDOMap = new Map<String,List<DO__c>>();
    private Map<String,List<IR__c>> doIRMap = new Map<String,List<IR__c>>();
    private Map<String,List<Sub_IR__c>> irSIRMap = new Map<String,List<Sub_IR__c>>();
    private Map<String,TreeNode> recMap = new Map<String,TreeNode>();
    
    private String filterStr;
    ClsGlobalUtility GU = new ClsGlobalUtility();
    public ClsResultsFrameworkUtility(Project__c project){  
        proj = project; 
        filterStr = ' WHERE Project_Id__c = \'' +project.Id + '\' ';
        List<Sobject> prjResultLinks = GU.lookupWithFilter(filterStr, 'Portfolio_RF_Linkage__c');   
        goalIds = new set<Id>();
        doIds = new set<Id>();
        irIds = new set<Id>();
        sirIds = new set<Id>();
        if (!prjResultLinks.isEmpty()){  
            for(Sobject so:prjResultLinks){
                Portfolio_RF_Linkage__c linkRec = (Portfolio_RF_Linkage__c) so;
                if (linkRec.Goal_Id__c != null)
                    goalIds.add(linkRec.Goal_Id__c);
                if (linkRec.DO_Id__c != null)
                    doIds.add(linkRec.DO_Id__c);
                if (linkRec.IR_Id__c != null)   
                    irIds.add(linkRec.IR_Id__c);
                if (linkRec.SIR_Id__c != null)  
                    sirIds.add(linkRec.SIR_Id__c);
            }   
        }       
    }
    
    public Map<String,List<CDCSGoal__c>> getResultsFrameworkGoalMap(){
        if (goalIds.isEmpty())
            return null;
                    
        filterStr = ' WHERE Id IN ' + GU.prepareINclause(goalIds);
        List<Sobject> goals = GU.lookupWithFilter(filterStr,'CDCSGoal__c'); 
        if (goals.isEmpty())
            return null;            
                                
        for(Sobject so: goals){
            CDCSGoal__c goal = (CDCSGoal__c) so;
            List<CDCSGoal__c> tGoalList = new List<CDCSGoal__c>();
            
            if (projectGoalMap != null){
                if (projectGoalMap.containsKey((String)proj.Id)){                           
                    tGoalList = projectGoalMap.get(proj.Id);                                
                }                               
            } 
            tGoalList.add(goal);                
            projectGoalMap.put((String)proj.Id,tGoalList);
        }
        
        return projectGoalMap;
    } 
    
    public Map<String,List<DO__c>> getResultsFrameworkDoMap(){
        if (doIds.isEmpty())
            return null;
                    
        filterStr = ' WHERE Id IN ' + GU.prepareINclause(doIds) +' Order by DO_Code__c ';
        List<Sobject> dos = GU.lookupWithFilter(filterStr,'DO__c'); 
        if (dos.isEmpty())
            return null;
                                
        for(Sobject so: dos){
            DO__c doo = (DO__c) so;
            List<DO__c> tDoList = new List<DO__c>();            
            if (goalDOMap != null){
                if (goalDOMap.containsKey((String)doo.CDCS_Goal__c)){                           
                    tDoList = goalDOMap.get(doo.CDCS_Goal__c);                              
                }                               
            } 
            tDoList.add(doo);               
            goalDOMap.put((String)doo.CDCS_Goal__c,tDOList);
        }
        
        return goalDOMap;
    }
    
    public Map<String,List<IR__c>> getResultsFrameworkIRMap(){
        if (irIds.isEmpty())
            return null;
        
        filterStr = ' WHERE Id IN ' + GU.prepareINclause(irIds) +' Order by IR_Code__c ';
        List<Sobject> irs = GU.lookupWithFilter(filterStr,'IR__c'); 
        if (irs.isEmpty())
            return null;
                                
        for(Sobject so: irs){
            IR__c ir = (IR__c) so;
            List<IR__c> tIrList = new List<IR__c>();            
            if (doIRMap != null){
                if (doIRMap.containsKey((String)ir.DO_Id__c)){                          
                    tIrList = doIRMap.get(ir.DO_Id__c);                             
                }                               
            } 
            tIrList.add(ir);                
            doIRMap.put((String)ir.DO_Id__c,tIrList);
        }
        
        return doIRMap;
        
    }
    
    public Map<String,List<Sub_IR__c>> getResultsFrameworkSIRMap(){
        if (sirIds.isEmpty())
            return null;
        
        filterStr = ' WHERE Id IN ' + GU.prepareINclause(sirIds) +' Order by SIR_Code__c ';
        List<Sobject> sirs = GU.lookupWithFilter(filterStr,'Sub_IR__c');    
        if (sirs.isEmpty())
            return null;
                                
        for(Sobject so: sirs){
            Sub_IR__c sir = (Sub_IR__c) so;
            List<Sub_IR__c> tSIrList = new List<Sub_IR__c>();           
            if (irSIRMap != null){
                if (irSIRMap.containsKey((String)sir.IR_Id__c)){                            
                    tSIrList = irSIRMap.get(sir.IR_Id__c);                              
                }                               
            } 
            tSIrList.add(sir);              
            irSIRMap.put((String)sir.IR_Id__c,tSIrList);
        }
        
        return irSIRMap;
    }
    
    
    public Map<String,TreeNode> getResultsFrameworkParentChildMap(){    
        
        system.debug('Goal Do Map:::' +goalDoMap);
        TreeNode projNode = new TreeNode(proj.Id,proj.public_Name__c,false,false);
        if (projectGoalMap.containsKey(proj.Id)){
            for(CDCSGoal__c g: projectGoalMap.get(proj.Id)){
                projNode.hasChildren = true;
                TreeNode goalNode = new TreeNode(g.Id, g.Goal_Statement__c,g.Indicators_Established__c,g.Reporting_Periods_Established__c);             
                if (goalDoMap.containsKey(g.Id)){
                    for(DO__c d: goalDoMap.get(g.Id)){
                        goalNode.hasChildren = true;
                        TreeNode doNode = new TreeNode(d.Id, d.Do_Name__c,d.Indicators_Established__c,d.Reporting_Periods_Established__c);                      
                        system.debug('DO IR Map:::' +doIrMap);
                        if (doIrMap.containsKey(d.Id)){             
                            for(IR__c i: doIrMap.get(d.Id)){
                                doNode.hasChildren = true;                  
                                TreeNode irNode = new TreeNode(i.Id, i.IR_Name__c,i.Indicators_Established__c,i.Reporting_Periods_Established__c);                              
                                system.debug('IR SUB IR Map:::' +irSirMap);
                                if (irSirMap.containsKey(i.Id)){    
                                    for(Sub_IR__c si: irSirMap.get(i.Id)){
                                        irNode.hasChildren = true;
                                        TreeNode sirNode = new TreeNode(si.Id, si.SIR_Name__c,si.Indicators_Established__c,si.Reporting_Periods_Established__c);
                                        
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
                        recMap.put(g.Id,goalNode);
                    }
                } else {
                    recMap.put(g.Id, new TreeNode());
                }
                projNode.children.add(goalNode);
                recMap.put(proj.Id,projNode);
            }
                
        } else {
            recMap.put(proj.Id, new TreeNode());
        }
        return recMap;
    }
    
    public Boolean hasChildren(String qId){
        if (recMap.containsKey(qId)){
            TreeNode tNode = new TreeNode();
            tNode = recMap.get(qId);
            return tNode.hasChildren;
        }
            
        return false;
    }
    
    
    
    
    public class TreeNode{
        public String nodeId{get; set;}
        public String nodeName{get;set;}
        public Boolean indEstablished{get;set;}
        public Boolean periodsEstablished{get;set;}
        public List<TreeNode> children {get;set;}
        public Boolean hasChildren{get;set;}
            
        /* Default Constructor of the calss TreeNode */
        public TreeNode(){
            children = new List<TreeNode>();
            this.hasChildren = false;
        }
        
        public TreeNode(String nId, String nName, Boolean iEst, Boolean pEst){        
            children = new List<TreeNode>();
            this.hasChildren = false;
            this.nodeId = nId;
            this.nodeName = nName;
            this.indEstablished = iESt;
            this.periodsEstablished = pEst;
            
        }   
        
        
        /* End of Default constructor of the calss TreeNode */
    }   
    

}