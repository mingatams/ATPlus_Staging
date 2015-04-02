/**
* testAppUtil is test class for AppUtil
*
* CHANGE HISTORY
* =============================================================================
* Date				Name				Description
* Sep 06 2014      	Brian Mason			Created
* Oct 09 2014		Brian Mason			Added	Comments
* =============================================================================
*/
@isTest
public class testAppUtil {

    @isTest(SeeAllData = false)
    public static void test1(){
        FiscalYear__c fy = new FiscalYear__c( Year__c = 2014, CurrentQuar__c = 'Q1' , IsActive__c = TRUE );
        insert fy;
        
        OperatingUnit__c pu = new OperatingUnit__c( Name = 'Test' );
        insert pu;
        
        NAICSCode__c n = new NAICSCode__c(Name = 'test', Description__c = 'test');
        insert n;
        
        List<Object_Field_IDs__c> lstCS = new List<Object_Field_IDs__c>{ 
            new Object_Field_IDs__c( name = 'AAPlanDetail.Business_Forecast_Listing', Field_API_Name__c='AwardTitle__c', Field_ID__c='AwardTitle__c', Object_API_Name__c='test', Object_Name__c='test1' ),
            new Object_Field_IDs__c( name = 'test2', Field_API_Name__c='Quarter__c', Field_ID__c='Quarter__c', Object_API_Name__c = 'test1', Object_Name__c='test2' ),
            new Object_Field_IDs__c( name = 'test3', Field_API_Name__c='ObligatedAmount__c', Field_ID__c='ObligatedAmount__c', Object_API_Name__c ='test3', Object_Name__c='test4' ),
            new Object_Field_IDs__c( name = 'test4', Field_API_Name__c='AandAPlan__c', Field_ID__c='AandAPlan__c', Object_API_Name__c = 'test3', Object_Name__c='test4' )};
        insert lstCS;
        
        Test.startTest();
        
        List<SelectOption> opts = AppUtil.prepareSelectOption( Account.Rating.getDescribe() );
        System.assert( opts.size() > 0, 'Test 1.1: Options not populated correctly' );
        
        SelectOption[] opts1 = AppUtil.getFiscalYearOptionsWithId();
        System.assert( opts1.size() > 0, 'Test 1.2: Options not populated correctly' );
        
        opts1 = AppUtil.getFiscalYearOptionsWithNumber();
        System.assert( opts1.size() > 0, 'Test 1.3: Options not populated correctly' );
        
        opts1 = AppUtil.getOperatingUnitOptionsWithId();
        System.assert( opts1.size() > 0, 'Test 1.4: Options not populated correctly' );
        
        opts1 = AppUtil.getNAICSCodeOptions();
        System.assert( opts1.size() > 0, 'Test 1.5: Options not populated correctly' );
        
        opts1 = AppUtil.getRegionOptions();
        System.assert( opts1.size() > 0, 'Test 1.6: Options not populated correctly' );
        
        opts1 = AppUtil.getBFLOptions();
        System.assert( opts1.size() > 0, 'Test 1.7: Options not populated correctly' );
        
        NAICSCode__c nc = AppUtil.getNAICSCodeOptions( 'test' );
        System.assert( nc != NULL, 'Test 1.8: NAICSCode__c not set correctly' );
        
        FiscalYear__c f = AppUtil.getActiveYear();
        System.assert( f != NULL, 'Test 1.9: FiscalYear not populated correctly' );
        
        delete f;
        f = AppUtil.getActiveYear();
        System.assert( f == NULL, 'Test 1.10: FiscalYear not populated correctly' );
        
        PageReference pageRef = Page.AAPlanGroupAdmin;
        Test.setCurrentPage(pageRef);
        //Add ID of Public Group to the page
        ApexPages.currentPage().getParameters().put( 'key', 'testeroo' );
        
        String urlStr = AppUtil.urlParam('key');
        System.assert( urlStr == 'testeroo', 'Test 1.11: Page parameter not set/retrieved correctly' );
        
        Boolean b = AppUtil.isMultiSelectEmpty(null);
        System.assert( b==TRUE, 'Test 1.12: Multiselect function not returning correctly' );
        
        
        String[] strArray =  AppUtil.getStringsFromMultiSelect('[test, test2, test3]');
        System.assert( strArray.size() == 3, 'Test 1.13: String Array was not set correctly' );
        
        String strRptFromCrit = AppUtil.getReportUrlFromCriteria( n.id, 'fieldName', new String[]{'test1', 'Test2', 'Test3'}, new String[]{'Yes'} );
        System.assert( strRptFromCrit.length() > 0, 'Test 1.14: Report URL with Criteria is not being set correctly' );
        
        strRptFromCrit = AppUtil.getReportUrlFromCriteria( n.id, 'fieldName', new String[]{}, new String[]{'Yes', 'No'} );
        System.assert( strRptFromCrit.length() > 0, 'Test 1.15: Report URL with Criteria is not being set correctly' );
        
        String[] values = new String[]{'test1', 'test2', 'test3'};
        String strReptURL = AppUtil.makeBFReportUrlParams( 'fieldName', values, new String[]{'Yes', 'No'} );
        System.assert( strReptURL.length() > 0, 'Test 1.16: Report URL is not being set correctly' );
        
        strReptURL = AppUtil.makeFullAAReportUrlParams(values, new String[]{'Yes'});
        System.assert( strReptURL.length() > 0, 'Test 1.17: Report URL is not being set correctly' );

        
        values.clear();
        strReptURL = AppUtil.makeBFReportUrlParams( 'fieldName', values, new String[]{'Yes', 'No'} );
        System.assert( strReptURL.length() > 0, 'Test 1.18: Report URL is not being set correctly' );
        
        Test.stopTest();
    }
}