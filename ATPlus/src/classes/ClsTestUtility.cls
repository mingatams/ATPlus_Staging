@IsTest 
 public class ClsTestUtility { 
 @TestVisible private User missionPilotUser;
 @TestVisible private User missionPartnerUser;
 @TestVisible private User thisUser;
 @TestVisible private Account acct;
 
 clsGlobalUtility GU = new clsGlobalUtility();
// Private method create and Set Group and Queues
@TestVisible private void setGroupNQueue() {

    thisUser = [select Id from User where Id = :UserInfo.getUserId()];
    Profile missionUserProf = [SELECT Id FROM Profile WHERE Name= 'MDA - Mission Data Admin'];
    Profile partnerUserProf = [SELECT Id FROM Profile WHERE Name= 'Mission Partner'];
  
    Group grp = new Group();
    grp.Name = 'OUC User';   
    grp.Type = 'Queue';
    System.runAs(thisUSer){
    insert grp; } 
    
    
    acct=new Account(Name='African Business Network1');
        
        System.runAs(thisUSer){ 
            insert acct;
        }
        
        Contact cont=new Contact(LastName = 'Testing',AccountId = acct.Id);
        System.runAs(thisUSer){ 
            insert cont;
        }
        
        missionPilotUser  = new User(Alias = 'standt', 
                                    Email='rmallipeddi@credence-llc.com', 
                                    isActive=true,       
                                    EmailEncodingKey='UTF-8', 
                                    LastName='Testing1', 
                                    LanguageLocaleKey='en_US',        
                                    LocaleSidKey='en_US', 
                                    ProfileId = missionUserProf.Id,        
                                    TimeZoneSidKey='America/Los_Angeles', 
                                    UserName='standarduserr1@testorg.com');
                                    
        missionPartnerUser  = new User(Alias = 'PUser',  
                                    Email='partneruser1@testorg.com', 
                                    isActive=true,       
                                    EmailEncodingKey='UTF-8', 
                                    LastName='Testing1', 
                                    LanguageLocaleKey='en_US',        
                                    LocaleSidKey='en_US', 
                                    ProfileId = partnerUserProf.Id,        
                                    TimeZoneSidKey='America/Los_Angeles', 
                                    UserName='partneruser1@testorg.com',
                                    ContactId = cont.Id);   
        System.runAs(thisUSer){ 
            insert missionPilotUser;
            insert missionPartnerUser;
        }   
    
    
   GroupMember gm = new GroupMember(UserOrGroupId=missionPilotUser.Id,  GroupId=grp.Id);
        System.runAs(thisUSer){ 
            insert gm;          
        }    
   
   // Build Queue List
    List<QueueSObject> qList = new List<QueueSObject>();
    QueueSobject q = new QueueSobject();
    q.QueueId = grp.Id;
    q.SobjectType = 'OrgUnit__c';
    qList.add(q);   
  
    QueueSobject q1 = new QueueSobject();
    q1.QueueId = grp.Id;
    q1.SobjectType = 'OrgUnit_Indicator__c';
    qList.add(q1);   
    
    QueueSobject q4 = new QueueSobject();
     q4.QueueId = grp.Id;
     q4.SobjectType = 'CDCSGoal__c';
     qList.add(q4 );
           
    QueueSobject q3 = new QueueSobject();
     q3.QueueId = grp.Id;
     q3.SobjectType = 'CDCSLINK__c';
     qList.add(q3);
  
    QueueSobject q2 = new QueueSobject();
     q2.QueueId = grp.Id;
     q2.SobjectType = 'DO__c';
     qList.add(q2);
     
       QueueSobject q5 = new QueueSobject();
     q5.QueueId = grp.Id;
     q5.SobjectType = 'IR__c';
     qList.add(q5);
     
       QueueSobject q6 = new QueueSobject();
     q6.QueueId = grp.Id;
     q6.SobjectType = 'Sub_IR__c';
     qList.add(q6);
     
       QueueSobject q7 = new QueueSobject();
     q7.QueueId = grp.Id;
     q7.SobjectType = 'Implementing_Mechanism__c';
     qList.add(q7);
     
    QueueSobject q8 = new QueueSobject();
     q8.QueueId = grp.Id;
     q8.SobjectType = 'Project__c';
     qList.add(q8);       
      
               
    QueueSobject q9 = new QueueSobject();
     q9.QueueId = grp.Id;
     q9.SobjectType = 'LF_Goal__c';
     qList.add(q9);
     
         QueueSobject q10 = new QueueSobject();
     q10.QueueId = grp.Id;
     q10.SobjectType = 'LF_Purpose__c';
     qList.add(q10);
     
         QueueSobject q11 = new QueueSobject();
     q11.QueueId = grp.Id;
     q11.SobjectType = 'LF_SubPurpose__c';
     qList.add(q11);
     
         QueueSobject q12 = new QueueSobject();
     q12.QueueId = grp.Id;
     q12.SobjectType = 'LF_Output__c';
     qList.add(q12);
     
     QueueSobject q13 = new QueueSobject();
     q13.QueueId = grp.Id;
     q13.SobjectType = 'LogFrame_Tree__c';
     qList.add(q13);
          
     QueueSobject q14 = new QueueSobject();
     q14.QueueId = grp.Id;
     q14.SobjectType = 'RF_Reporting_Period__c';
     qList.add(q14);
     
     
     QueueSobject q15 = new QueueSobject();
     q15.QueueId = grp.Id;
     q15.SobjectType = 'Reporting_Period__c';
     qList.add(q15); 
     
     QueueSobject q16 = new QueueSobject();
     q16.QueueId = grp.Id;
     q16.SobjectType = 'LF_Reporting_Period__c';
     qList.add(q16);  
     
     QueueSobject q17 = new QueueSobject();
     q17.QueueId = grp.Id;
     q17.SobjectType = 'Activity__c';
     qList.add(q17); 
     
     QueueSobject q18 = new QueueSobject();
     q18.QueueId = grp.Id;
     q18.SobjectType = 'Framework_Linkage__c';
     qList.add(q18); 
   
    System.runAs(thisUSer){
    insert qList; }
    
    
    
}


// Private method getBureauId
@TestVisible private String getBureauId(){
 setGroupNQueue();
 Bureau__c bu = new Bureau__c();    
    bu.burCode__c = 'BUR';
    bu.burName__c = 'BUR Name';
    bu.Name = 'BUR Name';    
    Insert bu;
   return bu.Id;
}

// Private method getOrgUnitForBureauId
@TestVisible private String getOrgUnitForBureauId(String burId) { 
   OrgUnit__c ou = new OrgUnit__c();    
    ou.ouCode__c = 'OUC';
    ou.ouName__c = 'OUNAME';
    ou.Name = 'OUNAME';    
    ou.ouDisplayName__c = 'OU DISPNAME';   
    ou.burId__c = burId;    
    ou.ouWebSiteURL__c = 'http://www.usaid.gov/where-we-work/asia/india';
    Insert ou;  
    System.Debug('getOrgUnitForBureauId *** ' + ou);
    return ou.Id;  
 }
 
 @TestVisible private Sector__c getSector(){
     Sector__c ss = new Sector__c(secCode__c='GH',name='GH | Global Health',secName__c='Global Health', secBannerURL__c='http://usaid.gov/what-we-do/global-health');
     insert ss;
     return ss;     
 
 }
 
 @TestVisible private GeoRegion__c getGeoRegion(){
     GeoRegion__c gr = new GeoRegion__c(regCode__c='ASIA',name='ASIA | ASIA',regName__c='ASIA', regWebSiteURL__c='http://www.usaid.gov/where-we-work/asia');
     insert gr;
     return gr;     
 
 }
 
 @TestVisible private GeoCountry__c getGeoCountry(String regId){
     GeoCountry__c gc = new GeoCountry__c(name='IN | India',regId__c=regId,cntryName__c='India',bgaCode__c='386',Center_Latitude__c=22.00000,visible__c=true,Center_Longitude__c=78.00000,cntryBounds__c='7.7, 68.6, 33.2, 89.5',cntryCode__c='IN',cntrydispName__c='India');
     insert gc;
     return gc;     
 
 }
 
 @TestVisible private orgUnitGeography__c getOrgUnitGeography(String ouId,String cntryId){
     orgUnitGeography__c og = new orgUnitGeography__c(name='IND | IN | India',cntryID__c=cntryId,orgUnitId__c=ouId,UniqueRecordName__c='IND | IN');
     insert og;
     return og;     
 
 }
 
 
 @TestVisible private List<GeoBoundary__c> getGeoBoundary(String cntryId){
     List<GeoBoundary__c> gbList = new List<GeoBoundary__c>();
     gbList.add(new GeoBoundary__c(name='IN | India | Punjab',cntryId__c=cntryId,adminBndryName__c='Punjab',adminUniqueName__c='IN | India | Punjab',adminBndryLatitude__c='30.84023339',adminBndryLongitude__c='75.40786355'));
     gbList.add(new GeoBoundary__c(name='IN | India | Rajasthan',cntryId__c=cntryId,adminBndryName__c='Rajasthan',adminUniqueName__c='IN | India | Rajasthan',adminBndryLatitude__c='26.58303359',adminBndryLongitude__c='73.8479495'));
     gbList.add(new GeoBoundary__c(name='IN | India | Tamil Nadu',cntryId__c=cntryId,adminBndryName__c='Tamil Nadu',adminUniqueName__c='IN | India | Tamil Nadu',adminBndryLatitude__c='11.0073361',adminBndryLongitude__c='78.40015166'));
     gbList.add(new GeoBoundary__c(name='IN | India | Andhra Pradesh',cntryId__c=cntryId,adminBndryName__c='Andhra Pradesh',adminUniqueName__c='IN | India | Andhra Pradesh',adminBndryLatitude__c='16.58623641',adminBndryLongitude__c='79.56118315'));
     
     insert gbList;
     return gbList;     
 
 }
 
// Private method getRFGoalForOrgId
 @TestVisible private Framework__c getFrameworks(String type) {
   Framework__c frm ;
   if(type.equalsIgnoreCase('Objective'))
       frm= new Framework__c(Indicator_Wizard_Display__c='Standard',factsCode__c='1',factsName__c='ObjectiveName',poCode__c='1',poName__c='ObjectiveName',paCode__c='',paName__c='',peCode__c='',peName__c='',seCode__c='',seName__c='');
   if(type.equalsIgnoreCase('Area'))
       frm= new Framework__c(Indicator_Wizard_Display__c='Standard',factsCode__c='1.1',factsName__c='ObjectiveName',poCode__c='1',poName__c='ObjectiveName',paCode__c='1.1',paName__c='AreaName',peCode__c='',peName__c='',seCode__c='',seName__c='');
   if(type.equalsIgnoreCase('Element'))
       frm= new Framework__c(Indicator_Wizard_Display__c='Standard',factsCode__c='1.1.1',factsName__c='ObjectiveName',poCode__c='1',poName__c='ObjectiveName',paCode__c='1.1',paName__c='AreaName',peCode__c='1.1.1',peName__c='ElementNAme',seCode__c='',seName__c='');
   if(type.equalsIgnoreCase('SubElement'))
       frm= new Framework__c(Indicator_Wizard_Display__c='Standard',factsCode__c='1.1.1.1',factsName__c='ObjectiveName',poCode__c='1',poName__c='ObjectiveName',paCode__c='1.1',paName__c='AreaName',peCode__c='1.1.1',peName__c='ElementNAme',seCode__c='1.1.1.1',seName__c='Sub element Name');            
   insert frm;
   return frm;
 }

 @TestVisible List<Framework__c> getFTFFrameworks() {
     List<Framework__c> ftfList = new List<Framework__c>();
     ftfList.add(new Framework__c(Indicator_Wizard_Display__c='FTF',factsCode__c='3',factsName__c='ObjectiveName',poCode__c='3',poName__c='ObjectiveName',paCode__c='',paName__c='',peCode__c='',peName__c='',seCode__c='',seName__c=''));
     ftfList.add(new Framework__c(Indicator_Wizard_Display__c='FTF',factsCode__c='3.1',factsName__c='ObjectiveName',poCode__c='3',poName__c='ObjectiveName',paCode__c='3.1',paName__c='AreaName',peCode__c='',peName__c='',seCode__c='',seName__c=''));
     ftfList.add(new Framework__c(Indicator_Wizard_Display__c='FTF',factsCode__c='3.1.1',factsName__c='ObjectiveName',poCode__c='3',poName__c='ObjectiveName',paCode__c='3.1',paName__c='AreaName',peCode__c='3.1.1',peName__c='ElementNAme',seCode__c='',seName__c=''));
     ftfList.add(new Framework__c(Indicator_Wizard_Display__c='FTF',factsCode__c='3.1.1.1',factsName__c='ObjectiveName',poCode__c='3',poName__c='ObjectiveName',paCode__c='3.1',paName__c='AreaName',peCode__c='3.1.1',peName__c='ElementNAme',seCode__c='3.1.1.1',seName__c='Sub element Name'));
     
     insert ftfList;
     return ftfList;
 }


@TestVisible Framework_Linkage__c getFrameworkLinks(String projId,String frmId, String type) {
    Framework_Linkage__c frmLink = new Framework_Linkage__c(Project_Id__c=projId,Framework_Id__c=frmId,Facts_Element_Type__c=type);
    insert frmLink ;
    return frmLink ;
}

// Private method getRFGoalForOrgId
 @TestVisible CDCSGoal__c getRFGoalRecordForOrgId(String OrgId) { 
   CDCSGoal__c rfGoal= [select Id,Name from CDCSGoal__c where ouId__c = :OrgId];
   System.Debug('getRFGoalForOrgId*** ' + rfGoal);
   return rfGoal;
 }
 
 @TestVisible private Do__c getRFDORecordForRFGoal(String goalId) { 
  //clsGlobalUtility GU = new clsGlobalUtility();
   DO__c testRFGoalDO = new DO__c(CDCS_Goal__c=goalId,Name = 'DO 1',DO_Title__c='Test DO');
    insert testRFGoalDO;    
   return testRFGoalDO;
 }
 
 @TestVisible private IR__c getRFIRRecordForRFDO(String doId) { 
  //clsGlobalUtility GU = new clsGlobalUtility();
   IR__c testRFGoalDOIR = new IR__c(DO_Id__c=doId,Name = 'IR 1.1',IR_Title__c='Test IR');
    insert testRFGoalDOIR;  
   return testRFGoalDOIR;
 }    
 
 @TestVisible private Sub_IR__c getRFSIRRecordForRFIR(String irId) { 
   //clsGlobalUtility GU = new clsGlobalUtility();
   Sub_IR__c testRFGoalDOIRSubIR = new Sub_IR__c(IR_Id__c=irId,Name ='SUB-IR 1.1.1',SIR_Title__c='Test Sub IR');
    insert testRFGoalDOIRSubIR;
    return testRFGoalDOIRSubIR;
 }
 
// Private method getRFGoalForOrgId
@TestVisible private String getRFGoalForOrgId(String OrgId) { 
   CDCSGoal__c rfGoal= [select Id,Name from CDCSGoal__c where ouId__c = :OrgId];
   System.Debug('getRFGoalForOrgId*** ' + rfGoal);
   return rfGoal.id;
 }
 
 @TestVisible private void updateRFGoalForOrgId(String OrgId) { 
   CDCSGoal__c rfGoal= [select Id,Name from CDCSGoal__c where ouId__c = :OrgId];
   rfGoal.Start_Year__c = '2011';
   rfGoal.End_Year__c = '2015';   
   System.Debug('getRFGoalForOrgId*** ' + rfGoal);
   upsert rfGoal;
 }
 
 
    // Private method getRFDOForGoal
@TestVisible private String getRFDOForGoal(String goalId) { 
    DO__c testRFGoalDO = new DO__c(CDCS_Goal__c=goalId,Name = 'DO 1',DO_Title__c='Test DO');
    insert testRFGoalDO;    
   return testRFGoalDO.Id;
 }

    // Private method getRFIRForDO
@TestVisible private String getRFIRForDO(String doId) { 
    IR__c testRFGoalDOIR = new IR__c(DO_Id__c=doId,Name = 'IR 1.1',IR_Title__c='Test IR');
    insert testRFGoalDOIR;  
   return testRFGoalDOIR.Id;
 }
 
    // Private method getRFSubIRForIR
@TestVisible private String getRFSubIRForIR(String IRId) {
    //clsGlobalUtility gu = new clsGlobalUtility(); 
    Sub_IR__c testRFGoalDOIRSubIR = new Sub_IR__c(IR_Id__c=IRId,Name ='SUB-IR 1.1.1',SIR_Title__c='Test Sub IR');
    insert testRFGoalDOIRSubIR;
    //String navigationLink = gu.createBreadCrumps(testRFGoalDOIRSubIR.Id);
    return testRFGoalDOIRSubIR.Id ;  
    
 }
 
 // Private method getIMForOrgId
@TestVisible private Implementing_Mechanism__c getIMRecordForOrgId(String OrgId) { 
   Implementing_Mechanism__c testIM = new Implementing_Mechanism__c(ouId__c=OrgId,Implementing_Mechanism_Name__c= 'TestIM-Utility-99999');
    insert testIM;
   return testIM;
 } 
 
@TestVisible private String getIMForOrgId(String OrgId) { 
   Implementing_Mechanism__c testIM = new Implementing_Mechanism__c(ouId__c=OrgId,Implementing_Mechanism_Name__c= 'TestIM-Utility-99999',COR__c=missionPilotUser.id);
    insert testIM;
   return testIM.id;
 }
 
 // Private method getIMForOrgId
@TestVisible private String getPortfolioRFLinks(String projId,String goalId, String doId, String irId, String sirId,String type) {
    Portfolio_RF_Linkage__c pl;
    if (type.equalsIgnoreCase('Goal'))
        pl = new Portfolio_RF_Linkage__c(Project_Id__c=projId,Goal_Id__c=goalId);
    if (type.equalsIgnoreCase('Do'))
        pl = new Portfolio_RF_Linkage__c(Project_Id__c=projId,Goal_Id__c=goalId, DO_Id__c=doId);      
    if (type.equalsIgnoreCase('IR'))
        pl = new Portfolio_RF_Linkage__c(Project_Id__c=projId,IR_Id__c=irId,Goal_Id__c=goalId, DO_Id__c=doId);          
    if (type.equalsIgnoreCase('SIR'))
        pl = new Portfolio_RF_Linkage__c(Project_Id__c=projId,SIR_Id__c=sirId,IR_Id__c=irId,Goal_Id__c=goalId, DO_Id__c=doId);          
   
    insert pl;
   return pl.id;
 }

 
 // Private method getIMForOrgId
@TestVisible private String getIMForOrgIdNRecordType(String OrgId,String recordType) { 
String IMRecordTypeId = GU.getRecordTypeId('Implementing_Mechanism__c', recordType);
   Implementing_Mechanism__c testIM = new Implementing_Mechanism__c(ouId__c=OrgId,Implementing_Mechanism_Name__c= 'TestIM-Utility-99999',RecordTypeid =IMRecordTypeId );
    insert testIM;
   return testIM.id;
 }
 
 @TestVisible private Implementing_Mechanism__c insertIMForOrgId(String OrgId,String rFreq, String rLevel) { 
  //clsGlobalUtility GU = new clsGlobalUtility();
  
   //Implementing_Mechanism__c testIM = new Implementing_Mechanism__c(ouId__c=OrgId,Implementing_Mechanism_Name__c= 'TestIM');
   //Implementing_Mechanism__c testIM = [Select Id, Name, Start_Date__c, End_Date__c, Reporting_Frequency__c, Reporting_Level__c From Implementing_Mechanism__c Where ouId__c=:OrgId and Implementing_Mechanism_Name__c= 'TestIM-Utility-99999' ];
   Implementing_Mechanism__c testIM = new Implementing_Mechanism__c(ouId__c=OrgId,
                                                               Implementing_Mechanism_Name__c= 'TestIM-Utility-99999',
                                                               start_Date__c = date.newinstance(2010, 2, 17),
                                                               End_Date__c = date.newinstance(2011, 6, 10),
                                                               Reporting_Level__c = rLevel,
                                                               COR__c = missionPilotUser.Id,
                                                               Partner_Id__c = acct.Id,   
                                                               Partner_User_1__c = missionPartnerUser.Id );  
   system.debug('IM Record From Test Utility Before Update:::'+testIM);
    insert testIM;
   system.debug('IM Record From Test Utility Before Update:::'+testIM);
   return testIM;
 }
 
 @TestVisible private void updateIMForOrgId(String OrgId,String rFreq, String rLevel) { 
  //clsGlobalUtility GU = new clsGlobalUtility();
  
   //Implementing_Mechanism__c testIM = new Implementing_Mechanism__c(ouId__c=OrgId,Implementing_Mechanism_Name__c= 'TestIM');
   Implementing_Mechanism__c testIM = [Select Id, Name, Start_Date__c, End_Date__c, Reporting_Frequency__c, Reporting_Level__c From Implementing_Mechanism__c Where ouId__c=:OrgId and Implementing_Mechanism_Name__c= 'TestIM-Utility-99999' ];
   testIM.start_Date__c = date.newinstance(2010, 2, 17);
   testIM.End_Date__c = date.newinstance(2014, 6, 10);
   // testIM.Reporting_Frequency__c = rFreq;
   testIM.Reporting_Level__c = rLevel;
   testIM.AOR__c = missionPilotUser.Id;
   testIM.Partner_Id__c = acct.Id;   
   testIM.Partner_User_1__c = missionPartnerUser.Id;   
   system.debug('IM Record From Test Utility Before Update:::'+testIM);
    update testIM;
   system.debug('IM Record From Test Utility Before Update:::'+testIM);
 }
 
 @TestVisible private void updateIMForOrgId(String OrgId, String rLevel) { 
  //clsGlobalUtility GU = new clsGlobalUtility();
  
   //Implementing_Mechanism__c testIM = new Implementing_Mechanism__c(ouId__c=OrgId,Implementing_Mechanism_Name__c= 'TestIM');
   Implementing_Mechanism__c testIM = [Select Id, Name, Start_Date__c, End_Date__c, Reporting_Level__c From Implementing_Mechanism__c Where ouId__c=:OrgId and Implementing_Mechanism_Name__c= 'TestIM-Utility-99999' ];
   testIM.start_Date__c = date.newinstance(2010, 2, 17);
   testIM.End_Date__c = date.newinstance(2014, 6, 10);
   //testIM.Reporting_Frequency__c = rFreq;
   testIM.Reporting_Level__c = rLevel;
   testIM.AOR__c = missionPilotUser.Id;
   testIM.Partner_Id__c = acct.Id;   
   testIM.Partner_User_1__c = missionPartnerUser.Id;
   system.debug('IM Record From Test Utility Before Update:::'+testIM);
    update testIM;
   
 }
 
 // Private method getProjectForOrgId
  @TestVisible private Project__c getProjectRecordForOrgId(String OrgId) { 
  //clsGlobalUtility GU = new clsGlobalUtility();
   String pId = getProjectForOrgId(OrgId);
   Project__c proj = (Project__c) GU.lookup(pId,'Project__c');
  
   return proj;
 }
 
 // Private method getProjectForOrgId
  @TestVisible private Project__c getIMProjectRecordForOrgId(String OrgId) { 
  //clsGlobalUtility GU = new clsGlobalUtility();
   String pId = getIMProjectForOrgId(OrgId);
   Project__c proj = (Project__c) GU.lookup(pId,'Project__c');
  
   return proj;
 }
 
 
 // Private method getProjectForOrgId
  @TestVisible private String getIMProjectForOrgId(String OrgId) { 
  //clsGlobalUtility GU = new clsGlobalUtility();
  String imRecordTypeId = GU.getRecordTypeId('Project__c', 'IM Project');
   Project__c testFactSheet = new Project__c(ouId__c=OrgId,Public_Name__c= 'Test IM Project',Project_Description__c='Test IM Proj Title',RecordTypeid =imRecordTypeId);
    insert testFactSheet;    
     System.Debug('testFactSheet*** ' + testFactSheet);
   return testFactSheet.Id;
 }
 
 // Private method getProjectForOrgId
  @TestVisible private String getProjectForOrgId(String OrgId) { 
  //clsGlobalUtility GU = new clsGlobalUtility();
  String LfRecordTypeId = GU.getRecordTypeId('Project__c', 'LF Project');
   Project__c testFactSheet = new Project__c(ouId__c=OrgId,Public_Name__c= 'Test Project',Project_Description__c='Test Proj Title',RecordTypeid =LfRecordTypeId);
    insert testFactSheet;    
     System.Debug('testFactSheet*** ' + testFactSheet);
   return testFactSheet.Id;
 }
 
 // Private method get PublicIMLinkId
@TestVisible private String getPublicIMLinkId(String imId, String ProjectId) { 
    
    Public_IM_Link__c PubIm = new Public_IM_Link__c(Implementing_Mechanism_Number__c = imId, Project_Code__c = ProjectId);
    insert PubIm;
   return PubIm.id;
 }
 
 

 // Private method getProjectForOrgId
  @TestVisible private void updateProjectForOrgId(String OrgId) { 
  //clsGlobalUtility GU = new clsGlobalUtility();
  String LfRecordTypeId = GU.getRecordTypeId('Project__c', 'LF Project');
   //Project__c testFactSheet = new Project__c(ouId__c=OrgId,Public_Name__c= 'Test Project',Project_Description__c='Test Proj Title',RecordTypeid =LfRecordTypeId);
   Project__c testFactSheet = [Select Id, Name, Start_Date__c, End_Date__c From Project__c where ouId__c= :OrgId and RecordTypeid =:LfRecordTypeId and Public_Name__c= 'Test Project' ];
    testFactSheet.Start_Date__c = date.newinstance(2010, 2, 17);
    testFactSheet.End_Date__c = date.newinstance(2013, 6, 10);
    upsert testFactSheet;    
     System.Debug('testFactSheet*** ' + testFactSheet);
   //return testFactSheet.Id;
 }
 
  // Private method getTask
@TestVisible private String getTask(String imId, String projId) { 
    Activity__c testTask = new Activity__c(ImpMech_Id__c=imId, Project_Code__c=projId, Activity_Name__c = 'Test Task');
    insert testTask;    
    return testTask.Id;
 } 
 
 @TestVisible private Activity__c getTaskRecordForIMAndProject(String imId, String projId) { 
    Activity__c testTask = new Activity__c(ImpMech_Id__c=imId, Project_Code__c=projId, Activity_Name__c = 'Test Task');
    insert testTask;    
    return testTask;
 } 

// Private method getLFGoalForProjectId
@TestVisible private LF_Goal__c getLFGoalRecordForProjectId(String projId) { 
   LF_Goal__c lfGoal= [select Id,Name from LF_Goal__c where Project_Id__c = :projId];
   System.Debug('testLFPurpose *** ' + lfGoal);
   return lfGoal;
 } 
 
 @TestVisible private LF_Purpose__c getLFPurposeRecordForLFgoal(String goalId) { 
   LF_Purpose__c testLFPurpose = [select Id,Name from LF_Purpose__c where LF_Goal_Id__c = :goalId];
    upsert testLFPurpose ;    
   return testLFPurpose;
 } 
 
 @TestVisible private LF_SubPurpose__c getLFSubPurposeRecordForLFPurpose(String purposeId) { 
    LF_SubPurpose__c testLFSubPurpose = new LF_SubPurpose__c(LF_Purpose_Id__c=purposeId,LF_SubPurpose_Name__c = 'Test SUb Purpose');
    insert testLFSubPurpose ;    
   return testLFSubPurpose;
 }
 
 @TestVisible private LF_Output__c  getLFOutputRecordForLFSubPurpose(String subPurposeId) { 
    LF_Output__c  testLFOutput = new LF_Output__c(LF_SubPurpose_Id__c=subPurposeId,LF_Output_Name__c = 'Test LF OutPut');
    insert testLFOutput ;    
   return testLFOutput;
 }
 
 @TestVisible private LF_Output__c getLFOutputRecordForLFPurpose(String purposeId) { 
    LF_Output__c  testLFOutput = new LF_Output__c(LF_Purpose_Id__c=purposeId,LF_Output_Name__c = 'Test LF OutPut');
    insert testLFOutput ;    
   return testLFOutput;
 }
 
 @TestVisible LF_Input__c getLFInputRecordForLFOutput(String outputId) { 
    LF_Input__c  testLFInput = new LF_Input__c(LF_Output_Id__c=outputId,LF_Input_Name__c = 'Test LF Input');
    insert testLFInput ;    
   return testLFInput;
 }
 
// Private method getLFGoalForProjectId
@TestVisible private String getLFGoalForProjectId(String projId) { 
   LF_Goal__c lfGoal= [select Id,Name from LF_Goal__c where Project_Id__c = :projId];
   System.Debug('testLFPurpose *** ' + lfGoal);
   return lfGoal.id;
 }

// Private method getLFGoalForProjectId
@TestVisible private String updateLFGoalForProjectId(String projId) { 
   LF_Goal__c lfGoal= [select Id,Name from LF_Goal__c where Project_Id__c = :projId];
   upsert lfGoal;
   System.Debug('testLFPurpose *** ' + lfGoal);
   return lfGoal.id;
 }

 // Private method getLFPurposeForGoal
@TestVisible private String getLFPurposeForGoal(String goalId) { 
    //LF_Purpose__c testLFPurpose = new LF_Purpose__c(LF_Goal_Id__c=goalId,LF_Purpose_Name__c = 'Test Purpose');
    LF_Purpose__c testLFPurpose = [select Id,Name from LF_Purpose__c where LF_Goal_Id__c = :goalId];
    upsert testLFPurpose ;    
   return testLFPurpose.Id;
 }
 
  // Private method getLFSubPurpose
@TestVisible private String getLFSubPurpose(String purposeId) { 
    LF_SubPurpose__c testLFSubPurpose = new LF_SubPurpose__c(LF_Purpose_Id__c=purposeId,LF_SubPurpose_Name__c = 'Test SUb Purpose');
    insert testLFSubPurpose ;    
   return testLFSubPurpose.Id;
 } 

 
  // Private method getLFOutput
@TestVisible private String getLFOutput(String subPurposeId) { 
    LF_Output__c  testLFOutput = new LF_Output__c(LF_SubPurpose_Id__c=subPurposeId,LF_Output_Name__c = 'Test LF OutPut');
    insert testLFOutput ;    
   return testLFOutput.Id;
 }
 
 
   // Private method getLFOutput
@TestVisible private String getLFOutputP(String purposeId) { 
    LF_Output__c  testLFOutput = new LF_Output__c(LF_Purpose_Id__c=purposeId,LF_Output_Name__c = 'Test LF OutPut');
    insert testLFOutput ;    
   return testLFOutput.Id;
 }
 
  // Private method getLFInput
@TestVisible private String getLFInput(String outputId) { 
    LF_Input__c  testLFInput = new LF_Input__c(LF_Output_Id__c=outputId,LF_Input_Name__c = 'Test LF Input');
    insert testLFInput ;    
   return testLFInput.Id;
 }
 
 // Private method getReportingPeriods
@TestVisible private List<Reporting_Period__c> getReportingPeriods(String imId) { 
    List<Reporting_Period__c>  rpList = new List<Reporting_Period__c>([Select Id,Name, Reporting_Level__c,Implementing_Mechanism_Id__c,recordTypeId,Status__c, Start_Date__c, End_Date__c, Close_Date__c From Reporting_Period__c Where Implementing_Mechanism_Id__c = : imId]);
    upsert rpList;    
   return rpList;
 }
 
 // Private method getReportingPeriods
@TestVisible private List<Reporting_Period__c> getReportingPeriods(String objId,String type) {
    List<Reporting_Period__c>  rpList;
    if (type.equalsIgnoreCase('IM')) 
        rpList = new List<Reporting_Period__c>([Select Id,Name, recordTypeId,Status__c, Reporting_Level__c,Implementing_Mechanism_Id__c,Start_Date__c, End_Date__c, Close_Date__c From Reporting_Period__c Where Implementing_Mechanism_Id__c = : objId]);
    if (type.equalsIgnoreCase('Task')) 
        rpList = new List<Reporting_Period__c>([Select Id,Name, recordTypeId,Status__c, Reporting_Level__c,Implementing_Mechanism_Id__c,Start_Date__c, End_Date__c, Close_Date__c From Reporting_Period__c Where Implementing_Mechanism_Id__c = : objId]);            
    upsert rpList;    
   return rpList;
 }
 
  // Private method getReportingPeriods
@TestVisible private List<Reporting_Period__c> getReportingPeriods(String imId,List<Reporting_Period__c> rpList, String status) { 
    List<Reporting_Period__c> rpListUpd = new List<Reporting_Period__c>();
    for(Reporting_Period__c rp: rpList){
        rp.Status__c = status;
        if (status == 'Submitted')
            rp.Results_Established__c =true;
        rp.Targets_Established__c = true;
        rp.close_Date__c = Date.today().addDays(17);
        rp.end_Date__c = Date.today().addDays(31);
        rpListUpd.add(rp);
    }
    upsert rpListUpd;    
   return rpListUpd;
 }
 
 
 
  // Private method getLFReportingPeriods
@TestVisible private List<LF_Reporting_Period__c> getLFReportingPeriods(String goalId) { 
    List<LF_Reporting_Period__c>  rpList = new List<LF_Reporting_Period__c>([Select Id,Name, LF_Goal_Id__c,LF_Purpose_Id__c,LF_SubPurpose_Id__c,LF_Output_Id__c,LF_Input_Id__c,recordTypeId,Status__c, Start_Date__c, End_Date__c From LF_Reporting_Period__c Where LF_Goal_Id__c = : goalId]);
    upsert rpList;    
   return rpList;
 }
 
   // Private method getLFReportingPeriods
@TestVisible private List<LF_Reporting_Period__c> getLFReportingPeriods(String objId,String type) {
    List<LF_Reporting_Period__c>  rpList;
    if (type.equalsIgnoreCase('Goal')) 
        rpList = new List<LF_Reporting_Period__c>([Select Id,Name, recordTypeId,Status__c, LF_Goal_Id__c,LF_Purpose_Id__c,LF_SubPurpose_Id__c,LF_Output_Id__c,LF_Input_Id__c,Start_Date__c, End_Date__c From LF_Reporting_Period__c Where LF_Goal_Id__c = : objId]);
    if (type.equalsIgnoreCase('Purpose')) 
        rpList = new List<LF_Reporting_Period__c>([Select Id,Name, recordTypeId,Status__c, LF_Goal_Id__c,LF_Purpose_Id__c,LF_SubPurpose_Id__c,LF_Output_Id__c,LF_Input_Id__c,Start_Date__c, End_Date__c From LF_Reporting_Period__c Where LF_Purpose_Id__c = : objId]);    
    if (type.equalsIgnoreCase('SubPurpose')) 
        rpList = new List<LF_Reporting_Period__c>([Select Id,Name, recordTypeId,Status__c, Start_Date__c, LF_Goal_Id__c,LF_Purpose_Id__c,LF_SubPurpose_Id__c,LF_Output_Id__c,LF_Input_Id__c,End_Date__c From LF_Reporting_Period__c Where LF_SubPurpose_Id__c = : objId]);        
    if (type.equalsIgnoreCase('Output')) 
        rpList = new List<LF_Reporting_Period__c>([Select Id,Name,recordTypeId, Status__c, Start_Date__c, LF_Goal_Id__c,LF_Purpose_Id__c,LF_SubPurpose_Id__c,LF_Output_Id__c,LF_Input_Id__c,End_Date__c From LF_Reporting_Period__c Where LF_Output_Id__c = : objId]);            
    if (type.equalsIgnoreCase('Input')) 
        rpList = new List<LF_Reporting_Period__c>([Select Id,Name, recordTypeId,Status__c, Start_Date__c, LF_Goal_Id__c,LF_Purpose_Id__c,LF_SubPurpose_Id__c,LF_Output_Id__c,LF_Input_Id__c,End_Date__c From LF_Reporting_Period__c Where LF_Input_Id__c = : objId]);                
    upsert rpList;    
   return rpList;
 }
 
 
    // Private method getLFReportingPeriods
@TestVisible private List<RF_Reporting_Period__c> getRFReportingPeriods(String objId,String type) {
    List<RF_Reporting_Period__c>  rpList;
    if (type.equalsIgnoreCase('Goal')) 
        rpList = new List<RF_Reporting_Period__c>([Select Id,Name, recordTypeId,Status__c, Start_Date__c, Goal_Id__c,DO_Id__c,IR_Id__c,SIR_Id__c,End_Date__c From RF_Reporting_Period__c Where Goal_Id__c = : objId]);
    if (type.equalsIgnoreCase('Do')) 
        rpList = new List<RF_Reporting_Period__c>([Select Id,Name, recordTypeId,Status__c, Start_Date__c,  Goal_Id__c,DO_Id__c,IR_Id__c,SIR_Id__c,End_Date__c From RF_Reporting_Period__c Where DO_Id__c = : objId]);    
    if (type.equalsIgnoreCase('Ir')) 
        rpList = new List<RF_Reporting_Period__c>([Select Id,Name, recordTypeId,Status__c, Start_Date__c,  Goal_Id__c,DO_Id__c,IR_Id__c,SIR_Id__c,End_Date__c From RF_Reporting_Period__c Where IR_Id__c = : objId]);        
    if (type.equalsIgnoreCase('SIR')) 
        rpList = new List<RF_Reporting_Period__c>([Select Id,Name, recordTypeId,Status__c, Start_Date__c,  Goal_Id__c,DO_Id__c,IR_Id__c,SIR_Id__c,End_Date__c From RF_Reporting_Period__c Where SIR_Id__c = : objId]);            
    
    upsert rpList;    
   return rpList;
 }

// Private method getIMForOrgIdindName
@TestVisible private OrgUnit_Indicator__c getCustomIndicatorRecordForOrgId(String OrgId) { 
   String masterRecType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'Master');
   OrgUnit_Indicator__c testOrgUnitIndicator = new OrgUnit_Indicator__c(ouId__c=OrgId,RecordTypeId=masterRecType,source__c='STANDARD',indcode__c= '1-Z1',indName__c= 'Master',sindcode__c= '1-Z12',sindName__c= 'SubMaster');
    insert testOrgUnitIndicator ;
     System.Debug('getCustomIndicatorForOrgId*** ' + testOrgUnitIndicator);
   return testOrgUnitIndicator;
 } 
 
 @TestVisible private OrgUnit_Indicator__c getCustomIndicatorRecordForOrgId(String OrgId,Boolean pprFlag) { 
   String masterRecType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'Master');
   OrgUnit_Indicator__c testOrgUnitIndicator = new OrgUnit_Indicator__c(ouId__c=OrgId,RecordTypeId=masterRecType,source__c='STANDARD',indcode__c= '1-Z1',indName__c= 'Master',sindcode__c= '1-Z12',sindName__c= 'SubMaster',PPR__c = pprFlag);
    insert testOrgUnitIndicator ;
     System.Debug('getCustomIndicatorForOrgId*** ' + testOrgUnitIndicator);
   return testOrgUnitIndicator;
 } 
 
 @TestVisible private List<USAID_Indicator__c> getUSAIDIndicatorRecords() { 
   List<USAID_Indicator__c> uIndicators = new List<USAID_Indicator__c>();
   uIndicators.add(new USAID_Indicator__c(Program_Objective__c='1',Source__c='Standard',prCode__c='1',prName__c='Peace And Security',indCode__c='1--1',indName__c='Standard Objective Test',indStatus__c='Active',sIndCode__c='',sIndName__c=''));
   uIndicators.add(new USAID_Indicator__c(Program_Objective__c='1',Source__c='Standard',prCode__c='1',prName__c='Peace And Security',indCode__c='1--1',indName__c='Standard Objective Test',indStatus__c='Active',sIndCode__c='1--1a',sIndName__c='Standard Objective Sub Indicator'));
   uIndicators.add(new USAID_Indicator__c(Program_Objective__c='1',Source__c='Standard',prCode__c='1.1',prName__c='Area 1',indCode__c='1.1-1',indName__c='Standard Area Test',indStatus__c='Active',sIndCode__c='',sIndName__c=''));
   uIndicators.add(new USAID_Indicator__c(Program_Objective__c='1',Source__c='Standard',prCode__c='1.1',prName__c='Area 1',indCode__c='1.1-1',indName__c='Standard Area Test',indStatus__c='Active',sIndCode__c='1.1-1a',sIndName__c='Standard Area Sub Indicator'));
   
   uIndicators.add(new USAID_Indicator__c(Program_Objective__c='1',Source__c='Standard',prCode__c='1.1.1',prName__c='Element 1',indCode__c='1.1.1-1',indName__c='Standard Element Test',indStatus__c='Active',sIndCode__c='',sIndName__c=''));
   uIndicators.add(new USAID_Indicator__c(Program_Objective__c='1',Source__c='Standard',prCode__c='1.1.1',prName__c='Element 1',indCode__c='1.1.1-1',indName__c='Standard element Test',indStatus__c='Active',sIndCode__c='1.1.1-1a',sIndName__c='Standard Element Sub Indicator'));
   
   uIndicators.add(new USAID_Indicator__c(Program_Objective__c='1',Source__c='Standard',prCode__c='1.1.1.1',prName__c='Sub Element 1',indCode__c='1.1.1.1-1',indName__c='Standard Sub Element Test',indStatus__c='Active',sIndCode__c='',sIndName__c=''));
   uIndicators.add(new USAID_Indicator__c(Program_Objective__c='1',Source__c='Standard',prCode__c='1.1.1.1',prName__c='Sub Element 1',indCode__c='1.1.1.1-1',indName__c='Standard sub element Test',indStatus__c='Active',sIndCode__c='1.1.1.1-1a',sIndName__c='Standard Sub Element Sub Indicator'));
   
   
   uIndicators.add(new USAID_Indicator__c(Program_Objective__c='3',Source__c='FTF',prCode__c='3',prName__c='Peace And Security',indCode__c='3--1',indName__c='Standard Objective Test',indStatus__c='Active',sIndCode__c='',sIndName__c=''));
   uIndicators.add(new USAID_Indicator__c(Program_Objective__c='3',Source__c='FTF',prCode__c='3',prName__c='Peace And Security',indCode__c='3--1',indName__c='Standard Objective Test',indStatus__c='Active',sIndCode__c='3--1a',sIndName__c='Standard Objective Sub Indicator'));
   uIndicators.add(new USAID_Indicator__c(Program_Objective__c='3',Source__c='FTF',prCode__c='3.1',prName__c='Area 1',indCode__c='3.1-1',indName__c='Standard Area Test',indStatus__c='Active',sIndCode__c='',sIndName__c=''));
   uIndicators.add(new USAID_Indicator__c(Program_Objective__c='3',Source__c='FTF',prCode__c='3.1',prName__c='Area 1',indCode__c='3.1-1',indName__c='Standard Area Test',indStatus__c='Active',sIndCode__c='3.1-1a',sIndName__c='Standard Area Sub Indicator'));
   
   uIndicators.add(new USAID_Indicator__c(Program_Objective__c='3',Source__c='FTF',prCode__c='3.1.1',prName__c='Element 1',indCode__c='3.1.1-1',indName__c='Standard Element Test',indStatus__c='Active',sIndCode__c='',sIndName__c=''));
   uIndicators.add(new USAID_Indicator__c(Program_Objective__c='3',Source__c='FTF',prCode__c='3.1.1',prName__c='Element 1',indCode__c='3.1.1-1',indName__c='Standard element Test',indStatus__c='Active',sIndCode__c='3.1.1-1a',sIndName__c='Standard Element Sub Indicator'));
   
   uIndicators.add(new USAID_Indicator__c(Program_Objective__c='3',Source__c='FTF',prCode__c='3.1.1.1',prName__c='Sub Element 1',indCode__c='3.1.1.1-1',indName__c='Standard Sub Element Test',indStatus__c='Active',sIndCode__c='',sIndName__c=''));
   uIndicators.add(new USAID_Indicator__c(Program_Objective__c='3',Source__c='FTF',prCode__c='3.1.1.1',prName__c='Sub Element 1',indCode__c='3.1.1.1-1',indName__c='Standard sub element Test',indStatus__c='Active',sIndCode__c='3.1.1.1-1a',sIndName__c='Standard Sub Element Sub Indicator'));
   
   uIndicators.add(new USAID_Indicator__c(Source__c='PEPFAR',Program_Objective__c='C', prCode__c='C1',prName__c='PEPFAR Test',indCode__c='C1.1.D',indName__c='PEPFAR Indicator',indStatus__c='Active',sIndCode__c='',sIndName__c=''));
   uIndicators.add(new USAID_Indicator__c(Source__c='PEPFAR',Program_Objective__c='C',prCode__c='C1',prName__c='PEPFAR Test',indCode__c='C1.1.D',indName__c='PEPFAR Indicator',indStatus__c='Active',sIndCode__c='C1.1.D-a',sIndName__c='PEPFAR Sub Indicator'));
   
   
   
    insert uIndicators;
     System.Debug('getUSAIDIndicatorRecords*** ' + uIndicators);
   return uIndicators;
 } 
 
 @TestVisible private List<OrgUnit_Indicator__c> getIndicatorsForOrgId(String OrgId, List<USAID_Indicator__c> uIndicators) { 
   String masterRecType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'Master');
   List<OrgUnit_Indicator__c> indicatorsList = new List<OrgUnit_Indicator__c>();
   for(USAID_Indicator__c uInd: uIndicators ){
       indicatorsList.add(new OrgUnit_Indicator__c(ouId__c=OrgId,USAID_Indicator_Id__c=uInd.Id,prCode__c=uInd.prCode__c,prName__c=uInd.prName__c,RecordTypeId=masterRecType,source__c=uInd.Source__c,indcode__c= uInd.indCode__c,indName__c= uInd.indName__c,sindcode__c= uInd.sIndCode__c,sindName__c= uInd.sIndName__c));
   }

   
    insert indicatorsList;
     System.Debug('getIndicatorForOrgId*** ' + indicatorsList);
   return indicatorsList;
 } 
 
 
 
 
 @TestVisible private List<OrgUnit_Indicator__c> getCustomIndicatorRecordsForOrgId(String OrgId) { 
   String masterRecType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'Master');
   List<OrgUnit_Indicator__c> cindicatorsList = new List<OrgUnit_Indicator__c>();
   cindicatorsList.add(new OrgUnit_Indicator__c(Custom__c=true,prCode__c='1',prName__c='Peach and Security',ouId__c=OrgId,source__c='STANDARD',RecordTypeId=masterRecType,indcode__c= '1-Z1',indName__c= 'Master',sindcode__c= '',sindName__c= ''));
   cindicatorsList.add(new OrgUnit_Indicator__c(Custom__c=true,prCode__c='1',prName__c='Peach and Security',ouId__c=OrgId,source__c='STANDARD',RecordTypeId=masterRecType,indcode__c= '1-Z1',indName__c= 'Master',sindcode__c= '1-Z12',sindName__c= 'SubMaster'));
   
 
     insert cindicatorsList;
     return cindicatorsList;
 }
