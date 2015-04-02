@isTest
private class TestMethod_4 {
    
/*public static testMethod void testMassUploadLocationNationalProjectGeo() 
  {
    System.debug('Inside the test Method');
    Pagereference pRef = Page.MassUploadLocationNationalProjectGeo;
    Test.setCurrentPageReference(pRef);
        
try{    
    User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
  
    Group grp = new Group();
    grp.Name = 'OUCODE User';   
    grp.Type = 'Queue';
    System.runAs(thisUSer){
    insert grp; }
    
    Group grp1 = [select id from group where name = 'OUCODE User' and Type = 'Queue'];
    List<QueueSObject> qList = new List<QueueSObject>();
    QueueSobject q = new QueueSobject();
    q.QueueId = grp1.Id;
    q.SobjectType = 'OrgUnit__c';
    qList.add(q);
    
    QueueSobject q1 = new QueueSobject();
    q1.QueueId = grp1.Id;
    q1.SobjectType = 'Project__c';
    qList.add(q1);
    
    QueueSobject q2 = new QueueSobject();
    q2.QueueId = grp1.Id;
    q2.SobjectType = 'Activity__c';
    qList.add(q2);
    
    System.runAs(thisUSer){
    insert qList; }
    
    Bureau__c bu = new Bureau__c();
    
    bu.burCode__c = 'BUR';
    bu.burName__c = 'BUR Name';
    bu.Name = 'BUR Name';
    
    Insert bu;
    
    Sector__c sc = new Sector__c();
    
    sc.secCode__c = 'SCODE';
    sc.secName__c = 'SNAME';
    sc.Name = 'SNAME';
    
    Insert sc;
    System.debug('After the sectors::' +sc);    
    
        
    OrgUnit__c ou = new OrgUnit__c();
    
    ou.ouCode__c = 'OUCODE';
    ou.ouName__c = 'OUNAME';
    ou.Name = 'OUNAME';
    
    ou.ouDisplayName__c = 'OU DISPNAME';
    Bureau__c bu1 = new Bureau__c();
    bu1 = [select id from Bureau__c where Name = 'BUR | BUR Name'];
    ou.burId__c = bu1.id;
    System.debug('Before the Org Unit Insert::' +ou);
    Insert ou;
    
    System.debug('After the Org Unit Insert::' +ou);
    
    Project__c  Proj = new Project__c ();
    
    Proj.Project_Name__c = 'Test Project';    
    Proj.Start_Date__c = date.parse('10/20/2011');    
    Proj.End_Date__c = date.parse('12/20/2015');
    Proj.Sector_Name__c = 'Education';
    OrgUnit__c ou1 = new OrgUnit__c();
    ou1 = [select id from OrgUnit__c where Name = 'OUCODE | OUNAME'];
    Proj.ouId__c = ou1.id; 
    Sector__c sc1 = new Sector__c();
    sc1 = [select id from Sector__c where Name = 'SCODE | SNAME'];
   // Proj.secId__c = sc1.id; 
    System.debug('Before Project::' +proj);  
    Insert Proj;
    System.debug('After Project::' +proj);
    
    Activity__c act = new Activity__c() ;
    
    act.activity_name__c= 'Test Act';
    Project__c  Proj1 = new Project__c();
    Proj1 = [select id from Project__c where Project_Name__c = 'Test Project'];
    act.Project_code__c = Proj1.id;
        
    Insert act; 
    
    Activity__c act1 = [select id from Activity__c where activity_name__c= 'Test Act'];
    
    System.debug('After the Activity1 creation:::' +act1.Id);
    
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
    
    geoCountry__c gc1 = new geoCountry__c();
    gc1 = [select id from geoCountry__c where Name = 'II | IIName'];
        
    GeoBoundary__c gbound = new GeoBoundary__c();
    gbound.cntryId__c = gc1.Id;     
    gbound.adminBndryName__c = 'Admin Boundary';
    gbound.Name = 'Admin Boundary';
    gbound.adminBndryLatitude__c = '2.34567';
    gbound.adminBndryLongitude__c = '3.56789';
    
    insert gbound;
    
    orgUnitGeography__c ouGeo = new orgUnitGeography__c();
    ouGeo.cntryID__c = gc1.id;
    ouGeo.orgUnitId__c = ou1.id;
    
    insert ouGeo;

    Project_Location__c  loc = new Project_Location__c() ;
    
    
    GeoBoundary__c gb1 = [select id from GeoBoundary__c where Name = 'II | IIName | Admin Boundary'];
    
   
    ApexPages.currentPage().getParameters().put('Lid', act1.Id);
    System.debug('After the Activity ID Generation' +act1.Id);
    ApexPages.StandardController sc5 = new ApexPages.StandardController(loc);
    System.debug('After the Standrad Controller Generation' +sc5);
    MassUploadLocationNationalProjectGeo a = new MassUploadLocationNationalProjectGeo(sc5);     
   
    a.getProvinces();
    a.selectedProv = gb1.id;
    a.getSelected();
    a.GetSelectedProvinces();  
    a.prepareProjectLocations();
    a.insertLocations();
    a.Cancel(); 
    a.insertLocations();
        
   }
   catch(exception e)
   {
   }

  } */
  
