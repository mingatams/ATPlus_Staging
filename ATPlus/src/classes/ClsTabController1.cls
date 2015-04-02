/* Controller used to controll Tab Focus */
public class ClsTabController1 {

    public ClsTabController1(ApexPages.StandardController controller) {

    }


  


public String tabInFocus1 {get;set;}
public String previousURL1 {get;set;}
public String navigationLink { get; set;}      
public clsGlobalUtility globalUtil = new clsGlobalUtility();   
public String aId {get;set;}
public String redirect{get;set;}
public OrgUnit__c ou {get;set;}

  public ClsTabController1(ClsOrgUnitIndicatorSController controller) {
    

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
       
    
    tabInFocus1 = ApexPages.currentPage().getParameters().get('tabSelected'); 
    Cookie  selectTabCookie1 ;
     Cookie PreviousURLCookie1;
    if(ApexPages.currentPage().getCookies().get('selectTabCookie1') != null)
    selectTabCookie1 = ApexPages.currentPage().getCookies().get('selectTabCookie1');
     if(ApexPages.currentPage().getCookies().get('previousURL1') != null)
    PreviousURLCookie1 =  ApexPages.currentPage().getCookies().get('previousURL1');
    
    if(PreviousURLCookie1 != null)
       previousURL1= PreviousURLCookie1.getValue();
    
     
    // If this is the first time the user is accessing the page,create a new cookie 
    if (selectTabCookie1 == null && tabInFocus1 != null) {
        selectTabCookie1 = new Cookie('selectTabCookie1',tabInFocus1,null,-1,false);
    } else {
        // If this isn't the first time the user is accessing the page create a new cookie, incrementing the value of the original count by 1
       if(selectTabCookie1 != null){
        tabInFocus1  = selectTabCookie1.getValue();
        selectTabCookie1 = new Cookie('selectTabCookie1', tabInFocus1  ,null,-1,false);
        }
    }

      // Set the new cookie for the page
      ApexPages.currentPage().setCookies(new Cookie[]{selectTabCookie1});  

    }
  
    
  public String selectedTab1 {
          get {        
               Cookie selectTabCookie1 =null;
            if (selectedTab1 == null) {
            
                if (tabInFocus1  != null) {
                    // Select the last saved tab                    
                    selectedTab1 = tabInFocus1;                   
                    selectTabCookie1 = new Cookie('selectTabCookie1',tabInFocus1,null,-1,false);
                }
            }    
            System.debug('get selectedTab1**** ' + selectedTab1);
            
            return selectedTab1;
        }
        set {
            
            if (value != selectedTab1) {                
                Cookie selectTabCookie1 = new Cookie('selectTabCookie1', value,null,-1,false);                
                ApexPages.currentPage().setCookies(new Cookie[]{selectTabCookie1 });             
            }
            
            selectedTab1 = value;
            tabInFocus1  =value;
            
            System.debug('Set selectedTab **** ' + selectedTab1);
            System.debug('Set tabInFocus1 **** ' + tabInFocus1);
           
        }
    }
    // Method for client-side Javascript to invoke; does nothing
    public PageReference selectTab() {    
        return null;
    }
    
    //Clear Cookie on Page Load
    public void doAction(){
     
      if(previousURL1 == null){   
          previousURL1 =  getURLFormat(ApexPages.currentPage().getUrl());
                  
          Cookie previousURL2Cookie = new Cookie('previousURL1', previousURL1,null,-1,false);                
          ApexPages.currentPage().setCookies(new Cookie[]{previousURL2Cookie});    
              Cookie selectTabCookie1 = new Cookie('selectTabCookie1', tabInFocus1,null,0,false);                
               ApexPages.currentPage().setCookies(new Cookie[]{selectTabCookie1 }); 
 
       }else{      
       String currentURL1 = getURLFormat(ApexPages.currentPage().getUrl());
                
           if(previousURL1 !=currentURL1){
            tabInFocus1=null;
            
             
            Cookie previousURL2Cookie = new Cookie('previousURL1', previousURL1,null,0,false);                
             ApexPages.currentPage().setCookies(new Cookie[]{previousURL2Cookie}); 
             
              previousURL1 = getURLFormat(ApexPages.currentPage().getUrl());             
                           
                previousURL2Cookie = new Cookie('previousURL1', previousURL1,null,-1,false);                
             ApexPages.currentPage().setCookies(new Cookie[]{previousURL2Cookie}); 
             
              Cookie selectTabCookie1 = new Cookie('selectTabCookie1', tabInFocus1,null,0,false);                
               ApexPages.currentPage().setCookies(new Cookie[]{selectTabCookie1 }); 
             
          }else if(previousURL1 ==currentURL1){
          
           Cookie  selectTabCookie1 = ApexPages.currentPage().getCookies().get('selectTabCookie1');
           if(tabInFocus1 == null && selectTabCookie1!= null)
             tabInFocus1=selectTabCookie1.getValue();
          
          }
          }         
       System.Debug('Previous URL **** ' + previousURL1);
       System.Debug('Current  URL **** ' + ApexPages.currentPage().getUrl());
      System.Debug('Save Tab Parameters ***  ' +tabInFocus1 + ' *** ' + selectedTab1);
    }
    
  
    
 /* Helper method to format URL */
   private String getURLFormat(String rURL){    
     String strTest =  ApexPages.currentPage().getUrl();
      if(strTest != null){
     String[] arrTest = strTest.split('=');      
     if(aId != null){
     if(aId.length() > 15)
     return arrTest[0]+'='+aId.substring(0, 15)+'&sfdc.override=1' ;
     else
      return arrTest[0]+'='+aId+'&sfdc.override=1' ;
     }
     }
     
     return rURL+'&sfdc.override=1';

    }

 }