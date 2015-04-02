/**
* testAAAnouncments is the test class for AA_AnnouncementAdminController 
*
* CHANGE HISTORY
* ===================================================================================
* Date            Name            Description
* Nov 20 2014     Brian Mason     Created
* ===================================================================================
*/
@isTest
public with sharing class testAAAnouncments {
public static testMethod void validateAddPos() {        
        Test.startTest();
        
        AA_AnnouncementAdminController controller = new AA_AnnouncementAdminController();
        A_A_Announcement__c ann;

               controller.announcement.Announcement__c = 'what';
        controller.announcement.Announcement_Title__c = 'test';
        controller.announcement.Start_Date__c = datetime.newInstance(2014, 9, 15, 13, 30, 0);
        controller.add();
            
        ann= [
            SELECT Announcement__c 
            FROM A_A_Announcement__c LIMIT 1 
        ];
        
        System.assertEquals(ann.Announcement__c, 'what');
        Test.stopTest();
    }
    
    public static testMethod void validateAddNeg() {
        
        Test.startTest();
        Boolean thrown = false;
        AA_AnnouncementAdminController controller = new AA_AnnouncementAdminController();
        A_A_Announcement__c ann;

               controller.announcement.Announcement__c = 'what';
        controller.announcement.Announcement_Title__c = 'test';
        controller.add();
         
        try{
            ann= [
                SELECT Announcement__c
                FROM A_A_Announcement__c LIMIT 1 
            ];
        }catch(System.QueryException e){thrown = true;}
        System.assert(thrown);
        Test.stopTest();
    }   
    
    public static testMethod void validateDeletePos() {        
        Test.startTest();
        
        AA_AnnouncementAdminController controller = new AA_AnnouncementAdminController();
        List<A_A_Announcement__c> anns = new List<A_A_Announcement__c>();
        
               controller.announcement.Announcement__c = 'what';
        controller.announcement.Announcement_Title__c = 'test';
        controller.announcement.Start_Date__c = datetime.newInstance(2014, 9, 15, 13, 30, 0);
        controller.announcement.End_Date__c = datetime.newInstance(2014, 9, 15, 13, 30, 0);
        controller.add();
        anns = [
            SELECT Announcement__c,Id
            FROM A_A_Announcement__c LIMIT 1 
        ];        
        System.assert(controller.announcementInfo.size() == 1);
        
        controller.SelectedAnnouncementId = anns[0].Id;
        controller.deleteAnnouncement();
        controller.loadData();

        
        System.assert(controller.announcementInfo.size() == 0);
        Test.stopTest();
    }
    
    public static testMethod void validateDeleteNeg() {        
        Test.startTest();
        
        AA_AnnouncementAdminController controller = new AA_AnnouncementAdminController();
        List<A_A_Announcement__c> anns = new List<A_A_Announcement__c>();
        
               controller.announcement.Announcement__c = 'what';
        controller.announcement.Announcement_Title__c = 'test';
        controller.announcement.Start_Date__c = datetime.newInstance(2014, 9, 15, 13, 30, 0);
        controller.announcement.End_Date__c = datetime.newInstance(2014, 9, 15, 13, 30, 0);
        controller.add();
        anns = [
            SELECT Announcement__c,Id
            FROM A_A_Announcement__c LIMIT 1 
        ];        
        System.assert(controller.announcementInfo.size() == 1);
        
        controller.SelectedAnnouncementId = null;
        controller.deleteAnnouncement();
        controller.loadData();

        
        System.assert(controller.announcementInfo.size() == 1);
        Test.stopTest();
    }
    
    public static testMethod void validateMessagePos() {
        
        Test.startTest();
        AA_AnnouncementAdminController controller = new AA_AnnouncementAdminController();
        A_A_Announcement__c ann;

               controller.announcement.Announcement__c = 'what';
        controller.announcement.Announcement_Title__c = 'test';
        controller.add();
         
        List<Apexpages.Message> msgs = ApexPages.getMessages();
                              boolean b = false;
                              for(Apexpages.Message msg:msgs){
                              if (msg.getDetail().contains('You must enter a value for Title, Announcement, and Start Date.')) b = true;
                              }
                              system.assert(b);
        Test.stopTest();
    }
    
    public static testMethod void validateMessageNeg() {
        
        Test.startTest();
        AA_AnnouncementAdminController controller = new AA_AnnouncementAdminController();
        A_A_Announcement__c ann;

               controller.announcement.Announcement__c = 'what';
        controller.announcement.Announcement_Title__c = 'test';
       controller.announcement.Start_Date__c = datetime.newInstance(2014, 9, 15, 13, 30, 0);
        controller.add();
         
        List<Apexpages.Message> msgs = ApexPages.getMessages();
               
                              system.assert(msgs.size()==0);
        Test.stopTest();
    }
    
    public static testMethod void validateReset() {        
        Test.startTest();
        
        AA_AnnouncementAdminController controller = new AA_AnnouncementAdminController();
        List<A_A_Announcement__c> anns = new List<A_A_Announcement__c>();
        
               controller.announcement.Announcement__c = 'what';
        controller.announcement.Announcement_Title__c = 'test';
        controller.announcement.Start_Date__c = datetime.newInstance(2014, 9, 15, 13, 30, 0);
        controller.announcement.End_Date__c = datetime.newInstance(2014, 9, 15, 13, 30, 0);
             
        System.assert(controller.announcement.Announcement__c == 'what');
        System.assert(controller.announcement.Announcement_Title__c == 'test');
        controller.reset();        
        System.assert(controller.announcement.Announcement__c == null);
               System.assert(controller.announcement.Announcement_Title__c == null);
        Test.stopTest();
   }    
    
    public static testMethod void validateSaveOneElOneRow() {        
        Test.startTest();
        boolean thrown = false;
        AA_AnnouncementAdminController controller = new AA_AnnouncementAdminController();
        A_A_Announcement__c ann;
        List<A_A_Announcement__c> anns = new List<A_A_Announcement__c>();        
        
        anns = [
            SELECT Announcement__c
            FROM A_A_Announcement__c LIMIT 1 
        ];
        System.assert(anns.size() == 0);
        
               controller.announcement.Announcement__c = 'what';
        controller.announcement.Announcement_Title__c = 'test';
        controller.announcement.Start_Date__c = datetime.newInstance(2014, 9, 15, 13, 30, 0);
        controller.announcement.End_Date__c = datetime.newInstance(2014, 9, 15, 13, 30, 0);  
        controller.add();

        controller.announcementInfo[0].Announcement__c = 'what2';                
        controller.save();
        controller.LoadData();
        anns = [
            SELECT Announcement__c
            FROM A_A_Announcement__c LIMIT 1 
        ];        
        System.assertEquals(anns[0].Announcement__c,'what2'); 
        Test.stopTest();
    }
    
    public static testMethod void validateSaveOneElMulRowDif() {        
        Test.startTest();
        boolean thrown = false;
        AA_AnnouncementAdminController controller = new AA_AnnouncementAdminController();
        A_A_Announcement__c ann;
        List<A_A_Announcement__c> anns = new List<A_A_Announcement__c>();
        
        
        anns = [
            SELECT Announcement__c
            FROM A_A_Announcement__c LIMIT 2 
        ];
        System.assert(anns.size() == 0);
        
               controller.announcement.Announcement__c = 'what1';
        controller.announcement.Announcement_Title__c = 'test1';
        controller.announcement.Start_Date__c = datetime.newInstance(2014, 9, 15, 13, 30, 0);
        controller.add();

        controller.announcement.Announcement__c = 'what2';
        controller.announcement.Announcement_Title__c = 'test2';
        controller.announcement.Start_Date__c = datetime.newInstance(2014, 9, 15, 13, 30, 0);
        controller.add();
            
        controller.announcementInfo[0].Announcement__c = 'what1.2';  
        controller.announcementInfo[1].Announcement_Title__c = 'test2.2'; 
        controller.save();
        controller.LoadData();
        anns = [
            SELECT Announcement__c, Announcement_Title__c
            FROM A_A_Announcement__c LIMIT 2 
        ];      
        System.assertEquals(anns[0].Announcement__c,'what1.2'); 
        System.assertEquals(anns[1].Announcement_Title__c,'test2.2'); 
        Test.stopTest();
    }
    
    public static testMethod void validateSaveOneElMulRowSame() {        
        Test.startTest();
        boolean thrown = false;
        AA_AnnouncementAdminController controller = new AA_AnnouncementAdminController();
        A_A_Announcement__c ann;
        List<A_A_Announcement__c> anns = new List<A_A_Announcement__c>();       
        
        anns = [
            SELECT Announcement__c
            FROM A_A_Announcement__c LIMIT 2 
        ];
        System.assert(anns.size() == 0);
        
               controller.announcement.Announcement__c = 'what1';
        controller.announcement.Announcement_Title__c = 'test1';
        controller.announcement.Start_Date__c = datetime.newInstance(2014, 9, 15, 13, 30, 0);
        controller.add();

        controller.announcement.Announcement__c = 'what2';
        controller.announcement.Announcement_Title__c = 'test2';
        controller.announcement.Start_Date__c = datetime.newInstance(2014, 9, 15, 13, 30, 0);
        controller.add();
            
        controller.announcementInfo[0].Announcement__c = 'what1.2';  
        controller.announcementInfo[1].Announcement__c = 'what2.2'; 
        controller.save();
        controller.LoadData();
        anns = [
            SELECT Announcement__c, Announcement_Title__c
           FROM A_A_Announcement__c LIMIT 2 
        ];      
        System.assertEquals(anns[0].Announcement__c,'what1.2'); 
        System.assertEquals(anns[1].Announcement__c,'what2.2'); 
        Test.stopTest();
    }
    
    public static testMethod void validateSaveMulElMulRowDif() {        
        Test.startTest();
        boolean thrown = false;
        AA_AnnouncementAdminController controller = new AA_AnnouncementAdminController();
        A_A_Announcement__c ann;
        List<A_A_Announcement__c> anns = new List<A_A_Announcement__c>();        
        
        anns = [
            SELECT Announcement__c, Announcement_Title__c
            FROM A_A_Announcement__c LIMIT 2 
        ];
        System.assert(anns.size() == 0);
        
               controller.announcement.Announcement__c = 'what1';
        controller.announcement.Announcement_Title__c = 'test1';
        controller.announcement.Start_Date__c = datetime.newInstance(2014, 9, 15, 13, 30, 0);
        controller.add();

        controller.announcement.Announcement__c = 'what2';
        controller.announcement.Announcement_Title__c = 'test2';
        controller.announcement.Start_Date__c = datetime.newInstance(2014, 9, 15, 13, 30, 0);
        controller.add();
            
        controller.announcementInfo[0].Announcement__c = 'what1.2';  
        controller.announcementInfo[0].Announcement_Title__c = 'test1.2'; 
        controller.announcementInfo[1].Announcement__c = 'what2.2';  
        controller.announcementInfo[1].Announcement_Title__c = 'test2.2';
        controller.save();
        controller.LoadData();
        anns = [
            SELECT Announcement__c, Announcement_Title__c
            FROM A_A_Announcement__c LIMIT 2 
        ];      
        System.assertEquals(anns[0].Announcement__c,'what1.2'); 
        System.assertEquals(anns[0].Announcement_Title__c,'test1.2'); 
        System.assertEquals(anns[1].Announcement__c,'what2.2'); 
        System.assertEquals(anns[1].Announcement_Title__c,'test2.2'); 
        Test.stopTest();
    }
}