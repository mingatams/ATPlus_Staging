@isTest(seealldata=true)    
private class TestMethod_OrgUnitGeography {
    
public static testMethod void testOrgUnitGeography() 
{
    System.debug('Inside the test Method');
    Pagereference pRef = Page.vforgUnitGeography;
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
    q1.SobjectType = 'CDCSGoal__c';
    qList.add(q1);
    
    QueueSobject q4 = new QueueSobject();
    q4.QueueId = grp1.Id;
    q4.SobjectType = 'CDCSLINK__c';
    qList.add(q4);
    
    System.runAs(thisUSer){
    insert qList; }
    
    Bureau__c bu = new Bureau__c();
    
    bu.burCode__c = 'BUR';
    bu.burName__c = 'BUR Name';
    bu.Name = 'BUR Name';
    
    Insert bu;
    
    OrgUnit__c ou = new OrgUnit__c();
    
    ou.ouCode__c = 'OUC';
    ou.ouName__c = 'OUNAME';
    ou.Name = 'OUNAME';
    ou.ouDisplayName__c = 'OU DISPNAME';
    Bureau__c bu1 = new Bureau__c();
    bu1 = [select id from Bureau__c where Name = 'BUR | BUR Name'];
    ou.burId__c = bu1.id;
    
    Insert ou;
    
    OrgUnit__c ou1 = [select id from OrgUnit__c where Name = 'OUC | OUNAME'];    
    
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
    
    geoCountry__c gco1 = [select id from geoCountry__c where Name = 'II | IIName'];
    
    orgUnitGeography__c ougp = new orgUnitGeography__c();
    ougp.cntryID__c = gco1.id;
    ougp.orgUnitId__c = ou1.id;
    ougp.Name = 'OUC | II | OUNAME';
    ougp.UniqueRecordName__c = 'OUC | II';
    Insert ougp;
    
    orgUnitGeography__c ougp1 = [select id from orgUnitGeography__c where UniqueRecordName__c = 'OUC | II'];
    
    String navigationLink = gu.createBreadCrumps(ougp1.id);
    
    ApexPages.currentPage().getParameters().put('Lid', ou1.Id);
    System.debug('After the Activity ID Generation' +ou1.Id);
    ApexPages.StandardController stc = new ApexPages.StandardController(ougp);
    //System.debug('After the Standrad Controller Generation' +sc5);
    ClsOrgUnitGeography a = new ClsOrgUnitGeography(stc);     
   
    //a.getProvinces();
    //a.selectedProv = gb1.id;
    a.selectedCountries = gco1.id;
    a.prepareGeoRegionCountriesXML();
    //a.getSelected();
    //a.GetSelectedProvinces();  
    //a.prepareProjectLocations();
    a.insertGeography();
    a.Cancel(); 
    //a.insertLocations();
        
   }
   catch(exception e)
   {
   }

  }
    

}