 public static testmethod void testTrOfficeBeforeUpsert(){
    try{
        test.startTest();
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
        
        
        System.runAs(thisUSer){
        insert qList; }
        
        Bureau__c bu = new Bureau__c(burCode__c = 'BUR', burName__c = 'BUR Name', Name = 'BUR Name'); 
        Insert bu;
        
        
        OrgUnit__c ou = new OrgUnit__c(ouCode__c = 'OUCODE', ouName__c = 'OUNAME',Name = 'OUNAME', ouDisplayName__c = 'OU DISPNAME',burId__c = bu.id );    
        Insert ou;
        
        Office__c off = new Office__c(offCode__c = 'OFF1', Name = 'OFF1 | Off Name', ouId__c=ou.Id, offType__c = 'Technical Office');
        insert off;
       
       
        
    } catch(exception e){
        
    }
    
 } 
 
 public static testmethod void testTrOrgUnitGeographyBeforeUpsert(){
    try{
        test.startTest();
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
        
        
        System.runAs(thisUSer){
        insert qList; }
        
        Bureau__c bu = new Bureau__c(burCode__c = 'BUR', burName__c = 'BUR Name', Name = 'BUR Name'); 
        Insert bu;
        
        
        OrgUnit__c ou = new OrgUnit__c(ouCode__c = 'OUCODE', ouName__c = 'OUNAME',Name = 'OUNAME', ouDisplayName__c = 'OU DISPNAME',burId__c = bu.id );    
        Insert ou;
        
        geoRegion__c reg = new geoRegion__c(regCode__c = 'REG1', Name='REG1 | REG1Name');
        insert reg;
        
        geoCountry__c cntry = new geoCountry__c (regId__c = reg.Id, cntryCode__c = 'CN1', Name = 'CN1 | CN1Name', cntrydispName__c= 'CN1Disp');
        insert cntry;
        
        orgUnitGeography__c og = new orgUnitGeography__c (orgUnitId__c = ou.Id, cntryId__c = cntry.Id);
        insert og;  
       
       
        
    } catch(exception e){
        
    }
    
 } 
 
 
 public static testmethod void testTrProjectLocationAfterUpsert(){
    try{
        test.startTest();
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
        
        System.runAs(thisUSer){
        insert qList; }
        
        Bureau__c bureau = new Bureau__c(burCode__c = 'BUR', Name = 'BUR | BURName');
        insert bureau;
        
        OrgUnit__c orgUnit = new OrgUnit__c(burId__c = bureau.Id, ouCode__c= 'OUCODE', Name = 'ORG | ORGNAme', ouDisplayName__c= 'ORGD');
        insert orgUnit;
        
        Sector__c sc = new Sector__c(secCode__c = 'SCODE', Name = 'SCODE | SNAME' ); 
        Insert sc;
        
        orgUnitSector__c ous = new orgUnitSector__c(ouId__c = orgUnit.Id, secId__c = sc.Id);
        insert ous;
        
        Project__c project = new Project__c(ouId__c = orgUnit.Id, Fiscal_Year__c = '2010', Project_Manager__c = 'Test', Publicly_disclosable__c = true, MissionName__c = 'Kenya');
        insert project;
        
        Activity__c act = new Activity__c(Activity_Name__c = 'Test', Project_Code__c = project.Id, Publicly_disclosable__c = true);
        insert act;       
        
        
        geoRegion__c reg = new geoRegion__c(regCode__c = 'REG1', Name='REG1 | REG1Name');
        insert reg;
        
        geoCountry__c cntry = new geoCountry__c (regId__c = reg.Id, cntryCode__c = 'CN1', Name = 'CN1 | CN1Name', cntrydispName__c= 'CN1Disp');
        insert cntry;
        
        GeoBoundary__c gb = new GeoBoundary__c(cntryId__c = cntry.Id, adminbndryName__c = 'bndryNAme', Name = 'bndryNAme', adminUniqueName__c='bndryNameu', adminBndryLatitude__c = '1.1',adminBndryLongitude__c = '-1.1' );
        insert gb;
        
        Project_Location__c pl = new Project_Location__c(activityId__c = act.Id, cntryId__c = cntry.Id, admin1BndryId__c = gb.Id, method__c='Geo Coding');
        insert pl;
        
        pl.address__c = 'Address1';
        update pl;
        
        delete pl;  
        
       
               
       
        
    } catch(exception e){
        
    }
    
 } 
 
 
 public static testMethod void testAidTrackerMapPreviewController() 
  {
    System.debug('Inside the test Method');
    Pagereference pRef = Page.MapPreview;
    Test.setCurrentPageReference(pRef);
    
    try{    
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];  
        System.runAs(thisUSer){
            AidTrackerMapPreviewController amp = new AidTrackerMapPreviewController();
        }              
    } catch(exception e){
   
    }  
     Profile Ad = [SELECT Id FROM Profile WHERE Name= 'STD - Mission Profile']; 
   
