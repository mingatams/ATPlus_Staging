/**
* testAAPlanGroupAdminController a test class for AAPlanGroupAdminController.
*
* CHANGE HISTORY
* =============================================================================
* Date				Name				Description
* Sep 07 2014      	Brian Mason			Created
* Oct 07 2014		Brian Mason			Updated	Comments
*
* =============================================================================
*/
@isTest
public class testAAPlanGroupAdminController {
	@isTest(SeeAllData=False)
    public static void testPublicGroupUserAdmin(){
        //User u = [SELECT ID FROM User WHERE Profile.Name = 'System Administrator' AND ID != :UserInfo.getUserID()].get(0);
        User u = TestHelper.getAdminUser(true);
        system.runAs( u ){
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
            List<AAPlan__c> lstPlans = new List<AAPlan__c>{a};
                AAPlanDetail__c b = new AAPlanDetail__c( AandAPlan__c = a.id, 
                                                        AwardTitle__c = 'Test A&A Action', 
                                                        ObligatedAmount__c = 123, 
                                                        Quarter__c = 'Q1' );
        insert b;
        }
        
        Test.startTest();
        //Create Public Group to use on the page
        //List<Group> grps = testAAPlanAdminHelper.createPublicGroups( 1, 'test' );
        List<Group> grps = [SELECT ID FROM Group WHERE Type = 'Regular' AND Name LIKE 'A&A Edit Test Planning Unit' LIMIT 1];
        System.assert( grps.size() == 1, 'Groups were not correctly identified');
        //Set current page to the Group Admin page
        PageReference pageRef = Page.AAPlanGroupAdmin;
        Test.setCurrentPage(pageRef);
        //Add ID of Public Group to the page
        ApexPages.currentPage().getParameters().put( 'id', grps.get(0).id );
        AAPlanGroupAdminController controller = new AAPlanGroupAdminController();
        
        //Assert the controller is receiving the groupID and setting variable
        system.assertEquals( grps.get(0).id, controller.groupID, 'Group ID not set correctly' );
        //Search for a string that will not return results
        controller.userSearch = '';
        controller.searchForUsers();
        //Set controller userSearch variable and fire Search function and populate results
        controller.userSearch = '%';
        controller.searchForUsers();
        //Search for a string that will clear results pulled last
        controller.userSearch = '';
        controller.searchForUsers();
        //Set controller userSearch variable and fire Search function for continued validation
        controller.userSearch = '%';
        controller.searchForUsers();
        //Assert the option list returned with Users has elements
        system.assert( controller.getUsers().size() > 0, 'Users NOT FOUND!' );
        //Set the selected user from the returned users and add user to Public Group
        controller.selectedUser = controller.getUsers().get(0).getValue();
        
        controller.addUser();
        //Assert user has been added to Public Group
        List<GroupMember> groupMemebers = [SELECT ID FROM GroupMember WHERE GroupID = :grps.get(0).id];
        system.assert( groupMemebers.size() > 0, 'User was not added to group successfully' );
        //Set the selected user for removal from Public Group
        controller.userToRemove = controller.getPublicGroupUsers().get(0).getValue();
        controller.removeUser();
        //Assert user has been removed from Public Group
        groupMemebers = [SELECT ID FROM GroupMember WHERE GroupID = :grps.get(0).id];
        system.assert( groupMemebers.size() == 0, 'User was not removed from group successfully' );
		
        Test.stopTest();
    }
    @isTest(SeeAllData=False)
    public static void testPublicGroupGroupAdmin(){
        Test.startTest();
        //Create Public Group to use on the page
        List<Group> parentGroup = testAAPlanAdminHelper.createPublicGroups( 1, 'parenttest' );
        List<Group> childGroup = testAAPlanAdminHelper.createPublicGroups( 1, 'childtest' );
        //Set current page to the Group Admin page
        PageReference pageRef = Page.AAPlanGroupAdmin;
        Test.setCurrentPage(pageRef);
        //Add ID of Public Group to the page
        ApexPages.currentPage().getParameters().put( 'id', parentGroup.get(0).id );
        AAPlanGroupAdminController controller = new AAPlanGroupAdminController();
        
        //Assert the controller is receiving the groupID and setting variable
        system.assertEquals( parentGroup.get(0).id, controller.groupID, 'Group ID not set correctly' );
        //Search for a string that will not return results
        controller.groupSearch = '';
        controller.searchForGroups();
        //Set controller groupSearch variable and fire Search function and populate results
        controller.groupSearch = '%';
        controller.searchForGroups();
        //Search for a string that will clear results pulled last
        controller.groupSearch = '';
        controller.searchForGroups();
        //Set controller groupSearch variable and fire Search function for continued validation
        controller.groupSearch = 'childtest';
        controller.searchForGroups();
        //Assert the option list returned with Public Groups has elements
        system.assert( controller.getGroups().size() > 0, 'Public Group NOT FOUND!' );
        //Set the selected Public Group from the returned Public Groups and add Public Group to Public Group
        controller.selectedGroup = controller.getGroups().get(0).getValue();
        controller.addGroup();
        //Assert Public Group has been added to Public Group
        List<GroupMember> groupMemebers = [SELECT ID FROM GroupMember WHERE GroupID = :parentGroup.get(0).id];
        system.assert( groupMemebers.size() > 0, 'Public Group was not added to Public Group successfully' );
        //Set the selected Public Group for removal from Public Group
        controller.groupToRemove = controller.getPublicGroupGroups().get(0).getValue();
        controller.removeGroup();
        //Assert Public Group has been added to Public Group
        groupMemebers = [SELECT ID FROM GroupMember WHERE GroupID = :parentGroup.get(0).id];
        system.assert( groupMemebers.size() == 0, 'Public Group was not removed from Public Group successfully' );
        Test.stopTest();
    }
}