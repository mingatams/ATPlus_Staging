public class ClsUserProfileFinder { 
    public ClsUserProfileFinder(ClsManageIndicatorReportingTargets controller) {

    }


    public ClsUserProfileFinder(ClsIndicatorsRelatedList controller) {

    }


    public ClsUserProfileFinder(ClsOrgUnitIndicatorSController controller) {

    }


    public ClsUserProfileFinder(ClsManageIndicatorTargets controller) {

    }
    
    public ClsUserProfileFinder(ManageIMIndicatorTargets controller) {

    }
   
    private final ApexPages.StandardController controller;   
    clsGlobalUtility GU = new clsGlobalUtility();
    
    public ClsUserProfileFinder(ApexPages.StandardController controller) {
        this.controller = controller;
    }   
    
    public ClsUserProfileFinder(){
    }
    
    public ClsUserProfileFinder(ClsTabController controller){        
    }
        public ClsUserProfileFinder(ClsHomePageController controller){        
    }
    
    
     /**
     Method used to check and return true if user has Partner Profile. 
    */
    
    public boolean getIsPartnerUser(){
      return GU.isPartnerProfileUser();   
    }

    /**
     Method used to check and return true if user has Partner Profile. 
    */    
    
   public boolean getIsPLTUser(){
      return GU.isPLTProfileUser();    
      //return GU.isPLTUser();
    }
   
    /**
     Method used to check and return true if user has Partner Profile. 
    */ 
     public boolean getIsSTDUser(){    
       return GU.isSTDProfileUser();      
    }
    
    /**
     Method used to check and return true if user has Partner Profile. 
    */
    public boolean getIsADMINUser(){  
      return GU.isADMINProfileUser();      
    }
    
       /**
     Method used to check and return true if user has PLT - Mission Profile. 
    */
    public boolean getIsPLTMissionUser(){  
      return GU.isPLTMissionUser();      
    }
    
       /**
     Method used to check and return true if user has PLT - Read Only. 
    */
    public boolean getIsPLTReadOnlyUser(){      
       return GU.isPLTReadOnlyUser();  
    }  
       /**
     Method used to check and return true if user has PLT-User Profile. 
    */
    public boolean getIsPLTUserOnly(){      
       return GU.isPLTUser();  
    }  
       /**
     Method used to check and return true if user has STD - AIDtracker Support. 
    */
    public boolean getIsSTDAidtrackSupportUser(){      
       return GU.isSTDAidtrackSupportUser();  
    }  
       /**
     Method used to check and return true if user has STD - AIDtracker Support - Read Only Profile. 
    */
    public boolean getIsSTDAidtrackSupReadOnlyUser(){      
       return GU.isSTDAidtrackSupReadOnlyUser(); 
    }  
    
       /**
     Method used to check and return true if user has STD - Edit Only - Custom. 
    */
    public boolean getIsSTDEditOnlyCustomUser(){      
       return GU.isSTDEditOnlyCustomUser();  
    }  
    
        /**
     Method used to check and return true if user has STD - Edit Only - Custom (Task). 
    */
    public boolean getIsSTDEditOnlyCustomTaskUser(){      
       return GU.isSTDEditOnlyCustomTaskUser();  
    }  
       /**
     Method used to check and return true if user has STD - Mission Profile. 
    */
    public boolean getIsSTDMissionProfileUser(){      
       return GU.isSTDMissionProfileUser();  
    }  
       /**
     Method used to check and return true if user has STD - Read OnlyProfile. 
    */
    public boolean getIsSTDReadOnlyUser(){      
       return GU.isSTDReadOnlyUser();  
    }  
    
   /**
     Method used to check and return true if user has Mission Partner. 
    */
    public boolean getIsMissionPartnerUser(){      
       return GU.isMissionPartnerUser();  
    }        
    
     
    
}