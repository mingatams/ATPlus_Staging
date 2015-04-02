/**
* testAAAnnouncementsController is a test class for 
* AAAnnouncementsController.
*
* CHANGE HISTORY
* ======================================================================================
* Date        		Name			Description
* Oct 23 2014		Brian Mason		Created
* Nov 26 2014		Brian Mason		Updated test to add standard user with no access
* ======================================================================================
*/
@isTest
public class testAAAnnouncementsController {

    @isTest(SeeAllData=False)
    public static void test1() {
        insert new List<A_A_Announcement__c>{ new A_A_Announcement__c( Announcement_Title__c='test title',
                                                                                                Announcement__c='Test Announcement',
                                                                                                Start_Date__c=datetime.now().addDays( -1 ),
                                                                                                End_Date__c=datetime.now().addDays( 1 ) ) };
		User u = TestHelper.getStandardUser( TRUE );
        User a = TestHelper.getAdminUser( TRUE );
        Test.startTest();
        
        AAAnnouncementsController con = NULL;
        // First test: user does not have access to page through profiles or permission sets
        System.runAs( u ){
        	con = new AAAnnouncementsController();
        }
        system.assertEquals( 1, con.Announcements.size(), 'Test 1.1 failed: controller not populated correctly.' );
        system.assertEquals( FALSE, con.administerFlag , 'Test 1.2 failed: controller not populating admin flag correctly.' );
        
        con = new AAAnnouncementsController();
        System.runAs( a ){
            con = new AAAnnouncementsController();
        }
        system.assertEquals( 1, con.Announcements.size(), 'Test 1.3 failed: controller not populated correctly.' );
        
        // Third test: user has access to page through permission sets but not profile
        system.runAs( a ){
            PermissionSet pm = [SELECT ID FROM PermissionSet WHERE Name = 'A_A_Announcement_Administration' LIMIT 1];
        	insert new PermissionSetAssignment( AssigneeId = u.id, PermissionSetId = pm.id );
        }
        
        System.runAs( u ){
            con = new AAAnnouncementsController();
        }
        system.assertEquals( 1, con.Announcements.size(), 'Test 1.5 failed: controller not populated correctly.' );
        system.assertEquals( TRUE, con.administerFlag , 'Test 1.6 failed: controller not populating admin flag correctly.' );
        Test.stopTest();
    }
}