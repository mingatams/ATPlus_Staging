@IsTest
public with sharing class ManageIMIndicatorTargetsTest{
  
 
 
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
        System.Test.setCurrentPage(new PAgereference('/apex/IMIndicatorData'));
        ApexPages.currentPage().getParameters().put('id',IMId.Id); 
        ApexPages.currentPage().getParameters().put('Lid',rp.Id);
        ManageIMIndicatorTargets controller = new  ManageIMIndicatorTargets();        
        controller.getPeriods();
        controller.selectedPeriodName =rp.Name;
        controller.changedRowIds = changedIds;
       // controller.xmlStr = '<?xml version="1.0" encoding="UTF-8"?><rows id="0"><row id="'+IndicatorId +'"><cell image="indicator.png"Id="1-Z1">&amp;nbsp&amp;nbsp&amp;nbsp1-Z1</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">100.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">200.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">300.00</cell><cell>100.00</cell><cell>&lt;img src="/resource/varianceImages/arrow-up.png" alt="Up Arrow" height="15" width="15" border="0"/&gt;</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell>1</cell><cell>Numeric</cell><cell></cell><cell></cell><cell></cell><row id="'+subIndicatorId +'"><cell image="sub-indicator.png" Id="1-Z12">&amp;nbsp&amp;nbsp&amp;nbsp1-Z12</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">100.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">200.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">300.00</cell><cell>100.00</cell><cell>&lt;img src="/resource/varianceImages/arrow-up.png" alt="Up Arrow" height="15" width="15" border="0"/&gt;</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell>1</cell><cell>Numeric</cell><cell></cell><cell></cell><cell></cell></row></row></rows>';        
        controller.xmlStr = '<?xml version="1.0" encoding="UTF-8"?><rows id="0"><row id="'+IndicatorId +'"><cell name="Indicator" image="indicator.png"Id="1-Z1">&amp;nbsp&amp;nbsp&amp;nbsp1-Z1</cell><cell name="Baseline" style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">100.00</cell><cell name="Target" style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">200.00</cell><cell name="Actual" style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">300.00</cell><cell name="Variance">100.00</cell><cell name="Pcomments">&lt;img src="/resource/varianceImages/arrow-up.png" alt="Up Arrow" height="15" width="15" border="0"/&gt;</cell><cell name="Mcomments" style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell name="Source">1</cell><cell name="IndicatorDataType">Numeric</cell><cell></cell><cell></cell><cell></cell><row id="'+subIndicatorId +'"><cell name="Indicator" image="sub-indicator.png" Id="1-Z12">&amp;nbsp&amp;nbsp&amp;nbsp1-Z12</cell><cell name="Baseline" style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">100.00</cell><cell name="Target" style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">200.00</cell><cell name="Actual" style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">300.00</cell><cell name="Variance">100.00</cell><cell name="Pcomments">&lt;img src="/resource/varianceImages/arrow-up.png" alt="Up Arrow" height="15" width="15" border="0"/&gt;</cell><cell name="Mcomments" style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell name="Source">1</cell><cell name="IndicatorDataType">Numeric</cell><cell></cell><cell></cell><cell></cell></row></row></rows>';
        controller.doSaveTargets();
       // controller.changeToOpen();
       // controller.changeToClose();
        controller.prepResultsTree();
        controller.prepResultsTreeChange();
        controller.showPopup();
        controller.closePopup();
        controller.showRejectReasonPopup();
        controller.closeRejectReasonPopup();
        controller.showSubmitPopup();
        controller.closeSubmitPopup();
       // controller.saveNarrative();
       // controller.savePeriodExtension();
        controller.getExtendPeriods();
       // controller.saveRejectReason();
        controller.closeExtendPopup();
        controller.showExtendPopup();
       // controller.changeToDraft();
       // controller.changeToPublish();
       // controller.changeToOpen();
       // controller.changeToSubmit();
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
        System.Test.setCurrentPage(new PAgereference('/apex/IMIndicatorData'));
        ApexPages.currentPage().getParameters().put('id',IMId.Id); 
        ApexPages.currentPage().getParameters().put('Lid',rp.Id);
        ApexPages.currentPage().getParameters().put('actId',act.Id);
        ManageIMIndicatorTargets controller = new  ManageIMIndicatorTargets(rp);
        controller.getPeriods();
        controller.selectedPeriodName =rp.Name;
        controller.getTasksForIM();
        controller.changedRowIds = changedIds;
       // controller.xmlStr = '<?xml version="1.0" encoding="UTF-8"?><rows id="0"><row id="'+IndicatorId +'"><cell image="indicator.png"Id="1-Z1">&amp;nbsp&amp;nbsp&amp;nbsp1-Z1</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">100.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">200.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">300.00</cell><cell>100.00</cell><cell>&lt;img src="/resource/varianceImages/arrow-up.png" alt="Up Arrow" height="15" width="15" border="0"/&gt;</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell>1</cell><cell>Numeric</cell><cell></cell><cell></cell><cell></cell><row id="'+subIndicatorId +'"><cell image="sub-indicator.png" Id="1-Z12">&amp;nbsp&amp;nbsp&amp;nbsp1-Z12</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">100.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">200.00</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">300.00</cell><cell>100.00</cell><cell>&lt;img src="/resource/varianceImages/arrow-up.png" alt="Up Arrow" height="15" width="15" border="0"/&gt;</cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell>1</cell><cell>Numeric</cell><cell></cell><cell></cell><cell></cell></row></row></rows>';
        controller.xmlStr = '<?xml version="1.0" encoding="UTF-8"?><rows id="0"><row id="'+IndicatorId +'"><cell name="Indicator" image="indicator.png"Id="1-Z1">&amp;nbsp&amp;nbsp&amp;nbsp1-Z1</cell><cell name="Baseline" style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">100.00</cell><cell name="Target" style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">200.00</cell><cell name="Actual" style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">300.00</cell><cell name="Variance">100.00</cell><cell name="Pcomments">&lt;img src="/resource/varianceImages/arrow-up.png" alt="Up Arrow" height="15" width="15" border="0"/&gt;</cell><cell name="Mcomments" style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell name="Source">1</cell><cell name="IndicatorDataType">Numeric</cell><cell></cell><cell></cell><cell></cell><row id="'+subIndicatorId +'"><cell name="Indicator" image="sub-indicator.png" Id="1-Z12">&amp;nbsp&amp;nbsp&amp;nbsp1-Z12</cell><cell name="Baseline" style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">100.00</cell><cell name="Target" style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">200.00</cell><cell name="Actual" style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;">300.00</cell><cell name="Variance">100.00</cell><cell name="Pcomments">&lt;img src="/resource/varianceImages/arrow-up.png" alt="Up Arrow" height="15" width="15" border="0"/&gt;</cell><cell name="Mcomments" style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell style="border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;"></cell><cell name="Source">1</cell><cell name="IndicatorDataType">Numeric</cell><cell></cell><cell></cell><cell></cell></row></row></rows>';
        controller.doSaveTargets();
        System.Test.stopTest();        
        
        
        
    
    }   
 }