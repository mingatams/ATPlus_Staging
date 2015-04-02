@IsTest(SeeAllData=true)
private class testMapDataController { 
    
    static Project__c proj = null;
    static Location1__c loc = null;
    static Activity__c act = null;
    
    static {
        /*
        proj = new Project__c();
        proj.Project_Name__c = 'Test Project';
        proj.Sector_Name__c = 'Climate Change';
        proj.MissionName__c = 'Ethiopia';
        proj.Project_Manager__c = 'Test Person';
        insert proj;
        
        act = new Activity__c();
        act.Project_code__c = proj.Id;
        act.Activity_Name__c = 'Test Activity';
        insert act;
        
        loc = new Location1__c();
        loc.Activity__c = act.Id;
        loc.Project_Code__c = proj.Id;
        loc.Activity_Location_Country__c = 'Ethiopia'; // Fake country
        loc.Activity_Location_Province__c = 'Elbonia'; // Fake province
        */
    }
    
    public static testMethod void testMaintainPCRInsert() {
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
        
        QueueSobject q1 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Project__c' );     
        qList.add(q1);
        
        QueueSobject q2 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Activity__c');    
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
        
        Sector__c sc = new Sector__c(secCode__c = 'SCODE',Name = 'SCODE | SNAME');
        insert sc;
        
        orgUnitSector__c ous = new orgUnitSector__c(ouId__c = orgUnit.Id,secId__c=sc.id);
        insert ous;
        
        proj = new Project__c();
        proj.Project_Name__c = 'Test Project';
        proj.Sector_Name__c = 'SNAME';
        proj.MissionName__c = 'Ethiopia';
        proj.Project_Manager__c = 'Test Person';
        proj.ouId__c = orgUnit.Id;
        insert proj;
        
        
        Implementing_Mechanism__c im = new Implementing_Mechanism__c(ouId__c=orgUnit.id,Implementing_Mechanism_Name__c='IM Name');
         insert im;
        
        act = new Activity__c();
        act.Project_code__c = proj.Id;
        act.Activity_Name__c = 'Test Activity';
        act.ImpMech_Id__c = im.id;
        insert act;
        
        loc = new Location1__c();
        loc.Activity__c = act.Id;
        loc.Project_Code__c = proj.Id;
        loc.Activity_Location_Country__c = 'Ethiopia'; // Fake country
        loc.Activity_Location_Province__c = 'Elbonia'; // Fake province
        
        System.AssertEquals(0, [SELECT COUNT() FROM Project_Region__c WHERE Region__c = 'Elbonia']);
        
        Test.StartTest();
        
        insert loc;
        
        Test.StopTest();
        
        System.AssertEquals(1, [SELECT COUNT() FROM Project_Region__c WHERE Region__c = 'Elbonia']);
    }
      
    
    public static testMethod void testMaintainPCRDelete() {
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
        
        QueueSobject q1 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Project__c' );     
        qList.add(q1);
        
        QueueSobject q2 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Activity__c');    
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
        
        Sector__c sc = new Sector__c(secCode__c = 'SCODE',Name = 'SCODE | SNAME');
        insert sc;
        
        orgUnitSector__c ous = new orgUnitSector__c(ouId__c = orgUnit.Id,secId__c=sc.id);
        insert ous;
        
        proj = new Project__c();
        proj.Project_Name__c = 'Test Project';
        proj.Sector_Name__c = 'SNAME';
        proj.MissionName__c = 'Ethiopia';
        proj.Project_Manager__c = 'Test Person';
        proj.ouId__c = orgUnit.Id;
        insert proj;
        
        Implementing_Mechanism__c im = new Implementing_Mechanism__c(ouId__c=orgUnit.id,Implementing_Mechanism_Name__c='IM Name');
         insert im;
        
        act = new Activity__c();
        act.Project_code__c = proj.Id;
        act.Activity_Name__c = 'Test Activity';
        act.ImpMech_Id__c = im.id;
        insert act;
        
        loc = new Location1__c();
        loc.Activity__c = act.Id;
        loc.Project_Code__c = proj.Id;
        loc.Activity_Location_Country__c = 'Ethiopia'; // Fake country
        loc.Activity_Location_Province__c = 'Elbonia'; // Fake province
        
        System.AssertEquals(0, [SELECT COUNT() FROM Project_Region__c WHERE Region__c = 'Elbonia']);
        insert loc;
        System.AssertEquals(1, [SELECT COUNT() FROM Project_Region__c WHERE Region__c = 'Elbonia']);
        
        Test.StartTest();
        
        delete loc;
        
        Test.StopTest();
        
        System.AssertEquals(0, [SELECT COUNT() FROM Project_Region__c WHERE Region__c = 'Elbonia']);
    }
      
    
    public static testMethod void testMaintainPCRUpdate() {
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
        
        QueueSobject q1 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Project__c' );     
        qList.add(q1);
        
        QueueSobject q2 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Activity__c');    
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
        
        Sector__c sc = new Sector__c(secCode__c = 'SCODE',Name = 'SCODE | SNAME');
        insert sc;
        
        orgUnitSector__c ous = new orgUnitSector__c(ouId__c = orgUnit.Id,secId__c=sc.id);
        insert ous;
        
        proj = new Project__c();
        proj.Project_Name__c = 'Test Project';
        proj.Sector_Name__c = 'SNAME';
        proj.MissionName__c = 'Ethiopia';
        proj.Project_Manager__c = 'Test Person';
        proj.ouId__c = orgUnit.Id;
        insert proj;
        
        Implementing_Mechanism__c im = new Implementing_Mechanism__c(ouId__c=orgUnit.id,Implementing_Mechanism_Name__c='IM Name');
         insert im;
         
        act = new Activity__c();
        act.Project_code__c = proj.Id;
        act.Activity_Name__c = 'Test Activity';
        act.ImpMech_Id__c = im.id;
        insert act;
        
        loc = new Location1__c();
        loc.Activity__c = act.Id;
        loc.Project_Code__c = proj.Id;
        loc.Activity_Location_Country__c = 'Ethiopia'; // Fake country
        loc.Activity_Location_Province__c = 'Elbonia'; // Fake province
        
        System.AssertEquals(0, [SELECT COUNT() FROM Project_Region__c WHERE Region__c = 'Elbonia']);
        insert loc;
        System.AssertEquals(1, [SELECT COUNT() FROM Project_Region__c WHERE Region__c = 'Elbonia']);
        
        Test.StartTest();
        
        loc.Activity_Location_Province__c = 'Ratbertia';
        update loc;
        
        Test.StopTest();
        
        System.AssertEquals(0, [SELECT COUNT() FROM Project_Region__c WHERE Region__c = 'Elbonia']);
        System.AssertEquals(1, [SELECT COUNT() FROM Project_Region__c WHERE Region__c = 'Ratbertia']);
    }
        
