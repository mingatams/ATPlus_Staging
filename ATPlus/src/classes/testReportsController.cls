/**
* testReportsController is test class for ReportsController
*
* CHANGE HISTORY
* =============================================================================
* Date				Name				Description
* Sep 01 2014      	Brian Mason			Created
* Oct 09 2014		Brian Mason			Added	Comments
* =============================================================================
*/
@isTest
public class testReportsController {

    //Test function to verify the reports are available
    @isTest(SeeAllData=false)
    public static void test1(){
		List<FiscalYear__c> fys = new List<FiscalYear__c>{
                                new FiscalYear__c( Name = '2013', Year__c = 2013, CurrentQuar__c = 'Q4', isActive__c = False ),
                                new FiscalYear__c( Name = '2015', Year__c = 2015, CurrentQuar__c = 'FY', isActive__c = False )
                            };        
        FiscalYear__c fy = new FiscalYear__c( Name = '2014', Year__c = 2014, CurrentQuar__c = 'Q1', isActive__c = True );
        fys.add(fy);
        insert fys;
        OperatingUnit__c o = new OperatingUnit__c( name = 'Test Planning Unit', Region__c = 'Test Planning Unit' );
        insert o;
        /*
        Planning_Unit_User__c puu = new Planning_Unit_User__c( Planning_Unit__c = o.id, User__c = UserInfo.getUserId() );
        insert puu;
        */
        AAPlan__c a = new AAPlan__c( Name = 'Test A&A Plan', FiscalYear__c = fy.id, OperatingUnit__c = o.id );
        insert a;
        AAPlanDetail__c b = new AAPlanDetail__c( AandAPlan__c = a.id, 
                                                AwardTitle__c = 'Test A&A Action', 
                                                ObligatedAmount__c = 123, 
                                                Quarter__c = 'Q1',
                                                TotalEstimateCost__c = '$150,000 - $499,999',
                                                ActionOrAwardType__c ='Contract',
                                                AwardPriority__c = 'Normal',
                                                Status__c = 'Activity Approval',
                                                PartnerOrIncumbentName__c = 'Test Incumbent');
        insert b;
        List<Fund_Type__c> fts = new List<Fund_Type__c>{ new Fund_Type__c( A_A_Action__c = b.id, Funding_Type__c = 'TEST', Funding_Year__c = '2014'),
                                                         new Fund_Type__c( A_A_Action__c = b.id, Funding_Type__c = 'TEST2', Funding_Year__c = '2014')};
        insert fts;
        List<Object_Field_IDs__c> lstCS = new List<Object_Field_IDs__c>{ 
            new Object_Field_IDs__c( name = 'AAPlanDetail.Business_Forecast_Listing', Field_API_Name__c='AwardTitle__c', Field_ID__c='AwardTitle__c', Object_API_Name__c='test', Object_Name__c='test1' ),
            new Object_Field_IDs__c( name = 'test2', Field_API_Name__c='Quarter__c', Field_ID__c='Quarter__c', Object_API_Name__c = 'test1', Object_Name__c='test2' ),
            new Object_Field_IDs__c( name = 'test3', Field_API_Name__c='ObligatedAmount__c', Field_ID__c='ObligatedAmount__c', Object_API_Name__c ='test3', Object_Name__c='test4' ),
            new Object_Field_IDs__c( name = 'test4', Field_API_Name__c='AandAPlan__c', Field_ID__c='AandAPlan__c', Object_API_Name__c = 'test3', Object_Name__c='test4' ),
            new Object_Field_IDs__c( name = 'AAPlanDetail.TotalEstimatedCost', Field_API_Name__c='TotalEstimateCost__c', Field_ID__c='TotalEstimateCost_', Object_API_Name__c = 'test5', Object_Name__c='test5' ),
            new Object_Field_IDs__c( name = 'AAPlanDetail.ActionOrAwardType', Field_API_Name__c='ActionOrAwardType__c', Field_ID__c='ActionOrAwardType_', Object_API_Name__c = 'test6', Object_Name__c='test6' )};
        insert lstCS;
		insert new A_A_Phoenix_Data__c();
		
        Test.startTest();

        //Testing the page with no ID provided
        PageReference pageRef = Page.Reports;
        Test.setCurrentPage(pageRef);       
        ReportsController controller = new ReportsController();
        //System.assert( controller.RegionItems.size() > 0, 'Test 1.1: Regions options not returned correctly' );
        system.assert( controller.FullAAPlanReportUrl != NULL, 'Test 1.2: FullAAPlanReportUrl is not set correctly');
        system.assert( controller.programPlanReportUrl != NULL, 'Test 1.3: programPlanReportUrl is not set correctly');
        system.assert( controller.businessForecastReportUrl != NULL, 'Test 1.4: businessForecastReportUrl is not set correctly');
        system.assert( controller.aaAccountabilityUrl != NULL, 'Test 1.5: aaAccountabilityUrl is not set correctly');
        system.assert( controller.aaBureauReportUrl != NULL, 'Test 1.6: aaBureauReportUrl is not set correctly');
        system.assert( controller.aaBureauSummaryUrl != NULL, 'Test 1.7: aaBureauSummaryUrl is not set correctly');
        system.assert( controller.aaBureauTotalsUrl != NULL, 'Test 1.8: aaBureauTotalsUrl is not set correctly');
        
        Test.stopTest();
    }

