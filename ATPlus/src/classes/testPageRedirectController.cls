@isTest
public class testPageRedirectController {
    @isTest(SeeAllData=false)
    public static void test1(){
        FiscalYear__c fy = new FiscalYear__c( Name = '2014', Year__c = 2014, CurrentQuar__c = 'Q1' );
        insert fy;
        OperatingUnit__c o = new OperatingUnit__c( name = 'Test Planning Unit', Region__c = 'Test Planning Unit' );
        insert o;
        Planning_Unit_User__c puu = new Planning_Unit_User__c( Planning_Unit__c = o.id, User__c = UserInfo.getUserId() );
        insert puu;
        AAPlan__c a = new AAPlan__c( Name = 'Test A&A Plan', FiscalYear__c = fy.id, OperatingUnit__c = o.id );
        insert a;
        AAPlanDetail__c b = new AAPlanDetail__c( AandAPlan__c = a.id, AwardTitle__c = 'Test A&A Action', ObligatedAmount__c = 123 );
        insert b;
        
        Test.startTest();
        PageReference pageRef = Page.AAPlanDetailViewRedirect;
        Test.setCurrentPage(pageRef);   
        PageRedirectController controller = new PageRedirectController();
        
        controller = new PageRedirectController( new ApexPages.StandardController(b) );
        
        String nextPage = controller.redirectAAPlanDetailEdit().getURL();
        System.assert( nextPage.toUpperCase().contains('AAPLANDETAILEDIT'), 'Test 1.1: AAPlanDetalEdit redirect not set correctly' );
        
        nextPage = controller.redirectAAPlanDetailView().getURL();
        System.assert( nextPage.toUpperCase().contains('AAPLANDETAILVIEW'), 'Test 1.2: AAPlanDetalEdit redirect not set correctly' );
        
        nextPage = controller.redirectAAPlanView().getURL();
        System.assert( nextPage.toUpperCase().contains('AAPLANLIST'), 'Test 1.3: AAPlanDetalEdit redirect not set correctly' );
        
        nextPage = controller.redirectSfReports().getURL();
        System.assert( nextPage.toUpperCase().contains('/00O/O'), 'Test 1.4: AAPlanDetalEdit redirect not set correctly' );
            
        Test.stopTest();
    } 
}