public with sharing class ClsIndicatorsRelatedList {

    //public ClsIndicatorsRelatedList() {

    //}

    public string selectedOrgUnit {get;set;}
    public string xmlString1{get;set;} 
    public string orgId;
    
     
    public ClsIndicatorsRelatedList(){
        
        //Id recType = GU.getRecordTypeId(OrgUnit_Indicator__c,'Master');
        String uRoleId = UserInfo.getUserRoleId();
        UserRole ur = [Select Name From UserRole where Id = :uRoleId];
        String orgUnitName;
        if (((String)ur.Name).contains(' | ')){
                orgUnitName = ((String)ur.Name).split(' | ')[0];
            } else {
                orgUnitName = 'Root';
        }
        
        system.debug('Org Unit Name::::'+orgUnitName);
        
        if (orgUnitName.equalsIgnoreCase('Root')){
            orgId = 'a0md0000000cqGw';
            system.debug('Org Unit ID::::'+orgId);
            selectedOrgUnit='a0md0000000cqGw';
            //Map<String,OrgUnit_Indicator__c> orgInd1 = IWU.getOrgUnitIndicatorsByRecordType1('', 'Master');
        } else {
            OrgUnit__c ou = [Select Id, ouCode__c From OrgUnit__c where ouCode__c = :orgUnitName.trim()];
            orgId = ou.Id;
            selectedOrgUnit = ou.Id;
            system.debug('Org Unit ID::::'+orgId);
            //Map<String,OrgUnit_Indicator__c> orgInd1 = IWU.getOrgUnitIndicatorsByRecordType1(orgId, 'Master');
        }
        getTreeXML();
            
    }       
    public PageReference getTreeXML(){
            clsGlobalUtility GU = new clsGlobalUtility();
            ClsIndicatorWizardUtility IWU = new ClsIndicatorWizardUtility();
            IWU.getOrgUnitIndicatorsByRecordType(orgId, 'Master');
            IWU.initializeXML();
            Map<String,OrgUnit_Indicator__c> orgInd1 = IWU.getOrgUnitIndicatorsByRecordType1(orgId, 'Master');
            Map<String,OrgUnit_Indicator__c> sorgInd1 = IWU.getOrgUnitSubIndicators(orgId, 'Master');
            Map<String,List<OrgUnit_Indicator__c>> subIndicators = IWU.getSubIndicatorsForIndicators(orgInd1.values(),sorgInd1.values());
            system.debug('Map::::'+orgInd1);
            for(String ind: orgInd1.keySet()){
                OrgUnit_Indicator__c ind1 = orgInd1.get(ind);
                if(ind1.Custom__c){
                    IWU.getCustomXMLString1('Custom Indicator',orgInd1.get(ind));
                  //  Map<String,OrgUnit_Indicator__c> cSubIndicators = IWU.getOUIndsWithOUIndIdAndUSAIDIndIdAsKeyByPrCode(ind, 'Custom Sub Indicator');
                  //  for(OrgUnit_Indicator__c cSubInd: cSubIndicators.values()){
                  if(subIndicators.containsKey(ind)){  
                    for(OrgUnit_Indicator__c cSubInd: subIndicators.get(ind)) {           
                        IWU.getCustomXMLString1('Custom Sub Indicator',cSubInd);               
                        IWU.terminateRow();
                    } 
                  }  
                    IWU.terminateRow(); 
                } else {
                    IWU.getCustomXMLString1('Indicator',orgInd1.get(ind));
                  //  Map<String,OrgUnit_Indicator__c> cSubIndicators = IWU.getOUIndsWithOUIndIdAndUSAIDIndIdAsKeyByPrCode(ind, 'Custom Sub Indicator');
                  //  for(OrgUnit_Indicator__c cSubInd: cSubIndicators.values()){ 
                   if(subIndicators.containsKey(ind)){           
                    for(OrgUnit_Indicator__c cSubInd: subIndicators.get(ind)) { 
                      if(cSubInd.custom__c){
                        IWU.getCustomXMLString1('Custom Sub Indicator',cSubInd);               
                        IWU.terminateRow();
                      } else {
                          IWU.getCustomXMLString1('Sub Indicator',cSubInd);               
                          IWU.terminateRow();
                      }  
                    }
                   }  
                  //  Map<String,OrgUnit_Indicator__c> cSubIndicators1 = IWU.getOUIndsWithOUIndIdAndUSAIDIndIdAsKeyByPrCode(ind, 'Sub Indicator');
                  //  for(OrgUnit_Indicator__c cSubInd: cSubIndicators1.values()){            
                  //      IWU.getCustomXMLString1('Sub Indicator',cSubInd);               
                  //      IWU.terminateRow();
                  //  }
                    IWU.terminateRow();
                }
        }       
        IWU.terminateXML();
        system.debug('XML Strin so far::::' +IWU.getXMLString());   
        xmlString1 = IWU.getXMLString();
        xmlString1 = xmlString1.replaceAll('\'','');
        return null;
    }
     @IsTest(SeeAllData=true) public static void testClsIndicatorsRelatedList(){
         User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
         Profile missionUserProf = [SELECT Id FROM Profile WHERE Name= 'MDA - Mission Data Admin'];
         UserRole missionUserRole = [Select Id From UserRole where DeveloperName = 'Rwanda_User'];
         User missionUser1 = [Select Id,Name From User where UserRoleId = :missionUserRole.Id limit 1][0];
          User missionUser  = new User(Alias = 'standt', 
                                    Email='standarduser1@testorg.com', 
                                    isActive=true,       
                                    EmailEncodingKey='UTF-8', 
                                    LastName='Testing1', 
                                    LanguageLocaleKey='en_US',        
                                    LocaleSidKey='en_US', 
                                    ProfileId = missionUserProf.Id,
                                    UserRoleId = missionUserRole.id,        
                                    TimeZoneSidKey='America/Los_Angeles', 
                                    UserName='testClsIndicatorsRelatedList@testorg.com');
        //  insert missionUser;                          
         ClsTestUtility testIndicatorUtil = new ClsTestUtility();
         String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
         List<USAID_Indicator__c> uInds = testIndicatorUtil.getUSAIDIndicatorRecords();
         List<OrgUnit_Indicator__c> masterInds = testIndicatorUtil.getIndicatorsForOrgId(OrgUnitId, uInds);
         List<OrgUnit_Indicator__c> cmasterInds =testIndicatorUtil.getCustomIndicatorRecordsForOrgId(OrgUnitId);
         //ApexPages.currentPage().getParameters().put('Lid', OrgUnitId);
          System.runAs(missionUser1){ 
         ClsIndicatorsRelatedList controller = new ClsIndicatorsRelatedList();
         }
         //controller.orgUnitName = 'AFG | Afghanistan';
     }
}