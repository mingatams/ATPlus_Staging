/**
* testAAPlanDetailViewController a test class for AAPlanDetailViewController.
*
* CHANGE HISTORY
* =============================================================================
* Date				Name				Description
* Sep 07 2014      	Brian Mason			Created
* Oct 07 2014		Brian Mason			Updated	Test Save function fully
* =============================================================================
*/
@isTest
public class testAAPlanDetailViewController {

    @isTest(SeeAllData = false)
    public static void test1(){
        // Initialize environment
        FiscalYear__c fy = new FiscalYear__c( Name = '2014', Year__c = 2014, CurrentQuar__c = 'Q1', isActive__c = true );
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
        b = [SELECT ID, AandAPlan__c, AwardTitle__c, ObligatedAmount__c, LastModifiedDate FROM AAPlanDetail__c WHERE ID = :b.id];
        List<AA_Quarterly_Update_Fields__c> lstCS = new List<AA_Quarterly_Update_Fields__c>{ 
            new AA_Quarterly_Update_Fields__c( name = 'AwardTitle__c', Field_API_Name__c='AwardTitle__c', Field_Label__c='AwardTitle__c' ),
            new AA_Quarterly_Update_Fields__c( name = 'Quarter__c', Field_API_Name__c='Quarter__c', Field_Label__c='Quarter__c' ),
            new AA_Quarterly_Update_Fields__c( name = 'ObligatedAmount__c', Field_API_Name__c='ObligatedAmount__c', Field_Label__c='ObligatedAmount__c' ),
            new AA_Quarterly_Update_Fields__c( name = 'AandAPlan__c', Field_API_Name__c='AandAPlan__c', Field_Label__c='AandAPlan__c' )};
        // end environment initialization
        // Start test.
        Test.startTest();
        //Testing the page with no ID provided
        PageReference pageRef = Page.AAPlanDetailView;
        Test.setCurrentPage( pageRef );
        AAPlanDetailViewController controller;
        try{
            // check if exception is thrown if custom setting is not available
        	controller = new AAPlanDetailViewController();
        }catch( Exception e ){
            System.assertEquals( 'AAPlanDetailViewController.MissingCustomSettingException',
                                e.getTypeName(), 
                                'Test 1.1: Custom Setting Exception not thrown correctly' );
        }
        // add custom setting so exception is not thrown again
        insert new Object_Field_Ids__c( Name = 'FundType.A_A_Action',
                                        Object_Name__c = 'Fund Type',
                                        Object_API_Name__c = 'Fund_Type__c',
                                        Field_API_Name__c = 'A_A_Action__c',
                                        Field_ID__c = '00Nm0000000U8KJ' );
        // instantiate new controller without exception
        controller = new AAPlanDetailViewController();
        // get next page from cancel button call
        String nextPage = controller.cancel().getURL();
        System.assert( nextPage.toUpperCase().contains('AAPLANDETAILLIST'),
                      'Test 1.2: Next page after Cancel was not set correctly');
        
        // get next page from Sharing button call
        nextPage = controller.SharingACLs().getURL();
        System.assert( nextPage.toUpperCase().contains( 'AAPLANDETAILLIST' ),
                       'Test 1.3: Next page after Sharing was not set correctly');
        
        // Add ID of Public Group to the page
        ApexPages.currentPage().getParameters().put( 'parentid', a.id );
        controller = new AAPlanDetailViewController();        
        
        // Add ID of Public Group to the page
        ApexPages.currentPage().getParameters().put( 'id', b.id );
        controller = new AAPlanDetailViewController();
        System.assert( controller.currentAandARecord != NULL, 'Test 1.4: Record not set correctly' );
        
        // update underlying record to test concurrency check in Save function
        AAPlanDetail__c d = [SELECT ID, ObligatedAmount__c, LastModifiedDate FROM AAPlanDetail__c WHERE ID = :b.id];
        d.ObligatedAmount__c = 345;
        // add a delay to allow 'lastmodifieddate' to have a difference
        // in case test executes too quickly.
        Long startingTime = System.now().getTime(); // Num milliseconds since Jan 1 1970
		Integer delayInMilliseconds = 2000; // One-second delay
		while (System.now().getTime() - startingTime < delayInMilliseconds)  {
		            // Do nothing until desired delay has passed
		}
        system.debug( b.id + ' - ' + b.lastmodifieddate.format( 'HH:MM:ss.SSS' ) );
        update d;
        d = [SELECT ID, ObligatedAmount__c, LastModifiedDate FROM AAPlanDetail__c WHERE ID = :b.id];
        system.debug( d.id + ' - ' + d.lastmodifieddate.format( 'HH:MM:ss.SSSS' ) );
        System.assertEquals( null, controller.save(), 'Test 1.5: Save did not fire correctly' );
        
        // get next page from cancel button call
        nextPage = controller.cancel().getURL();
        System.assert( nextPage.toUpperCase().contains( 'AAPLANDETAILVIEW' ),
                      'Test 1.6: Next page after Cancel was not set correctly' );
        
        // add existing record to page for controller to pickup
        ApexPages.currentPage().getParameters().put( 'id', b.id );
        controller = new AAPlanDetailViewController();
        
        // assert save returns AAPlanDetail__c view page
        nextPage = controller.save().getURL();
        System.assert( nextPage.toUpperCase().contains( 'AAPLANDETAILVIEW' ),
                      'Test 1.7: Next page after Save was not set correctly' );
        
        // assert edit returns AAPlanDetail__c edit page
        nextPage = controller.edit().getURL();
        System.assert( nextPage.toUpperCase().contains( 'AAPLANDETAILEDIT' ),
                      'Test 1.8: Next page after Edit was not set correctly' );
        
        // assert Sharing button returns AAPlanDetail__c Sharing page
        nextPage = controller.SharingACLs().getURL();
        System.assert( nextPage.toUpperCase().contains( 'CUSTOMOBJECTSHARINGDETAIL' ), 
                      'Test 1.9: Next page after Sharing was not set correctly' );
        
        // add delete reason allowing record to be deleted
        b.Delete_Reason__c = 'Test Reason';
        update b;
        
        // assert delete function returns detail list page
        // after successfully deleting record.
        nextPage = controller.deletex().getURL();
        system.assert( nextPage.toUpperCase().contains( 'AAPLANDETAILLIST' ),
                      'Test 1.10: Next page after Delete was not set correctly' );
        
        // finish test
        Test.stopTest();
    }
    
