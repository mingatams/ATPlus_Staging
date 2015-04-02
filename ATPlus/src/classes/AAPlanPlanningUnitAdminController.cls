/**
* AAPlanPlanningUnitAdminController is used in AAPlanPlanningUnitAdmin to
* assist with administering Planning_Unit_Group__c records.
*
* CHANGE HISTORY
* =============================================================================
* Date				Name				Description
* Aug 26 2014      	Brian Mason			Created
* Oct 07 2014		Brian Mason			Added	Comments
* Oct 09 2014		Brian Mason			Commented out trigger to start removal
*										of Planning_Unit_User__c object from 
*										system.
* =============================================================================
*/
public class AAPlanPlanningUnitAdminController {
	/* Variables */
    public ID planningUnitID { get; private set; }
    public String ActiveTab{ get; set; }
    public OperatingUnit__c varPlanningUnit { get; private set; }
    //public List<Planning_Unit_User__c> varPlanningUnitUser { get; private set;}
    public List<SelectOption> AccessLevels;
/*
    public String userSearch { get; set;}
    private List<User> foundUsers { get; private set; }
    public String selectedUser {get; set;}
    public String addedUserName { get; set; }
    public ID userToRemove { get; set; }
    public Boolean userRemoved { get; private set; }
*/
    public String groupSearch { get; set;}
    private List<Group> foundGroups { get; private set; }
    public ID selectedGroup { get; set; }
    public String selectedAccessLevel { get; set;}

    public ID selectedEditGroup { get; set; }
    public String existingEditGroup { get; private set;}
    public Planning_Unit_Group__c editPlanningUnitGroup;

    public ID selectedReadGroup { get; set; }
    public String existingReadGroup { get; private set;}
    public Planning_Unit_Group__c readPlanningUnitGroup;

	/* Constructor */
    public AAPlanPlanningUnitAdminController(){

        planningUnitID = apexpages.currentPage().getParameters().get('id');

        if( planningUnitID != null ) {
            varPlanningUnit = [SELECT ID, Name, OperatingUnitName__c FROM OperatingUnit__c WHERE ID = :planningUnitID];
            /*
            varPlanningUnitUser = [SELECT ID,
									  Planning_Unit__c,
                               		  User__c,
                               		  User__r.Name,
                               		  Planning_Unit__r.OperatingUnitName__c
                        	FROM Planning_Unit_User__c
                        	WHERE Planning_Unit__c = :planningUnitID];
            */
            List<Planning_Unit_Group__c> existingPUGs = [SELECT ID, Group_ID__c FROM Planning_Unit_Group__c]; 
            Set<ID> existingGroupIDs = new Set<ID>();
            for( Planning_Unit_Group__c pug : existingPUGs ) {
                if( String.isNotBlank( pug.Group_ID__c ) ) {
                    existingGroupIDs.add( (ID)pug.Group_ID__c );
                }
            }
            setAssociatedPublicGroups();
        }
    }

    /* Public Methods */
    // Method fired when Search button for users is clicked
/*
    public void searchForUsers(){
        if( String.isNotBlank( userSearch ) ) {
            refreshMatchingUsers( '%' + userSearch + '%' );
            if ( foundUsers.size() > 15 ) {
            	foundUsers.remove( 15 );
                ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Warning, 'Search results were too large. Please enter more characters of the search string. Only Showing the first 15 results.' ) );
            }
        }else{
            if( foundUsers != null && !foundUsers.isEmpty() ) {
                foundUsers.clear();
            }
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, 'Please populate the "User Name" field before searching.' ) );
        }
        ActiveTab = 'userTab';
    }
*/
	// Method fired when Search button for Groups is clicked
    public void searchForGroups(){
        if( String.isNotBlank( groupSearch ) ) {
            refreshMatchingGroups( '%' + groupSearch + '%' );
            if ( foundGroups.size() > 15 ) {
            	foundGroups.remove( 15 );
                ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Warning, 'Search results were too large. Please enter more characters of the search string. Only Showing the first 15 results.' ) );
            }
        }else{
            if( foundGroups != null && !foundGroups.isEmpty() ) {
                foundGroups.clear();
            }
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, 'Please populate the "Group Name" field before searching.' ) );
        }
        ActiveTab = 'planningUnitTab';
    }

	// Method to return selectoptions for users selection box
