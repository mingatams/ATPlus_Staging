@IsTest(SeeAllData=true)
public with sharing class testProjectDetailController {
   /* static Project__c project = null;
    static Activity__c act = null;
    static Location1__c loc = null;
    
    static {
        project = new Project__c(Fiscal_Year__c = '2010', Project_Manager__c = 'Test', Publicly_disclosable__c = true, MissionName__c = 'Kenya');
        insert project;
        
        act = new Activity__c(Activity_Name__c = 'Test', Project_Code__c = project.Id, Publicly_disclosable__c = true);
        insert act;
        
        loc = new Location1__c(Activity__c = act.Id, Project_Code__c = project.Id, Publicly_disclosable__c = true);
        insert loc;
        
    } */
    
    
    public static testMethod void testProjectDetail() {
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
  
        Group grp = new Group();
        grp.Name = 'OUCODE User';   
        grp.Type = 'Queue';
        System.runAs(thisUSer){
        insert grp; }
        
        Group grp1 = [select id from group where name = 'OUCODE User' and Type = 'Queue'];
        List<QueueSObject> qList = new List<QueueSObject>();
        QueueSobject q = new QueueSobject(QueueId = grp1.Id, SobjectType = 'OrgUnit__c');       
        qList.add(q);
        
        QueueSobject q1 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Project__c');
        qList.add(q1);
        
        QueueSobject q2 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Activity__c');
        qList.add(q2);
        
        QueueSobject q3 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'CDCSGoal__c');
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
        
        geoRegion__c grg = new geoRegion__c();
    
    grg.regCode__c = 'LLC';
    grg.regName__c = 'LLC Name';
    grg.Name = 'LLC Name';
       
    Insert grg;
    
    geoCountry__c gco = new geoCountry__c();
    
    geoRegion__c grg1 = new geoRegion__c ();
    grg1 = [select id from geoRegion__c where Name = 'LLC | LLC Name'];
    gco.regId__c = grg1.id;
    gco.cntryCode__c = 'II';
    gco.cntryName__c = 'IIName';
    gco.cntrydispName__c = 'IIName';
    gco.Name = 'IIName';
   // gco.cntrydispName__c = 'IIName Disp';
        
    Insert gco;
        
        orgUnitGeography__c ouGeo = new orgUnitGeography__c();
    ouGeo.cntryID__c = gco.id;
    ouGeo.orgUnitId__c = orgUnit.id;
    
    insert ouGeo;
        
        
        Sector__c sc = new Sector__c(secCode__c = 'SCODE', Name = 'SCODE | SNAME' ); 
        Insert sc;
        
        orgUnitSector__c ous = new orgUnitSector__c(ouId__c = orgUnit.Id, secId__c = sc.Id);
        insert ous;
        
        Project__c project = new Project__c(ouId__c = orgUnit.Id, 
                                            Fiscal_Year__c = '2010', 
                                            Project_Manager__c = 'Test',
                                            Public_Name__c = 'Women',
                                            Public_Photo__c='https://cs10.salesforce.com',
                                            Project_Description__c='Some Desc',
                                            Results__c='Some Results', 
                                            start_Date__c = date.newinstance(2010, 2, 17),
                                            end_date__c = date.newinstance(2014, 6, 10),                                            
                                            Primary_Initiative__c = 'Initiative',
                                            Project_Subtype__c = 'Sub Type',
                                            Publicly_disclosable__c = true, 
                                            MissionName__c = 'Kenya');
        insert project;
        
        Implementing_Mechanism__c im = new Implementing_Mechanism__c();
        im.ouId__c = orgUnit.id;
        im.Implementing_Mechanism_Name__c = 'IM Name';
        insert im;
        
        Activity__c act = new Activity__c(Activity_Name__c = 'Test', Project_Code__c = project.Id, Publicly_disclosable__c = true, ImpMech_Id__c=im.Id);
        insert act;
        
        Location1__c loc = new Location1__c(Activity__c = act.Id, Project_Code__c = project.Id, Publicly_disclosable__c = true);
        insert loc;
        
        PageReference p = Page.ProjectDetail;
        p.getParameters().put('Id', project.Id);
        
        PageReference p1 = Page.PublicProjectDetail;
        p1.getParameters().put('Id', project.Id);
        
        System.Test.setCurrentPage(p);

        System.Test.StartTest();
        
        ProjectDetailController controller = new ProjectDetailController();
        
        ProjectDetailControllerNew controller1 = new ProjectDetailControllerNew();
        
        System.Test.StopTest();
        
        System.Test.setCurrentPage(p1);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(project);
        PublicProjectDetailExtension controller2 = new PublicProjectDetailExtension(sc1);
        string pURL = controller2.photoUrl;
        string projectDescription = controller2.projectDescription;
        string fname = controller2.flagName;
        Double amt = controller2.awardAmount;
        //System.AssertNotEquals(null, controller.imLink);
        //System.AssertNotEquals(null, controller.locations);
        //System.AssertEquals(1, controller.locations.size());
        System.AssertNotEquals(null, controller.project);
        System.AssertNotEquals(null, controller1.project);
    }

}