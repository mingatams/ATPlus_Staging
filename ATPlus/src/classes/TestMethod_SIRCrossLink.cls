@isTest
public with sharing class TestMethod_SIRCrossLink {

static testMethod void testSIRCrossLink() 
{
    Pagereference pRef = Page.vfSIRCrossLink;
    Test.setCurrentPageReference(pRef);

try{    
    User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
    
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
    QueueSobject q5 = new QueueSobject();
    q5.QueueId = grp1.Id;
    q5.SobjectType = 'Sub_IR__c';
    qList.add(q5);
    System.runAs(thisUSer){
    insert qList; }
    
    Bureau__c bu = new Bureau__c();
    
    bu.burCode__c = 'BUR';
    bu.burName__c = 'BUR Name';
    bu.Name = 'BUR | BUR Name';
    
    Insert bu;
    
    OrgUnit__c ou = new OrgUnit__c();
    
    ou.ouCode__c = 'OUC';
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
    
        
    IR__c ir = new IR__c();
    
    ir.Name = 'IR1.1';
    ir.IR_Title__c = 'IRTitle';
    ir.DO_Id__c = devObj.id;
    ir.IR_Code__c = 'IR1.1';
    
    Insert ir;
    
    ir.IR_Title__c = 'IRTitle1';
    
    Update ir;
    
    Sub_IR__c sir = new Sub_IR__c();
    
    sir.Name = 'SUB-IR 1.1.1';
    sir.SIR_Title__c = 'SIRTIT';
    sir.IR_Id__c = ir.Id;
    
    insert sir;
    
    sir.SIR_Title__c = 'SIRTIT1';
    Update sir;
    
    /*CDCSLINK__c cdcs = new CDCSLINK__c();
    
    cdcs.DO_Id__c = devObj.id;
    cdcs.IR_Id__c = ir.id;
    cdcs.SIR_Id__c = sir.id;
    cdcs.Link_Type__c = 'Secondary IR';
    
    Insert cdcs; */
    
    
    //IR__c ir1 = [select id from IR__c where Name = 'IR1.1'];
    
    //DO__c devObj2 = new DO__c();
    CDCSLINK__c cdcs1 = new CDCSLINK__c();
    ApexPages.currentPage().getParameters().put('Lid', sir.Id);
    
    System.debug('SIR Id' +sir.Id);
    
    ApexPages.StandardController stc = new ApexPages.StandardController(cdcs1);
    
    ClsSIRCrossLink a = new ClsSIRCrossLink(stc); 
    
    a.prepareIrsXML();
    a.selectedIrs = devObj.id+':'+ir.id;
    a.insertSirs();
    a.Cancel(); 
    
    delete sir;
    delete ir;
    delete devObj;
    
   
                
   }
   catch(exception e)
   {
   }

  }
    
}