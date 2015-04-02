/**
* AAAnnouncementsController is used in the A&A Announcement VF Component
*
* CHANGE HISTORY
* ===================================================================================
* Date            Name            Description
* Sep 16 2014     Brian Mason     Created
* Oct 07 2014     Brian Mason     Added Comments
* Nov 26 2014     Brian Mason     Added flag to allow render of Administration link
* ===================================================================================
*/
public class AAAnnouncementsController {

    public List<A_A_Announcement__c> Announcements { get; private set;}
    public Boolean administerFlag { public get; private set; }
    public AAAnnouncementsController(){
        Announcements = [SELECT Announcement_Title__c,
                                Announcement__c,
                                Start_Date__c,
                                End_Date__c
                             FROM A_A_Announcement__c
                             WHERE Start_Date__c < :Datetime.now()
                             AND (End_Date__c > :Datetime.now()
                                  OR
                                  End_Date__c = NULL)
                             ORDER BY Start_Date__c DESC];
        setAdministerFlag();
    }
    
    // Method to check if user has access to the page by profile or permission set.
    private void setAdministerFlag() {
        // First check to see if user has access because the profile has
        // access to the page.
        try{
            List<SetupEntityAccess> sea = [SELECT Id, 
                                                Parent.Name, 
                                                Parent.Profile.Name, 
                                                Parent.Profile.Id
                                            FROM SetupEntityAccess 
                                            WHERE Parent.Profile.Id = :UserInfo.getProfileId() 
                                            AND SetupEntityId IN (SELECT Id 
                                                                    FROM ApexPage 
                                                                    WHERE Name = 'AA_AnnouncementAdmin')];
            if( !sea.isEmpty() ){
                administerFlag = TRUE;
            }else{
                administerFlag = FALSE;
            }
        }catch( Exception e ){
            administerFlag = FALSE;
        }
        if( administerFlag != TRUE){
            // Next, check if the user has a permission set which has access to the page
            try{
                // Get all the permission sets asssigned to the user
                List<PermissionSetAssignment> psa = [SELECT ID, 
                                                            permissionsetID
                                                            FROM PermissionSetAssignment
                                                            WHERE AssigneeID = :UserInfo.getUserID()];
                // drop all permission set id into a set for use in the query.
                // 'Parent.ID' relationship cannot be traveresd in query.
                Set<ID> psaIDs = new Set<ID>();
                for( PermissionSetAssignment p : psa ){
                    psaIDs.add( p.PermissionSetID );
                }
                // query to check if assigned permission set has access to the admin page
                List<SetupEntityAccess> sea =[SELECT ID,
                                                    Parent.Name
                                                FROM SetupEntityAccess
                                                WHERE Parent.id IN :psaIDs
                                                AND SetupEntityId IN (SELECT Id 
                                                                        FROM ApexPage 
                                                                        WHERE Name = 'AA_AnnouncementAdmin')];
                if( !sea.isEmpty() ){
                    administerFlag = TRUE;
                }else{
                    administerFlag = FALSE;
                }
            }catch( Exception e ){
                administerFlag = FALSE;
            }
        }
    }
}