    public static testMethod void testMapDataController() {
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
        
        QueueSobject q1 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Project__c' );     
        qList.add(q1);
        
        QueueSobject q2 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Activity__c');    
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
        
        Sector__c sc = new Sector__c(secCode__c = 'SCODE',Name = 'SCODE | SNAME');
        insert sc;
        
        orgUnitSector__c ous = new orgUnitSector__c(ouId__c = orgUnit.Id,secId__c=sc.id);
        insert ous;
        
        proj = new Project__c();
        proj.Project_Name__c = 'Test Project';
        proj.Sector_Name__c = 'SNAME';
        proj.MissionName__c = 'Ethiopia';
        proj.Project_Manager__c = 'Test Person';
        proj.ouId__c = orgUnit.Id;
        insert proj;
        
        Implementing_Mechanism__c im = new Implementing_Mechanism__c(ouId__c=orgUnit.id,Implementing_Mechanism_Name__c='IM Name');
         insert im;
        
        act = new Activity__c();
        act.Project_code__c = proj.Id;
        act.Activity_Name__c = 'Test Activity';
        act.ImpMech_Id__c = im.id;        
        insert act;
        
        loc = new Location1__c();
        loc.Activity__c = act.Id;
        loc.Project_Code__c = proj.Id;
        loc.Activity_Location_Country__c = 'Ethiopia'; // Fake country
        loc.Activity_Location_Province__c = 'Elbonia'; // Fake province
        insert loc;
        
        Test.startTest();

        MapDataController c = new MapDataController();
        System.assertNotEquals(null, c.OverviewJSON);
        System.assertNotEquals(null, c.ProjectsJSON);
        System.assertNotEquals(null, c.ProjectDetailsJSON);
        //System.assertNotEquals(null, c.LocationList);
        System.assertNotEquals(null, c.getProjectSummaries());
        System.assertNotEquals(null,c.requestProjectDetails);
        System.assertNotEquals(null,c.requestProjects);
        System.assertNotEquals(null,c.requestSnapshot);
        System.assertNotEquals(null, c.requestProjectsOverview);
        
        Map<String, String> x = ApexPages.currentPage().getParameters();
        x.put('r', 'overview');
        x.put('s', 'Education');
        c = new MapDataController();
        System.assertNotEquals(null, c.OverviewJSON);
        System.assertNotEquals(null, c.ProjectsJSON);

        x.put('r', 'overview');
        x.put('c', 'Ghana');
        c = new MapDataController();
        System.assertNotEquals(null, c.OverviewJSON);
        System.assertNotEquals(null, c.ProjectsJSON);
        
        x.put('r', 'overview');
        x.put('i', 'Global Health Initiative');
        c = new MapDataController();
        System.assertNotEquals(null, c.OverviewJSON);
        System.assertNotEquals(null, c.ProjectsJSON);

        x.put('r', 'overview');
        x.put('f', '34343434343');
        x.put('t', '343434343434');   
        c = new MapDataController();
        System.assertNotEquals(null, c.OverviewJSON);
        System.assertNotEquals(null, c.ProjectsJSON);
    
        x.put('r', 'overview');
        x.put('l', 'local');
        x.put('w', 'India');   
        c = new MapDataController();
        System.assertNotEquals(null, c.OverviewJSON);
        System.assertNotEquals(null, c.ProjectsJSON);
        
        x.put('r', 'overview');
        x.put('l', 'local');
        x.put('w', 'India');   
        c = new MapDataController();
        System.assertNotEquals(null, c.OverviewJSON);
        System.assertNotEquals(null, c.ProjectsJSON);

        
        x.put('r', 'overview');
        x.put('l', 'regional');
        x.put('w', 'ASIA');   
        c = new MapDataController();
        System.assertNotEquals(null, c.OverviewJSON);
        System.assertNotEquals(null, c.ProjectsJSON);
        
        c = new MapDataController();
        System.assertNotEquals(null, c.OverviewJSON);
        System.assertNotEquals(null, c.ProjectsJSON);
        System.assertNotEquals(null, c.ProjectDetailsJSON);
        //System.assertNotEquals(null, c.LocationList);
        System.assertNotEquals(null, c.getProjectSummaries());
        System.assertNotEquals(null,c.requestProjectDetails);
        System.assertNotEquals(null,c.requestProjects);
        System.assertNotEquals(null,c.requestSnapshot);
        System.assertNotEquals(null, c.requestProjectsOverview);                            
        Test.stopTest();
    }
}