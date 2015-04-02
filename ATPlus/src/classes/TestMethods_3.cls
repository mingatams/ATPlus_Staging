@isTest
private class TestMethods_3{
      
       //test method for MassUploadLocationNationalProjectN
  
    /*public static testmethod void testMassUploadLocationNationalProjectN() {         
    
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
       // Proj.secId__c = sc1.id; 
        //System.debug('Before Project::' +proj);  
        Insert Proj;
       // System.debug('After Project::' +proj);
        
        Activity__c act = new Activity__c() ;
        
        act.activity_name__c= 'Test Act';
        Project__c  Proj1 = new Project__c();
        Proj1 = [select id from Project__c where Project_Name__c = 'Test Project'];
        act.Project_code__c = Proj1.id;
            
        Insert act; 
        
       
        Location1__c  loc = new Location1__c () ;
    
         loc.Name = 'Test01' ;
         Loc.Location_Description__c = 'test1 \n test1';
         Loc.Location_Names__c = true;
         loc.Activity__c = act.id;
     
        Insert loc ;
        
        Province__c pr = new Province__c();
         pr.country__c='Egypt';
         insert pr;
         
       ApexPages.currentPage().getParameters().put('Lid', act.Id);
       ApexPages.currentPage().getParameters().put('MissionName', 'Egypt');


               
    
       ApexPages.currentPage().getParameters().put('lid', act.Id);
       
       ApexPages.StandardController scsc = new ApexPages.StandardController(loc);
       MassUploadLocationNationalProjectN a = new MassUploadLocationNationalProjectN(scsc);     
       Province__c pr1 = new Province__c();
       pr1.Name = 'Delhi';
       Province__c pr2 = new Province__c();
       pr1.Name = 'Mumbai';
       List<Province__c> selProvinces = new List<Province__c>();
       selProvinces.add(pr1);
       selProvinces.add(pr2);
       
       a.getProvinces();
       a.getSelected();
       a.GetSelectedProvinces();  
       a.prepareLocations();
       a.insertLocations();
       a.Cancel();
       
       
       
       Loc.Location_Description__c = '';
       
       update loc;
        a.insertLocations();
        
}catch(exception e){
               }

  } */
  

     
  


//test method for MassUploadLocationNationalProject
  
 /*       public static testmethod void testMassUploadLocationNationalProject() { 
        
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
       // Proj.secId__c = sc1.id; 
        //System.debug('Before Project::' +proj);  
        Insert Proj;
       // System.debug('After Project::' +proj);
        
        Activity__c act = new Activity__c() ;
        
        act.activity_name__c= 'Test Act';
        Project__c  Proj1 = new Project__c();
        Proj1 = [select id from Project__c where Project_Name__c = 'Test Project'];
        act.Project_code__c = Proj1.id;
            
        Insert act;    
       
        Location1__c  loc = new Location1__c () ;
    
     loc.Name = 'Test01' ;
     Loc.Location_Description__c = 'test1 \n test1';
     Loc.Location_Names__c = true;
     loc.Activity__c = act.id;
     
     Insert loc ;
                 Province__c pr = new Province__c();
         pr.country__c='Bangladesh';
         insert pr;
         
               
               
    
       ApexPages.currentPage().getParameters().put('lid', act.Id);
       
       ApexPages.StandardController scsc = new ApexPages.StandardController(loc);
       MassUploadLocationNationalProject a = new MassUploadLocationNationalProject(scsc);
     
       a.insertLocations();
       
       
       
       Loc.Location_Description__c = '';
       
       update loc;
        a.insertLocations();
        



}catch(exception e){
               }

  } */
  
  

//test method for Project_Before_Delete_ProjectIDs
/* public static testmethod void testProject_Before_Delete_ProjectIDs(){
  
     Bureau__c  b= new Bureau__c (name='testName',burCode__c='TestCode') ;
        insert b;
        
        OrgUnit__c  OU= new OrgUnit__c (name='testName',burId__c=b.id,ouDisplayName__c='Disp5',ouCode__c='IND') ;
        insert OU;
            String code1 = OU.ouCode__c;
            String title1 = OU.name;
            OU.name = code1 + ' | ' + title1;
        Update OU;
     mission__c m = new mission__c () ;
         m.Country_Code__c = 'BD';
         m.Mission_Name__c = 'Bangladesh';
        insert m;        
        
        Project__c p = new Project__c ();
         P.Project_Name__c = 'test' ;
         p.MissionName__c = 'Bangladesh';
         p.ouId__c = ou.id;
        Insert P;
        
        Activity__c a = new Activity__c ();
        a.activity_name__c='test1';
         a.Project_Code__c = P.Id ;
         
        insert a ;
        
        delete P ;
         
 
  } */


//test method for Activity_Upsert_Regional_RecordType 
 public static testmethod void testActivity_Upsert_Regional_RecordType(){
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
        QueueSobject q2 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Project__c');      
        qList.add(q2);
        QueueSobject q3 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Activity__c');     
        qList.add(q3);
        
        QueueSobject q4 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'CDCSLINK__c');
        qList.add(q4);
        QueueSobject q5 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Implementing_Mechanism__c');
         qList.add(q5);
        