// Private method getIMForOrgIdindName
@TestVisible private String getCustomIndicatorForOrgId(String OrgId) { 
   String masterRecType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'Master'); 
   OrgUnit_Indicator__c testOrgUnitIndicator = new OrgUnit_Indicator__c(ouId__c=OrgId,source__c='STANDARD',RecordTypeId=masterRecType,indcode__c= '1-Z1',indName__c= 'Master',sindcode__c= '1-Z12',sindName__c= 'SubMaster');
    insert testOrgUnitIndicator ;
     System.Debug('getCustomIndicatorForOrgId*** ' + testOrgUnitIndicator);
   return testOrgUnitIndicator.Id;
 }
 
// Private method getIMForOrgId
@TestVisible private OrgUnit_Indicator__c getCustomIndicatorForType(String OrgId,String typeId,String typeName, String masterId) { 
    String recType;
   OrgUnit_Indicator__c testOrgUnitIndicator ;
   if(typeName =='RFGoal'){
     recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'RF Goal');  
     testOrgUnitIndicator = new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c='STANDARD',indcode__c='1-Z1',indName__c= 'TESTRF',Goal_Id__c =typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF',Organization_Indicator_Id__c=masterID);
   } else if(typeName =='RFDO') {
     recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'RF DO');  
     testOrgUnitIndicator = new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c='STANDARD',indcode__c='1-Z1',indName__c= 'TESTRF',DO_Id__c=typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF',Organization_Indicator_Id__c=masterID);  
   }  else if(typeName =='RFIR') {
     recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'RF IR');  
     testOrgUnitIndicator = new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c='STANDARD',indcode__c='1-Z1',indName__c= 'TESTRF',IR_Id__c=typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF',Organization_Indicator_Id__c=masterID);  
   }  else if(typeName =='RFSIR') {
     recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'RF SUB IR');  
     testOrgUnitIndicator = new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c='STANDARD',indcode__c='1-Z1',indName__c= 'TESTRF',SIR_Id__c=typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF',Organization_Indicator_Id__c=masterID);    
   } else if(typeName =='LFGoal') {
     recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'LF Goal');  
     testOrgUnitIndicator = new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c='STANDARD',indcode__c='1-Z1',indName__c= 'TESTLF',LF_Goal_Id__c =typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF',Organization_Indicator_Id__c=masterID);
   } else if(typeName =='LFPurpose') {
     recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'LF Purpose');  
     testOrgUnitIndicator = new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c='STANDARD',indcode__c='1-Z1',indName__c= 'TESTLF',LF_Purpose_Id__c=typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF',Organization_Indicator_Id__c=masterID);  
   } else if(typeName =='LFSubPurpose') {
     recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'LF Sub-Purpose');  
     testOrgUnitIndicator = new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c='STANDARD',indcode__c='1-Z1',indName__c= 'TESTLF',LF_SubPurpose_Id__c=typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF',Organization_Indicator_Id__c=masterID);  
   } else if(typeName =='LFOutput') {
     recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'LF Output');  
     testOrgUnitIndicator = new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c='STANDARD',indcode__c='1-Z1',indName__c= 'TESTLF',LF_Output_Id__c=typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF',Organization_Indicator_Id__c=masterID);   
   } else if(typeName =='LFInput') {
     recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'LF Input');  
     testOrgUnitIndicator = new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c='STANDARD',indcode__c='1-Z1',indName__c= 'TESTLF',LF_Input_Id__c=typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF',Organization_Indicator_Id__c=masterID);           
   } else if(typeName =='IM'){
     recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'Implementing Mechanism');
     testOrgUnitIndicator = new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c='STANDARD',indcode__c='1-Z1',indName__c= 'TESTLF',Implementing_Mechanism_Id__c =typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF',Organization_Indicator_Id__c=masterID);    
   }  
    insert testOrgUnitIndicator ;
     System.Debug('getCustomIndicatorForType*** ' + testOrgUnitIndicator); 
     return testOrgUnitIndicator;
 }


