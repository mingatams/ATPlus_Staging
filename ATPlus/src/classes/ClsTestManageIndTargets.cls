@IsTest
public with sharing class ClsTestManageIndTargets  {
  
 
 
 public static testMethod void testManageIndTargetsIMR(){
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());       
        //Implementing_Mechanism__c IMId= testIndicatorUtil.getIMRecordForOrgId(OrgUnitId);
        //testIndicatorUtil.updateIMForOrgId(orgUnitId,'Annual','Implementing Mechanism'); 
         ApplicationConstants.bypassIMCreateVendorTriggerLogic = true;          
          ApplicationConstants.bypassReportingPeriodApprovalLogic = true;
          Implementing_Mechanism__c imid = testIndicatorUtil.insertIMForOrgId(OrgUnitId,'Annual', 'Implementing Mechanism');       
        List<Reporting_Period__c> rpList = testIndicatorUtil.getReportingPeriods(IMId.Id,'IM');
        List<OrgUnit_Indicator__c> masterList = testIndicatorUtil.getCustomIndicatorRecordsForOrgId(OrgUnitId);
        List<OrgUnit_Indicator__c> childInd = testIndicatorUtil.getCustomIndicatorsForType(OrgUnitId,imId.Id,'IM',masterList); 
        List<Indicator_Results__c> irList = testIndicatorUtil.getIndicatorResultByIM(rpList,childInd,imId.Id);
        Reporting_Period__c rp = rpList[0];        
        system.debug('Reporting Period From test method:::'+rp);
        String changedIds;
        List<Indicator_Results__c> irUpdList = new List<Indicator_Results__c>();
        String IndicatorId;
        String subIndicatorId;
       // List<Indicator_Results__c> irUpdList = new List<Indicator_Results__c>();
        Indicator_Results__c cIr = new Indicator_Results__c();
        for(Indicator_Results__c ir: irList){
            if (ir.Reporting_Period_Id__c == rp.Id){
               // ir.baseline__c = '100.00';
                irUpdList.add(ir);
                if (changedIds != null){                    
                    subIndicatorId = ir.Organization_Indicator_Id__c;
                    changedIds = changedIds + ',' + ir.Organization_Indicator_Id__c;
                } else {                    
                    IndicatorId = ir.Organization_Indicator_Id__c;
                    changedIds = ir.Organization_Indicator_Id__c;
                }
            }        
            
        }
        
        System.Test.startTest();
        System.Test.setCurrentPage(new PAgereference('/apex/vfIMIndicatorResultsPage'));
        ApexPages.currentPage().getParameters().put('id',IMId.Id); 
        ApexPages.currentPage().getParameters().put('Lid',rp.Id);
        ClsManageIndicatorTargets controller = new  ClsManageIndicatorTargets();        
        controller.getPeriods();
        controller.selectedPeriodName =rp.Name;
        controller.changedRowIds = changedIds;
        controller.xmlStr = '<?xml version="1.0" encoding="UTF-8"?><rows id="0"><row id="'+IndicatorId +'"><cell image="indicator.png"Id="1-Z1">&amp;nbsp&amp;nbsp&amp;nbsp1-Z1</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">100.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">200.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">300.00</cell><cell>100.00</cell><cell>&lt;img src="/resource/varianceImages/arrow-up.png" alt="Up Arrow" height="15" width="15" border="0"/&gt;</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell>1</cell><cell>Numeric</cell><cell></cell><cell></cell><cell></cell><row id="'+subIndicatorId +'"><cell image="sub-indicator.png" Id="1-Z12">&amp;nbsp&amp;nbsp&amp;nbsp1-Z12</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">100.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">200.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">300.00</cell><cell>100.00</cell><cell>&lt;img src="/resource/varianceImages/arrow-up.png" alt="Up Arrow" height="15" width="15" border="0"/&gt;</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell>1</cell><cell>Numeric</cell><cell></cell><cell></cell><cell></cell></row></row></rows>';        
        controller.doSaveTargets();
       // controller.changeToOpen();
       // controller.changeToClose();
        controller.cancel();
        controller.cancelGo();
        controller.CancelNGo();
        controller.cancelSave();
        System.Test.stopTest();   
        
        //upsert irUpdList;
        
        
    }  

    
     public static testMethod void testManageIndTargetsIMTask(){
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());       
       // Implementing_Mechanism__c IMId= testIndicatorUtil.getIMRecordForOrgId(OrgUnitId);  
        //ApplicationConstants.bypassIMCreateVendorTriggerLogic = true; 
        ApplicationConstants.bypassIMCreateVendorTriggerLogic = true;          
          ApplicationConstants.bypassReportingPeriodApprovalLogic = true;  
          ApplicationConstants.bypassOrgUnitIndicatorUpsertShare = true;
        Implementing_Mechanism__c imId = testIndicatorUtil.insertIMForOrgId(OrgUnitId,'Annual', 'Task');
        Project__c imProj = testIndicatorUtil.getIMProjectRecordForOrgId(OrgUnitId);         
        
       // testIndicatorUtil.updateIMForOrgId(orgUnitId,'Annual','Task');      
        Activity__c act = testIndicatorUtil.getTaskRecordForIMAndProject(IMId.Id,imProj.Id);
        
        List<Reporting_Period__c> rpList = testIndicatorUtil.getReportingPeriods(ImId.Id,'Task');
        System.debug('Task Reporting Periods ::' +rpList);
        List<OrgUnit_Indicator__c> masterList = testIndicatorUtil.getCustomIndicatorRecordsForOrgId(OrgUnitId);
        List<OrgUnit_Indicator__c> childInd = testIndicatorUtil.getCustomIndicatorsForType(OrgUnitId,imId.Id,'IM',masterList); 
        List<Indicator_Results__c> irList = testIndicatorUtil.getIndicatorResultByIM(rpList,childInd,imId.Id);
        Reporting_Period__c rp = rpList[0];        
        system.debug('Reporting Period From test method:::'+rp);
        String changedIds;
        String IndicatorId;
        String subIndicatorId;
        for(Indicator_Results__c ir: irList){
            if (ir.Reporting_Period_Id__c == rp.Id){
                if (changedIds != null){
                    subIndicatorId = ir.Organization_Indicator_Id__c;
                    changedIds = changedIds + ',' + ir.Organization_Indicator_Id__c;
                } else {
                    IndicatorId = ir.Organization_Indicator_Id__c;
                    changedIds = ir.Organization_Indicator_Id__c;
                }
            }        
            
        }
        System.Test.startTest();
        ApplicationConstants.bypassIMCreateVendorTriggerLogic = true;          
          ApplicationConstants.bypassReportingPeriodApprovalLogic = true;
        System.Test.setCurrentPage(new PAgereference('/apex/vfIMIndicatorResultsPage'));
        ApexPages.currentPage().getParameters().put('id',IMId.Id); 
        ApexPages.currentPage().getParameters().put('Lid',rp.Id);
        ApexPages.currentPage().getParameters().put('actId',act.Id);
        ClsManageIndicatorTargets controller = new  ClsManageIndicatorTargets(rp);
        controller.getPeriods();
        controller.selectedPeriodName =rp.Name;
        controller.getTasksForIM();
        controller.changedRowIds = changedIds;
        controller.xmlStr = '<?xml version="1.0" encoding="UTF-8"?><rows id="0"><row id="'+IndicatorId +'"><cell image="indicator.png"Id="1-Z1">&amp;nbsp&amp;nbsp&amp;nbsp1-Z1</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">100.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">200.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">300.00</cell><cell>100.00</cell><cell>&lt;img src="/resource/varianceImages/arrow-up.png" alt="Up Arrow" height="15" width="15" border="0"/&gt;</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell>1</cell><cell>Numeric</cell><cell></cell><cell></cell><cell></cell><row id="'+subIndicatorId +'"><cell image="sub-indicator.png" Id="1-Z12">&amp;nbsp&amp;nbsp&amp;nbsp1-Z12</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">100.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">200.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">300.00</cell><cell>100.00</cell><cell>&lt;img src="/resource/varianceImages/arrow-up.png" alt="Up Arrow" height="15" width="15" border="0"/&gt;</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell>1</cell><cell>Numeric</cell><cell></cell><cell></cell><cell></cell></row></row></rows>';
        controller.doSaveTargets();
        System.Test.stopTest();        
        
        
        
    
    }   
    
    public static testMethod void testManageIndTargetsRFGoal(){
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        CDCSGoal__c rGoal = testIndicatorUtil.getRFGoalRecordForOrgId(OrgUnitId);
        testIndicatorUtil.updateRFGoalForOrgId(OrgUnitId);
        
        List<RF_REporting_Period__c> rpList = testIndicatorUtil.getRFReportingPeriods(rGoal.Id,'Goal');
        List<OrgUnit_Indicator__c> masterList = testIndicatorUtil.getCustomIndicatorRecordsForOrgId(OrgUnitId);
        List<OrgUnit_Indicator__c> childList = testIndicatorUtil.getCustomIndicatorsForType(OrgUnitId,rGoal.Id,'RFGoal',masterList);
        system.debug('Org Indicators for RF Goal::' +childList);
        List<RF_Indicator_Result__c> rirList = testIndicatorUtil.getRFIndicatorResultByRFElement(rpList, childList,rGoal.Id , 'Goal'); 
        system.debug('RF Indicator REsults::' +rirList);
        
        RF_Reporting_Period__c rp = rpList[0];        
        system.debug('Reporting Period From test method:::'+rp);
        String changedIds;
        String IndicatorId;
        String subIndicatorId;
        for(RF_Indicator_Result__c ir: rirList){
            if (ir.RF_Reporting_Period_Id__c == rp.Id){
                if (changedIds != null){
                    subIndicatorId = ir.Organization_Indicator_Id__c;
                    changedIds = changedIds + ',' + ir.Organization_Indicator_Id__c;
                } else {
                    IndicatorId = ir.Organization_Indicator_Id__c;
                    changedIds = ir.Organization_Indicator_Id__c;
                }
            }        
            
        }
        
        
        System.Test.startTest();
        System.Test.setCurrentPage(new PAgereference('/apex/vfRFGoalDetail'));
        ApexPages.currentPage().getParameters().put('id',rGoal.Id); 
        ApexPages.currentPage().getParameters().put('Lid',rp.Id);
        //ApexPages.currentPage().getParameters().put('actId',act.Id);
        ApexPages.StandardController thecontroller = new ApexPages.StandardController(rGoal);
        ClsManageIndicatorTargets controller = new  ClsManageIndicatorTargets(thecontroller);
        controller.changedRowIds = changedIds;
        controller.objName = 'RF_Reporting_Period__c';
        controller.xmlStr = '<?xml version="1.0" encoding="UTF-8"?><rows id="0"><row id="'+IndicatorId +'"><cell image="indicator.png"Id="1-Z1">&amp;nbsp&amp;nbsp&amp;nbsp1-Z1</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">100.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">200.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">300.00</cell><cell>100.00</cell><cell>&lt;img src="/resource/varianceImages/arrow-up.png" alt="Up Arrow" height="15" width="15" border="0"/&gt;</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell>1</cell><cell>Numeric</cell><cell></cell><cell></cell><cell></cell><row id="'+subIndicatorId +'"><cell image="sub-indicator.png" Id="1-Z12">&amp;nbsp&amp;nbsp&amp;nbsp1-Z12</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">100.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">200.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">300.00</cell><cell>100.00</cell><cell>&lt;img src="/resource/varianceImages/arrow-up.png" alt="Up Arrow" height="15" width="15" border="0"/&gt;</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell>1</cell><cell>Numeric</cell><cell></cell><cell></cell><cell></cell></row></row></rows>';
        controller.doSaveTargets();
        System.Test.stopTest();   
        
        
        System.Test.setCurrentPage(new PAgereference('/apex/vfRFGoalDetail'));
        ApexPages.currentPage().getParameters().put('id',rGoal.Id); 
        ClsManageIndicatorTargets controller1 = new  ClsManageIndicatorTargets();
        controller1.getPeriods();
        
    }
    
    
    public static testMethod void testManageIndTargetsLFGoal(){
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        Project__c proj = testIndicatorUtil.getProjectRecordForOrgId(OrgUnitId);
        LF_Goal__c lGoal = testIndicatorUtil.getLFGoalRecordForProjectId(proj.Id);
        testIndicatorUtil.updateProjectForOrgId(OrgUnitId);
        String lGoalId = testIndicatorUtil.updateLFGoalForProjectId(proj.Id);  
        
        
        List<LF_REporting_Period__c> rpList = testIndicatorUtil.getLFReportingPeriods(lGoal.Id,'Goal');
        List<OrgUnit_Indicator__c> masterList = testIndicatorUtil.getCustomIndicatorRecordsForOrgId(OrgUnitId);
        List<OrgUnit_Indicator__c> childList = testIndicatorUtil.getCustomIndicatorsForType(OrgUnitId,lGoal.Id,'LFGoal',masterList);
        system.debug('Org Indicators for LF Goal::' +childList);
        List<LF_Indicator_Result__c> lirList = testIndicatorUtil.getLFIndicatorResultByLFElement(rpList, childList,lGoal.Id , 'Goal'); 
        system.debug('LF Indicator REsults::' +lirList);
        
        LF_Reporting_Period__c rp = rpList[0];        
        system.debug('Reporting Period From test method:::'+rp);
        String changedIds;
        String IndicatorId;
        String subIndicatorId;
        for(LF_Indicator_Result__c ir: lirList){
            if (ir.LF_Reporting_Period_Id__c == rp.Id){
                if (changedIds != null){
                    subIndicatorId = ir.Organization_Indicator_Id__c;
                    changedIds = changedIds + ',' + ir.Organization_Indicator_Id__c;
                } else {
                    IndicatorId = ir.Organization_Indicator_Id__c;
                    changedIds = ir.Organization_Indicator_Id__c;
                }
            }        
            
        }
        
        
        System.Test.startTest();
        System.Test.setCurrentPage(new PAgereference('/apex/vfLFGoalDetail'));
        ApexPages.currentPage().getParameters().put('id',lGoal.Id); 
        ApexPages.currentPage().getParameters().put('Lid',rp.Id);
        //ApexPages.currentPage().getParameters().put('actId',act.Id);
        ApexPages.StandardController thecontroller = new ApexPages.StandardController(lGoal);
        ClsManageIndicatorTargets controller = new  ClsManageIndicatorTargets(thecontroller);
        controller.changedRowIds = changedIds;
        controller.objName = 'LF_Reporting_Period__c';
        controller.xmlStr = '<?xml version="1.0" encoding="UTF-8"?><rows id="0"><row id="'+IndicatorId +'"><cell image="indicator.png"Id="1-Z1">&amp;nbsp&amp;nbsp&amp;nbsp1-Z1</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">100.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">200.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">300.00</cell><cell>100.00</cell><cell>&lt;img src="/resource/varianceImages/arrow-up.png" alt="Up Arrow" height="15" width="15" border="0"/&gt;</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell>1</cell><cell>Numeric</cell><cell></cell><cell></cell><cell></cell><row id="'+subIndicatorId +'"><cell image="sub-indicator.png" Id="1-Z12">&amp;nbsp&amp;nbsp&amp;nbsp1-Z12</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">100.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">200.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">300.00</cell><cell>100.00</cell><cell>&lt;img src="/resource/varianceImages/arrow-up.png" alt="Up Arrow" height="15" width="15" border="0"/&gt;</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell>1</cell><cell>Numeric</cell><cell></cell><cell></cell><cell></cell></row></row></rows>';
        controller.doSaveTargets();
        System.Test.stopTest();
         
        System.Test.setCurrentPage(new PAgereference('/apex/vfLFGoalDetail'));
        ApexPages.currentPage().getParameters().put('id',lGoal.Id); 
        ClsManageIndicatorTargets controller1 = new  ClsManageIndicatorTargets();
        controller1.getPeriods();
        
    } 
    
  public static testMethod void testManageIndTargetsReportingPeriodChanges() {    
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        ApplicationConstants.bypassIMCreateVendorTriggerLogic = true;          
          ApplicationConstants.bypassReportingPeriodApprovalLogic = true;      
        Implementing_Mechanism__c im = testIndicatorUtil.insertIMForOrgId(OrgUnitId,'Annual', 'Implementing Mechanism');
      //  String IMId= testIndicatorUtil.getIMForOrgId(OrgUnitId);
      
      //  testIndicatorUtil.updateIMForOrgId(orgUnitId,'Annual','Implementing Mechanism');
         List<Reporting_Period__c> imReportingPeriodList = testIndicatorUtil.getReportingPeriods(IM.Id,'IM');
         List<OrgUnit_Indicator__c> masterList = testIndicatorUtil.getCustomIndicatorRecordsForOrgId(OrgUnitId);
        List<OrgUnit_Indicator__c> childInd = testIndicatorUtil.getCustomIndicatorsForType(OrgUnitId,im.Id,'IM',masterList); 
        List<Indicator_Results__c> irList = testIndicatorUtil.getIndicatorResultByIM(imReportingPeriodList,childInd,im.Id);
        Reporting_Period__c tempPeriod = new Reporting_PEriod__c();
        if(imReportingPeriodList != null && imReportingPeriodList.size()>0){
         System.Debug('Reporting Period IM ***** ' + imReportingPeriodList);
         
         for(Reporting_Period__c testReportingPeriod:imReportingPeriodList){
          tempPeriod = testReportingPeriod;
          break;
           
         } 
          tempPeriod.Results_Established__c =true;
          upsert tempPeriod;
          
         }
         ApexPages.currentPage().getParameters().put('id',IM.Id); 
         ApexPages.currentPage().getParameters().put('closedDay','2');
         ApexPages.currentPage().getParameters().put('narative','Hi World'); 
         System.Test.StartTest();
         ClsManageIndicatorTargets controller = new ClsManageIndicatorTargets();
         
         
         controller.repPeriod = tempPeriod; 
     //    controller.selectedPeriodName =tempPeriod.Name;
        controller.objName='Reporting_Period__c';
      //  controller.getPeriods();
      //  controller.getTasksForIM(); 
        controller.changeToClose();
        controller.changeToOpen();    
        controller.changeToPublish();
       // List<Reporting_Period__c> getReportingPeriods(String imId,List<Reporting_Period__c> rpList, String status)
        
        //controller.changeToOpen();
        controller.changeToSubmit();
         controller.changeToDraft();
        controller.changeToApproved();
        controller.changeToReject();
        controller.saveIMRptNarative();
    //    controller.saveIMreport();
        System.Test.StopTest();
    }
 
 
 
 /*
 Below Old Methods
 
 
 */
 
 
 
   /* public static testMethod void testManageIndTargetsIMR(){
         System.Test.StartTest();
            ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
            String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());       
            Implementing_Mechanism__c IMId= testIndicatorUtil.getIMRecordForOrgId(OrgUnitId);
            testIndicatorUtil.updateIMForOrgId(orgUnitId,'Annual','Implementing Mechanism');
            
            List<Reporting_Period__c> rpList = testIndicatorUtil.getReportingPeriods(IMId.Id);
            Reporting_Period__c rp = rpList[0];
            System.Test.setCurrentPage(new Pagereference('/apex/vfIMIndicatorResultsPage'));
            ApexPages.currentPage().getParameters().put('id',rp.Id); 
            ClsManageIndicatorTargets controller = new  ClsManageIndicatorTargets();       
            controller.changeToOpen();
            controller.changeToClose();
         System.Test.StopTest();
    }  
    
    
   
    
    
    
    public static testMethod void testManageIndTargetsIM() {    
     System.Test.StartTest();
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();
        ClsGlobalUtility GU = new ClsGlobalUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
       
        String IMId= testIndicatorUtil.getIMForOrgId(OrgUnitId);
        String projectId =  testIndicatorUtil.getProjectForOrgId(OrgUnitId);
        //String ImRecTypeId = GU.getRecordTypeId('OrgUnit_Indicator__c', 'Implementing Mechanism');
        //OrgUnit_Indicator__c ImInds = testIndicatorUtil.getCustIndicatorForRecordType(OrgUnitId,IMId,'IM',ImRecTypeId );
        Project__c  imLink=[select Id,Name from Project__c where id = :projectId ];         
        ApexPages.StandardController thecontroller = new ApexPages.StandardController(imLink);
    
        testIndicatorUtil.updateIMForOrgId(orgUnitId,'Annual','Implementing Mechanism');
        
        List<Reporting_Period__c> imReportingPeriodList = testIndicatorUtil.getReportingPeriods(IMId);
        
        ApexPages.currentPage().getParameters().put('id',IMId);  
        
        Reporting_Period__c testReport = new Reporting_Period__c();
         ClsManageIndicatorTargets controller1 = new  ClsManageIndicatorTargets(testReport ) ;
        
        ApexPages.StandardController thecontroller1 = new ApexPages.StandardController(testReport );
        ClsManageIndicatorTargets controller3 = new ClsManageIndicatorTargets (thecontroller1);
        
         ClsManageIndicatorTargets controller = new ClsManageIndicatorTargets();  
         if(imReportingPeriodList != null && imReportingPeriodList.size()>0){
         System.Debug('Reporting Period IM ***** ' + imReportingPeriodList);
         for(Reporting_Period__c testReportingPeriod:imReportingPeriodList){
         controller.repPeriod  = testReportingPeriod;
         controller.getPeriods();
         controller1.repPeriod  = testReportingPeriod; 
         controller3.repPeriod  = testReportingPeriod; 
          break;
           
         } 
         
         }
     
        controller.objName='Reporting_Period__c';
          controller.prepareTargetsXML(new ClsIndicatorWizardUtility());
        
 
         Cookie previousReportPeriodCookie = new Cookie('selectedPeriod', 'test',null,-1,false);
       ApexPages.currentPage().setCookies(new Cookie[]{previousReportPeriodCookie});
       
        Cookie previousTaskCookie= new Cookie('selectedTasks', 'test',null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{previousTaskCookie}); 
            
     
        controller.prepResultsTree();
      
        ApexPages.currentPage().getParameters().put('closedDay','2');
        controller.saveIMReport();
        ApexPages.currentPage().getParameters().put('narative','Hi World');
        controller.saveIMRptNarative();
        
        System.Test.StopTest();
    }
    
        public static testMethod void testManageIndTargetsIM1() {   
         System.Test.StartTest(); 
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
       
        String IMId= testIndicatorUtil.getIMForOrgId(OrgUnitId);
        String projectId =  testIndicatorUtil.getProjectForOrgId(OrgUnitId);
        
        Project__c  imLink=[select Id,Name from Project__c where id = :projectId ];         
        ApexPages.StandardController thecontroller = new ApexPages.StandardController(imLink);
             
       
        //Reporting_Period__c testReportingPeriod = imReportingPeriodList.get(0);
        testIndicatorUtil.updateIMForOrgId(orgUnitId,'Annual','Implementing Mechanism');
         List<Reporting_Period__c> imReportingPeriodList = testIndicatorUtil.getReportingPeriods(IMId);
        ApexPages.currentPage().getParameters().put('id',IMId);  
         ClsManageIndicatorTargets controller = new ClsManageIndicatorTargets();  
         if(imReportingPeriodList != null && imReportingPeriodList.size()>0){
         System.Debug('Reporting Period IM ***** ' + imReportingPeriodList);
         for(Reporting_Period__c testReportingPeriod:imReportingPeriodList){
          controller.repPeriod = testReportingPeriod;
          break;
           
         } 
         
         }
        
      controller.objName='Reporting_Period__c';
      ApexPages.currentPage().getParameters().put('rejectReasonid','TESTReject');
      controller.changeToReject();
       Cookie previousReportPeriodCookie = new Cookie('selectedPeriod', 'test',null,-1,false);
       ApexPages.currentPage().setCookies(new Cookie[]{previousReportPeriodCookie});
       
        Cookie previousTaskCookie= new Cookie('selectedTasks', 'test',null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{previousTaskCookie}); 
            
        controller.prepResultsTreeChange();
       
        
        System.Test.StopTest();
    }
    
     public static testMethod void testManageIndTargetsIM2() {    
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        System.Test.StartTest();
        String IMId= testIndicatorUtil.getIMForOrgId(OrgUnitId);
        String projectId =  testIndicatorUtil.getProjectForOrgId(OrgUnitId);
        
        Project__c  imLink=[select Id,Name from Project__c where id = :projectId ];         
        ApexPages.StandardController thecontroller = new ApexPages.StandardController(imLink);
             
       
        //Reporting_Period__c testReportingPeriod = imReportingPeriodList.get(0);
        testIndicatorUtil.updateIMForOrgId(orgUnitId,'Annual','Implementing Mechanism');
         List<Reporting_Period__c> imReportingPeriodList = testIndicatorUtil.getReportingPeriods(IMId);
         ApexPages.currentPage().getParameters().put('id',IMId);  
         
         ClsManageIndicatorTargets controller = new ClsManageIndicatorTargets();  
         if(imReportingPeriodList != null && imReportingPeriodList.size()>0){
         System.Debug('Reporting Period IM ***** ' + imReportingPeriodList);
         for(Reporting_Period__c testReportingPeriod:imReportingPeriodList){
          controller.repPeriod = testReportingPeriod;
          break;
           
         } 
         
         }
          controller.objName='Reporting_Period__c';
        controller.getPeriods();
        controller.getTasksForIM();
     
     controller.changeToPublish();
  
        controller.changeToClose();
       
        //controller.changeToOpen();
        controller.changeToSubmit();
        
         controller.changeToDraft();
        controller.changeToApproved();
       
        controller.CancelNGo();
        
        controller.doSaveTargets();
       
        
        
        System.Test.StopTest();
    }
    */
    /**  
    
    RF Goal
    =======
    */
    
    /*
       public static testMethod void testManageIndTargetsRF() {    
     System.Test.StartTest();
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        String rfGoadId =  testIndicatorUtil.getRFGoalForOrgId(OrgUnitId);
      
    
        testIndicatorUtil.updateRFGoalForOrgId(orgUnitId);
         List<RF_Reporting_Period__c> imReportingPeriodList =testIndicatorUtil.getRFReportingPeriods(rfGoadId ,'Goal') ;
        RF_Reporting_Period__c rp = imReportingPeriodList[0];
        System.Test.setCurrentPage(new PAgereference('/apex/vfIMIndicatorResultsPage'));
        ApexPages.currentPage().getParameters().put('id',rp.Id); 
         ClsManageIndicatorTargets controller = new ClsManageIndicatorTargets();  
     // ApexPages.currentPage().getParameters().put('id',rfGoadId);  
       
         if(imReportingPeriodList != null && imReportingPeriodList.size()>0){
        
         for(RF_Reporting_Period__c testReportingPeriod:imReportingPeriodList){
         controller.rfRepPeriod = testReportingPeriod;
          break;          
         } 
         
         }
       
      controller.objName='RF_Reporting_Period__c';
       testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,rfGoadId,'RFGoal');
       controller.prepareTargetsXML(new ClsIndicatorWizardUtility());
     
        controller.getPeriods();
     
        controller.prepResultsTree();
      
        
        
        System.Test.StopTest();
    }
    
        public static testMethod void testManageIndTargetsRF1() {   
         System.Test.StartTest(); 
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        String rfGoadId =  testIndicatorUtil.getRFGoalForOrgId(OrgUnitId);
      
    
        testIndicatorUtil.updateRFGoalForOrgId(orgUnitId);
         List<RF_Reporting_Period__c> imReportingPeriodList =testIndicatorUtil.getRFReportingPeriods(rfGoadId ,'Goal') ;
        
        ApexPages.currentPage().getParameters().put('id',rfGoadId);  
         ClsManageIndicatorTargets controller = new ClsManageIndicatorTargets();  
         if(imReportingPeriodList != null && imReportingPeriodList.size()>0){
         System.Debug('Reporting Period IM ***** ' + imReportingPeriodList);
         for(RF_Reporting_Period__c testReportingPeriod:imReportingPeriodList){
         controller.rfRepPeriod = testReportingPeriod;
          break;          
         } 
         
         }
         
       testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,rfGoadId,'RFGoal');
     
      controller.objName='RF_Reporting_Period__c';
       controller.xmlStr='<?xml version="1.0" encoding="UTF-8"?>' +
        '<rows id="0"><row id="1.1.1-2"><cell image="indicator.png">1.1.1-2</cell>'+
    '<cell>Number of Ports of Entry supported by USG Terrorist Interdiction Programs</cell><cell></cell><cell>' +
    '</cell><cell>Output</cell><cell></cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row>' +
    '<row id="1.2-3"><cell image="indicator.png">1.2-3</cell><cell>Overall bilateral country Rating Assessment Tool score demonstrating status of an effective and institutionalized strategic trade control system meeting international standards</cell><cell></cell>' +
    '<cell></cell><cell>Outcome</cell><cell>true</cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row><row id="1.3.1-3"><cell image="indicator.png">1.3.1-3</cell><cell>Number of exercises host country military personnel participate in with US or coalition forces as a result of USG assistance</cell><cell></cell><cell></cell><cell>Output</cell><cell>true</cell>' +
    '<cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row><row id="1.1.1-1"><cell image="indicator.png">1.1.1-1</cell><cell>Number of students trained on counterterrorism finance by USG programs</cell><cell></cell><cell></cell><cell></cell><cell></cell><cell>true</cell><cell>' +
    '</cell><cell disabled="true">true</cell><cell>STANDARD</cell><row id="1.1.1-1a" open="1"><cell image="sub-indicator.png">1.1.1-1a</cell><cell>Number of men</cell><cell></cell><cell></cell><cell></cell><cell>true</cell><cell>true</cell><cell></cell><cell>true</cell><cell>STANDARD</cell></row><row id="1.1.1-1b" open="1"><cell image="sub-indicator.png">1.1.1-1b</cell><cell>Number of women</cell><cell></cell><cell>Beta</cell><cell></cell><cell></cell><cell>true</cell><cell></cell><cell>true</cell><cell>STANDARD</cell></row></row><row id="1.2.1-2"><cell image="indicator.png">1.2.1-2</cell><cell>Number of participants trained in strategic trade controls</cell><cell></cell><cell></cell><cell>Output</cell><cell></cell><cell>true</cell><cell></cell>' +
    '<cell></cell><cell>STANDARD</cell><row id="1.2.1-2a" open="1"><cell image="sub-indicator.png">1.2.1-2a</cell><cell>Number of men</cell><cell></cell><cell></cell><cell></cell><cell></cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row><row id="1.2.1-2b" open="1"><cell image="sub-indicator.png">1.2.1-2b</cell><cell>Number of women</cell><cell></cell><cell></cell><cell></cell><cell></cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row></row><row id="1.3-8"><cell image="indicator.png">1.3-8</cell><cell>Country score on Index of State Weakness in the Developing World</cell><cell></cell><cell></cell><cell>Outcome</cell><cell>true</cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row><row id="1.6-4"><cell image="indicator.png">1.6-4</cell><cell>Country political stability and absence of violence point value score</cell><cell></cell><cell></cell><cell>Outcome</cell><cell></cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row><row id="1-Z1"><cell image="custom-indicator.png">1-Z1</cell><cell>test43</cell><cell></cell><cell></cell><cell></cell><cell></cell><cell>true</cell><cell>true</cell><cell disabled="true">true</cell><cell>STANDARD</cell></row><row id="1.1-3"><cell image="custom-indicator.png">1.1-3</cell><cell></cell><cell></cell><cell></cell><cell></cell><cell></cell><cell>true</cell><cell>true</cell><cell></cell><cell>STANDARD</cell><row id="1.1-3Za" open="1"><cell image="custom-sub-indicator.png">1.1-3Za</cell><cell>Test</cell><cell></cell><cell></cell><cell></cell><cell></cell><cell>true</cell><cell>true</cell><cell>true</cell><cell>STANDARD</cell></row></row><row id="1.1.3-2"><cell image="indicator.png">1.1.3-2</cell><cell>Number of students trained in anti-terrorism topics and skills through the Anti-Terrorism Assistance (ATA) program</cell><cell>APP/APR</cell><cell></cell><cell>Output</cell><cell>true</cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row><row id="1.3.1-10"><cell image="indicator.png">1.3.1-10</cell><cell>Improvements (or deterioration) in the security situation as ascertained through UN Department of Safety &amp; Security (UN DSS) reports</cell><cell></cell><cell></cell><cell>Outcome</cell><cell>true</cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row></rows>';

        controller.prepResultsTreeChange();
       
        
        System.Test.StopTest();
    }
    
   public static testMethod void testManageIndTargetsRF2() {    
         ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        String rfGoadId =  testIndicatorUtil.getRFGoalForOrgId(OrgUnitId);
      
    
        testIndicatorUtil.updateRFGoalForOrgId(orgUnitId);
         List<RF_Reporting_Period__c> imReportingPeriodList =testIndicatorUtil.getRFReportingPeriods(rfGoadId ,'Goal') ;
        
         RF_Reporting_Period__c rp = imReportingPeriodList[0];
        System.Test.setCurrentPage(new PAgereference('/apex/vfIMIndicatorResultsPage'));
        ApexPages.currentPage().getParameters().put('id',rp.Id); 
         ClsManageIndicatorTargets controller = new ClsManageIndicatorTargets();  
        
        
        
        ApexPages.currentPage().getParameters().put('id',rfGoadId);  
        
         if(imReportingPeriodList != null && imReportingPeriodList.size()>0){
         System.Debug('Reporting Period IM ***** ' + imReportingPeriodList);
         for(RF_Reporting_Period__c testReportingPeriod:imReportingPeriodList){
         controller.rfRepPeriod = testReportingPeriod;
          break;          
         } 
         
         }
          controller.objName='RF_Reporting_Period__c';
     
         testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,rfGoadId,'RFGoal');    
        ApexPages.currentPage().getParameters().put('closedDay','2');
        controller.saveIMReport();
      
        controller.doSaveTargets();
       
        
        
        System.Test.StopTest();
    }
    
    
    */
    
       /** LF Goal */
    
    /*
   public static testMethod void testManageIndTargetsLF() {    
     System.Test.StartTest();
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        String projectId =  testIndicatorUtil.getProjectForOrgId(OrgUnitId);
        String lfGoadId =  testIndicatorUtil.getLFGoalForProjectId(projectId);
      
        testIndicatorUtil.updateProjectForOrgId(orgUnitId);
        testIndicatorUtil.updateLFGoalForProjectId(projectId);
         List<LF_Reporting_Period__c> imReportingPeriodList =testIndicatorUtil.getLFReportingPeriods(lfGoadId ,'Goal') ;
        
        LF_Reporting_Period__c rp = imReportingPeriodList[0];
        System.Test.setCurrentPage(new PAgereference('/apex/vfIMIndicatorResultsPage'));
        ApexPages.currentPage().getParameters().put('id',rp.Id); 
         ClsManageIndicatorTargets controller = new ClsManageIndicatorTargets();  
        
        
    //  ApexPages.currentPage().getParameters().put('id',lfGoadId );  
         
         if(imReportingPeriodList != null && imReportingPeriodList.size()>0){
         System.Debug('Reporting Period LF ***** ' + imReportingPeriodList);
         for(LF_Reporting_Period__c testReportingPeriod:imReportingPeriodList){
         controller.lfRepPeriod = testReportingPeriod;
          break;          
         } 
         
         } 
         
     controller.objName='LF_Reporting_Period__c';
       testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,lfGoadId,'LFGoal');
       controller.prepareTargetsXML(new ClsIndicatorWizardUtility());
     
        controller.getPeriods();
     
        controller.prepResultsTree();
      
        
        
        System.Test.StopTest();
    }
    
       public static testMethod void testCancelNGo() {    
        System.Test.StartTest();
         ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
       String IMId= testIndicatorUtil.getIMForOrgId(OrgUnitId);
        ApexPages.currentPage().getParameters().put('id',IMId);  
      ClsManageIndicatorTargets controller = new ClsManageIndicatorTargets();  
        controller.CancelNGo();
        
     controller.CancelGo();
     controller.CancelSave();
        // controller.changeToOpen();
        System.Test.StopTest();
    }  
        public static testMethod void testManageIndTargetsLF1() {   
         System.Test.StartTest(); 
         ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        String projectId =  testIndicatorUtil.getProjectForOrgId(OrgUnitId);
        String lfGoadId =  testIndicatorUtil.getLFGoalForProjectId(projectId);
      
    
        testIndicatorUtil.updateRFGoalForOrgId(orgUnitId);
         List<LF_Reporting_Period__c> imReportingPeriodList =testIndicatorUtil.getLFReportingPeriods(lfGoadId ,'Goal') ;
        
        ApexPages.currentPage().getParameters().put('id',lfGoadId );  
         ClsManageIndicatorTargets controller = new ClsManageIndicatorTargets();  
         if(imReportingPeriodList != null && imReportingPeriodList.size()>0){
         System.Debug('Reporting Period IM ***** ' + imReportingPeriodList);
         for(LF_Reporting_Period__c testReportingPeriod:imReportingPeriodList){
         controller.lfRepPeriod = testReportingPeriod;
          break;          
         } 
         
         }
      controller.objName='LF_Reporting_Period__c';
       controller.xmlStr='<?xml version="1.0" encoding="UTF-8"?><rows id="0"><row id="1.1.1-2"><cell image="indicator.png">1.1.1-2</cell><cell>Number of Ports of Entry supported by USG Terrorist Interdiction Programs</cell><cell></cell><cell></cell><cell>Output</cell><cell></cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row><row id="1.2-3"><cell image="indicator.png">1.2-3</cell><cell>Overall bilateral country Rating Assessment Tool score demonstrating status of an effective and institutionalized strategic trade control system meeting international standards</cell><cell></cell><cell></cell><cell>Outcome</cell><cell>true</cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row><row id="1.3.1-3"><cell image="indicator.png">1.3.1-3</cell><cell>Number of exercises host country military personnel participate in with US or coalition forces as a result of USG assistance</cell><cell></cell><cell></cell><cell>Output</cell><cell>true</cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row><row id="1.1.1-1"><cell image="indicator.png">1.1.1-1</cell><cell>Number of students trained on counterterrorism finance by USG programs</cell><cell></cell><cell></cell><cell></cell><cell></cell><cell>true</cell><cell></cell><cell disabled="true">true</cell><cell>STANDARD</cell><row id="1.1.1-1a" open="1"><cell image="sub-indicator.png">1.1.1-1a</cell><cell>Number of men</cell><cell></cell><cell></cell><cell></cell><cell>true</cell><cell>true</cell><cell></cell><cell>true</cell><cell>STANDARD</cell></row><row id="1.1.1-1b" open="1"><cell image="sub-indicator.png">1.1.1-1b</cell><cell>Number of women</cell><cell></cell><cell>Beta</cell><cell></cell><cell></cell><cell>true</cell><cell></cell><cell>true</cell><cell>STANDARD</cell></row></row><row id="1.2.1-2"><cell image="indicator.png">1.2.1-2</cell><cell>Number of participants trained in strategic trade controls</cell><cell></cell><cell></cell><cell>Output</cell><cell></cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell><row id="1.2.1-2a" open="1"><cell image="sub-indicator.png">1.2.1-2a</cell><cell>Number of men</cell><cell></cell><cell></cell><cell></cell><cell></cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row><row id="1.2.1-2b" open="1"><cell image="sub-indicator.png">1.2.1-2b</cell><cell>Number of women</cell><cell></cell><cell></cell><cell></cell><cell></cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row></row><row id="1.3-8"><cell image="indicator.png">1.3-8</cell><cell>Country score on Index of State Weakness in the Developing World</cell><cell></cell><cell></cell><cell>Outcome</cell><cell>true</cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row><row id="1.6-4"><cell image="indicator.png">1.6-4</cell><cell>Country political stability and absence of violence point value score</cell><cell></cell><cell></cell><cell>Outcome</cell><cell></cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row><row id="1-Z1"><cell image="custom-indicator.png">1-Z1</cell><cell>test43</cell><cell></cell><cell></cell><cell></cell><cell></cell><cell>true</cell><cell>true</cell><cell disabled="true">true</cell><cell>STANDARD</cell></row><row id="1.1-3"><cell image="custom-indicator.png">1.1-3</cell><cell></cell><cell></cell><cell></cell><cell></cell><cell></cell><cell>true</cell><cell>true</cell><cell></cell><cell>STANDARD</cell><row id="1.1-3Za" open="1"><cell image="custom-sub-indicator.png">1.1-3Za</cell><cell>Test</cell><cell></cell><cell></cell><cell></cell><cell></cell><cell>true</cell><cell>true</cell><cell>true</cell><cell>STANDARD</cell></row></row><row id="1.1.3-2"><cell image="indicator.png">1.1.3-2</cell><cell>Number of students trained in anti-terrorism topics and skills through the Anti-Terrorism Assistance (ATA) program</cell><cell>APP/APR</cell><cell></cell><cell>Output</cell><cell>true</cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row><row id="1.3.1-10"><cell image="indicator.png">1.3.1-10</cell><cell>Improvements (or deterioration) in the security situation as ascertained through UN Department of Safety &amp; Security (UN DSS) reports</cell><cell></cell><cell></cell><cell>Outcome</cell><cell>true</cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row></rows>';

        controller.prepResultsTreeChange();
       
        
        System.Test.StopTest();
    }
    
     public static testMethod void testManageIndTargetsLF2() {    
         ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        String projectId =  testIndicatorUtil.getProjectForOrgId(OrgUnitId);
        String lfGoadId =  testIndicatorUtil.getLFGoalForProjectId(projectId);
      
    
        testIndicatorUtil.updateRFGoalForOrgId(orgUnitId);
         List<LF_Reporting_Period__c> imReportingPeriodList =testIndicatorUtil.getLFReportingPeriods(lfGoadId ,'Goal') ;
        
        ApexPages.currentPage().getParameters().put('id',lfGoadId );  
         ClsManageIndicatorTargets controller = new ClsManageIndicatorTargets();  
         if(imReportingPeriodList != null && imReportingPeriodList.size()>0){
         System.Debug('Reporting Period IM ***** ' + imReportingPeriodList);
         for(LF_Reporting_Period__c testReportingPeriod:imReportingPeriodList){
         controller.lfRepPeriod = testReportingPeriod;
          break;          
         } 
         
         }
      controller.objName='LF_Reporting_Period__c';
    
    controller.xmlStr='<?xml version="1.0" encoding="UTF-8"?><rows id="0"><row id="1.1.1-2"><cell image="indicator.png">1.1.1-2</cell><cell>Number of Ports of Entry supported by USG Terrorist Interdiction Programs</cell><cell></cell><cell></cell><cell>Output</cell><cell></cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row><row id="1.2-3"><cell image="indicator.png">1.2-3</cell><cell>Overall bilateral country Rating Assessment Tool score demonstrating status of an effective and institutionalized strategic trade control system meeting international standards</cell><cell></cell><cell></cell><cell>Outcome</cell><cell>true</cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row><row id="1.3.1-3"><cell image="indicator.png">1.3.1-3</cell><cell>Number of exercises host country military personnel participate in with US or coalition forces as a result of USG assistance</cell><cell></cell><cell></cell><cell>Output</cell><cell>true</cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row><row id="1.1.1-1"><cell image="indicator.png">1.1.1-1</cell><cell>Number of students trained on counterterrorism finance by USG programs</cell><cell></cell><cell></cell><cell></cell><cell></cell><cell>true</cell><cell></cell><cell disabled="true">true</cell><cell>STANDARD</cell><row id="1.1.1-1a" open="1"><cell image="sub-indicator.png">1.1.1-1a</cell><cell>Number of men</cell><cell></cell><cell></cell><cell></cell><cell>true</cell><cell>true</cell><cell></cell><cell>true</cell><cell>STANDARD</cell></row><row id="1.1.1-1b" open="1"><cell image="sub-indicator.png">1.1.1-1b</cell><cell>Number of women</cell><cell></cell><cell>Beta</cell><cell></cell><cell></cell><cell>true</cell><cell></cell><cell>true</cell><cell>STANDARD</cell></row></row><row id="1.2.1-2"><cell image="indicator.png">1.2.1-2</cell><cell>Number of participants trained in strategic trade controls</cell><cell></cell><cell></cell><cell>Output</cell><cell></cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell><row id="1.2.1-2a" open="1"><cell image="sub-indicator.png">1.2.1-2a</cell><cell>Number of men</cell><cell></cell><cell></cell><cell></cell><cell></cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row><row id="1.2.1-2b" open="1"><cell image="sub-indicator.png">1.2.1-2b</cell><cell>Number of women</cell><cell></cell><cell></cell><cell></cell><cell></cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row></row><row id="1.3-8"><cell image="indicator.png">1.3-8</cell><cell>Country score on Index of State Weakness in the Developing World</cell><cell></cell><cell></cell><cell>Outcome</cell><cell>true</cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row><row id="1.6-4"><cell image="indicator.png">1.6-4</cell><cell>Country political stability and absence of violence point value score</cell><cell></cell><cell></cell><cell>Outcome</cell><cell></cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row><row id="1-Z1"><cell image="custom-indicator.png">1-Z1</cell><cell>test43</cell><cell></cell><cell></cell><cell></cell><cell></cell><cell>true</cell><cell>true</cell><cell disabled="true">true</cell><cell>STANDARD</cell></row><row id="1.1-3"><cell image="custom-indicator.png">1.1-3</cell><cell></cell><cell></cell><cell></cell><cell></cell><cell></cell><cell>true</cell><cell>true</cell><cell></cell><cell>STANDARD</cell><row id="1.1-3Za" open="1"><cell image="custom-sub-indicator.png">1.1-3Za</cell><cell>Test</cell><cell></cell><cell></cell><cell></cell><cell></cell><cell>true</cell><cell>true</cell><cell>true</cell><cell>STANDARD</cell></row></row><row id="1.1.3-2"><cell image="indicator.png">1.1.3-2</cell><cell>Number of students trained in anti-terrorism topics and skills through the Anti-Terrorism Assistance (ATA) program</cell><cell>APP/APR</cell><cell></cell><cell>Output</cell><cell>true</cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row><row id="1.3.1-10"><cell image="indicator.png">1.3.1-10</cell><cell>Improvements (or deterioration) in the security situation as ascertained through UN Department of Safety &amp; Security (UN DSS) reports</cell><cell></cell><cell></cell><cell>Outcome</cell><cell>true</cell><cell>true</cell><cell></cell><cell></cell><cell>STANDARD</cell></row></rows>';

    
        ApexPages.currentPage().getParameters().put('closedDay','2');
        controller.saveIMReport();
      
        controller.doSaveTargets();
       
        
        
        System.Test.StopTest();
    }
    
       public static testMethod void testSaveIMNarativeNReports() {    
     System.Test.StartTest();
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
       
        String IMId= testIndicatorUtil.getIMForOrgId(OrgUnitId);
       
    
        testIndicatorUtil.updateIMForOrgId(orgUnitId,'Annual','Implementing Mechanism');
         List<Reporting_Period__c> imReportingPeriodList = testIndicatorUtil.getReportingPeriods(IMId);
        ApexPages.currentPage().getParameters().put('id',IMId);  
         ClsManageIndicatorTargets controller = new ClsManageIndicatorTargets();  
         if(imReportingPeriodList != null && imReportingPeriodList.size()>0){
         System.Debug('Reporting Period IM ***** ' + imReportingPeriodList);
         for(Reporting_Period__c testReportingPeriod:imReportingPeriodList){
         
          testReportingPeriod.Close_Date__c = null;
         controller.repPeriod  = testReportingPeriod;
          break;
           
         } 
         
         }
    
        controller.objName='Reporting_Period__c';
      
       ApexPages.currentPage().getParameters().put('narative','Hi World');
        controller.saveIMRptNarative();
       
        ApexPages.currentPage().getParameters().put('closedDay','2');
        controller.saveIMReport();
        
        controller.changeToDraft();
       
        
        System.Test.StopTest();
    }
    
  */
    
 }