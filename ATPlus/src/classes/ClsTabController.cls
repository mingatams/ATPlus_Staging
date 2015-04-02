/* Controller used to controll Tab Focus */
public class ClsTabController {

    public ClsTabController(ClsLogFrameOverview controller) {

    }


    public ClsTabController(ClsResultsFrameWorkOverview controller) {

    }


    public ClsTabController(ClsManageIndicatorTargets controller) {
    
 selectedPeriod=ApexPages.currentpage().getParameters().get('selectedPeriod');
  selectedYear=ApexPages.currentpage().getParameters().get('selectedYear');
 //selectedTasks=ApexPages.currentpage().getParameters().get('selectedTasks');
    }

   

    public ClsTabController(ClsOrgUnitIndicatorSController controller) {

    }


public String tabInFocus {get;set;}
public String previousURL {get;set;}
public String navigationLink { get; set;}      
public clsGlobalUtility globalUtil = new clsGlobalUtility();   
public String aId {get;set;}
public String redirect{get;set;}
public OrgUnit__c ou {get;set;}
public String selectedPeriod{get;set;}
public String selectedYear{get;set;}
//public String selectedTasks{get;set;}
  
public ClsTabController (ApexPages.StandardController controller) {
     
     
   //Get Id 
         if(aId == null && ApexPages.currentPage().getParameters().get('Id') != null)
           aId = ApexPages.currentPage().getParameters().get('Id');
         else if(aId == null && ApexPages.currentPage().getParameters().get('id') != null)
           aId = ApexPages.currentPage().getParameters().get('id');
         else{
              Set<String> idKey= ApexPages.currentPage().getParameters().keySet();
                if(idKey != null && idKey.size()>0){
                aId=idKey.iterator().next();
              }          
         }
         
         if(aId != null)
            navigationLink= globalUtil.createBreadCrumps(aId);      
         
   
    //if (globalUtil.getProfile() != 'Mission Partner'){
    if(globalUtil.isPartnerProfileUser() == false){
        List<OrgUnit__c>  OrgList = globalUtil.lookup(globalUtil.getUserRole(),'ouCode__c', 'OrgUnit__c');    
           if(OrgList != null && OrgList.size() > 0){           
               ou =  OrgList.get(0);           
           } else {
               OrgList = globalUtil.lookup('AFG','ouCode__c', 'OrgUnit__c');
               ou =  OrgList.get(0);
           }
     }
    tabInFocus = ApexPages.currentPage().getParameters().get('tabSelected'); 
    Cookie PreviousURLCookie =  ApexPages.currentPage().getCookies().get('previousURL');
    Cookie  selectTabCookie = ApexPages.currentPage().getCookies().get('selectTabCookie');
    if(PreviousURLCookie != null)
       previousURL= PreviousURLCookie.getValue();
    
     
    // If this is the first time the user is accessing the page,create a new cookie 
    if (selectTabCookie == null) {
        selectTabCookie = new Cookie('selectTabCookie',tabInFocus,null,-1,false);
    } else {
        // If this isn't the first time the user is accessing the page create a new cookie, incrementing the value of the original count by 1
        tabInFocus  = selectTabCookie.getValue();
        selectTabCookie = new Cookie('selectTabCookie', tabInFocus  ,null,-1,false);
    }

      // Set the new cookie for the page
      ApexPages.currentPage().setCookies(new Cookie[]{selectTabCookie});  
  }
 
  public ClsTabController () {
  
  }
    
  public String selectedTab {
          get {        
               Cookie selectTabCookie =null;
            if (selectedTab == null) {
            
                if (tabInFocus  != null) {
                    // Select the last saved tab                    
                    selectedTab = tabInFocus;                   
                    selectTabCookie = new Cookie('selectTabCookie',tabInFocus,null,-1,false);
                }
            }    
           
            return selectedTab;
        }
        set {
            
            if (value != selectedTab) {                
                Cookie selectTabCookie = new Cookie('selectTabCookie', value,null,-1,false);                
                ApexPages.currentPage().setCookies(new Cookie[]{selectTabCookie });             
            }
            
            selectedTab = value;
            tabInFocus  =value;
           
        }
    }
    // Method for client-side Javascript to invoke; does nothing
    public PageReference selectTab() {    
        return null;
    }
    
