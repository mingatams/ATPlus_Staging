public with sharing class ClsManageIndicatorTargets {

    public String Cancel { get; set; }
    public string periodAction {get;set;}

    public String isReject { get; set; }
    public set<Id> ddRepIds{get;set;}
    public String changeToReject { get; set; }
    public String rejectReason { get; set; }    
    public Reporting_Period__c repPeriod {get;set;}
    public LF_Reporting_Period__c lfRepPeriod {get;set;}
    public RF_Reporting_Period__c rfRepPeriod {get;set;}
    public Reporting_Period__c repPeriod1 {get;set;}
    public LF_Reporting_Period__c lfRepPeriod1 {get;set;}
    public RF_Reporting_Period__c rfRepPeriod1 {get;set;}
    public Activity__c act{get;set;}
    public String selectedPeriod{get;set;}
    public String selectedTasks{get;set;}
    public String xmlStr{get;set;}
    public String enteredTargets {get;set;}
    public String changedRowIds {get;set;}
    public String taskValue{get;set;}
    public String closedDate {get;set;}
    public String objName{get;set;}
    public String recTypeName{get;set;}
    public String cancelVal{get;set;}
    public String dispName{get;set;}
    public String breadCrumpsStr{get;set;}
    public String ShowErrors{get;set;}
    public String Error{get;set;}
    public Boolean showResults{get;set;}    
    public OrgUnit_Indicator__c ouIndRec{get;set;}
    public OrgUnit_Indicator__c ouIndMasterRec{get;set;}
    public String uProfile{get;set;}
    public boolean hasTree{get;set;}
    public boolean reportPeriodExist{get;set;}
    public boolean taskExist{get;set;}
    public boolean isEdit{get;set;}
    public boolean isTaskExist{get;set;}
    public boolean isAORCORExist{get;set;}
    public String narative{get;set;}
    public String reason{get;set;}
    public boolean isPLTReadOnlyUser{get;set;}
    
    public boolean isSaveActionEnabled{get;set;}
    
    public String selectedPeriodName{get;set;}
    public String selectedTaskName{get;set;}
    public  List<selectOption> taskList{get;set;}
    public  List<selectOption> periodsList{get;set;}
    public String selectedPeriodValue{get;set;}
   
    clsGlobalUtility GU = new clsGlobalUtility();
   
    Map<String,IndicatorTargets> iTargetsMap = new Map<String,IndicatorTargets>();
    public String buttonId{
        get;
        set {
            buttonId = value;
            //system.debug('Button value from the controller:::' +value +':: Button Id::' +buttonId);
        }
    } 
    
 public ClsManageIndicatorTargets(Reporting_Period__c controller) {
    
    
     try {  
          // selectedPeriodName='';
          // selectedTaskName='';
            //system.debug('Selected Reporting Period::::' +selectedPeriod);            
            Id rptId= ApexPages.currentpage().getParameters().get('Lid');
            Id actId= ApexPages.currentpage().getParameters().get('actId');
          isSaveActionEnabled=false;
            periodDetermination(rptId,actId);
        
        } catch(Exception e){
          
        }
  
 }
     
    public ClsManageIndicatorTargets(ApexPages.StandardController controller) {
     try {      
        // selectedPeriodName='';
         //  selectedTaskName='';
            //system.debug('Selected Reporting Period::::' +selectedPeriod);            
            Id rptId= ApexPages.currentpage().getParameters().get('Lid');
            Id actId= ApexPages.currentpage().getParameters().get('actId');
           isSaveActionEnabled=false;
            periodDetermination(rptId,actId);
         
        } catch(Exception e){
          
        }
    }
    public ClsManageIndicatorTargets(){
       /* ClsIndicatorWizardUtility IWU = new ClsIndicatorWizardUtility();
        ClsGlobalUtility GU = new ClsGlobalUtility();
        uProfile = GU.getProfile((Id)Userinfo.getProfileId());
        system.debug('Profile Name::'+uProfile); */
       // selectedPeriodName='';
          // selectedTaskName='';
          isPLTReadOnlyUser = GU.isPLTReadOnlyUser();
           isSaveActionEnabled=false;
           isAORCORExist =false;
        Date valDate = DATE.today();
        system.debug('Selected Period::'+selectedPeriod);
        Id inputId = ApexPages.currentpage().getParameters().get('id');
        try {       
            
            List<RF_Reporting_Period__c> pListRF = new List<RF_Reporting_Period__c>([Select Id, Name, Start_Date__c, End_Date__c from RF_Reporting_Period__c Where IR_Id__c = :inputId OR Goal_Id__c = :inputId OR DO_Id__c = :inputId OR SIR_Id__c =:inputId ORDER BY Name]);        
        
            if(pListRF != null && pListRF.size() > 0){
                for(RF_Reporting_Period__c period: pListRF ){
                    //periodsList.add(new selectOption((String)period.Id, (String)period.Name));
                    if(period.Start_Date__c <= valDate && period.End_Date__c >= valDate){
                        selectedPeriod = period.Id;                        
                    } 
                }
                if(selectedPeriod == null){
                    rfRepPeriod1 = [Select Id, Name, Start_Date__c, End_Date__c from RF_Reporting_Period__c Where IR_Id__c = :inputId OR Goal_Id__c = :inputId OR DO_Id__c = :inputId OR SIR_Id__c =:inputId ORDER BY Name DESC limit 1];
                    selectedPeriod = rfRepPeriod1.Id;                      
                }
            }       
            
             List<LF_Reporting_Period__c> pList = new List<LF_Reporting_Period__c>([Select Id, Name, Start_Date__c, End_Date__c from LF_Reporting_Period__c Where LF_Goal_Id__c = :inputId OR LF_Purpose_Id__c = :inputId OR LF_SubPurpose_Id__c= :inputId OR LF_Output_Id__c =:inputId OR LF_Input_Id__c =:inputId ORDER BY Name]);        
              if(pList != null && pList.size() > 0){
                  for(LF_Reporting_Period__c period: pList){
                    //periodsList.add(new selectOption((String)period.Id, (String)period.Name));
                    if(period.Start_Date__c <= valDate && period.End_Date__c >= valDate){
                        selectedPeriod = period.Id;                        
                    } 
                  }
                  if(selectedPeriod == null){
                    lfRepPeriod1 = [Select Id, Name, Start_Date__c, End_Date__c from LF_Reporting_Period__c Where LF_Goal_Id__c = :inputId OR LF_Purpose_Id__c = :inputId OR LF_SubPurpose_Id__c= :inputId OR LF_Output_Id__c =:inputId OR LF_Input_Id__c =:inputId ORDER BY Name DESC limit 1];
                    selectedPeriod = lfRepPeriod1.Id;                    
                  } 
              }
          
          List<Reporting_Period__c> pListRP = new List<Reporting_Period__c>([Select Id, Name, Start_Date__c, End_Date__c, 
                              Reason__c, Narrative__c, Narrative_Status__c,  status__c, Implementing_Mechanism_Id__c 
                              from Reporting_Period__c Where Implementing_Mechanism_Id__c = :inputId and Id in :ddRepIds  ORDER BY Name]);        
              if(pListRP != null && pListRP .size() > 0){
                  for(Reporting_Period__c period: pListRP ){
                    //periodsList.add(new selectOption((String)period.Id, (String)period.Name));
                    if(period.Start_Date__c <= valDate && period.End_Date__c >= valDate){
                        selectedPeriod = period.Id;
                        repPeriod = period;
                    } 
                  }
                  if(selectedPeriod == null){
                    repPeriod1 = [Select Id, Name, Start_Date__c, End_Date__c,Narrative__c, Narrative_Status__c, Reason__c,
                     status__c, Implementing_Mechanism_Id__c
                    from Reporting_Period__c Where Implementing_Mechanism_Id__c = :inputId and Id in :ddRepIds ORDER BY Name DESC limit 1];
                    selectedPeriod = repPeriod1.Id;
                    repPeriod =  repPeriod1;
                  }
              }
            system.debug('Selected Reporting Period::::' +selectedPeriod);            
            Id rptId= ApexPages.currentpage().getParameters().get('Lid');
            Id actId= ApexPages.currentpage().getParameters().get('actId');
             hasTree = false;
             isEdit=false;
             
              //Id inputId = ApexPages.currentpage().getParameters().get('id');
               Implementing_Mechanism__c currentIM =[Select  Name,Reporting_Level__c,AOR__c,COR__c,Alternate_COR__c,Alternate_AOR__c from Implementing_Mechanism__c Where id =:inputId]; 
     
        if(currentIM != null && currentIM.Reporting_Level__c == 'Task'){
        isTaskExist=true;
        }else{
        isTaskExist=false;
        }
            //Cookie previousReportPeriodCookie=  ApexPages.currentPage().getCookies().get('selectedPeriod');
            periodDetermination(rptId,actId);
           
           /* if(selectedPeriod == null)
            {selectedPeriod = previousReportPeriodCookie.getValue();
            }else{
             previousReportPeriodCookie= new Cookie('selectedPeriod', selectedPeriod ,null,-1,false);
              ApexPages.currentPage().setCookies(new Cookie[]{previousReportPeriodCookie});
            }*/
               
      
       /*     cancelVal = rptId;
            objName = GU.getObjectNameById(rptId);
            if (objName.equalsIgnoreCase('Reporting_Period__c')){
                repPeriod = (Reporting_Period__c)IWU.getObjectRecordByIdAndName(rptId,'Reporting_Period__c');
                act = (Activity__c) IWU.getObjectRecordByIdAndName(actId,'Activity__c');
                recTypeName =  IWU.getReportingPeriodRecTypeName(objName,repPeriod.recordTypeId);
            } else if(objName.equalsIgnoreCase('LF_Reporting_Period__c')){
                lfRepPeriod = (LF_Reporting_Period__c)IWU.getObjectRecordByIdAndName(rptId,'LF_Reporting_Period__c');
                recTypeName =  IWU.getReportingPeriodRecTypeName(objName,lfRepPeriod.recordTypeId);
                dispName = 'LF';
            } else if(objName.equalsIgnoreCase('RF_Reporting_Period__c')){
                rfRepPeriod = (RF_Reporting_Period__c)IWU.getObjectRecordByIdAndName(rptId,'RF_Reporting_Period__c');
                recTypeName =  IWU.getReportingPeriodRecTypeName(objName,rfRepPeriod.recordTypeId);
                dispName = 'RF';
            }   
            System.debug('Reporting Period::: ' +repPeriod);
            breadCrumpsStr = IWU.getBreadcrums(rptId); 
            System.debug('BCrumps::: ' +breadCrumpsStr);
            
            System.debug('Rec Type Name::: ' +recTypeName);
            getRelatedOrgUnitIndicators(IWU);           
            if(recTypeName == 'Activity'){
                dispName = 'Task';
            } else  if (recTypeName == 'Implementing Mechanism'){
                dispName = recTypeName;
            } 
                        
            prepareTargetsXML(IWU);       */  
            
        } catch(Exception e){
           // system.debug('Manage Indicator Targets Error: -'+e.getStackTraceString());
            //e.setMessage('Could not create Indicator Targets for -'+ +'\\n'+'Error -'+e.getMessage()+' occured in class ClsManageIndicatorTargets at line number -'+e.getLineNumber() );
            //throw(e);
        }
      
    }
    
    public List<selectOption> getPeriods(){
       // System.Debug('Inside the getMissions');
       Date valDate = DATE.today();
        Id inputId = ApexPages.currentpage().getParameters().get('id');
        periodsList = new List<selectOption>();
      isAORCORExist=false;
        
        List<RF_Reporting_Period__c> pListRF = new List<RF_Reporting_Period__c>([Select Id, Name, Start_Date__c, End_Date__c from RF_Reporting_Period__c Where IR_Id__c = :inputId OR Goal_Id__c = :inputId OR DO_Id__c = :inputId OR SIR_Id__c =:inputId ORDER BY Name]);        
        
        if(pListRF != null && pListRF.size() > 0){
            for(RF_Reporting_Period__c period: pListRF ){
                periodsList.add(new selectOption((String)period.Id, (String)period.Name));
                /*if(period.Start_Date__c <= valDate && period.End_Date__c >= valDate){
                    selectedPeriod = period.Id;
                }*/
            }
        }       
        
         List<LF_Reporting_Period__c> pList = new List<LF_Reporting_Period__c>([Select Id, Name, Start_Date__c, End_Date__c from LF_Reporting_Period__c Where LF_Goal_Id__c = :inputId OR LF_Purpose_Id__c = :inputId OR LF_SubPurpose_Id__c= :inputId OR LF_Output_Id__c =:inputId OR LF_Input_Id__c =:inputId ORDER BY Name]);        
          if(pList != null && pList.size() > 0){
              for(LF_Reporting_Period__c period: pList){
                periodsList.add(new selectOption((String)period.Id, (String)period.Name));
                /*if(period.Start_Date__c <= valDate && period.End_Date__c >= valDate){
                    selectedPeriod = period.Id;
                }*/
              }
          }
      List<OrgUnit_Indicator__c> pCollectionFreqList = new List<OrgUnit_Indicator__c>([Select Collection_Frequency__c from OrgUnit_Indicator__c where Implementing_Mechanism_Id__c=:inputId]); 
       Set<String> freqSet= new Set<String>();
       
        if(pCollectionFreqList != null && pCollectionFreqList.size() > 0){
         for(OrgUnit_Indicator__c orgInd: pCollectionFreqList ){
         freqSet.add(orgInd.Collection_Frequency__c);
         }
        }
      ddRepIds = new set<Id>();  
      List<Reporting_Period__c> pListRP = new List<Reporting_Period__c>([Select Id, Name,Frequency__c, Start_Date__c, End_Date__c from Reporting_Period__c Where Implementing_Mechanism_Id__c = :inputId   ORDER BY Name]);        
         
          if(pListRP != null && pListRP .size() > 0){
          if(freqSet!= null && freqSet.size() > 0){
              for(Reporting_Period__c period: pListRP ){
              
                if(freqSet.contains(period.Frequency__c))            
                periodsList.add(new selectOption((String)period.Id, (String)period.Name));
                ddRepIds.add(period.Id);
                
                /*if(period.Start_Date__c <= valDate && period.End_Date__c >= valDate){
                    selectedPeriod = period.Id;
                }*/
              }
                }
          }
             try{
                Implementing_Mechanism__c currentIM =[Select  Name,Reporting_Level__c,AOR__c,COR__c,Alternate_COR__c,Alternate_AOR__c from Implementing_Mechanism__c Where id =:inputId];               
                if(currentIM != null && (currentIM.AOR__c != null || currentIM.COR__c != null))
                { 
                   if( (currentIM.AOR__c != null && currentIM.AOR__c == UserInfo.getUserId()) || 
                         (currentIM.COR__c != null && currentIM.COR__c == UserInfo.getUserId()) || 
                         (currentIM.Alternate_COR__c != null && currentIM.Alternate_COR__c == UserInfo.getUserId()) || 
                         (currentIM.Alternate_AOR__c != null && currentIM.Alternate_AOR__c == UserInfo.getUserId()) ){                           
                              isAORCORExist=true;
                   }else{
                              isAORCORExist=false;
                   }                  
                }
        }catch(Exception e){}
          
          
          if(periodsList != null && periodsList.size() <=0){
             periodsList=null;
              reportPeriodExist= false;
             }else{
              reportPeriodExist= true;
             }
        return periodsList;
    }
    
    
       public List<selectOption> getTasksForIM(){
       // System.Debug('Inside the getMissions');
        Id inputId = ApexPages.currentpage().getParameters().get('id');
        taskList = new List<selectOption>();
//       Implementing_Mechanism__c currentIM = new Implementing_Mechanism__c([Select  Name,Reporting_Level__c from Implementing_Mechanism__c Where id = :inputId]); 
       
        Implementing_Mechanism__c currentIM =[Select  Name,Reporting_Level__c from Implementing_Mechanism__c Where id =:inputId]; 
        
        if(currentIM != null && currentIM.Reporting_Level__c == 'Task'){
             isTaskExist=true;
          List<Activity__c> pIMTask = new List<Activity__c>([Select Id, Name,Activity_Name__c from Activity__c Where ImpMech_Id__c = :inputId  ORDER BY Name]);        
            if(pIMTask != null && pIMTask.size() > 0){              
              for(Activity__c task: pIMTask ){
                taskList.add(new selectOption((String)task.Id, (String)task.Name +' - '+(String)task.Activity_Name__c));
                 
              }
          }
          
          if(taskList != null && taskList.size() > 0){
           //taskExist = true;
          }
        }else{
          isTaskExist=false;
          //taskExist = false;
        }
   
   
        return taskList;
    }
    
    public void prepResultsTree(){
     ShowErrors='false';
    ApexPages.getMessages().clear(); 
        system.debug('Selected Reporting Period::::' +selectedPeriod);       
         Cookie previousReportPeriodCookie=  ApexPages.currentPage().getCookies().get('selectedPeriod');          
         Cookie previousTaskCookie=  ApexPages.currentPage().getCookies().get('selectedTasks');       
            if(previousReportPeriodCookie!= null)
            {   
              String preVal = previousReportPeriodCookie.getValue();
              if(preVal != null && preVal !=''){
               selectedPeriod = previousReportPeriodCookie.getValue();
               if(previousTaskCookie != null){
                //System.debug('prepResultsTree selectedTasks ::::' +selectedTasks +' *** ' + previousTaskCookie.getValue());     
               String preTask = previousTaskCookie.getValue();
               if(preTask != null && preTask !=''){
               selectedTasks= previousTaskCookie.getValue();
               }
               }
              }
            }   
        
        /*    String selPeriod='';
   Map<String,String> parameterMap = ApexPages.currentPage().getParameters();
      if(parameterMap != null)
        {
          for(String txtParm:parameterMap.keySet()){
          if(txtParm.contains('periodvalue'))
            {
             if(parameterMap.get(txtParm) != null && parameterMap.get(txtParm) != '')       
               //System.Debug('NewVal ***** ' + String.valueOf(parameterMap.get(txtParm)));    
               selPeriod=String.valueOf(parameterMap.get(txtParm));       
            }        
          }      
       }   
  
  
       if(selPeriod != null && selPeriod !=''){
       selectedPeriod =selPeriod ;
       }
       */
            // System.debug('After Actuals  Selected Reporting Period::::' +selectedPeriod);  
            if(selectedPeriod != null && selectedPeriod !='' ){  
                if(selectedTasks != null && selectedTasks !=''){
                   periodDetermination((Id)selectedPeriod, (Id)selectedTasks);
                }else{
                    periodDetermination((Id)selectedPeriod, null);
                 }
                 showResults = true;
        }
        narative='';
        if(repPeriod != null && repPeriod.Narrative__c!= null && repPeriod.Narrative__c !='')
        narative=repPeriod.Narrative__c.length() >150 ? repPeriod.Narrative__c.left(150)+'...':null;
       
      
        selectedPeriodName= getselectedPeriodName();
          selectedTaskName= getselectedTaskName();
     
          
          System.Debug('prepResultsTree selectedPeriod ***' + selectedPeriod );
      //  new Cookie('selectTabCookie', selectedPeriod ,null,-1,false);
      //  new Cookie('selectTabCookie', selectedPeriod ,null,-1,false);
       
    }
  
    
  public void prepResultsTreeChange(){
   ShowErrors='false';
    ApexPages.getMessages().clear(); 
  String selPeriod='';
   Map<String,String> parameterMap = ApexPages.currentPage().getParameters();
   System.debug('Page Parameters:::' +parameterMap);
      if(parameterMap != null)
        {
          for(String txtParm:parameterMap.keySet()){
          if(txtParm.contains('periodvalue'))
            {
             
             if(parameterMap.get(txtParm) != null && parameterMap.get(txtParm) != '')       
              // System.Debug('NewVal ***** ' + String.valueOf(parameterMap.get(txtParm))); 
              System.debug('Page Parameters:::' +parameterMap.get(txtParm));   
               selPeriod=String.valueOf(parameterMap.get(txtParm));       
            }        
          }      
       }   
  
  
  
       if(selPeriod != null && selPeriod !=''){
       selectedPeriod =selPeriod ;
       }
       if(selectedPeriod != null){
         Cookie previousReportPeriodCookie= new Cookie('selectedPeriod', selectedPeriod,null,0,false);                
         ApexPages.currentPage().setCookies(new Cookie[]{previousReportPeriodCookie}); 
         
         Cookie previousTaskCookie= new Cookie('selectedTasks', selectedTasks,null,0,false);                
         ApexPages.currentPage().setCookies(new Cookie[]{previousTaskCookie}); 
         
        /* if(selectedTasks != null && selectedTasks !='')
            periodDetermination((Id)selectedPeriod, (Id)selectedTasks );
         else   
            periodDetermination((Id)selectedPeriod, null);
         
         showResults = true;
         */
         previousReportPeriodCookie =new Cookie('selectedPeriod', selectedPeriod,null,-1,false); 
         ApexPages.currentPage().setCookies(new Cookie[]{previousReportPeriodCookie}); 
         
          previousTaskCookie= new Cookie('selectedTasks', selectedTasks,null,-1,false);                            
         ApexPages.currentPage().setCookies(new Cookie[]{previousTaskCookie}); 
         
         }else{
            Cookie previousReportPeriodCookie=  ApexPages.currentPage().getCookies().get('selectedPeriod');  
            Cookie previousTaskCookie=  ApexPages.currentPage().getCookies().get('selectedTasks');             
            if(previousReportPeriodCookie!= null)
            {   
              String preVal = previousReportPeriodCookie.getValue();
              if(preVal != null && preVal !=''){
               selectedPeriod = previousReportPeriodCookie.getValue();
              }
              String preTaskVal = previousTaskCookie.getValue();
              if(preTaskVal != null && preTaskVal !=''){                
                      selectedTasks= previousTaskCookie.getValue();
              }
               /* if(selectedPeriod != null && selectedPeriod !='' ){  
                if( selectedTasks != null && selectedTasks !=''){
                   periodDetermination((Id)selectedPeriod, (Id)selectedTasks);
                }else{
                    periodDetermination((Id)selectedPeriod, null);
                 }
                 showResults = true;
                
               }*/
            }   
         }
         System.Debug('SelectedPeriod ***** ' + selectedPeriod );
           if(selectedPeriod != null && selectedPeriod !='' ){  
                if( selectedTasks != null && selectedTasks !=''){
                   periodDetermination((Id)selectedPeriod, (Id)selectedTasks);
                }else{
                    periodDetermination((Id)selectedPeriod, null);
                 }
                 showResults = true;
                
               }
               narative='';
          if(repPeriod != null && repPeriod.Narrative__c!= null && repPeriod.Narrative__c !='')
          narative=repPeriod.Narrative__c.length() >150 ? repPeriod.Narrative__c.left(150)+'...':null;
          
          selectedPeriodName= getselectedPeriodName();
          selectedTaskName= getselectedTaskName();
            
             System.Debug('prepResultsTreeChange selectedPeriod ***' + selectedPeriod );
          
    }
    
    private String getselectedPeriodName(){
   
     String selectName='';
      if(periodsList!= null && periodsList.size() > 0){
      for(SelectOption namee:periodsList){
      System.debug('getselectPerid *** ' + namee.getValue() +'***'+selectedPeriod);
        if(namee.getValue() == selectedPeriod){
         // System.Debug('SelecteName ***  ' + namee.getLabel());
          selectName=namee.getLabel();
          //selectedPeriodValue=namee.getValue();
          //selectedPeriod=namee.getValue(); 
          // System.Debug('getselectedPeriodName selectedPeriod ***' + selectedPeriod );
          
          //ApexPages.currentpage().getParameters().put('periodvalue',selectedPeriod);      
         
          
        }
       }
      }
      return selectName;
    }
    
    private String getselectedPeriodIdValue(String pName){
   
     String selectName='';
      if(periodsList!= null && periodsList.size() > 0){
      for(SelectOption namee:periodsList){
      System.debug('getselectPerid *** ' + namee.getValue() +'***'+selectedPeriod);
        if(namee.getLabel() == pName){
         // System.Debug('SelecteName ***  ' + namee.getLabel());
          selectName=namee.getValue();
                
         
          
        }
       }
      }
      return selectName;
    }
    
   
    
     private String getselectedTaskName(){
     String selectName='';
     if(taskList != null && taskList.size() > 0){
      for(SelectOption namee:taskList){
        if(namee.getValue() == selectedTasks){
          //System.Debug('SelecteName ***  ' + namee.getLabel());
          selectName=namee.getLabel();
           
         
         
        }
       }
      }
      return selectName;
    }
    
    public void periodDetermination(Id rptId,Id actId){
   
        ClsIndicatorWizardUtility IWU = new ClsIndicatorWizardUtility();
        ClsGlobalUtility GU = new ClsGlobalUtility();
        uProfile = GU.getProfile((Id)Userinfo.getProfileId());
        //system.debug('Profile Name::'+uProfile);
        Id inputId = ApexPages.currentpage().getParameters().get('id');         
        if (inputId == null){
            cancelVal = rptId;
        } else { cancelVal = inputId;}  
        objName = GU.getObjectNameById(rptId);
        if (objName.equalsIgnoreCase('Reporting_Period__c')){
            repPeriod = (Reporting_Period__c)IWU.getObjectRecordByIdAndName(rptId,'Reporting_Period__c');
            act = (Activity__c) IWU.getObjectRecordByIdAndName(actId,'Activity__c');
            recTypeName =  IWU.getReportingPeriodRecTypeName(objName,repPeriod.recordTypeId);
        } else if(objName.equalsIgnoreCase('LF_Reporting_Period__c')){
            lfRepPeriod = (LF_Reporting_Period__c)IWU.getObjectRecordByIdAndName(rptId,'LF_Reporting_Period__c');
            recTypeName =  IWU.getReportingPeriodRecTypeName(objName,lfRepPeriod.recordTypeId);
            dispName = 'LF';
        } else if(objName.equalsIgnoreCase('RF_Reporting_Period__c')){
       
            rfRepPeriod = (RF_Reporting_Period__c)IWU.getObjectRecordByIdAndName(rptId,'RF_Reporting_Period__c');
            recTypeName =  IWU.getReportingPeriodRecTypeName(objName,rfRepPeriod.recordTypeId);
            dispName = 'RF';
        }  
       
        //System.debug('Reporting Period::: ' +repPeriod);
        breadCrumpsStr = IWU.getBreadcrums(rptId); 
        //System.debug('BCrumps::: ' +breadCrumpsStr);
        
        //System.debug('Rec Type Name::: ' +recTypeName);
        getRelatedOrgUnitIndicators(IWU);           
        if(recTypeName == 'Activity'){
            dispName = 'Task';
        } else  if (recTypeName == 'Implementing Mechanism'){
            dispName = recTypeName;
        } 
               if(selectedPeriod == null)
           selectedPeriod = rptId;
           
           if(selectedTasks == null) 
              selectedTasks= actId;
        
        if(selectedPeriod==null ||  selectedPeriod == '' ){
         hasTree = false;
        }else{
         hasTree = true;
        }
        ApexPages.currentpage().getParameters().put('selectedPeriod',selectedPeriod);      
         ApexPages.currentpage().getParameters().put('selectedTasks',selectedTasks);  
         
        prepareTargetsXML(IWU);
    }
    
    public void prepareTargetsXML(ClsIndicatorWizardUtility IWU){
        IWU.initializeXML();
        IWU.profileFinder();
        Map<String,OrgUnit_Indicator__c> orgUnitIndsMap = IWU.getOUIndsWithOUIndIdAsKey(null,'Indicator');
        Map<String, Indicator_Results__c> iResultsMap = new Map<String, Indicator_Results__c>();//IWU.getIndicatorResultsByRepPeriodId(repPeriod.Id);
        Map<String, LF_Indicator_Result__c> lfiResultsMap = new Map<String, LF_Indicator_Result__c>();
        Map<String, RF_Indicator_Result__c> rfiResultsMap = new Map<String, RF_Indicator_Result__c>();
          
        if(orgUnitIndsMap.isEmpty()  && ! objName.equalsIgnoreCase('Reporting_Period__c')){
            showErrors = 'true';
            hasTree = false;
            ApexPages.getMessages().clear();           
               
            
            //system.debug('Record Type::::'+recTypeName);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Indicators are not defined for the selected '+recTypeName+'. Please select indicators to proceed.'));
        } else {
            showErrors = 'false';
            hasTree = true;
        }
        //System.Debug('ShowErrors ***  ' + showErrors);
        if (objName.equalsIgnoreCase('Reporting_Period__c')){
            String andStr;
            if (repPeriod.Reporting_Level__c == 'Task'){
                andStr = ' AND Activity_Id__c = \''+ act.Id +'\' ';             
            } else {
                andStr = ' AND Implementing_Mechanism_Id__c = \''+ repPeriod.Implementing_Mechanism_Id__c +'\' ';
            }   
            iResultsMap = IWU.getIndicatorResultsByRepPeriodId(repPeriod.Id,andStr);
            
            for(OrgUnit_Indicator__c oInd: orgUnitIndsMap.values()){
                prepReportingPeriodIndicators(IWU,iResultsMap,oInd,'Indicator');
                Map<String, OrgUnit_Indicator__c> orgUnitSubIndMap = IWU.getOUIndsWithOUIndIdAsKey(oInd.indCode__c,'Sub Indicator');
                for(OrgUnit_Indicator__c oSInd: orgUnitSubIndMap.values()){
                    prepReportingPeriodIndicators(IWU,iResultsMap,oSInd,'Sub Indicator');
                    IWU.terminateRow();
                }
                IWU.terminateRow();
            }                   
        } else if (objName.equalsIgnoreCase('LF_Reporting_Period__c')){
            lfiResultsMap = IWU.getIndicatorResultsByLFRepPeriodId(lfRepPeriod.Id);
            for(OrgUnit_Indicator__c oInd: orgUnitIndsMap.values()){
                prepLFReportingPeriodIndicators(IWU,lfiResultsMap,oInd,'Indicator');
                Map<String, OrgUnit_Indicator__c> orgUnitSubIndMap = IWU.getOUIndsWithOUIndIdAsKey(oInd.indCode__c,'Sub Indicator');
                for(OrgUnit_Indicator__c oSInd: orgUnitSubIndMap.values()){
                    prepLFReportingPeriodIndicators(IWU,lfiResultsMap,oSInd,'Sub Indicator');
                    IWU.terminateRow();
                }
                IWU.terminateRow();
            }           
        } else if (objName.equalsIgnoreCase('RF_Reporting_Period__c')){
            rfiResultsMap = IWU.getIndicatorResultsByRFRepPeriodId(rfRepPeriod.Id);
            for(OrgUnit_Indicator__c oInd: orgUnitIndsMap.values()){
                prepRFReportingPeriodIndicators(IWU,rfiResultsMap,oInd,'Indicator');
                Map<String, OrgUnit_Indicator__c> orgUnitSubIndMap = IWU.getOUIndsWithOUIndIdAsKey(oInd.indCode__c,'Sub Indicator');
                for(OrgUnit_Indicator__c oSInd: orgUnitSubIndMap.values()){
                    prepRFReportingPeriodIndicators(IWU,rfiResultsMap,oSInd,'Sub Indicator');
                    IWU.terminateRow();
                }
                IWU.terminateRow();
            }               
        }
        
    /*  for(OrgUnit_Indicator__c oInd: orgUnitIndsMap.values()){
            if (iResultsMap.containsKey(oInd.Id)){
                Indicator_Results__c iResult = iResultsMap.get((String)oInd.Id);
                if (oInd.Custom__c){
                    IWU.getTargetsXMLString('Custom Indicator', oInd, iResult); 
                } else {
                    IWU.getTargetsXMLString('Indicator', oInd, iResult);    
                }               
            } else {
                if (oInd.Custom__c){
                    IWU.getTargetsXMLString('Custom Indicator', oInd, null);    
                } else {
                    IWU.getTargetsXMLString('Indicator', oInd, null);   
                }
            }
            Map<String, OrgUnit_Indicator__c> orgUnitSubIndMap = IWU.getOUIndsWithOUIndIdAsKey(oInd.indCode__c,'Sub Indicator');
            for(OrgUnit_Indicator__c oSInd: orgUnitSubIndMap.values()){
                if (iResultsMap.containsKey(oSInd.Id)){
                    Indicator_Results__c iSResult = iResultsMap.get((String)oSInd.Id);                      
                    if (oInd.Custom__c){
                        IWU.getTargetsXMLString('Custom Sub Indicator', oSInd, iSResult);   
                    } else {
                        IWU.getTargetsXMLString('Sub Indicator', oSInd, iSResult);  
                    }                                   
                } else {                    
                    if (oInd.Custom__c){
                        IWU.getTargetsXMLString('Custom Sub Indicator', oSInd, null);   
                    } else {
                        IWU.getTargetsXMLString('Sub Indicator', oSInd, null);  
                    }
                }
                IWU.terminateRow();
            }
            IWU.terminateRow();
        } */
        
        IWU.terminateXML();
        xmlStr = IWU.getXMLString();
        xmlStr = xmlStr.replaceAll('\'','');
       
        system.debug('XML String so far:;;' +xmlStr);
    }
    
   private void prepReportingPeriodIndicators(ClsIndicatorWizardUtility IWU, Map<String, Indicator_Results__c> iResultsMap, OrgUnit_Indicator__c oInd, String indType ){
        
        if (indType.equalsIgnoreCase('Indicator')){
            if (iResultsMap.containsKey(oInd.Id)){
                Indicator_Results__c iResult = iResultsMap.get((String)oInd.Id);
                if (oInd.Custom__c){
                    IWU.getTargetsXMLString('Custom Indicator', oInd, iResult,null,null,objName,uProfile,repPeriod);   
                } else {
                    IWU.getTargetsXMLString('Indicator', oInd, iResult,null,null,objName,uProfile,repPeriod);  
                }               
            } else {
                if (oInd.Custom__c){
                    IWU.getTargetsXMLString('Custom Indicator', oInd, null,null,null,objName,uProfile,repPeriod);  
                } else {
                    IWU.getTargetsXMLString('Indicator', oInd, null,null,null,objName,uProfile,repPeriod); 
                } 
            }   
        } else if (indType.equalsIgnoreCase('Sub Indicator')){
            if (iResultsMap.containsKey(oInd.Id)){
                Indicator_Results__c iSResult = iResultsMap.get((String)oInd.Id);                       
                if (oInd.Custom__c){
                    IWU.getTargetsXMLString('Custom Sub Indicator', oInd, iSResult,null,null,objName,uProfile,repPeriod);  
                } else {
                    IWU.getTargetsXMLString('Sub Indicator', oInd, iSResult,null,null,objName,uProfile,repPeriod); 
                }                                   
            } else {                    
                if (oInd.Custom__c){
                    IWU.getTargetsXMLString('Custom Sub Indicator', oInd, null,null,null,objName,uProfile,repPeriod);  
                } else {
                    IWU.getTargetsXMLString('Sub Indicator', oInd, null,null,null,objName,uProfile,repPeriod); 
                }
            }           
        }       
    }
    
    private void prepLFReportingPeriodIndicators(ClsIndicatorWizardUtility IWU, Map<String, LF_Indicator_Result__c> lfiResultsMap, OrgUnit_Indicator__c oInd, String indType){
        
        if (indType.equalsIgnoreCase('Indicator')){
            if (lfiResultsMap.containsKey(oInd.Id)){
                LF_Indicator_Result__c iResult = lfiResultsMap.get((String)oInd.Id);
                if (oInd.Custom__c){
                    IWU.getTargetsXMLString('Custom Indicator', oInd, null,iResult, null, objName,uProfile); 
                } else {
                    IWU.getTargetsXMLString('Indicator', oInd, null,iResult, null, objName,uProfile);    
                }               
            } else {
                if (oInd.Custom__c){
                    IWU.getTargetsXMLString('Custom Indicator', oInd, null,null, null, objName,uProfile);    
                } else {
                    IWU.getTargetsXMLString('Indicator', oInd, null,null, null, objName,uProfile);   
                }
            }   
        } else if(indType.equalsIgnoreCase('Sub Indicator')){
            if (lfiResultsMap.containsKey(oInd.Id)){
                LF_Indicator_Result__c iSResult = lfiResultsMap.get((String)oInd.Id);                       
                if (oInd.Custom__c){
                    IWU.getTargetsXMLString('Custom Sub Indicator', oInd, null,iSResult, null, objName,uProfile);    
                } else {
                    IWU.getTargetsXMLString('Sub Indicator', oInd, null, iSResult,null,objName,uProfile);    
                }                                   
            } else {                    
                if (oInd.Custom__c){
                    IWU.getTargetsXMLString('Custom Sub Indicator', oInd, null,null, null, objName,uProfile);    
                } else {
                    IWU.getTargetsXMLString('Sub Indicator', oInd, null,null, null, objName,uProfile);   
                }
            }
        }       
    } 
    
    private void prepRFReportingPeriodIndicators(ClsIndicatorWizardUtility IWU, Map<String, RF_Indicator_Result__c> rfiResultsMap, OrgUnit_Indicator__c oInd, String indType){
        if (indType.equalsIgnoreCase('Indicator')){
            if (rfiResultsMap.containsKey(oInd.Id)){
                RF_Indicator_Result__c iResult = rfiResultsMap.get((String)oInd.Id);
                if (oInd.Custom__c){
                    IWU.getTargetsXMLString('Custom Indicator', oInd, null,null,iResult,objName,uProfile);   
                } else {
                    IWU.getTargetsXMLString('Indicator', oInd, null,null,iResult,objName,uProfile);  
                }               
            } else {
                if (oInd.Custom__c){
                    IWU.getTargetsXMLString('Custom Indicator', oInd, null,null,null,objName,uProfile);  
                } else {
                    IWU.getTargetsXMLString('Indicator', oInd, null,null,null,objName,uProfile); 
                }
            }       
        } else if(indType.equalsIgnoreCase('Sub Indicator')){
            if (rfiResultsMap.containsKey(oInd.Id)){
                RF_Indicator_Result__c iSResult = rfiResultsMap.get((String)oInd.Id);                       
                if (oInd.Custom__c){
                    IWU.getTargetsXMLString('Custom Sub Indicator', oInd, null,null,iSResult,objName,uProfile);  
                } else {
                    IWU.getTargetsXMLString('Sub Indicator', oInd, null,null,iSResult,objName,uProfile); 
                }                                   
            } else {                    
                if (oInd.Custom__c){
                    IWU.getTargetsXMLString('Custom Sub Indicator', oInd, null,null,null,objName,uProfile);  
                } else {
                    IWU.getTargetsXMLString('Sub Indicator', oInd, null,null,null,objName,uProfile); 
                }
            }
        }
            
    }
    
    public PageReference doSaveTargets(){
    
    System.debug('Do Save Target Inside ***** ');
          isSaveActionEnabled=true;
        //system.debug('Changed Row Ids:::' +changedRowIds);
        //system.debug('Changed XML String::::' +xmlStr);
       // system.debug('Activity Record:::' +act);
        List<Indicator_Results__c> resultsToUpsert = new List<Indicator_Results__c>();
        List<Indicator_Results__c> resultsToDelete = new List<Indicator_Results__c>();
        List<LF_Indicator_Result__c> lfResultsToUpsert = new List<LF_Indicator_Result__c>();
        List<LF_Indicator_Result__c> lfResultsToDelete = new List<LF_Indicator_Result__c>();
        List<RF_Indicator_Result__c> rfResultsToUpsert = new List<RF_Indicator_Result__c>();
        List<RF_Indicator_Result__c> rfResultsToDelete = new List<RF_Indicator_Result__c>();
        Set<OrgUnit_Indicator__c> oIndSet = new Set<OrgUnit_Indicator__c>();
        List<OrgUnit_Indicator__c> oIndList = new List<OrgUnit_Indicator__c>();
        ClsIndicatorWizardUtility IWU = new ClsIndicatorWizardUtility();
        getRelatedOrgUnitIndicators(IWU);
        
        Map<String,OrgUnit_Indicator__c> orgUnitIndsMap = IWU.getOUIndsWithOUIndIdAsKey(null,'All');
        Map<String, Indicator_Results__c> iResultsMap = new Map<String, Indicator_Results__c>();
        Map<String, LF_Indicator_Result__c> lfiResultsMap = new Map<String, LF_Indicator_Result__c>();
        Map<String, RF_Indicator_Result__c> rfiResultsMap = new Map<String, RF_Indicator_Result__c>();
       // string buttonId = apexpages.currentpage().getparameters().get('buttonId');
       // system.debug('Button Id Value:::'+buttonId);
        if (objName.equalsIgnoreCase('Reporting_Period__c')){
            String andStr;
            if (repPeriod.Reporting_Level__c == 'Task'){
                andStr = ' AND Activity_Id__c = \''+ act.Id +'\' ';             
            } else {
                andStr = ' AND Implementing_Mechanism_Id__c = \''+ repPeriod.Implementing_Mechanism_Id__c +'\' ';
            }   
            System.debug('Selected Period From Save::'+selectedPeriod);
            
              repPeriod= (Reporting_Period__c)IWU.getObjectRecordByIdAndName(getselectedPeriodIdValue(selectedPeriodName),'Reporting_Period__c');
              iResultsMap = IWU.getIndicatorResultsByRepPeriodId(repPeriod.Id,andStr);
        } else if (objName.equalsIgnoreCase('LF_Reporting_Period__c')){
             lfRepPeriod= (LF_Reporting_Period__c)IWU.getObjectRecordByIdAndName(selectedPeriod,'LF_Reporting_Period__c');
               lfiResultsMap = IWU.getIndicatorResultsByLFRepPeriodId(lfRepPeriod.Id);
        } else if (objName.equalsIgnoreCase('RF_Reporting_Period__c')){       
            rfRepPeriod = (RF_Reporting_Period__c)IWU.getObjectRecordByIdAndName(selectedPeriod,'RF_Reporting_Period__c');
              rfiResultsMap = IWU.getIndicatorResultsByRFRepPeriodId(rfRepPeriod.Id); 
        }
        
        parse(xmlStr);
        List<String> chndIds = changedRowIds.split(',');
        if (chndIds.size() == 0){
            chndIds.add(changedRowIds);
        }
        set<Id> oindIds = new Set<Id>();
        set<Id> oindMasterIds = new Set<Id>(); 
        Map<Id,OrgUnit_Indicator__c> nOindMap = new Map<Id,OrgUnit_Indicator__c>();
        Map<Id,OrgUnit_Indicator__c> nMasterOindMap = new Map<Id,OrgUnit_Indicator__c>();
         
        for(String cId: chndIds){
            if (iTargetsMap.containsKey(cId)){              
                IndicatorTargets iTree = iTargetsMap.get(cId);
                oindIds.add((Id)iTree.rowId);                              
            }
        }
        if (!oindIds.isEmpty()){
            for(Sobject sobj: GU.lookup(oindIds,'Id','OrgUnit_Indicator__c')){
                OrgUnit_Indicator__c tempOi = (OrgUnit_Indicator__c)sobj;                
                nOindMap.put(tempOi.Id,tempOi);
                oindMasterIds.add(tempOi.Organization_Indicator_Id__c);  
            }
        }
        if (!oindMasterIds.isEmpty()){
            for(Sobject sobj: GU.lookup(oindMasterIds,'Id','OrgUnit_Indicator__c')){
                OrgUnit_Indicator__c tempOi = (OrgUnit_Indicator__c)sobj;                
                nMasterOindMap.put(tempOi.Id,tempOi);
            }
        }
        
        for(String cId: chndIds){
            Indicator_Results__c iResultnew = new Indicator_Results__c();
            LF_Indicator_Result__c lfiResultnew = new LF_Indicator_Result__c();
            RF_Indicator_Result__c rfiResultnew = new RF_Indicator_Result__c();
            
            if (iTargetsMap.containsKey(cId)){              
                IndicatorTargets iTree = iTargetsMap.get(cId);
                //OrgUnit_Indicator__c oi = new OrgUnit_Indicator__c();
                //OrgUnit_Indicator__c oim = new OrgUnit_Indicator__c();
                ouIndRec = nOindMap.containsKey(iTree.rowId) ? nOindMap.get(iTree.rowId) : null ;                
                ouIndMasterRec = nMasterOindMap.containsKey(ouIndRec.Organization_Indicator_Id__c) ? nMasterOindMap.get(ouIndRec.Organization_Indicator_Id__c) : null ;                
              //  ouIndRec = (OrgUnit_Indicator__c)IWU.getObjectRecordByIdAndName(iTree.rowId,'OrgUnit_Indicator__c');
              //  ouIndMasterRec = (OrgUnit_Indicator__c)IWU.getObjectRecordByIdAndName(ouIndRec.Organization_Indicator_Id__c,'OrgUnit_Indicator__c');
                if (objName.equalsIgnoreCase('Reporting_Period__c')){
                    if (iResultsMap.containsKey(cId)){
                        iResultnew = iResultsMap.get(cId);
                        if((String.isEmpty(iTree.baseLine))  && (String.isEmpty(iTree.notes)) && (String.isEmpty(iTree.target)) && (String.isEmpty(iTree.actual))){
                        resultsToDelete.add(iResultnew);
                        }else{
                        resultsToUpsert.add(prepareIndicatorResultsInsertUpdate(iTree, iResultNew, repPeriod,true,ouIndMasterRec));
                        }
                    }   else {
                        resultsToUpsert.add(prepareIndicatorResultsInsertUpdate(iTree, iResultNew, repPeriod,false,ouIndMasterRec));
                    }    
                    if((iTree.target != null) && !((String)iTree.target).isAlphaSpace()){   
                        repPeriod.Targets_Established__c = true;
                    }
                    repPeriod.Results_Established__c = true;
                } else if (objName.equalsIgnoreCase('LF_Reporting_Period__c')){
                    if (lfiResultsMap.containsKey(cId)){
                        lfiResultnew = lfiResultsMap.get(cId);
                        if((String.isEmpty(iTree.baseLine))  && (String.isEmpty(iTree.notes)) && (String.isEmpty(iTree.target)) && (String.isEmpty(iTree.actual))){
                        lfResultsToDelete.add(lfiResultnew);
                        }else{
                        lfResultsToUpsert.add(prepareLFIndicatorResultsInsertUpdate(iTree, lfiResultNew, lfRepPeriod,true,ouIndMasterRec));
                    }}   else {
                        lfResultsToUpsert.add(prepareLFIndicatorResultsInsertUpdate(iTree, lfiResultNew, lfRepPeriod,false,ouIndMasterRec));
                    }
                    if((iTree.target != null) && !((String)iTree.target).isAlphaSpace()){
                        lfRepPeriod.Targets_Established__c = true;
                    }   
                    lfRepPeriod.Results_Established__c = true;
                } else if (objName.equalsIgnoreCase('RF_Reporting_Period__c')){
                    if (rfiResultsMap.containsKey(cId)){
                        rfiResultnew = rfiResultsMap.get(cId);
                        if((String.isEmpty(iTree.baseLine))  && (String.isEmpty(iTree.notes)) && (String.isEmpty(iTree.target)) && (String.isEmpty(iTree.actual))){
                        rfResultsToDelete.add(rfiResultnew);
                        }else{
                        rfResultsToUpsert.add(prepareRFIndicatorResultsInsertUpdate(iTree, rfiResultNew, rfRepPeriod,true,ouIndMasterRec));
                    }}   else {
                        rfResultsToUpsert.add(prepareRFIndicatorResultsInsertUpdate(iTree, rfiResultNew, rfRepPeriod,false,ouIndMasterRec));
                    }
                    if(!(String.isEmpty(iTree.target)) && !((String)iTree.target).isAlphaSpace()){
                        rfRepPeriod.Targets_Established__c = true;
                    } 
                    rfRepPeriod.Results_Established__c = true;  
                }
                
              /*  if(!(String.isEmpty(iTree.target)) && !((String)iTree.target).isAlphaSpace()){
                    ouIndRec.Targets_Established__c = true;
                    ouIndMasterRec.Targets_Established__c = true;
                }
                if(!(String.isEmpty(iTree.Actual)) && !((String)iTree.Actual).isAlphaSpace()){
                    ouIndRec.Actuals_Recorded__c = true;
                    ouIndMasterRec.Actuals_Recorded__c = true;
                }
                ouIndRec.Results_Established__c = true;
                ouIndMasterRec.Results_Established__c = true; 
                oIndSet.add(ouIndRec);
                oIndSet.add(ouIndMasterRec); */
            }   
        }  
        
      /*  if (!oIndSet.isEmpty()){
            oIndList.addAll(oIndSet);
            ApplicationConstants.bypassIMSharingRulesTriggerLogic = true;
            ApplicationConstants.bypassIMCreateVendorTriggerLogic = true;
            ApplicationConstants.bypassOrgUnitIndicatorUpsertShare = true;
            ApplicationConstants.bypassReportingPeriodApprovalLogic = true;
            ApplicationConstants.bypassOrganizationIndicatorBeforeUpsertQOwner = true;
            upsert oIndList;
            
            ApplicationConstants.bypassIMSharingRulesTriggerLogic = false;
            ApplicationConstants.bypassIMCreateVendorTriggerLogic = false;
            ApplicationConstants.bypassOrgUnitIndicatorUpsertShare = false;
            ApplicationConstants.bypassReportingPeriodApprovalLogic = false;
            ApplicationConstants.bypassOrganizationIndicatorBeforeUpsertQOwner = false; 
        } */
        if (objName.equalsIgnoreCase('Reporting_Period__c')  ){
            if (resultsToUpsert != null && resultsToUpsert.size() > 0){
                //System.debug('Results Before Upsert::' +resultsToUpsert);
                ApplicationConstants.bypassIMSharingRulesTriggerLogic = true;
                ApplicationConstants.bypassIMCreateVendorTriggerLogic = true;
                ApplicationConstants.bypassOrgUnitIndicatorUpsertShare = true;
                ApplicationConstants.bypassReportingPeriodApprovalLogic = true;          
                ApplicationConstants.bypassOrganizationIndicatorBeforeUpsertQOwner = true;
                ApplicationConstants.bypassReportingPeriodBeforeUpsertQOwner = true;
                
                upsert resultsToUpsert;
                // upsert repPeriod;
                if (periodAction != null && periodAction.equalsIgnoreCase('Submit') ){
                    changeToSubmit();
                } else if(periodAction != null && periodAction.equalsIgnoreCase('Publish')) {
                    changeToPublish();
                } else if(periodAction != null && periodAction.equalsIgnoreCase('Internal Approval')){
                    changeToImported();
                } else {
                    upsert repPeriod;
                }
                
                ApplicationConstants.bypassIMSharingRulesTriggerLogic = false;
                ApplicationConstants.bypassIMCreateVendorTriggerLogic = false;
                ApplicationConstants.bypassOrgUnitIndicatorUpsertShare = false;
                ApplicationConstants.bypassReportingPeriodApprovalLogic = false;
                ApplicationConstants.bypassOrganizationIndicatorBeforeUpsertQOwner = false;
                ApplicationConstants.bypassReportingPeriodBeforeUpsertQOwner = false;
            } else {
                if (periodAction != null && periodAction.equalsIgnoreCase('Submit') ){
                    changeToSubmit();
                } else if(periodAction != null && periodAction.equalsIgnoreCase('Publish')) {
                    changeToPublish();
                } else if(periodAction != null && periodAction.equalsIgnoreCase('Internal Approval')){
                    changeToImported();
                } else {
                    upsert repPeriod;
                }
            }    
           selectedPeriod = repPeriod.Id; 
        } else if (objName.equalsIgnoreCase('LF_Reporting_Period__c') && lfresultsToUpsert != null && lfresultsToUpsert.size() > 0){
            upsert lfResultsToUpsert;
            upsert lfRepPeriod;
        } else if (objName.equalsIgnoreCase('RF_Reporting_Period__c') && rfresultsToUpsert != null && rfresultsToUpsert.size() > 0){
            upsert rfResultsToUpsert;
            upsert rfRepPeriod;
        }
        
        
        if (objName.equalsIgnoreCase('Reporting_Period__c') && resultsToDelete != null && resultsToDelete.size() > 0){
            //System.debug('Results Before Upsert::' +resultsToDelete);
            delete resultsToDelete;
            //upsert repPeriod;
        }
        if (objName.equalsIgnoreCase('LF_Reporting_Period__c') && lfResultsToDelete != null && lfResultsToDelete.size() > 0){
            //System.debug('Results Before Upsert::' +lfResultsToDelete);
            delete lfResultsToDelete;
            //upsert repPeriod;
        }
        if (objName.equalsIgnoreCase('RF_Reporting_Period__c') && rfResultsToDelete != null && rfResultsToDelete.size() > 0){
            //System.debug('Results Before Upsert::' +rfResultsToDelete);
            delete rfResultsToDelete;
        }
        /*if(ouIndRec != null){
        upsert ouIndRec;
        }
        if(ouIndMasterRec!= null){
        upsert ouIndMasterRec;
        }*/
        
        //PageReference ref = new PageReference('/apex/vfManageIndicatorTargets?Lid=' + repPeriod.Id);
        PageReference ref;
        Id inputId = ApexPages.currentpage().getParameters().get('id'); 
       // if  (buttonId.equalsIgnoreCase('save')){
       
       if (objName.equalsIgnoreCase('Reporting_Period__c')){
            if (repPeriod.Reporting_Level__c == 'Task'){
                ref = new PageReference('/apex/vfManageIndicatorTargets?Lid=' + repPeriod.Id +'&actId='+act.Id); 
            } else {
               // ref = new PageReference('/apex/vfManageIndicatorTargets?Lid=' + repPeriod.Id);
               ref = new PageReference('/apex/vfIMIndicatorReportingDetails?id=' + inputId);
            }            
        } else if (objName.equalsIgnoreCase('LF_Reporting_Period__c')){
            if (inputId == null){
                ref = new PageReference('/apex/vfManageIndicatorTargets?Lid=' + lfRepPeriod.Id);
            } else {   ref = new PageReference('/' + inputId);} 
        } else if (objName.equalsIgnoreCase('RF_Reporting_Period__c')){
           // Id inputId = ApexPages.currentpage().getParameters().get('id');         
            if (inputId == null){
                ref = new PageReference('/apex/vfManageIndicatorTargets?Lid=' + rfRepPeriod.Id);
            } else { ref = new PageReference('/' + inputId);}
            
        }
        
        
        
       // ref = new PageReference('/apex/vfIMIndicatorReportingDetails?id=' + inputId);
       //ref=  new PageReference('/'+inputId);
     
       String currentRequestURL = URL.getCurrentRequestUrl().toExternalForm();
      // ref=  new PageReference(currentRequestURL+'&previousPeriod='+selectedPeriod+'&previousTask='+selectedTasks+'&selectedPeriodSaved=true&sfdc.override=1');
         
        //}
        
       /* if(buttonId.equalsIgnoreCase('saveClose')){
        ref = new PageReference(currentRequestURL +'/'+cancelVal); 
        }*/
        ref.setRedirect(true);    
        
       
       //  System.Debug('Selecte Report Period **** ' + selectedTasks);
       /* if(repPeriod != null && repPeriod.Id!=null)
        selectedPeriod = repPeriod.Id;      
        if( act != null &&  act.Id != null)
        selectedTasks= act.Id;      */
        
       /* Cookie previousReportPeriodCookie=  ApexPages.currentPage().getCookies().get('selectedPeriod');  
        Cookie previousTaskCookie=  ApexPages.currentPage().getCookies().get('selectedTasks'); 
        if (previousReportPeriodCookie != null){
            previousReportPeriodCookie= new Cookie('selectedPeriod', selectedPeriod,null,0,false);                
             ApexPages.currentPage().setCookies(new Cookie[]{previousReportPeriodCookie}); 
        }     
        
        if (previousTaskCookie != null){ 
             previousTaskCookie= new Cookie('selectedTasks', selectedTasks,null,0,false);                
             ApexPages.currentPage().setCookies(new Cookie[]{previousTaskCookie});
        }
         if (previousReportPeriodCookie == null){
             previousReportPeriodCookie = new Cookie('selectedPeriod', selectedPeriod,null,-1,false);                
             ApexPages.currentPage().setCookies(new Cookie[]{previousReportPeriodCookie});
         }        
         if (previousTaskCookie == null){ 
             previousTaskCookie= new Cookie('selectedTasks', selectedTasks,null,-1,false);                
             ApexPages.currentPage().setCookies(new Cookie[]{previousTaskCookie});
         }    */ 
         
        Cookie  previousReportPeriodCookie = new Cookie('selectedPeriod', selectedPeriod,null,-1,false);                
             ApexPages.currentPage().setCookies(new Cookie[]{previousReportPeriodCookie});
         Cookie    previousTaskCookie= new Cookie('selectedTasks', selectedTasks,null,-1,false);                
             ApexPages.currentPage().setCookies(new Cookie[]{previousTaskCookie});
           selectedPeriodName= getselectedPeriodName();
          selectedTaskName= getselectedTaskName();
        
         return ref;
    }
    
    private Indicator_Results__c prepareIndicatorResultsInsertUpdate(IndicatorTargets iTree, Indicator_Results__c ir, 
                                                            Reporting_Period__c rp, Boolean isUpdate, OrgUnit_Indicator__c oIndMaster){
        Indicator_Results__c irNew = new Indicator_Results__c();
        if (isUpdate){
            irNew = ir;
            irNew = populateIndicatorResultDecimals(iTree,irNew);           
        } else {
            irNew = populateIndicatorResultDecimals(iTree,irNew);
            irNew.Organization_Indicator_Id__c = iTree.rowId;
        }   
        irNew.Reporting_Period_Id__c = rp.Id;
        irNew.Name = iTree.indCode;
        String recTypeName;
        if (rp.Reporting_Level__c == 'Task'){
            irNew.Activity_Id__c = act.Id;
            recTypeName = 'Task';
        } else if(rp.Reporting_Level__c == 'Implementing Mechanism'){ 
            irNew.Implementing_Mechanism_Id__c = rp.Implementing_Mechanism_Id__c;
            recTypeName = 'Implementing Mechanism';
        }   
        irNew.Organization_Indicator_Master_Id__c = oIndMaster.Id;
        irNew.Note_Comments__c = iTree.notes;
        irNew.Notes_Comments_Partner__c = iTree.partnerNotes;
        //String recTypeName = GU.getRecordType('Reporting_Period__c',rp.RecordTypeId);
        String recTypeId = GU.getRecordTypeId('Indicator_Results__c',recTypeName);
        irNew.RecordTypeId = recTypeId;
        return irNew;
    }
    
    private Indicator_Results__c populateIndicatorResultDecimals(IndicatorTargets iTree, Indicator_Results__c irNew){
        if(!(String.isEmpty(iTree.baseLine))){
            system.debug('Baseline amount::' +iTree.baseline);
            irNew.Baseline__c = decimal.valueOf(iTree.baseLine);
        } else {
            irNew.Baseline__c = null;
        }
        if(!(String.isEmpty(iTree.target))){
            irNew.Target__c = decimal.valueOf(iTree.target);    
        }else {
            irNew.Target__c = null;
        }
        if(!(String.isEmpty(iTree.actual))){
            irNew.Actual__c = decimal.valueOf(iTree.actual);    
        }else {
            irNew.Actual__c = null;
        }
        
        return irNew;
    }
    
    
    private LF_Indicator_Result__c prepareLFIndicatorResultsInsertUpdate(IndicatorTargets iTree, LF_Indicator_Result__c lfir, 
                                                    LF_Reporting_Period__c lfrp, Boolean isUpdate, OrgUnit_Indicator__c oIndMaster){
        LF_Indicator_Result__c lfirNew = new LF_Indicator_Result__c();
        if (isUpdate){
            lfirNew = lfir;
            lfirNew = populateLFIndicatorResultDecimals(iTree,lfirNew);         
        } else {
            lfirNew = populateLFIndicatorResultDecimals(iTree,lfirNew);
            lfirNew.Organization_Indicator_Id__c = iTree.rowId;
        }   
        lfirNew.Organization_Indicator_Master_Id__c = oIndMaster.Id;
        lfirNew.Name = iTree.indCode;
        lfirNew.LF_Reporting_Period_Id__c = lfrp.Id;
        lfirNew.LogFrame_Tree_Id__c = lfrp.LogFrame_Tree_Id__c;
        lfirNew.LF_Goal_Id__c = lfrp.LF_Goal_Id__c;
        lfirNew.LF_Input__c = lfrp.LF_Input_Id__c;
        lfirNew.LF_Output__c = lfrp.LF_Output_Id__c;
        lfirNew.LF_Purpose_Id__c = lfrp.LF_Purpose_Id__c;
        lfirNew.LF_SubPurpose_Id__c = lfrp.LF_SubPurpose_Id__c;
        lfirNew.Note_Comments__c = iTree.notes;
        String recTypeName = GU.getRecordType('LF_Reporting_Period__c',lfrp.RecordTypeId);
        String recTypeId = GU.getRecordTypeId('LF_Indicator_Result__c',recTypeName);
        lfirNew.RecordTypeId = recTypeId;
        return lfirNew;
    }
    
    private LF_Indicator_Result__c populateLFIndicatorResultDecimals(IndicatorTargets iTree, LF_Indicator_Result__c lfirNew){
        if(!(String.isEmpty(iTree.baseLine))){
            lfirNew.Baseline__c = decimal.valueOf(iTree.baseLine);
        } else {
            lfirNew.Baseline__c = null;
        }
        if(!(String.isEmpty(iTree.target))){
            lfirNew.Target__c = decimal.valueOf(iTree.target);  
        }else {
            lfirNew.Target__c = null;
        }
        if(!(String.isEmpty(iTree.actual))){
            lfirNew.Actual__c = decimal.valueOf(iTree.actual);  
        }else {
            lfirNew.Actual__c = null;
        }
        
        return lfirNew;
    }
    
    
    private RF_Indicator_Result__c prepareRFIndicatorResultsInsertUpdate(IndicatorTargets iTree, RF_Indicator_Result__c rfir, 
                                                                RF_Reporting_Period__c rfrp, Boolean isUpdate, OrgUnit_Indicator__c oIndMaster){
        RF_Indicator_Result__c rfirNew = new RF_Indicator_Result__c();
        
        System.Debug('IsUpdate ***  ' + isUpdate);
        if (isUpdate){
            rfirNew = rfir;
            rfirNew = populateRFIndicatorResultDecimals(iTree,rfirNew);         
        } else {
            rfirNew = populateRFIndicatorResultDecimals(iTree,rfirNew);
            rfirNew.Organization_Indicator_Id__c = iTree.rowId;
        }   
        rfirNew.Name = iTree.indCode;
        rfirNew.RF_Reporting_Period_Id__c = rfrp.Id;
        rfirNew.Note_Comments__c = iTree.notes;
        rfirNew.Organization_Indicator_Master_Id__c = oIndMaster.Id;
        rfirNew.CDCS_Goals__c = rfrp.Goal_Id__c;
        rfirNew.DO_Id__c = rfrp.DO_Id__c;
        rfirNew.IR_Id__c = rfrp.IR_Id__c;
        rfirNew.Sub_IR_Id__c = rfrp.SIR_Id__c;
        String recTypeName = GU.getRecordType('RF_Reporting_Period__c',rfrp.RecordTypeId);
        String recTypeId = GU.getRecordTypeId('RF_Indicator_Result__c',recTypeName);
        rfirNew.RecordTypeId = recTypeId;
        return rfirNew;
    }
    
    private RF_Indicator_Result__c populateRFIndicatorResultDecimals(IndicatorTargets iTree, RF_Indicator_Result__c rfirNew){
        if(!(String.isEmpty(iTree.baseLine))){
            rfirNew.Baseline__c = decimal.valueOf(iTree.baseLine);
        } else {
            rfirNew.Baseline__c = null;
        }
        if(!(String.isEmpty(iTree.target))){
            rfirNew.Target__c = decimal.valueOf(iTree.target);  
        }else {
            rfirNew.Target__c = null;
        }
        if(!(String.isEmpty(iTree.actual))){
            rfirNew.Actual__c = decimal.valueOf(iTree.actual);  
        }else {
            rfirNew.Actual__c = null;
        }
        
        return rfirNew;
    }
    
    
    
    public PageReference Cancel(){
   
        PageReference pageRef = new PageReference('/'+cancelVal); 
        
        pageRef.setRedirect(true);
        return pageRef ;
    }
    
    public PageReference CancelGo(){
   
        return null ;
    }
    
    public PageReference CancelSave(){
   
        PageReference pageRef = new PageReference('/apex/vfIMIndicatorResultsPage?id='+ ApexPages.currentpage().getParameters().get('id') ); 
        
        pageRef.setRedirect(true);
        return pageRef ;
    }
    
    private void parse(String toParse) {
        DOM.Document doc = new DOM.Document();    
        //toParse = toParse.escapeXml();  
        try {
            System.debug('PArsing String::' +toParse);
            doc.load(toParse);    
            DOM.XMLNode root = doc.getRootElement();   
            //system.debug('Root Tag Name:::' +root.getName()); 
                
            for(Dom.XMLNode child: root.getChildElements()){
                walkThrough(child);
            }           
        } catch (System.XMLException e) {  
            //system.debug( e.getMessage());
        }
    }
    
    private void walkThrough(DOM.XMLNode node) {        
        Integer childCount = 0;
        Boolean rowInserted = false;
        IndicatorTargets iTree = new IndicatorTargets();
        
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT && node.getName().equalsIgnoreCase('row')) {
            String rowId = node.getAttributeValue(node.getAttributeKeyAt(0), node.getAttributeKeyNsAt(0));       
            iTree.rowId = rowId;
            for (Dom.XMLNode child: node.getChildElements()) {
                
                if(child.getName().equalsIgnoreCase('cell')){
                    if (childCount == 0){      
                        iTree.indCode = child.getAttributeValue(child.getAttributeKeyAt(0), child.getAttributeKeyNsAt(0));                      
                    } else if (childCount == 1){
                        string temp = child.getText();
                        if (temp.contains(',')){
                            temp=temp.remove(',');
                        }
                        if (temp.contains('%')){
                            temp=temp.remove('%');
                            iTree.baseLine = temp;  
                        } else if (temp.contains('$')){
                            temp=temp.remove('$');
                            iTree.baseLine = temp;  
                        } else{
                            iTree.baseLine = temp;
                        }
                        //system.debug('Base Line::::'+iTree.baseLine);
                    } else if (childCount == 2){
                        string temp = child.getText();
                        if (temp.contains(',')){
                            temp=temp.remove(',');
                        }
                        if (temp.contains('%')){
                            temp=temp.remove('%');
                            iTree.target = temp;    
                        } else if (temp.contains('$')){
                            temp=temp.remove('$');
                            iTree.target = temp;  
                        } else {
                            iTree.target = temp;
                        }
                        //system.debug('Target::::'+iTree.target);
                    } else if (childCount == 3){
                        string temp = child.getText();
                        if (temp.contains(',')){
                            temp=temp.remove(',');
                        }
                        if (temp.contains('%')){
                            temp=temp.remove('%');
                            iTree.actual = temp;    
                        } else if (temp.contains('$')){
                            temp=temp.remove('$');
                            iTree.actual = temp;  
                        } else {
                            iTree.actual = temp;
                        }
                        //system.debug('Target::::'+iTree.actual);
                    } else if (childCount == 4){                
                                     
                    }else if (childCount == 5){
                        iTree.partnerNotes = child.getText();
                        //iTargetsMap.put(rowId, iTree);
                        //rowInserted = true;    
                        //system.debug('Notes and Comments::::'+iTree.notes);
                    }else if (childCount == 6){
                        iTree.notes = child.getText();
                        iTargetsMap.put(rowId, iTree);
                        rowInserted = true;                         
                    }else if (childCount == 7){                        
                    }                    
                    childCount++;
                }  else {                   
                    walkThrough(child); 
                } 
                
            }
            if (!rowInserted){
                iTargetsMap.put(rowId, iTree);
            }   
        }
         
    } 
    
    public void getRelatedOrgUnitIndicators(ClsIndicatorWizardUtility IWU){
        if (objName.equalsIgnoreCase('Reporting_Period__c')){
            if(IWU.getReportingPeriodRecTypeName(objName,repPeriod.recordTypeId).equalsIgnoreCase('Activity')){         
                //IWU.getOrgUnitIndicatorsByRecordType(IWU.getReportingPeriodRecTypeName(repPeriod.recordTypeId),'Activity_Id__c',repPeriod.Activity_Id__c);
                Activity__c act= (Activity__c)IWU.getObjectRecordByIdAndName(repPeriod.Activity_Id__c,'Activity__c');
                Implementing_Mechanism__c im = (Implementing_Mechanism__c)IWU.getObjectRecordByIdAndName(act.ImpMech_Id__c,'Implementing_Mechanism__c'); 
                IWU.getOrgUnitIndicatorsByRecordType2('Implementing Mechanism','Implementing_Mechanism_Id__c',im.Id,repPeriod.Frequency__c);                
            } else if(IWU.getReportingPeriodRecTypeName(objName,repPeriod.recordTypeId).equalsIgnoreCase('Implementing Mechanism')){
                IWU.getOrgUnitIndicatorsByRecordType2(IWU.getReportingPeriodRecTypeName(objName,repPeriod.recordTypeId),'Implementing_Mechanism_Id__c',repPeriod.Implementing_Mechanism_Id__c,repPeriod.Frequency__c);
            }           
        } else if(objName.equalsIgnoreCase('LF_Reporting_Period__c')){
            if(IWU.getReportingPeriodRecTypeName(objName,lfRepPeriod.recordTypeId).equalsIgnoreCase('LF Goal')){
                IWU.getOrgUnitIndicatorsByRecordType(IWU.getReportingPeriodRecTypeName(objName,lfRepPeriod.recordTypeId),'LF_Goal_Id__c',lfRepPeriod.LF_Goal_Id__c);
            } else if(IWU.getReportingPeriodRecTypeName(objName,lfRepPeriod.recordTypeId).equalsIgnoreCase('LF Purpose')){
                IWU.getOrgUnitIndicatorsByRecordType(IWU.getReportingPeriodRecTypeName(objName,lfRepPeriod.recordTypeId),'LF_Purpose_Id__c',lfRepPeriod.LF_Purpose_Id__c);
            } else if(IWU.getReportingPeriodRecTypeName(objName,lfRepPeriod.recordTypeId).equalsIgnoreCase('LF Sub-Purpose')){
                IWU.getOrgUnitIndicatorsByRecordType(IWU.getReportingPeriodRecTypeName(objName,lfRepPeriod.recordTypeId),'LF_SubPurpose_Id__c',lfRepPeriod.LF_SubPurpose_Id__c);
            } else if(IWU.getReportingPeriodRecTypeName(objName,lfRepPeriod.recordTypeId).equalsIgnoreCase('LF Output')){
                IWU.getOrgUnitIndicatorsByRecordType(IWU.getReportingPeriodRecTypeName(objName,lfRepPeriod.recordTypeId),'LF_Output_Id__c',lfRepPeriod.LF_Output_Id__c);
            } else if(IWU.getReportingPeriodRecTypeName(objName,lfRepPeriod.recordTypeId).equalsIgnoreCase('LF Input')){
                IWU.getOrgUnitIndicatorsByRecordType(IWU.getReportingPeriodRecTypeName(objName,lfRepPeriod.recordTypeId),'LF_Input_Id__c',lfRepPeriod.LF_Input_Id__c);
            }
        } else if(objName.equalsIgnoreCase('RF_Reporting_Period__c')){
            if(IWU.getReportingPeriodRecTypeName(objName,rfRepPeriod.recordTypeId).equalsIgnoreCase('RF Goal')){
                IWU.getOrgUnitIndicatorsByRecordType(IWU.getReportingPeriodRecTypeName(objName,rfRepPeriod.recordTypeId),'Goal_Id__c',rfRepPeriod.Goal_Id__c);
            } else if(IWU.getReportingPeriodRecTypeName(objName,rfRepPeriod.recordTypeId).equalsIgnoreCase('RF DO')){
                IWU.getOrgUnitIndicatorsByRecordType(IWU.getReportingPeriodRecTypeName(objName,rfRepPeriod.recordTypeId),'DO_Id__c',rfRepPeriod.DO_Id__c);
            } else if(IWU.getReportingPeriodRecTypeName(objName,rfRepPeriod.recordTypeId).equalsIgnoreCase('RF IR')){
                IWU.getOrgUnitIndicatorsByRecordType(IWU.getReportingPeriodRecTypeName(objName,rfRepPeriod.recordTypeId),'IR_Id__c',rfRepPeriod.IR_Id__c);
            } else if(IWU.getReportingPeriodRecTypeName(objName,rfRepPeriod.recordTypeId).equalsIgnoreCase('RF SUB IR')){
                IWU.getOrgUnitIndicatorsByRecordType(IWU.getReportingPeriodRecTypeName(objName,rfRepPeriod.recordTypeId),'SIR_Id__c',rfRepPeriod.SIR_Id__c);
            }
        }
    }
    
    
    
    public void saveIMReport(){   
    
    ClsIndicatorWizardUtility IWU = new ClsIndicatorWizardUtility();    
 repPeriod= (Reporting_Period__c)IWU.getObjectRecordByIdAndName(getselectedPeriodIdValue(selectedPeriodName),'Reporting_Period__c');
        
    if(repPeriod != null){
    
    Map<String,String> parameterMap = ApexPages.currentPage().getParameters();
  if(parameterMap != null)
    {
       for(String dateParm:parameterMap.keySet()){
       if(dateParm.contains('closedDay'))
         {
          if(parameterMap.get(dateParm) != null && parameterMap.get(dateParm) != '')
               closedDate=parameterMap.get(dateParm);           
         }        
       }      
    } 
     
    if(repPeriod.Close_Date__c == null){    
      repPeriod.Close_Date__c = date.today();
      repPeriod.Close_Date__c = repPeriod.Close_Date__c.addDays(Integer.valueof(closedDate));
    }else{
      repPeriod.Close_Date__c = repPeriod.Close_Date__c.addDays(Integer.valueof(closedDate));
    }
      
     upsert repPeriod;  
     selectedPeriod = repPeriod.Id;  
     isEdit=false;   
    }
    }
     
   public void saveIMRptNarative(){   
    if(repPeriod != null){    
       Map<String,String> parameterMap = ApexPages.currentPage().getParameters();
       
      if(parameterMap != null)
        {
          for(String txtParm:parameterMap.keySet()){
           
          if(txtParm.contains('narative'))
            {
             
             if(parameterMap.get(txtParm) != null && parameterMap.get(txtParm) != '')       
               repPeriod.Narrative__c=String.valueOf(parameterMap.get(txtParm));   
               break;        
            }        
          }      
       }   
       
        upsert repPeriod; 
        
        isEdit=false; 
      }
    }
   
        
    public class IndicatorTargets{
        public String indCode;
        public String rowId;            
        public String baseLine;
        public String target;
        public String actual;
        public String notes;
        public String partnerNotes;
        
    }       
    
    
    
    //  public PageReference changeToPublish(){
   
    //    //system.debug('changeToPublish Record Id:::' +repPeriod.id);
       
    //    repPeriod.Status__c = 'Publish';
    //    upsert repPeriod;
    //    prepResultsTreeChange();
    //    return Cancel();
    //   //return null;
        
   // }
    
    public void changeToPublish(){
        repPeriod.Status__c = 'Publish';
        upsert repPeriod;
    }
    public PageReference changeToClose(){
        //system.debug('changeToClose Record Id:::' +repPeriod.id);
        
        repPeriod.Status__c = 'Closed';
        upsert repPeriod;
        return Cancel();
    }
    
    public PageReference changeToDraft(){
        //system.debug('changeToDraft Record Id:::' +repPeriod.id);
      
        repPeriod.Status__c = 'Draft';
        upsert repPeriod;
        prepResultsTreeChange();
        return Cancel();
      // return null;
    }
    
    public PageReference changeToOpen(){
        //system.debug('changeToOpen Record Id:::' +repPeriod.id + ' ***  ' + repPeriod.Targets_Established__c);       
        repPeriod.Status__c = 'Open';
        if(! repPeriod.Targets_Established__c){
        showErrors = 'true';
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please establish targets before changing the status to Open'));
        }else{
        
         upsert repPeriod;
        }
        return Cancel();
       
    }
    
  /*  public PageReference changeToExtend(){
        system.debug('changeToExtend Record Id:::' +repPeriod.id);
        
        //rp.Status__c = 'Open';
        if (repPeriod.Close_Date__c > Date.today()){
            repPeriod.Close_Date__c = repPeriod.Close_Date__c.addDays(15);
        } else {
            repPeriod.Close_Date__c = Date.today().addDays(15);
        }   
        upsert repPeriod;
        return Cancel();
    }*/
    
  //  public PageReference changeToSubmit(){
        //system.debug('changeToSubmit Record Id:::' +repPeriod.id);
        
  //      repPeriod.Status__c = 'Submitted';
  //      repPeriod.Reason__c = null;
  //      upsert repPeriod;
       // return Cancel(); 
  //      doSaveTargets();       
      //  return Cancel();
  //    return null;
  //  }
     public void changeToSubmit(){
         system.debug('changeToSubmit Record Id:::' +repPeriod.id);
         repPeriod.Status__c = 'Submitted';
         repPeriod.Reason__c = null;
         upsert repPeriod;
     }
     
     public void changeToImported(){
         system.debug('changeToImported Record Id:::' +repPeriod.id);
         repPeriod.Status__c = 'Approved';
         repPeriod.Reason__c = null;
         upsert repPeriod;
     }
    
     public PageReference changeToApproved(){
        
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Approving request');
            req.setAction('Approve');
            
            Id workItemId = getWorkItemId(repPeriod.id);
            
     
            if(workItemId == null)
            {
                repPeriod.addError('Error Occured');
                
            }
            else
            {
                req.setWorkitemId(workItemId);
                // Submit the request for approval
                Approval.ProcessResult result =  Approval.process(req);
            }
            
            return cancel();
        }
     
    
    public Id getWorkItemId(Id targetObjectId)
    {
        Id retVal = null;

        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
            where p.ProcessInstance.TargetObjectId =: targetObjectId])
        {
            retVal  =  workItem.Id;
        }

        return retVal;
    }
    
    public PageReference changeToReject(){
       /* system.debug('changeToReject Record Id:::' +recId);
        rp.Status__c = 'Rejected';
        upsert rp;
        return Cancel();
        */  
            //system.debug('Reporting Period::'+repPeriod);
      if(repPeriod != null){    
            Map<String,String> parameterMap = ApexPages.currentPage().getParameters();
                if(parameterMap != null)
                {
                  //system.debug('Reject Reason:::::1');
                  for(String txtParm:parameterMap.keySet()){
                  if(txtParm.contains('rejectReasonid'))
                    {
                     //system.debug('Reject Reason:::::2');
                     if(parameterMap.get(txtParm) != null && parameterMap.get(txtParm) != '')       
                       repPeriod.Reason__c=String.valueOf(parameterMap.get(txtParm));
                       repPeriod.Status__c = 'Open';
                       //system.debug('Reject Reason:::::'+parameterMap.get(txtParm));       
                    }        
                  }      
                }
            //system.debug('Record to update:::::'+repPeriod.Reason__c);  
            upsert repPeriod; 
            //system.debug('Reject Reason:::::4');
            } 
                 
                    
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Rejecting request');
            req.setAction('Reject');            
            Id workItemId = getWorkItemId(repPeriod.id);
            
     
            if(workItemId == null)
            {
                repPeriod.addError('Error Occured');
                
            }
            else
            {
                req.setWorkitemId(workItemId);
                // Submit the request for approval
                Approval.ProcessResult result =  Approval.process(req);
            } 
            
             
                        
          PageReference pageRef = new PageReference('/apex/vfIMIndicatorResultsPage?id='+cancelVal);
          pageRef.setRedirect(true);
          return pageRef ;  
          //return cancel();
    }
    
   
      public PageReference CancelNGo(){
      
       Cookie previousReportPeriodCookie= new Cookie('selectedPeriod', selectedPeriod,null,0,false);                
             ApexPages.currentPage().setCookies(new Cookie[]{previousReportPeriodCookie}); 
             
             
            Cookie previousURLCookie = new Cookie('previousURL', '',null,0,false);                
             ApexPages.currentPage().setCookies(new Cookie[]{previousURLCookie}); 
           
             
              Cookie selectTabCookie = new Cookie('selectTabCookie', '',null,0,false);                
               ApexPages.currentPage().setCookies(new Cookie[]{selectTabCookie }); 
               
         PageReference pageRef; 
         Id inputId = ApexPages.currentpage().getParameters().get('id');
         pageRef = new PageReference('/' + inputId); 
         pageRef.setRedirect(true);
         return pageRef ;     
    }
   
   static final List<String> notedAttFieldList= new List<String>{'id','Name','Title','LastModifiedDate','LastModifiedById','createdbyid'}; 
