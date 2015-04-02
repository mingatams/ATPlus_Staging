/**
* testAAPlanPlanningUnitAdminController a test class for 
* AAPlanPlanningUnitAdminController.
*
* CHANGE HISTORY
* =============================================================================
* Date				Name				Description
* Sep 04 2014      	Brian Mason			Created
* Oct 07 2014		Brian Mason			Updated	Comments
* =============================================================================
*/
@isTest
public class testAAPlanPlanningUnitAdminController {
/*
    @isTest(SeeAllData=False)
	public static void testPlanningUnitUserAdmin(){
        Test.startTest();
        //Create a Planning Unit to view in page
        OperatingUnit__c pu = testAAPlanAdminHelper.createPlanningUnit('Test Planning Unit','Test Planning Unit');
        //Set Test page to Planning Unit Admin page
        PageReference pageRef = Page.AAPlanPlanningUnitAdmin;
        Test.setCurrentPage(pageRef);
        //Add ID of Planning Unit to the page
        ApexPages.currentPage().getParameters().put( 'id', pu.id );
        AAPlanPlanningUnitAdminController controller = new AAPlanPlanningUnitAdminController();
        
        //Assert the controller is receiving the groupID and setting variable
        system.assertEquals( pu.id, controller.planningUnitID, 'Planning Unit ID not set correctly' );
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
        //Set the selected user from the returned users and add user to Planning Unit User object
        controller.selectedUser = controller.getUsers().get(0).getValue();
        controller.addUser();
        /*
        //Assert user has been added to Planning Unit User object
        List<Planning_Unit_User__c> puu = [SELECT ID FROM Planning_Unit_User__c WHERE Planning_Unit__c = :pu.id];
        system.assert( puu.size() > 0, 'User was not added to Planning_Unit_User__c successfully' );
        //Set the selected user for removal from Planning Unit User object
        controller.userToRemove = controller.getPlanningUnitUsers().get(0).getValue();
        controller.removeUser();
        //Assert user has been removed from Planning Unit User object
        puu = [SELECT ID FROM Planning_Unit_User__c WHERE Planning_Unit__c = :pu.id];
        system.assert( puu.size() == 0, 'User was not removed from group successfully' );
        Test.stopTest();
    }
    */
	@isTest(SeeAllData=False)
    public static void testPlanningUnitPlanningUnitAdmin(){
        Test.startTest();
        List<Group> grp1 = [SELECT ID FROM Group where Type='Regular'];
        //Create a Planning Unit to view in page
        OperatingUnit__c pu = testAAPlanAdminHelper.createPlanningUnit('Test Planning Unit','Test Planning Unit');
        //Set Test page to Planning Unit Admin page
        PageReference pageRef = Page.AAPlanPlanningUnitAdmin;
        Test.setCurrentPage(pageRef);
        //Add ID of Planning Unit to the page
        ApexPages.currentPage().getParameters().put( 'id', pu.id );
        AAPlanPlanningUnitAdminController controller = new AAPlanPlanningUnitAdminController();
        
        //Assert the controller is receiving the groupID and setting variable
        system.assertEquals( pu.id, controller.planningUnitID, 'Planning Unit ID not set correctly' );
        //Delete Planning_Unit_Group__c that are automatically created with triggers
        List<Planning_Unit_Group__c> pug = [SELECT ID, group_id__c FROM Planning_Unit_Group__c WHERE Planning_Unit__c = :pu.id];
        //Assert there are only two groups created when a Planning Unit is created.
        System.assertEquals( 2, pug.size(), 'Planning Unit Groups were not assigned correctly.');
        //Get Group IDs to use in a test
        List<ID> grpIDs = new List<ID>();
        for( Planning_Unit_Group__c p : pug ){
            grpIDs.add( p.group_ID__c );
        }
        //Delete Planning_Unit_Group__c associated with Planning Units.
        Delete pug;
        
        //Add Group Association to Planning Unit through Planning Unit Group page
        controller.groupSearch = '';
        controller.searchForGroups();
        controller.groupSearch = '%';
        controller.searchForGroups();
        controller.groupSearch = '';
        controller.searchForGroups();
        controller.groupSearch = '%';
        controller.searchForGroups();
        controller.selectedGroup = controller.getGroups().get(0).getValue();
        controller.selectedAccessLevel = controller.getAccessLevels().get(0).getValue();
        controller.addPlanningUnitGroup();
        controller.selectedGroup = controller.getGroups().get(1).getValue();
        controller.selectedAccessLevel = controller.getAccessLevels().get(0).getValue();
        controller.addPlanningUnitGroup();
        
        //Assert there are only two groups created when a Planning Unit is created.
        System.assertEquals( 2, pug.size(), 'Planning Unit Groups were not assigned correctly.' );
        
        //Delete Planning_Unit_Group__c that are automatically created with triggers
        pug = [SELECT ID, group_id__c FROM Planning_Unit_Group__c WHERE Planning_Unit__c = :pu.id];
        //Delete Planning_Unit_Group__c that are assigned after last test
        Delete pug;
        
        controller = new AAPlanPlanningUnitAdminController();
        //Add Group Association to Planning Unit through Planning Unit Group page
        controller.groupSearch = '%';
        controller.searchForGroups();
        controller.selectedGroup = controller.getGroups().get(0).getValue();
        controller.selectedAccessLevel = controller.getAccessLevels().get(1).getValue();
        controller.addPlanningUnitGroup();
        controller.selectedGroup = controller.getGroups().get(1).getValue();
        controller.selectedAccessLevel = controller.getAccessLevels().get(0).getValue();
        controller.addPlanningUnitGroup();
        controller.getAccessLevels();
        //Assert there are only two groups created when a Planning Unit is created.
        System.assertEquals( 2, pug.size(), 'Planning Unit Groups were not assigned correctly.' );
        
        //Update Planning Unit Groups, removing Public Group ID
        pug = [SELECT ID, group_id__c FROM Planning_Unit_Group__c WHERE Planning_Unit__c = :pu.id];
        for( Planning_Unit_Group__c p : pug ){
            p.Group_ID__c = null;
        }
        //Update Planning_Unit_Group__c associated with Planning Units.
        update pug;
        controller.selectedEditGroup = controller.getAvailableGroups().get(0).getValue();
        controller.selectedReadGroup = controller.selectedEditGroup;
        controller.addEditPlanningUnitGroupPublicGroup();
        controller.addReadPlanningUnitGroupPublicGroup();
        //Assert Public Groups have not been added to Planning Unit Group
        pug = [SELECT ID, group_id__c FROM Planning_Unit_Group__c WHERE Planning_Unit__c = :pu.id AND Group_ID__c != NULL];
        System.assertEquals( 0, pug.size(), 'Public Groups were not associated with the Planning Unit Groups correctly.' );
        //Clear Public Group for Edit and Read for reassignment
        controller.selectedEditGroup = null;
        controller.selectedReadGroup = null;
        //Assign values for submitting
        controller.selectedReadGroup = controller.getAvailableGroups().get(0).getValue();
        controller.addReadPlanningUnitGroupPublicGroup();
        controller.selectedEditGroup = controller.getAvailableGroups().get(1).getValue();
        controller.addEditPlanningUnitGroupPublicGroup();
        //Check Planning Unit Group to assert Groups were updated correctly.
        pug = [SELECT ID, group_id__c FROM Planning_Unit_Group__c WHERE Planning_Unit__c = :pu.id AND Group_ID__c != NULL];
        System.assertEquals( 2, pug.size(), 'Public Groups were not associated with the Planning Unit Groups correctly.' );
        
        Test.stopTest();
    }

}