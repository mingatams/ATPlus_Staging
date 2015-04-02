/**
* A controller for Announcements.vfp to handle data manipulation
* for announcement records.
*
* CHANGE HISTORY
* =============================================================================
* Date                                 Name                                  Description
* 11/04/2014    Chad Hammond Created
* 11/18/2014    Chad Hammond Added Reset() method
* =============================================================================
* 
*/
public class AA_AnnouncementAdminController {
    public List<A_A_Announcement__c> announcementInfo { get; set; }
    public A_A_Announcement__c announcement { get; set; } 
    public string SelectedAnnouncementId { get; set; }
    
    public AA_AnnouncementAdminController() {
        loadData();
    }
    
    public void loadData(){
        // get date for all A_A_Announcement__c objects
        announcementInfo = [
                SELECT Announcement__c, Announcement_Title__c, End_Date__c, Start_Date__c,Id 
                FROM A_A_Announcement__c 
            ];
        
        // A_A_Announcement__c object to store new announcements
        announcement = new A_A_Announcement__c();
    }
    
    public void add() {        
        // display error message
        if(announcement.Announcement__c ==  '' || announcement.Announcement__c ==  null || announcement.Announcement_Title__c == null || announcement.Start_Date__c == null)
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'You must enter a value for Title, Announcement, and Start Date.'));
        else {
            // save new announcement, reload data for display
            upsert announcement;        
            loadData();
        }
    }
    
    public void reset() {        
        // clear data from announcement
        announcement = null;        
        loadData();
    }
       
    // delete an announcement
    public void deleteAnnouncement() {
        if (SelectedAnnouncementId == null)       
               return;                  
      
        // find record to be deleted
        A_A_Announcement__c ann = new A_A_Announcement__c(Id = SelectedAnnouncementId);
       
               Delete ann;
                       
        // load updated data for display
               loadData();
    }
    
    // save announcement data
    public PageReference save() {
        // load updated data for display        
        upsert announcementInfo;
        return null;
    }
}