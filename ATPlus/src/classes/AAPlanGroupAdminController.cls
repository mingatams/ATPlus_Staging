/**
* AAPlanGroupAdminController is used in AAPlanGroupAdmin to
* assist with administering Public Group records.
*
* CHANGE HISTORY
* =============================================================================
* Date				Name				Description
* Aug 21 2014      	Brian Mason			Created
* Oct 07 2014		Brian Mason			Added	Comments
* =============================================================================
*/
public with sharing class AAPlanGroupAdminController {
	/* Search and disaply variables */
    public ID groupID { get; private set; }
    public Group varGroup { get; private set; }
    public String ActiveTab{ get; set; }

    public String userSearch { get; set;}
    private List<User> foundUsers { get; private set; }
    public String selectedUser {get; set;}
    public String addedUserName { get; set; }

    public String groupSearch { get; set;}
    private List<Group> foundGroups { get; private set; }
    public String selectedGroup {get; set;}
    public String addedGroupName { get; set; }

    public Boolean userRemoved { get; private set; }
    public ID userToRemove { get; set; }
    private List<User> existingUsers { get; private set;}

    public Boolean groupRemoved { get; private set; }
    public ID groupToRemove { get; set; }
    private List<Group> existingGroups { get; private set;}

    /* Constructor: sets variables for use in page */
    public AAPlanGroupAdminController(){
        groupID = apexpages.currentPage().getParameters().get('id');

        if( groupID != null ) {
            varGroup = [SELECT ID,
                        		Name,
                        		DeveloperName
                        	FROM Group
                        	WHERE Type = 'Regular'
                        	AND ID = :groupID];
            existingUsers = [SELECT ID,
                            		Name,
                            		Email
                            	FROM USER
                            	WHERE IsActive = TRUE
                             	AND ID IN
                             (SELECT UserOrGroupID FROM GroupMember WHERE GroupID = :groupID)
                             Order By Name ASC];
            existingGroups = [SELECT ID,
                            		Name
                            	FROM Group
                            	WHERE ID IN
                             (SELECT UserOrGroupID FROM GroupMember WHERE GroupID = :groupID)
                             Order By Name ASC];
        }
    }

	/* Public Methods */
	// Method fired when Search button for users is clicked
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
        ActiveTab = 'userAdmin';
    }

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
        ActiveTab = 'groupAdmin';
    }

	// Method to return selectoptions for users selection box
    public List<SelectOption> getUsers() {
        List<SelectOption> opts = new List<SelectOption>();
        if( foundUsers != null && !foundUsers.isEmpty() ) {
            for( User u : foundUsers ){
                opts.add( new SelectOption( u.Id, u.Name + ' - ' + u.email ) );
            }
        }
        return opts;
    }

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

	// method to add user to a Public Group
    public void addUser(){
        if( String.isNotBlank( groupID ) && String.isNotBlank( selectedUser ) ) {
            insert( new GroupMember( GroupID = groupID, UserOrGroupId = selectedUser ) );
            addedUserName = [SELECT ID, Name FROM User WHERE ID = :selectedUser].Name;
            refreshData();
            searchForUsers();            
            ActiveTab = 'userAdmin';
        }
    }

    /*
    @future
    public static void sharePlanningUnitWithUser( String groupID, String selectedUser){
    	//holder for new shares
		List<OperatingUnit__Share> shares = new List<OperatingUnit__Share>();
    	
    	//get the Planning Unit Group junction object
    	//so we can get the ID of the Planning Unit to share
    	Planning_Unit_Group__c plug = [SELECT Id,Planning_Unit__c,Access_Level__c,Group_ID__c
    										FROM Planning_Unit_Group__c
    										WHERE Group_ID__c = :groupID];
    	
    	//create a share for the planning unit for this user
    	OperatingUnit__Share share = new OperatingUnit__Share();
		share.ParentId = plug.Planning_Unit__c;
		share.UserOrGroupId = selectedUser;
		share.AccessLevel = 'read';
		share.RowCause = Schema.OperatingUnit__Share.RowCause.A_A_Plan_Group_Access__c;
		
		shares.add(share);
		/*
		//share the child Planning Units as well
		List<OperatingUnit__c> children = [SELECT Id,Parent__c FROM OperatingUnit__c WHERE Id = :plug.Planning_Unit__c];
		//childrens children
		List<Id> grandChildIds = new List<Id>();
		
		for( OperatingUnit__c child : children ){
			OperatingUnit__Share childShare = new OperatingUnit__Share();
			childShare.ParentId = child.Id;
			childShare.UserOrGroupId = selectedUser;
			childShare.AccessLevel = 'read';
			childShare.RowCause = Schema.OperatingUnit__Share.RowCause.A_A_Plan_Group_Access__c;
			
			if(!String.isBlank(child.Parent__c)){
				grandChildIds.add(child.Parent__c);
			}
			
			shares.add(childShare);
		}
		
		//share the children's child Planning Units as well
		List<OperatingUnit__c> grandChildren = [SELECT Id FROM OperatingUnit__c WHERE Id = :grandChildIds];
		
		for( OperatingUnit__c grandChild : grandChildren ){
			OperatingUnit__Share childShare = new OperatingUnit__Share();
			childShare.ParentId = grandChild.Id;
			childShare.UserOrGroupId = selectedUser;
			childShare.AccessLevel = 'read';
			childShare.RowCause = Schema.OperatingUnit__Share.RowCause.A_A_Plan_Group_Access__c;

			shares.add(childShare);
		}
		
		insert(shares);
    }
    */

	// Method to remove User from Public group
    public void removeUser() {
        if( String.isNotBlank( groupID ) && String.isNotBlank( userToRemove ) ) {
			List<GroupMember> gm = [SELECT ID 
                                        FROM GroupMember 
                                        WHERE GroupID = :groupID 
                                        AND UserOrGroupID = :userToRemove ];
            if( !gm.isEmpty() ){
                delete gm;
                userRemoved = true;
                refreshData();
                searchForUsers();
                ActiveTab = 'userAdmin';
            }
        }
    }

    /*
    @future
    public static void revokeSharePlanningUnitWithUser( String groupID, String userToRemove){
    	//get the Planning Unit Group junction object
    	//so we can get the ID of the Planning Unit to revoke sharing
    	Planning_Unit_Group__c plug = [SELECT Id,Planning_Unit__c,Access_Level__c,Group_ID__c
    										FROM Planning_Unit_Group__c
    										WHERE Group_ID__c = :groupID];
    	
    	List<OperatingUnit__Share> revokeShare = [SELECT Id
    											FROM OperatingUnit__Share
    											WHERE ParentID = :plug.Planning_Unit__c 
    												AND UserOrGroupId = :userToRemove
    												AND RowCause = :Schema.OperatingUnit__Share.RowCause.A_A_Plan_Group_Access__c];
    											
    	delete revokeShare;
    }
    */

	// Method to remove Public Group from an enclosing Public Group
    public void removeGroup() {
        if( String.isNotBlank( groupID ) && String.isNotBlank( groupToRemove ) ) {
			List<GroupMember> gm = [SELECT ID 
                                        FROM GroupMember 
                                        WHERE GroupID = :groupID 
                                        AND UserOrGroupID = :groupToRemove ];
            if( !gm.isEmpty() ){
                delete gm;
                groupRemoved = true;
                refreshData();
                searchForGroups();
                ActiveTab = 'groupAdmin';
            }
        }
    }

	// Method to add Public Group to an enclosing Public Group
    public void addGroup(){
        if( String.isNotBlank( groupID ) && String.isNotBlank( selectedGroup ) ) {
            insert( new GroupMember( GroupID = groupID, UserOrGroupId = selectedGroup ) );
            addedGroupName = [SELECT ID, Name FROM Group WHERE Type = 'Regular' AND ID = :selectedGroup].Name;
            refreshData();
            searchForGroups();
            ActiveTab = 'groupAdmin';
        }
    }

	// Method to return select options to the page containing users
    public List<SelectOption> getPublicGroupUsers() {
        List<SelectOption> opts = new List<SelectOption>();
        if( existingUsers != null && !existingUsers.isEmpty() ){
            for( User u : existingUsers ) {
                opts.add( new SelectOption( u.id, u.Name + ' - ' + u.email ) );
            }
        }
        return opts;
    }

	// Method to return select options to the page containing Public Groups
    public List<SelectOption> getPublicGroupGroups() {
        List<SelectOption> opts = new List<SelectOption>();
        if( existingGroups != null && !existingGroups.isEmpty() ){
            for( Group g : existingGroups ) {
                opts.add( new SelectOption( g.id, g.Name ) );
            }
        }
        return opts;
    }

    /* Private Methods */
    // Method to refresh private data
    private void refreshData(){
        existingUsers = [SELECT ID,
                        		Name,
                        		Email
                            	FROM USER
                            	WHERE IsActive = TRUE
                             	AND ID IN
                             (SELECT UserOrGroupID FROM GroupMember WHERE GroupID = :groupID)
                             	Order By Name ASC];
        existingGroups = [SELECT ID,
                            		Name
                            	FROM Group
                            	WHERE ID IN
                             (SELECT UserOrGroupID FROM GroupMember WHERE GroupID = :groupID)
                             Order By Name ASC];
        refreshMatchingUsers( '%' + userSearch + '%' );
        refreshMatchingGroups( '%' + groupSearch + '%' );
    }

	// method to refresh foundUsers data
    private void refreshMatchingUsers( String querySearchUser ) {
        foundUsers = [SELECT ID, Name, Email FROM User WHERE IsActive = true AND ID NOT IN (SELECT UserOrGroupID FROM GroupMember WHERE GroupID =:groupID) AND Name LIKE :querySearchUser Order by Name ASC LIMIT 16 ];
    }

	// method to refresh foundGroups data
    private void refreshMatchingGroups( String querySearchGroup ) {
        foundGroups = [SELECT ID, Name FROM Group WHERE Type = 'Regular' AND ID NOT IN :new Map<ID, Group>(existingGroups).keySet() AND Name LIKE :querySearchGroup Order by Name ASC LIMIT 16 ];
    }
}