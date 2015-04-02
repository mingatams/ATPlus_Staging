@isTest(seealldata=true)
private class testIMupsertTrigger {
	public static testMethod void testTRimBeforeUpsertQOwner(){
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
	    q1.SobjectType = 'Implementing_Mechanism__c';
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
	    OrgUnit__c ou1 = new OrgUnit__c();
	    ou1 = [select id from OrgUnit__c where Name = 'OUCODE | OUNAME'];
	    
	    Implementing_Mechanism__c im = new Implementing_Mechanism__c();
	    im.ouId__c = ou1.id;
	    im.Implementing_Mechanism_Name__c = 'IM Name';
	    
	    insert im;
	    test.stopTest();
	 }catch(exception e){
    }   
	    
	}

}