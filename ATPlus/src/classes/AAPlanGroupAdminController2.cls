public with sharing class AAPlanGroupAdminController2 {

    public transient String newGroupLabel{ get; set; }
    public transient String newPublicGroupDevName{ get; set;}
    public String ActiveTab{ get; set; }
    public String existingGroupName{ get; set; }
    public String searchGroup{ get; set; }
    public List<Group> matchingGroups{ get; set;}
    public Id deleteRecordId{ get; set; }
    
    public String searchUser{ get; set; }
    public List<User> matchingUsers{ get; set;}
    public ID selectedUserId{ get; set; }
    
    public PageReference addGroup(){
        if( String.isNotBlank( newGroupLabel ) &&
          	String.isNotBlank( newPublicGroupDevName ) ) {
                ActiveTab = 'PubGroupAdmin';
                try{
                    insert new Group( DeveloperName = newPublicGroupDevName,
                                                Name = newGroupLabel,
                                                Type = 'Regular' );
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, '"' + newGroupLabel + '" added successfully.'));
                    newGroupLabel = '';
                    newPublicGroupDevName = '';
                }catch(Exception e){
                    //ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, e.getTypeName() + ' - ' + e.getMessage() ) );
                }
            }else{
                ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Warning, 'Group Name and Group API Name must be populated to create a group.' ) );
            }
        return null;
    }

    public PageReference groupSearch() {
        if( String.isNotBlank( searchGroup ) ) {
            ActiveTab = 'PubGroupAdmin';
            refreshMatchingGroups( '%' + searchGroup + '%' );
            if ( matchingGroups.size() > 15 ) {
                matchingGroups.remove( 15 );
                ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Warning, 'Search results were too large. Please enter more characters of the search string. Only Showing the first 15 results.' ) );
            }
        }else{
            if( matchingGroups != null && !matchingGroups.isEmpty() ) {
                matchingGroups.clear();
            }
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, 'Please populate the "Group Name" field in the "Remove Public Group" section before searching.' ) );
        }
        return null;
    }
    
    public PageReference deleteGroup() {
        //Delete the selected object
        for( Group g : matchingGroups ){
            if( g.id == deleteRecordId ){
                delete g;
                refreshMatchingGroups( '%' + searchGroup + '%' );
            }
    	}
        return null;
    }
    
    public PageReference userSearch() {
        if( String.isNotBlank( searchUser ) ) {
            ActiveTab = 'UserGroupAdmin';
            refreshMatchingUsers( '%' + searchUser + '%' );
            if ( matchingUsers.size() > 15 ) {
                matchingUsers.remove( 15 );
                ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Warning, 'Search results were too large. Please enter more characters of the search string. Only Showing the first 15 results.' ) );
            }
        }else{
            if( matchingUsers != null && !matchingUsers.isEmpty() ) {
                matchingUsers.clear();
            }
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, 'Please populate the "User Name" field before searching.' ) );
        }
        return null;
    }
    
    public List<SelectOption> getUsers() {
        List<SelectOption> opts = new List<SelectOption>();
        if( matchingUsers != null && !matchingUsers.isEmpty() ) {
            for( User u : matchingUsers ){
                opts.add( new SelectOption( u.Id, u.Name ) );
            }
        }else{
            opts.add( new SelectOption( '-----', 'No Users Selected' ) );
        }
        return opts;
    }
    
    private void refreshMatchingGroups( String querySearchGroup ) {
        matchingGroups = [SELECT ID, Name, DeveloperName FROM Group WHERE Type = 'Regular' AND Name LIKE :querySearchGroup LIMIT 16 ];
    }
    private void refreshMatchingUsers( String querySearchUser ) {
        matchingUsers = [SELECT ID, Name FROM User WHERE Name LIKE :querySearchUser LIMIT 16 ];
    }
}