        System.runAs(thisUSer){
        insert qList; }
    
    
        Bureau__c  b= new Bureau__c (name='testName',burCode__c='TestCode') ;
        insert b;
        
        OrgUnit__c  OU= new OrgUnit__c (name='OUCODE | OUName',burId__c=b.id,ouDisplayName__c='Disp5',ouCode__c='OUCODE') ;
        insert OU;
            String code1 = OU.ouCode__c;
            String title1 = OU.name;
            OU.name = code1 + ' | ' + title1;
        Update OU;
        
        Sector__c sc = new Sector__c(secCode__c = 'SCODE', Name = 'SCODE | SNAME' ); 
        Insert sc;
        
        orgUnitSector__c ous = new orgUnitSector__c(ouId__c = OU.Id, secId__c = sc.Id);
        insert ous;
        
        Project__c p = new Project__c ();
         P.Project_Name__c = 'test' ;
         p.MissionName__c = 'Central Asia Republics';
         p.ouId__c = ou.Id;
        Insert P;
        
        Implementing_Mechanism__c im = new Implementing_Mechanism__c(ouId__c=OU.id,Implementing_Mechanism_Name__c='IM Name');
         insert im;
        
        Activity__c a = new Activity__c ();
        a.activity_name__c='test1';
         a.Project_Code__c = P.Id ;
         a.ImpMech_Id__c = im.Id;         
        insert a ;
        upsert a;
        
       // upsert a.ID;
        
        Project__c p1 = new Project__c ();
         P1.Project_Name__c = 'test1' ;
         p1.MissionName__c = 'Bangladesh';
         p1.ouId__c = ou.Id;
        Insert P1;
        
        Implementing_Mechanism__c im1 = new Implementing_Mechanism__c(ouId__c=OU.id,Implementing_Mechanism_Name__c='IM Name 1');
         insert im1;
        
        Activity__c a1 = new Activity__c ();
        a1.activity_name__c='test11';
         a1.Project_Code__c = P1.Id ;
         a1.ImpMech_Id__c = im1.Id;
        insert a1 ;
         upsert a1;
 
  }
  
  
 public static testmethod void test1() {
       /*
        profile pr=[select id from profile where name='System Administrator(c)'];
        user u =[select id,name, profileid from user where profileid =:pr.id limit 1];
        
        Project__c p = new Project__c (
            MissionName__c = 'Central Asia Republics'
        );
        
        insert p ;
*/
   }
  
  

