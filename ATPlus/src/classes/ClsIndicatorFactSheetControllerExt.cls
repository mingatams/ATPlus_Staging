public with sharing class ClsIndicatorFactSheetControllerExt {
    private OrgUnit_Indicator__c iRec;
    
    private Map<String,List<RF_Indicator_Result__c>> rfResults;
    private Map<String,List<LF_Indicator_Result__c>> lfResults;
    private Map<String,List<Indicator_Results__c>> imResults;
    
    
    public List<IndResults> rfIndResults{get;set;}
    public List<IndResults> lfIndResults{get;set;}
    public List<IndResults> imIndResults{get;set;}   
    
        
    
    ClsGlobalUtility GU = new ClsGlobalUtility();
    public ClsIndicatorFactSheetControllerExt(ApexPages.StandardController controller){ 
        iRec = (OrgUnit_Indicator__c)controller.getRecord();
        
        rfResults = new Map<String,List<RF_Indicator_Result__c>>();
        lfResults = new Map<String,List<LF_Indicator_Result__c>>();
        imResults = new Map<String,List<Indicator_Results__c>>();  
        
        rfIndResults = new List<IndResults>();
        lfIndResults = new List<IndResults>();
        imIndResults = new List<IndResults>();      
        
        Set<Id> rfGoalIds = new Set<Id>();
        Set<Id> rfDoIds = new Set<Id>();
        Set<Id> rfIrIds = new Set<Id>();
        Set<Id> rfSirIds = new Set<Id>();    
        
        Set<Id> lfGoalIds = new Set<Id>();
        Set<Id> lfPurposeIds = new Set<Id>();
        Set<Id> lfSpurposeIds = new Set<Id>();
        Set<Id> lfOutputIds = new Set<Id>();
        Set<Id> lfInputIds = new Set<Id>();
    
        Set<Id>imIds = new Set<Id>();
        Set<Id> taskIds = new Set<Id>();        
     
               
        Map<String,String> rfrecTypesMap = GU.getRecordTypeByObject('RF_Indicator_Result__c');
        Map<String,String> lfrecTypesMap = GU.getRecordTypeByObject('LF_Indicator_Result__c');
        Map<String,String> imrecTypesMap = GU.getRecordTypeByObject('Indicator_Results__c');
        
        Map<String,String> orgUnitRecTypesMap = GU.getRecordTypeByObject('OrgUnit_Indicator__c');
        
        Map<String,String> recTypesMapRev = new Map<String,String>();
        Map<String,String> orgUnitRecTypesMapRev = new Map<String,String>();
          for(String Key: rfrecTypesMap.keySet()){
              recTypesMapRev.put(rfrecTypesMap.get(Key),Key);       
          }   
          
          for(String Key: lfrecTypesMap.keySet()){
              recTypesMapRev.put(lfrecTypesMap.get(Key),Key);       
          }
          
          for(String Key: imrecTypesMap.keySet()){
              recTypesMapRev.put(imrecTypesMap.get(Key),Key);       
          }
          
          for(String Key: orgUnitRecTypesMap.keySet()){
              orgUnitRecTypesMapRev.put(orgUnitRecTypesMap.get(Key),Key);       
          }
        
        String indFStr = ' where Organization_Indicator_Id__c = \'' +iRec.Id + '\' order by RecordTypeId'; 
        List<Sobject> childIndicators = GU.lookupWithFilter(indFStr,'OrgUnit_Indicator__c');
        System.debug('Record types Map:'+orgUnitRecTypesMap);
        for(SObject cind: childIndicators){
            OrgUnit_Indicator__c oCInd = (OrgUnit_Indicator__c) cind;
            if (orgUnitRecTypesMapRev.get(oCInd.RecordTypeId).equalsIgnoreCase('RF Goal') && oCInd.Goal_Id__c != null){                                           
                 rfGoalIds.add(oCInd.Goal_Id__c );                                                     
            } else if(orgUnitRecTypesMapRev.get(oCInd.RecordTypeId).equalsIgnoreCase('RF DO') && oCInd.DO_Id__c != null){
                rfDoIds.add(oCInd.DO_Id__c);               
            } else if(orgUnitRecTypesMapRev.get(oCInd.RecordTypeId).equalsIgnoreCase('RF IR') && oCInd.IR_Id__c != null) {
                rfIrIds.add(oCInd.IR_Id__c);                
            } else if(orgUnitRecTypesMapRev.get(oCInd.RecordTypeId).equalsIgnoreCase('RF SUB IR') && oCInd.SIR_Id__c != null ) {
                rfSirIds.add(oCInd.SIR_Id__c);                            
            } else if (orgUnitRecTypesMapRev.get(oCInd.RecordTypeId).equalsIgnoreCase('LF Goal') && oCInd.LF_Goal_Id__c != null){
                lfGoalIds.add(oCInd.LF_Goal_Id__c);                                
            } else if(orgUnitRecTypesMapRev.get(oCInd.RecordTypeId).equalsIgnoreCase('LF Purpose') && oCInd.LF_Purpose_Id__c != null){
                lfPurposeIds.add(oCInd.LF_Purpose_Id__c);                
            } else if(orgUnitRecTypesMapRev.get(oCInd.RecordTypeId).equalsIgnoreCase('LF Sub-Purpose') && oCInd.LF_SubPurpose_Id__c != null) {
                lfSpurposeIds.add(oCInd.LF_SubPurpose_Id__c);                
            } else if(orgUnitRecTypesMapRev.get(oCInd.RecordTypeId).equalsIgnoreCase('LF Output') && oCInd.LF_Output_Id__c != null) {
                lfOutputIds.add(oCInd.LF_Output_Id__c);                           
            } else if(orgUnitRecTypesMapRev.get(oCInd.RecordTypeId).equalsIgnoreCase('LF Input') && oCInd.LF_Input_Id__c != null) {
                lfInputIds.add(oCInd.LF_Input_Id__c);                            
            } else if (orgUnitRecTypesMapRev.get(oCInd.RecordTypeId).equalsIgnoreCase('Implementing Mechanism') && oCInd.Implementing_Mechanism_Id__c != null){
                imIds.add(oCInd.Implementing_Mechanism_Id__c);                                
            } 
            
        }
        String fStr = ' where Organization_Indicator_Master_Id__c = \'' +iRec.Id +'\' Order by RecordTypeId';
        List<Sobject> rfSObjects = GU.lookupWithFilter(fStr,'RF_Indicator_Result__c');
        for(SObject rfs: rfSObjects){
            RF_Indicator_Result__c rfir = (RF_Indicator_Result__c) rfs;           
            if (recTypesMapRev.get(rfir.RecordTypeId).equalsIgnoreCase('RF Goal') && rfir.CDCS_Goals__c != null){                                           
                // rfGoalIds.add(rfir.CDCS_Goals__c);
                 prepareRFResults(rfir.CDCS_Goals__c,rfir);                                    
            } else if(recTypesMapRev.get(rfir.RecordTypeId).equalsIgnoreCase('RF DO') && rfir.DO_Id__c != null){
               // rfDoIds.add(rfir.DO_Id__c);
                prepareRFResults(rfir.DO_Id__c,rfir);
            } else if(recTypesMapRev.get(rfir.RecordTypeId).equalsIgnoreCase('RF IR') && rfir.IR_Id__c != null) {
               // rfIrIds.add(rfir.IR_Id__c);
                prepareRFResults(rfir.IR_Id__c,rfir);
            } else if(recTypesMapRev.get(rfir.RecordTypeId).equalsIgnoreCase('RF SUB IR') && rfir.Sub_IR_Id__c!= null ) {
               // rfSirIds.add(rfir.Sub_IR_Id__c);
                prepareRFResults(rfir.Sub_IR_Id__c,rfir);            
            }            
        }
        List<Sobject> lfSObjects = GU.lookupWithFilter(fStr,'LF_Indicator_Result__c');
        
        for(SObject lfs: lfSObjects){
            LF_Indicator_Result__c lfir = (LF_Indicator_Result__c) lfs;           
            if (recTypesMapRev.get(lfir.RecordTypeId).equalsIgnoreCase('LF Goal') && lfir.LF_Goal_Id__c != null){
               // lfGoalIds.add(lfir.LF_Goal_Id__c);
                prepareLFResults(lfir.LF_Goal_Id__c,lfir);                
            } else if(recTypesMapRev.get(lfir.RecordTypeId).equalsIgnoreCase('LF Purpose') && lfir.LF_Purpose_Id__c != null){
               // lfPurposeIds.add(lfir.LF_Purpose_Id__c);
                prepareLFResults(lfir.LF_Purpose_Id__c,lfir);
            } else if(recTypesMapRev.get(lfir.RecordTypeId).equalsIgnoreCase('LF Sub-Purpose') && lfir.LF_SubPurpose_Id__c != null) {
               // lfSpurposeIds.add(lfir.LF_SubPurpose_Id__c);
                prepareLFResults(lfir.LF_SubPurpose_Id__c,lfir);
            } else if(recTypesMapRev.get(lfir.RecordTypeId).equalsIgnoreCase('LF Output') && lfir.LF_Output__c != null) {
               // lfOutputIds.add(lfir.LF_Output__c);
                prepareLFResults(lfir.LF_Output__c,lfir);            
            } else if(recTypesMapRev.get(lfir.RecordTypeId).equalsIgnoreCase('LF Input') && lfir.LF_Input__c != null) {
               // lfInputIds.add(lfir.LF_Input__c);
                prepareLFResults(lfir.LF_Input__c,lfir);            
            }           
        }
        
        List<Sobject> imSObjects = GU.lookupWithFilter(fStr,'Indicator_Results__c');
        
        for(SObject ims: imSObjects){
            Indicator_Results__c imir = (Indicator_Results__c) ims;           
            if (recTypesMapRev.get(imir.RecordTypeId).equalsIgnoreCase('Implementing Mechanism') && imir.Implementing_Mechanism_Id__c != null){
               // imIds.add(imir.Implementing_Mechanism_Id__c);
                prepareIMResults(imir.Implementing_Mechanism_Id__c,imir);                
            } else if(recTypesMapRev.get(imir.RecordTypeId).equalsIgnoreCase('Task') && imir.Activity_Id__c != null){
                taskIds.add(imir.Activity_Id__c);
                prepareIMResults(imir.Activity_Id__c,imir);
            }            
        }       
        
        if(!rfGoalIds.isEmpty()){
            fStr = ' where Id in ' +GU.prepareINclause(rfGoalIds);
            List<Sobject> sList = GU.lookupWithFilter(fStr, 'CDCSGoal__c');
            for(Sobject s: sList){
                CDCSGoal__c cObj = (CDCSGoal__c) s;
                if (rfResults.containsKey(cObj.Id)) {
                    IndResults ir = new IndResults(cObj.Id,'Goal',cObj.Goal_Name__c,rfResults.get(cObj.Id));
                    ir.resultsEstablished = true;
                    rfIndResults.add(ir);
                } else {
                    IndResults ir = new IndResults(cObj.Id,'Goal',cObj.Goal_Name__c);
                    ir.resultsEstablished = false;
                    rfIndResults.add(ir);
                }
                
            }          
            
        }   
        
        
        if(!rfDoIds.isEmpty()){
            fStr = ' where Id in ' +GU.prepareINclause(rfDoIds);
            List<Sobject> sList = GU.lookupWithFilter(fStr, 'DO__c');
            for(Sobject s: sList){
                DO__c cObj = (DO__c) s;
                if (rfResults.containsKey(cObj.Id)) {
                    IndResults ir = new IndResults(cObj.Id,cObj.Name,cObj.DO_Title__c,rfResults.get(cObj.Id));
                    ir.resultsEstablished = true;
                    rfIndResults.add(ir);
                } else {
                    IndResults ir = new IndResults(cObj.Id,cObj.Name,cObj.DO_Title__c);
                    ir.resultsEstablished = false;
                    rfIndResults.add(ir);
                }
                
            }            
        }
        
        if(!rfIrIds.isEmpty()){
            fStr = ' where Id in ' +GU.prepareINclause(rfIrIds);
            List<Sobject> sList = GU.lookupWithFilter(fStr, 'IR__c');
            for(Sobject s: sList){
                IR__c cObj = (IR__c) s;
                if (rfResults.containsKey(cObj.Id)) {
                    IndResults ir = new IndResults(cObj.Id,cObj.Name,cObj.IR_Title__c,rfResults.get(cObj.Id));
                    ir.resultsEstablished = true;
                    rfIndResults.add(ir);
                } else {
                    IndResults ir = new IndResults(cObj.Id,cObj.Name,cObj.IR_Title__c);
                    ir.resultsEstablished = false;
                    rfIndResults.add(ir);
                }
                
            }            
        }
        
        if(!rfSirIds.isEmpty()){
            fStr = ' where Id in ' +GU.prepareINclause(rfSirIds);
            List<Sobject> sList = GU.lookupWithFilter(fStr, 'Sub_IR__c');
            for(Sobject s: sList){
                Sub_IR__c cObj = (Sub_IR__c) s;
                if (rfResults.containsKey(cObj.Id)) {
                    IndResults ir = new IndResults(cObj.Id,cObj.Name,cObj.SIR_Title__c,rfResults.get(cObj.Id));
                    ir.resultsEstablished = true;
                    rfIndResults.add(ir);
                } else {
                    IndResults ir = new IndResults(cObj.Id,cObj.Name,cObj.SIR_Title__c);
                    ir.resultsEstablished = false;
                    rfIndResults.add(ir);
                }
                
            }
        }
        
        if(!lfGoalIds.isEmpty()){
            fStr = ' where Id in ' +GU.prepareINclause(lfGoalIds);
            List<Sobject> sList = GU.lookupWithFilter(fStr, 'LF_Goal__c');
            for(Sobject s: sList){
                LF_Goal__c cObj = (LF_Goal__c) s;
               if (lfResults.containsKey(cObj.Id)) {
                    IndResults ir = new IndResults(cObj.Id,'Goal',cObj.LF_Goal_Name__c,lfResults.get(cObj.Id));
                    ir.resultsEstablished = true;
                    lfIndResults.add(ir);
                } else {
                    IndResults ir = new IndResults(cObj.Id,'Goal',cObj.LF_Goal_Name__c);
                    ir.resultsEstablished = false;
                    lfIndResults.add(ir);
                }
                
            }
        } 
        
        if(!lfPurposeIds.isEmpty()){
            fStr = ' where Id in ' +GU.prepareINclause(lfPurposeIds);
            List<Sobject> sList = GU.lookupWithFilter(fStr, 'LF_Purpose__c');
            for(Sobject s: sList){
                LF_Purpose__c cObj = (LF_Purpose__c) s;
                if (lfResults.containsKey(cObj.Id)) {
                    IndResults ir = new IndResults(cObj.Id,'Purpose',cObj.LF_Purpose_Name__c,lfResults.get(cObj.Id));
                    ir.resultsEstablished = true;
                    lfIndResults.add(ir);
                } else {
                    IndResults ir = new IndResults(cObj.Id,'Purpose',cObj.LF_Purpose_Name__c);
                    ir.resultsEstablished = false;
                    lfIndResults.add(ir);
                }
                
            }
        }
        
        if(!lfSpurposeIds.isEmpty()){
            fStr = ' where Id in ' +GU.prepareINclause(lfSpurposeIds);
            List<Sobject> sList = GU.lookupWithFilter(fStr, 'LF_SubPurpose__c');
            for(Sobject s: sList){
                LF_SubPurpose__c cObj = (LF_SubPurpose__c) s;
                if (lfResults.containsKey(cObj.Id)) {
                    IndResults ir = new IndResults(cObj.Id,'Sub Purpose',cObj.LF_SubPurpose_Name__c,lfResults.get(cObj.Id));
                    ir.resultsEstablished = true;
                    lfIndResults.add(ir);
                } else {
                    IndResults ir = new IndResults(cObj.Id,'Sub Purpose',cObj.LF_SubPurpose_Name__c);
                    ir.resultsEstablished = false;
                    lfIndResults.add(ir);
                }
                
            }
        }
        
        if(!lfOutputIds.isEmpty()){
            fStr = ' where Id in ' +GU.prepareINclause(lfOutputIds);
            List<Sobject> sList = GU.lookupWithFilter(fStr, 'LF_Output__c');
            for(Sobject s: sList){
                LF_Output__c cObj = (LF_Output__c) s;
                if (lfResults.containsKey(cObj.Id)) {
                    IndResults ir = new IndResults(cObj.Id,'Output',cObj.LF_Output_Name__c,lfResults.get(cObj.Id));
                    ir.resultsEstablished = true;
                    lfIndResults.add(ir);
                } else {
                    IndResults ir = new IndResults(cObj.Id,'Output',cObj.LF_Output_Name__c);
                    ir.resultsEstablished = false;
                    lfIndResults.add(ir);
                }
                
            }
        }
        
        if(!lfInputIds.isEmpty()){
            fStr = ' where Id in ' +GU.prepareINclause(lfInputIds);
            List<Sobject> sList = GU.lookupWithFilter(fStr, 'LF_Input__c');
            for(Sobject s: sList){
                LF_Input__c cObj = (LF_Input__c) s;
                if (lfResults.containsKey(cObj.Id)) {
                    IndResults ir = new IndResults(cObj.Id,'Input',cObj.LF_Input_Name__c,lfResults.get(cObj.Id));
                    ir.resultsEstablished = true;
                    lfIndResults.add(ir);
                } else {
                    IndResults ir = new IndResults(cObj.Id,'Input',cObj.LF_Input_Name__c);
                    ir.resultsEstablished = false;
                    lfIndResults.add(ir);
                }
                
            }
        }
        
        if(!imIds.isEmpty()){
            fStr = ' where Id in ' +GU.prepareINclause(imIds);
            List<Sobject> sList = GU.lookupWithFilter(fStr, 'Implementing_Mechanism__c');
            for(Sobject s: sList){
                Implementing_Mechanism__c cObj = (Implementing_Mechanism__c) s;
                if (imResults.containsKey(cObj.Id)) {
                    IndResults ir = new IndResults(cObj.Id,cObj.Name,cObj.Implementing_Mechanism_Name__c,imResults.get(cObj.Id));
                    ir.resultsEstablished = true;
                    imIndResults.add(ir);
                } else {
                    IndResults ir = new IndResults(cObj.Id,cObj.Name,cObj.Implementing_Mechanism_Name__c);
                    ir.resultsEstablished = false;
                    imIndResults.add(ir);
                }
            } 
        }
        
        if(!taskIds.isEmpty()){
            fStr = ' where Id in ' +GU.prepareINclause(taskIds);
            List<Sobject> sList = GU.lookupWithFilter(fStr, 'Activity__c');
            for(Sobject s: sList){
                Activity__c cObj = (Activity__c) s;
                if (imResults.containsKey(cObj.Id)) {
                    IndResults ir = new IndResults(cObj.Id,'Task | '+cObj.Name+' | '+cObj.ImpMech_Name__c,cObj.Activity_Name__c,imResults.get(cObj.Id));
                    imIndResults.add(ir);
                }
            }
        }
        
        
    }
    
    private void prepareRFResults(String idStr, RF_Indicator_Result__c ir){
        List<RF_Indicator_Result__c> tempList = new List<RF_Indicator_Result__c>();
        if (rfResults.containsKey(idStr)){
            tempList = rfResults.get(idStr);
        } 
        tempList.add(ir);
        rfResults.put(idStr,tempList);    
    }
    
    private void prepareLFResults(String idStr, LF_Indicator_Result__c ir){
        List<LF_Indicator_Result__c> tempList = new List<LF_Indicator_Result__c>();
        if (lfResults.containsKey(idStr)){
            tempList = lfResults.get(idStr);
        } 
        tempList.add(ir);
        lfResults.put(idStr,tempList);    
    }
    
    private void prepareIMResults(String idStr, Indicator_Results__c ir){
        List<Indicator_Results__c> tempList = new List<Indicator_Results__c>();
        if (imResults.containsKey(idStr)){
            tempList = imResults.get(idStr);
        } 
        tempList.add(ir);
        imResults.put(idStr,tempList);    
    }
    
    public Class IndResults{
        public Id recId{get;set;}
        public String recType{get;set;}
        public String recName{get;set;}
        public boolean resultsEstablished{get;set;}
        public List<RF_Indicator_Result__c> rfResults{get;set;}
        public List<LF_Indicator_Result__c> lfResults{get;set;}
        public List<Indicator_Results__c> imResults{get;set;}
        
        public IndResults(Id rId, String rType, String rName, List<RF_Indicator_Result__c> rResults){
            assignPrimitives(rId,rType,rName);
            this.rfResults = rResults;
        }
        
        public IndResults(Id rId, String rType, String rName, List<LF_Indicator_Result__c> lResults){
            assignPrimitives(rId,rType,rName);
            this.lfResults = lResults;
        }
        
        public IndResults(Id rId, String rType, String rName, List<Indicator_Results__c> iResults){
            assignPrimitives(rId,rType,rName);
            this.imResults = iResults;
        }
        
        public IndResults(Id rId, String rType, String rName){
            assignPrimitives(rId,rType,rName);
        }
        
        private void assignPrimitives(Id rId, String rType, String rName){
            this.recId =  rId;
            this.recType =  rType;
            this.recName =  rName;
        }
    
    }
     
     @IsTest public static void testClsIndicatorFactSheetControllerExtLFGoal() {        
          ClsTestUtility testIndicatorUtil = new ClsTestUtility(); 
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
          String projectId = testIndicatorUtil.getProjectForOrgId(OrgUnitId);          
          String lfGoalId = testIndicatorUtil.getLFGoalForProjectId(projectId);
         // String lfPurposeId = testIndicatorUtil.getLFPurposeForGoal(lfGoalId);
         // String lfSubPurposeId = testIndicatorUtil.getLFSubPurpose(lfPurposeId);          
         // String lfOutputId = testIndicatorUtil.getLFOutputP(lfPurposeId);
         // String lfOutputId1 = testIndicatorUtil.getLFOutput(lfSubPurposeId);
         // String lfInputId = testIndicatorUtil.getLFInput(lfOutputId);
         // String lfInputId1 = testIndicatorUtil.getLFInput(lfOutputId1);
          testIndicatorUtil.updateProjectForOrgId(OrgUnitId);
          testIndicatorUtil.updateLFGoalForProjectId(projectId);
          
           
          System.Test.startTest();
          testIndicatorUtil.updateProjectForOrgId(OrgUnitId);
          testIndicatorUtil.updateLFGoalForProjectId(projectId);
          OrgUnit_Indicator__c masterInd = testIndicatorUtil.getCustomIndicatorRecordForOrgId(OrgUnitId);
          OrgUnit_Indicator__c childInd = testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,lfGoalId,'LFGoal');
          List<LF_Reporting_Period__c> lfRPList = testIndicatorUtil.getLFReportingPeriods(lfGoalId);
          LF_Reporting_Period__c lfRP = lfRPList[0];
          LF_Indicator_Result__c irId = testIndicatorUtil.getLFIndicatorResultRecordByLFGoal(lfRP.Id,masterInd.Id,childInd.Id,lfGoalId);  
              
          ApexPages.currentPage().getParameters().put('id', masterInd.Id);  
          ApexPages.StandardController sc5 = new ApexPages.StandardController(masterInd);          
          ClsIndicatorFactSheetControllerExt CLF = new ClsIndicatorFactSheetControllerExt(sc5);
          
         // upsert irId;
         // upsert lfRP;
          upsert childInd;
          
         // delete irId;
         // delete lfRP;
          delete childInd;
          
          System.Test.stopTest();
      
     }  
     
     @IsTest public static void testClsIndicatorFactSheetControllerExtLFPurpose() {        
          ClsTestUtility testIndicatorUtil = new ClsTestUtility(); 
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
          String projectId = testIndicatorUtil.getProjectForOrgId(OrgUnitId);          
          String lfGoalId = testIndicatorUtil.getLFGoalForProjectId(projectId);
          testIndicatorUtil.updateProjectForOrgId(OrgUnitId);
          testIndicatorUtil.updateLFGoalForProjectId(projectId);
          
          String lfPurposeId = testIndicatorUtil.getLFPurposeForGoal(lfGoalId);
         // String lfSubPurposeId = testIndicatorUtil.getLFSubPurpose(lfPurposeId);          
         // String lfOutputId = testIndicatorUtil.getLFOutputP(lfPurposeId);
         // String lfOutputId1 = testIndicatorUtil.getLFOutput(lfSubPurposeId);
         // String lfInputId = testIndicatorUtil.getLFInput(lfOutputId);
         // String lfInputId1 = testIndicatorUtil.getLFInput(lfOutputId1);
         // testIndicatorUtil.updateProjectForOrgId(OrgUnitId);
         // testIndicatorUtil.updateLFGoalForProjectId(projectId);
          
           
          System.Test.startTest();
          
          OrgUnit_Indicator__c masterInd = testIndicatorUtil.getCustomIndicatorRecordForOrgId(OrgUnitId);
          OrgUnit_Indicator__c childInd = testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,lfPurposeId,'LFPurpose');
          List<LF_Reporting_Period__c> lfRPList = testIndicatorUtil.getLFReportingPeriods(lfPurposeId,'Purpose');
          LF_Reporting_Period__c lfRP = lfRPList[0];
          LF_Indicator_Result__c irId = testIndicatorUtil.getLFIndicatorResultByLFElement(lfRP.Id,masterInd.Id,childInd.Id,lfPurposeId,'Purpose');  
              
          ApexPages.currentPage().getParameters().put('id', masterInd.Id);  
          ApexPages.StandardController sc5 = new ApexPages.StandardController(masterInd);          
          ClsIndicatorFactSheetControllerExt CLF = new ClsIndicatorFactSheetControllerExt(sc5);
          
        //  upsert irId;
        //  upsert lfRP;
          upsert childInd;
          
        //  delete irId;
        //  delete lfRP;
          delete childInd;
          
          System.Test.stopTest();
      
     }
     
     @IsTest public static void testClsIndicatorFactSheetControllerExtLFSubPurpose() {        
          ClsTestUtility testIndicatorUtil = new ClsTestUtility(); 
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
          String projectId = testIndicatorUtil.getProjectForOrgId(OrgUnitId);          
          String lfGoalId = testIndicatorUtil.getLFGoalForProjectId(projectId);
          String lfPurposeId = testIndicatorUtil.getLFPurposeForGoal(lfGoalId);
          testIndicatorUtil.updateProjectForOrgId(OrgUnitId);
          testIndicatorUtil.updateLFGoalForProjectId(projectId);          
          
          String lfSubPurposeId = testIndicatorUtil.getLFSubPurpose(lfPurposeId);          
         // String lfOutputId = testIndicatorUtil.getLFOutputP(lfPurposeId);
         // String lfOutputId1 = testIndicatorUtil.getLFOutput(lfSubPurposeId);
         // String lfInputId = testIndicatorUtil.getLFInput(lfOutputId);
         // String lfInputId1 = testIndicatorUtil.getLFInput(lfOutputId1);
         // testIndicatorUtil.updateProjectForOrgId(OrgUnitId);
         // testIndicatorUtil.updateLFGoalForProjectId(projectId);
          
           
          System.Test.startTest();
          
          OrgUnit_Indicator__c masterInd = testIndicatorUtil.getCustomIndicatorRecordForOrgId(OrgUnitId);
          OrgUnit_Indicator__c childInd = testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,lfSubPurposeId,'LFSubPurpose');
          List<LF_Reporting_Period__c> lfRPList = testIndicatorUtil.getLFReportingPeriods(lfSubPurposeId,'SubPurpose');
          LF_Reporting_Period__c lfRP = lfRPList[0];
          LF_Indicator_Result__c irId = testIndicatorUtil.getLFIndicatorResultByLFElement(lfRP.Id,masterInd.Id,childInd.Id,lfSubPurposeId,'SubPurpose');  
              
          ApexPages.currentPage().getParameters().put('id', masterInd.Id);  
          ApexPages.StandardController sc5 = new ApexPages.StandardController(masterInd);          
          ClsIndicatorFactSheetControllerExt CLF = new ClsIndicatorFactSheetControllerExt(sc5);
          
        //  upsert irId;
       //   upsert lfRP;
          upsert childInd;
          
        //  delete irId;
        //  delete lfRP;
          delete childInd;
          
          System.Test.stopTest();
      
     }
     
     @IsTest public static void testClsIndicatorFactSheetControllerExtLFOutput() {        
          ClsTestUtility testIndicatorUtil = new ClsTestUtility(); 
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
          String projectId = testIndicatorUtil.getProjectForOrgId(OrgUnitId);          
          String lfGoalId = testIndicatorUtil.getLFGoalForProjectId(projectId);
          String lfPurposeId = testIndicatorUtil.getLFPurposeForGoal(lfGoalId);
          //String lfSubPurposeId = testIndicatorUtil.getLFSubPurpose(lfPurposeId);
          testIndicatorUtil.updateProjectForOrgId(OrgUnitId);
          testIndicatorUtil.updateLFGoalForProjectId(projectId);
          
                    
          String lfOutputId = testIndicatorUtil.getLFOutputP(lfPurposeId);
         // String lfOutputId1 = testIndicatorUtil.getLFOutput(lfSubPurposeId);
         // String lfInputId = testIndicatorUtil.getLFInput(lfOutputId);
         // String lfInputId1 = testIndicatorUtil.getLFInput(lfOutputId1);
         // testIndicatorUtil.updateProjectForOrgId(OrgUnitId);
         // testIndicatorUtil.updateLFGoalForProjectId(projectId);
          
           
          System.Test.startTest();
          
          OrgUnit_Indicator__c masterInd = testIndicatorUtil.getCustomIndicatorRecordForOrgId(OrgUnitId);
          OrgUnit_Indicator__c childInd = testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,lfOutputId,'LFOutput');
          List<LF_Reporting_Period__c> lfRPList = testIndicatorUtil.getLFReportingPeriods(lfOutputId,'Output');
          LF_Reporting_Period__c lfRP = lfRPList[0];
          LF_Indicator_Result__c irId = testIndicatorUtil.getLFIndicatorResultByLFElement(lfRP.Id,masterInd.Id,childInd.Id,lfOutputId,'Output');  
              
          ApexPages.currentPage().getParameters().put('id', masterInd.Id);  
          ApexPages.StandardController sc5 = new ApexPages.StandardController(masterInd);          
          ClsIndicatorFactSheetControllerExt CLF = new ClsIndicatorFactSheetControllerExt(sc5);
          
        //  upsert irId;
        //  upsert lfRP;
          upsert childInd;
          
        //  delete irId;
        //  delete lfRP;
          delete childInd;
          
          System.Test.stopTest();
      
     }
     
     @IsTest public static void testClsIndicatorFactSheetControllerExtLFInput() {        
          ClsTestUtility testIndicatorUtil = new ClsTestUtility(); 
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
          String projectId = testIndicatorUtil.getProjectForOrgId(OrgUnitId);          
          String lfGoalId = testIndicatorUtil.getLFGoalForProjectId(projectId);
          String lfPurposeId = testIndicatorUtil.getLFPurposeForGoal(lfGoalId);
         // String lfSubPurposeId = testIndicatorUtil.getLFSubPurpose(lfPurposeId);          
          String lfOutputId = testIndicatorUtil.getLFOutputP(lfPurposeId);
         // String lfOutputId1 = testIndicatorUtil.getLFOutput(lfSubPurposeId);
          testIndicatorUtil.updateProjectForOrgId(OrgUnitId);
          testIndicatorUtil.updateLFGoalForProjectId(projectId);
          
          
          String lfInputId = testIndicatorUtil.getLFInput(lfOutputId);
         // String lfInputId1 = testIndicatorUtil.getLFInput(lfOutputId1);
         // testIndicatorUtil.updateProjectForOrgId(OrgUnitId);
         // testIndicatorUtil.updateLFGoalForProjectId(projectId);
          
           
          System.Test.startTest();
          
          OrgUnit_Indicator__c masterInd = testIndicatorUtil.getCustomIndicatorRecordForOrgId(OrgUnitId);
          OrgUnit_Indicator__c childInd = testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,lfInputId,'LFInput');
          List<LF_Reporting_Period__c> lfRPList = testIndicatorUtil.getLFReportingPeriods(lfInputId,'Input');
          LF_Reporting_Period__c lfRP = lfRPList[0];
          LF_Indicator_Result__c irId = testIndicatorUtil.getLFIndicatorResultByLFElement(lfRP.Id,masterInd.Id,childInd.Id,lfInputId,'Input');  
              
          ApexPages.currentPage().getParameters().put('id', masterInd.Id);  
          ApexPages.StandardController sc5 = new ApexPages.StandardController(masterInd);          
          ClsIndicatorFactSheetControllerExt CLF = new ClsIndicatorFactSheetControllerExt(sc5);
          
        //  upsert irId;
        //  upsert lfRP;
          upsert childInd;
          
        //  delete irId;
        //  delete lfRP;
          delete childInd;
          
          System.Test.stopTest();
      
     }
     
     
     
     
     @IsTest public static void testClsIndicatorFactSheetControllerExtRFGoal() {
        //  clsReportingPeriod CRP = new clsReportingPeriod();
          ClsTestUtility testIndicatorUtil = new ClsTestUtility(); 
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
          CDCSGoal__c goal = testIndicatorUtil.getRFGoalRecordForOrgId(OrgUnitId);
        //  Do__c doo = testIndicatorUtil.getRFDORecordForRFGoal(goal.Id); 
        //  IR__c irr = testIndicatorUtil.getRFIRRecordForRFDo(doo.Id);
        //  Sub_IR__c sir = testIndicatorUtil.getRFSIRRecordForRFIR(irr.Id);
          testIndicatorUtil.updateRFGoalForOrgId(OrgUnitId);
          
          OrgUnit_Indicator__c masterInd = testIndicatorUtil.getCustomIndicatorRecordForOrgId(OrgUnitId);
          OrgUnit_Indicator__c childInd = testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,goal.Id,'RFGoal');
          List<RF_Reporting_Period__c> rfRPList = testIndicatorUtil.getRFReportingPeriods(goal.Id,'Goal');
          RF_Reporting_Period__c rfRP = rfRPList[0];
          RF_Indicator_Result__c irId = testIndicatorUtil.getRFIndicatorResultRecordByRFGoal(rfRP.Id,masterInd.Id,childInd.Id,goal.Id);
          
          ApexPages.currentPage().getParameters().put('id', masterInd.Id);  
          ApexPages.StandardController sc5 = new ApexPages.StandardController(masterInd);          
          ClsIndicatorFactSheetControllerExt CLF = new ClsIndicatorFactSheetControllerExt(sc5); 
          
        //  upsert irId;
        //  upsert rfRP;
          upsert childInd;
          
        //  delete irId;
        //  delete rfRP;
          delete childInd;
     }
     
     @IsTest public static void testClsIndicatorFactSheetControllerExtRFDo() {
        //  clsReportingPeriod CRP = new clsReportingPeriod();
          ClsTestUtility testIndicatorUtil = new ClsTestUtility(); 
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
          CDCSGoal__c goal = testIndicatorUtil.getRFGoalRecordForOrgId(OrgUnitId);
          testIndicatorUtil.updateRFGoalForOrgId(OrgUnitId);
          Do__c doo = testIndicatorUtil.getRFDORecordForRFGoal(goal.Id); 
       //   IR__c irr = testIndicatorUtil.getRFIRRecordForRFDo(doo.Id);
       //   Sub_IR__c sir = testIndicatorUtil.getRFSIRRecordForRFIR(irr.Id);
          
          
          OrgUnit_Indicator__c masterInd = testIndicatorUtil.getCustomIndicatorRecordForOrgId(OrgUnitId);
          OrgUnit_Indicator__c childInd = testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,doo.Id,'RFDO');
          List<RF_Reporting_Period__c> rfRPList = testIndicatorUtil.getRFReportingPeriods(doo.Id,'DO');
          RF_Reporting_Period__c rfRP = rfRPList[0];
          RF_Indicator_Result__c irId = testIndicatorUtil.getRFIndicatorResultByRFElement(rfRP.Id,masterInd.Id,childInd.Id,doo.Id,'DO');
          
          ApexPages.currentPage().getParameters().put('id', masterInd.Id);  
          ApexPages.StandardController sc5 = new ApexPages.StandardController(masterInd);          
          ClsIndicatorFactSheetControllerExt CLF = new ClsIndicatorFactSheetControllerExt(sc5); 
          
        //  upsert irId;
        //  upsert rfRP;
          upsert childInd;
          
        //  delete irId;
        //  delete rfRP;
          delete childInd;
     }
     
     @IsTest public static void testClsIndicatorFactSheetControllerExtRFIR() {
        //  clsReportingPeriod CRP = new clsReportingPeriod();
          ClsTestUtility testIndicatorUtil = new ClsTestUtility(); 
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
          CDCSGoal__c goal = testIndicatorUtil.getRFGoalRecordForOrgId(OrgUnitId);
          Do__c doo = testIndicatorUtil.getRFDORecordForRFGoal(goal.Id);
          testIndicatorUtil.updateRFGoalForOrgId(OrgUnitId);           
          IR__c irr = testIndicatorUtil.getRFIRRecordForRFDo(doo.Id);
       //   Sub_IR__c sir = testIndicatorUtil.getRFSIRRecordForRFIR(irr.Id);
          
          
          OrgUnit_Indicator__c masterInd = testIndicatorUtil.getCustomIndicatorRecordForOrgId(OrgUnitId);
          OrgUnit_Indicator__c childInd = testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,irr.Id,'RFIR');
          List<RF_Reporting_Period__c> rfRPList = testIndicatorUtil.getRFReportingPeriods(irr.Id,'IR');
          RF_Reporting_Period__c rfRP = rfRPList[0];
          RF_Indicator_Result__c irId = testIndicatorUtil.getRFIndicatorResultByRFElement(rfRP.Id,masterInd.Id,childInd.Id,irr.Id,'IR');
          
          ApexPages.currentPage().getParameters().put('id', masterInd.Id);  
          ApexPages.StandardController sc5 = new ApexPages.StandardController(masterInd);          
          ClsIndicatorFactSheetControllerExt CLF = new ClsIndicatorFactSheetControllerExt(sc5); 
          
         // upsert irId;
         // upsert rfRP;
         System.Test.startTest();
          upsert childInd;
          
        //  delete irId;
        //  delete rfRP;
          delete childInd;
          System.Test.stopTest();
     }
     
     @IsTest public static void testClsIndicatorFactSheetControllerExtRFSIR() {
        //  clsReportingPeriod CRP = new clsReportingPeriod();
          ClsTestUtility testIndicatorUtil = new ClsTestUtility(); 
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
          CDCSGoal__c goal = testIndicatorUtil.getRFGoalRecordForOrgId(OrgUnitId);
          Do__c doo = testIndicatorUtil.getRFDORecordForRFGoal(goal.Id);
          IR__c irr = testIndicatorUtil.getRFIRRecordForRFDo(doo.Id);
          testIndicatorUtil.updateRFGoalForOrgId(OrgUnitId);          
          Sub_IR__c sir = testIndicatorUtil.getRFSIRRecordForRFIR(irr.Id);
          
          
          OrgUnit_Indicator__c masterInd = testIndicatorUtil.getCustomIndicatorRecordForOrgId(OrgUnitId);
          OrgUnit_Indicator__c childInd = testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,sir.Id,'RFSIR');
          List<RF_Reporting_Period__c> rfRPList = testIndicatorUtil.getRFReportingPeriods(sir.Id,'SIR');
          RF_Reporting_Period__c rfRP = rfRPList[0];
          RF_Indicator_Result__c irId = testIndicatorUtil.getRFIndicatorResultByRFElement(rfRP.Id,masterInd.Id,childInd.Id,sir.Id,'SIR');
          
          ApexPages.currentPage().getParameters().put('id', masterInd.Id);  
          ApexPages.StandardController sc5 = new ApexPages.StandardController(masterInd);          
          ClsIndicatorFactSheetControllerExt CLF = new ClsIndicatorFactSheetControllerExt(sc5); 
          
        //  upsert irId;
        //  upsert rfRP;
          System.Test.startTest();
          upsert childInd;
          
        //  delete irId;
        //  delete rfRP;
          delete childInd;
          System.Test.stopTest();
          
     }
     
     @IsTest public static void testClsIndicatorFactSheetControllerExtIM() {
          ClsTestUtility testIndicatorUtil = new ClsTestUtility();  
          
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());          
         // String imId = testIndicatorUtil.getIMForOrgId(OrgUnitId);
         // testIndicatorUtil.updateIMForOrgId(OrgUnitId,'Annual','Implementing Mechanism');
          ApplicationConstants.bypassIMCreateVendorTriggerLogic = true;          
          ApplicationConstants.bypassReportingPeriodApprovalLogic = true;
          ApplicationConstants.bypassOrgUnitIndicatorUpsertShare = true;
          Implementing_Mechanism__c im = testIndicatorUtil.insertIMForOrgId(OrgUnitId,'Annual', 'Implementing Mechanism');
          
          List<Reporting_Period__c> rpList =  testIndicatorUtil.getReportingPeriods(im.Id);
         // String etId = testIndicatorUtil.getEmailTemplateId('ReportingPeriodPublishReminder');  
         
          OrgUnit_Indicator__c masterInd = testIndicatorUtil.getCustomIndicatorRecordForOrgId(OrgUnitId);
          OrgUnit_Indicator__c childInd = testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,im.Id,'IM',masterInd.Id);        
          
          List<Indicator_Results__c> irList;
          List<Reporting_Period__c> rpList1;
          Reporting_Period__c rp = new Reporting_Period__c();
          Indicator_Results__c ir = new Indicator_Results__c();
          //rpList1.add(rpList[0]);
          System.Test.startTest();
          
          irList = testIndicatorUtil.getIndicatorResultByIM(rpList,masterInd.Id,childInd.Id,im.Id);     
         // rpList1 =  testIndicatorUtil.getReportingPeriods(imId,rpList,'Open');
          ir = irList[0];
          rp = rpList[0];
          ApexPages.currentPage().getParameters().put('id', masterInd.Id);  
          ApexPages.StandardController sc5 = new ApexPages.StandardController(masterInd);          
          ClsIndicatorFactSheetControllerExt CLF = new ClsIndicatorFactSheetControllerExt(sc5);
          upsert childInd;
          
          ApplicationConstants.bypassIMCreateVendorTriggerLogic = true;
          ApplicationConstants.bypassIMSharingRulesTriggerLogic = true;
          ApplicationConstants.bypassReportingPeriodApprovalLogic = true;
          delete ir;
          delete rp;
          delete childInd;
          
          System.Test.stopTest();         
          
          
     } 
     
    
}