     UserRole r=[SELECT Id FROM UserRole WHERE Name = 'KEN | Kenya'];
   // UserRole r=[SELECT Id FROM UserRole WHERE Name = 'Kenya User']; 
       User u5 = new User(Alias = 'standt5', Email='standarduser5@testorg.com', isActive=true,
       EmailEncodingKey='UTF-8', LastName='Testing5', LanguageLocaleKey='en_US', 
       LocaleSidKey='en_US', ProfileId = Ad.Id,  UserRoleId=r.id,
       TimeZoneSidKey='America/Los_Angeles', UserName='standarduser5@testorg.com' );
      // users.add(u5);
      insert u5;
          
    try{    
        //User thisUser1 = [select Id, UserRoleId from User where UserRoleId = '00Ed0000000QkoI' and isActive = true];        
        System.runAs(u5){
            AidTrackerMapPreviewController amp = new AidTrackerMapPreviewController();
        } 
    } catch(exception e){
   
    }
          
  }
  
  public static testmethod void testProjectdetailcontrollerNew() {
     System.debug('Inside the test Method'); 
     try{
        test.startTest();
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
  
        Group grp = new Group();
        grp.Name = 'OUCODE User';   
        grp.Type = 'Queue';
        System.runAs(thisUSer){
        insert grp; }
        
        Group grp1 = [select id from group where name = 'OUCODE User' and Type = 'Queue'];
        List<QueueSObject> qList = new List<QueueSObject>();
        QueueSobject q = new QueueSobject();
        q.QueueId = grp1.Id;
        q.SobjectType = 'OrgUnit__c';
        qList.add(q);
        
        QueueSobject q1 = new QueueSobject();
        q1.QueueId = grp1.Id;
        q1.SobjectType = 'Project__c';
        qList.add(q1);
        
        QueueSobject q2 = new QueueSobject();
        q2.QueueId = grp1.Id;
        q2.SobjectType = 'Activity__c';
        qList.add(q2);
        
        QueueSobject q3 = new QueueSobject();
        q3.QueueId = grp1.Id;
        q3.SobjectType = 'CDCSGoal__c';
        qList.add(q3);
        
        System.runAs(thisUSer){
        insert qList; }
        
        Bureau__c bu = new Bureau__c();
        
        bu.burCode__c = 'BUR';
        bu.burName__c = 'BUR Name';
        bu.Name = 'BUR Name';
        
        Insert bu;
        
        Sector__c sc = new Sector__c();
        
        sc.secCode__c = 'SCODE';
        sc.secName__c = 'SNAME';       
        sc.Name = 'SCODE | SNAME';
        
        Insert sc;
        //System.debug('After the sectors::' +sc);    
        
            
        OrgUnit__c ou = new OrgUnit__c();
        
        ou.ouCode__c = 'OUCODE';
        ou.ouName__c = 'OUNAME';
        ou.Name = 'OUNAME';
        
        ou.ouDisplayName__c = 'OU DISPNAME';
        Bureau__c bu1 = new Bureau__c();
        bu1 = [select id from Bureau__c where Name = 'BUR | BUR Name'];
        ou.burId__c = bu1.id;
        //System.debug('Before the Org Unit Insert::' +ou);
        Insert ou;
        
        //System.debug('After the Org Unit Insert::' +ou);
        
        Project__c  Proj = new Project__c ();
        
        Proj.Project_Name__c = 'Test Project';    
        Proj.Start_Date__c = date.parse('10/20/2011');    
        Proj.End_Date__c = date.parse('12/20/2015');
        Proj.Sector_Name__c = 'SNAME';
        OrgUnit__c ou1 = new OrgUnit__c();
        ou1 = [select id from OrgUnit__c where Name = 'OUCODE | OUNAME'];
        Proj.ouId__c = ou1.id; 
        Sector__c sc1 = new Sector__c();
        sc1 = [select id from Sector__c where Name = 'SCODE | SNAME'];
        
        Proj.missionname__c = 'Bangladesh';
        Proj.Sector_Name__c = 'SNAME';
        Proj.Primary_Initiative__c = 'abc';
        Proj.Project_Subtype__c = 'test';
        Proj.Start_Date__c = system.today();
        Proj.End_Date__c = system.today()+395;
        Proj.Project_Description__c = 'my description';
        Proj.Public_Photo__c = 'amp,test';
        
       // Proj.secId__c = sc1.id; 
        //System.debug('Before Project::' +proj);  
        orgUnitSector__c ous = new orgUnitSector__c(ouId__c = ou1.id,secId__c=sc1.id);
        insert ous;
        
        Insert Proj;
        
        
        System.debug('Inside the test Method 2');
        mission__c m= new  mission__c () ;
        m.Country_Code__c= 'BD';
        insert m;       
        
        Account acc = new account ();
        acc.name ='test';
        insert acc;
       
        Implementing_Mechanism__c im= new Implementing_Mechanism__c ();
        im.Award_Amount__c  = 10000 ;
        im.Partner_Id__c = acc.Id;
        im.Implementing_Mechanism_Name__c  = 'sfd';
        insert im ;
        
        Public_IM_Link__c pim = new Public_IM_Link__c () ;
        pim.Implementing_Mechanism_Number__c = im.Id;
        pim.Project_Code__c = Proj.id;

        insert pim ;
        
        //ApexPages.currentPage().getParameters().put('pid', p.Id);
        ApexPages.currentPage().getParameters().put('id', Proj.Id);
        ProjectDetailControllerNew a = new ProjectDetailControllerNew();
        
        
        Proj.Project_Description__c = null;
        Proj.Results__c = null;
        Proj.MissionName__c= 'Afghanistan';
        update Proj;
        //system.debug('************************ Now in 2: '+p);
        ApexPages.currentPage().getParameters().put('id', Proj.Id);        
        ProjectDetailControllerNew aa = new ProjectDetailControllerNew();
        System.debug('Inside the test Method 3');
        test.stopTest();
        /* p.
        update p;
        ApexPages.currentPage().getParameters().put('id', p.Id);        
        a = new ProjectDetailControllerNew ();
        */
           
    }catch(exception e){
    }
  }  
  
  public static testmethod void testTrUpsertProjectQowner1() {
    try{
        test.startTest();
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
  
        Group grp = new Group();
        grp.Name = 'OUCODE User';   
        grp.Type = 'Queue';
        System.runAs(thisUSer){
        insert grp; }
        
        Group grp1 = [select id from group where name = 'OUCODE User' and Type = 'Queue'];
        List<QueueSObject> qList = new List<QueueSObject>();
        QueueSobject q = new QueueSobject();
        q.QueueId = grp1.Id;
        q.SobjectType = 'OrgUnit__c';
        qList.add(q);
        
        QueueSobject q1 = new QueueSobject();
        q1.QueueId = grp1.Id;
        q1.SobjectType = 'Project__c';
        qList.add(q1);
        
        QueueSobject q2 = new QueueSobject();
        q2.QueueId = grp1.Id;
        q2.SobjectType = 'Activity__c';
        qList.add(q2);
        
        System.runAs(thisUSer){
        insert qList; }
        
        Bureau__c bu = new Bureau__c();
        
        //bu.burCode__c = 'BUR';
        //bu.burName__c = 'BUR Name';
        bu.Name = 'BUR | BUR Name';
        
        Insert bu;
        
        Sector__c sc = new Sector__c();
        
        sc.secCode__c = 'SCODE';
        sc.secName__c = 'SNAME';
        sc.Name = 'SCODE | SNAME';
        
        Insert sc;
        //System.debug('After the sectors::' +sc);    
        
            
        OrgUnit__c ou = new OrgUnit__c();
        
        ou.ouCode__c = 'OUCODE';
        ou.ouName__c = 'OUNAME';
        ou.Name = 'OUNAME';
        
        ou.ouDisplayName__c = 'OU DISPNAME';
        Bureau__c bu1 = new Bureau__c();
        bu1 = [select id from Bureau__c where Name = 'BUR | BUR Name'];
        ou.burId__c = bu1.id;
        //System.debug('Before the Org Unit Insert::' +ou);
        Insert ou;
        
         
        
        //System.debug('After the Org Unit Insert::' +ou);
        
        Project__c  Proj = new Project__c ();
        
        Proj.Project_Name__c = 'Test Project';    
        Proj.Start_Date__c = date.parse('10/20/2011');    
        Proj.End_Date__c = date.parse('12/20/2015');
        Proj.Sector_Name__c = 'Education';
        OrgUnit__c ou1 = new OrgUnit__c();
        ou1 = [select id from OrgUnit__c where Name = 'OUCODE | OUNAME'];
        Proj.ouId__c = ou1.id; 
        Sector__c sc1 = new Sector__c();
        sc1 = [select id from Sector__c where Name = 'SCODE | SNAME'];
        
        Proj.missionname__c = 'Bangladesh';
        Proj.Sector_Name__c = 'Health';
        Proj.Primary_Initiative__c = 'abc';
        Proj.Project_Subtype__c = 'test';
        Proj.Start_Date__c = system.today();
        Proj.End_Date__c = system.today()+395;
        Proj.Project_Description__c = 'my description';
        Proj.Public_Photo__c = 'amp,test';
        
       // Proj.secId__c = sc1.id; 
        //System.debug('Before Project::' +proj);
        orgUnitSector__c ous = new orgUnitSector__c();
        ous.ouId__c = ou1.id;
        ous.secId__c = sc1.Id;
        insert ous;  
        Insert Proj;
        
        Implementing_Mechanism__c im = new Implementing_Mechanism__c();
        im.ouId__c = ou1.id;
        im.Implementing_Mechanism_Name__c = 'IM Name';
        
        insert im;
        
        }catch(exception e){
    }
  }
  
}