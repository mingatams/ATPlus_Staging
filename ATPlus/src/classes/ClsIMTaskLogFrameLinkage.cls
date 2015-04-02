public with sharing class ClsIMTaskLogFrameLinkage {
    ClsGlobalUtility GU = new ClsGlobalUtility(); 
    
    public String inputRecordId;
    public String inputObjName;
    public String xmlStr{get;set;}
    public Map<String,String> projectIds = new Map<String,String>();
    public Boolean ShowErrors{get;set;}
    public string selectedSIrs{get;set;}
    public string headerName{get;set;}
    public string dispString{get;set;}
    public string filterStr{get;set;}
    public String navigationLink { get; set;} 
    Map<String,LFTree> iTreeMap = new Map<String,LFTree>();
    
    Public ClsIMTaskLogFrameLinkage(apexpages.standardcontroller controller){
        determineWhereFrom();       
    }
    
    private void determineWhereFrom(){
        try{
            inputRecordId = ApexPages.currentpage().getParameters().get('Lid');
            system.debug('Input Record::'+inputRecordId);
             if(inputRecordId != null)
            navigationLink= GU.createBreadCrumps(inputRecordId);      
          System.Debug('navigationLink*****  ' + navigationLink);
            
            inputObjName = GU.getObjectNameById(inputRecordId);
            system.debug('Object Name:::'+inputObjName);
            if(inputObjName.equalsIgnoreCase('Implementing_Mechanism__c')){
                dispString = 'Implementing Mechanism';
                filterStr = ' Where Implementing_Mechanism_Number__c = \'' +inputRecordId+ '\' AND Project_Type__c = \'LF Project\'';
                //List<Sobject> imProjects = GU.lookup(inputRecordId,'Implementing_Mechanism_Number__c','Public_IM_Link__c');
                List<Sobject> imProjects = GU.lookupWithFilter(filterStr,'Public_IM_Link__c');
                if (imProjects.isEmpty()){
                    ShowErrors = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Loading the LogFrame Table. Please contact your System Admin.'));
                } else {
                    for(Sobject sObj:imProjects){                       
                        Public_IM_Link__c pIMLink = new Public_IM_Link__c() ;       
                        pIMLink = (Public_IM_Link__c) sObj;
                        headerName = pIMLink.ImpMech_Name__c;
                        system.debug('Test:::::'+headerName);                       
                        projectIds.put((String)pIMLink.Project_Code__c,pIMLink.Project_Name__c);                                                
                    }
                    prepareLogFrameTree();
                    ShowErrors = false;
                }               
            } else if(inputObjName.equalsIgnoreCase('Activity__c')){
                dispString = 'Task';
                Activity__c actRec = (Activity__c) GU.lookup(inputRecordId,'Activity__c');              
                headerName = actRec.Activity_Name__c;
                system.debug('Test:::::'+headerName);
                if (actRec == null){
                    ShowErrors = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Loading the LogFrame Table. Please contact your System Admin.'));
                } else {
                    //for(Sobject sObj:actProjects){
                        //Activity__c actRec = new Activity__c();
                        //headerName = actRec.Activity_Name__c;
                        //system.debug('Test:::::'+headerName);
                        projectIds.put(actRec.Project_Code__c,actRec.Project_Name__c);                      
                    //}
                    prepareLogFrameTree();
                    ShowErrors = false;
                }
                
            }
            
        } catch(Exception e){
            System.debug('Error Message'+e.getMessage());
            ShowErrors = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Loading the LogFrame Table. Please contact your System Admin.'));
        }
    } 
    
    private void prepareLogFrameTree(){
        system.debug('Displaying the project Ids:::' +projectIds);
        //List<LogFrame_Tree__c> lfTreeList = prepLogframeTreeMap();
        //system.debug('Displaying the Tree List:::' +lfTreeList);
        Map<String,List<LogFrame_Tree__c>> logFrameMap = prepLogframeTreeMap(); 
        Map<String,LF_Link__c> existLinkMap = getExistLogFrameLink();                                                                   
        
        
        Xmlstreamwriter xmlW = new Xmlstreamwriter();
        xmlW.writeStartDocument('UTF-8','1.0');
        xmlW.writeStartElement(null,'rows', null);
        xmlW.writeAttribute(null,null,'id','0');
        system.debug('LogFrame Map:::' +logFrameMap);
        for(String pId: projectIds.keySet()){
            xmlW = prepareXMLrow(xmlW,pId,projectIds.get(pId),false,'1',existLinkMap);
            if (logFrameMap.containsKey(pId)){
                for(LogFrame_Tree__c goal: logFrameMap.get(pId) ){
                    xmlW = prepareXMLrow(xmlW,goal.Id,goal.LF_Goal_Name__c,false,'2',existLinkMap);
                    if (logFrameMap.containsKey(goal.LF_Goal_Id__c)){                   
                        for(LogFrame_Tree__c purpose: logFrameMap.get(goal.LF_Goal_Id__c)){
                            xmlW = prepareXMLrow(xmlW,purpose.Id,purpose.LF_Purpose_Name__c,false,'3',existLinkMap);
                            if(logFrameMap.containsKey(purpose.LF_Purpose_Id__c)){
                                for(LogFrame_Tree__c subPurpose: logFrameMap.get(purpose.LF_Purpose_Id__c)){
                                    if (subPurpose.LF_SubPurpose_Id__c == null){
                                        xmlW = prepareXMLrow(xmlW,subPurpose.Id,subPurpose.LF_Output_Name__c,true,'4',existLinkMap);
                                        if (logFrameMap.containsKey(subPurpose.LF_Output_Id__c)){
                                            for(LogFrame_Tree__c input: logFrameMap.get(subPurpose.LF_Output_Id__c)){
                                                xmlW = prepareXMLrow(xmlW,input.Id,input.LF_Input_Name__c,true,'5',existLinkMap);
                                                xmlW.writeEndElement();
                                            } // Close of Inputs    
                                        } // IF Verify Map by Output Id 
                                    } else {
                                        xmlW = prepareXMLrow(xmlW,subPurpose.Id,subPurpose.LF_SubPurpose_Name__c,true,'4',existLinkMap);
                                        if(logFrameMap.containsKey(subPurpose.LF_SubPurpose_Id__c)){
                                            for(LogFrame_Tree__c output: logFrameMap.get(subPurpose.LF_SubPurpose_Id__c)){
                                                xmlW = prepareXMLrow(xmlW,output.Id,output.LF_Output_Name__c,true,'5',existLinkMap);
                                                if (logFrameMap.containsKey(output.LF_Output_Id__c)){
                                                    for(LogFrame_Tree__c input: logFrameMap.get(output.LF_Output_Id__c)){
                                                        xmlW = prepareXMLrow(xmlW,input.Id,input.LF_Input_Name__c,true,'6',existLinkMap);
                                                        xmlW.writeEndElement();
                                                    } // Close of Inputs    
                                                } // IF Verify Map by Output Id     
                                                xmlW.writeEndElement();                 
                                            }   // Close of Outputs     
                                        }   //IF Verify Map by Sub Purpose Id
                                    }
                                    
                                    xmlW.writeEndElement();         
                                }   // Close of SubPurpose  
                            }   //IF Verify Map by Purpose Id
                            xmlW.writeEndElement();         
                        }   //Close of Purpose  
                    }   //IF Verify Map by Goal Id  
                    xmlW.writeEndElement(); 
                } // Close of Goal
            }   //IF Verify Map by Project Id
            xmlW.writeEndElement();
        } // Close of Project
        
        xmlW.writeEndElement();
        system.debug('XML Strin so far::::' +xmlW.getXmlString());   
        xmlStr = xmlW.getXmlString();
        xmlStr = xmlStr.replaceAll('\'','');            
    }
    private Map<String,LF_Link__c> getExistLogFrameLink(){
        Map<String,LF_Link__c> existLinkMap = new Map<String,LF_Link__c>();
        List<LF_Link__c> existLinkList = new List<LF_Link__c>([Select Id, LF_Goal_Id__c, LF_Input_Id__c, LF_Output_Id__c,
                                                                                LF_Purpose_Id__c, LF_SubPurpose_Id__c, Implementing_Mechanism_Id__c,
                                                                                Activity_Id__c, LogFrame_Tree_Id__c
                                                                        From LF_Link__c
                                                                        where Implementing_Mechanism_Id__c = :inputRecordId OR
                                                                                Activity_Id__c =:inputRecordId]);
        for(LF_Link__c lLink : existLinkList){
            existLinkMap.put(lLink.LogFrame_Tree_Id__c,lLink);          
        }
        return existLinkMap;                                                                
        
    }
    private Map<String,List<LogFrame_Tree__c>> prepLogframeTreeMap(){
        List<LogFrame_Tree__c> lfTreeList = new List<LogFrame_Tree__c>([Select LF_Goal_Id__c, LF_Input_Id__c, LF_Output_Id__c,
                                                                                LF_Purpose_Id__c, LF_SubPurpose_Id__c, LF_Goal_Name__c,
                                                                                LF_Input_Name__c, LF_Output_Name__c, LF_Purpose_Name__c,
                                                                                LF_SubPurpose_Name__c, Link_Type__c, Project_Id__c
                                                                        From LogFrame_Tree__c
                                                                        Where Project_Id__c in :projectIds.keySet()
                                                                        Order By Link_Type__c]);
        
        
        Map<String,List<LogFrame_Tree__c>> logFrameMap = new Map<String,List<LogFrame_Tree__c>>();
                                                                        
        
        for(LogFrame_Tree__c lTree: lfTreeList){            
            List<LogFrame_Tree__c> tempList = new List<LogFrame_Tree__c>();
            if (lTree.Link_Type__c == 'Primary'){               
                if (logFrameMap.containsKey(lTree.Project_Id__c)){
                    tempList = logFrameMap.get(lTree.Project_Id__c);                    
                }                   
                tempList.add(lTree);
                logFrameMap.put(lTree.Project_Id__c,tempList);
            }  else if (lTree.Link_Type__c == 'Primary Goal'){
                if (logFrameMap.containsKey(lTree.LF_Goal_Id__c)){
                    tempList = logFrameMap.get(lTree.LF_Goal_Id__c);                    
                }                   
                tempList.add(lTree);
                logFrameMap.put(lTree.LF_Goal_Id__c,tempList);
            } else if (lTree.Link_Type__c == 'Primary Purpose'  || lTree.Link_Type__c == 'Primary Purpose Output'){
                if (logFrameMap.containsKey(lTree.LF_Purpose_Id__c)){
                    tempList = logFrameMap.get(lTree.LF_Purpose_Id__c);                 
                }                   
                tempList.add(lTree);
                logFrameMap.put(lTree.LF_Purpose_Id__c,tempList);
            } else if (lTree.Link_Type__c == 'Primary Sub-Purpose'){
                if (logFrameMap.containsKey(lTree.LF_SubPurpose_Id__c)){
                    tempList = logFrameMap.get(lTree.LF_SubPurpose_Id__c);                  
                }                   
                tempList.add(lTree);
                logFrameMap.put(lTree.LF_SubPurpose_Id__c,tempList);
            } else if (lTree.Link_Type__c == 'Primary Output'){
                if (logFrameMap.containsKey(lTree.LF_Output_Id__c)){
                    tempList = logFrameMap.get(lTree.LF_Output_Id__c);                  
                }                   
                tempList.add(lTree);
                logFrameMap.put(lTree.LF_Output_Id__c,tempList);
            }
                
            
        }
        
        return logFrameMap;
    }
    
    
    private Xmlstreamwriter prepareXMLrow(Xmlstreamwriter xmlW,String rowId,String rowName, Boolean selectable, String level, 
                                        Map<String,LF_Link__c> existLinkMap){
        xmlW.writeStartElement(null,'row',null);
        if (!selectable) { 
            xmlW.writeAttribute(null,null,'locked','1');
        }   
        xmlW.writeAttribute(null,null,'id',rowId);
        xmlW.writeAttribute(null,null,'open','1');
        
        xmlW.writeStartElement(null,'cell',null);
        xmlw.writeCharacters('&nbsp'+rowName);
        xmlW.writeEndElement();
        if (selectable) {
            xmlW.writeStartElement(null,'cell',null);
            if (existLinkMap.containsKey(rowId)){
                xmlw.writeCharacters('true');   
            }         
            xmlW.writeEndElement();
        }   
        return xmlW;
        
    }
    
    
    
    
    
    
    Public pageReference insertSIrs(){
        system.debug('Changed Row Ids::::' +selectedSIrs);
        system.debug('Changed XML String:::' +xmlStr);
        
        determineWhereFrom();
        Map<String,List<LogFrame_Tree__c>> logFrameMap = prepLogframeTreeMap();
        Map<String,LF_Link__c> existLinkMap = getExistLogFrameLink();
        List<LF_Link__c> linkRecs = new List<LF_Link__c>();
        List<LF_Link__c> linkRecsDel = new List<LF_Link__c>();
        List<String> treeIds = new List<String>();
        
        parse(xmlStr);
        List<String> chndIds = new List<String>();
        if(selectedSIrs != '' && selectedSIrs != null){
            if(selectedSIrs.contains(',')){
                chndIds = selectedSIrs.split(',');
            } else {
                chndIds.add(selectedSIrs);
            }
        }
          
        /*if (chndIds.size() == 0 && selectedSIrs != null){
            chndIds.add(selectedSIrs);
            System.debug('Change Ids Before Processing 1:::' +chndIds);
        } */
        
        
        
        Map<Id,LogFrame_Tree__c> selectedTreeMap = new Map<Id,LogFrame_Tree__c>([Select Id, LF_Goal_Id__c, LF_Input_Id__c, LF_Output_Id__c,
                                                                                LF_Purpose_Id__c, LF_SubPurpose_Id__c, LF_Goal_Name__c,
                                                                                LF_Input_Name__c, LF_Output_Name__c, LF_Purpose_Name__c,
                                                                                LF_SubPurpose_Name__c, Link_Type__c, Project_Id__c
                                                                        From LogFrame_Tree__c
                                                                        Where Link_Type__c in ('Primary Output','Primary Sub-Purpose','Primary Purpose','Primary Purpose Output')
                                                                        Order By Link_Type__c]);
        
        System.debug('Change Ids Before Processing:::' +chndIds); 
        System.debug('selectedTree Map:::' +selectedTreeMap);
        
        for(String cId: chndIds){
            System.debug('Change Ids::: ' +cId); 
            if (iTreeMap.containsKey(cId)){
                LFTree lTree = iTreeMap.get(cId);
                if (!lTree.selected && existLinkMap.get(cId) != null){                  
                    linkRecsDel.add(existLinkMap.get(cId));                 
                }               
            }
        
            if(selectedTreeMap.containsKey(cId)){
                LF_Link__c linkNew = new LF_Link__c();
                LogFrame_Tree__c lTree = new LogFrame_Tree__c();                
                lTree = selectedTreeMap.get(cId);
                if (existLinkMap.containsKey(cId)){
                    linkNew = existLinkMap.get(cId);
                }
                linkNew.LogFrame_Tree_Id__c = lTree.Id;
                linkNew.LF_Goal_Id__c = lTree.LF_Goal_Id__c;
                linkNew.LF_Input_Id__c = lTree.LF_Input_Id__c;
                linkNew.LF_Output_Id__c = lTree.LF_Output_Id__c;
                linkNew.LF_Purpose_Id__c = lTree.LF_Purpose_Id__c;
                linkNew.LF_SubPurpose_Id__c = lTree.LF_SubPurpose_Id__c;    
                if (inputObjName.equalsIgnoreCase('Implementing_Mechanism__c')){
                    linkNew.Implementing_Mechanism_Id__c = inputRecordId;                   
                } else if(inputObjName.equalsIgnoreCase('Activity__c')){
                    linkNew.Activity_Id__c = inputRecordId;
                }
                linkRecs.add(linkNew);
            } 
        }
    
        
        
        if (!linkRecs.isEmpty()){
            System.debug('Test Upsert::::' +linkRecs);
            upsert linkRecs;
        }
        
        if (!linkRecsDel.isEmpty()){
            System.debug('Test Delete:::::' +linkRecsDel);
            delete linkRecsDel;
        }
        
        
        PageReference pageRef = new PageReference('/' + inputRecordId );  
        pageRef.setRedirect(true);
        return pageRef ;
    }
    
    
    private void parse(String toParse) {
        DOM.Document doc = new DOM.Document();    
          
        try {
            doc.load(toParse);    
            DOM.XMLNode root = doc.getRootElement();   
            system.debug('Root Tag Name:::' +root.getName()); 
                
            for(Dom.XMLNode child: root.getChildElements()){
                walkThrough(child);
            }           
        } catch (System.XMLException e) {  
            system.debug( e.getMessage());
        }
    }
    
    private void walkThrough(DOM.XMLNode node) {        
        Integer childCount = 0;
        Boolean rowInserted = false;
        LFTree iTree = new LFTree();
        
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT && node.getName().equalsIgnoreCase('row')) {
            String rowId = node.getAttributeValue(node.getAttributeKeyAt(0), node.getAttributeKeyNsAt(0));       
            iTree.rowId = rowId;
            for (Dom.XMLNode child: node.getChildElements()) {
                
                if(child.getName().equalsIgnoreCase('cell')){
                    if (childCount == 0){      
                        iTree.NameStr = child.getText();                      
                    } else if (childCount == 1){    
                        if (child.getText() == '1'){
                            iTree.selected = true;   
                        } else {
                            iTree.selected = false;
                        }   
                        iTreeMap.put(rowId, iTree);
                        rowInserted = true;                      
                    } 
                    childCount++;
                }  else {                   
                    walkThrough(child); 
                } 
                
            }
            if (!rowInserted){
                iTreeMap.put(rowId, iTree);
            }   
        }
         
    } 
    
    
    public PageReference cancel(){
        PageReference pageRef = new PageReference('/' + inputRecordId );  
        pageRef.setRedirect(true);
        return pageRef ;        
    }
    
    
    public class LFTree{        
        public String rowId;   
        public String NameStr;          
        public Boolean selected;        
    }
    
    @IsTest public static void testClsIMTaskLogFrameLinkage(){
         ClsTestUtility testIndicatorUtil = new ClsTestUtility();
         clsGlobalUtility gu1 = new clsGlobalUtility();
         String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
         String projectId = testIndicatorUtil.getProjectForOrgId(OrgUnitId);
         Implementing_Mechanism__c imId = testIndicatorUtil.getIMRecordForOrgId(OrgUnitId);
         String lfGoalId = testIndicatorUtil.getLFGoalForProjectId(projectId);
         String taskId = testIndicatorUtil.getTask(imId.id, projectId);
         String PImId = testIndicatorUtil.getPublicIMLinkId(imId.id, projectId);
         String lfPurposeId = testIndicatorUtil.getLFPurposeForGoal(lfGoalId);
         String lfSubPurposeId = testIndicatorUtil.getLFSubPurpose(lfPurposeId);
         //String lfOutputId = testIndicatorUtil.getLFOutputP(lfPurposeId);          
         String lfOutputId1 = testIndicatorUtil.getLFOutput(lfSubPurposeId);
         //String lfInputId = testIndicatorUtil.getLFInput(lfOutputId);
         String lfInputId1 = testIndicatorUtil.getLFInput(lfOutputId1);
         //String navigationLink1 = gu1.createBreadCrumps(lfInputId1);
         //LF_Link__c link1 = new LF_Link__c();
         //LogFrame_Tree__c link = new LogFrame_Tree__c();
         Test.Starttest() ; 
         String navigationLink1 = gu1.createBreadCrumps(lfInputId1);
         ApexPages.currentPage().getParameters().put('Lid', imId.id);
         //Implementing_Mechanism__c testIM = [Select Id, Name, Start_Date__c, End_Date__c, Reporting_Frequency__c, Reporting_Level__c From Implementing_Mechanism__c Where ouId__c=:OrgUnitId and Implementing_Mechanism_Name__c= 'TestIM' ];
         ApexPages.StandardController sc5 = new ApexPages.StandardController(imId);
         ClsIMTaskLogFrameLinkage CTL = new ClsIMTaskLogFrameLinkage(sc5);
         String navigationLink= gu1.createBreadCrumps(imId.id);
         CTL.prepareLogFrameTree();
         //CTL.insertSIrs();
         //CTL.cancel();
         Test.Stoptest(); 
         
     }
    
     @IsTest public static void testClsIMTaskLogFrameLinkage1(){
         ClsTestUtility testIndicatorUtil = new ClsTestUtility();
         String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
         String projectId = testIndicatorUtil.getProjectForOrgId(OrgUnitId);
         Implementing_Mechanism__c imId = testIndicatorUtil.getIMRecordForOrgId(OrgUnitId);
         String lfGoalId = testIndicatorUtil.getLFGoalForProjectId(projectId);
         String taskId = testIndicatorUtil.getTask(imId.id, projectId);
         String PImId = testIndicatorUtil.getPublicIMLinkId(imId.id, projectId);
         String lfPurposeId = testIndicatorUtil.getLFPurposeForGoal(lfGoalId);
         String lfSubPurposeId = testIndicatorUtil.getLFSubPurpose(lfPurposeId);          
         String lfOutputId1 = testIndicatorUtil.getLFOutput(lfSubPurposeId);
         String lfInputId1 = testIndicatorUtil.getLFInput(lfOutputId1);
         //LF_Link__c link1 = new LF_Link__c();
         //LogFrame_Tree__c link = new LogFrame_Tree__c();
         Test.Starttest() ; 
         ApexPages.currentPage().getParameters().put('Lid', imId.id);
         //Implementing_Mechanism__c testIM = [Select Id, Name, Start_Date__c, End_Date__c, Reporting_Frequency__c, Reporting_Level__c From Implementing_Mechanism__c Where ouId__c=:OrgUnitId and Implementing_Mechanism_Name__c= 'TestIM' ];
         ApexPages.StandardController sc5 = new ApexPages.StandardController(imId);
         ClsIMTaskLogFrameLinkage CTL = new ClsIMTaskLogFrameLinkage(sc5);
         //CTL.prepareLogFrameTree();
         CTL.insertSIrs();
         CTL.cancel();
         Test.Stoptest(); 
         
     }
     
     @IsTest public static void testClsIMTaskLogFrameLinkage2(){
         ClsTestUtility testIndicatorUtil = new ClsTestUtility();
         clsGlobalUtility gu1 = new clsGlobalUtility();
         String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
         String projectId = testIndicatorUtil.getProjectForOrgId(OrgUnitId);
         Implementing_Mechanism__c imId = testIndicatorUtil.getIMRecordForOrgId(OrgUnitId);
         String lfGoalId = testIndicatorUtil.getLFGoalForProjectId(projectId);
         String taskId = testIndicatorUtil.getTask(imId.ID, projectId);
         String PImId = testIndicatorUtil.getPublicIMLinkId(imId.ID, projectId);
         String lfPurposeId = testIndicatorUtil.getLFPurposeForGoal(lfGoalId);
         String lfSubPurposeId = testIndicatorUtil.getLFSubPurpose(lfPurposeId); 
         //String lfOutputId = testIndicatorUtil.getLFOutputP(lfPurposeId);         
         String lfOutputId1 = testIndicatorUtil.getLFOutput(lfSubPurposeId);
         //String lfInputId = testIndicatorUtil.getLFInput(lfOutputId);
         String lfInputId1 = testIndicatorUtil.getLFInput(lfOutputId1);
         //LF_Link__c link1 = new LF_Link__c();
         //LogFrame_Tree__c link = new LogFrame_Tree__c();
         Test.Starttest() ; 
         ApexPages.currentPage().getParameters().put('Lid', taskId);
         //Activity__c testTask = new Activity__c(ImpMech_Id__c=imId, Project_Code__c=projId, Activity_Name__c = 'Test Task');
         Activity__c testTask = [Select Id, Name, ImpMech_Id__c, Project_Code__c, Activity_Name__c from Activity__c where ImpMech_Id__c =: imId.ID and Project_Code__c =: projectId];
         //Implementing_Mechanism__c testIM = [Select Id, Name, Start_Date__c, End_Date__c, Reporting_Frequency__c, Reporting_Level__c From Implementing_Mechanism__c Where ouId__c=:OrgUnitId and Implementing_Mechanism_Name__c= 'TestIM' ];
         ApexPages.StandardController sc6 = new ApexPages.StandardController(testTask);
         ClsIMTaskLogFrameLinkage CTL = new ClsIMTaskLogFrameLinkage(sc6);
         String navigationLink= gu1.createBreadCrumps(taskId);
         CTL.prepareLogFrameTree();
         //CTL.insertSIrs();
         //CTL.cancel();
         Test.Stoptest(); 
         
     }
     
}