@TestVisible private List<OrgUnit_Indicator__c> getCustomIndicatorsForType(String OrgId,String typeId,String typeName, List<OrgUnit_Indicator__c> masterList) { 
    String recType;
   List<OrgUnit_Indicator__c> testOrgUnitIndicator  = new List<OrgUnit_Indicator__c>();
   for(OrgUnit_Indicator__c oMaster: masterList){
       if(typeName =='RFGoal'){
         recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'RF Goal');  
         testOrgUnitIndicator.add(new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c=omaster.source__c,indcode__c=oMaster.indCode__c,indName__c= oMaster.indName__c,Goal_Id__c =typeId,sindcode__c= oMaster.sindCode__c,sindName__c= oMaster.sindName__c,Organization_Indicator_Id__c=oMaster.Id));
       } else if(typeName =='RFDO') {
         recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'RF DO');  
         testOrgUnitIndicator.add(new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c=omaster.source__c,indcode__c=oMaster.indCode__c,indName__c= oMaster.indName__c,DO_Id__c=typeId,sindcode__c= oMaster.sindCode__c,sindName__c= oMaster.sindName__c,Organization_Indicator_Id__c=oMaster.Id));  
       }  else if(typeName =='RFIR') {
         recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'RF IR');  
         testOrgUnitIndicator.add(new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c=omaster.source__c,indcode__c=oMaster.indCode__c,indName__c= oMaster.indName__c,IR_Id__c=typeId,sindcode__c= oMaster.sindCode__c,sindName__c= oMaster.sindName__c,Organization_Indicator_Id__c=oMaster.Id));  
       }  else if(typeName =='RFSIR') {
         recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'RF SUB IR');  
         testOrgUnitIndicator.add(new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c=omaster.source__c,indcode__c=oMaster.indCode__c,indName__c= oMaster.indName__c,SIR_Id__c=typeId,sindcode__c= oMaster.sindCode__c,sindName__c= oMaster.sindName__c,Organization_Indicator_Id__c=oMaster.Id));    
       } else if(typeName =='LFGoal') {
         recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'LF Goal');  
         testOrgUnitIndicator.add(new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c=omaster.source__c,indcode__c=oMaster.indCode__c,indName__c= oMaster.indName__c,LF_Goal_Id__c =typeId,sindcode__c= oMaster.sindCode__c,sindName__c= oMaster.sindName__c,Organization_Indicator_Id__c=oMaster.Id));
       } else if(typeName =='LFPurpose') {
         recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'LF Purpose');  
         testOrgUnitIndicator.add(new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c=omaster.source__c,indcode__c=oMaster.indCode__c,indName__c= oMaster.indName__c,LF_Purpose_Id__c=typeId,sindcode__c= oMaster.sindCode__c,sindName__c= oMaster.sindName__c,Organization_Indicator_Id__c=oMaster.Id));  
       } else if(typeName =='LFSubPurpose') {
         recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'LF Sub-Purpose');  
         testOrgUnitIndicator.add(new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c=omaster.source__c,indcode__c=oMaster.indCode__c,indName__c= oMaster.indName__c,LF_SubPurpose_Id__c=typeId,sindcode__c= oMaster.sindCode__c,sindName__c= oMaster.sindName__c,Organization_Indicator_Id__c=oMaster.Id));  
       } else if(typeName =='LFOutput') {
         recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'LF Output');  
         testOrgUnitIndicator.add(new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c=omaster.source__c,indcode__c=oMaster.indCode__c,indName__c= oMaster.indName__c,LF_Output_Id__c=typeId,sindcode__c= oMaster.sindCode__c,sindName__c= oMaster.sindName__c,Organization_Indicator_Id__c=oMaster.Id));   
       } else if(typeName =='LFInput') {
         recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'LF Input');  
         testOrgUnitIndicator.add(new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c=omaster.source__c,indcode__c=oMaster.indCode__c,indName__c= oMaster.indName__c,LF_Input_Id__c=typeId,sindcode__c= oMaster.sindCode__c,sindName__c= oMaster.sindName__c,Organization_Indicator_Id__c=oMaster.Id));           
       } else if(typeName =='IM'){
         recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'Implementing Mechanism');
         testOrgUnitIndicator.add(new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c=omaster.source__c,indcode__c=oMaster.indCode__c,indName__c= oMaster.indName__c,Implementing_Mechanism_Id__c =typeId,sindcode__c= oMaster.sindCode__c,sindName__c= oMaster.sindName__c,Organization_Indicator_Id__c=oMaster.Id,Collection_Frequency__c='Quarterly'));
         testOrgUnitIndicator.add(new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c=omaster.source__c,indcode__c=oMaster.indCode__c,indName__c= oMaster.indName__c,Implementing_Mechanism_Id__c =typeId,sindcode__c= oMaster.sindCode__c,sindName__c= oMaster.sindName__c,Organization_Indicator_Id__c=oMaster.Id,Collection_Frequency__c='Semi-Annual'));    
         testOrgUnitIndicator.add(new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c=omaster.source__c,indcode__c=oMaster.indCode__c,indName__c= oMaster.indName__c,Implementing_Mechanism_Id__c =typeId,sindcode__c= oMaster.sindCode__c,sindName__c= oMaster.sindName__c,Organization_Indicator_Id__c=oMaster.Id,Collection_Frequency__c='Annual'));
       }
    }     
    insert testOrgUnitIndicator ;
     System.Debug('getCustomIndicatorForType*** ' + testOrgUnitIndicator); 
     return testOrgUnitIndicator;
 }

 
