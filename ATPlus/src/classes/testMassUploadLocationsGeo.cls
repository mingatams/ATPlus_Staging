@isTest
private class testMassUploadLocationsGeo {
    
public static testMethod void testMassUploadLocationNationalProjectGeo() 
  {
    System.debug('Inside the test Method');
    Pagereference pRef = Page.MassUploadLocationNationalProjectGeo;
    Test.setCurrentPageReference(pRef);
        
try{    
    User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
    clsGlobalUtility gu = new clsGlobalUtility();
    
    Group grp = new Group();
    grp.Name = 'OUC User';   
    grp.Type = 'Queue';
    System.runAs(thisUSer){
    insert grp; }
    
    Group grp1 = [select id from group where name = 'OUC User' and Type = 'Queue'];
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
    
    QueueSobject q4 = new QueueSobject();
    q4.QueueId = grp1.Id;
    q4.SobjectType = 'CDCSLINK__c';
    qList.add(q4);
    
    QueueSobject q5 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Implementing_Mechanism__c');
    qList.add(q5);
    
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
    System.debug('After the sectors::' +sc);    
    
        
    OrgUnit__c ou = new OrgUnit__c();
    
    ou.ouCode__c = 'OUC';
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
    Proj.Sector_Name__c = 'SNAME';
    OrgUnit__c ou1 = new OrgUnit__c();
    ou1 = [select id from OrgUnit__c where Name = 'OUC | OUNAME'];
    Proj.ouId__c = ou1.id; 
    Sector__c sc1 = new Sector__c();
    sc1 = [select id from Sector__c where Name = 'SCODE | SNAME'];
   // Proj.secId__c = sc1.id; 
    System.debug('Before Project::' +proj); 
    orgUnitSector__c ous = new orgUnitSector__c(ouId__c = ou1.id,secId__c=sc1.id);
    insert ous;
     
    Insert Proj;
    System.debug('After Project::' +proj);
    Implementing_Mechanism__c im = new Implementing_Mechanism__c(ouId__c=OU.id,Implementing_Mechanism_Name__c='IM Name');
    insert im;
    System.debug('After IM::' +im);
    Activity__c act = new Activity__c() ;
    
    act.activity_name__c= 'Test Act';
    Project__c  Proj1 = new Project__c();
    Proj1 = [select id from Project__c where Project_Name__c = 'Test Project'];
    act.Project_code__c = Proj1.id;
    Implementing_Mechanism__c im1 = new Implementing_Mechanism__c();
    im1 = [select id from Implementing_Mechanism__c where Implementing_Mechanism_Name__c='IM Name'];
    act.ImpMech_Id__c = im1.id;
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
    
    loc.Name = 'Test Name';
    loc.admin1BndryId__c = gb1.id;      
    loc.cntryId__c = gc1.id;
    loc.ActivityId__c = act1.Id;
    
    Insert loc; 
    
    system.debug('Location Rec:::'+loc);
    
    Project_Location__c  loc1 = [select id from Project_Location__c where Name = 'Test Name'];
    String navigationLink = gu.createBreadCrumps(loc.id);
        
   }
   catch(exception e)
   {
   }

  }
  
}