// Test method for trigger Project_Insert_MissionnameCannotChange on Project
/*
  public static testmethod void Project_Insert_MissionnameCannotChange() {  
  
  try{
  
        user u =[select id,name, profileid from user where userrole.name = 'RDMA User' limit 1];
        
        Bureau__c  b= new Bureau__c (name='testName',burCode__c='TestCode') ;
        insert b;
        
        OrgUnit__c  OU= new OrgUnit__c (name='testName',burId__c=b.id,ouDisplayName__c='Disp5',ouCode__c='IND') ;
        insert OU;
            String code1 = OU.ouCode__c;
            String title1 = OU.name;
            OU.name = code1 + ' | ' + title1;
        Update OU;
        
        mission__c m = new mission__c (
            Mission_Abbr__c = 'RDMA User', Mission_Name__c = 'Regional Development Mission for Asia'
        );
        insert m ;
        
        Project__c p = new Project__c() ;
        p.missionname__c = '';
        p.ouId__c = ou.Id;
        insert p ;
        p.MissionName__c = m.mission_Name__c;
        Update p;
        
        }catch(exception e){ 
    }           
  }

*/

     public static void testtrFrameworkLinkageBeforeUpsertQOwner(){
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();
        Framework__c objective = testIndicatorUtil.getFrameworks('Objective');
        Framework__c area = testIndicatorUtil.getFrameworks('Area');
        Framework__c element = testIndicatorUtil.getFrameworks('Element');
        Framework__c selement = testIndicatorUtil.getFrameworks('SubElement');
        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        Project__c proj = testIndicatorUtil.getIMProjectRecordForOrgId(OrgUnitId);
        
        Framework_Linkage__c frmLink = testIndicatorUtil.getFrameworkLinks(proj.Id,element.Id,'Program Element');
  
      }

  
  
       public static void testtrLFGoalBeforeDelete(){
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        Project__c proj = testIndicatorUtil.getProjectRecordForOrgId(OrgUnitId);
        Lf_Goal__c lfGoal = testIndicatorUtil.getLFGoalRecordForProjectId(proj.Id);
        LF_Purpose__c lfPurpose = testIndicatorUtil.getLFPurposeRecordForLFgoal(lfGoal.Id);
        LF_SubPurpose__c lfSubPurpose = testIndicatorUtil.getLFSubPurposeRecordForLFPurpose(lfPurpose.Id);
        LF_Output__c lfOutput = testIndicatorUtil.getLFOutputRecordForLFSubPurpose(lfSubPurpose.Id);
        LF_Input__c lfInput = testIndicatorUtil.getLFInputRecordForLFOutput(lfOutput.Id);
        
        delete lfInput;
        delete lfOutput;
        delete lfSubPurpose;        
        delete lfPurpose;
        delete lfGoal;        
        
  
      } 
      
      
       public static void testIndicatorResultsDelete() {
          ClsTestUtility testIndicatorUtil = new ClsTestUtility();  
          
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());          
         // String imId = testIndicatorUtil.getIMForOrgId(OrgUnitId);
         // testIndicatorUtil.updateIMForOrgId(OrgUnitId,'Quarterly','Implementing Mechanism');
           ApplicationConstants.bypassIMCreateVendorTriggerLogic = true;          
          ApplicationConstants.bypassReportingPeriodApprovalLogic = true;
          Implementing_Mechanism__c im = testIndicatorUtil.insertIMForOrgId(OrgUnitId,'Quarterly', 'Implementing Mechanism');
          List<Reporting_Period__c> rpList =  testIndicatorUtil.getReportingPeriods(im.Id);
         // String etId = testIndicatorUtil.getEmailTemplateId('ReportingPeriodPublishReminder');  
         
          OrgUnit_Indicator__c masterInd = testIndicatorUtil.getCustomIndicatorRecordForOrgId(OrgUnitId);
          OrgUnit_Indicator__c childInd = testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,im.Id,'IM',masterInd.Id);        
          
          List<Indicator_Results__c> irList = testIndicatorUtil.getIndicatorResultByIM(rpList,masterInd.Id,childInd.Id,im.Id); 
          
          System.Test.startTest(); 
          
          testIndicatorUtil.getReportingPeriods(im.Id,rpList,'Publish');
         // testIndicatorUtil.getReportingPeriods(imId,rpList,'Open');
              
          
          
          delete irList;
          delete rpList;
          
          System.Test.stopTest();         
          
          
     }
     
     
     @IsTest(SeeAllData=true) public static void testReportingPeriodsUpdate1() {
          ClsTestUtility testIndicatorUtil = new ClsTestUtility();  
          
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());          
         // String imId = testIndicatorUtil.getIMForOrgId(OrgUnitId);
         // testIndicatorUtil.updateIMForOrgId(OrgUnitId,'Quarterly','Implementing Mechanism');
          ApplicationConstants.bypassIMCreateVendorTriggerLogic = true;          
          ApplicationConstants.bypassReportingPeriodApprovalLogic = true;
          Implementing_Mechanism__c im = testIndicatorUtil.insertIMForOrgId(OrgUnitId,'Quarterly', 'Implementing Mechanism');
          List<Reporting_Period__c> rpList =  testIndicatorUtil.getReportingPeriods(im.Id);
         // String etId = testIndicatorUtil.getEmailTemplateId('ReportingPeriodPublishReminder');  
         
          OrgUnit_Indicator__c masterInd = testIndicatorUtil.getCustomIndicatorRecordForOrgId(OrgUnitId);
          OrgUnit_Indicator__c childInd = testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,im.Id,'IM',masterInd.Id);        
          
          List<Indicator_Results__c> irList = testIndicatorUtil.getIndicatorResultByIM(rpList,masterInd.Id,childInd.Id,im.Id); 
          
          System.Test.startTest(); 
          ApplicationConstants.bypassReportingPeriodApprovalLogic = true;
          testIndicatorUtil.getReportingPeriods(im.Id,rpList,'Publish');
          testIndicatorUtil.getReportingPeriods(im.Id,rpList,'Open');
          
          System.runAs(testIndicatorUtil.missionPilotUser){ 
            testIndicatorUtil.getReportingPeriods(im.Id,rpList,'Submitted');
          }
          
              
          
          
         // delete irList;
         // delete rpList;
          
          System.Test.stopTest();         
          
          
     }
     
     @IsTest(seealldata=true) public static void testReportingPeriodsUpdate() {
          ClsTestUtility testIndicatorUtil = new ClsTestUtility();  
          
       //   Folder f = new Folder(AccessType='Public',DeveloperName='Folder1',name='Folder1NAme',Type='Email Template' );
          
       //   System.RunAs(testIndicatorUtil.thisUser){
       //       insert f;
       //   }
       //   System.debug('First line::');
       //   EmailTemplate et = new EMailTemplate(Body='Test Body', DeveloperName='Partner Submitted Email Template',subject='test Subject',Name='TemplateName', TemplateType='Text');
       //   System.debug('Before Email Template');
       //   System.RunAs(testIndicatorUtil.thisUser){
       //       insert et;
       //   }
          System.debug('After Email Template');
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());          
         // String imId = testIndicatorUtil.getIMForOrgId(OrgUnitId);
         // testIndicatorUtil.updateIMForOrgId(OrgUnitId,'Quarterly','Implementing Mechanism');
          ApplicationConstants.bypassIMCreateVendorTriggerLogic = true;          
          ApplicationConstants.bypassReportingPeriodApprovalLogic = true;
          Implementing_Mechanism__c im = testIndicatorUtil.insertIMForOrgId(OrgUnitId,'Quarterly', 'Implementing Mechanism');
          List<Reporting_Period__c> rpList =  testIndicatorUtil.getReportingPeriods(im.Id);
         // String etId = testIndicatorUtil.getEmailTemplateId('ReportingPeriodPublishReminder');  
         
          OrgUnit_Indicator__c masterInd = testIndicatorUtil.getCustomIndicatorRecordForOrgId(OrgUnitId);
          OrgUnit_Indicator__c childInd = testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,im.Id,'IM',masterInd.Id);        
          
          List<Indicator_Results__c> irList = testIndicatorUtil.getIndicatorResultByIM(rpList,masterInd.Id,childInd.Id,im.Id); 
          
          System.Test.startTest(); 
          
          ApplicationConstants.bypassReportingPeriodApprovalLogic = true;
          testIndicatorUtil.getReportingPeriods(im.Id,rpList,'Publish');
          testIndicatorUtil.getReportingPeriods(im.Id,rpList,'Open');
          List<Reporting_Period__c> rpList1 = new List<Reporting_Period__c>();
          Reporting_Period__c rp = rpList[0];
          rp.close_Date__c = rp.close_Date__c + 15;
          rp.Actuals_Recorded__c = false;
          rpList1.add(rpList[0]);
          
          
          testIndicatorUtil.getReportingPeriods(im.Id,rpList1,'Open');
          System.runAs(testIndicatorUtil.thisUser){ 
            ApplicationConstants.bypassReportingPeriodApprovalLogic = false;  
            testIndicatorUtil.getReportingPeriods(im.Id,rpList1,'Submitted');
          }
          
         /* System.runAs(testIndicatorUtil.missionPilotUser){ 
            testIndicatorUtil.getReportingPeriods(imId,rpList1,'Rejected');
          }  
          
          System.runAs(testIndicatorUtil.missionPartnerUser){ 
            testIndicatorUtil.getReportingPeriods(imId,rpList1,'Submitted');
          } */
          System.runAs(testIndicatorUtil.thisUser){ 
          //  testIndicatorUtil.getReportingPeriods(imId,rpList1,'Open');
            testIndicatorUtil.getReportingPeriods(im.Id,rpList1,'Approved');
          }
              
          
          
         // delete irList;
         // delete rpList;
          
          System.Test.stopTest();         
          
          
     }
     
    public static testMethod void testIndicatorResultsUpdate(){
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());       
       // Implementing_Mechanism__c IMId= testIndicatorUtil.getIMRecordForOrgId(OrgUnitId);
       // testIndicatorUtil.updateIMForOrgId(orgUnitId,'Annual','Implementing Mechanism');        
        ApplicationConstants.bypassIMCreateVendorTriggerLogic = true;          
          ApplicationConstants.bypassReportingPeriodApprovalLogic = true;
          Implementing_Mechanism__c imid = testIndicatorUtil.insertIMForOrgId(OrgUnitId,'Annual', 'Implementing Mechanism');
        List<Reporting_Period__c> rpList = testIndicatorUtil.getReportingPeriods(IMId.Id,'IM');
        List<OrgUnit_Indicator__c> masterList = testIndicatorUtil.getCustomIndicatorRecordsForOrgId(OrgUnitId);
        List<OrgUnit_Indicator__c> childInd = testIndicatorUtil.getCustomIndicatorsForType(OrgUnitId,imId.Id,'IM',masterList); 
        List<Indicator_Results__c> irList = testIndicatorUtil.getIndicatorResultByIM(rpList,childInd,imId.Id);
        Reporting_Period__c rp = rpList[0];        
        system.debug('Reporting Period From test method:::'+rp);
        String changedIds;
        List<Indicator_Results__c> irUpdList = new List<Indicator_Results__c>();
        String IndicatorId;
        String subIndicatorId;
       // List<Indicator_Results__c> irUpdList = new List<Indicator_Results__c>();
        Indicator_Results__c cIr = new Indicator_Results__c();
        for(Indicator_Results__c ir: irList){
            if (ir.Reporting_Period_Id__c == rp.Id){
               // ir.baseline__c = '100.00';
                irUpdList.add(ir);
                if (changedIds != null){                    
                    subIndicatorId = ir.Organization_Indicator_Id__c;
                    changedIds = changedIds + ',' + ir.Organization_Indicator_Id__c;
                } else {                    
                    IndicatorId = ir.Organization_Indicator_Id__c;
                    changedIds = ir.Organization_Indicator_Id__c;
                }
            }        
            
        }
        
        System.Test.startTest();
         upsert irUpdList;
        System.Test.stopTest();
     }
     
      
}