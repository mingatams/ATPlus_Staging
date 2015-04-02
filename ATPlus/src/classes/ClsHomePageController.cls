public with sharing class ClsHomePageController {
    
    
    
    public List<officeReport> officeReportList{get;set;}
    public List<ObjectiveReport> objectiveReportList{get;set;}
    public List<String> sectorReportXCat{get;set;}
    public List<Double> sectorReportData{get;set;}
    public List<String> partnerReportXCat{get;set;}
    public List<Double> partnerReportData{get;set;}
    public String localStr{get;set;}
    public String countryStr{get;set;}
    public String focusStr{get;set;}
    public clsGlobalUtility globalUtil = new clsGlobalUtility();   
    public String officeReportListStr{
        get {
            //system.debug(JSON.serialize(this.officeReportList));
            return JSON.serialize(this.officeReportList);
        }
        private set;
    } 
    
    public String objectiveReportListStr{
        get {
            //system.debug(JSON.serialize(this.officeReportList));
            return JSON.serialize(this.objectiveReportList);
        }
        private set;
    } 
    
   /* public String sectorReportListStr{
        get {
            //system.debug(JSON.serialize(this.officeReportList));
            return JSON.serialize(this.sectorReportList);
        }
        private set;
    } */
    
    public ClsHomePageController(){
    //  mapURLStr = '';
        String queryString, queryStringS, queryStringP, queryStringO ;        
        String uRoleId = UserInfo.getUserRoleId();
        UserRole ur = [Select Name From UserRole where Id = :uRoleId];
        String orgUnitName;
        string countryName;
        localStr= 'local';
      /* if (((String)ur.Name).contains(' | ')){
            orgUnitName = ((String)ur.Name).split(' | ')[0];
            countryName = ((String)ur.Name).split(' | ')[2];
            countryStr=countryName.trim();
        } else {
            orgUnitName = 'SEN';
            countryStr = 'Senegal';
        }
        */
         List<OrgUnit__c>  OrgList = globalUtil.lookup(globalUtil.getUserRole(),'ouCode__c', 'OrgUnit__c');    
          if(OrgList != null && OrgList.size() > 0){
             if(OrgList.get(0).ouType__c == 'Bilateral Mission' || OrgList.get(0).ouType__c == 'Field Mission'){ 
               orgUnitName =OrgList.get(0).ouCode__c;    
               countryStr  =OrgList.get(0).ouDisplayName__c;
               focusStr =   OrgList.get(0).ouDisplayName__c;
               localStr= 'local';     
             } else {
                 orgUnitName =OrgList.get(0).ouCode__c; 
                 List<orgUnitGeography__c>  orgGeoCntryList = globalUtil.lookup(OrgList.get(0).Id,'orgUnitId__c', 'orgUnitGeography__c');
                 if (!orgGeoCntryList.isEmpty()){    
                     countryStr  = orgGeoCntryList.get(0).cntryName__c;
                     List<GeoCountry__c>  geoCntryList = globalUtil.lookup(orgGeoCntryList.get(0).cntryId__c,'Id', 'GeoCountry__c');
                     focusStr = !geoCntryList.isEmpty() ? geoCntryList.get(0).regName__c : '';
                    
                 }    
                 localStr = 'regional';
             }  
          } 
         if(orgUnitName == null){
            orgUnitName = 'SEN';
            countryStr = 'Senegal';
            focusStr =  'Senegal'; 
         }
        
        system.debug('Display COuntry NAme::::' +countryName);
      //  if (orgUnitName.equalsIgnoreCase('Root')){
      //      queryString = 'Select p.offId__r.offName__c oName, count(Id) pCount From Project__c  p where p.offId__c <> null group by p.offId__r.offName__c ';
      //      queryStringS = 'Select p.Project_Code__r.Sector_Name__c sName, sum(Award_Amount__c) aAmount From Public_IM_Link__c  p where p.Project_Code__r.ouCode__c <> null group by p.Project_Code__r.Sector_Name__c';
      //      queryStringP = 'Select Partner_Name__c pName, sum(Award_Amount__c) aAmount  From Implementing_Mechanism__c  p where p.Partner_Name__c <> null group by p.Partner_Name__c';
      //      queryStringO = 'Select Framework_Id__r.poCode__c oCode, Framework_Id__r.poName__c oName, Count_Distinct(Project_Id__c) pCount From Framework_Linkage__c group by Framework_Id__r.poCode__c, Framework_Id__r.poName__c';
        //  mapURLStr = '/AidTrackerMapData';
      //  } else {
          if (orgUnitName != null) {
           // queryString = 'Select p.offId__r.offName__c oName, count(Id) pCount From Project__c p where ouCode__c = \'' +orgUnitName +'\' and p.offId__c <> null group by p.offId__r.offName__c ';
            queryString = 'Select p.Project_Code__r.offId__r.offName__c oName, Count_Distinct(p.Implementing_Mechanism_Number__c) pCount From Public_IM_Link__c p where p.Project_Code__r.ouCode__c = \'' +orgUnitName +'\' and p.Project_Code__r.offId__c <> null group by p.Project_Code__r.offId__r.offName__c'; 
            queryStringS = 'Select p.Project_Code__r.Sector_Name__c sName, sum(Award_Amount__c) aAmount From Public_IM_Link__c p where p.Project_Code__r.ouCode__c = \'' +orgUnitName +'\' group by p.Project_Code__r.Sector_Name__c  order by sum(Award_Amount__c) desc';
           // queryStringP = 'Select p.Partner_Id__r.Name pName, sum(p.Award_Amount__c) aAmount From Implementing_Mechanism__c  p where p.Partner_Id__c <> null and Award_Amount__c > 0 and p.ouCode__c = \'' +orgUnitName +'\'  group by p.Partner_Id__r.Name order by sum(Award_Amount__c) desc limit 10';
            queryStringP = 'Select p.Partner_Name__c pName, sum(p.Award_Amount__c) aAmount From Implementing_Mechanism__c  p where p.Partner_Name__c <> null and Award_Amount__c > 0 and p.ouCode__c = \'' +orgUnitName +'\'  group by p.Partner_Name__c order by sum(Award_Amount__c) desc limit 10'; 
            queryStringO = 'Select Framework_Id__r.poCode__c oCode, Framework_Id__r.poName__c oName, Count_Distinct(Project_Id__c) pCount From Framework_Linkage__c where ouCode__c = \'' +orgUnitName +'\' group by Framework_Id__r.poCode__c, Framework_Id__r.poName__c';
            /*if (((String)ur.Name).contains(' | ')){
                mapURLStr = '/apex/AidTrackerMapData?l=local&w='+countryName;
            } else {
                mapURLStr = '/apex/AidTrackerMapData';
            }   */
        }
       // system.debug('Display MapURL::::' +mapURLStr);
        officeReportList = new List<officeReport>();    
        for(AggregateResult ar: Database.query(queryString)){
            officeReportList.add(new officeReport((String)ar.get('oName'),(Integer)ar.get('pCount')));              
        }
        sectorReportXCat = new List<String>();
        sectorReportData = new List<Double>();
        for(AggregateResult ar: Database.query(queryStringS)){
            //sectorReportList.add(new sectorReport((String)ar.get('sName'),(Double)ar.get('aAmount')));
            if (ar.get('sName') != null){
                sectorReportXCat.add('\''+((String)ar.get('sName')).replaceAll('\'','')+'\'');  
                sectorReportData.add((Double)ar.get('aAmount'));
            }               
        }
        
        partnerReportXCat = new List<String>();
        partnerReportData = new List<Double>();
        for(AggregateResult ar: Database.query(queryStringP)){
            //sectorReportList.add(new sectorReport((String)ar.get('sName'),(Double)ar.get('aAmount')));
            if (ar.get('pName') != null){
                partnerReportXCat.add('\''+((String)ar.get('pName')).replaceAll('\'','')+'\''); 
                partnerReportData.add((Double)ar.get('aAmount'));
            }               
        }
        
        objectiveReportList = new List<ObjectiveReport>();
        for(AggregateResult ar: Database.query(queryStringO)){
            objectiveReportList.add(new ObjectiveReport((String)ar.get('oName'),(Integer)ar.get('pCount')));              
        }
    }
    
    public class officeReport{      
        public Integer projectCount{get;set;}
        public String officeName{get;set;}
        
        public officeReport(String oName, Integer pCount){
            this.officeName = oName;
            this.projectCount = pCount;
            
        }
        
    }
    
    public class ObjectiveReport{      
        public Integer projectCount{get;set;}
        public String objectiveName{get;set;}
        
        public ObjectiveReport(String oName, Integer pCount){
            this.objectiveName= oName;
            this.projectCount = pCount;
            
        }
        
    }
    
    
 /** Test Method */      
 @IsTest(SeeAllData=true) public static void testClsHomePageController() {
      ClsHomePageController controller = new ClsHomePageController();
      
 }
    
    

}