/*
    public List<SelectOption> getUsers() {
        List<SelectOption> opts = new List<SelectOption>();
        if( foundUsers != null && !foundUsers.isEmpty() ) {
            for( User u : foundUsers ){
                opts.add( new SelectOption( u.Id, u.Name ) );
            }
        }
        return opts;
    }
*/
	// Method to return selectoptions for Groups selection box
	public List<SelectOption> getGroups() {
        List<SelectOption> opts = new List<SelectOption>();
        if( foundGroups != null && !foundGroups.isEmpty() ) {
            for( Group g : foundGroups ){
                opts.add( new SelectOption( g.Id, g.Name ) );
            }
        }
        return opts;
    }
/*
	// Method to return SelectOptions of Users for dropdown
    public List<SelectOption> getPlanningUnitUsers() {
        List<SelectOption> opts = new List<SelectOption>();
        if( varPlanningUnitUser != null && !varPlanningUnitUser.isEmpty() ){
            for( Planning_Unit_User__c puu : varPlanningUnitUser ) {
                opts.add( new SelectOption( puu.User__c, puu.User__r.Name ) );
            }
        }
        return opts;
    }

	// Method to Add User to Planning_Unit_User__c object
    public void addUser(){
        if( String.isNotBlank( planningUnitID ) && String.isNotBlank( selectedUser ) ) {
            List<Planning_Unit_User__c> userCheck = [SELECT ID FROM Planning_Unit_User__c WHERE User__c = :selectedUser];
            if( userCheck.isEmpty()) {
            	insert( new Planning_Unit_User__c(Planning_Unit__c = planningUnitID, User__c = selectedUser ) );
                addedUserName = [SELECT ID, Name FROM User WHERE ID = :selectedUser].Name;    
            }
            refreshData();
        }
        ActiveTab = 'userTab';
    }

	// Method to remove user from Planning_Unit_User__c object
    public void removeUser() {
        if( String.isNotBlank( planningUnitID ) && String.isNotBlank( userToRemove ) ) {
			List<Planning_Unit_User__c> puu = [SELECT ID 
                                               		FROM Planning_Unit_User__c 
                                               		WHERE User__c = :userToRemove 
                                               		AND Planning_Unit__c = :planningUnitID ];
            if( !puu.isEmpty() ){
                delete puu;
                userRemoved = true;
                refreshData();
            }
        }
        ActiveTab = 'userTab';
    }
*/
	// Method to assign Public Group to Planning Unit using Planning_Unit_Group__c
	// and assign shares on Planning Unit
    public void	addPlanningUnitGroup() {
        if( selectedGroup != NULL && selectedAccessLevel != NULL){
            insert new Planning_Unit_Group__c( Access_Level__c = selectedAccessLevel, Group_ID__c = selectedGroup, Planning_Unit__c = planningUnitID );
            insert new OperatingUnit__share( ParentId = planningUnitID, UserOrGroupId = selectedGroup, AccessLevel = selectedAccessLevel );
        }
        refreshData();
        ActiveTab = 'planningUnitTab';
    }

	// Method to return available Access Levels
	public List<SelectOption> getAccessLevels() {
        refreshAccessLevels();
        return AccessLevels;
    }

	// Method to returning Read groups assigned to Planning Unit
	public Planning_Unit_Group__c getReadPlanningUnitGroup() {
        List<Planning_Unit_Group__c> PUG = new List<Planning_Unit_Group__c>();
        if( planningUnitID != NULL ){
        PUG = [SELECT ID, Access_Level__c, Group_ID__c FROM Planning_Unit_Group__c WHERE Access_Level__c LIKE 'Read' AND Planning_Unit__c = :planningUnitID];
            if( !PUG.isEmpty() ){
                ReadPlanningUnitGroup = PUG.get(0);
            }else{
                ReadPlanningUnitGroup = null;
            }
        }
        return ReadPlanningUnitGroup;
    }

	// Method to returning Edit groups assigned to Planning Unit
    public Planning_Unit_Group__c getEditPlanningUnitGroup() {
        List<Planning_Unit_Group__c> PUG = new List<Planning_Unit_Group__c>();
        if( planningUnitID != NULL ){
            PUG = [SELECT ID, Access_Level__c, Group_ID__c FROM Planning_Unit_Group__c WHERE Access_Level__c LIKE 'Edit' AND Planning_Unit__c = :planningUnitID];
            if( !PUG.isEmpty() ){
                EditPlanningUnitGroup = PUG.get(0);
            }else{
                EditPlanningUnitGroup = null;
            }
        }
        return EditPlanningUnitGroup;
    }

	// Method to return SelectOptions of Public Groups available for selection
	public List<SelectOption> getAvailableGroups() {
        List<SelectOption> opts = new List<SelectOption>();
        Set<ID> existingGroupIDs = new Set<ID>();
        for( Planning_Unit_Group__c pug : [SELECT Group_ID__c FROM Planning_Unit_Group__c] ) {
            if( String.isNotBlank( pug.Group_ID__c ) ) {
                existingGroupIDs.add( (ID)pug.Group_ID__c );
            }
        }
        List<Group> grps = [SELECT ID, Name FROM Group WHERE Type = 'Regular' AND ID NOT IN :existingGroupIDs];

        if( grps != null && !grps.isEmpty() ){
            for( Group g : grps ) {
                opts.add( new SelectOption( g.id, g.Name ) );
            }
        }
        return opts;
    }

	// Method to add Public Group, as the Edit group, to a Planning Unit, through
	// Planning_Unit_Group__c
    public void addEditPlanningUnitGroupPublicGroup(){
        if( selectedEditGroup != NULL && selectedReadGroup == null 
           	||(selectedReadGroup != null && selectedReadGroup != selectedEditGroup) ){
                List<Planning_Unit_Group__c> recsToUpdate = [SELECT ID, 
		                                                             Access_Level__c, 
        		                                                     Group_ID__c, 
                		                                             Planning_Unit__c 
                                                             FROM Planning_Unit_Group__c
                                                             WHERE id = :EditPlanningUnitGroup.Id
                                                             AND Access_Level__c LIKE 'Edit'];
                for( Planning_Unit_Group__c pug : recsToUpdate ){
                    pug.Group_ID__c = selectedEditGroup;
                }
                if( !recsToUpdate.isEmpty() ){
                    update recsToUpdate;
                }
                refreshData();
            } else if( selectedReadGroup != null && selectedEditGroup != NULL && selectedReadGroup == selectedEditGroup ) {
               ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, 'The selected Edit Group cannot be the same as the Read Group.' ) ); 
            }
        ActiveTab = 'planningUnitTab';
    }

	// Method to add Public Group, as the Read group, to a Planning Unit, through
	// Planning_Unit_Group__c
    public void addReadPlanningUnitGroupPublicGroup(){
        if( selectedReadGroup != NULL && selectedEditGroup == null 
           	||(selectedEditGroup != null && selectedEditGroup != selectedReadGroup) ){
                List<Planning_Unit_Group__c> recsToUpdate = [SELECT ID, 
		                                                             Access_Level__c, 
        		                                                     Group_ID__c, 
                		                                             Planning_Unit__c 
                                                             FROM Planning_Unit_Group__c
                                                             WHERE id = :ReadPlanningUnitGroup.Id
                                                             AND Access_Level__c LIKE 'Read'];
                for( Planning_Unit_Group__c pug : recsToUpdate ){
                    pug.Group_ID__c = selectedReadGroup;
                }
                if( !recsToUpdate.isEmpty() ){
                    update recsToUpdate;
                }
                refreshData();
            } else if( selectedEditGroup != null && selectedReadGroup != NULL && selectedEditGroup == selectedReadGroup ) {
               ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, 'The selected Read Group cannot be the same as the Edit Group.' ) ); 
            }
        ActiveTab = 'planningUnitTab';
    }

    /* Private Methods */
    // Method to refresh data
    private void refreshData(){
        //refreshMatchingUsers( '%' + userSearch + '%' );
        refreshMatchingGroups( '%' + groupSearch + '%' );
        /*
        varPlanningUnitUser = [SELECT ID,
                                       Planning_Unit__c,
                                       User__c,
                                       User__r.Name,
                                       Planning_Unit__r.OperatingUnitName__c
                                   FROM Planning_Unit_User__c
                                   WHERE Planning_Unit__c = :planningUnitID];
       */
        List<Planning_Unit_Group__c> existingPUGs = [SELECT ID, Group_ID__c FROM Planning_Unit_Group__c]; 
        Set<ID> existingGroupIDs = new Set<ID>();
        for( Planning_Unit_Group__c pug : existingPUGs ) {
            if( String.isNotBlank( pug.Group_ID__c ) ) {
                existingGroupIDs.add( (ID)pug.Group_ID__c );
            }
        }
        getReadPlanningUnitGroup();
        getEditPlanningUnitGroup();
        setAssociatedPublicGroups();
    }

	// Method to refresh Matching Users for selection options
