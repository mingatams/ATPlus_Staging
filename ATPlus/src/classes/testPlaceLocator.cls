@IsTest(SeeAllData=true)
public with sharing class testPlaceLocator {

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
        OrgUnit__c ou = new OrgUnit__c(ouCode__c='OUCODE', Name='OUCODE | Nicaragua', ouDisplayName__c='Nicaragua2',burId__c=bu.Id, ouType__c='Regional Office');
        insert ou;
        Project__c project = new Project__c(Fiscal_Year__c = '2010', Project_Manager__c = 'Test', MissionName__c = 'Kenya', ouId__c=ou.Id);
        insert project;
        
        Implementing_Mechanism__c im = new Implementing_Mechanism__c(ouId__c=ou.id,Implementing_Mechanism_Name__c='IM Name');
        ApplicationConstants.bypassIMSharingRulesTriggerLogic = true;
        ApplicationConstants.bypassIMCreateVendorTriggerLogic = true;
        insert im;
        Activity__c act = new Activity__c(Activity_Name__c = 'Test', Project_Code__c = project.Id, ImpMech_Id__c=im.Id);
        insert act;      
        geoRegion__c gr = new geoRegion__c(regCode__c='AFPAK2', Name='AFPAK | AFGHANISTAN & PAKISTAN');
        insert gr;
        geoCountry__c gc = new geoCountry__c(cntryCode__c='AF2', Name='AF | Afghanistan', cntrydispName__c='Afghanistan1', bgaCode__c='306', regId__c=gr.Id);
        insert gc;
        geoCountry__c gc2 = new geoCountry__c(cntryCode__c='AF3', Name='AF | Afghanistan3', cntrydispName__c='Afghanistan2', bgaCode__c='305', regId__c=gr.Id);
        insert gc2;
        GeoBoundary__c gb = new GeoBoundary__c(cntryId__c=gc.Id, Name='AF | Afghanistan | Badakhshan', adminBndryLatitude__c='36.75', adminBndryLongitude__c='72', adminBndryName__c='Badakhshan1');
        insert gb;
        orgUnitGeography__c org1 = new orgUnitGeography__c(cntryID__c=gc.id, orgUnitId__c=ou.id);
        insert org1;
        orgUnitGeography__c org2 = new orgUnitGeography__c(cntryID__c=gc2.id, orgUnitId__c=ou.Id);
        insert org2;
        Project_Location__c loc = new Project_Location__c(Name='test', ActivityId__c = act.Id, cntryId__c=gc.Id,admin1BndryId__c=gb.id);
        insert loc;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(loc);
        
        System.Test.setCurrentPage(Page.PlaceLocator);
        
        System.Test.StartTest();
        
        PlaceLocatorController controller = new PlaceLocatorController(stdController);
        
        String address = controller.getAddressOrName();
        
        Decimal north = controller.North;
        Decimal south = controller.South;
        Decimal east = controller.East;
        Decimal west = controller.West;
        controller.Country = 'Afghanistan1';
        controller.State = 'Badakhshan1';

        controller.doLocation();
        
        System.Test.StopTest();
    }
    public static testMethod void testController2() {
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
  
        Group grp = new Group(Name = 'OUCODE User',Type = 'Queue');
                
        System.runAs(thisUSer){
        insert grp; 
        
        }
        
        Group grp1 = [select id from group where name = 'OUCODE User' and Type = 'Queue' limit 1];
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
        OrgUnit__c ou = new OrgUnit__c(ouCode__c='OUCODE', Name='OUCODE | Nicaragua', ouDisplayName__c='Nicaragua2',burId__c=bu.Id, ouType__c='Field Mission', ouName__c='Nicaragua');
        insert ou;
        Project__c project = new Project__c(Fiscal_Year__c = '2010', Project_Manager__c = 'Test', MissionName__c = 'Kenya', ouId__c=ou.Id);
        insert project;
        
        Implementing_Mechanism__c im = new Implementing_Mechanism__c(ouId__c=ou.id,Implementing_Mechanism_Name__c='IM Name');
        ApplicationConstants.bypassIMSharingRulesTriggerLogic = true;
        ApplicationConstants.bypassIMCreateVendorTriggerLogic = true;
         insert im;
         
        Activity__c act = new Activity__c(Activity_Name__c = 'Test', Project_Code__c = project.Id, ImpMech_Id__c=im.Id);
        insert act;      
        geoRegion__c gr = new geoRegion__c(regCode__c='AFPAK2', Name='AFPAK | AFGHANISTAN & PAKISTAN');
        insert gr;
        geoCountry__c gc = new geoCountry__c(cntryCode__c='AF2', Name='AF | Afghanistan', cntrydispName__c='Afghanistan1', bgaCode__c='306', regId__c=gr.Id);
        insert gc;
        geoCountry__c gc2 = new geoCountry__c(cntryCode__c='AF3', Name='AF | Afghanistan3', cntrydispName__c='Afghanistan2', bgaCode__c='305', regId__c=gr.Id);
        insert gc2;
        GeoBoundary__c gb = new GeoBoundary__c(cntryId__c=gc.Id, Name='AF | Afghanistan | Badakhshan', adminBndryLatitude__c='36.75', adminBndryLongitude__c='72', adminBndryName__c='Badakhshan1');
        insert gb;
        orgUnitGeography__c org1 = new orgUnitGeography__c(cntryID__c=gc.id, orgUnitId__c=ou.id);
        insert org1;
        Project_Location__c loc = new Project_Location__c(Name='test', ActivityId__c = act.Id, cntryId__c=gc.Id,admin1BndryId__c=gb.id);
        insert loc;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(loc);
        
        System.Test.setCurrentPage(Page.PlaceLocator);
        
        System.Test.StartTest();
        
        PlaceLocatorController controller = new PlaceLocatorController(stdController);
        
        String address = controller.getAddressOrName();
        
        Decimal north = controller.North;
        Decimal south = controller.South;
        Decimal east = controller.East;
        Decimal west = controller.West;
        controller.Country = 'Afghanistan1';
        controller.State = 'Badakhshan1';

        controller.doLocation();
        
        System.Test.StopTest();
    }
}