public List<String> getnotedAttFieldList(){ 
     
     return notedAttFieldList;
     }

     public List<Sobject> notesAttach {
        get{
            List<Sobject> retList = new List<Sobject>();
            system.debug('Selected Period::'+selectedPeriod+':RepPeriod::');
            List<Note> notesList = new List<Note>([SELECT CreatedById,IsPrivate,
                             LastModifiedById,LastModifiedDate,Title 
                             FROM Note
                             where (parentId = :selectedPeriod and isPrivate = false)
                             or (parentId = :selectedPeriod and isPrivate = true and createdById = :UserInfo.getUserId())
                             order by lastmodifieddate desc]);
             System.Debug('Notes ***  ' + notesList);                
             List<Attachment> attachList = new List<Attachment>([SELECT CreatedById,IsPrivate,
                             LastModifiedById,LastModifiedDate,Description, Name
                             FROM Attachment
                             where (parentId = :selectedPeriod and isPrivate = false)
                             or (parentId = :selectedPeriod and isPrivate = true and createdById = :UserInfo.getUserId()) 
                             order by lastmodifieddate desc]);
             System.Debug('Attachments***  ' + attachList);                
              
             for(Attachment a: attachList ){
                 retList.add((Sobject)a);
             }
             for(Note n: notesList ){
                 retList.add((Sobject)n);
             }
             return retList;                
        }
        set;}
   
   
   
   
   
   
   /* 
    public PageReference Cancel(){
         PageReference pageRef; 
         Id inputId = ApexPages.currentpage().getParameters().get('id');
         pageRef = new PageReference('/' + inputId ); 
         pageRef.setRedirect(true);
         return pageRef ;     
    }
    
    
  */
    
        
}