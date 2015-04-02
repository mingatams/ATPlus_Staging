public with sharing class ClsProjectFactSheetControllerExt {
    private Project__c iRec;
    private String filterStr;
   // public Map<String,List<Implementing_Mechanism__c>> projectIMMap{get;set;}
   // public Map<String,Public_IM_Link__c> projectIMLinkMap{get;set;}
   // public Boolean hasImplementingMechanism{get;set;}
    public string  imgURL{get;set;}
    public string imgID{get;set;}
    public boolean photoflag{get;set;}
    public String selectedMemberId{get;set;}
    public String projectDesc{get;set;}
    public String projectResults{get;set;}
    public String projectBenDesc{get;set;}
     public String projAttachRelatInfo{get;set;}
    //public Map<String,List<Note>> notesMap{get;set;}
    //public Map<String,List<Attachment>> attachMap{get;set;}
    
    ClsGlobalUtility GU = new ClsGlobalUtility();
    public ClsProjectFactSheetControllerExt(ApexPages.StandardController controller){       
        iRec = (Project__c)controller.getRecord();
        iRec = (Project__c) GU.lookup(iRec.Id,'Project__c');
       // hasImplementingMechanism = false;
       // List<Sobject> projectIMLinks = GU.lookup(iRec.ID,'Project_Code__c','Public_IM_Link__c');
       // Set<Id> imIds = new Set<Id>();
       // projectIMLinkMap = new Map<String,Public_IM_Link__c>();
       // for(Sobject so: projectIMLinks){
       //     Public_IM_Link__c imLink = (Public_IM_Link__c)so;
       //     imIds.add(imLink.Implementing_Mechanism_Number__c);
       //     projectIMLinkMap.put((String)imLink.Project_Code__c+(String)imLink.Implementing_Mechanism_Number__c,imLink);
       // }
        
        String filterStr;
       // projectIMMap = new Map<String,List<Implementing_Mechanism__c>>();
       // if (!imIds.isEmpty()){
       //     hasImplementingMechanism = true;
       //     filterStr = ' WHERE ID IN ' +GU.prepareINclause(imIds);
       //     List<Implementing_Mechanism__c> imList = new List<Implementing_Mechanism__c>();
       //     List<Sobject> ims = GU.lookupWithFilter(filterStr, 'Implementing_Mechanism__c');
       //     for (SObject so: ims){
       //         Implementing_Mechanism__c im = (Implementing_Mechanism__c)so;
       //         imList.add(im);
       //     }
       //     projectIMMap.put(iRec.Id,imList);
       // }
        
        
         imgURL = iRec.Public_Photo__c;
       
       if (imgURL != null){
           imgURL = imgURL.replaceAll('amp;','');    
           String regex = 'src\\s*=\\s*([\"\'])?([^\"\']*)';
           Matcher m = Pattern.compile(regex).matcher(imgURL);        
           if (m.find()){
               imgID = m.group(2); 
               photoflag = false;           
           }  else {
               imgID = ' ';
               photoflag = true;
            }    
       } else {
         imgID = ' ';
         photoflag = true;
       }
    
    
        projectDesc = GU.getHTMLRemovedText((String)iRec.Project_Description__c);
        if(iRec.AdditionalLinksRelatedInfo__c != null)
        projAttachRelatInfo= (String)iRec.AdditionalLinksRelatedInfo__c.replaceAll('<img.*?>','');
        projectResults = GU.getHTMLRemovedText((String)iRec.Results__c);
        projectBenDesc = GU.getHTMLRemovedText((String)iRec.Beneficiary_Description__c);
        
    //  notesMap = new Map<String,List<Note>>();
    //  notesMap = GU.getRecordNotes(iRec.Id); 
    //  attachMap = new Map<String,List<Attachment>>();
    //  attachMap = GU.getRecordAttachments(iRec.Id);
    }   
    
   /* public PageReference removeMember(){
        system.debug('Inside RemoveMember');
        Public_IM_Link__c linkTobeDeleted = (Public_IM_Link__c)GU.lookup((Id)selectedMemberId,'Public_IM_Link__c');
        delete linkTobeDeleted;
        
        PageReference pageRef; 
        pageRef = new PageReference(ApexPages.currentPage().getURL()); 
        pageRef.setRedirect(true);
        return pageRef;
        
    } */

    @IsTest public static void testClsProjectExtensionController() {
        //  clsReportingPeriod CRP = new clsReportingPeriod();
          ClsTestUtility testIndicatorUtil = new ClsTestUtility(); 
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
          Project__c project = testIndicatorUtil.getProjectRecordForOrgId(OrgUnitId);
          project.Public_Photo__c ='www.salesforce.com';
          ApexPages.currentPAge().getParameters().put('id',project.Id);    
          ApexPages.StandardController sc5 = new ApexPages.StandardController(project);          
          ClsProjectFactSheetControllerExt  CPFC= new ClsProjectFactSheetControllerExt(sc5);  
          
          
          
      
     }


}