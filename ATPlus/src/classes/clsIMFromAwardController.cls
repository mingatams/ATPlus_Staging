/**
 * This class contains  controller  methods for creating Implementing Mechanism from Award.
 *
 * These controller is used by  vfIMFromAward page
*/
public with sharing class clsIMFromAwardController {
     
    public List<Award__c> AwardsList {get;set;}
    public String pageErrMsg {get;set;}
    public String dispIMAward {get;set;} 
    public Boolean imExists {get;set;}
    public Boolean editMode {get;set;}
    public String userRoleCd {get;set;}
    public String vfpMode  {get;set;}
    public String awName {get;set;}
    public String awPartner {get;set;}
    public String awAwardRef {get;set;}
    public Boolean pcExists {get;set;}
    public Boolean dispSelect  {get;set;}     
        
    private String sortDirection = 'ASC';
    private String sortExp = 'Name';
    private String whereClause ='';
    private String selectedAwardId;
    private String selectedIMId;
    private String retURL;
    private String imId=null;
    public String navigationLink { get; set;}      
    private clsIMAwardUtility awardInfo ; 
    private Award__c selectedAward ;
    private Implementing_Mechanism__c impMech;

    clsGlobalUtility GU = new clsGlobalUtility();
    //constructor
    public clsIMFromAwardController(){
        imExists=false;
        pcExists=false;
        imId=ApexPages.currentPage().getParameters().get('id');
        userRoleCd=GU.getUserRole();
        awardInfo=new clsIMAwardUtility(userRoleCd);
        if (imId !=null) impMech = awardInfo.getIMPMech(imId);
        
          if(imId != null)
            navigationLink= GU.createBreadCrumps(imId );     
            
        if (imId !=null){//edit Mode
                 if(impMech.Partner_User_1__c !=null || impMech.Partner_User_2__c !=null || impMech.Partner_User_3__c !=null || impMech.Partner_User_4__c !=null){
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Partner contacts exist for Implementing Mechanism-'+impMech.Name+'. Cannot update Award.' )); 
                    
                    pcExists=true;
                 }
                 if (impMech.Award_Id__c==null){
                     vfpMode='Select Award to assign to '+impMech.Name;
                     awName=impMech.Implementing_Mechanism_Name__c;
                     awPartner=impMech.Partner_Name__c;
                     awAwardRef=impMech.Award_Number__c;
                 }
                 else{
                    //"{!vfpMode} Implementing Mechanism" 
                     vfpMode='Select Award to reassign to '+impMech.Name;
                 }   
                 if (pcExists){
                     vfpMode=impMech.Name;
                     dispSelect=false;
                 }
                else
                     dispSelect=true;  
                 editMode=true;
        }
        else//create mode
        {
            vfpMode='Select Award to create Implementing Mechanism';
            editMode=false;
           
        }
        if (editMode && pcExists){
                 dispSelect=false; 
        }
        whereclause=' OrgUnit_Code__c=\''+userRoleCd+'\' AND (Implementing_Mechanism__c =null OR Implementing_Mechanism__c = \'\')';
    }
    //Following 4 methods are use as Assigned to methods in VFP 
    public String getAward(){
                if (selectedAward !=null){
                    return selectedAward.Name;
                }
                return 'Select Award';
    }
    public void setAward(String awardId){
            selectedAwardId=awardId;
            if (selectedAwardId !=null){
                selectedAward=awardInfo.getAward(selectedAwardId);
                dispIMAward='IM for -'+selectedAward.Name;
            }
    }
    //Award getter and Setter
    public String getImpMech(){
            if (selectedAward !=null)
                return  selectedIMId;
            return null;
    }
    public void setImpMech(String imId){
        imExists=(imId==null || imId=='')?false:true;
        if(imExists)
            dispIMAward=' IM-'+imId;
        else if (selectedAward !=null)
            dispIMAward='IM for-'+selectedAward.Name;
        selectedIMId=imId;
    }

   /** Search for ProjectTitle Starts with Selected alpha */
    public void searchAlpha(){    
    String alphaSearch = Apexpages.currentPage().getParameters().get('alpha');   
     whereclause=' OrgUnit_Code__c=\''+userRoleCd+'\' AND (Implementing_Mechanism__c =null OR Implementing_Mechanism__c = \'\')';
           
        //Add search parameters to where clause
        if(alphaSearch !=null && alphaSearch .trim() !='')
        whereClause+=' AND PROJECTTITLE__c Like \''+alphaSearch +'%\'';
    
    }
    
    //Function called from Search Button
    public void search(){
            
        awPartner='';
        awName='';
        awAwardRef='';
        awardInfo.counter=0;
        //get search parameters from Page
        awPartner = Apexpages.currentPage().getParameters().get('partner');
        awName = Apexpages.currentPage().getParameters().get('awardtitle');
        awAwardRef = Apexpages.currentPage().getParameters().get('docnumber');
   
        whereclause=' OrgUnit_Code__c=\''+userRoleCd+'\' AND (Implementing_Mechanism__c =null OR Implementing_Mechanism__c = \'\')';
           
        String awardClause='';
        //Add search parameters to where clause
        if(awName !=null && awName.trim() !='')
        whereClause+=' AND PROJECTTITLE__c Like \'%'+awName+'%\'';
            
        if(awPartner !=null && awPartner.trim() !='')
            whereClause +=whereClause !=''?' AND  VENDOR_NM__c Like \'%'+awPartner+'%\'':' VENDOR_NM__c Like \'%'+awPartner+'%\'';

        if(awAwardRef !=null && awAwardRef.trim()!=''){
                  awardClause =  '(DocNum__c Like \'%'+awAwardRef+'%\' OR OrderNum__c Like \'%'+awAwardRef+'%\')';
                  whereClause +=whereClause !='' ? ' AND '+awardClause:awardClause;
        }
          
        awardInfo.whereClause = whereClause;
        system.debug('Search Where Clause-'+awardInfo.whereClause);
    }
    public void refresh(){
        awName ='';
        awPartner ='';
        awAwardRef ='';
        awardInfo.orderBy='';
        awardInfo.counter=0;
        whereclause=' OrgUnit_Code__c=\''+userRoleCd+'\' AND (Implementing_Mechanism__c = null OR Implementing_Mechanism__c = \'\')';
 
    }
    public List<Award__c> getAwards(){
         awardInfo.orderBy=sortExp+' '+sortDirection;
         awardInfo.whereClause = whereClause;
         AwardsList=awardInfo.listdata();
         return AwardsList;
    }
    //methods for sorting
    public void setSortingOrder(){
    //isFilterOn = true;
    }
    public String sortExpression
    {
         get
         {return sortExp;}
         set
         {//if the column is clicked on then switch between Ascending and Descending modes
           if (value == sortExp)
             sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
           else
             sortDirection = 'ASC';
             sortExp = value;
         }
    }
    public String getSortDirection()
    {
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
          return 'ASC';
        else
         return sortDirection;
    }
    public void setSortDirection(String value)
    {  
        sortDirection = value; 
    }
    public PageReference Beginning() { //user clicked beginning
        awardInfo.counter = 0;
        return null;
    }

    public PageReference End() { //user clicked end
        awardInfo.counter = awardInfo.total_size - math.mod(awardInfo.total_size, awardInfo.list_size);
        return null;
       }
    // returns the previous page of records
    public PageReference previous() {
        awardInfo.counter -= awardInfo.list_size;
        return null;
    }
    // returns the next page of records
    public PageReference next() {
        awardInfo.counter += awardInfo.list_size;
        return null;
    }
    public Boolean getDisableNext() { //this will disable the next and end buttons
        if (awardInfo.counter + awardInfo.list_size < awardInfo.total_size) 
            return false; 
        else return true;
       }
    public Integer getTotal_size() {
          return awardInfo.total_size;
    }
    public Integer getPageNumber() {
          return awardInfo.counter/awardInfo.list_size + 1;
    }
    public Integer getTotalPages() {
      if (math.mod(awardInfo.total_size, awardInfo.list_size) > 0) {
         return awardInfo.total_size/awardInfo.list_size + 1;
      } else {
         return (awardInfo.total_size/awardInfo.list_size);
      }
    }      
    public Boolean getDisablePrevious() {
      //this will disable the previous and beginning buttons
      if (awardInfo.counter>0) return false; else return true;
    }
    public pageReference back(){
        
        Id impMechId;
        pageReference pr ;
        if(editMode)
            pr = new pageReference('/'+imId);
        else
            pr = new pageReference('/a0S/o');
        return pr;
    }
    public pageReference save(){
        pageReference pr = new pageReference('/'+selectedIMId);
        return pr;
    }
    public pageReference selAward (){
        return null;
    }
    public pageReference viewIM (){
        pageReference pr = new pageReference('/'+selectedIMId);
        return pr;
    }
    public pageReference selectAward (){
        if(selectedAwardId==null || selectedAwardId==''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Could not get Award Id. Cannot Proceed.-'+selectedAwardId)); 
        }
        selectedAward=awardInfo.getAward(selectedAwardId);
        return null;
    }
    public pageReference updateIM (){
        String oldAwardId=null;
        pageErrMsg='IM Updated';
        selectedAwardId = Apexpages.currentPage().getParameters().get('awardId');          
        Implementing_Mechanism__c im = new  Implementing_Mechanism__c();
        if (impMech!=null)
            im=impMech;
        oldAwardId=im.Award_Id__c;
        im.Award_Id__c=selectedAwardId;
        //Begin Transaction for updating IM Old Award and Selected Award
        award__c aw = awardInfo.getAwardObj(selectedAwardId);
        if (aw!=null && aw.Implementing_Mechanism__c!=null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Award cannot be selected as it is already associated with an Implementing Mechanism.'));          
                return null;
        }
        Savepoint sp = Database.setSavepoint();
        try{
            im.RecordTypeId=GU.getRecordTypeId('Implementing_Mechanism__c', 'Advanced');
            awardInfo.updateIM(im);
            if (oldAwardId !=null)
                awardInfo.updateAward(oldAwardId,null);
            if (selectedAwardId !=null)
                awardInfo.updateAward(selectedAwardId,im.Id);
            pageReference pr = new pageReference('/'+imId);
            pr.setRedirect(true);
            return (pr);
         }
         catch (Exception e) {
            Database.rollback(sp);  
            system.debug('Rolling Back Transaction error occured in updateIM '+e.getStackTraceString());
            pageErrMsg= 'Cannot update Implementing Mechanism for award -'+selectedAwardId+'\\n'+'Error -'+e.getMessage()+' occured in class clsIMFromAwardController at line number -'+e.getLineNumber();
         }
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, pageErrMsg));
        return null;
    }
    public pageReference createIM (){
        pageErrMsg='IM Created';
        Implementing_Mechanism__c im =new Implementing_Mechanism__c();
        selectedAwardId = Apexpages.currentPage().getParameters().get('awardId');
        //1. Fetch  Award Object for select Award 
        //Begin Transaction for updating IM Old Award and Selected Award
  
        award__c aw = awardInfo.getAwardObj(selectedAwardId);
        if (aw !=null){
            im.Award_Id__c=aw.Id;
            if (aw.Implementing_Mechanism__c !=null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Award cannot be selected as it is already associated with an Implementing Mechanism.'));          
                return null;
            }
            //2. Fetch  OrgUnit  Object for orUnit code from select Award
            OrgUnit__c ou = getOrgUnit(aw.OrgUnit_Code__c);
            if (ou !=null)
                im.ouId__c=ou.Id;
        }
        Savepoint sp = Database.setSavepoint();
        try{
            if (aw ==null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Award could not be selected.'));          
                return null;
            }
            im.Implementing_Mechanism_Name__c=aw.PROJECTTITLE__c;
            im.RecordTypeId=GU.getRecordTypeId('Implementing_Mechanism__c', 'Advanced');         
            String imId = awardInfo.createIM(im);
            awardInfo.updateAward(selectedAwardId,imId);
            if (imId !=null){
                pageReference pr = new pageReference('/'+imId);
                return pr;
             }
             pageErrMsg='Could not create IM. Please contact your administrator';
   
        }catch(Exception e){
             Database.rollback(sp);  
             system.debug('Rolling Back Transaction error occured while creating IM '+e.getStackTraceString());
             pageErrMsg= 'Cannot create Implementing Mechanism for award -'+selectedAwardId+'\\n'+'Error -'+e.getMessage()+' occured in class clsIMFromAwardController at line number -'+e.getLineNumber();
                 
         }
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,pageErrMsg));          
         return null;
    }
    private OrgUnit__c getOrgUnit(String OrgUnit_Code){
        try{
            List<OrgUnit__c> ouList= new List<OrgUnit__c>([select Id,ouCode__c from OrgUnit__c where ouCode__c=:OrgUnit_Code ]);
            if (ouList==null || ouList.size()<=0)
                return null;
            return ouList[0];
        }
        catch(Exception e) {
             system.debug('Error occured in getOrgUnit -'+e.getStackTraceString());
             pageErrMsg= 'Could not Select getOrgUnitfor -'+OrgUnit_Code+'\\n'+'Error -'+e.getMessage()+' occured in class clsIMFromAwardController at line number -'+e.getLineNumber();
       }
       return null;
    }
  @IsTest(SeeAllData=true) public static void testIMFromAwardController() {
 
    ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        Test.StartTest();
        String IMId= testIndicatorUtil.getIMForOrgIdNRecordType(OrgUnitId,'Advanced');
         ApexPages.currentPage().getParameters().put('Id',IMId); 
        
        Implementing_Mechanism__c  imLink=[select Id,Name from Implementing_Mechanism__c where id = :IMId];         
        ApexPages.StandardController thecontroller = new ApexPages.StandardController(imLink);
      
          
          Award__c testAward = new Award__c(Name='AwardTest');
          insert testAward;    
        ApexPages.currentPage().getParameters().put('Id',IMId); 
       
        clsIMFromAwardController controller = new clsIMFromAwardController();
        controller.getAward();
        //controller.setAward('TEST');
        controller.getImpMech();
        controller.setImpMech(IMId);         
       Apexpages.currentPage().getParameters().put('alpha','test'); 
       controller.searchAlpha();
       
      
       Apexpages.currentPage().getParameters().put('partner','test'); 
        Apexpages.currentPage().getParameters().put('awardtitle','test'); 
         Apexpages.currentPage().getParameters().put('docnumber','test23');  
       
       controller.search();    
       controller.refresh();
       controller.getAwards();
       controller.setSortingOrder();
       controller.sortExpression='ASC';
        controller.getSortDirection();
        controller.setSortDirection('TEST');
        controller.Beginning();
        controller.End();
        controller.previous();
        controller.next();
        controller.getDisableNext();
        controller.getTotal_size() ;
        controller.getPageNumber();
        controller.getTotalPages();
        controller.getDisablePrevious();
        controller.back();
        controller.save();
         controller.selAward ();
         controller.viewIM ();
         controller.selectAward ();
         Apexpages.currentPage().getParameters().put('awardId',testAward.id); 
         controller.createIM ();
         controller.updateIM ();
          controller.getOrgUnit(OrgUnitId);
          ApexPages.currentPage().getParameters().put('Id',null); 
       
        clsIMFromAwardController controller1 = new clsIMFromAwardController();
         controller1.createIM ();
         controller1.updateIM ();
        Test.StopTest();
    
 }
}//End Controller