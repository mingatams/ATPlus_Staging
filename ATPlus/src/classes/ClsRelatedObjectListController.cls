public with sharing class ClsRelatedObjectListController{ 
   
  

      /** Public and Private Fields */
        public Boolean showRecs{get;set;}
        
        public String objectName{get;set;}     
        private string queryString {get;set;}
        private string fieldNames {get;set;}        
        public string errorMessage {get;set;}
        public string urlLinkField {get;set;}       
                          
        public List<SObject> selectedObjList {get;set;}         
        public List<String> selectColumn {get;set;}   
        public Map<String, Schema.SObjectField> fieldMap {get;set;} 

        public string parentRecordId{get;set;}
        public Integer pageSize=30;  
        private String sortDirection = 'ASC';
        private String sortExp = 'name';
    
        public List<Sobject> notesAttach {
        get{
            List<Sobject> retList = new List<Sobject>();
            List<Note> notesList = new List<Note>([SELECT CreatedById,IsPrivate,
                             LastModifiedById,LastModifiedDate,Title 
                             FROM Note
                             where (parentId = :(Id)parentRecordId and isPrivate = false)
                             or (parentId = :(Id)parentRecordId and isPrivate = true and createdById = :UserInfo.getUserId())
                             order by lastmodifieddate desc]);
             System.Debug('Notes ***  ' + notesList);                
             List<Attachment> attachList = new List<Attachment>([SELECT CreatedById,IsPrivate,
                             LastModifiedById,LastModifiedDate,Description, Name
                             FROM Attachment
                             where (parentId = :(Id)parentRecordId and isPrivate = false)
                             or (parentId = :(Id)parentRecordId and isPrivate = true and createdById = :UserInfo.getUserId()) 
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
        public sObject parentObject{get;set;}
        public sObject[] parentObjectArray{get;set;}
        
        public List<sObject> relatedObjectArray{get;set;}        
        public String parentobjColName{get;set;}
        public string childObjectName{get;set;}
        public string objFieldSetName{get;set;}
        public string blockHeader{get;set;}
        public string rowNumbers{get;set;}
        public string newPageURL{get;set;}
        public string editPageURL{get;set;}
        public string parentPageURL{get;set;}
        public string secondCondCol{get;set;}
        public string secondCondVal{get;set;}
        public string notesAttachFieldSet = ' id,Name,IsNote,Title,LastModifiedDate,LastModifiedById,createdbyid ';
        static final List<String> notedAttFieldList= new List<String>{'id','Name','IsNote','Title','LastModifiedDate','LastModifiedById','createdbyid'};       
        clsGlobalUtility GU = new clsGlobalUtility();
        
        public boolean getIsPartnerUser(){
          return GU.isPartnerProfileUser();   
        }
              
    /** Controller Initiation */
    public ClsRelatedObjectListController(){
     
             String parentId =ApexPages.currentPage().getParameters().get('parentObj');   
             childObjectName =ApexPages.currentPage().getParameters().get('childName');
             objFieldSetName=ApexPages.currentPage().getParameters().get('fSetName');
             blockHeader=ApexPages.currentPage().getParameters().get('bTitle');     
             newPageURL=ApexPages.currentPage().getParameters().get('newPgURL');
             editPageURL=ApexPages.currentPage().getParameters().get('editPgURL');
             parentPageURL=ApexPages.currentPage().getParameters().get('parentPgURL');               
             parentObject=GU.lookup((Id)parentId , GU.getObjectNameById(parentId ));
             parentobjColName=ApexPages.currentPage().getParameters().get('parentColName');   
             secondCondCol = ApexPages.currentPage().getParameters().get('secondFilterCol');
             secondCondVal = ApexPages.currentPage().getParameters().get('secondFilterVal');
             System.Debug('Parent Id ****' +(Id)parentRecordId);
             System.Debug('Page URL ****' +ApexPages.currentPage());
             System.Debug('New Page URL ***  ' + newPageURL);
             
                                             
           
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
    
     public List<String> getnotedAttFieldList(){ 
     
     return notedAttFieldList;
     }
    /** Return Object Record List*/ 
    public List<sobject> getObjectRecords(){    
    
   
    
       if(queryString== null){
        fetch_Object(); 
       }
           ApexPages.getMessages().clear();   
         if(con.getRecords().size() <=0){
                 showRecs = false;     
                 ApexPages.getMessages().clear();                           
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, errorMessage ));
           }                          
                
        selectedObjList = con.getRecords();  
 
        return selectedObjList;   
    }
  
      /** Fetch Project */   
       private void fetch_Object(){        
       
        if(blockHeader == 'NOTES AND ATTACHMENTS'){
        if(parentObjColName == null)
          parentobjColName=ApexPages.currentPage().getParameters().get('parentColName'); 
          queryString= 'SELECT (select id,IsNote,Title,LastModifiedDate,LastModifiedById,createdbyid From NotesAndAttachments ) FROM '+ parentobjColName +' WHERE id='+'\'' + parentObject.id+ '\''; 
   
        }else{
             fieldNames =getQueryFields(childObjectName,objFieldSetName); 
         
          if(parentObjColName == null)
          parentobjColName=ApexPages.currentPage().getParameters().get('parentColName');
          if (secondCondCol != null && secondCondVal != null){
             queryString ='select '+ fieldNames +' from '+childObjectName +' where ' +parentobjColName +'='+'\'' + parentObject.id+ '\' and ' +secondCondCol +' = \'' +secondCondVal+'\'';
          }  else {
            queryString ='select '+ fieldNames +' from '+childObjectName +' where ' +parentobjColName +'='+'\'' + parentObject.id+ '\'';    
          }      
           
          parseFieldPath(fieldNames);
           }
          System.Debug('Query String ***  ' + queryString);
          showRecs = true;
          errorMessage ='Related List are not defined for selected record.';
         
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
  
 
 
    /* Sorting Start */    
    public void ViewData()
    { 
     fetch_Object();    
      if(sortExpression  != null && sortExpression  !=''){                      
       string sortFullExp = sortExpression  + ' ' + sortDirection;   
       queryString=queryString +' order by  ' + sortFullExp ;     
      }
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
         ApexPages.currentPage().getParameters().put('parentObj',IMId); 
        
    
        
        ClsRelatedObjectListController controller = new ClsRelatedObjectListController();
       
       
         ApexPages.currentPage().getParameters().put('childObjectName','Project__c');
         ApexPages.currentPage().getParameters().put('objFieldSetName','ProjectLookUpFieldSet');
         controller.objectName='Project__c';
        controller.getQueryFields('Project__c','ProjectLookUpFieldSet');
        controller.getnotedAttFieldList();
         controller.parseFieldPath('test,tester');
          controller.childObjectName='Project__c';
         controller.objFieldSetName='ProjectLookUpFieldSet';
         controller.blockHeader = 'TASK';
        controller.ViewData();
        controller.blockHeader = 'TASK';
        //controller.getObjectRecords();
        controller.fetch_Object();
       
        controller.sortExpression='ASC';
        controller.getSortDirection();
        controller.setSortDirection('ASC');
        
        controller.queryString = 'Select id,name from Project__c';
         ApexPages.StandardSetController Con = new ApexPages.StandardSetController(Database.getQueryLocator(controller.queryString));
        controller.getObjectRecords();
        controller.blockHeader = 'NOTES AND ATTACHMENTS';
        controller.parentObjColName =null;
         controller.fetch_Object();
         
         System.Test.StopTest();
        }
  
}