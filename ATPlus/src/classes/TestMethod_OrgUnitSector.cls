@isTest
private class TestMethod_OrgUnitSector {

public static testMethod void testOrgUnitSector() 
{
    System.debug('Inside the test Method');
    Pagereference pRef = Page.vforgUnitSector;
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
    
    Sector__c sec = new Sector__c();
    sec.Name = 'SEC NAME';
    sec.secCode__c = 'SEC CODE';
    
    Insert sec;
    
    Sector__c sec1 = [select id from Sector__c where Name = 'SEC CODE | SEC NAME'];
    
    orgUnitSector__c ousc = new orgUnitSector__c();
    ousc.ouId__c = ou1.id;
    ousc.secId__c = sec1.id;
    ousc.Name = 'SEC CODE | SEC NAME';
    System.debug('Org Sector Rec:::'+ousc);
    Insert ousc;
    
    orgUnitSector__c ousc1 = [select id from orgUnitSector__c where Name = 'SEC CODE | SEC NAME'];
    System.debug('Org Sector Rec1:::'+ousc1);
    String navigationLink = gu.createBreadCrumps(ousc1.id);
    System.debug('Navigation Link:::'+navigationLink);
    ApexPages.currentPage().getParameters().put('Lid', ou1.Id);
    System.debug('After the Activity ID Generation' +ou1.Id);
    ApexPages.StandardController stc = new ApexPages.StandardController(ousc);
    //System.debug('After the Standrad Controller Generation' +sc5);
    ClsOrgUnitSector a = new ClsOrgUnitSector(stc);     
   
    //a.getProvinces();
    //a.selectedProv = gb1.id;
    a.selectedSectors = sec1.id;
    a.prepareGeoSectorXML();
    //a.getSelected();
    //a.GetSelectedProvinces();  
    //a.prepareProjectLocations();
    a.insertSector();
    a.Cancel(); 
     
    //a.insertLocations();
        
   }
   catch(exception e)
   {
   }

  }
    
}