// Private method getIMForOrgId
@TestVisible private OrgUnit_Indicator__c getCustomIndicatorForType(String OrgId,String typeId,String typeName) { 
    String recType;
   OrgUnit_Indicator__c testOrgUnitIndicator ;
   if(typeName =='RFGoal'){
     recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'RF Goal');  
     testOrgUnitIndicator = new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c='STANDARD',indcode__c='1-Z1',indName__c= 'TESTRF',Goal_Id__c =typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF');
   } else if(typeName =='RFDO') {
     recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'RF DO');  
     testOrgUnitIndicator = new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c='STANDARD',indcode__c='1-Z1',indName__c= 'TESTRF',DO_Id__c=typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF');  
   }  else if(typeName =='RFIR') {
     recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'RF IR');  
     testOrgUnitIndicator = new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c='STANDARD',indcode__c='1-Z1',indName__c= 'TESTRF',IR_Id__c=typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF');  
   }  else if(typeName =='RFSIR') {
     recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'RF SUB IR');  
     testOrgUnitIndicator = new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c='STANDARD',indcode__c='1-Z1',indName__c= 'TESTRF',SIR_Id__c=typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF');    
   } else if(typeName =='LFGoal') {
     recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'LF Goal');  
     testOrgUnitIndicator = new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c='STANDARD',indcode__c='1-Z1',indName__c= 'TESTLF',LF_Goal_Id__c =typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF');
   } else if(typeName =='LFPurpose') {
     recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'LF Purpose');  
     testOrgUnitIndicator = new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c='STANDARD',indcode__c='1-Z1',indName__c= 'TESTLF',LF_Purpose_Id__c=typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF');  
   } else if(typeName =='LFSubPurpose') {
     recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'LF Sub-Purpose');  
     testOrgUnitIndicator = new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c='STANDARD',indcode__c='1-Z1',indName__c= 'TESTLF',LF_SubPurpose_Id__c=typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF');  
   } else if(typeName =='LFOutput') {
     recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'LF Output');  
     testOrgUnitIndicator = new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c='STANDARD',indcode__c='1-Z1',indName__c= 'TESTLF',LF_Output_Id__c=typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF');   
   } else if(typeName =='LFInput') {
     recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'LF Input');  
     testOrgUnitIndicator = new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c='STANDARD',indcode__c='1-Z1',indName__c= 'TESTLF',LF_Input_Id__c=typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF');           
   } else if(typeName =='IM'){
     recType = GU.getRecordTypeId('OrgUnit_Indicator__c', 'Implementing Mechanism');
     testOrgUnitIndicator = new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c='STANDARD',indcode__c='1-Z1',indName__c= 'TESTLF',Implementing_Mechanism_Id__c =typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF',Collection_Frequency__c='Quarterly');    
     testOrgUnitIndicator = new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c='STANDARD',indcode__c='1-Z1',indName__c= 'TESTLF',Implementing_Mechanism_Id__c =typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF',Collection_Frequency__c='Semi-Annual');    
     testOrgUnitIndicator = new OrgUnit_Indicator__c(RecordTypeId=recType,ouId__c=OrgId, source__c='STANDARD',indcode__c='1-Z1',indName__c= 'TESTLF',Implementing_Mechanism_Id__c =typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF',Collection_Frequency__c='Annual');    
   }  
    insert testOrgUnitIndicator ;
     System.Debug('getCustomIndicatorForType*** ' + testOrgUnitIndicator); 
     return testOrgUnitIndicator;
 }
 
 
 // Private method getIMForOrgId
