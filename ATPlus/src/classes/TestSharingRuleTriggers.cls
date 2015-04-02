@isTest 
public class TestSharingRuleTriggers {
    
    public static testmethod void testMethodTrIMUpsertSharingRule(){
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
        
        Profile missionUserProf = [SELECT Id FROM Profile WHERE Name= 'MDA - Mission Data Admin'];
        Profile partnerUserProf = [SELECT Id FROM Profile WHERE Name= 'Mission Partner'];
                                           
        
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
                                    LocaleSidKey='en_US', 
                                    ProfileId = missionUserProf.Id,        
                                    TimeZoneSidKey='America/Los_Angeles', 
                                    UserName='standarduserr1@testorg.com');
                                    
        User partnerUser  = new User(Alias = 'PUser',  
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
            insert missionUser;
            insert partnerUser;
        }   
        
        GroupMember gm = new GroupMember(UserOrGroupId=missionUser.Id,  GroupId=grp.Id);
        System.runAs(thisUSer){ 
            insert gm;          
        }
        OrgUnit__c ou = new OrgUnit__c();
        ou = prepOrgUnit();
        
        Award__c award = new Award__c();
        award = prepAward(1);
        System.runAs(thisUSer){
            insert award;
        }
        RecordType recType = [Select Id From RecordType where SobjectType = 'Implementing_Mechanism__c' and Name = 'Advanced'];     
        Implementing_Mechanism__c imRec = new Implementing_Mechanism__c(Implementing_Mechanism_Name__c = 'IM Name',
                                                RecordTypeId = recType.Id,
                                                ouId__c = ou.Id,
                                                Award_Id__c = award.Id,
                                                Partner_Id__c = ac.Id,
                                                Partner_User_1__c = partnerUser.Id
                                                );
        
            
        System.runAs(missionUser){
            insert imRec;   
        }
        
        Project__c project = new Project__c(ouId__c = ou.Id, Fiscal_Year__c = '2010', 
                                            Project_Manager__c = 'Test', Publicly_disclosable__c = true, 
                                            MissionName__c = 'Kenya');
        System.runAs(missionUser){
            insert project; 
        }
            
        Activity__c act = new Activity__c(Activity_Name__c = 'Test', Project_Code__c = project.Id, 
                                        ImpMech_Id__c = imRec.Id, Publicly_disclosable__c = true);
        System.runAs(missionUser){
            insert act; 
        }
        
        
        Public_IM_Link__c projectIM = new Public_IM_Link__c(Implementing_Mechanism_Number__c = imRec.Id, Project_Code__c=project.Id);               
        System.runAs(missionUser){
            System.debug('Before Inserting Public IM::');
            insert projectIM;   
        }       
        
        delete  projectIM;
        delete act;
        delete imRec;   
        
    }
    
    private static OrgUnit__c prepOrgUnit(){    
        
        Bureau__c bu = new Bureau__c(burCode__c = 'BUR', burName__c = 'BUR Name', Name = 'BUR Name'); 
        Insert bu;
        OrgUnit__c ou = new OrgUnit__c(ouCode__c = 'OUCODE', ouName__c = 'OUNAME',Name = 'OUNAME', ouDisplayName__c = 'OU DISPNAME',burId__c = bu.id );    
        Insert ou;
        return ou;      
    }
    
    private static Award__c prepAward(Integer seq){
        Award__c ae = new Award__c(AWARD_KEY__c = 'AKEY' + String.valueOf(seq),
                                                Name = 'AKEY' + String.valueOf(seq),
                                                ADDR_LINE_1__c = 'Award Address Line1' + String.valueOf(seq),
                                                ADDR_LINE_2__c = 'Award Address Line2' + String.valueOf(seq),
                                                ADDR_STATE__c = 'Award State' +String.valueOf(seq),
                                                AWARD_TYPE__c= 'Award Type' +String.valueOf(seq),
                                                CONTRACT_GRANT__c = 'ContractGrant'+String.valueOf(seq),
                                                DOCNUM__c = 'DocNum'+String.valueOf(seq),
                                                OrgUnit_Code__c = ''+String.valueOf(seq),
                                                OrgUnit_Name__c = ''+String.valueOf(seq),
                                                ENDDATE__c = Date.today() + 365 * seq,
                                                STARTDATE__c = Date.today() - seq,
                                                PROJECTTITLE__c = ''+String.valueOf(seq),
                                                LAST_MODIFICATION__c = ''+String.valueOf(seq),
                                                TEC__c = 3000 + (3000/seq),
                                                VEND_UNIQUE_ID__c = 'VenUniqueId'+String.valueOf(seq),
                                                VENDOR_CD__c = 'VenCd'+String.valueOf(seq),
                                                VENDOR_NM__c = 'VenName'+String.valueOf(seq),
                                                VENDOR_ADDR_CD__c = 'VenAdrCd'+String.valueOf(seq)
                                                );
        return ae;
    }
    
    private static Implementing_Mechanism__c prepIMBasicRecord(Integer seq, OrgUnit__c ou, Award__c award){
        RecordType recType = [Select Id From RecordType where SobjectType = 'Implementing_Mechanism__c' and Name = 'Advanced'];
        //System.debug('orgUnit Record::' +ou);
        //System.debug('Award Record::' +award);
        Implementing_Mechanism__c imRec = new Implementing_Mechanism__c(Implementing_Mechanism_Name__c = 'IM Name' + String.valueOf(seq),
                                                RecordTypeId = recType.Id,
                                                ouId__c = ou.Id,
                                                Award_Id__c = award.Id
                                                
                                                );
        return imRec;
    }

}