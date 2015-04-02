public with sharing class ClsIMIndicatorsResultsReport {


 public string OrgUnit {get;set;}
 public string orgId;
 

 
 List<Indicator_Results__c> iResultsList = new list<Indicator_Results__c>();
 Public Map<string,list<Indicator_Results__c>> iResultMap {get;set;}
 Public Map<string,list<Indicator_Results__c>> iResultMap1 {get;set;}
 Public List<DO__c> doList {get;set;}
 Public List<doListClass> dl {get;set;}
 Public List<Portfolio_RF_Linkage__c> doProjectList{get;set;}
 Public Map<string,list<Portfolio_RF_Linkage__c>> doProjectMap {get;set;}
 public Map<String,TreeNode> recMap{get;set;}
 Public Map<string,DO__c> doMap{get;set;}
 public set<string> doSet{get;set;}
 Public set<string> doSet1{get;set;}
 set<string> projSet = new set<string>();
 set<string> imSet = new set<string>();
 Public Map<string,list<Public_IM_Link__c>> ProjectImMap {get;set;}
 List<Public_IM_Link__c> ProjectImList = new list<Public_IM_Link__c>();
 
 public ClsIMIndicatorsResultsReport(){
  dl = new list<doListClass>();
  doList = new list<DO__c>();
  doSet = new Set<string>();
  doMap =  new Map<string,DO__c>();
  doProjectList = new list<Portfolio_RF_Linkage__c>();
  doProjectMap = new Map<string,list<Portfolio_RF_Linkage__c>>();
  ProjectImMap = new Map<string,list<Public_IM_Link__c>>();
  iResultMap = new Map<string,list<Indicator_Results__c>>();
  iResultMap1 = new Map<string,list<Indicator_Results__c>>();
  recMap = new Map<String,TreeNode>();
  doSet1 = new set<string>();
  String uRoleId = UserInfo.getUserRoleId();
  UserRole ur = [Select Name From UserRole where Id = :uRoleId];
  String orgUnitName;
    if (((String)ur.Name).contains(' | ')){
            orgUnitName = ((String)ur.Name).split(' | ')[0];
        } else {
            orgUnitName = 'Root';
    }
    
   if (orgUnitName.equalsIgnoreCase('Root')){
        iResultsList =  [Select ouId__c, ouCode__c, Variance__c, Target__c, Reporting_Period_Name__c, Reporting_Period_Id__c, RecordTypeId,
                     Organization_Indicator_Id__c, Name, Indicator_Name__c, Indicator_Code__c, Implementing_Mechanism_Id__c, ImpMech_Number__c, 
                     ImpMech_Name__c, Id, Fiscal_Year__c, Fiscal_Period__c, Baseline__c, Actual__c, Activity_Name__c, Activity_Id__c 
                     From Indicator_Results__c where Implementing_Mechanism_Id__c != '' AND Organization_Indicator_Master_Id__r.PPR__c = true];
                     
        doList = [Select ouName__c, ouId__c, ouCode__c, Unique_Name__c, Name, Id, Goal_Name__c, DO_Title__c, DO_Overview__c, 
              DO_Name__c, DO_Id__c, DO_Code__c, CDCS_Goal__c From DO__c order by DO_Name__c ];
    } else {
        OrgUnit__c ou = [Select Id, ouCode__c From OrgUnit__c where ouCode__c = :orgUnitName.trim()];
        orgId = ou.Id;
        orgId = orgId.left(15);
        system.debug('Org Id::;'+orgId);
        iResultsList =  [Select ouId__c, ouCode__c, Variance__c, Target__c, Reporting_Period_Name__c, Reporting_Period_Id__c, RecordTypeId,
                     Organization_Indicator_Id__c, Name, Indicator_Name__c, Indicator_Code__c, Implementing_Mechanism_Id__c, ImpMech_Number__c, 
                     ImpMech_Name__c, Id, Fiscal_Year__c, Fiscal_Period__c, Baseline__c, Actual__c, Activity_Name__c, Activity_Id__c 
                     From Indicator_Results__c where ouId__c =: orgId AND Implementing_Mechanism_Id__c != '' AND Organization_Indicator_Master_Id__r.PPR__c = true];
                     
        doList = [Select ouName__c, ouId__c, ouCode__c, Unique_Name__c, Name, Id, Goal_Name__c, DO_Title__c, DO_Overview__c, 
              DO_Name__c, DO_Id__c, DO_Code__c, CDCS_Goal__c From DO__c where ouId__c =: orgId order by DO_Name__c ];
        
    }
    
     for(Indicator_Results__c i : iResultsList){
         List<Indicator_Results__c> tempList = new List<Indicator_Results__c>();
         if (iResultMap.containsKey(i.Implementing_Mechanism_Id__c)){
            tempList = iResultMap.get(i.Implementing_Mechanism_Id__c);
         }
         tempList.add(i);
         iResultMap.put(i.Implementing_Mechanism_Id__c, tempList); 
         imSet.add(i.Implementing_Mechanism_Id__c);
     }
     
    //doList = [Select ouName__c, ouId__c, ouCode__c, Unique_Name__c, Name, Id, Goal_Name__c, DO_Title__c, DO_Overview__c, 
    //        DO_Name__c, DO_Id__c, DO_Code__c, CDCS_Goal__c From DO__c where ouId__c =: orgId order by DO_Name__c ];
              
    for(DO__c dl : doList){
        doMap.put(dl.Id, dl); 
        doSet.add(dl.Id);
    }
          
    doProjectList = [Select Project_Name__c, Project_Id__c, Project_Code__c, Do_Name__c, DO_Id__c, DO_Code__c,
                     SIR_Name__c, SIR_Id__c, IR_Name__c, SIR_Code__c, IR_Id__c, IR_Code__c 
                     From Portfolio_RF_Linkage__c where DO_Id__c IN :doSet];
     
   for(Portfolio_RF_Linkage__c pl : doProjectList){
        List<Portfolio_RF_Linkage__c> tempList1 = new List<Portfolio_RF_Linkage__c>();
        
            if(doProjectMap.containsKey(pl.DO_Id__c)){
                tempList1 = doProjectMap.get(pl.DO_Id__c);  
            }
        tempList1.add(pl);
        doProjectMap.put(pl.DO_Id__c, tempList1);
        projSet.add(pl.Project_Id__c);
    }         
    
    ProjectImList = [Select ouName__c, Project_Type__c, Project_Name__c, Project_Code__c, Office_Name__c, Name, 
                     Mission_Name__c, Implementing_Mechanism_Number__c, ImpMech_Name__c, Id, External_MissionName__c, 
                     Award_Amount__c, Allocation_of_IM_Funding_to_Project__c, Activity_Name__c, Activity_Code__c 
                     From Public_IM_Link__c where Project_Code__c IN :projSet]; 
                          
    
    for(Public_IM_Link__c pm : ProjectImList){
        List<Public_IM_Link__c> tempList2 = new List<Public_IM_Link__c>();
            
            if(ProjectImMap.containsKey(pm.Project_Code__c)){
                tempList2 = ProjectImMap.get(pm.Project_Code__c);   
            }
        tempList2.add(pm);
        ProjectImMap.put(pm.Project_Code__c, tempList2);
    }
    
    
    system.debug('DO List::::'+doList);
    system.debug('DO Map::::'+doMap);   
    system.debug('DO-PROJ Map::::'+doProjectMap);
    system.debug('PROJ-IM Map::::'+ProjectImMap);
    system.debug('IM IResult Map::::'+iResultMap);
    
    for(String dId: doSet){
        if (doProjectMap.containsKey(dId)){             
            for(Portfolio_RF_Linkage__c rfLink: doProjectMap.get(dId))  {
                if(ProjectImMap.containsKey(rfLink.Project_Id__c)){
                    for(Public_IM_Link__c pLink: ProjectImMap.get(rfLink.Project_Id__c)){
                        if(iResultMap.containsKey(pLink.Implementing_Mechanism_Number__c)){
                            recMap.put(dId, new TreeNode(dId,rfLink.Do_Name__c, true));
                            recMap.put(rfLink.Project_Id__c, new TreeNode(rfLink.Project_Id__c,rfLink.Project_Name__c, true));
                            recMap.put(pLink.Implementing_Mechanism_Number__c, new TreeNode(pLink.Implementing_Mechanism_Number__c,pLink.ImpMech_Name__c, true));
                        } else {
                            recMap.put(dId, new TreeNode(dId,rfLink.Do_Name__c, false));
                            recMap.put(rfLink.Project_Id__c, new TreeNode(rfLink.Project_Id__c,rfLink.Project_Name__c, false));
                            recMap.put(pLink.Implementing_Mechanism_Number__c, new TreeNode(pLink.Implementing_Mechanism_Number__c,pLink.ImpMech_Name__c, false));
                        } 
                    }
                } else {
                    recMap.put(dId, new TreeNode(dId,rfLink.Do_Name__c, false));
                    recMap.put(rfLink.Project_Id__c, new TreeNode(rfLink.Project_Id__c,rfLink.Project_Name__c, false));
                }               
            }           
        } else {
            recMap.put(dId, new TreeNode(dId,'', false));           
        }
        
        
    }
    
    for(DO__c dId: doList){
        List<ResultsClass> RclassList = new List<ResultsClass>();
        if (doProjectMap.containsKey(dId.Id)){          
            for(Portfolio_RF_Linkage__c rfLink: doProjectMap.get(dId.Id))   {
                if(ProjectImMap.containsKey(rfLink.Project_Id__c)){
                    for(Public_IM_Link__c pLink: ProjectImMap.get(rfLink.Project_Id__c)){
                        if(iResultMap.containsKey(pLink.Implementing_Mechanism_Number__c)){
                            for(Indicator_Results__c iRes: iResultMap.get(pLink.Implementing_Mechanism_Number__c)){
                                RclassList.add(new ResultsClass(iRes.Indicator_Code__c, iRes.Indicator_Name__c, rfLink.IR_Name__c, rfLink.SIR_Name__c, iRes.ImpMech_Name__c, pLink.Project_Name__c, iRes.Reporting_Period_Name__c, iRes.Baseline__c, iRes.Target__c, iRes.Actual__c));  
                            }
                                
                        } 
                    }
                }               
            }           
        } 
        system.debug('RclassList:::'+RclassList);
        system.debug('RclassList:::'+RclassList.size());
        if(RclassList.size()>0){
            doListClass dClass = new doListClass(dId.DO_Id__c, dId.DO_Name__c, RclassList);
            dl.add(dClass);
        }
        
    }
        
 }
 
 
    public class TreeNode{
        public String nodeId{get; set;}
        public String nodeName{get;set;}        
        public Boolean hasChildren{get;set;}
        
        /* Default Constructor of the calss TreeNode */
        public TreeNode(string nId, string nName, Boolean nChild ){        
            nodeId = nId;
            nodeName = nName;
            this.hasChildren = nChild;
        }        
        
        /* End of Default constructor of the calss TreeNode */
    }
    
        public class doListClass{
         public String doId{get; set;}
         public String doName{get;set;}        
         public List<ResultsClass> RclassList{get;set;}
        
        /* Default Constructor of the calss doListClass */
            public doListClass(string dId, string dName, List<ResultsClass> rList ){        
                this.doId = dId;
                this.doName = dName;
                this.RclassList = rList;
            }        
        
        /* End of Default constructor of the calss doListClass */
        }
        
        public class ResultsClass{
         public String indId{get; set;}
        public String indName{get;set;}   
        public String irName{get;set;}
        public String sirName{get;set;}
        public String imName{get;set;} 
        public String projName{get;set;} 
        public String rPeriod{get;set;} 
        public Decimal baseline{get;set;} 
        public Decimal target{get;set;} 
        public Decimal actual{get;set;}      
                
        /* Default Constructor of the calss ResultsClass */
            public ResultsClass(string indId1, string indName1, string irName1, string sirName1, string imName1,string projName1, string rPeriod1, Decimal baseline1, Decimal target1, Decimal actual1){        
                this.indId = indId1;
                this.indName = indName1;
                this.irName = irName1;
                this.sirName = sirName1;
                this.imName = imName1;
                this.projName = projName1;
                this.rPeriod = rPeriod1;
                this.baseline = baseline1;
                this.target = target1;
                this.actual = actual1;
            }        
        
        /* End of Default constructor of the calss ResultsClass */
        }
 
      @isTest

    public static void testIMIndicatorResultsReport(){
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();  
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId()); 
          Project__c proj = testIndicatorUtil.getProjectRecordForOrgId(OrgUnitId);
          CDCSGoal__c goal = testIndicatorUtil.getRFGoalRecordForOrgId(OrgUnitId);
          Do__c doo = testIndicatorUtil.getRFDORecordForRFGoal(goal.Id); 
          IR__c irr = testIndicatorUtil.getRFIRRecordForRFDo(doo.Id);
          Sub_IR__c sir = testIndicatorUtil.getRFSIRRecordForRFIR(irr.Id);
          ApplicationConstants.bypassIMCreateVendorTriggerLogic = true;          
          ApplicationConstants.bypassReportingPeriodApprovalLogic = true;
          ApplicationConstants.bypassOrgUnitIndicatorUpsertShare = true;
          Implementing_Mechanism__c im = testIndicatorUtil.insertIMForOrgId(OrgUnitId,'Quarterly', 'Implementing Mechanism');
          Public_IM_Link__c pmi = new Public_IM_Link__c(Implementing_Mechanism_Number__c = im.Id, Project_Code__c=proj.id);
          insert pmi;
          Portfolio_RF_Linkage__c pRFlink = new Portfolio_RF_Linkage__c(Project_Id__c = proj.id,DO_Id__c=doo.Id,IR_Id__c=irr.Id);
          insert pRFlink; 
           
          
                
          System.Test.startTest();
          List<Reporting_Period__c> rpList =  testIndicatorUtil.getReportingPeriods(im.Id);     
         
          OrgUnit_Indicator__c masterInd = testIndicatorUtil.getCustomIndicatorRecordForOrgId(OrgUnitId,true);
          OrgUnit_Indicator__c childInd = testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,im.Id,'IM',masterInd.Id);
          List<Indicator_Results__c> irList = testIndicatorUtil.getIndicatorResultByIM(rpList,masterInd.Id,childInd.Id,im.Id); 
                 
          
          PageReference pageRef = Page.vfIMIndicatorsResultsReport;
          System.Test.setCurrentPage(pageRef);
          
         // System.runAs(testIndicatorUtil.missionPilotUser){
              
            ClsIMIndicatorsResultsReport a = new ClsIMIndicatorsResultsReport();
          
         // }
          System.Test.stopTest();
        
        
    
    } 

     
}