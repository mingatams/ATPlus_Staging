@isTest(seealldata=true)
private class testTrProjectBeforeupsertQowner {
	public static testmethod void testTrUpsertProjectQowner() {
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
	    
	    bu.burCode__c = 'BUR';
	    //bu.burName__c = 'BUR Name';
	    bu.Name = 'BUR | BUR Name';
	    
	    Insert bu;
	    
	    Sector__c sc = new Sector__c();
	    
	    sc.secCode__c = 'SCODE';
	    //sc.secName__c = 'SNAME';
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
	    
	    
	    
	    }catch(exception e){
    }
  }
}