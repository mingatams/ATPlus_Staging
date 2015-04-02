public with sharing class ClsLogFrameUtility {
	public Project__c proj{get;set;}
	public set<Id> lgoalIds{get;set;}
	public set<Id> purposeIds{get;set;}
	public set<Id> spurposeIds{get;set;}
	public set<Id> outputIds{get;set;}
	public set<Id> inputIds{get;set;}
	
	private Map<String,List<LF_Goal__c>> projectLGoalMap = new Map<String,List<LF_Goal__c>>();
	private Map<String,List<LF_Purpose__c>> goalPurposeMap = new Map<String,List<LF_Purpose__c>>();
	private Map<String,List<LF_SubPurpose__c>> purposeSubPurposeMap = new Map<String,List<LF_SubPurpose__c>>();
	private Map<String,List<LF_Output__c>> purposeSubPurposeOutputMap = new Map<String,List<LF_Output__c>>();
	private Map<String,List<LF_Input__c>> outputInputMap = new Map<String,List<LF_Input__c>>();
	private Map<String,TreeNode> recMap = new Map<String,TreeNode>();
	
	
	private String filterStr;
	ClsGlobalUtility GU = new ClsGlobalUtility();
	public ClsLogFrameUtility(Project__c project){
		proj = project;
		lgoalIds  = new set<Id>();
		purposeIds = new set<Id>();
		spurposeIds = new set<Id>();
		outputIds = new set<Id>();
		inputIds = new set<Id>();
		filterStr = ' WHERE Project_Id__c = \'' +project.Id + '\' ';
		List<Sobject> prjLogFrameLinks = GU.lookupWithFilter(filterStr, 'LogFrame_Tree__c');
		if (!prjLogFrameLinks.isEMpty()){				 
			for(Sobject so:prjLogFrameLinks){
				LogFrame_Tree__c linkRec = (LogFrame_Tree__c) so;
				if (linkRec.LF_Goal_Id__c != null)
					lgoalIds.add(linkRec.LF_Goal_Id__c);
				if (linkRec.LF_Purpose_Id__c != null)
					purposeIds.add(linkRec.LF_Purpose_Id__c);
				if (linkRec.LF_SubPurpose_Id__c != null)	
					spurposeIds.add(linkRec.LF_SubPurpose_Id__c);
				if (linkRec.LF_Output_Id__c != null)	
					outputIds.add(linkRec.LF_Output_Id__c);
				if (linkRec.LF_Input_Id__c != null)	
					inputIds.add(linkRec.LF_Input_Id__c);
			}
		}
	}
	
	public Map<String,List<LF_Goal__c>> getLogFrameGoalMap(){
		if (lgoalIds.isEMpty())
			return null;
		filterStr = ' WHERE Id IN ' + GU.prepareINclause(lgoalIds);
		List<Sobject> lgoals = GU.lookupWithFilter(filterStr,'LF_Goal__c');	
		if (lgoals.isEmpty())
			return null;			
								
		for(Sobject so: lgoals){
			LF_Goal__c lgoal = (LF_Goal__c) so;
			List<LF_Goal__c> tLGoalList = new List<LF_Goal__c>();
			
			if (projectLGoalMap != null){
				if (projectLGoalMap.containsKey((String)proj.Id)){							
				 	tLGoalList = projectLGoalMap.get(proj.Id);					 			
				}					 			
			} 
			tLGoalList.add(lgoal);				
			projectLGoalMap.put((String)proj.Id,tLGoalList);
		}
		
		return projectLGoalMap;
	} 
	
	public Map<String,List<LF_Purpose__c>> getLogFramePurposeMap(){
		if (purposeIds.isEMpty())
			return null;
		filterStr = ' WHERE Id IN ' + GU.prepareINclause(purposeIds);
		List<Sobject> purposes = GU.lookupWithFilter(filterStr,'LF_Purpose__c');	
		if (purposes.isEmpty())
			return null;			
								
		for(Sobject so: purposes){
			LF_Purpose__c purpose = (LF_Purpose__c) so;
			List<LF_Purpose__c> tpurposeList = new List<LF_Purpose__c>();
			
			if (goalPurposeMap != null){
				if (goalPurposeMap.containsKey((String)purpose.LF_Goal_Id__c)){							
				 	tpurposeList = goalPurposeMap.get(purpose.LF_Goal_Id__c);					 			
				}					 			
			} 
			tpurposeList.add(purpose);				
			goalPurposeMap.put((String)purpose.LF_Goal_Id__c,tpurposeList);
		}
		
		return goalPurposeMap;
	} 
	
	public Map<String,List<LF_SubPurpose__c>> getLogFrameSubPurposeMap(){
		if (spurposeIds.isEMpty())
			return null;
		filterStr = ' WHERE Id IN ' + GU.prepareINclause(spurposeIds);
		List<Sobject> subPurposes = GU.lookupWithFilter(filterStr,'LF_SubPurpose__c');	
		if (subPurposes.isEmpty())
			return null;			
								
		for(Sobject so: subPurposes){
			LF_SubPurpose__c spurpose = (LF_SubPurpose__c) so;
			List<LF_SubPurpose__c> tspurposeList = new List<LF_SubPurpose__c>();
			
			if (purposeSubPurposeMap != null){
				if (purposeSubPurposeMap.containsKey((String)spurpose.LF_Purpose_Id__c)){							
				 	tspurposeList = purposeSubPurposeMap.get(spurpose.LF_Purpose_Id__c);					 			
				}					 			
			} 
			tspurposeList.add(spurpose);				
			purposeSubPurposeMap.put((String)spurpose.LF_Purpose_Id__c,tspurposeList);
		}
		
		System.debug('Purpose Sub Purpose Map:::' +purposeSubPurposeMap);
		return purposeSubPurposeMap;
	}
	
	public Map<String,List<LF_Output__c>> getLogFrameOutputMap(){
		if (outputIds.isEMpty())
			return null;
		filterStr = ' WHERE Id IN ' + GU.prepareINclause(outputIds);
		List<Sobject> outputs = GU.lookupWithFilter(filterStr,'LF_Output__c');	
		if (outputs.isEmpty())
			return null;			
								
		for(Sobject so: outputs){
            LF_Output__c output = (LF_Output__c) so;
            List<LF_Output__c> tOutputList = new List<LF_Output__c>();
            
            if (purposeSubPurposeOutputMap != null){
                if (output.LF_SubPurpose_Id__c == null){
                    if (purposeSubPurposeOutputMap.containsKey((String)output.LF_Purpose_Id__c)){                         
                        tOutputList = purposeSubPurposeOutputMap.get(output.LF_Purpose_Id__c);                                
                    }                           
                } else {
                    if (purposeSubPurposeOutputMap.containsKey((String)output.LF_SubPurpose_Id__c)){                          
                        tOutputList = purposeSubPurposeOutputMap.get(output.LF_SubPurpose_Id__c);                             
                    }                           
                }
                                                
            } 
            if (output.LF_SubPurpose_Id__c == null){                        
                tOutputList.add(output);                
                purposeSubPurposeOutputMap.put((String)output.LF_Purpose_Id__c,tOutputList);  
            } else {                        
                tOutputList.add(output);                
                purposeSubPurposeOutputMap.put((String)output.LF_SubPurpose_Id__c,tOutputList);
            }
            
        }
		
		return purposeSubPurposeOutputMap;
	}
	
	public Map<String,List<LF_Input__c>> getLogFrameInputMap(){
		if (inputIds.isEMpty())
			return null;
		filterStr = ' WHERE Id IN ' + GU.prepareINclause(inputIds);
		List<Sobject> inputs = GU.lookupWithFilter(filterStr,'LF_Input__c');	
		if (inputs.isEmpty())
			return null;			
								
		for(Sobject so: inputs){
			LF_Input__c input = (LF_Input__c) so;
			List<LF_Input__c> tInputList = new List<LF_Input__c>();			
			if (outputInputMap != null){
				if (outputInputMap.containsKey((String)input.LF_Output_Id__c)){							
				 	tInputList = outputInputMap.get(input.LF_Output_Id__c);					 			
				}					 			
			} 
			tInputList.add(input);				
			outputInputMap.put((String)input.LF_Output_Id__c,tInputList);
		}		
		
		return outputInputMap;
	}
	
	public Map<String,TreeNode> getLogFrameParentChildMap(){
		recMap = new Map<String,Treenode>();
        TreeNode projectNode = new TreeNode(proj.Id,proj.Public_Name__c,false,false);         
        if(projectLGoalMap.containsKey(proj.Id)){
            for(LF_Goal__c g: projectLGoalMap.get(proj.Id)){
                projectNode.hasChildren = true;
                TreeNode goalNode = new TreeNode(g.Id,g.LF_Goal_Name__c,g.Indicators_Established__c,g.Reporting_Periods_Established__c);                    
                if(goalPurposeMap.containsKey(g.Id) ){
                    for(LF_Purpose__c p: goalPurposeMap.get(g.Id)){
                        goalNode.hasChildren = true;
                        TreeNode purposeNode = new TreeNode(p.Id,p.LF_Purpose_Name__c,p.Indicators_Established__c,p.Reporting_Periods_Established__c);
                        
                        if(purposeSubPurposeOutputMap.containsKey(p.Id)){
                            for(LF_Output__c o:purposeSubPurposeOutputMap.get(p.Id)){
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
                            for(LF_SubPurpose__c sp: purposeSubPurposeMap.get(p.Id)){
                                purposeNode.hasChildren = true;
                                TreeNode subPurposeNode = new TreeNode(sp.Id,sp.LF_Purpose_Name__c,sp.Indicators_Established__c,sp.Reporting_Periods_Established__c);                                   
                                if(purposeSubPurposeOutputMap.containsKey(sp.Id)){
                                    for(LF_Output__c o:purposeSubPurposeOutputMap.get(sp.Id)){
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
                            if (!purposeSubPurposeOutputMap.containsKey(p.Id)){
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
                recMap.put(proj.Id,projectNode); 
            }               
        } else {
            recMap.put(proj.Id, new TreeNode());
        }
        return recMap;
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
	
}