    @isTest(SeeAllData = false)
    public static void test2(){
        // Initialize environment
        FiscalYear__c fy = new FiscalYear__c( Name = '2014', Year__c = 2014, CurrentQuar__c = 'Q1', isActive__c = true );
        insert fy;
        OperatingUnit__c o = new OperatingUnit__c( name = 'Test Planning Unit', Region__c = 'Test Planning Unit' );
        insert o;
        Planning_Unit_User__c puu = new Planning_Unit_User__c( Planning_Unit__c = o.id, User__c = UserInfo.getUserId() );
        insert puu;
        AAPlan__c a = new AAPlan__c( Name = 'Test A&A Plan', FiscalYear__c = fy.id, OperatingUnit__c = o.id );
        insert a;
        AAPlanDetail__c b = new AAPlanDetail__c( AandAPlan__c = a.id, AwardTitle__c = 'Test A&A Action', ObligatedAmount__c = 123 );
        insert b;
        b = [SELECT ID, AandAPlan__c, AwardTitle__c, ObligatedAmount__c, LastModifiedDate FROM AAPlanDetail__c WHERE ID = :b.id];
        List<AA_Quarterly_Update_Fields__c> lstCS = new List<AA_Quarterly_Update_Fields__c>{ 
            new AA_Quarterly_Update_Fields__c( name = 'AwardTitle__c', Field_API_Name__c='AwardTitle__c', Field_Label__c='AwardTitle__c' ),
            new AA_Quarterly_Update_Fields__c( name = 'Quarter__c', Field_API_Name__c='Quarter__c', Field_Label__c='Quarter__c' ),
            new AA_Quarterly_Update_Fields__c( name = 'ObligatedAmount__c', Field_API_Name__c='ObligatedAmount__c', Field_Label__c='ObligatedAmount__c' ),
            new AA_Quarterly_Update_Fields__c( name = 'AandAPlan__c', Field_API_Name__c='AandAPlan__c', Field_Label__c='AandAPlan__c' )};
        insert new Object_Field_Ids__c( Name = 'FundType.A_A_Action',
                                        Object_Name__c = 'Fund Type',
                                        Object_API_Name__c = 'Fund_Type__c',
                                        Field_API_Name__c = 'A_A_Action__c',
                                        Field_ID__c = '00Nm0000000U8KJ' );
        // end environment initialization
        // Start test.
		Test.startTest();
    
        //Testing the page with no ID provided
        PageReference pageRef = Page.AAPlanDetailView;
        Test.setCurrentPage( pageRef );
        AAPlanDetailViewController controller = new AAPlanDetailViewController();
        
        // adding values to blank record before saving it
        controller.currentAandARecord.AandAPlan__c = a.id;
        controller.currentAandARecord.ObligatedAmount__c = 123;
        controller.save();
        
        // assert the record was saved correctly
        System.assert( controller.currentAandARecord.id != null, 'Test 2.1: Record not saved correctly' );
        
        // finish test
        Test.stopTest();
    }
}