    @isTest(SeeAllData=false)
    public static void test2(){
        
        List<FiscalYear__c> fys = new List<FiscalYear__c>{
                                new FiscalYear__c( Name = '2013', Year__c = 2013, CurrentQuar__c = 'Q4', isActive__c = False ),
                                new FiscalYear__c( Name = '2015', Year__c = 2015, CurrentQuar__c = 'FY', isActive__c = False )
                            };        
        FiscalYear__c fy = new FiscalYear__c( Name = '2014', Year__c = 2014, CurrentQuar__c = 'Q1', isActive__c = True );
        fys.add(fy);
        insert fys;
        OperatingUnit__c o = new OperatingUnit__c( name = 'Test Planning Unit', Region__c = 'Test Planning Unit' );
        insert o;
        Planning_Unit_User__c puu = new Planning_Unit_User__c( Planning_Unit__c = o.id, User__c = UserInfo.getUserId() );
        insert puu;
        AAPlan__c a = new AAPlan__c( Name = 'Test A&A Plan', FiscalYear__c = fy.id, OperatingUnit__c = o.id );
        insert a;
        AAPlanDetail__c b = new AAPlanDetail__c( AandAPlan__c = a.id, 
                                                AwardTitle__c = 'Test A&A Action', 
                                                ObligatedAmount__c = 123, 
                                                Quarter__c = 'Q1',
                                                TotalEstimateCost__c = '$150,000 - $499,999',
                                                ActionOrAwardType__c ='Contract',
                                                AwardPriority__c = 'Normal',
                                                Status__c = 'Activity Approval',
                                                PartnerOrIncumbentName__c = 'Test Incumbent');
        insert b;
        List<Fund_Type__c> fts = new List<Fund_Type__c>{ new Fund_Type__c( A_A_Action__c = b.id, Funding_Type__c = 'TEST', Funding_Year__c = '2014'),
                                                         new Fund_Type__c( A_A_Action__c = b.id, Funding_Type__c = 'TEST2', Funding_Year__c = '2014')};
        insert fts;
        List<Object_Field_IDs__c> lstCS = new List<Object_Field_IDs__c>{ 
            new Object_Field_IDs__c( name = 'AAPlanDetail.Business_Forecast_Listing', Field_API_Name__c='AwardTitle__c', Field_ID__c='AwardTitle__c', Object_API_Name__c='test', Object_Name__c='test1' ),
            new Object_Field_IDs__c( name = 'test2', Field_API_Name__c='Quarter__c', Field_ID__c='Quarter__c', Object_API_Name__c = 'test1', Object_Name__c='test2' ),
            new Object_Field_IDs__c( name = 'test3', Field_API_Name__c='ObligatedAmount__c', Field_ID__c='ObligatedAmount__c', Object_API_Name__c ='test3', Object_Name__c='test4' ),
            new Object_Field_IDs__c( name = 'test4', Field_API_Name__c='AandAPlan__c', Field_ID__c='AandAPlan__c', Object_API_Name__c = 'test3', Object_Name__c='test4' ),
            new Object_Field_IDs__c( name = 'AAPlanDetail.TotalEstimatedCost', Field_API_Name__c='TotalEstimateCost__c', Field_ID__c='TotalEstimateCost_', Object_API_Name__c = 'test5', Object_Name__c='test5' ),
            new Object_Field_IDs__c( name = 'AAPlanDetail.ActionOrAwardType', Field_API_Name__c='ActionOrAwardType__c', Field_ID__c='ActionOrAwardType_', Object_API_Name__c = 'test6', Object_Name__c='test6' )};
        insert lstCS;
        insert new AAPlan_Bureau_Phoenix_Report__c();
        Test.startTest();
        
        //Testing the page with no ID provided
        PageReference pageRef = Page.Reports;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put( 'year', fy.Id );
        ApexPages.currentPage().getParameters().put( 'opUnit', o.Id );
        ApexPages.currentPage().getParameters().put( 'BFL', 'Yes' );
        
        ReportsController controller = new ReportsController();
        //controller.SearchRegion = 'Test Planning Unit';
        controller.SearchOperatingUnitId = o.id;
        controller.searchx();
        //system.assert( controller.RegionItems.size() > 0, 'Test 2.1: RegionItems are not set correctly' );
        system.assert( controller.OperatingUnitOptions.size() > 0, 'Test 2.2: OperatingUnitOptions are not set correctly' );
        system.assert( controller.FiscalYearOptions.size() > 0, 'Test 2.3: FiscalYearOptions are not set correctly' );
        system.assert( controller.BFLOptions.size() > 0, 'Test 2.4: BFLOptions are not set correctly' );
        Test.stopTest();
    }
}