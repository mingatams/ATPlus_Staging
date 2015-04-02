public with sharing class ClsDeleteControllerExt {

  public String deleUrl {get;set;}
  public String currentRequestURL {get;set;}
 
    public ClsDeleteControllerExt(ApexPages.StandardController controller) {
        this.controller = controller;
    }
 
    public boolean getHasErrorMessages(){
   
     return ApexPages.hasMessages(ApexPages.Severity.ERROR);
   }
   
  
       
    public PageReference customDelete(){
        PageReference newPage;       
        Try{
            Database.DeleteResult dr = Database.delete(this.controller.getRecord(), false);
           
            if (dr.isSuccess()) {   
                 if(currentRequestURL == null || currentRequestURL =='')           
                    currentRequestURL = URL.getCurrentRequestUrl().toExternalForm();
                 String redirectPage ='';            
                 System.Debug('CurrentURL ***  ' + currentRequestURL );        
                if(currentRequestURL.indexOf('vfProjectFact') > 0){
                  redirectPage ='/apex/VFProjectTab';
                }else if(currentRequestURL.indexOf('vfIMProjectFact') > 0){
                  redirectPage ='/apex/VFPortfolioMapTab';
                }else if(currentRequestURL.indexOf('vfIMBasicDetailFactSheet') > 0){
                  redirectPage ='/apex/VFIMTab';
                }else if(currentRequestURL.indexOf('vfOrgDetailFactSheet') > 0){
                  redirectPage ='/apex/VFOrgUnitTab';
                }else if(deleUrl != null){                 
                   redirectPage =deleUrl; 
                }
                 
                newPage = new PageReference(redirectPage);   
                newPage.setRedirect(true);
                return newPage;
            } else {
                ApexPages.getMessages().clear();                     
                for(Database.Error err : dr.getErrors()) {                  
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,err.getMessage()));
                 }
                 
                return null;        
                   
            }
            
        }catch(Exception e){
        ApexPages.getMessages().clear();     
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
          return null;
        }
        
        
    }
    
    private final ApexPages.StandardController controller;   
    
   
}