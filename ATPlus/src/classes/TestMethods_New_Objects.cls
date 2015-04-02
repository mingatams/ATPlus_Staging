@isTest(seealldata=true)

public class TestMethods_New_Objects{  
    
//test method for trBureauBeforeUpsert trigger  
        public static testmethod void trBureauBeforeUpsert() {      
        
        
        Bureau__c  b= new Bureau__c (name='testName',burCode__c='TestCode') ;
        insert b;
             String title = b.name;
             String code = b.burCode__c;
             b.name = code + ' | ' + title;
        Update b;
        }
        
//test method for trGeoBoundaryBeforeUpsert trigger  
        public static testmethod void trGeoBoundaryBeforeUpsert() {
        geoRegion__c gr = new geoRegion__c(name='gname',regCode__c='5');
        insert gr;
            String code1 = gr.regCode__c;
            String title1 = gr.name;
            gr.name = code1 + ' | ' + title1;
        Update gr;
        GeoCountry__c gc = new geocountry__c(name='TestCountry',cntryCode__c='4',regId__c=gr.id,cntrydispName__c='2');
        insert gc;
            String code2 = gc.cntryCode__c;
            String title2 = gc.name;
            gc.name = code2 + ' | ' + title2;
        Update gc;
        GeoBoundary__c  b= new GeoBoundary__c  (name='testName',cntryId__c=gc.id) ;
        insert b;
        
        
        
             String title3 = b.name;
             String code3 = b.cntryCode__c; 
             b.name = code3 + ' | ' + title3;
        Update b;
        }
        
        @IsTest(SeeAllData=true) 
        public static void testMissionUsersReport(){
            User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
            System.runAs(thisUSer){
                MissionUsersReport mc = new MissionUsersReport();
                mc.getLoginFilters();
                mc.getRoles();
                mc.selectedUserRole = 'All';
                mc.selectedLoginFilter = '30';
                mc.FilterMissionUsers();
                
                PartnerUsersReport  pr = new PartnerUsersReport();
            }
        }
        
//test method for trOfficeBeforeUpsert trigger  
        public static testmethod void trOfficeBeforeUpsert () { 
        
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
        
        QueueSobject q2 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'CDCSLINK__c');
        qList.add(q2);     
        
        
        System.runAs(thisUSer){
        insert qList; } 
        
        Bureau__c  b= new Bureau__c (name='testName',burCode__c='TestCode') ;
        insert b;
        
        OrgUnit__c  OU= new OrgUnit__c (name='OUCODE | OUNAME',burId__c=b.id,ouDisplayName__c='Disp5',ouCode__c='OUCODE') ;
        insert OU;
            String code1 = OU.ouCode__c;
            String title1 = OU.name;
            OU.name = code1 + ' | ' + title1;
        Update OU;
        Office__c  o= new Office__c (name='testName',offCode__c='TestCode',offDisplayName__c='office name',ouId__c=OU.id) ;
        insert o;
             String title2 = o.name;
             String code2 = o.offCode__c;
             o.name = code2 + ' | ' + title2;
        Update o;
        }
//test method for trOrgUnitGeographyBeforeUpsert trigger  
        public static testmethod void trOrgUnitGeographyBeforeUpsert() { 
        
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
        
        QueueSobject q2 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'CDCSLINK__c');
        qList.add(q2);
        
        System.runAs(thisUSer){
        insert qList; } 
        
        geoRegion__c gr = new geoRegion__c(name='gname',regCode__c='5');
        insert gr;
        GeoCountry__c gc = new geocountry__c(name='TestCountry',cntryCode__c='4',regId__c=gr.id,cntrydispName__c='2');
        insert gc;
        
        Bureau__c  b= new Bureau__c (name='testName',burCode__c='TestCode') ;
        insert b;        
        OrgUnit__c  OU= new OrgUnit__c (name='OUCODE | OUNAME',burId__c=b.id,ouDisplayName__c='Disp5',ouCode__c='OUCODE') ;
        insert OU;
        
        orgUnitGeography__c  oug= new orgUnitGeography__c (cntryID__c=gc.id,orgUnitId__c=ou.id) ;
        oug.uniqueRecordName__c = oug.orgUnitCode__c + ' | ' + oug.cntryCode__c;
        insert oug;
             
        }       
        
//test method for trSectorBeforeUpsert trigger  
        public static testmethod void trSectorBeforeUpsert () { 
        
        Sector__c  s= new Sector__c (name='testName',secCode__c='TestCode') ;
        insert s;
             String title = s.name;
             String code = s.secCode__c;
             s.name = code + ' | ' + title;
        Update s;
        }        
        
        
        //test method for trOrgUnitSectorBeforeUpsert trigger  
        public static testmethod void trOrgUnitSectorBeforeUpsert () { 
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
        
        QueueSobject q2 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'CDCSLINK__c');
        qList.add(q2);
        
        System.runAs(thisUSer){
        insert qList; } 
        
         Bureau__c  b= new Bureau__c (name='testName',burCode__c='TestCode') ;
        insert b;
        
        OrgUnit__c  OU= new OrgUnit__c (name='OUCODE | OUCODENAme',burId__c=b.id,ouDisplayName__c='Disp5',ouCode__c='OUCODE') ;
        insert OU;
        
         Sector__c  s= new Sector__c (name='testName',secCode__c='TestCode') ;
        insert s;
        
        orgUnitSector__c  ous= new orgUnitSector__c (name='testName1',ouid__c=OU.id,secId__c=s.id) ;
        insert ous;
             String title = ous.name;
             String code = ous.secCode__c;
             ous.name = code + ' | ' + title;
        Update ous;
        }  
 }