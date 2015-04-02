@isTest     
public class testClsObjectLookupController {
    public static testmethod void testMethodClsObjectLookupController(){
        Pagereference pRef = Page.vfObjectLookup;
        Test.setCurrentPageReference(pRef);
        
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
        q2.SobjectType = 'Implementing_Mechanism__c';
        qList.add(q2);
        
        QueueSobject q3 = new QueueSobject();
        q3.QueueId = grp1.Id;
        q3.SobjectType = 'CDCSGoal__c';
        qList.add(q3);
        
        QueueSobject q4 = new QueueSobject();
        q4.QueueId = grp1.Id;
        q4.SobjectType = 'Activity__c';
        qList.add(q4);
        
        QueueSobject q5 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'CDCSLINK__c');
        qList.add(q5);
                
        System.runAs(thisUSer){
        insert qList; }
        
        Profile missionUserProf = [SELECT Id FROM Profile WHERE Name= 'STD - Mission Profile'];
        Profile partnerUserProf = [SELECT Id FROM Profile WHERE Name= 'Mission Partner'];
        UserRole uRole = new UserRole(Name='OUCODE | OUNAME');
        System.runAs(thisUSer){ 
            insert uRole;
        }
        Account ac=new Account(Name='African Business Network1');
        
        System.runAs(thisUSer){ 
            insert ac;
        }
        
        Contact cont=new Contact(LastName = 'Testing',AccountId = ac.Id);
        System.runAs(thisUSer){ 
            insert cont;
        }
        
        User missionUser  = new User(Alias = 'standt', 
                                    Email='standarduser1@testorg.com', 
                                    isActive=true,       
                                    EmailEncodingKey='UTF-8', 
                                    LastName='Testing1', 
                                    LanguageLocaleKey='en_US',
                                    Title='Mission User Title',        
                                    LocaleSidKey='en_US', 
                                    ProfileId = missionUserProf.Id,  
                                    UserRoleId =  uRole.Id,      
                                    TimeZoneSidKey='America/Los_Angeles', 
                                    UserName='standarduserr1@testorg.com');
                                    
        User partnerUser  = new User(Alias = 'PUser',  
                                    Email='partneruser1@testorg.com', 
                                    isActive=true,       
                                    EmailEncodingKey='UTF-8', 
                                    LastName='Testing1',
                                    Title='Portal User Title', 
                                    LanguageLocaleKey='en_US',        
                                    LocaleSidKey='en_US', 
                                    ProfileId = partnerUserProf.Id,        
                                    TimeZoneSidKey='America/Los_Angeles', 
                                    UserName='partneruser1@testorg.com',
                                    ContactId = cont.Id);   
        System.runAs(thisUSer){ 
            insert missionUser;
            insert partnerUser;
        }   
        
        GroupMember gm = new GroupMember(UserOrGroupId=missionUser.Id,  GroupId=grp.Id);
        System.runAs(thisUSer){ 
            insert gm;          
        }
        
        
        Bureau__c bu = new Bureau__c(burCode__c = 'BUR', burName__c = 'BUR Name', Name = 'BUR Name'); 
        Insert bu;
        OrgUnit__c ou = new OrgUnit__c(ouCode__c = 'OUCODE', ouName__c = 'OUNAME',Name = 'OUNAME', ouDisplayName__c = 'OU DISPNAME',burId__c = bu.id );    
        Insert ou;
        
        Sector__c sec = new Sector__c(Name = 'SEC NAME',secCode__c = 'SEC CODE');
        Insert sec;
        
        Office__c office = new Office__c(offCode__c='OFFCD', Name='OFFCD | offName', offDisplayName__c='offDIsp', ouId__c=ou.Id, offType__c='Technical Office');
        insert office;
        
        RecordType recType = [Select Id From RecordType where SobjectType = 'Implementing_Mechanism__c' and Name = 'Basic'];        
        Implementing_Mechanism__c imRec = new Implementing_Mechanism__c(Implementing_Mechanism_Name__c = 'IM Name',
                                                RecordTypeId = recType.Id,
                                                ouId__c = ou.Id                                             
                                                ); 
        insert imRec;
        
        Project__c project = new Project__c(ouId__c = ou.Id, Fiscal_Year__c = '2010', 
                                            Project_Manager__c = 'Test', Publicly_disclosable__c = true, Public_Name__c='Project Name',
                                            MissionName__c = 'Kenya');
        insert project;
        
        Activity__c act = new Activity__c(Activity_Name__c = 'Test', Project_Code__c = project.Id, 
                                        ImpMech_Id__c = imRec.Id, Publicly_disclosable__c = true);
        insert act;
                                        
        Public_IM_Link__c projectIM = new Public_IM_Link__c(Implementing_Mechanism_Number__c = imRec.Id, Project_Code__c=project.Id);
        insert projectIM;
        
        Sub_Awardee__c sAwardee = new Sub_Awardee__c(ImpMech_Id__c = imRec.Id, SubAwardee_Name__c='Sub Name', SubAwardee_Type__c='Partner Country System');
        insert sAwardee;
        
       
        ApexPages.currentPage().getParameters().put('ObjectName', 'OrgUnit');
        clsObjectLookupController objLook = new clsObjectLookupController();
        
        ApexPages.currentPage().getParameters().put('ObjectName', 'Office');
        objLook = new clsObjectLookupController();
        
        ApexPages.currentPage().getParameters().put('ObjectName', 'Sector');
        objLook = new clsObjectLookupController();
        
        System.runAs(missionUser){
            ApexPages.currentPage().getParameters().put('ObjectName', 'Project');
            objLook = new clsObjectLookupController();
        }
        ApexPages.currentPage().getParameters().put('ObjectName', 'Implementing Mechanism');
        ApexPages.currentPage().getParameters().put('pCode', project.Id);
        objLook = new clsObjectLookupController();
        
        ApexPages.currentPage().getParameters().put('ObjectName', 'Implementing Mechanism');
        ApexPages.currentPage().getParameters().put('pCode', '');
        objLook = new clsObjectLookupController();
        
        ApexPages.currentPage().getParameters().put('ObjectName', 'Sub-Awardee');
        ApexPages.currentPage().getPArameters().put('imCode',imRec.Id);
        objLook = new clsObjectLookupController();
        
        ApexPages.currentPage().getParameters().put('ObjectName', 'Sub-Awardee');
        ApexPages.currentPage().getPArameters().put('imCode','');
        objLook = new clsObjectLookupController();
        
        ApexPages.currentPage().getParameters().put('ObjectName', 'MissionUser');
        ApexPages.currentPage().getParameters().put('orgUnit',ou.Id);           
        objLook = new clsObjectLookupController();        
               
        ApexPages.currentPage().getParameters().put('ObjectName', 'PortalUser');
        ApexPages.currentPage().getParameters().put('accId',ac.Id);         
        objLook = new clsObjectLookupController();
        
        
        
        
    }

}