@isTest
public with sharing class TestMethod_IRCrossLink {

static testMethod void TestMethod_IRCrossLink() 
{
    Pagereference pRef = Page.vfIRCrossLink;
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
    q1.SobjectType = 'CDCSGoal__c';
    qList.add(q1);
    QueueSobject q2 = new QueueSobject();
    q2.QueueId = grp1.Id;
    q2.SobjectType = 'DO__c';
    qList.add(q2);
    QueueSobject q3 = new QueueSobject();
    q3.QueueId = grp1.Id;
    q3.SobjectType = 'IR__c';
    qList.add(q3);
    QueueSobject q4 = new QueueSobject();
    q4.QueueId = grp1.Id;
    q4.SobjectType = 'CDCSLINK__c';
    qList.add(q4);
    System.runAs(thisUSer){
    insert qList; }
    
    Bureau__c bu = new Bureau__c();
	
	bu.burCode__c = 'BUR';
	bu.burName__c = 'BUR Name';
	bu.Name = 'BUR | BUR Name';
	
	Insert bu;
	
	OrgUnit__c ou = new OrgUnit__c();
	
	ou.ouCode__c = 'OUCODE';
	ou.ouName__c = 'OUNAME';
	ou.Name = 'OUCODE | OUNAME';
	ou.ouDisplayName__c = 'OU DISPNAME';
	Bureau__c bu1 = new Bureau__c();
	bu1 = [select id from Bureau__c where Name = 'BUR | BUR Name'];
    ou.burId__c = bu1.id;
    
    Insert ou;
    
    DO__c devObj = new DO__c();
    
    devObj.Name = 'DO1';
    devObj.DO_Title__c = 'DOTITLE';
    devObj.DO_Code__c = 'DO1';
    
    CDCSGoal__c g1 = new CDCSGoal__c();
    g1 =[select Name, id, ouId__c, ouCode__c, ouName__c from CDCSGoal__c where ouName__c = 'OUNAME'];
    devObj.CDCS_Goal__c = g1.id;
    insert devObj;
    
    System.debug('DO Inserted'+devObj);
    
    
    
    IR__c ir = new IR__c();
    
    ir.Name = 'IR1.1';
    ir.IR_Title__c = 'IRTitle';
    ir.DO_Id__c = devObj.id;
    ir.IR_Code__c = 'IR1.1';
    
    Insert ir;
    
    ir.IR_Title__c = 'IRTitle1';
    
    Update ir;
     
    
    
    //IR__c ir1 = [select id from IR__c where Name = 'IR1.1'];
    
    DO__c devObj2 = new DO__c();
    
    ApexPages.currentPage().getParameters().put('Lid', ir.Id);
    
    System.debug('IR Id' +ir.Id);
    
    ApexPages.StandardController stc = new ApexPages.StandardController(devObj2);
    
    ClsIRCrossLink a = new ClsIRCrossLink(stc); 
    
    a.selectedDos = devObj.id;
    a.prepareIrsXML();
    a.insertIrs();
    a.Cancel(); 
    
                
   }
   catch(exception e)
   {
   }

  }
    
}