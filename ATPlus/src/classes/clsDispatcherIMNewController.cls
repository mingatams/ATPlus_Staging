/**
 * This class contains  controller for launching Standard page or Implementing Mechanism from Award  pagein New mode
 *
 * These controller is used by  vfDispatcherIMNew page
*/
public with sharing class clsDispatcherIMNewController {
    public clsDispatcherIMNewController(ApexPages.StandardController controller) {
        this.controller = controller;
    }
        public String userRole{get;set;}
        public PageReference getRedir() {
        String retURL = '/a0S/o';
        clsGlobalUtility GU = new clsGlobalUtility();

        String prf = UserInfo.getProfileId();
        String userRole = GU.getWholeUserRole();
       
        PageReference newPage = Page.vfIMBasicNew;
        
        Try{
           // String prfId = GU.getProfile('PLT - Mission Profile');
           //system.debug('Profile: '+prf+'Profile Id1:'+prfId);
          //  if (prf.equals(prfId) )
             if(GU.isPLTProfileUser())
                newPage = Page.vfIMFromAward;
            else{
              newPage = Page.vfIMBasicNew;
                
    
            }   
            return newPage.setRedirect(true);
        }catch(Exception e){
            system.debug('IM Dispatcher New Error -'+e.getMessage());
            return newPage.setRedirect(true);
        }
    }
 
    private final ApexPages.StandardController controller;
     /** Test Method */      
 @IsTest(SeeAllData=true) public static void testRFIndicatorSetup() {
 
    ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        Test.StartTest();
        String IMId= testIndicatorUtil.getIMForOrgIdNRecordType(OrgUnitId,'Advanced');
         ApexPages.currentPage().getParameters().put('Id',IMId); 
        
        Implementing_Mechanism__c  imLink=[select Id,Name from Implementing_Mechanism__c where id = :IMId];         
        ApexPages.StandardController thecontroller = new ApexPages.StandardController(imLink);
      
        clsDispatcherIMNewController controller = new clsDispatcherIMNewController(thecontroller );
        ApexPages.currentPage().getParameters().put('Id',IMId); 
        
        controller.getRedir();         
     
       
        Test.StopTest();
    
 }
}//End Controller