public with sharing class ClsManageIndicatorReportingTargets {

     public List<OrgUnit_Indicator__c> orgUnitIndList{get;set;}
     public List<Reporting_Period__c> reportingPeriodListForInd{get;set;}
     public List<String> reportingYearList {get;set;}
      
     // Creating List for Wrapper class
     public List<String> jasonString {get;set;}
     
     public Set<wrapper> wrapperList = new Set<wrapper>();
     public Set<wrapper> indWrapperList = new Set<wrapper>();
     
      public List<wrapper> saveWrapperList  { get; set; }
    
    public String Cancel { get; set; }

    public String isReject { get; set; }
    
    public String changeToReject { get; set; }
    public String rejectReason { get; set; }    
    public Reporting_Period__c repPeriod {get;set;}  
    public Reporting_Period__c repPeriod1 {get;set;}
    public String imId{get;set;}
    public Id actId{get;set;}
   
    public Activity__c act{get;set;}
    public String selectedYear{get;set;}
    public String selectedTasks{get;set;}
    public String xmlStr{get;set;}
    
    public String saveXMLString {get;set;}
    
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
    public String ShowPublishErrors{get;set;}
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
    public boolean isSavePublishEnabled{get;set;}
    public boolean isDraftPublishRecExist{get;set;}
    
    public boolean isSaveActionEnabled{get;set;}
    
    public String selectedYearName{get;set;}
    public String selectedTaskName{get;set;}
    public  List<selectOption> taskList{get;set;}
    public  List<selectOption> periodsList{get;set;}
    public String selectedYearValue{get;set;}
   
   
    clsGlobalUtility GU = new clsGlobalUtility();
   
 public ClsManageIndicatorReportingTargets(Reporting_Period__c controller) {
    
    
     try {  
          // selectedYearName='';
          // selectedTaskName='';
            //system.debug('Selected Reporting Period::::' +selectedYear);            
            Id rptId= ApexPages.currentpage().getParameters().get('Lid');
             actId= ApexPages.currentpage().getParameters().get('actId');
            imId =ApexPages.currentpage().getParameters().get('id');
          isSaveActionEnabled=false;
          //  periodDetermination(rptId,actId);
          prepareTargetsXML();
        
        } catch(Exception e){
          
        }
  
 }
     
    public ClsManageIndicatorReportingTargets(ApexPages.StandardController controller) {
     try {      
        // selectedYearName='';
         //  selectedTaskName='';
            //system.debug('Selected Reporting Period::::' +selectedYear);            
            Id rptId= ApexPages.currentpage().getParameters().get('Lid');
           actId= ApexPages.currentpage().getParameters().get('actId');
           isSaveActionEnabled=false;
          //  periodDetermination(rptId,actId);
          prepareTargetsXML();
         
        } catch(Exception e){
          
        }
    }
    public ClsManageIndicatorReportingTargets(){
      
          isPLTReadOnlyUser = GU.isPLTReadOnlyUser();
           isSaveActionEnabled=false;
           isAORCORExist =false;
        Date valDate = DATE.today();
        Id inputId = ApexPages.currentpage().getParameters().get('id');
        try {       
 

       
       /*   List<Reporting_Period__c> pListRP = new List<Reporting_Period__c>([Select Id, Name, Start_Date__c, End_Date__c from Reporting_Period__c Where Implementing_Mechanism_Id__c = :inputId  ORDER BY Name]);        
              if(pListRP != null && pListRP .size() > 0){
                  for(Reporting_Period__c period: pListRP ){
                   
                    if(period.Start_Date__c <= valDate && period.End_Date__c >= valDate){
                        selectedYear = period.Id;
                    } 
                  }
                  if(selectedYear == null){
                    repPeriod1 = [Select Id, Name, Start_Date__c, End_Date__c from Reporting_Period__c Where Implementing_Mechanism_Id__c = :inputId  ORDER BY Name DESC limit 1];
                    selectedYear = repPeriod1.Id; 
                  }
              }
             
            system.debug('Selected Reporting Period::::' +selectedYear);   */         
            Id rptId= ApexPages.currentpage().getParameters().get('Lid');
            Id actId= ApexPages.currentpage().getParameters().get('actId');
             hasTree = false;
             isEdit=false;
             
              //Id inputId = ApexPages.currentpage().getParameters().get('id');
               Implementing_Mechanism__c currentIM =[Select  Name,Reporting_Level__c,AOR__c,COR__c,Alternate_AOR__c,Alternate_COR__c from Implementing_Mechanism__c Where id =:inputId]; 
     
        if(currentIM != null && currentIM.Reporting_Level__c == 'Task'){
        isTaskExist=true;
        }else{
        isTaskExist=false;
        }
            //Cookie previousReportYearCookie=  ApexPages.currentPage().getCookies().get('selectedYear');
          //  periodDetermination(rptId,actId);
            
            prepareTargetsXML();
           
         
      
     
            
        } catch(Exception e){
           // system.debug('Manage Indicator Targets Error: -'+e.getStackTraceString());
            //e.setMessage('Could not create Indicator Targets for -'+ +'\\n'+'Error -'+e.getMessage()+' occured in class ClsManageIndicatorReportingTargets at line number -'+e.getLineNumber() );
            //throw(e);
        }
      
    }
    
    
 
    
    /**
    
    */
    
     public List<selectOption> getPeriods(){
       // System.Debug('Inside the getMissions');
       Date valDate = DATE.today();
        Id inputId = ApexPages.currentpage().getParameters().get('id');
        periodsList = new List<selectOption>();
      isAORCORExist=false;
               
       //  List<aggregateResult> pListRP = new List<aggregateResult>([Select FISCAL_Year(END_Date__c) endYear from Reporting_Period__c  Where Implementing_Mechanism_Id__c = :inputId  GROUP BY FISCAL_Year(END_Date__c) Order by FISCAL_Year(END_Date__c)]); 
         List<aggregateResult> pListRP = new List<aggregateResult>([Select fiscal_year__c from Reporting_Period__c  Where Implementing_Mechanism_Id__c = :inputId  GROUP BY fiscal_year__c  Order by fiscal_year__c]); 
          if(pListRP != null && pListRP .size() > 0){
              selectedYearValue ='';
              for(AggregateResult  period: pListRP ){
              if(selectedYearValue =='')
              selectedYearValue=String.valueOf(period.get('fiscal_year__c'));
                periodsList.add(new selectOption(String.valueOf(period.get('fiscal_year__c')), String.valueOf(period.get('fiscal_year__c'))));
          
              }
          } 
          
          
             try{
                Implementing_Mechanism__c currentIM =[Select  Name,Reporting_Level__c,AOR__c,COR__c,Alternate_AOR__c,Alternate_COR__c from Implementing_Mechanism__c Where id =:inputId];               
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
        system.debug('Selected Reporting Period::::' +selectedYear);       
         Cookie previousReportYearCookie=  ApexPages.currentPage().getCookies().get('selectedYear');          
         Cookie previousTaskCookie=  ApexPages.currentPage().getCookies().get('selectedTasks');       
            if(previousReportYearCookie!= null)
            {   
              String preVal = previousReportYearCookie.getValue();
              if(preVal != null && preVal !=''){
               selectedYear = previousReportYearCookie.getValue();
               if(previousTaskCookie != null){
                //System.debug('prepResultsTree selectedTasks ::::' +selectedTasks +' *** ' + previousTaskCookie.getValue());     
               String preTask = previousTaskCookie.getValue();
               if(preTask != null && preTask !=''){
               selectedTasks= previousTaskCookie.getValue();
               }
               }
              }
            }   
    
            // System.debug('After Actuals  Selected Reporting Period::::' +selectedYear);  
            if(selectedYear != null && selectedYear !='' ){  
                if(selectedTasks != null && selectedTasks !=''){
                   //periodDetermination((Id)selectedYear, (Id)selectedTasks);
                   prepareTargetsXML();
                }else{
                    //periodDetermination((Id)selectedYear, null);
                    prepareTargetsXML();
                   
                    
                 }
                 
                 showResults = true;
        }
        narative='';
        if(repPeriod != null && repPeriod.Narrative__c!= null && repPeriod.Narrative__c !='')
        narative=repPeriod.Narrative__c.length() >150 ? repPeriod.Narrative__c.left(150)+'...':null;
       
      
        selectedYearName= getselectedYearName();
          selectedTaskName= getselectedTaskName();
     
          
          System.Debug('prepResultsTree selectedYear ***' + selectedYear );
     
    }
  
    
  public void prepResultsTreeChange(){
   ShowErrors='false';
    ApexPages.getMessages().clear(); 
  String selPeriod='';
   Map<String,String> parameterMap = ApexPages.currentPage().getParameters();
      if(parameterMap != null)
        {
          for(String txtParm:parameterMap.keySet()){
          if(txtParm.contains('periodvalue'))
            {
             if(parameterMap.get(txtParm) != null && parameterMap.get(txtParm) != '')       
              // System.Debug('NewVal ***** ' + String.valueOf(parameterMap.get(txtParm)));    
               selPeriod=String.valueOf(parameterMap.get(txtParm));       
            }        
          }      
       }   
  
  
  
     
       if(selPeriod != null && selPeriod !=''){
       selectedYear =selPeriod ;
       }
       
     
       if(selectedYear != null){
         Cookie previousReportYearCookie= new Cookie('selectedYear', selectedYear,null,0,false);                
         ApexPages.currentPage().setCookies(new Cookie[]{previousReportYearCookie}); 
         
         Cookie previousTaskCookie= new Cookie('selectedTasks', selectedTasks,null,0,false);                
         ApexPages.currentPage().setCookies(new Cookie[]{previousTaskCookie}); 
         
       
         previousReportYearCookie =new Cookie('selectedYear', selectedYear,null,-1,false); 
         ApexPages.currentPage().setCookies(new Cookie[]{previousReportYearCookie}); 
         
          previousTaskCookie= new Cookie('selectedTasks', selectedTasks,null,-1,false);                            
         ApexPages.currentPage().setCookies(new Cookie[]{previousTaskCookie}); 
         
         }else{
            Cookie previousReportYearCookie=  ApexPages.currentPage().getCookies().get('selectedYear');  
            Cookie previousTaskCookie=  ApexPages.currentPage().getCookies().get('selectedTasks');             
            if(previousReportYearCookie!= null)
            {   
              String preVal = previousReportYearCookie.getValue();
              if(preVal != null && preVal !=''){
               selectedYear = previousReportYearCookie.getValue();
              }
              String preTaskVal = previousTaskCookie.getValue();
              if(preTaskVal != null && preTaskVal !=''){                
                      selectedTasks= previousTaskCookie.getValue();
              }
     
            }   
         }
         System.Debug('SelectedPeriod ***** ' + selectedYear );
           if(selectedYear != null && selectedYear !='' ){  
                if( selectedTasks != null && selectedTasks !=''){
                  // periodDetermination((Id)selectedYear, (Id)selectedTasks);
                    prepareTargetsXML();
                }else{
                   // periodDetermination((Id)selectedYear, null);
                    prepareTargetsXML();
                    
                 }
                 showResults = true;
                
               }
               narative='';
          if(repPeriod != null && repPeriod.Narrative__c!= null && repPeriod.Narrative__c !='')
          narative=repPeriod.Narrative__c.length() >150 ? repPeriod.Narrative__c.left(150)+'...':null;
          
          selectedYearName= getselectedYearName();
          selectedTaskName= getselectedTaskName();
            
             System.Debug('prepResultsTreeChange selectedYear ***' + selectedYear );
          
    }
    
    private String getselectedYearName(){
   
     String selectName='';
      if(periodsList!= null && periodsList.size() > 0){
      for(SelectOption namee:periodsList){
     // System.debug('getselectPerid *** ' + namee.getValue() +'***'+selectedYear);
        if(namee.getValue() == selectedYear){
         // System.Debug('SelecteName ***  ' + namee.getLabel());
          selectName=namee.getLabel();
      
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
    
   
  
    
     /**
    
    */
      public void prepareTargetsXML(){
   
     if(imId == null){
       imId = ApexPages.currentpage().getParameters().get('id');
     }
   
  orgUnitIndList= new List<OrgUnit_Indicator__c>([Select id,Name,Implementing_Mechanism_Id__c,Organization_Indicator_Id__c,indCode__c,indName__c,sIndCode__c,sIndName__c,indDataType__c,Collection_Frequency__c ,UOM__c,(select Id, Reporting_Period_Id__c,Indicator_Code__c,Organization_Indicator_Id__c,Baseline__c,Actual__c,Variance__c,Target__c,Note_Comments__c,Notes_Comments_Partner__c  from indicator_Results__r where   Fiscal_Year__c = :selectedYear order by Reporting_Period_Id__c) from OrgUnit_Indicator__c where Implementing_Mechanism_Id__c=:imId  order by id,indCode__c,sIndCode__c]);        
 
  if(orgUnitIndList.isEmpty()){
            showErrors = 'true';           
            ApexPages.getMessages().clear();           
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Indicators are not defined for the selected '+recTypeName+'. Please select indicators to proceed.'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Indicators are not defined for the selected Implementing Mechanism. Please select indicators to proceed.'));
        } else {
            showErrors = 'false';         
        }
   Map<string,Indicator_Results__c> resultsMap = new Map<string,Indicator_Results__c>();
   for(Indicator_Results__c ir: [select Id, Reporting_Period_Id__c,Indicator_Code__c,
                   Organization_Indicator_Id__c,Baseline__c,Actual__c,Variance__c,Target__c,
                   Note_Comments__c,Notes_Comments_Partner__c  
               from indicator_Results__c 
               where Fiscal_Year__c = :selectedYear 
               and Implementing_Mechanism_Id__c=:imId
               order by Reporting_Period_Id__c  ]) {
       resultsMap.put(ir.Reporting_Period_Id__c+':'+ir.Organization_Indicator_Id__c, ir);    
   
   }
   reportingPeriodListForInd = new List<Reporting_Period__c>([Select id,Name,Implementing_Mechanism_Id__c,Status__c,Implementing_Mechanism_Name__c,Frequency__c,Start_Date__c,End_Date__c,Reporting_Level__c from Reporting_Period__c where Implementing_Mechanism_Id__c=:imId  and fiscal_year__c = :selectedYear order by id]); 
 
             wrapperList = new Set<wrapper>();    
             indWrapperList  = new Set<wrapper>();    
           if(orgUnitIndList!= null && orgUnitIndList.size() > 0){           
            
                  for(OrgUnit_Indicator__c orgUnitInd: orgUnitIndList){
                 
                   if(reportingPeriodListForInd != null && reportingPeriodListForInd.size() > 0){
                      
                      for(Reporting_Period__c reportingPeriod: reportingPeriodListForInd){
                         
                        if( orgUnitInd.Collection_Frequency__c == reportingPeriod.Frequency__c ){    
                            if(resultsMap.containsKey(reportingPeriod.Id+':'+orgUnitInd.Id)) {
                                System.debug('Result Found:::'+reportingPeriod.Name+':'+orgUnitInd.Name);
                                Indicator_Results__c indResult = resultsMap.get(reportingPeriod.Id+':'+orgUnitInd.Id);
                                indWrapperList.add(new wrapper(orgUnitInd.id,reportingPeriod.id,orgUnitInd.indCode__c,orgUnitInd.indName__c,orgUnitInd.sIndCode__c,orgUnitInd.sIndName__c,orgUnitInd.Collection_Frequency__c,
                                reportingPeriod.Name,reportingPeriod.Status__c,Double.valueOf(indResult.Baseline__c),Double.valueOf(indResult.Target__c),Double.valueOf(indResult.Actual__c),Double.valueOf(indResult.Variance__c),orgUnitInd.indDataType__c,indResult.Notes_Comments_Partner__c,indResult.Note_Comments__c,orgUnitInd.UOM__c,indResult.id,orgUnitInd.Organization_Indicator_Id__c,reportingPeriod.Reporting_Level__c,selectedYear));                                   
                            } else {
                                System.debug('Result Not Found:::'+reportingPeriod.Name+':'+orgUnitInd.Name);
                                wrapperList.add(new wrapper(orgUnitInd.id,reportingPeriod.id,orgUnitInd.indCode__c,orgUnitInd.indName__c,orgUnitInd.sIndCode__c,orgUnitInd.sIndName__c,orgUnitInd.Collection_Frequency__c,
                                reportingPeriod.Name,reportingPeriod.Status__c,null,null,null,null,orgUnitInd.indDataType__c,'','',orgUnitInd.UOM__c,'',orgUnitInd.Organization_Indicator_Id__c,reportingPeriod.Reporting_Level__c,selectedYear));   
                            }                 
                       
                       // if(orgUnitInd.indicator_Results__r != null && orgUnitInd.indicator_Results__r.size() > 0 ){
                       //     orgUnitInd.indicator_Results__r.sort();
                          //  Boolean noPeriodData = true;
                          //  for(indicator_Results__c indResult:orgUnitInd.indicator_Results__r){
                          //     if(orgUnitInd.id==indResult.Organization_Indicator_Id__c ){                              
                           //         if(reportingPeriod.id == indResult.Reporting_Period_Id__c){
                           //            noPeriodData = false;
                           //            system.debug('11111:'+orgUnitInd.indCode__c+'::'+reportingPeriod.id); 
                            //          indWrapperList.add(new wrapper(orgUnitInd.id,reportingPeriod.id,orgUnitInd.indCode__c,orgUnitInd.indName__c,orgUnitInd.sIndCode__c,orgUnitInd.sIndName__c,orgUnitInd.Collection_Frequency__c,
                            //         reportingPeriod.Name,reportingPeriod.Status__c,Double.valueOf(indResult.Baseline__c),Double.valueOf(indResult.Target__c),Double.valueOf(indResult.Actual__c),Double.valueOf(indResult.Variance__c),orgUnitInd.indDataType__c,indResult.Notes_Comments_Partner__c,indResult.Note_Comments__c,orgUnitInd.UOM__c,indResult.id,orgUnitInd.Organization_Indicator_Id__c,reportingPeriod.Reporting_Level__c,selectedYear));                                   
                            //        }else{                        
                                         //wrapperList.add(new wrapper(orgUnitInd.id,reportingPeriod.id,orgUnitInd.indCode__c,orgUnitInd.indName__c,orgUnitInd.sIndCode__c,orgUnitInd.sIndName__c,orgUnitInd.Collection_Frequency__c,
                                            // reportingPeriod.Name,reportingPeriod.Status__c,0,0,0,0,'','',orgUnitInd.UOM__c,'',orgUnitInd.Organization_Indicator_Id__c,reportingPeriod.Reporting_Level__c));  
                              //              }                                                
                               //  }   
                         //   }  
                         //   if(noPeriodData){
                         //      system.debug('2222222:'+orgUnitInd.indCode__c+'::'+reportingPeriod.id); 
                         //      wrapperList.add(new wrapper(orgUnitInd.id,reportingPeriod.id,orgUnitInd.indCode__c,orgUnitInd.indName__c,orgUnitInd.sIndCode__c,orgUnitInd.sIndName__c,orgUnitInd.Collection_Frequency__c,
                         //    reportingPeriod.Name,reportingPeriod.Status__c,null,null,null,null,orgUnitInd.indDataType__c,'','',orgUnitInd.UOM__c,'',orgUnitInd.Organization_Indicator_Id__c,reportingPeriod.Reporting_Level__c,selectedYear));   
                         //   } 
                                                
                      // } else {
                       //    system.debug('333333:'+orgUnitInd.indCode__c+'::'+reportingPeriod.id); 
                       //    wrapperList.add(new wrapper(orgUnitInd.id,reportingPeriod.id,orgUnitInd.indCode__c,orgUnitInd.indName__c,orgUnitInd.sIndCode__c,orgUnitInd.sIndName__c,orgUnitInd.Collection_Frequency__c,
                       //      reportingPeriod.Name,reportingPeriod.Status__c,null,null,null,null,orgUnitInd.indDataType__c,'','',orgUnitInd.UOM__c,'',orgUnitInd.Organization_Indicator_Id__c,reportingPeriod.Reporting_Level__c,selectedYear));   
                       
                      // }
                        
                      // else{                        
                      //   wrapperList.add(new wrapper(orgUnitInd.id,reportingPeriod.id,orgUnitInd.indCode__c,orgUnitInd.indName__c,orgUnitInd.sIndCode__c,orgUnitInd.sIndName__c,orgUnitInd.Collection_Frequency__c,
                      //       reportingPeriod.Name,reportingPeriod.Status__c,null,null,null,null,orgUnitInd.indDataType__c,'','',orgUnitInd.UOM__c,'',orgUnitInd.Organization_Indicator_Id__c,reportingPeriod.Reporting_Level__c,selectedYear));  
                      //      }
                        }
                             
                           
                      }
                     
                     }
              
              }
        }
 
     system.debug('WrapperList size'+wrapperList.size());
     system.debug('IndWrapperList size'+indwrapperList.size());
    
     if(wrapperList != null && wrapperList.size() > 0){
      
      isSavePublishEnabled = false;
      isDraftPublishRecExist=false;
      for(wrapper wrapperObj1: wrapperList){
      if(wrapperObj1.reportStatus == 'Draft'){
            isSavePublishEnabled = true;
         }
         
   
         
          if(indWrapperList != null && indWrapperList.size() > 0){
      for(Wrapper indWrap:indWrapperList){
      if(indWrap.indResultId != null && wrapperObj1.orgUnitId ==  indWrap.orgUnitId && wrapperObj1.reportPeriodId==  indWrap.reportPeriodId
         && wrapperObj1.indCode ==  indWrap.indCode && wrapperObj1.fiscalYear == indWrap.fiscalYear && 
         (indWrap.baseLine != null || indWrap.target != null || indWrap.actuals != null 
           || indWrap.partnerNotes!= null || indWrap.missionNotes!= null)){
           system.debug('Inside the inwrap override');
         wrapperObj1.baseLine=indWrap.baseLine;
         wrapperObj1.target=indWrap.target;
         wrapperObj1.actuals =indWrap.actuals;
         wrapperObj1.partnerNotes=indWrap.partnerNotes;
         wrapperObj1.missionNotes=indWrap.missionNotes;
         wrapperObj1.indResultId =indWrap.indResultId ;
         
         
       
         } else {
             wrapperList.add(indWrap);
         }
       }
      }
         
         
         }
         system.debug('Inside the inwrap override1'+wrapperList);
    } else {
    
        wrapperList.addAll(indWrapperList);
    }
    
    
    
     
      Xmlstreamwriter xmlW = new Xmlstreamwriter();
      xmlW.writeStartDocument('UTF-8','1.0');
      xmlW.writeStartElement(null,'rows', null);
      xmlW.writeAttribute(null,null,'id','0');
            
          
     if(wrapperList != null && wrapperList.size() > 0){
      integer i=0;
          
       for(wrapper wrapperObj: wrapperList){
        System.Debug('SekarObject **** ' + wrapperObj);
         xmlW.writeStartElement(null,'row',null);
          if(wrapperObj.indCode != null && wrapperObj.indName!= null && wrapperObj.subIndCode== null )
            xmlW.writeAttribute(null,null,'id',wrapperObj.reportPeriodId+'_'+wrapperObj.orgUnitId+'_'+wrapperObj.indCode);
         else
            xmlW.writeAttribute(null,null,'id',wrapperObj.reportPeriodId+'_'+wrapperObj.orgUnitId+'_'+wrapperObj.subIndCode);
            
         xmlW.writeAttribute(null,null,'image','pe.png'); 
         xmlw.writeCharacters(wrapperObj.reportPeriodId);             
             
      
         
           xmlW.writeStartElement(null,'cell',null); 
            
             
               if(wrapperObj.indCode != null && wrapperObj.indName!= null && wrapperObj.subIndCode== null )
              xmlW.writeAttribute(null,null,'image','indicator.png');   
           else  
               xmlW.writeAttribute(null,null,'image','sub-indicator.png');
                   
             
               xmlW.writeAttribute(null,null,'id','reportPeriod');
               if(wrapperObj.reportPeriod != null)
            xmlw.writeCharacters(wrapperObj.reportPeriod);          
              xmlW.writeEndElement();                          
         
         xmlW.writeStartElement(null,'cell',null);
          xmlW.writeAttribute(null,null,'id','reportStatus');
         if(wrapperObj.reportStatus!= null){
        
         xmlw.writeCharacters(wrapperObj.reportStatus);
         }
         xmlW.writeEndElement(); 
         
  
         xmlW.writeStartElement(null,'cell',null);
          xmlW.writeAttribute(null,null,'id','baseLine');
         if(wrapperObj.baseLine!= null && wrapperObj.baseLine >= 0 )
         xmlw.writeCharacters(String.valueOf(wrapperObj.baseLine));        
         xmlW.writeEndElement();         
         
         xmlW.writeStartElement(null,'cell',null);
          xmlW.writeAttribute(null,null,'id','target');
         if(wrapperObj.target!= null && wrapperObj.target >= 0)
         xmlw.writeCharacters(String.valueOf(wrapperObj.target));         
         xmlW.writeEndElement();         
         
         xmlW.writeStartElement(null,'cell',null);
          xmlW.writeAttribute(null,null,'id','actuals');
         if(wrapperObj.actuals!= null && wrapperObj.actuals>= 0)
         xmlw.writeCharacters(String.valueOf(wrapperObj.actuals));        
         xmlW.writeEndElement();   
         
  
            xmlW.writeStartElement(null,'cell',null);   
             xmlW.writeAttribute(null,null,'id','differences ');
            if(wrapperObj.differences != null && wrapperObj.differences != 0)     
         xmlw.writeCharacters(String.valueOf(wrapperObj.differences));
         xmlW.writeEndElement();   
         
            xmlW.writeStartElement(null,'cell',null);        
         xmlw.writeCharacters('');
         xmlW.writeEndElement();   
         
          xmlW.writeStartElement(null,'cell',null);   
         xmlW.writeAttribute(null,null,'id','partnerNotes'); 
           if(wrapperObj.partnerNotes!= null)              
         xmlw.writeCharacters(String.valueOf(wrapperObj.partnerNotes));
         xmlW.writeEndElement();   
         
        xmlW.writeStartElement(null,'cell',null);   
         xmlW.writeAttribute(null,null,'id','missionNotes');  
           if(wrapperObj.missionNotes!= null)             
         xmlw.writeCharacters(String.valueOf(wrapperObj.missionNotes));
         xmlW.writeEndElement();   
         
          xmlW.writeStartElement(null,'cell',null);   
         xmlW.writeAttribute(null,null,'id','indCode');
          if(wrapperObj.indCode != null)                
         xmlw.writeCharacters(String.valueOf(wrapperObj.indCode));
         xmlW.writeEndElement();   
     
     //orgUnitInd.indDataType__c,   
      
      xmlW.writeStartElement(null,'cell',null);   
         xmlW.writeAttribute(null,null,'id','datType');     
          if(wrapperObj.datType!= null)           
         xmlw.writeCharacters(wrapperObj.datType);
         xmlW.writeEndElement(); 
         
          xmlW.writeStartElement(null,'cell',null);   
         xmlW.writeAttribute(null,null,'id','subIndCode');     
          if(wrapperObj.subIndCode!= null)           
         xmlw.writeCharacters(String.valueOf(wrapperObj.subIndCode));
         xmlW.writeEndElement(); 
         
     
         
          xmlW.writeStartElement(null,'cell',null);   
         xmlW.writeAttribute(null,null,'id','indResultId');     
          if(wrapperObj.indResultId!= null)           
         xmlw.writeCharacters(String.valueOf(wrapperObj.indResultId));
         xmlW.writeEndElement(); 
         
   
         
          xmlW.writeStartElement(null,'cell',null);   
         xmlW.writeAttribute(null,null,'id','unitOfMeasures');     
          if(wrapperObj.unitOfMeasures!= null)           
         xmlw.writeCharacters(String.valueOf(wrapperObj.unitOfMeasures));
         xmlW.writeEndElement(); 
         
               xmlW.writeStartElement(null,'cell',null);        
         xmlw.writeCharacters('');
         xmlW.writeEndElement();   
         
           xmlW.writeStartElement(null,'cell',null);
          if(wrapperObj.indCode != null && wrapperObj.indName!= null && wrapperObj.subIndCode== null )
            xmlw.writeCharacters(wrapperObj.indCode +' '+ wrapperObj.indName);
         else
            xmlw.writeCharacters(wrapperObj.subIndCode+' '+ wrapperObj.subIndName ); 
         xmlW.writeEndElement(); 
                                 
         xmlW.writeEndElement(); 
       }
       xmlW.writeEndElement();
     }
         
        xmlW.writeEndDocument(); //Close XML document
   
        xmlStr =  xmlW.getXmlString();
        
        xmlStr = xmlStr.replaceAll('\'','');
      
    xmlW.close();
   
        system.debug('XML String so far:;;' +xmlStr);
    }
    
   
  
    
   public List<wrapper> listRecords = new List<wrapper>();
   
    
   
    
  //  public PageReference doSaveTargets(){
  public void doSaveTargets(){
 
   
    if(saveXMLString != null && saveXMLString !=''){
    
    List<String> savelist = saveXMLString.split('-,');  //split('\\,{');
     
    if(saveList != null && saveList.size() >0){
     saveWrapperList  = new List<wrapper>();
   
  
    for(String saveStr:savelist){
       Map<String, Object> m =   (Map<String, Object>) JSON.deserializeUntyped(saveStr);       
      
       List<String> parts = String.valueOf(m.get('reporIndId')).split('_');    
      
        wrapper saveWrap = new wrapper();
        saveWrap.reportPeriodId=parts[0]; 
        saveWrap.orgUnitId=parts[1];
             // sText.replaceAll( '\\s+', '');
        saveWrap.reportPeriod=String.valueOf(m.get('reportingPeriod'));
        saveWrap.reportStatus=String.valueOf(m.get('status'));
        
    /*    if(m.get('baseline')!= null && m.get('baseline')!= '' && Double.valueOf(String.valueOf(m.get('baseline')).replaceAll(',$%','')) > 0)
        saveWrap.baseLine=Double.valueOf(String.valueOf(m.get('baseline')).replaceAll(',$%',''));
         if(m.get('target')!= null && m.get('target')!= '' && Double.valueOf(String.valueOf(m.get('target')).replaceAll(',$%','')) > 0)
        saveWrap.target=Double.valueOf(String.valueOf(m.get('target')).replaceAll(',$%',''));
         if(m.get('actuals')!= null && m.get('actuals')!= '' && Double.valueOf(String.valueOf(m.get('actuals')).replaceAll(',$%','')) > 0)
        saveWrap.actuals=Double.valueOf(String.valueOf(m.get('actuals')).replaceAll(',$%',''));

*/
        if(m.get('baseline')!= null && m.get('baseline')!= '' && convertToDouble(String.valueOf(m.get('baseline'))) >= 0)
        saveWrap.baseLine=convertToDouble(String.valueOf(m.get('baseline')));
         if(m.get('target')!= null && m.get('target')!= '' && convertToDouble(String.valueOf(m.get('target'))) >= 0)
        saveWrap.target=convertToDouble(String.valueOf(m.get('target')));
         if(m.get('actuals')!= null && m.get('actuals')!= '' && convertToDouble(String.valueOf(m.get('actuals'))) >= 0)
        saveWrap.actuals=convertToDouble(String.valueOf(m.get('actuals')));


        saveWrap.partnerNotes=String.valueOf(m.get('partnerNotes'));
        saveWrap.missionNotes=String.valueOf(m.get('missionNotes'));
         saveWrap.indCode=String.valueOf(m.get('indCode'));
         saveWrap.subIndCode=String.valueOf(m.get('subIndCode'));  
         if(saveWrap.subIndCode == '')
         saveWrap.subIndCode=null;     
        saveWrap.indResultId=String.valueOf(m.get('indResultId'));
       
        saveWrapperList.add(saveWrap);    
     }
    }  
     

      
      List<indicator_Results__c> saveIndResult = new List<indicator_Results__c>();
       if(saveWrapperList != null && saveWrapperList.size() > 0){
           for(wrapper saveObj: saveWrapperList){

              if(wrapperList!= null && wrapperList.size() > 0){
               for(wrapper orginalObj: wrapperList){

               if(orginalObj.reportPeriodId == saveObj.reportPeriodId &&  orginalObj.orgUnitId == saveObj.orgUnitId 
                 && orginalObj.indCode== saveObj.indCode &&  orginalObj.subIndCode== saveObj.subIndCode
                 && orginalObj.indResultId== saveObj.indResultId){

                  indicator_Results__c indResult = new indicator_Results__c();
                  
                  if(orginalObj.indResultId != null && orginalObj.indResultId != '')
                     indResult.id =orginalObj.indResultId;
                  else
                     indResult.Organization_Indicator_Id__c=orginalObj.orgUnitId; 
                  
                 
                  
                  indResult.Reporting_Period_Id__c =orginalObj.reportPeriodId;
                  
                  //if(indResult.id == null && orginalObj.indResultId != '')
                  
                 // else
                  // indResult.Organization_Indicator_Master_Id__c =orginalObj.orgUnitId;     
                  
                  System.Debug('orginalObj ***' +orginalObj.indCode +'   sub ***' +orginalObj.subIndCode );           
                  
                   if(orginalObj.indCode != null && orginalObj.subIndCode != null)
                    indResult.Name =orginalObj.subIndCode;
                   else
                    indResult.Name =orginalObj.indCode;             
                  
                  
                  indResult.Baseline__c =saveObj.baseLine;
                  indResult.Actual__c =saveObj.actuals;
                  //indResult.Variance__c =saveObj.differences;
                  indResult.Target__c =saveObj.target;
                  indResult.Note_Comments__c =saveObj.missionNotes;
                  indResult.Notes_Comments_Partner__c =saveObj.partnerNotes;
                  
                   indResult.Organization_Indicator_Master_Id__c =orginalObj.masterOrgInd;  
                   if(imId == null){
       imId = ApexPages.currentpage().getParameters().get('id');
     }
                   indResult.Implementing_Mechanism_Id__c=imId ;//'a0SK000000FbrI2MAJ'; 
                   
                    String recTypeName;
        if (orginalObj.reportingPeriodLevel   == 'Task'){
            indResult.Activity_Id__c = selectedTasks;
            recTypeName = 'Task';
        } else if(orginalObj.reportingPeriodLevel  == 'Implementing Mechanism'){ 
           // indResult.Implementing_Mechanism_Id__c =imId ;// rp.Implementing_Mechanism_Id__c;
            recTypeName = 'Implementing Mechanism';
        }   
       
        String recTypeId = GU.getRecordTypeId('Indicator_Results__c',recTypeName);
        indResult.RecordTypeId = recTypeId;         
   
                  saveIndResult.add(indResult);
               
               }
               
               }    //inside for           
              }          
           }//outside for
       }
      
      
        if(saveIndResult!= null && saveIndResult.size() > 0)  {  

                       // upsert saveIndResult;     
                    saveOrDeleteIndResult(saveIndResult,false,null);
                   }
      }
   
      prepareTargetsXML();
        PageReference ref;
        Id inputId = ApexPages.currentpage().getParameters().get('id'); 
      
     
       String currentRequestURL = URL.getCurrentRequestUrl().toExternalForm();
       ref=  new PageReference(currentRequestURL+'&previousPeriod='+selectedYear+'&previousTask='+selectedTasks+'&selectedYearSaved=true&sfdc.override=1');
 
        ref.setRedirect(true);    
  
      
         Cookie  previousReportYearCookie = new Cookie('selectedYear', selectedYear,null,-1,false);                
         ApexPages.currentPage().setCookies(new Cookie[]{previousReportYearCookie});    
         
          Cookie previousTaskCookie= new Cookie('selectedTasks', selectedTasks,null,-1,false);                
         ApexPages.currentPage().setCookies(new Cookie[]{previousTaskCookie}); 
         
          
           selectedYearName= getselectedYearName();
          selectedTaskName= getselectedTaskName();
        
       //  return ref;
    }
    
    
    /**
        Publish and Save
    
    
    */
  //  public PageReference doSavePublishTargets(){
  public void doSavePublishTargets(){
    
    if(saveXMLString != null && saveXMLString !=''){
   
    
    List<String> savelist = saveXMLString.split('-,'); 
     
     List<Reporting_Period__c> publishReport = new List<Reporting_Period__c>();
     
    if(saveList != null && saveList.size() >0){
     saveWrapperList  = new List<wrapper>();
   
  
    for(String saveStr:savelist){
       Map<String, Object> m =   (Map<String, Object>) JSON.deserializeUntyped(saveStr);       
      
       List<String> parts = String.valueOf(m.get('reporIndId')).split('_');    
      
        wrapper saveWrap = new wrapper();
        saveWrap.reportPeriodId=parts[0]; 
        saveWrap.orgUnitId=parts[1];
              
        saveWrap.reportPeriod=String.valueOf(m.get('reportingPeriod'));
     
        saveWrap.reportStatus=String.valueOf(m.get('status'));
    /*   if(m.get('baseline')!= null && m.get('baseline')!= '' && Double.valueOf(String.valueOf(m.get('baseline')).replaceAll(',$%','')) > 0)
        saveWrap.baseLine=Double.valueOf(String.valueOf(m.get('baseline')).replaceAll(',$%',''));
         if(m.get('target')!= null && m.get('target')!= '' && Double.valueOf(String.valueOf(m.get('target')).replaceAll(',$%','')) > 0)
        saveWrap.target=Double.valueOf(String.valueOf(m.get('target')).replaceAll(',$%',''));
         if(m.get('actuals')!= null && m.get('actuals')!= '' && Double.valueOf(String.valueOf(m.get('actuals')).replaceAll(',$%','')) > 0)
        saveWrap.actuals=Double.valueOf(String.valueOf(m.get('actuals')).replaceAll(',$%',''));
*/
 if(m.get('baseline')!= null && m.get('baseline')!= '' && convertToDouble(String.valueOf(m.get('baseline'))) > 0)
        saveWrap.baseLine=convertToDouble(String.valueOf(m.get('baseline')));
         if(m.get('target')!= null && m.get('target')!= '' && convertToDouble(String.valueOf(m.get('target'))) > 0)
        saveWrap.target=convertToDouble(String.valueOf(m.get('target')));
         if(m.get('actuals')!= null && m.get('actuals')!= '' && convertToDouble(String.valueOf(m.get('actuals'))) > 0)
        saveWrap.actuals=convertToDouble(String.valueOf(m.get('actuals')));

        saveWrap.partnerNotes=String.valueOf(m.get('partnerNotes'));
        saveWrap.missionNotes=String.valueOf(m.get('missionNotes'));
         saveWrap.indCode=String.valueOf(m.get('indCode'));
         saveWrap.subIndCode=String.valueOf(m.get('subIndCode'));  
         if(saveWrap.subIndCode == '')
         saveWrap.subIndCode=null;     
        saveWrap.indResultId=String.valueOf(m.get('indResultId'));
       
        saveWrapperList.add(saveWrap);    
     }
    }  
     
  
      
      Set<String> publishReportPeriod = new Set<String>();
      
      
      List<indicator_Results__c> saveIndResult = new List<indicator_Results__c>();
       if(saveWrapperList != null && saveWrapperList.size() > 0){
           for(wrapper saveObj: saveWrapperList){
            System.Debug('saveObj ***' + saveObj);
              if(wrapperList!= null && wrapperList.size() > 0){
               for(wrapper orginalObj: wrapperList){
               
               if(orginalObj.reportPeriodId == saveObj.reportPeriodId &&  orginalObj.orgUnitId == saveObj.orgUnitId 
                 && orginalObj.indCode== saveObj.indCode &&  orginalObj.subIndCode== saveObj.subIndCode
                 && orginalObj.indResultId== saveObj.indResultId){
          
                  indicator_Results__c indResult = new indicator_Results__c();
                  
                  if(orginalObj.indResultId != null && orginalObj.indResultId != '')
                     indResult.id =orginalObj.indResultId;
                  else
                     indResult.Organization_Indicator_Id__c=orginalObj.orgUnitId;                 
                 
                  
                  indResult.Reporting_Period_Id__c =orginalObj.reportPeriodId;       
              
                  
                   if(saveObj.indCode != null && saveObj.subIndCode != null)
                    indResult.Name =saveObj.subIndCode;
                   else
                    indResult.Name =saveObj.indCode;             
                  
                  
                  indResult.Baseline__c =saveObj.baseLine;
                  indResult.Actual__c =saveObj.actuals;
                  //indResult.Variance__c =saveObj.differences;
                  indResult.Target__c =saveObj.target;
                  indResult.Note_Comments__c =saveObj.missionNotes;
                  indResult.Notes_Comments_Partner__c =saveObj.partnerNotes;
                  
                   indResult.Organization_Indicator_Master_Id__c =orginalObj.masterOrgInd;  
                   if(imId == null){
       imId = ApexPages.currentpage().getParameters().get('id');
     }
                   indResult.Implementing_Mechanism_Id__c=imId ;
                   
                    String recTypeName;
        if (orginalObj.reportingPeriodLevel   == 'Task'){
            indResult.Activity_Id__c = selectedTasks;
            recTypeName = 'Task';
        } else if(orginalObj.reportingPeriodLevel  == 'Implementing Mechanism'){         
            recTypeName = 'Implementing Mechanism';
        }   
       
        String recTypeId = GU.getRecordTypeId('Indicator_Results__c',recTypeName);
        indResult.RecordTypeId = recTypeId;         
        
        publishReportPeriod.add(orginalObj.reportPeriodId);
              
                  saveIndResult.add(indResult);
               
               }
               
               }    //inside for           
              }          
           }//outside for
       }
      
      
        if(saveIndResult!= null && saveIndResult.size() > 0)  {   
                    System.Debug('saveIndResult****  ' + saveIndResult);
                    // upsert saveIndResult;     
                    saveOrDeleteIndResult(saveIndResult,true,reportingPeriodListForInd );
                
                   }
                  }
     
          
          //Build reporting period Publish list
          List<Reporting_Period__c> reportPubList = new List<Reporting_Period__c>();            
                  for(Reporting_Period__c repPublish:reportingPeriodListForInd ){                  
                      if(repPublish.Status__c == 'Draft'){
                        repPublish.Status__c = 'Publish';
                        repPublish.Targets_Established__c =true;                   
                        reportPubList.add(repPublish);                   
                      }
             }
              
  
        PageReference ref;
        Id inputId = ApexPages.currentpage().getParameters().get('id'); 
      
     
       String currentRequestURL = URL.getCurrentRequestUrl().toExternalForm();
       ref=  new PageReference(currentRequestURL+'&previousPeriod='+selectedYear+'&previousTask='+selectedTasks+'&selectedYearSaved=true&sfdc.override=1');        
        
        ref.setRedirect(true);    
    
      
         Cookie  previousReportYearCookie = new Cookie('selectedYear', selectedYear,null,-1,false);                
         ApexPages.currentPage().setCookies(new Cookie[]{previousReportYearCookie});    
         
          Cookie previousTaskCookie= new Cookie('selectedTasks', selectedTasks,null,-1,false);                
         ApexPages.currentPage().setCookies(new Cookie[]{previousTaskCookie}); 
         
          
           selectedYearName= getselectedYearName();
          selectedTaskName= getselectedTaskName();
          
       //insert publish     
      if(reportPubList != null && reportPubList.size() > 0){      
             ApplicationConstants.bypassReportingPeriodApprovalLogic=true;                 
                    upsert reportPubList;
      }
   
      prepareTargetsXML();
        
     //    return ref;
    }
    
    
    private Double convertToDouble(String doValue){
   
    if(doValue != null){
       doValue = doValue.replaceAll(',','');
       doValue = doValue.replaceAll('\\$','');
       doValue = doValue.replaceAll('\\%','');    
       
    }else{
       doValue='0';
    }
    return  Double.valueOf(doValue);
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
    
  
    
  
   
      public PageReference CancelNGo(){
      
       Cookie previousReportYearCookie= new Cookie('selectedYear', selectedYear,null,0,false);                
             ApexPages.currentPage().setCookies(new Cookie[]{previousReportYearCookie});              
             
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
 
 /**
 
 */
 
 private void saveOrDeleteIndResult(List<indicator_Results__c> indWrapperList, boolean isPublish,List<Reporting_Period__c> reportingPeriodList ){
 
   Set<String> publishReportPeriod = new Set<String>();
   if(indWrapperList != null && indWrapperList.size() > 0){
   List<indicator_Results__c> saveIndRec = new List<indicator_Results__c>();
   List<indicator_Results__c> deleteIndRec = new List<indicator_Results__c>();   
      for(indicator_Results__c indWrap:indWrapperList){
      if(indWrap.id != null && (indWrap.Baseline__c== null || indWrap.Baseline__c == 0) 
                            && (indWrap.Target__c== null || indWrap.Target__c == 0) 
                            && (indWrap.Actual__c== null || indWrap.Actual__c == 0) 
                            && (indWrap.Note_Comments__c== null || indWrap.Note_Comments__c == '') 
                            && (indWrap.Notes_Comments_Partner__c== null || indWrap.Notes_Comments_Partner__c== '') ){
            deleteIndRec.add(indWrap);
         }else{
         publishReportPeriod.add(indWrap.Reporting_Period_Id__c);
             saveIndRec.add(indWrap);
         }
       }    
         
     if(saveIndRec != null && saveIndRec.size() > 0){
        upsert saveIndRec;
        
    /*    if(isPublish){
        if(reportingPeriodList!= null && reportingPeriodList.size() >0){
           for(Reporting_Period__c repPublish:reportingPeriodList){        
            
           if(repPublish.id != null && publishReportPeriod.contains(repPublish.id)){
            if(repPublish.Status__c == 'Draft'){
               repPublish.Status__c = 'Publish';
               repPublish.Targets_Established__c =true;                
                upsert repPublish;
               }
               }
             }
        } 
        }*/
     }
     if(deleteIndRec != null && deleteIndRec.size() > 0){
     delete deleteIndRec;
     }
   }
 }

// Wrapper Class Construction

public class wrapper{

public String orgUnitId{get;set;}
public String indResultId{get;set;}
public String indCode{get;set;}
public String indName{get;set;}
public String subIndCode{get;set;}
public String subIndName{get;set;}
public String indFrequency{get;set;}
public String reportPeriodId{get;set;}
public String reportPeriod{get;set;}
public String reportStatus{get;set;}
public Double baseLine{get;set;}
public Double target{get;set;}
public Double actuals{get;set;}
public Double differences{get;set;}
public String datType{get;set;}
public String partnerNotes{get;set;}
public String missionNotes{get;set;}
public String unitOfMeasures{get;set;}
public String masterOrgInd{get;set;}
public String reportingPeriodLevel{get;set;}
public String fiscalYear{get;set;}

// Wrapper class constructor
public wrapper(){

}
public wrapper(String orgUnitId,String reportPeriodId, String indCode,String indName,String subIndCode,String subIndName,
               String indFrequency,String reportPeriod,String reportStatus,Double baseLine,
               Double target,Double actuals,Double differences,String datType,String partnerNotes,String missionNotes,String unitOfMeasures,String indResultId,String masterOrgInd, String reportingPeriodLevel ,String fiscalYear){
      
        this.orgUnitId=orgUnitId;
        this.reportPeriodId=reportPeriodId;
        this.indCode=indCode;
        this.indName=indName;
        this.subIndCode=subIndCode;
        this.subIndName=subIndName;
        this.indFrequency=indFrequency;
        this.reportPeriod=reportPeriod;
        this.reportStatus=reportStatus;     
        this.baseLine=baseLine;    
        this.target=target;    
        this.actuals=actuals;
        this.differences=differences;
        this.datType=datType;
        this.partnerNotes=partnerNotes;
        this.missionNotes=missionNotes;

      /*   this.baseLine=2.0;
        this.target=3.0;
        this.actuals=4.0;
        this.differences=1.0;
        
        this.partnerNotes='TestPartner';
        this.missionNotes='TestMission';*/
        this.unitOfMeasures=unitOfMeasures;
        this.indResultId = indResultId;
        this.masterOrgInd=masterOrgInd;
        this.reportingPeriodLevel  = reportingPeriodLevel ;
        this.fiscalYear =fiscalYear;
        }

}
 
 
}