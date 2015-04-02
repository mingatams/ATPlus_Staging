@isTest
public with sharing class TestMethod_ProjectIRSIRLink {
  
  public static testMethod void TestMethod_ProjectIRSIRLink() 
  {
    System.debug('Inside the test Method');
    Pagereference pRef = Page.vfProjectIRSIRLink;
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
    q2.SobjectType = 'CDCSGoal__c';
    qList.add(q2);
    
    QueueSobject q3 = new QueueSobject();
    q3.QueueId = grp1.Id;
    q3.SobjectType = 'DO__c';
    qList.add(q3);
    
    QueueSobject q4 = new QueueSobject();
    q4.QueueId = grp1.Id;
    q4.SobjectType = 'IR__c';
    qList.add(q4);
    
    QueueSobject q5 = new QueueSobject();
    q5.QueueId = grp1.Id;
    q5.SobjectType = 'Sub_IR__c';
    qList.add(q5);
    
    QueueSobject q6 = new QueueSobject();
    q6.QueueId = grp1.Id;
    q6.SobjectType = 'CDCSLINK__c';
    qList.add(q6);
    
    QueueSobject q7 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Implementing_Mechanism__c');
    qList.add(q7);
    
    System.runAs(thisUSer){
    insert qList; }
    
    Bureau__c bu = new Bureau__c();
  
    bu.burCode__c = 'BUR';
    bu.burName__c = 'BUR Name';
    bu.Name = 'BUR | BUR Name';
  
    Insert bu;
  
  
  
  //Sector__c sc = [select id, secName__c from Sector__c where secCode__c = 'GH'];
    
  //sc.secCode__c = 'GH';
  //sc.secName__c = 'Global Health';
  //sc.Name = 'GH | Global Health';
    
  //Insert sc; 
  
  OrgUnit__c ou = new OrgUnit__c();
  
  ou.ouCode__c = 'OUC';
  ou.ouName__c = 'OUNAME';
  ou.Name = 'OUC | OUNAME';
  ou.ouDisplayName__c = 'OU DISPNAME';
  Bureau__c bu1 = new Bureau__c();
  bu1 = [select id from Bureau__c where Name = 'BUR | BUR Name'];
    ou.burId__c = bu1.id;
    
    Insert ou;
  OrgUnit__c ou1 = [select id from OrgUnit__c where Name = 'OUC | OUNAME'];    
    
    Sector__c sc = new Sector__c();
    sc.Name = 'SEC NAME';
    sc.secCode__c = 'SEC CODE';
    
    Insert sc;  
    Project__c  Proj = new Project__c ();
    
    Proj.Project_Name__c = 'Test Project';    
    Proj.Start_Date__c = date.parse('10/20/2011');    
    Proj.End_Date__c = date.parse('12/20/2015');
     Proj.Sector_Name__c = 'SEC NAME';
    //OrgUnit__c ou1 = new OrgUnit__c();
    //ou1 = [select id from OrgUnit__c where Name = 'OUC | OUNAME'];
    Proj.ouId__c = ou.id; 
    //Sector__c sc1 = new Sector__c();
    //sc1 = [select id from Sector__c where Name = 'GH | Global Health'];
    
    System.debug('Before Project::' +proj); 
    orgUnitSector__c ous = new orgUnitSector__c(ouId__c = ou.id,secId__c=sc.id);
    insert ous;
    Proj.secId__c = ous.id; 
    Insert Proj;
    
    DO__c devObj = new DO__c();
    
    devObj.Name = 'DO1';
    devObj.DO_Title__c = 'DOTITLE';
    devObj.DO_Code__c = 'DO1';
    
    CDCSGoal__c g1 = new CDCSGoal__c();
    g1 =[select Name, id, ouId__c, ouCode__c, ouName__c from CDCSGoal__c where ouName__c = 'OUNAME'];
    g1.Goal_Statement__c = 'TEST STATEMENT';
    update g1;
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
    
    Sub_IR__c sir = new Sub_IR__c();
    sir.Name='SUB-IR 1.1.1';
    sir.SIR_Title__c = 'SIRTitla';
    sir.IR_Id__c = ir.id;
    //sir.DO_Id__c = devObj.id;
    sir.SIR_Code__c = 'SUB-IR 1.1.1';
    
    Insert sir;
    
    sir.SIR_Title__c = 'SIRTitle1';
    
    Update sir;
    String navigationLink = gu.createBreadCrumps(sir.id);
    //Portfolio_RF_Linkage__c link1 = new Portfolio_RF_Linkage__c();
    //link1.DO_Id__c = devObj.id;
    //link1.IR_Id__c = ir.id;
    //link1.SIR_Id__c = sir.Id;
    //link1.Project_Id__c = Proj.Id;
    //Insert link1;
    
  Portfolio_RF_Linkage__c link = new Portfolio_RF_Linkage__c();
  ApexPages.currentPage().getParameters().put('Lid', proj.Id);
  
  ApexPages.StandardController stc = new ApexPages.StandardController(link);
  ClsProjectIRSIRLink a = new ClsProjectIRSIRLink(stc);
  a.prepareSIrsXML();
  a.selectedSirs = g1.id+':'+devObj.id+':'+ir.id+':'+sir.Id;
  a.insertSIrs();
  a.selectedSirs = g1.id+':'+devObj.id+':'+ir.id;
  a.insertSIrs();
  a.selectedSirs = g1.id+':'+devObj.id;
  a.insertSIrs();
  a.Cancel();

  }
   catch(exception e)
   {
   }
  }

}