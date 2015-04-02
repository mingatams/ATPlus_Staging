public with sharing class ClsReportingPeriodExtension {
clsGlobalUtility GU = new clsGlobalUtility();
 public String recId;
    public Integer showLevel{get;set;}
    public Reporting_Period__c rp{get;set;}
    
    
    public ClsReportingPeriodExtension(ManageIMIndicatorTargets controller) {
 
       
         recId = ApexPages.currentpage().getParameters().get('id');
       showLevel = 2;
        Map<String,String> pageParameters = ApexPages.currentpage().getParameters();
        for(String param: pageParameters.keySet()){
            if (param.contains('_lkid')){
                recId = pageParameters.get(param);
            }           
        }
        String objName = GU.getObjectNameById(recId);
        String recTypeName;
        if (objName.equalsIgnoreCase('Reporting_Period__c')){
            rp = (Reporting_Period__c)GU.lookup(recId,'Reporting_Period__c');
            
            if(rp == null){     
              Map<String,String> parameterMap = ApexPages.currentPage().getParameters();
                  if(parameterMap != null)                    {
                       for(String reportId:parameterMap.keySet()){
                       if(reportId.contains('rptPeriod'))
                         {
                          if(parameterMap.get(reportId) != null && parameterMap.get(reportId) != '')                                                   
                            rp = (Reporting_Period__c)GU.lookup(parameterMap.get(reportId),'Reporting_Period__c');
                         }                        
                       }                      
                    }             
            }
            
            
            recTypeName = GU.getRecordType('Reporting_Period__c', rp.RecordTypeId);
            if (recTypeName.equalsIgnoreCase('Activity')){
                showLevel = 2;
            } else if (recTypeName.equalsIgnoreCase('Implementing Mechanism')){
                showLevel = 1;
            }
        } 
    }
    
    
    public ClsReportingPeriodExtension(ClsManageIndicatorTargets controller) {
 
       
         recId = ApexPages.currentpage().getParameters().get('id');
       showLevel = 2;
        Map<String,String> pageParameters = ApexPages.currentpage().getParameters();
        for(String param: pageParameters.keySet()){
            if (param.contains('_lkid')){
                recId = pageParameters.get(param);
            }           
        }
        String objName = GU.getObjectNameById(recId);
        String recTypeName;
        if (objName.equalsIgnoreCase('Reporting_Period__c')){
            rp = (Reporting_Period__c)GU.lookup(recId,'Reporting_Period__c');
            
            if(rp == null){     
              Map<String,String> parameterMap = ApexPages.currentPage().getParameters();
                  if(parameterMap != null)                    {
                       for(String reportId:parameterMap.keySet()){
                       if(reportId.contains('rptPeriod'))
                         {
                          if(parameterMap.get(reportId) != null && parameterMap.get(reportId) != '')                                                   
                            rp = (Reporting_Period__c)GU.lookup(parameterMap.get(reportId),'Reporting_Period__c');
                         }                        
                       }                      
                    }             
            }
            
            
            recTypeName = GU.getRecordType('Reporting_Period__c', rp.RecordTypeId);
            if (recTypeName.equalsIgnoreCase('Activity')){
                showLevel = 2;
            } else if (recTypeName.equalsIgnoreCase('Implementing Mechanism')){
                showLevel = 1;
            }
        } 
    }

   
     public ClsReportingPeriodExtension(ClsManageIndicatorReportingTargets controller) {
 
       
         recId = ApexPages.currentpage().getParameters().get('id');
       showLevel = 2;
        Map<String,String> pageParameters = ApexPages.currentpage().getParameters();
        for(String param: pageParameters.keySet()){
            if (param.contains('_lkid')){
                recId = pageParameters.get(param);
            }           
        }
        String objName = GU.getObjectNameById(recId);
        String recTypeName;
        if (objName.equalsIgnoreCase('Reporting_Period__c')){
            rp = (Reporting_Period__c)GU.lookup(recId,'Reporting_Period__c');
            
            if(rp == null){     
              Map<String,String> parameterMap = ApexPages.currentPage().getParameters();
                  if(parameterMap != null)                    {
                       for(String reportId:parameterMap.keySet()){
                       if(reportId.contains('rptPeriod'))
                         {
                          if(parameterMap.get(reportId) != null && parameterMap.get(reportId) != '')                                                   
                            rp = (Reporting_Period__c)GU.lookup(parameterMap.get(reportId),'Reporting_Period__c');
                         }                        
                       }                      
                    }             
            }
            
            
            recTypeName = GU.getRecordType('Reporting_Period__c', rp.RecordTypeId);
            if (recTypeName.equalsIgnoreCase('Activity')){
                showLevel = 2;
            } else if (recTypeName.equalsIgnoreCase('Implementing Mechanism')){
                showLevel = 1;
            }
        } 
    }
    
    public ClsReportingPeriodExtension(ApexPages.StandardController stdController){
        clsGlobalUtility GU = new clsGlobalUtility();
       
         recId = ApexPages.currentpage().getParameters().get('id');
      
        Map<String,String> pageParameters = ApexPages.currentpage().getParameters();
        for(String param: pageParameters.keySet()){
            if (param.contains('_lkid')){
                recId = pageParameters.get(param);
            }           
        }
        String objName = GU.getObjectNameById(recId);
        String recTypeName;
        if (objName.equalsIgnoreCase('Reporting_Period__c')){
            rp = (Reporting_Period__c)GU.lookup(recId,'Reporting_Period__c');
            recTypeName = GU.getRecordType('Reporting_Period__c', rp.RecordTypeId);
            if (recTypeName.equalsIgnoreCase('Activity')){
                showLevel = 2;
            } else if (recTypeName.equalsIgnoreCase('Implementing Mechanism')){
                showLevel = 1;
            }
        } else if (objName.equalsIgnoreCase('LF_Reporting_Period__c')){
            LF_Reporting_Period__c rp = (LF_Reporting_Period__c)GU.lookup(recId,'LF_Reporting_Period__c');
            recTypeName = GU.getRecordType('LF_Reporting_Period__c', rp.RecordTypeId);
            if (recTypeName.equalsIgnoreCase('LF Goal')){
                showLevel = 1;
            } else if (recTypeName.equalsIgnoreCase('LF Purpose')){
                showLevel = 2;
            } else if (recTypeName.equalsIgnoreCase('LF Sub-Purpose')){
                showLevel = 3;
            } else if (recTypeName.equalsIgnoreCase('LF Output')){
                showLevel = 4;
            } else if (recTypeName.equalsIgnoreCase('LF Input')){
                showLevel = 5;
            }
            
        } else if (objName.equalsIgnoreCase('RF_Reporting_Period__c')){
            RF_Reporting_Period__c rp = (RF_Reporting_Period__c)GU.lookup(recId,'RF_Reporting_Period__c');
            recTypeName = GU.getRecordType('RF_Reporting_Period__c', rp.RecordTypeId);
            if (recTypeName.equalsIgnoreCase('RF Goal')){
                showLevel = 1;
            } else if (recTypeName.equalsIgnoreCase('RF DO')){
                showLevel = 2;
            } else if (recTypeName.equalsIgnoreCase('RF IR')){
                showLevel = 3;
            } else if (recTypeName.equalsIgnoreCase('RF SUB IR')){
                showLevel = 4;
            }
        } else if (objName.equalsIgnoreCase('Implementing_Mechanism__c')){
            showLevel = 1;
        } else if (objName.equalsIgnoreCase('Activity__c')){
            showLevel = 2;
        } else if (objName.equalsIgnoreCase('LF_Goal__c')){
            showLevel = 1;
        } else if (objName.equalsIgnoreCase('LF_Purpose__c')){
            showLevel = 2;
        } else if (objName.equalsIgnoreCase('LF_SubPurpose__c')){
            showLevel = 3;
        } else if (objName.equalsIgnoreCase('LF_Output__c')){
            showLevel = 4;
        } else if (objName.equalsIgnoreCase('LF_Input__c')){
            showLevel = 5;
        } else if (objName.equalsIgnoreCase('CDCSGoal__c')){
            showLevel = 1;
        } else if (objName.equalsIgnoreCase('DO__c')){
            showLevel = 2;
        } else if (objName.equalsIgnoreCase('IR__c')){
            showLevel = 3;
        } else if (objName.equalsIgnoreCase('Sub_IR__c')){
            showLevel = 4;
        }
        
    }
    
  //  public void changeToPublish(){
   
  //      system.debug('changeToPublish Record Id:::' +recId);
  //      getReportPeriod();
  //      rp.Status__c = 'Publish';
  //      upsert rp;
      //  return Cancel();
        
  //  }
    
    public void changeToClose(){
        system.debug('changeToClose Record Id:::' +recId);
         getReportPeriod();
        rp.Status__c = 'Closed';
        upsert rp;
      //  return Cancel();
    }
    
   // public void changeToDraft(){
   //     system.debug('changeToDraft Record Id:::' +recId);
   //      getReportPeriod();
   //     rp.Status__c = 'Draft';
   //     upsert rp;
      //  return Cancel();
   // }
    
   // public void changeToOpen(){
   //     system.debug('changeToOpen Record Id:::' +recId);
   //      getReportPeriod();
   //     rp.Status__c = 'Open';
        
      
   //     upsert rp;
       
       // return Cancel();
   // }
    
    public void changeToExtend(){
        system.debug('changeToExtend Record Id:::' +recId);
         getReportPeriod();
        //rp.Status__c = 'Open';
        if (rp.Close_Date__c > Date.today()){
            rp.Close_Date__c = rp.Close_Date__c.addDays(15);
        } else {
            rp.Close_Date__c = Date.today().addDays(15);
        }   
        upsert rp;
       // return Cancel();
    }
    
    public void changeToSubmit(){
        system.debug('changeToSubmit Record Id:::' +recId);
         getReportPeriod();
        rp.Status__c = 'Submitted';
        rp.Reason__c = '';
        upsert rp;
     //   return Cancel();        
    }
    
    
   //  public void changeToApproved(){
        
          /*  Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Approving request');
            req.setAction('Approve');
            getReportPeriod();
            system.debug('WRP Id:::'+rp.id);
            Id workItemId = getWorkItemId(rp.id);
            system.debug('Work Item Id:::'+workItemId);
     
            if(workItemId == null)
            {
                rp.addError('Error Occured');
                
            }
            else
            {
                req.setWorkitemId(workItemId);
                // Submit the request for approval
                Approval.ProcessResult result =  Approval.process(req);
            } */
     //       system.debug('changeToSubmit Record Id:::' +recId);
     //       getReportPeriod();
     //       rp.Status__c = 'Approved';
     //       upsert rp;
            
            
          //  return cancel();
     //   } 
     
    
    public Id getWorkItemId(Id targetObjectId)
    {
        Id retVal = null;

        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
            where p.ProcessInstance.TargetObjectId =: targetObjectId])
        {
            retVal  =  workItem.Id;
            system.debug('Ret Val'+retVal);
        }
        //system.debug('Ret Val'+retVal);
        return retVal;
    }
    
 /*   public PageReference changeToReject(){
      system.debug('changeToReject Record Id:::' +recId);
        rp.Status__c = 'Rejected';
        upsert rp; 
        return Cancel();
        
            system.debug('Reject Reason:::::1');
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Rejecting request');
            req.setAction('Reject');
            getReportPeriod();
            Id workItemId = getWorkItemId(rp.id);
            
            if(workItemId == null)
            {
                rp.addError('Error Occured');
                
            }
            else
            {
                req.setWorkitemId(workItemId);
                // Submit the request for approval
                if(rp != null){    
                Map<String,String> parameterMap = ApexPages.currentPage().getParameters();
                    if(parameterMap != null)
                    {
                      system.debug('Reject Reason:::::1');
                      for(String txtParm:parameterMap.keySet()){
                      if(txtParm.contains('rejectReasonid'))
                        {
                         system.debug('Reject Reason:::::2');
                         if(parameterMap.get(txtParm) != null && parameterMap.get(txtParm) != '')       
                           rp.Reason__c=String.valueOf(parameterMap.get(txtParm));
                           //rp.Reporting_Period_Status__c = 'Rejected';
                           system.debug('Reject Reason:::::'+parameterMap.get(txtParm));
                                  
                        }        
                      }      
                    }
                system.debug('Record to update:::::'+rp);  
                upsert rp; 
                system.debug('Reject Reason:::::4');
                }
                Approval.ProcessResult result =  Approval.process(req);
            }
            
            system.debug('Reporting Period::'+rp);
            if(rp != null){    
            Map<String,String> parameterMap = ApexPages.currentPage().getParameters();
                if(parameterMap != null)
                {
                  system.debug('Reject Reason:::::1');
                  for(String txtParm:parameterMap.keySet()){
                  if(txtParm.contains('rejectReasonid'))
                    {
                     system.debug('Reject Reason:::::2');
                     if(parameterMap.get(txtParm) != null && parameterMap.get(txtParm) != '')       
                       rp.Reason__c=String.valueOf(parameterMap.get(txtParm));
                       //rp.Reporting_Period_Status__c = 'Rejected';
                       system.debug('Reject Reason:::::'+parameterMap.get(txtParm));
                              
                    }        
                  }      
                }
            system.debug('Record to update:::::'+rp);  
            upsert rp; 
            system.debug('Reject Reason:::::4');
            }
          
           return cancel();
    } */
    
    
   
    
    
    public PageReference Cancel(){
         PageReference pageRef; 
       // pageRef = new PageReference('/' + recId); 
         pageRef= new PageReference('/apex/vfIMIndicatorResultsPage?id='+ recId);
         
          
          String currentRequestURL = URL.getCurrentRequestUrl().toExternalForm();
       pageRef=  new PageReference(currentRequestURL);
         pageRef.setRedirect(true);
         return pageRef ;     
    }
    
    
    public void getReportPeriod(){
      if(rp == null){     
              Map<String,String> parameterMap = ApexPages.currentPage().getParameters();
                  if(parameterMap != null)                    {
                       for(String reportId:parameterMap.keySet()){
                       if(reportId.contains('rptPeriod'))
                         {
                          if(parameterMap.get(reportId) != null && parameterMap.get(reportId) != '')                                                   
                            rp = (Reporting_Period__c) GU.lookup(String.valueOf(parameterMap.get(reportId)),'Reporting_Period__c');
                         }                        
                       }                      
                    }             
            }
            
    
    }
    
    
    
    @IsTest public static void testClsReportingPeriodExtension() {
  
      ClsTestUtility testIndicatorUtil = new ClsTestUtility();
      String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
      CDCSGoal__c rfGoalId = testIndicatorUtil.getRFGoalRecordForOrgId(OrgUnitId); 
      testIndicatorUtil.updateRFGoalForOrgId(OrgUnitId);
      Do__c rfDoId = testIndicatorUtil.getRFDORecordForRFGoal(rfGoalId.Id);
      IR__c rfIrId = testIndicatorUtil.getRFIRRecordForRFDO(rfDoId.Id);
      
      System.Test.setCurrentPage(new PageReference('/apex/vfRFGoalDetail'));
      ApexPages.currentPage().getParameters().put('id',rfGoalId.Id);
      ApexPages.StandardController sc5 = new ApexPages.StandardController(rfGoalId);
      ClsReportingPeriodExtension CRPE = new ClsReportingPeriodExtension(sc5);
      
      System.Test.setCurrentPage(new PageReference('/apex/vfRFDODetail'));
      ApexPages.currentPage().getParameters().put('id',rfDoId.Id);
      sc5 = new ApexPages.StandardController(rfDoId);
      CRPE = new ClsReportingPeriodExtension(sc5);
      
      System.Test.setCurrentPage(new PageReference('/apex/vfRFDOIRDetail'));
      ApexPages.currentPage().getParameters().put('id',rfIrId.Id);
      sc5 = new ApexPages.StandardController(rfIrId);
      CRPE = new ClsReportingPeriodExtension(sc5);
      
      System.Test.setCurrentPage(new PageReference('/apex/vfRFReportingPeriodNew'));
      
      List<RF_Reporting_Period__c> rpList = testIndicatorUtil.getRFReportingPeriods(rfGoalId.Id,'Goal');
      RF_Reporting_Period__c rp = rpList[0];   
    
      ApexPages.currentPage().getParameters().put('id',rp.Id);
      sc5 = new ApexPages.StandardController(rp);
      CRPE = new ClsReportingPeriodExtension(sc5);
      
      
       
      rpList = testIndicatorUtil.getRFReportingPeriods(rfDoId.Id,'Do');
      rp = rpList[0];
      ApexPages.currentPage().getParameters().put('id',rp.Id);
      sc5 = new ApexPages.StandardController(rp);
      CRPE = new ClsReportingPeriodExtension(sc5);
      
       
      rpList = testIndicatorUtil.getRFReportingPeriods(rfIrId.Id,'IR');
      rp = rpList[0];
      ApexPages.currentPage().getParameters().put('id',rp.Id);
      sc5 = new ApexPages.StandardController(rp);
      CRPE = new ClsReportingPeriodExtension(sc5);
      
      System.Test.startTest();
      Sub_IR__c rfSIrId = testIndicatorUtil.getRFSIRRecordForRFIR(rfIrId.Id); 
      rpList = testIndicatorUtil.getRFReportingPeriods(rfSIrId.Id,'SIR');
      rp = rpList[0];
      ApexPages.currentPage().getParameters().put('id',rp.Id);
      sc5 = new ApexPages.StandardController(rp);
      CRPE = new ClsReportingPeriodExtension(sc5);
      CRPE.cancel();
      
      
      System.Test.setCurrentPage(new PageReference('/apex/vfRFSubIRDetail'));
      ApexPages.currentPage().getParameters().put('id',rfSIrId.Id);
      sc5 = new ApexPages.StandardController(rfSIrId);
      CRPE = new ClsReportingPeriodExtension(sc5);
      System.Test.stopTest();
      
  }
    
  @IsTest public static void testClsReportingPeriodExtension1() {
  
      ClsTestUtility testIndicatorUtil = new ClsTestUtility();
      clsGlobalUtility gu = new clsGlobalUtility();
      String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
      String projId =  testIndicatorUtil.getProjectForOrgId(OrgUnitId);
      testIndicatorUtil.updateProjectForOrgId(OrgUnitId);
      LF_Goal__c lfGoal = testIndicatorUtil.getLFGoalRecordForProjectId(projId);
      String goalId = testIndicatorUtil.updateLFGoalForProjectId(projId);
      LF_Purpose__c lfPurpose = testIndicatorUtil.getLFPurposeRecordForLFGoal(lfGOal.Id);      
      
      
      System.Test.setCurrentPage(new PageReference('/apex/vfLFGoalDetail'));
      ApexPages.currentPage().getParameters().put('id',lfGoal.Id);
      ApexPages.StandardController sc5 = new ApexPages.StandardController(lfGoal);
      ClsReportingPeriodExtension CRPE = new ClsReportingPeriodExtension(sc5);
      
      System.Test.setCurrentPage(new PageReference('/apex/vfLFPurposeDetail'));
      ApexPages.currentPage().getParameters().put('id',lfPurpose.Id);
      sc5 = new ApexPages.StandardController(lfPurpose);
      CRPE = new ClsReportingPeriodExtension(sc5);    
      
      
      System.Test.setCurrentPage(new PageReference('/apex/vfLFReportingPeriodNew'));
      
      List<LF_Reporting_Period__c> rpList = testIndicatorUtil.getLFReportingPeriods(lfGoal.Id,'Goal');
      LF_Reporting_Period__c rp = rpList[0];   
      ApexPages.currentPage().getParameters().put('id',rp.Id);
      sc5 = new ApexPages.StandardController(rp);
      CRPE = new ClsReportingPeriodExtension(sc5);
      
      
       
      rpList = testIndicatorUtil.getLFReportingPeriods(lfPurpose.Id,'Purpose');
      rp = rpList[0];
      ApexPages.currentPage().getParameters().put('id',rp.Id);
      sc5 = new ApexPages.StandardController(rp);
      CRPE = new ClsReportingPeriodExtension(sc5);
      
       
      
      
      System.Test.startTest();
      LF_SubPurpose__c lfSubPurpose = testIndicatorUtil.getLFSubPurposeRecordForLFPurpose(lfPurpose.Id);
      rpList = testIndicatorUtil.getLFReportingPeriods(lfSubPurpose.Id,'SubPurpose');
      rp = rpList[0];
      //String navigationLink = gu.createBreadCrumps(rp.id);
      ApexPages.currentPage().getParameters().put('id',rp.Id);
      sc5 = new ApexPages.StandardController(rp);
      CRPE = new ClsReportingPeriodExtension(sc5);
      
      
      LF_Output__c output = testIndicatorUtil.getLFOutputRecordForLFSubPurpose(lfSubPurpose.Id); 
      rpList = testIndicatorUtil.getLFReportingPeriods(output.Id,'Output');
      rp = rpList[0];
      //String navigationLink1 = gu.createBreadCrumps(rp.id);
      ApexPages.currentPage().getParameters().put('id',rp.Id);
      sc5 = new ApexPages.StandardController(rp);
      CRPE = new ClsReportingPeriodExtension(sc5);
      CRPE.cancel();
      
      LF_Input__c Input = testIndicatorUtil.getLFInputRecordForLFOutput(output.Id); 
      rpList = testIndicatorUtil.getLFReportingPeriods(Input.Id,'Input');
      rp = rpList[0];
      //String navigationLink2 = gu.createBreadCrumps(rp.id);
      ApexPages.currentPage().getParameters().put('id',rp.Id);
      sc5 = new ApexPages.StandardController(rp);
      CRPE = new ClsReportingPeriodExtension(sc5);
      CRPE.cancel();
      
      System.Test.setCurrentPage(new PageReference('/apex/vfLFSubPurposeDetail'));
      ApexPages.currentPage().getParameters().put('id',lfSubPurpose.Id);
      sc5 = new ApexPages.StandardController(lfSubPurpose);
      CRPE = new ClsReportingPeriodExtension(sc5);
      
      System.Test.setCurrentPage(new PageReference('/apex/vfLFOutputDetail'));
      ApexPages.currentPage().getParameters().put('id',output.Id);
      sc5 = new ApexPages.StandardController(output );
      CRPE = new ClsReportingPeriodExtension(sc5);
            
      System.Test.setCurrentPage(new PageReference('/apex/vfLFInputDetail'));
      ApexPages.currentPage().getParameters().put('id',input.Id);
      sc5 = new ApexPages.StandardController(input);
      CRPE = new ClsReportingPeriodExtension(sc5);
      System.Test.stopTest();
      
  }  
  
  @IsTest public static void testClsReportingPeriodExtension2() {
  
      ClsTestUtility testIndicatorUtil = new ClsTestUtility();
      String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
      String projId =  testIndicatorUtil.getProjectForOrgId(OrgUnitId);
      //Implementing_Mechanism__c im = testIndicatorUtil.getIMrecordForOrgId(OrgUnitId);
       Implementing_Mechanism__c im = testIndicatorUtil.insertIMForOrgId(OrgUnitId,'Annual', 'Implementing Mechanism');
      Activity__c task = testIndicatorUtil.getTaskRecordForIMAndProject(im.Id,projId);
      //testIndicatorUtil.updateIMForOrgId(OrgUnitId,'Annual', 'Implementing Mechanism');             
      
      
      System.Test.setCurrentPage(new PageReference('/apex/vfIMIndicatorResultsPage'));
      ApexPages.currentPage().getParameters().put('id',im.Id);
      ApexPages.StandardController sc5 = new ApexPages.StandardController(im);
      ClsReportingPeriodExtension  CRPE = new ClsReportingPeriodExtension(sc5);
      
      //System.Test.setCurrentPage(new PageReference('/apex/vfLFPurposeDetail'));
      ApexPages.currentPage().getParameters().put('id',task.Id);
      sc5 = new ApexPages.StandardController(task);
      CRPE = new ClsReportingPeriodExtension(sc5); 
      
      
     
      System.Test.setCurrentPage(new PageReference('/apex/vfReportingPeriodNew'));
      System.Test.startTest();
      List<Reporting_Period__c> rpList = testIndicatorUtil.getReportingPeriods(im.Id,'IM');
      Reporting_Period__c rp = rpList[0];   
    
      ApexPages.currentPage().getParameters().put('id',rp.Id);
      sc5 = new ApexPages.StandardController(rp);
      CRPE = new ClsReportingPeriodExtension(sc5);
   //   CRPE.changeToPublish();
      CRPE.changeToClose();
   //   CRPE.changeToDraft();
      CRPE.changeToExtend();
   //   CRPE.changeToApproved();
     // CRPE.changeToSubmit();
     ClsManageIndicatorTargets cntlr = new ClsManageIndicatorTargets();
     CRPE = new ClsReportingPeriodExtension(cntlr);
      System.Test.stopTest();
       
      
      
  }
  
  
    
}