/** Extension Controller used to set default value for OrgId while creating project */
public class ClsProjectExtensionController {
     public Project__c p;
     public Boolean isPropsedSelected {get;set;}
     static final String PROPOSED_STATUS='Proposed';
     static final String START_DATE_ID='startDate';
     static final String END_DATE_ID='endDate';
     public clsGlobalUtility globalUtil = new clsGlobalUtility();   
  public ClsProjectExtensionController (ApexPages.StandardController controller) {
    this.controller = controller;
    isPropsedSelected =true;
 
    p =(Project__c)controller.getRecord();    
   /* UserRole urRole=[select name from UserRole where id=:UserInfo.getUserRoleId()];   
    String userRoleName = globalUtil.
    List<OrgUnit__c> listOrgUnit  = [select Id from  OrgUnit__c where Name=:urRole.name];
    if (listOrgUnit.size() > 0)
     {
       OrgUnit__c org  = listOrgUnit.get(0);
        if(org != null && org.Id!=null){
              p.ouId__c=org.Id; 
           }
     }   
    */
     List<OrgUnit__c>  OrgList = globalUtil.lookup(globalUtil.getUserRole(),'ouCode__c', 'OrgUnit__c');    
     if(OrgList != null && OrgList.size() > 0){
        p.ouId__c=OrgList.get(0).Id;           
     } 
     
     p.RecordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
     isStatusChanges(); 
  } 
 /**  Check for status change and set Start and End date required */
  public void isStatusChanges(){
  Map<String,String> parameterMap = ApexPages.currentPage().getParameters();
  if(parameterMap != null)
    {
       for(String dateParm:parameterMap.keySet()){
       if(dateParm.contains(START_DATE_ID))
         {
          if(parameterMap.get(dateParm) != null && parameterMap.get(dateParm) != '')
          p.Start_Date__c =date.parse(parameterMap.get(dateParm));
         }
        if(dateParm.contains(END_DATE_ID)){
            if(parameterMap.get(dateParm) != null && parameterMap.get(dateParm) != '')
          p.End_Date__c =date.parse(parameterMap.get(dateParm));
          }
       }
      
    } 
    
          if(p.Status__c==PROPOSED_STATUS){
           isPropsedSelected = false;
          }
          else {
          isPropsedSelected =true;
          }
      
  }
  
  
    public PageReference save() {
        clsGlobalUtility GU = new clsGlobalUtility();
        Project__c proj = (Project__c)controller.getRecord();
        proj = (Project__c)GU.lookup(proj.Id,'Project__c');
        String recordType;
        if(proj == null) {
            recordType = ApexPages.currentPage().getParameters().get('RecordType');
            } else {        
            recordType = GU.getRecordType('Project__c',proj.RecordTypeId);
        }
        String currURL = ApexPages.currentPage().getUrl();
        system.debug('Current URL'+currURL);
        if(controller.save() != null) {
            PageReference sPageRef;
          if (currURL.contains('Edit')){            
             if (recordType.equalsIgnoreCase('IM Project')){
                sPageRef = new PageReference('/apex/VFIMProjectFactsheet?id='+controller.getId());
            } else {
                sPageRef = new PageReference('/apex/vfProjectFactsheet?id='+controller.getId());
            }         
            sPageRef.setRedirect(true);
            //sPageRef.getParameters().put('id',controller.getId());
            return sPageRef;
          } else if (currURL.contains('vfProjectNew')){
            sPageRef = new PageReference('/apex/vfProjectFactsheet?id='+controller.getId());
            return sPageRef;
          } else if (currURL.contains('vfIMProjectNew')){
             sPageRef = new PageReference('/apex/VFIMProjectFactsheet?id='+controller.getId());
             return sPageRef;
          } 
        }
        return null;
    }
  
    /** Cancel Go to Parent Page */
     public PageReference cancel() {
        clsGlobalUtility GU = new clsGlobalUtility();
        Project__c proj = (Project__c)controller.getRecord();
        proj = (Project__c)GU.lookup(proj.Id,'Project__c');
        //system.debug('Project Record:::'+proj);
        String recordType;
        if(proj == null) {
            recordType = ApexPages.currentPage().getParameters().get('RecordType');
            } else {        
            recordType = GU.getRecordType('Project__c',proj.RecordTypeId);
        }
        //recordType = GU.getRecordType('Project__c',proj.RecordTypeId);      
        PageReference pageRef;     
        String returnURL= ApexPages.currentPage().getParameters().get('retURL');
         if(returnURL != null)
           pageRef = new PageReference(returnURL); 
         else 
             if (recordType.equalsIgnoreCase('IM Project')){
                pageRef = new PageReference('/apex/VFPortfolioMapTab');
            } else {
                pageRef = new PageReference('/apex/vfProjectTab');
            }          
             pageRef.setRedirect(true);
             return pageRef ;         
          }    
          
    private final ApexPages.StandardController controller;     
  
    @IsTest public static void testClsProjectExtensionController() {
        //  clsReportingPeriod CRP = new clsReportingPeriod();
          ClsTestUtility testIndicatorUtil = new ClsTestUtility(); 
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
          Project__c project = testIndicatorUtil.getProjectRecordForOrgId(OrgUnitId);
          test.setCurrentPage(new PageReference('/apex/vfProjectEdit?id='+project.Id));
          ApexPages.currentPage().getParameters().put('startDate','11/27/2010');
          ApexPages.currentPage().getParameters().put('endDate','11/27/2013');            
          ApexPages.StandardController sc5 = new ApexPages.StandardController(project);          
          ClsProjectExtensionController CPE= new ClsProjectExtensionController(sc5);
          CPE.save();
          CPE.cancel();
          test.setCurrentPage(new PageReference('/apex/vfProjectNew'));          
          ApexPages.StandardController sc6 = new ApexPages.StandardController(project);          
          CPE = new ClsProjectExtensionController(sc6);
          CPE.save();
          CPE.cancel();
      
     }      
   
}