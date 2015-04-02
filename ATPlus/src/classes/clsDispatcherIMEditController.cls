/**
 * This class contains  controller for launching Standard page or Implementing Mechanism from Award  pagein Edit mode
 *
 * These controller is used by  vfDispatcherIMEdit page
*/
public with sharing class clsDispatcherIMEditController {
    
    public clsDispatcherIMEditController(ApexPages.StandardController controller) {
        this.controller = controller;
    }
    public PageReference getRedir() {
           
        User usr ;
        PageReference newPage;
        //String prf = UserInfo.getProfileId();
        String imId='';
        //String profileName = 'PLT - Mission Profile';
        //newPage = new PageReference('/a0S/e');
        newPage = Page.vfIMBasicEdit;
        String imRecType;
        
       //Instantiate Utility Classes
        clsIMAwardUtility IMU = new clsIMAwardUtility();
        clsGlobalUtility GU = new clsGlobalUtility();
        
        //fetch parameters from URL 
        String retURL=ApexPages.currentPage().getParameters().get('retURL');
        imId=ApexPages.currentPage().getParameters().get('id');
        Try{
                usr = [Select Id, ProfileId from User where id=:UserInfo.getUserId()];               
                Implementing_Mechanism__c im= IMU.getIMPMech(imId);
                if(im !=null ){
                    imId=im.Id;
                    imRecType= GU.getRecordType('Implementing_Mechanism__c', im.RecordTypeId);
                }
           
               // Profile prof = [Select Id, Name from Profile where Name=:profileName];
                //If Profile is Pilot and Record Type is Advanced      
                      
               // if (imRecType.equals('Advanced') && ((prof !=null && prf.equals(prof.Id)) || prf.equals('00ed0000000GYdBAAW')))
                 if (imRecType.equals('Advanced') && GU.isPLTProfileUser())
                    newPage = Page.vfIMEdit;
                else{
                    newPage = Page.vfIMBasicEdit;
                  
                }   
                newPage.getParameters().put('id', imId);
                return newPage.setRedirect(true);
        }catch(Exception e){
            system.debug('IM Dispatcher Edit Error -'+e.getMessage());
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
        
        Implementing_Mechanism__c  imLink=[select Id,Name,RecordTypeId from Implementing_Mechanism__c where id = :IMId];         
        ApexPages.StandardController thecontroller = new ApexPages.StandardController(imLink);
      
        clsDispatcherIMEditController controller = new clsDispatcherIMEditController(thecontroller );
        ApexPages.currentPage().getParameters().put('Id',IMId); 
        
        controller.getRedir();         
        IMId= testIndicatorUtil.getIMForOrgIdNRecordType(OrgUnitId,'Basic');
         ApexPages.currentPage().getParameters().put('Id',IMId); 
        
          imLink=[select Id,Name,RecordTypeId from Implementing_Mechanism__c where id = :IMId];         
        ApexPages.StandardController thecontroller1 = new ApexPages.StandardController(imLink);
      
        clsDispatcherIMEditController controller1 = new clsDispatcherIMEditController(thecontroller1 );
        ApexPages.currentPage().getParameters().put('Id',IMId); 
        
        controller1.getRedir();         
         ApexPages.currentPage().getParameters().put('Id',null); 
        
        controller1.getRedir();         
        Test.StopTest();
    
 }
}//End Controller