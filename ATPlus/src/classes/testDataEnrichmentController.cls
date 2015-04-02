@IsTest(SeeAllData=true)
public with sharing class testDataEnrichmentController {
    
    public static testMethod void testController() {
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
  
        Group grp = new Group(Name = 'OUCODE User',Type = 'Queue' );
        
        System.runAs(thisUSer){
        insert grp; }
        
        Group grp1 = [select id from group where name = 'OUCODE User' and Type = 'Queue'];
        List<QueueSObject> qList = new List<QueueSObject>();
        QueueSobject q = new QueueSobject(QueueId = grp1.Id, SobjectType = 'OrgUnit__c');       
        qList.add(q);
        
        QueueSobject q1 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Project__c');      
        qList.add(q1);
        
        QueueSobject q2 = new QueueSobject(QueueId = grp1.Id,SobjectType = 'Activity__c');      
        qList.add(q2);
        
        QueueSobject q3 = new QueueSobject(QueueId = grp1.Id,SobjectType = 'CDCSGoal__c');      
        qList.add(q3);
        
        QueueSobject q4 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'CDCSLINK__c');
        qList.add(q4);
        
        QueueSobject q5 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Implementing_Mechanism__c');
         qList.add(q5);
        
        System.runAs(thisUSer){
        insert qList; }
        
        Bureau__c bureau = new Bureau__c(burCode__c = 'BUR', Name = 'BUR | BURName');
        insert bureau;
        
        OrgUnit__c orgUnit = new OrgUnit__c(burId__c = bureau.Id, ouCode__c= 'OUCODE', Name = 'ORG | ORGNAme', ouDisplayName__c= 'ORGD');
        insert orgUnit;
        
        Sector__c sc = new Sector__c(secCode__c = 'SCODE', Name = 'SCODE | SNAME' ); 
        insert sc;
        
        orgUnitSector__c ous = new orgUnitSector__c(ouId__c = orgUnit.Id, secId__c = sc.Id);
        insert ous;
        
        Project__c testProject = new Project__c(ouId__c = orgUnit.Id, Fiscal_Year__c = '2010', Project_Manager__c = 'Test', SBU__c = true, MissionName__c = 'Kenya');
        insert testProject;
        
        Implementing_Mechanism__c im = new Implementing_Mechanism__c(ouId__c=orgUnit.id,Implementing_Mechanism_Name__c='IM Name');
         insert im;
        
        Activity__c testActivity = new Activity__c (Activity_Name__c = 'Test', Project_code__c = testProject.Id, Publicly_disclosable__c = true, ImpMech_Id__c=im.Id);
        insert testActivity;
        Location1__c testLocation = new Location1__c (Activity__c = testActivity.Id, Activity_Location_Province__c = 'Test Province', Activity_Location_Country__c = 'Test Country');
        insert testLocation;
        
        List<Location1__c> locations = new List<Location1__c>();
        
        Test.setCurrentPage(Page.DataEnrichment);
        
        Test.StartTest();
        
        DataEnrichmentController controller = new DataEnrichmentController();
        
        List<Location1__c> location = DataEnrichmentController.getLocation();
        
        DataEnrichmentController.updateLocations(locations);
        controller.resetEnriched();
        
        Test.StopTest();
    }
}