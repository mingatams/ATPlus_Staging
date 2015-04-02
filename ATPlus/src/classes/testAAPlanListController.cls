/**
* testAAPlanListController a test class for AAPlanListController.
*
* CHANGE HISTORY
* =============================================================================
* Date				Name				Description
* Sep 07 2014      	Brian Mason			Created
* Oct 07 2014		Brian Mason			Updated	Comments
* =============================================================================
*/
@isTest
public class testAAPlanListController {

    @isTest(SeeAllData = false)
    public static void test1(){

        FiscalYear__c fy = new FiscalYear__c( Name = '2014', Year__c = 2014, CurrentQuar__c = 'Q1' );
        insert fy;
        OperatingUnit__c o = new OperatingUnit__c( name = 'Test Planning Unit', Region__c = 'Test Planning Unit' );
        insert o;
        /*
        Planning_Unit_User__c puu = new Planning_Unit_User__c( Planning_Unit__c = o.id, User__c = UserInfo.getUserId() );
        insert puu;
        */
        AAPlan__c a = new AAPlan__c( Name = 'Test A&A Plan', FiscalYear__c = fy.id, OperatingUnit__c = o.id );
        insert a;
        AAPlanDetail__c b = new AAPlanDetail__c( AandAPlan__c = a.id, AwardTitle__c = 'Test A&A Action', ObligatedAmount__c = 123 );
        insert b;
        
        Test.startTest();
        
        //Set current page to the Group Admin page
        PageReference pageRef = Page.AAPlanList;
        Test.setCurrentPage(pageRef);
        //Add ID of Public Group to the page
        //ApexPages.currentPage().getParameters().put( 'id', grps.get(0).id );
        AAPlanListController controller = new AAPlanListController();
        Integer qLimit = controller.queryLimit;
        system.assert( qLimit != NULL && qLimit > 0, 'Test 1.1: Query limit not returned correctly' );
        
        AAPlan__c[] aaplans = controller.results;
        system.assert( aaplans.size() == 1, 'Test 1.2: Results from controller returned incorrectly' );
        
        ApexPages.currentPage().getParameters().put( 'PlanId', a.id );
        ApexPages.currentPage().getParameters().put( 'Year', '2014' );
        controller = new AAPlanListController( new ApexPages.StandardSetController([SELECT ID FROM AAPlan__c WHERE ID = :a.id]) );
        
        //controller.SearchRegion = '[Test Planning Unit]';
        controller.SearchOperatingUnitId = '[' + o.id + ']';
        controller.SearchFiscalYearId = '[' + fy.id + ']';
        controller.searchAandAPlanMaster();
        system.assert( aaplans.size() == 1, 'Test 1.3: Results from controller returned incorrectly' );
        ApexPages.currentPage().getParameters().put( 'recordId', a.id );
        controller = new AAPlanListController();
        //PageReference nextPage = controller.submitForApproval();
        //system.assert( nextPage == null, 'Test 1.4: Approval not submitted correctly' );
        
        Test.stopTest();
    }
}