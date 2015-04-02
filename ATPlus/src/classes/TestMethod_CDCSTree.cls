@isTest
public with sharing class TestMethod_CDCSTree {

static testMethod void TestMethod_IRCrossLink() 
{
    Pagereference pRef = Page.vfCDCSTree;
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
    QueueSobject q = new QueueSobject(QueueId=grp1.Id, SobjectType='OrgUnit__c');   
    qList.add(q);
    QueueSobject q1 = new QueueSobject(QueueId=grp1.Id, SobjectType='CDCSGoal__c');    
    qList.add(q1);
    QueueSobject q2 = new QueueSobject(QueueId=grp1.Id, SobjectType='DO__c');    
    qList.add(q2);
    QueueSobject q3 = new QueueSobject(QueueId=grp1.Id, SobjectType='IR__c');    
    qList.add(q3);
    QueueSobject q5 = new QueueSobject(QueueId=grp1.Id, SobjectType='Sub_IR__c');    
    qList.add(q5);
    QueueSobject q4 = new QueueSobject(QueueId=grp1.Id, SobjectType='CDCSLINK__c');    
    qList.add(q4);
    System.runAs(thisUSer){
    insert qList; }
    
    Bureau__c bu = new Bureau__c(burCode__c='BUR', burName__c='BUR Name', Name = 'BUR | BUR Name' );	
	Insert bu;
	
	OrgUnit__c ou = new OrgUnit__c(ouCode__c='OUCODE', ouName__c = 'OUNAME', Name = 'OUCODE | OUNAME', ouDisplayName__c = 'OU DISPNAME', burId__c = bu.id );	
	Insert ou;
    
    CDCSGoal__c g1 = new CDCSGoal__c();
    g1 =[select Name, id, ouId__c, ouCode__c, ouName__c from CDCSGoal__c where ouName__c = 'OUNAME'];
    
    ApexPages.currentPage().getParameters().put('Lid', g1.Id);    
    System.debug('Goal Id' +g1.Id);    
    ClsCDCSTree tr = new ClsCDCSTree();
    tr.Cancel();
    
    DO__c devObj = new DO__c(Name = 'DO1', DO_Title__c = 'DOTITLE',CDCS_Goal__c = g1.id); 
    
    insert devObj;
    
    System.debug('DO Inserted'+devObj);
    
    ApexPages.currentPage().getParameters().put('Lid', devObj.Id);    
    System.debug('Do Id' +devObj.Id);    
    ClsCDCSTree tr1 = new ClsCDCSTree();
    tr1.Cancel();
    
    IR__c ir = new IR__c(Name = 'IR1.1', IR_Title__c = 'IRTitle', DO_Id__c = devObj.id);    
    Insert ir;
    
    ir.IR_Title__c = 'IRTitle1';    
    Update ir;
    
    ApexPages.currentPage().getParameters().put('Lid', ir.Id);    
    System.debug('Do Id' +ir.Id);    
    ClsCDCSTree tr2 = new ClsCDCSTree();
    tr2.Cancel();
    
    ApexPages.currentPage().getParameters().put('Lid', ((String)g1.Id).left(15));    
    System.debug('Goal Id' +ir.Id);    
    ClsCDCSTree tr4 = new ClsCDCSTree();
    tr4.Cancel();
     
    Sub_IR__c sir = new Sub_IR__c();
    
    sir.Name = 'IR1.1.1';
    sir.SIR_Title__c = 'SIRTitle';
    sir.IR_Id__c = ir.id;
    
    Insert sir;
    
    sir.SIR_Title__c = 'SIRTitle1';
    
    Update sir;
    
    
    
    
    ApexPages.currentPage().getParameters().put('Lid', sir.Id);    
    System.debug('SIR Id' +sir.Id);    
    ClsCDCSTree tr3 = new ClsCDCSTree();
    tr3.Cancel();
   
    
                
   }
   catch(exception e)
   {
   }

  }


}