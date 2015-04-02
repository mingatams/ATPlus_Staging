/**
* testAAPlanDetailListController a test class for AAPlanDetailListController.
*
* CHANGE HISTORY
* =============================================================================
* Date				Name				Description
* Sep 12 2014      	Brian Mason			Created
* Oct 07 2014		Brian Mason			Updated	Comments
* =============================================================================
*/
@isTest
public class testAAPlanDetailListController {

    @isTest(SeeAllData=false)
    public static void test1(){
        List<FiscalYear__c> fys = new List<FiscalYear__c>{
                                new FiscalYear__c( Name = '2013', Year__c = 2013, CurrentQuar__c = 'Q4', isActive__c = False ),
                                new FiscalYear__c( Name = '2015', Year__c = 2015, CurrentQuar__c = 'FY', isActive__c = False ),
                                new FiscalYear__c( Name = '2014', Year__c = 2014, CurrentQuar__c = 'Q1', isActive__c = True )
                            };        
        //FiscalYear__c fy = new FiscalYear__c( Name = '2014', Year__c = 2014, CurrentQuar__c = 'Q1', isActive__c = True );
        //fys.add(fy);
        insert fys;
        OperatingUnit__c o = new OperatingUnit__c( name = 'Test Planning Unit', Region__c = 'Test Planning Unit' );
        insert o;
        /*
        Planning_Unit_User__c puu = new Planning_Unit_User__c( Planning_Unit__c = o.id, User__c = UserInfo.getUserId() );
        insert puu;
        */
        AAPlan__c a = new AAPlan__c( Name = 'Test A&A Plan', FiscalYear__c = fys[2].id, OperatingUnit__c = o.id );
        insert a;
        List<AAPlan__c> lstPlans = new List<AAPlan__c>{a};
        AAPlanDetail__c b = new AAPlanDetail__c( AandAPlan__c = a.id, 
                                                AwardTitle__c = 'Test A&A Action', 
                                                ObligatedAmount__c = 123, 
                                                Quarter__c = 'Q1' );
        insert b;
        
        List<Object_Field_IDs__c> lstCS = new List<Object_Field_IDs__c>{ 
            new Object_Field_IDs__c( name = 'AAPlanDetail.Business_Forecast_Listing', Field_API_Name__c='AwardTitle__c', Field_ID__c='AwardTitle__c', Object_API_Name__c='test', Object_Name__c='test1' ),
            new Object_Field_IDs__c( name = 'test2', Field_API_Name__c='Quarter__c', Field_ID__c='Quarter__c', Object_API_Name__c = 'test1', Object_Name__c='test2' ),
            new Object_Field_IDs__c( name = 'test3', Field_API_Name__c='ObligatedAmount__c', Field_ID__c='ObligatedAmount__c', Object_API_Name__c ='test3', Object_Name__c='test4' ),
            new Object_Field_IDs__c( name = 'test4', Field_API_Name__c='AandAPlan__c', Field_ID__c='AandAPlan__c', Object_API_Name__c = 'test3', Object_Name__c='test4' )};
        insert lstCS;
        
        Test.startTest();
        PageReference pageRef = Page.AAPlanDetailList;
        Test.setCurrentPage(pageRef);       
        AAPlanDetailListController controller = new AAPlanDetailListController();
        system.assert( controller.parentId.length() == 0, 'Test 1.1: ParentId not set correctly' );
        system.assert( controller.queryLimit > 0, 'Test 1.2: SOQL Limit value not set correctly' );
        system.assert( controller.Title == 'All', 'Test 1.3: Title not set correctly' );
        system.assert( controller.OpUnitName.length() == 0, 'Test 1.4: OpUnitName not set correctly' );
        system.assert( controller.OpUnitId.length() == 0, 'Test 1.5: OpUnitName not set correctly' );
        system.assert( controller.Year.length() == 0, 'Test 1.6: OpUnitName not set correctly' );
                      
        ApexPages.currentPage().getParameters().put( 'ParentId', a.id );
        controller = new AAPlanDetailListController();
        system.assert( controller.parentId.length() > 0, 'Test 1.7: ParentId not set correctly' );
        system.assert( controller.results.size() > 0, 'Test 1.8: results not set correctly' );
        system.assert( controller.Title == 'Test A&A Plan', 'Test 1.9 Title not set correctly' );
        system.assert( controller.OpUnitName == 'Test Planning Unit', 'Test 1.10: OpUnitName not set correctly' );
        system.assert( controller.OpUnitId.length() > 0, 'Test 1.11: OpUnitName not set correctly' );
        system.assert( controller.Year.length() > 0, 'Test 1.12: OpUnitName not set correctly' );
        
        ApexPages.currentPage().getParameters().put( 'ParentId', a.id );
        ApexPages.currentPage().getParameters().put( 'Quarter', 'Q1' );
        ApexPages.currentPage().getParameters().put( 'Year', '2014' );
        controller = new AAPlanDetailListController( new ApexPages.StandardSetController( lstPlans ) );
        controller.searchAandAPlan();
        system.assert( controller.parentId.length() > 0, 'Test 1.13: ParentId not set correctly' );
        system.assert( controller.results.size() > 0, 'Test 1.14: results not set correctly' );
        system.assert( controller.Title == 'Test A&A Plan', 'Test 1.15 Title not set correctly' );
        system.assert( controller.OpUnitName == 'Test Planning Unit', 'Test 1.16: OpUnitName not set correctly' );
        system.assert( controller.OpUnitId.length() > 0, 'Test 1.17: OpUnitName not set correctly' );
        system.assert( controller.Year.length() > 0, 'Test 1.18: OpUnitName not set correctly' );
        
        ApexPages.currentPage().getParameters().put('id', b.id );
        controller = new AAPlanDetailListController( new ApexPages.StandardSetController( lstPlans ) );
        b.Delete_Reason__c = 'Test Reason';
        update b;
        controller.deleteRecord();
        system.assert( [SELECT ID FROM AAPlanDetail__c].size() == 0, 'Test 1.19: Record not removed correctly' );
        Test.stopTest();
    }
}