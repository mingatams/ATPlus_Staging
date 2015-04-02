/** Extension Controller used to set default value for OrgId while creating project */
public class ClsProjectIMLinkExtController {

private ApexPages.StandardController ctrl;



    public ClsProjectIMLinkExtController(ApexPages.StandardController controllerParam) {
 ctrl = controllerParam;
    }

     
   public List<Public_IM_Link__c> projectIMLinkList {get;set;}    
   public String imNumber {get;set;}   
    public clsGlobalUtility globalUtil = new clsGlobalUtility();        
      /** Controller */ 
        public ClsProjectIMLinkExtController (){        
        imNumber=ApexPages.currentPage().getParameters().get('Id');      
        projectIMLinkList = globalUtil.lookup(imNumber ,'Implementing_Mechanism_Number__c ', 'Public_IM_Link__c');
        
    }

  

 public PageReference saveAndReturn() {
  ctrl.save(); // This takes care of the details for you.
  
  PageReference returnPage= new PageReference(ApexPages.currentPage().getParameters().get('retURL'));   
  returnPage.setRedirect(true);
  return returnPage;
}
 
    // returns the PageReference of the original page, if known, or the home page.
    public PageReference cancel() {
       PageReference returnPage= new PageReference(ApexPages.currentPage().getParameters().get('retURL'));   
  returnPage.setRedirect(true);
  return returnPage;
    }
   
    
    
}