@TestVisible private OrgUnit_Indicator__c getCustIndicatorForRecordType(String OrgId,String typeId,String typeName,String recTypeId) { 
   OrgUnit_Indicator__c testOrgUnitIndicator ;
   if(typeName =='RFGoal')
     testOrgUnitIndicator = new OrgUnit_Indicator__c(ouId__c=OrgId, source__c='STANDARD',RecordTypeId =recTypeId, indcode__c='1-Z1',indName__c= 'TESTRF',Goal_Id__c =typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF');
   if(typeName =='LFGoal')
     testOrgUnitIndicator = new OrgUnit_Indicator__c(ouId__c=OrgId, source__c='STANDARD',RecordTypeId =recTypeId,indcode__c='1-Z1',indName__c= 'TESTLF',LF_Goal_Id__c =typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF');  
   if(typeName =='IM')
     testOrgUnitIndicator = new OrgUnit_Indicator__c(ouId__c=OrgId, source__c='STANDARD',RecordTypeId =recTypeId,indcode__c='1-Z1',indName__c= 'TESTLF',Implementing_Mechanism_Id__c =typeId,sindcode__c= '1-Z12',sindName__c= 'SubRF',Collection_Frequency__c='Quarterly');    
    insert testOrgUnitIndicator ;
     System.Debug('getCustomIndicatorForType*** ' + testOrgUnitIndicator); 
     return testOrgUnitIndicator;
 }
 
 
 
 // Private method getIMForOrgIdindName
@TestVisible private String getLFIndicatorResultByLFGoal(String rpId, String masterId, String childId, String goalId) { 
   String lfGoalRecType = GU.getRecordTypeId('LF_Indicator_Result__c', 'LF Goal');
   LF_Indicator_Result__c testLFIndResult = new LF_Indicator_Result__c(RecordTypeId=lfGoalRecType,LF_Reporting_Period_Id__c=rpId,Organization_Indicator_Master_Id__c=masterId,Organization_Indicator_Id__c= childId,LF_Goal_Id__c= goalId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00);
    insert testLFIndResult;
     System.Debug('getLFIndicatorResultByLFGoal*** ' + testLFIndResult);
   return testLFIndResult.Id;
 }
 
 @TestVisible private LF_Indicator_Result__c getLFIndicatorResultRecordByLFGoal(String rpId, String masterId, String childId, String goalId) { 
   String lfGoalRecType = GU.getRecordTypeId('LF_Indicator_Result__c', 'LF Goal');
   LF_Indicator_Result__c testLFIndResult = new LF_Indicator_Result__c(RecordTypeId=lfGoalRecType,LF_Reporting_Period_Id__c=rpId,Organization_Indicator_Master_Id__c=masterId,Organization_Indicator_Id__c= childId,LF_Goal_Id__c= goalId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00);
    insert testLFIndResult;
     System.Debug('getLFIndicatorResultByLFGoal*** ' + testLFIndResult);
   return testLFIndResult;
 }
 @TestVisible private RF_Indicator_Result__c getRFIndicatorResultRecordByRFGoal(String rpId, String masterId, String childId, String goalId) { 
   String rfGoalRecType = GU.getRecordTypeId('RF_Indicator_Result__c', 'RF Goal');
   RF_Indicator_Result__c testRFIndResult = new RF_Indicator_Result__c(RecordTypeId=rfGoalRecType,RF_Reporting_Period_Id__c=rpId,Organization_Indicator_Master_Id__c=masterId,Organization_Indicator_Id__c= childId,CDCS_Goals__c= goalId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00);
    insert testRFIndResult;
     System.Debug('getRFIndicatorResultByRFGoal*** ' + testRFIndResult);
   return testRFIndResult;
 }
 
 @TestVisible private String getRFIndicatorResultByRFGoal(String rpId, String masterId, String childId, String goalId) { 
   String rfGoalRecType = GU.getRecordTypeId('RF_Indicator_Result__c', 'RF Goal');
   RF_Indicator_Result__c testRFIndResult = new RF_Indicator_Result__c(RecordTypeId=rfGoalRecType,RF_Reporting_Period_Id__c=rpId,Organization_Indicator_Master_Id__c=masterId,Organization_Indicator_Id__c= childId,CDCS_Goals__c= goalId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00);
    insert testRFIndResult;
     System.Debug('getRFIndicatorResultByRFGoal*** ' + testRFIndResult);
   return testRFIndResult.Id;
 }
 
 @TestVisible private RF_Indicator_Result__c getRFIndicatorResultByRFElement(String rpId, String masterId, String childId, String elementId, String type) {
  String recType;
  RF_Indicator_Result__c testRFIndResult;
  if(type.equalsIgnoreCase('Goal')){
      recType =   GU.getRecordTypeId('RF_Indicator_Result__c', 'RF Goal');  
      testRFIndResult = new RF_Indicator_Result__c(RecordTypeId=recType,RF_Reporting_Period_Id__c=rpId,Organization_Indicator_Master_Id__c=masterId,Organization_Indicator_Id__c= childId,CDCS_Goals__c= elementId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00);
  } else if(type.equalsIgnoreCase('Do')){
      recType =   GU.getRecordTypeId('RF_Indicator_Result__c', 'RF DO');
      testRFIndResult = new RF_Indicator_Result__c(RecordTypeId=recType,RF_Reporting_Period_Id__c=rpId,Organization_Indicator_Master_Id__c=masterId,Organization_Indicator_Id__c= childId,DO_Id__c= elementId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00);    
  } else if(type.equalsIgnoreCase('Ir')){
      recType =   GU.getRecordTypeId('RF_Indicator_Result__c', 'RF IR');
      testRFIndResult = new RF_Indicator_Result__c(RecordTypeId=recType,RF_Reporting_Period_Id__c=rpId,Organization_Indicator_Master_Id__c=masterId,Organization_Indicator_Id__c= childId,IR_Id__c= elementId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00);
  } else if(type.equalsIgnoreCase('SIR')){
      recType =   GU.getRecordTypeId('RF_Indicator_Result__c', 'RF SUB IR');
      testRFIndResult = new RF_Indicator_Result__c(RecordTypeId=recType,RF_Reporting_Period_Id__c=rpId,Organization_Indicator_Master_Id__c=masterId,Organization_Indicator_Id__c= childId,Sub_IR_Id__c= elementId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00);
  }
  
  insert testRFIndResult;
  return testRFIndResult;
 }
 
 
 @TestVisible private List<RF_Indicator_Result__c> getRFIndicatorResultByRFElement(List<RF_Reporting_Period__c> rpList, List<OrgUnit_Indicator__c> childList, String elementId, String type) {
  String recType;
  List<RF_Indicator_Result__c> testRFIndResult = new List<RF_Indicator_Result__c>();
  for(RF_Reporting_Period__c rPeriod: rpList){
      for(OrgUnit_Indicator__c oChild: childList){
          if(type.equalsIgnoreCase('Goal')){
              recType =   GU.getRecordTypeId('RF_Indicator_Result__c', 'RF Goal');  
              testRFIndResult.add(new RF_Indicator_Result__c(RecordTypeId=recType,RF_Reporting_Period_Id__c=rPeriod.Id,Organization_Indicator_Master_Id__c=oChild.Organization_Indicator_Id__c,Organization_Indicator_Id__c= oChild.Id,CDCS_Goals__c= elementId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00));
          } else if(type.equalsIgnoreCase('Do')){
              recType =   GU.getRecordTypeId('RF_Indicator_Result__c', 'RF DO');
              testRFIndResult.add(new RF_Indicator_Result__c(RecordTypeId=recType,RF_Reporting_Period_Id__c=rPeriod.Id,Organization_Indicator_Master_Id__c=oChild.Organization_Indicator_Id__c,Organization_Indicator_Id__c= oChild.Id,DO_Id__c= elementId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00));    
          } else if(type.equalsIgnoreCase('Ir')){
              recType =   GU.getRecordTypeId('RF_Indicator_Result__c', 'RF IR');
              testRFIndResult.add(new RF_Indicator_Result__c(RecordTypeId=recType,RF_Reporting_Period_Id__c=rPeriod.Id,Organization_Indicator_Master_Id__c=oChild.Organization_Indicator_Id__c,Organization_Indicator_Id__c= oChild.Id,IR_Id__c= elementId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00));
          } else if(type.equalsIgnoreCase('SIR')){
              recType =   GU.getRecordTypeId('RF_Indicator_Result__c', 'RF SUB IR');
              testRFIndResult.add(new RF_Indicator_Result__c(RecordTypeId=recType,RF_Reporting_Period_Id__c=rPeriod.Id,Organization_Indicator_Master_Id__c=oChild.Organization_Indicator_Id__c,Organization_Indicator_Id__c= oChild.Id,Sub_IR_Id__c= elementId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00));
          }
      }
  }
  
  insert testRFIndResult;
  return testRFIndResult;
 }
 
 
 
 
 @TestVisible private List<LF_Indicator_Result__c> getLFIndicatorResultByLFElement(List<LF_Reporting_Period__c> rpList, List<OrgUnit_Indicator__c> childList, String elementId, String type) {
  String recType;
  List<LF_Indicator_Result__c> testLFIndResult = new List<LF_Indicator_Result__c>();
  for(LF_Reporting_Period__c lPeriod: rpList){
      for(OrgUnit_Indicator__c oChild: childList){
        if(type.equalsIgnoreCase('Goal')){
          recType =   GU.getRecordTypeId('LF_Indicator_Result__c', 'LF Goal');  
          testLFIndResult.add(new LF_Indicator_Result__c(RecordTypeId=recType,LF_Reporting_Period_Id__c=lPeriod.Id,Organization_Indicator_Master_Id__c=oChild.Organization_Indicator_Id__c,Organization_Indicator_Id__c= oChild.Id,LF_Goal_Id__c= elementId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00));
        } else if(type.equalsIgnoreCase('Purpose')){
          recType =   GU.getRecordTypeId('LF_Indicator_Result__c', 'LF Purpose');
          testLFIndResult.add(new LF_Indicator_Result__c(RecordTypeId=recType,LF_Reporting_Period_Id__c=lPeriod.Id,Organization_Indicator_Master_Id__c=oChild.Organization_Indicator_Id__c,Organization_Indicator_Id__c= oChild.Id,LF_Purpose_Id__c= elementId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00));    
        } else if(type.equalsIgnoreCase('SubPurpose')){
          recType =   GU.getRecordTypeId('LF_Indicator_Result__c', 'LF Sub-Purpose');
          testLFIndResult.add(new LF_Indicator_Result__c(RecordTypeId=recType,LF_Reporting_Period_Id__c=lPeriod.Id,Organization_Indicator_Master_Id__c=oChild.Organization_Indicator_Id__c,Organization_Indicator_Id__c= oChild.Id,LF_SubPurpose_Id__c= elementId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00));
        } else if(type.equalsIgnoreCase('Output')){
          recType =   GU.getRecordTypeId('LF_Indicator_Result__c', 'LF Output');
          testLFIndResult.add(new LF_Indicator_Result__c(RecordTypeId=recType,LF_Reporting_Period_Id__c=lPeriod.Id,Organization_Indicator_Master_Id__c=oChild.Organization_Indicator_Id__c,Organization_Indicator_Id__c= oChild.Id,LF_Output__c= elementId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00));
        } else if(type.equalsIgnoreCase('Input')){
          recType =   GU.getRecordTypeId('LF_Indicator_Result__c', 'LF Input');
          testLFIndResult.add(new LF_Indicator_Result__c(RecordTypeId=recType,LF_Reporting_Period_Id__c=lPeriod.Id,Organization_Indicator_Master_Id__c=oChild.Organization_Indicator_Id__c,Organization_Indicator_Id__c= oChild.Id,LF_Input__c= elementId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00));
        }
      }
   }    
  insert testLFIndResult ;
  return testLFIndResult ;
 }
 
 
 
 
 
 @TestVisible private LF_Indicator_Result__c getLFIndicatorResultByLFElement(String rpId, String masterId, String childId, String elementId, String type) {
  String recType;
  LF_Indicator_Result__c testLFIndResult;
  if(type.equalsIgnoreCase('Goal')){
      recType =   GU.getRecordTypeId('LF_Indicator_Result__c', 'LF Goal');  
      testLFIndResult = new LF_Indicator_Result__c(RecordTypeId=recType,LF_Reporting_Period_Id__c=rpId,Organization_Indicator_Master_Id__c=masterId,Organization_Indicator_Id__c= childId,LF_Goal_Id__c= elementId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00);
  } else if(type.equalsIgnoreCase('Purpose')){
      recType =   GU.getRecordTypeId('LF_Indicator_Result__c', 'LF Purpose');
      testLFIndResult = new LF_Indicator_Result__c(RecordTypeId=recType,LF_Reporting_Period_Id__c=rpId,Organization_Indicator_Master_Id__c=masterId,Organization_Indicator_Id__c= childId,LF_Purpose_Id__c= elementId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00);    
  } else if(type.equalsIgnoreCase('SubPurpose')){
      recType =   GU.getRecordTypeId('LF_Indicator_Result__c', 'LF Sub-Purpose');
      testLFIndResult = new LF_Indicator_Result__c(RecordTypeId=recType,LF_Reporting_Period_Id__c=rpId,Organization_Indicator_Master_Id__c=masterId,Organization_Indicator_Id__c= childId,LF_SubPurpose_Id__c= elementId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00);
  } else if(type.equalsIgnoreCase('Output')){
      recType =   GU.getRecordTypeId('LF_Indicator_Result__c', 'LF Output');
      testLFIndResult = new LF_Indicator_Result__c(RecordTypeId=recType,LF_Reporting_Period_Id__c=rpId,Organization_Indicator_Master_Id__c=masterId,Organization_Indicator_Id__c= childId,LF_Output__c= elementId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00);
  } else if(type.equalsIgnoreCase('Input')){
      recType =   GU.getRecordTypeId('LF_Indicator_Result__c', 'LF Input');
      testLFIndResult = new LF_Indicator_Result__c(RecordTypeId=recType,LF_Reporting_Period_Id__c=rpId,Organization_Indicator_Master_Id__c=masterId,Organization_Indicator_Id__c= childId,LF_Input__c= elementId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00);
  }
  
  insert testLFIndResult ;
  return testLFIndResult ;
 }
 // Private method getIMForOrgIdindName
@TestVisible private List<Indicator_Results__c> getIndicatorResultByIM(List<Reporting_Period__c> rpList, String masterId, String childId, String imId) { 
   List<Indicator_Results__c> irList  = new List<Indicator_Results__c>();
   String recType =   GU.getRecordTypeId('Indicator_Results__c', 'Implementing Mechanism');
   for (Reporting_Period__c rp: rpList){
       irList.add(new Indicator_Results__c(RecordTypeId=recType,Reporting_Period_Id__c=rp.Id,Organization_Indicator_Master_Id__c=masterId,Organization_Indicator_Id__c= childId,Implementing_MEchanism_Id__c= imId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00));    
   }
   
    insert irList;
     System.Debug('getIndicatorResultByIM*** ' + irList);
   return irList;
 }
 
 
 @TestVisible private List<Indicator_Results__c> getIndicatorResultByIM(List<Reporting_Period__c> rpList, List<OrgUnit_Indicator__c> childList, String imId) { 
   List<Indicator_Results__c> irList  = new List<Indicator_Results__c>();
   String recType =   GU.getRecordTypeId('Indicator_Results__c', 'Implementing Mechanism');
   for (Reporting_Period__c rp: rpList){
       for (OrgUnit_Indicator__c ci: childList){
           irList.add(new Indicator_Results__c(RecordTypeId=recType,Reporting_Period_Id__c=rp.Id,Organization_Indicator_Master_Id__c=ci.Organization_Indicator_Id__c,Organization_Indicator_Id__c= ci.Id,Implementing_MEchanism_Id__c= imId, Baseline__c=100.00,target__c=200.00,Actual__c=300.00));
       }        
   }
   
    insert irList;
     System.Debug('getIndicatorResultByIM*** ' + irList);
   return irList;
 }
 
  // Private method Test ClsIndicatorSetupController for Id and IndName
@TestVisible private void testClsIndicatorSetupController(String pId,String pIndicatorName, List<OrgUnit_Indicator__c> existinList,String OrgInd,List<OrgUnit_Indicator__c> oIndList) {

       
            ClsIndicatorSetupController controller = new ClsIndicatorSetupController();
             controller.aId= pId;             
             System.assertNotEquals(pId,null);       
             System.Debug('AID ***  ' + pId);  
            
             controller.getAllInfoForId();
              if(existinList != null)
             controller.OrgRecTypeIndicatorList=existinList;
             List<OrgUnit_Indicator__c> orgInds = new List<OrgUnit_Indicator__c>();
               controller.setOrgList(oIndList);
               
             controller.getSetupInforOrgIndicator();
             set<string> sources = controller.getSourceNameList();
             set<string> indicators = controller.getIndIdList(oIndList);
             controller.getSubIndMap(oIndList);
             controller.getSourceParentSubIndMap(oIndList);
            // controller.getmainnodes();        
             controller.updateMasterNParent();
             controller.recordTypeName ='TEST';
             OrgUnit_Indicator__c  orgUnitInd =(OrgUnit_Indicator__c) GU.lookup(OrgInd,'OrgUnit_Indicator__c');
             controller.checkRecordIDExist(orgUnitInd );
             controller.selectedSourceIndicators=pIndicatorName;      
             controller.selectedSourceIndicators='1-Z12,1-Z1';
             controller.doSaveIndicatorForRecordType();            
             controller.cancel();
             controller.CancelNGo();              
           
}  

 @IsTest public static void testClsUserProfileFinder() {        
     ClsUserProfileFinder controller = new ClsUserProfileFinder();          
     controller.getIsPartnerUser();     
     controller.getIsPLTUser();     
     controller.getIsSTDUser();     
     controller.getIsADMINUser();     
     controller.getIsPLTMissionUser();     
     controller.getIsPLTReadOnlyUser();     
     controller.getIsPLTUserOnly();     
     controller.getIsSTDAidtrackSupportUser();     
     controller.getIsSTDAidtrackSupReadOnlyUser();     
     controller.getIsSTDEditOnlyCustomUser();     
     controller.getIsSTDEditOnlyCustomTaskUser();     
     controller.getIsSTDMissionProfileUser();     
     controller.getIsSTDReadOnlyUser();     
     controller.getIsMissionPartnerUser();      
  }  
  
  // Private method Test ClsIndicatorSetupController for Id and IndName
@TestVisible private void testClsIndicatorSetupControllerIM(String pId,String pIndicatorName, List<OrgUnit_Indicator__c> existinList,String OrgInd,List<OrgUnit_Indicator__c> oIndList) {

            //system.test.setCurrentPage(new PageReference('/apex/vfIMIndicatorPage'));
            ApexPages.currentPage().getParameters().put('id', pId);  
            ClsIndicatorSetupControllerIM controller = new ClsIndicatorSetupControllerIM();
             controller.aId= pId;             
             System.assertNotEquals(pId,null);       
             System.Debug('AID ***  ' + pId);  
            
             controller.getAllInfoForId();
              if(existinList != null)
             controller.OrgRecTypeIndicatorList=existinList;
             List<OrgUnit_Indicator__c> orgInds = new List<OrgUnit_Indicator__c>();
             controller.setOrgList(oIndList);
             controller.getSetupInforOrgIndicator();
               set<string> sources = controller.getSourceNameList();
             set<string> indicators = controller.getIndIdList(oIndList);
             controller.getSubIndMap(oIndList);
             controller.getSourceParentSubIndMap(oIndList);
            // controller.getmainnodes();        
             //controller.updateMasterNParent();
             controller.recordTypeName ='TEST';
             OrgUnit_Indicator__c  orgUnitInd =(OrgUnit_Indicator__c) GU.lookup(OrgInd,'OrgUnit_Indicator__c');
             controller.checkRecordIDExist(orgUnitInd );
             controller.selectedSourceIndicators=pIndicatorName;      
             controller.selectedSourceIndicators='1.1-1:::1,1.1-1a:::1,1-Z1:::2,1-Z:::3';
             controller.doSaveIndicatorForRecordType();  
             controller.updateMasterNParent();          
             controller.cancel();
             controller.CancelNGo();              
           
}  

}