    //Clear Cookie on Page Load
    public void doAction(){
     
      if(previousURL == null){   
          previousURL =  getURLFormat(ApexPages.currentPage().getUrl());
                  
          Cookie previousURLCookie = new Cookie('previousURL', previousURL,null,-1,false);                
          ApexPages.currentPage().setCookies(new Cookie[]{previousURLCookie});    
              Cookie selectTabCookie = new Cookie('selectTabCookie', tabInFocus,null,0,false);                
               ApexPages.currentPage().setCookies(new Cookie[]{selectTabCookie }); 
  Cookie previousReportPeriodCookie= new Cookie('selectedPeriod', selectedPeriod,null,0,false);                
             ApexPages.currentPage().setCookies(new Cookie[]{previousReportPeriodCookie});   
             Cookie previousReportYearCookie= new Cookie('selectedYear', selectedYear,null,0,false);                
             ApexPages.currentPage().setCookies(new Cookie[]{previousReportYearCookie});              
          
       }else{      
       String currentURL = getURLFormat(ApexPages.currentPage().getUrl());
             
           if(previousURL !=currentURL  ){
            tabInFocus=null;
             Cookie previousReportPeriodCookie= new Cookie('selectedPeriod', selectedPeriod,null,0,false);                
             ApexPages.currentPage().setCookies(new Cookie[]{previousReportPeriodCookie}); 
             
               Cookie previousReportYearCookie= new Cookie('selectedYear', selectedYear,null,0,false);                
             ApexPages.currentPage().setCookies(new Cookie[]{previousReportYearCookie});    
             
             
            Cookie previousURLCookie = new Cookie('previousURL', previousURL,null,0,false);                
             ApexPages.currentPage().setCookies(new Cookie[]{previousURLCookie}); 
             
              previousURL = getURLFormat(ApexPages.currentPage().getUrl());             
                           
                previousURLCookie = new Cookie('previousURL', previousURL,null,-1,false);                
             ApexPages.currentPage().setCookies(new Cookie[]{previousURLCookie}); 
             
              Cookie selectTabCookie = new Cookie('selectTabCookie', tabInFocus,null,0,false);                
               ApexPages.currentPage().setCookies(new Cookie[]{selectTabCookie }); 
             
          }
          }        
           
      selectedPeriod=ApexPages.currentpage().getParameters().get('selectedPeriod');
       selectedYear=ApexPages.currentpage().getParameters().get('selectedYear');
     
     //selectedTasks=ApexPages.currentpage().getParameters().get('selectedTasks');
    }
    
  
     /** Redirect for Detail page for Org and RFGoal */
     public PageReference redirectPage() {
     String currentUrl =  getURLFormat(ApexPages.currentPage().getUrl());
      PageReference pageRef; 
     if(currentUrl.IndexOf('VFOrgUnitTab') > -1){
       List<OrgUnit__c>  OrgList = globalUtil.lookup(globalUtil.getUserRole(),'ouCode__c', 'OrgUnit__c');    
           if(OrgList != null && OrgList.size() > 0){  
             String idString =OrgList.get(0).id;
             idString = idString.substring(0, 15) ;         
             pageRef = new PageReference('/apex/vfOrgDetailFactSheet?id=' +idString+'&sfdc.override=1'); 
              pageRef.setRedirect(true);
           }
     }
     else if(currentUrl.IndexOf('VFGoalTab')> -1){
       List<CDCSGoal__c>  goalList= globalUtil.lookup(globalUtil.getUserRole(),'ouCode__c', 'CDCSGoal__c');    
       if(goalList!= null && goalList.size() > 0){      
             String idString =goalList.get(0).id;
             idString = idString.substring(0, 15) ;  
              pageRef = new PageReference('/apex/vfResultsFrameWorkOverview?id=' + idString+'&sfdc.override=1'); 
              pageRef.setRedirect(true);
             }     
     }            
             return pageRef ;         
          }         
 
 /* Helper method to format URL */
   private String getURLFormat(String rURL){    
  
     String strTest =  ApexPages.currentPage().getUrl();
     if(strTest != null){
         String[] arrTest = strTest.split('=');      
         if(aId != null)
         return arrTest[0]+'='+aId.substring(0, 15)+'&sfdc.override=1' ;
     }
     return rURL+'&sfdc.override=1';

    }

 }