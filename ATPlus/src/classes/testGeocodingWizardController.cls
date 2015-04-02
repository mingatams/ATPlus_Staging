@IsTest(SeeAllData=true)
public with sharing class testGeocodingWizardController {
  
 /* static Project__c project = null;
  static Activity__c act = null;
  static Location1__c loc = null;
  
  static {
    project = new Project__c(Fiscal_Year__c = '2010', Project_Manager__c = 'Test', Publicly_disclosable__c = true, MissionName__c = 'Kenya');
    insert project;
    
    act = new Activity__c(Activity_Name__c = 'Test', Project_Code__c = project.Id, Publicly_disclosable__c = true);
    insert act;
    
    loc = new Location1__c(Name = 'Test Location Name', Activity__c = act.Id, Project_Code__c = project.Id, Publicly_disclosable__c = true);
    insert loc;
    
  }

    public static testMethod void testConstructorParameters_noParams() {
        ApexPages.StandardController stdController = new ApexPages.StandardController(loc);
    
        PageReference page1 = new PageReference('/apex/GeoWizardStep1');     
        Test.setCurrentPage(page1);
      
        Test.StartTest();
      
        GeocodingWizardController controller = new GeocodingWizardController(stdController);
        controller.showPopup();
        controller.closePopup();
        
        //System.assert(ApexPages.getMessages().size() == 3); 
        System.assert(ApexPages.getMessages().get(0).getDetail() == 'Parameter Does Not Exist'); 
        System.assert(ApexPages.getMessages().get(0).getSeverity() == ApexPages.Severity.ERROR);   
      
        Test.StopTest();
    }
  
    public static testMethod void testConstructorParameters_paramExists() {
        ApexPages.StandardController stdController = new ApexPages.StandardController(loc);
    
        PageReference page1 = new PageReference('/apex/GeoWizardStep1?AcitivityID=' + act.Id + '&ProjectCode=' + project.Id + '&retURL=/' + act.Id);      
        Test.setCurrentPage(page1);
      
        Test.StartTest();
      
        GeocodingWizardController controller = new GeocodingWizardController(stdController);
        controller.showPopup();
        controller.closePopup();
        
        //System.assert(ApexPages.getMessages().size() == 1); 
        System.assert(ApexPages.getMessages().get(0).getDetail() == 'Parameter Exists'); 
        System.assert(ApexPages.getMessages().get(0).getSeverity() == ApexPages.Severity.CONFIRM);  
      
        Test.StopTest();
    }

    public static testMethod void testController() {
        ApexPages.StandardController stdController = new ApexPages.StandardController(loc);
    
        String url = '/apex/GeoWizardStep1?AcitivityID=' + act.Id + '&ProjectCode=' + project.Id + '&retURL=/' + act.Id;
        PageReference page1 = new PageReference(url);      
        Test.setCurrentPage(page1);
      
        Test.StartTest();
      
        GeocodingWizardController controller = new GeocodingWizardController(stdController);
        controller.showPopup();
        controller.closePopup();
        
        Project_Location__c location = controller.getLocation();
       // location.Project_Code__c = project.Id; 
        location.Activity_Id__c = act.Id; 
        
        PageReference nextPage = controller.step2();
              
        String page2 = nextPage.getUrl();
        System.assertEquals('/apex/geowizardstep2', page2);      
      
        String address = controller.getAddressOrName();
      
        controller.doLocation();
        
        page2 = controller.saveAndNew().getUrl();
        
        page2 = controller.cancel().getUrl();
        System.assertEquals('/' + act.Id, page2);         
      
        Test.StopTest();
    } 
  
    public static testMethod void testController2() {
        ApexPages.StandardController stdController = new ApexPages.StandardController(loc);
    
        String url = '/apex/GeoWizardStep1?AcitivityID=' + act.Id + '&ProjectCode=' + project.Id + '&retURL=/' + act.Id;
        PageReference page1 = new PageReference(url);      
        Test.setCurrentPage(page1);
      
        Test.StartTest();
      
        GeocodingWizardController controller = new GeocodingWizardController(stdController);
        controller.showPopup();
        controller.closePopup();
        
        Project_Location__c location = controller.getLocation();
        //location.Project_Code__c = project.Id; 
        location.Activity_Id__c = act.Id; 
              
        String page2 = controller.step2().getUrl();
        System.assertEquals('/apex/geowizardstep2', page2);  
        
        String pg1 = controller.step1().getUrl();
        System.assertEquals('/apex/geowizardstep1', pg1);  
        
        String pg2 = controller.step2().getUrl();
        System.assertEquals('/apex/geowizardstep2', pg2);  
      
        String address = controller.getAddressOrName();
      
        controller.doLocation();
        
        page2 = controller.save().getUrl();
        System.assertEquals('/' + location.Id, page2);           
      
        Test.StopTest();
    }    */

    public static testMethod void testController() {
        
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
  
        Group grp = new Group(Name = 'OUCODE User',Type = 'Queue');
                
        System.runAs(thisUSer){
        insert grp; 
        
        }
        
        Group grp1 = [select id from group where name = 'OUCODE User' and Type = 'Queue'];
        List<QueueSObject> qList = new List<QueueSObject>();
        QueueSobject q = new QueueSobject(QueueId = grp1.Id, SobjectType = 'OrgUnit__c');
        qList.add(q); 
        QueueSobject q1 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'CDCSGoal__c');     
        qList.add(q1);      
        QueueSobject q2 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Project__c');      
        qList.add(q2);
        QueueSobject q3 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Activity__c');     
        qList.add(q3); 
        
        QueueSobject q4 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'CDCSLINK__c');
        qList.add(q4);
        
        QueueSobject q5 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Implementing_Mechanism__c');
         qList.add(q5);
        
        System.runAs(thisUSer){
        insert qList; }
        
        Profile p = [SELECT Id FROM profile WHERE name='Standard User'];
        User u = new User(alias = 'nu123', email='newuser123@testorg.com', emailencodingkey='UTF-8', lastname='Testing',
            languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id, timezonesidkey='America/Los_Angeles',
            username='newuser123@testorg.com');
        insert u;
        Bureau__c bu = new Bureau__c(burCode__c='Test123', Name='Test234', OwnerId=u.Id);
        insert bu;
        OrgUnit__c ou = new OrgUnit__c(ouCode__c='OUCODE', Name='OUCODE | Nicaragua', ouDisplayName__c='Nicaragua2',burId__c=bu.Id, ouType__c='Regional Office', ouName__c='NICARAGUA11');
        insert ou;
        Project__c project = new Project__c(Fiscal_Year__c = '2010', Project_Manager__c = 'Test', MissionName__c = 'Kenya', ouId__c=ou.Id);
        insert project;
        Implementing_Mechanism__c im = new Implementing_Mechanism__c(ouId__c=ou.id,Implementing_Mechanism_Name__c='IM Name');
         insert im;
        
        Activity__c act = new Activity__c(Activity_Name__c = 'Test', Project_Code__c = project.Id, ImpMech_Id__c=im.Id);
        insert act;      
        geoRegion__c gr = new geoRegion__c(regCode__c='AFPAK2', Name='AFPAK | AFGHANISTAN & PAKISTAN');
        insert gr;
        geoCountry__c gc = new geoCountry__c(cntryCode__c='AF2', Name='AF | Afghanistan', cntrydispName__c='Afghanistan1', bgaCode__c='306', regId__c=gr.Id);
        insert gc;
        geoCountry__c gc2 = new geoCountry__c(cntryCode__c='AF3', Name='AF | Afghanista3', cntrydispName__c='Afghanistan3', bgaCode__c='303', regId__c=gr.Id);
        insert gc2;
        GeoBoundary__c gb = new GeoBoundary__c(cntryId__c=gc.Id, Name='AF | Afghanistan | Badakhshan', adminBndryLatitude__c='36.75', adminBndryLongitude__c='72', adminBndryName__c='Badakhshan1');
        insert gb;
        orgUnitGeography__c geo1 = new orgUnitGeography__c(cntryID__c=gc.Id, orgUnitId__c=ou.Id);
        insert geo1;
        orgUnitGeography__c geo2 = new orgUnitGeography__c(cntryID__c=gc2.Id, orgUnitId__c=ou.Id);
        insert geo2;
        Project_Location__c loc = new Project_Location__c(Name='test', ActivityId__c = act.Id, cntryId__c=gc.Id,admin1BndryId__c=gb.id,Latitude__c=1.1,Longitude__c=1.1);
        insert loc;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(loc);
        
        PageReference page1 = new PageReference('/apex/GeoWizardStep1?AcitivityID=' + act.Id + '&retURL=/' + act.Id);      
        Test.setCurrentPage(page1);
        
        Test.StartTest();
        
        GeocodingWizardController controller = new GeocodingWizardController(stdController);
        controller.checkboxSelected = true;
        controller.closePopup();

        controller.step1();
        
        controller.activityId = act.id;
        Project_Location__c location = new Project_Location__c();
        location = controller.getLocation();
        location.ActivityId__c = act.Id;
        location.Name = 'test';
        String address = controller.getAddressOrName();
        List<SelectOption> cs = controller.getCountryList();
        Decimal north = controller.North;
        Decimal south = controller.South;
        Decimal east = controller.East;
        Decimal west = controller.West;

        controller.Country = 'Afghanistan1';
        controller.State = 'Badakhshan1';       
        controller.doLocation();
        controller.save();
        controller.saveAndNew();
        controller.cancel();
        
        Project_Location__c location2 = new Project_Location__c();
        location2 = controller.getLocation();
        location2.ActivityId__c = act.Id;
        location2.Name = 'Badakhshan';
        controller.Country = 'Afghanistan';
        controller.doLocation();
        controller.save();
        controller.saveAndNew();

        Project_Location__c location3 = new Project_Location__c();
        location3 = controller.getLocation();
        location3.ActivityId__c = act.Id;
        location3.Name = 'test3';
        location3.admin1BndryId__c = gb.id;
        location3.cntryId__c = gc.id;
        loc.admin1BndryId__c = gb.id;
        loc.cntryId__c = gc.id;
        loc.Name = 'test3';
        
        controller.step2();
        controller.doLocation();
        controller.save();
        
        Test.StopTest();
    }
    public static testMethod void testController2() {
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
  
        Group grp = new Group(Name = 'OUCODE User',Type = 'Queue');
                
        System.runAs(thisUSer){
        insert grp; 
        
        }
        
        Group grp1 = [select id from group where name = 'OUCODE User' and Type = 'Queue'];
        List<QueueSObject> qList = new List<QueueSObject>();
        QueueSobject q = new QueueSobject(QueueId = grp1.Id, SobjectType = 'OrgUnit__c');
        qList.add(q); 
        QueueSobject q1 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'CDCSGoal__c');     
        qList.add(q1);      
        QueueSobject q2 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Project__c');      
        qList.add(q2);
        QueueSobject q3 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Activity__c');     
        qList.add(q3); 
        
        QueueSobject q4 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'CDCSLINK__c');
        qList.add(q4);
        
        QueueSobject q5 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Implementing_Mechanism__c');
         qList.add(q5);
        
        System.runAs(thisUSer){
        insert qList; }
        
        Profile p = [SELECT Id FROM profile WHERE name='Standard User'];
        User u = new User(alias = 'nu123', email='newuser123@testorg.com', emailencodingkey='UTF-8', lastname='Testing',
            languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id, timezonesidkey='America/Los_Angeles',
            username='newuser123@testorg.com');
        insert u;
        Bureau__c bu = new Bureau__c(burCode__c='Test123', Name='Test234', OwnerId=u.Id);
        insert bu;
        OrgUnit__c ou = new OrgUnit__c(ouCode__c='OUCODE', Name='OUCODE | Nicaragua', ouDisplayName__c='Nicaragua2',burId__c=bu.Id, ouType__c='Field Mission', ouName__c='Nicaragua1');
        insert ou;
        Project__c project = new Project__c(Fiscal_Year__c = '2010', Project_Manager__c = 'Test', MissionName__c = 'Kenya', ouId__c=ou.Id);
        insert project;
        Implementing_Mechanism__c im = new Implementing_Mechanism__c(ouId__c=ou.id,Implementing_Mechanism_Name__c='IM Name');
         insert im;        
        Activity__c act = new Activity__c(Activity_Name__c = 'Test', Project_Code__c = project.Id, Publicly_Disclosable__c = true, ImpMech_Id__c=im.Id);
        insert act;      
        geoRegion__c gr = new geoRegion__c(regCode__c='AFPAK2', Name='AFPAK | AFGHANISTAN & PAKISTAN');
        insert gr;
        geoCountry__c gc = new geoCountry__c(cntryCode__c='AF2', Name='AF | Afghanistan', cntrydispName__c='Afghanistan1', bgaCode__c='306', regId__c=gr.Id);
        insert gc;
        GeoBoundary__c gb = new GeoBoundary__c(cntryId__c=gc.Id, Name='AF | Afghanistan | Badakhshan', adminBndryLatitude__c='36.75', adminBndryLongitude__c='72', adminBndryName__c='Badakhshan1');
        insert gb;
        orgUnitGeography__c geo = new orgUnitGeography__c(cntryID__c=gc.Id, orgUnitId__c=ou.Id);
        insert geo;
        Project_Location__c loc = new Project_Location__c(Name='test',ActivityId__c=act.Id,cntryId__c=gc.Id,admin1BndryId__c=gb.id,Latitude__c=1.1,Longitude__c=1.1);
        insert loc;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(loc);
        
        PageReference page1 = new PageReference('/apex/GeoWizardStep1?AcitivityID=' + act.Id + '&retURL=/' + act.Id);      
        Test.setCurrentPage(page1);      
        
        Test.StartTest();
        
        GeocodingWizardController controller = new GeocodingWizardController(stdController);
        

        Decimal north = controller.North;
        Decimal south = controller.South;
        Decimal east = controller.East;
        Decimal west = controller.West;

        controller.Country = 'Afghanistan1';
        controller.State = 'Badakhshan1';       
        
        controller.activityId = act.id;

        Project_Location__c location3 = new Project_Location__c();
        location3 = controller.getLocation();
        location3.ActivityId__c = act.Id;
        location3.Name = 'test4';
        location3.admin1BndryId__c = gb.id;
        location3.cntryId__c = gc.id;
        
        Location1__c loc1 = new Location1__c();
        loc1.Activity__c = act.Id;
        loc1.Name = loc.Name;
        loc1.Activity_Location_Country__c = 'Afghanistan';
        loc1.Activity_Location_Province__c = loc.admin1BndryName__c;
        loc1.Activity_Location_Latitude__c = loc.Latitude__c;
        loc1.Activity_Location_Longitude__c = loc.Longitude__c;
        insert loc1;
        //System.debug('Location Data::' +loc1);
        //System.debug('GeoCoding Wizard Test 1:' +loc);
        loc.admin1BndryId__c = gb.id;
        loc.cntryId__c = gc.id;
        loc.Name = 'test3';
        loc.Latitude__c = 1.1;
        loc.Longitude__c = 1.1;
        //loc.ActivityId__c = act.Id;
        //System.debug('GeoCoding Wizard Test 2:' +loc);
        upsert loc;
        
        controller.doLocation();
        controller.saveAndNew();
        
        Test.StopTest();
    }
}