/*
    private void refreshMatchingUsers( String querySearchUser ) {
        foundUsers = [SELECT ID, 
                      		 Name 
                      	FROM User 
                      	WHERE IsActive = true 
                      	AND Name LIKE :querySearchUser 
                      	AND ID NOT IN(SELECT User__c FROM Planning_Unit_User__c)
                      	LIMIT 16 ];
    }
*/
	// Method to refresh Matching Groups for selection options
    private void refreshMatchingGroups( String querySearchGroup ) {
        Set<ID> existingGroupIDs = new Set<ID>();
        List<Planning_Unit_Group__c> existingPUGs = [SELECT ID, Group_ID__c FROM Planning_Unit_Group__c]; 
        for( Planning_Unit_Group__c pug : existingPUGs ) {
            if( String.isNotBlank( pug.Group_ID__c ) ) {
                existingGroupIDs.add( (ID)pug.Group_ID__c );
            }
        }
        foundGroups = [SELECT ID, 
                      		 Name 
                      	FROM Group 
                      	WHERE Type = 'Regular' 
                      	AND Name LIKE :querySearchGroup 
                      	AND ID NOT IN :existingGroupIDs
                      	Order By Name ASC
                      	LIMIT 16 ];
    }

	// Method to refresh Access level selection dropdown
    private void refreshAccessLevels(){
        if( EditPlanningUnitGroup == NULL && ReadPlanningUnitGroup == NULL ){
            AccessLevels = new List<SelectOption>{ new SelectOption( 'Edit', 'Edit' ), new SelectOption( 'Read', 'Read' ) };
                }else if( EditPlanningUnitGroup != NULL && ReadPlanningUnitGroup == NULL ){
                    AccessLevels = new List<SelectOption>{ new SelectOption( 'Read', 'Read' ) };
                }else if( EditPlanningUnitGroup == NULL && ReadPlanningUnitGroup != NULL ){
                    AccessLevels = new List<SelectOption>{ new SelectOption( 'Edit', 'Edit' ) };
                }else if( EditPlanningUnitGroup != NULL && ReadPlanningUnitGroup != NULL ){
                    AccessLevels = new List<SelectOption>();
                } 
    }

	// Method to set variables associated with displaying
	// public groups already associated with the Planning Unit,
	// through Planning_Unit_Group__c
    private void setAssociatedPublicGroups(){
        Set<ID> existingGroupIDs = new Set<ID>();
        List<Planning_Unit_Group__c> lstPUGs = [SELECT Access_Level__c, Group_ID__c FROM Planning_Unit_Group__c WHERE Planning_Unit__c = :planningUnitID];
        Map<ID, String> mapGrpIDAccess = new Map<ID, String>();
        for( Planning_Unit_Group__c pug : lstPUGs ) {
            if( String.isNotBlank( pug.Group_ID__c ) ) {
                existingGroupIDs.add( (ID)pug.Group_ID__c );
                mapGrpIDAccess.put( (ID)pug.Group_ID__c, pug.Access_Level__c );
            }
        }
        List<Group> grps = [SELECT ID, Name, DeveloperName FROM Group WHERE ID IN :existingGroupIDs];
        for( Group g : grps ){
            if( mapGrpIDAccess.containsKey( g.ID ) && mapGrpIDAccess.get( g.ID ).toUpperCase() == 'EDIT' ){
                existingEditGroup = g.Name;
            }else if( mapGrpIDAccess.containsKey( g.ID ) && mapGrpIDAccess.get( g.ID ).toUpperCase() == 'READ' ){
                existingReadGroup = g.Name;
            }
        }
    }    
}