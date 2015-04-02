public with sharing class ClsObjectLookupController{

      /** Public and Private Fields */
        public Boolean showRecs{get;set;}
        public string orgunitCode;
        public String objectName{get;set;}     
        private string queryString {get;set;}
        private string fieldNames {get;set;}        
        public string errorMessage {get;set;}
        public string urlLinkField {get;set;}       
        public string ObjectNameUpper {get;set;}                    
        public List<SObject> selectedObjList {get;set;}         
        public List<String> selectColumn {get;set;}   
        public Map<String, Schema.SObjectField> fieldMap {get;set;}  
        public Integer totalpageNumber {get;set;}              
        public string enterstring{get;set;}
        public string objName{get;set;}
        public string  objFieldSet{get;set;}
        public Integer pageSize=25;  
        private String sortDirection = 'ASC';
        private String sortExp = 'name';
    
     /** Controller Initiation */
     public ClsObjectLookupController(){
            UserRole userR = [Select Name From UserRole where Id =:UserInfo.getUserRoleId()];
            this.orgunitCode = ((String)userR.Name).left(((String)userR.Name).indexOf(' | ')); 
            this.orgunitCode='Ken';       
            objectName=ApexPages.currentPage().getParameters().get('ObjectName');
            if(objectName=='Project')
              {
                String activity='Factsheet';//Activity';
                ObjectNameUpper = activity.toUpperCase();
              }else{
               ObjectNameUpper = objectName.toUpperCase();
            }
            processLookupAction();                                                                       
        }
    
    /** Process Lookup Action based on requested  Object Name */                    
     public void processLookupAction(){      
            if (objectName=='OrgUnit')
                  fetch_OrgUnits();
            else if (objectName=='Project')
                  fetch_Project();          
            else if (objectName=='Sub-Awardee')
                  fetch_SubAwardee();
            else if (objectName=='Implementing Mechanism')
                  fetch_IM();
            else if (objectName=='Office')
                  fetch_Office();
            else if (objectName=='MissionUser')
                 fetch_MissionUser();
            else if (objectName=='PortalUser')
                 fetch_PortalUser();  
            else if (objectName=='Sector')
                 fetch_Sector();
            else if (objectName=='Partner')
                 fetch_Partner();   
            else if (objectName=='Bureau')
                 fetch_Bureau();                                                                
     }        
        
  /**Execute Built Query */
  public ApexPages.StandardSetController Con{           
        get {           
            if(con== null) {
                con= new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
            }
            con.setPageSize(pageSize); 
            return con;
        }
        set;
    }        
    
    /** Return Object Record List*/ 
    public List<sobject> getObjectRecords(){    
           ApexPages.getMessages().clear();   
         if(con.getRecords().size() <=0){
                 showRecs = false;     
                 ApexPages.getMessages().clear();                           
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, errorMessage ));
           }                          
        getTotPageNumber();              
        selectedObjList = con.getRecords();   
       
        return selectedObjList;   
    }
  
      /** Fetch Project */   
       private void fetch_Project(){    
          String imCode =  System.currentPageReference().getParameters().get('imCode');  
          String taskIMCode = System.currentPageReference().getParameters().get('taskImCode');
          String pType =  System.currentPageReference().getParameters().get('pType');
          selectedObjList = new Project__c[]{};
          objName='Project__c';
          objFieldSet='ProjectLookUpFieldSet';          
          fieldNames = getQueryFields(objName,ObjFieldSet) ;
          if(imCode != null)
            if (pType.equalsIgnoreCase('IM')){
                queryString ='select '+ fieldNames +' from  Project__c where id Not IN ( Select Project_Code__c  From Public_IM_Link__c where Implementing_Mechanism_Number__c ='+'\'' +imCode+ '\''+') and RecordType.Name = \'IM Project\' '; 
            } else{
            ObjectNameUpper='Project';
                queryString ='select '+ fieldNames +' from  Project__c where id Not IN ( Select Project_Code__c  From Public_IM_Link__c where Implementing_Mechanism_Number__c ='+'\'' +imCode+ '\''+') and RecordType.Name = \'LF Project\' ';
            }             
             
          else if(taskImCode != null)
          queryString ='select '+ fieldNames +' from  Project__c where id IN ( Select Project_Code__c  From Public_IM_Link__c where Project_Type__c = \'IM Project\' AND Implementing_Mechanism_Number__c ='+'\'' +taskImCode+ '\''+') ';           
          else if(this.orgunitCode != null || this.orgunitCode != '')
          queryString ='select '+ fieldNames +' from Project__c where oucode__c ='+'\'' + this.orgunitCode+ '\'';
          else
          queryString ='select '+ fieldNames +' from Project__c where Project_Code__c != null ';
          parseFieldPath(fieldNames);
          System.Debug('Query String ***  ' + queryString);
          showRecs = true;
          errorMessage ='Factsheet are not defined for this Organization.';
        }   
       
       /** Fetch Org Units */  
       private void fetch_OrgUnits(){
          selectedObjList = new OrgUnit__c[]{};
          objName='OrgUnit__c';
          objFieldSet='OrgUnitLookUpFieldSet';
          fieldNames = getQueryFields(objName,ObjFieldSet) ;
          queryString ='select '+ fieldNames +' ,Name from  OrgUnit__c where ouCode__c != null ';
          parseFieldPath(fieldNames);
          System.Debug('Query String ***  ' + queryString);
          showRecs = true;
          errorMessage ='No OrgUnits to Display.';
        }        
        
        /** Fetch Sub Awardee */ 
        private void fetch_SubAwardee(){
          String imCode =  System.currentPageReference().getParameters().get('imCode'); 
          selectedObjList = new Sub_Awardee__c[]{}; 
          objName='Sub_Awardee__c';
          objFieldSet='SubAwardeeLookUpFieldSet';
          fieldNames = getQueryFields(objName,ObjFieldSet) ;
          queryString ='select '+ fieldNames +' from Sub_Awardee__c where ImpMech_Id__c ='+'\'' +imCode+ '\'';
          parseFieldPath(fieldNames);
          System.Debug('Query String ***  ' + queryString);
          showRecs = true;
          errorMessage ='There are no Sub-Awardees associated for the selected Implementing Mechanism.';     
        }
        
       /** Fetch Implementing Mechanism */ 
        private void fetch_IM(){
          String projectCode =  System.currentPageReference().getParameters().get('pCode');
          selectedObjList = new Implementing_Mechanism__c[]{};      
          objName='Implementing_Mechanism__c';
          objFieldSet='IMLookUpFieldSet';
          fieldNames = getQueryFields(objName,ObjFieldSet) ;
          if(projectCode != null)
          queryString ='select '+ fieldNames +' from Implementing_Mechanism__c where Id Not IN ( Select Implementing_Mechanism_Number__c  From Public_IM_Link__c where Project_Code__c ='+'\'' +projectCode+ '\''+') ';     
          else
          queryString ='select '+ fieldNames +' from Implementing_Mechanism__c where Implementing_Mechanism_Name__c != null ';     
          parseFieldPath(fieldNames);
          System.Debug('Query String ***  ' + queryString);
          showRecs = true;
          errorMessage ='Implementing Mechanisms are not defined for the Activity Code selected.'; 
        }
        
      /** Fetch Office */ 
      private void fetch_Office(){

          String orgCode =  System.currentPageReference().getParameters().get('orgCode');         
          selectedObjList = new Office__c[]{};        
          objName='Office__c';
          objFieldSet='OfficeLookUpFieldSet';
          fieldNames = getQueryFields(objName,ObjFieldSet) ;        
          queryString ='select '+ fieldNames +' ,Name from Office__c where ouId__c ='+'\'' +orgCode + '\'';   
          parseFieldPath(fieldNames);
          System.Debug('Query String ***  ' + queryString);
          showRecs = true;
          errorMessage ='Offices are not defined for this Organization.';           
        }
        
  /** Fetch Bureau */ 
      private void fetch_Bureau(){              
          selectedObjList = new Bureau__c[]{};        
          objName='Bureau__c';
          objFieldSet='BureauLookUpFieldSet';
          fieldNames = getQueryFields(objName,ObjFieldSet) ;        
          queryString ='select '+ fieldNames +' ,Name from Bureau__c where burCode__c != null ';   
          parseFieldPath(fieldNames);
          System.Debug('Query String ***  ' + queryString);
          showRecs = true;
                   
        }        
     /** Fetch Sector */ 
     private void fetch_Sector(){                
          selectedObjList = new Sector__c[]{};                  
          objName='Sector__c';
          objFieldSet='SectorLookUpFieldSet';
          fieldNames = getQueryFields(objName,ObjFieldSet) ;
          queryString ='select '+ fieldNames +' ,Name from Sector__c__c where secCode__c != null ';    
          parseFieldPath(fieldNames);
          System.Debug('Query String ***  ' + queryString);
          showRecs = true;
          errorMessage ='No Sectors to Display';                 
        }       
         
     /** Fetch Mission User */    
     private void fetch_MissionUser(){            
          String orgUnit =  System.currentPageReference().getParameters().get('orgUnit');
          OrgUnit__c ou = [select id, Name, ouCode__c From OrgUnit__c where id = :orgUnit];
          UserRole ur = [select Id, Name From UserRole where Name = :ou.Name];
          selectedObjList = new User[]{};         
          objName='User';
          objFieldSet='UserLookUpFieldSet';
          fieldNames = getQueryFields(objName,ObjFieldSet) ;
          queryString ='select '+ fieldNames +' from User where isActive = true and UserRoleId ='+'\'' +ur.Id+ '\'';      
          parseFieldPath(fieldNames);
          System.Debug('Query String ***  ' + queryString);
          showRecs = true;
          errorMessage ='There are no users associated for this Organization.';
      }        
      
      /** Fetch Portal User */  
     private void fetch_PortalUser(){            
          String accId =  System.currentPageReference().getParameters().get('accId');
          selectedObjList = new User[]{};        
          objName='User';
          objFieldSet='UserLookUpFieldSet';
          fieldNames = getQueryFields(objName,ObjFieldSet) ;
          queryString ='select '+ fieldNames +' from User where isActive = true and isPortalEnabled = true and AccountId ='+'\'' +accId+ '\'';      
          parseFieldPath(fieldNames);
          System.Debug('Query String ***  ' + queryString);
          showRecs = true;
          errorMessage ='There are no users associated for this Implementing Partner.';
      }  
      
  /** Fetch Partner Details */  
     private void fetch_Partner(){            
          //String accId =  System.currentPageReference().getParameters().get('accId');
          selectedObjList = new Account[]{};        
          objName='Account';
          objFieldSet='AccountLookUpFieldSet';
          fieldNames = getQueryFields(objName,ObjFieldSet) ;
          queryString ='select '+ fieldNames +' from Account where Vendor_cd__c != null ';      
          parseFieldPath(fieldNames);
          System.Debug('Query String ***  ' + queryString);
          showRecs = true;
          errorMessage ='Partner Not Avaliable.';
      }        
        
       /** Get Fields for given Object Name and FieldSetName */
      public String  getQueryFields( String ObjectName,String fieldSetName)
    {
         String queryFields = '';
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        fieldMap = SObjectTypeObj.getDescribe().fields.getMap();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);        
         for(Schema.FieldSetMember f : fieldSetObj.getFields()) {     
                if(queryFields.length() > 0) {
                   queryFields += ', ';
                }                
                 queryFields += f.getFieldPath();
             }    
     return queryFields; 
    }  
 
    
      /** Get Total Page Number */ 
      private void getTotPageNumber(){
        totalpageNumber  = con.getResultSize()/pageSize;
        Integer remainder = math.mod(con.getResultSize(), pageSize); 
        if(remainder > 0)
            totalpageNumber=totalpageNumber+1;    
    }
    
    /* Search Logic */
    public void search1(){       
        errorMessage ='';         
        processLookupAction();
       boolean isDataExist=false;    
       if(enterstring!=null && enterstring!='')   {  
     for (String f : fieldNames.split(',')) {         
          if(f.trim() != 'Id'){              
            Schema.DisplayType fielddataType = fieldMap.get(f.trim()).getDescribe().getType();
             if(fielddataType == Schema.DisplayType.String){
                if(! isDataExist){
                queryString=queryString +' and ('+f.trim()+ ' like '+'\''+'%'+ enterstring+ '%'+ '\'';
                 isDataExist=true; 
                }else{
                 queryString=queryString +' or  '+f.trim()+ ' like '+'\''+'%'+ enterstring+ '%'+ '\'';
                }
                }
           else if(fielddataType == Schema.DisplayType.Integer){
                if(! isDataExist){
                queryString=queryString +' and ('+f.trim()+ ' >= '+'\''+'%'+ enterstring+ '%'+ '\'';
                 isDataExist=true; 
                }else{
                 queryString=queryString +' or  '+f.trim()+ ' >= '+'\''+'%'+ enterstring+ '%'+ '\'';
                }
             }
          else if(fielddataType == Schema.DisplayType.Picklist){
                if(! isDataExist){
                queryString=queryString +' and ('+f.trim()+ ' = '+'\''+ enterstring+ '\'';
                 isDataExist=true; 
                }else{
                 queryString=queryString +' or  '+f.trim()+ ' = '+'\''+ enterstring+ '\'';
                }
             }
              
 
                }
              }
             
              if(queryString!=null && queryString != '')
                   queryString=queryString +' ) ';
                   
                    con=null;
     }
     
   
   
    }
 
     /** Clear Search Text and Refresh the Page */
     public PageReference clearSearch(){     
         errorMessage='';
         enterstring='';
         con=null;
         ApexPages.getMessages().clear(); 
         processLookupAction();  
         PageReference pageRef = ApexPages.currentPage();
         pageRef.setRedirect(true);        
         return pageRef;      
     }
     
 /** Parse Fields from sObjectType */
      private String[] parseFieldPath(String s) {         
          selectColumn = new List<String>();
          boolean urlColName=false;
          for (String f : s.split(',')) {
          if(f.trim() != 'Id'){
            if(!urlColName){          
                 if (objectName=='OrgUnit' || objectName=='Office')
                     urlLinkField='Name';
                 else        
                     urlLinkField =f.trim();                
               urlColName =true;              
               }
              selectColumn .add(f.trim());              
              }
          }
         
          return selectColumn ;
      }
  
        

 
        public string getParentForm() {
            return System.currentPageReference().getParameters().get('frm');
        }
        
        public string getParentText() {
            return System.currentPageReference().getParameters().get('txt');
        }
        
            
     /*** Pagination control***/
    
     // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {        
            return con.getHasNext();
        }
        set;
    }
 
    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {       
            return con.getHasPrevious();
        }
        set;
    }
 
    // returns the page number of the current page set
    public Integer pageNumber {
        get {
              if(totalpageNumber > 0)
            return con.getPageNumber();
            else
            return totalpageNumber;
        }
        set;
    }
    
 // returns the page number of the current page set
    public Integer getTotalpageNumber {
        get {       
            return totalpageNumber;
        }
        set;
    }
    // returns the first page of records
    public void first() {   
        con.first();
    }
 
    // returns the last page of records
    public void last() {   
        con.last();
    }
 
    // returns the previous page of records
    public void previous() {   
        con.previous();
    }
 
    // returns the next page of records
    public void next() {   
        con.next();
    }
 
    // returns the PageReference of the original page, if known, or the home page.
    public void cancel() {
        con.cancel();
    }
      
 /*** Pagination control***/
 
 
    /* Sorting Start */    
    public void ViewData()
    { 
     processLookupAction();                
     string sortFullExp = sortExpression  + ' ' + sortDirection;   
     queryString=queryString +'order by ' + sortFullExp ;   
     con=null;
    }
        
     /** Build Sort Expression*/ 
    public String sortExpression
    {
        get 
        {
        return sortExp;
        } 
        set
        {
        if (value == sortExp)
        sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
        else
        sortDirection = 'ASC';
        sortExp = value;
        }
    }
    
   /** Get Sort Director*/ 
    public String getSortDirection()
    {
    if (sortExpression == null || sortExpression == '')
    return 'ASC';
    else
    return sortDirection;
    }
    
    /** Set Sort Director*/         
    public void setSortDirection(String value)
    {  
    sortDirection = value;
    }    
    /*Sorting end */


 @IsTest(SeeAllData=true) public static void testClsObjectLookupController() {
 
    ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        System.Test.StartTest();
        String IMId= testIndicatorUtil.getIMForOrgIdNRecordType(OrgUnitId,'Advanced');
         ApexPages.currentPage().getParameters().put('ObjectName','Bureau'); 
        
        //Implementing_Mechanism__c  imLink=[select Id,Name from Implementing_Mechanism__c where id = :IMId];         
       
      //String burString = testIndicatorUtil.getBureauId();
        //Bureau__c burC = [select Id,Name,burCode__c,burName__c from Bureau__c where id = :burString ]; 
        // ApexPages.StandardController thecontroller = new ApexPages.StandardController(burC);
        
        ClsObjectLookupController controller = new ClsObjectLookupController();
         //controller.objName='Bureau__c';
         //controller.objFieldSet='BureauLookUpFieldSet';
        controller.fetch_Bureau();
         ApexPages.currentPage().getParameters().put('ObjectName','Partner');
          controller.fetch_Partner();
        controller.getObjectRecords();
        controller.getTotPageNumber();
       
        controller.fieldNames = controller.getQueryFields('Project__c','ProjectLookUpFieldSet');
        controller.search1();
        controller.enterstring='BUR';
        controller.clearSearch();
        controller.ViewData();
        controller.sortExpression='ASC';
        controller.getSortDirection();
        
         System.Test.StopTest();
        }
}