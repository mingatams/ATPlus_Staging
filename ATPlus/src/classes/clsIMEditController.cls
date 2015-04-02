/**
 * This class contains  controller  methods for editing Implementing Mechanism from Award.
 *
 * These controller is used by  vfDispatcherIMEdit page
*/
public with sharing class clsIMEditController {
     // the soql without the order and limit
      private String soql {get;set;}
      public Project__c taskProject {get;set;}
      // the collection of accounts to display
      public List<Award__c> awards {get;set;}
      
      public class OrgUnitRetObj{
                public String OUCode {get; set;}
                public String OUName {get; set;}
            }
    
      // the current sort direction. defaults to asc
      public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
      }
      // the current field to sort by. defaults to AWARD_KEY__c
      public String sortField {
        get  { if (sortField == null) {sortField = 'AWARD_KEY__c'; } return sortField;  }
        set;
      }
      // format the soql for display on the visualforce page
      public String debugSoql {
        get { return soql; }
        set;
      }   
 
    public String retURL {get; set;}
    public String saveNewURL {get; set;}
    public String rType {get; set;}
    public String cancelURL {get; set;}
    public String IMID {get; set;}
    public String contactID {get; set;}
   
// init the controller and display some sample data when the page loads initially
public clsIMEditController(ApexPages.StandardController controller){
    soql='SELECT Name, ID, AWARD_KEY__c, PROJECTTITLE__c, DocNum__c, OrderNum__c, Last_Modification__c, VENDOR_NM__c, TEC__c, StartDate__c, EndDate__c FROM Award__c WHERE Award__c.Name != null';
    runQuery();
   IMID =ApexPages.currentPage().getParameters().get('id');
   
 
  List<Public_IM_Link__c> publicIMLink = [SELECT Project_Code__c,Project_Name__c,Project_Type__c FROM Public_IM_Link__c WHERE Implementing_Mechanism_Number__c=:IMID and Project_Type__c='IM Project'];
       if(publicIMLink != null && publicIMLink.size()==1){  
           for(Public_IM_Link__c pIMLink:publicIMLink ){            
           taskProject  = [SELECT id,Project_Code__c,Public_Name__c FROM Project__c WHERE id=:pIMLink.Project_Code__c];
           }
       }else{
         taskProject  =new Project__c() ;
       }               

   
  }
  
  
  
  
  public PageReference redirect() {
    return null;
  }
  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    runQuery();
  }
 
// runs the actual query
  public void runQuery() {
    try {
        awards = Database.query(soql + ' ORDER BY ' + sortField + ' ' + sortDir + ' Limit 10');
    } catch (Exception e) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Occured on this page:'+e.getMessage()+' at line number'+e.getLineNumber()));
    }}
  // runs the search with parameters passed via Javascript
  public PageReference runSearch() {

    String awardDocNum= Apexpages.currentPage().getParameters().get('AwardDocNum').trim();
    String awardOrderNum= Apexpages.currentPage().getParameters().get('AwardOrderNum').trim();
    String awardProjTitle= Apexpages.currentPage().getParameters().get('AwardProjTitle').trim();
    String awardOrgUnit= Apexpages.currentPage().getParameters().get('AwardOrgUnit').trim();
    String awardPartnerName= Apexpages.currentPage().getParameters().get('AwardPartnerName').trim();

    //  System.debug('Award Doc Num:'+awardDocNum);
    soql='SELECT Name, ID, AWARD_KEY__c, PROJECTTITLE__c, DocNum__c, OrderNum__c, Last_Modification__c, VENDOR_NM__c, TEC__c, StartDate__c, EndDate__c FROM Award__c WHERE Award__c.Name != null';
   
    if (!awardDocNum.equals(''))
        soql += ' AND DocNum__c LIKE \''+String.escapeSingleQuotes(awardDocNum)+'%\'';
    if (!awardProjTitle.equals(''))
        soql += ' AND PROJECTTITLE__c LIKE '+'\'%'+String.escapeSingleQuotes(awardProjTitle)+'%\'';
    if (!awardOrderNum.equals(''))
        soql += ' AND OrderNum__c LIKE '+'\'%'+String.escapeSingleQuotes(awardOrderNum)+'%\'';
    if (!awardPartnerName.equals(''))
        soql += ' AND VENDOR_NM__c LIKE '+'\'%'+String.escapeSingleQuotes(awardPartnerName)+'%\''; 
    // run the query again
    runQuery();
    return null;
}
 
//*************************************************************************************  
 // Populate the Dropdowm values here: 
    public List<OrgUnitRetObj> orgUnits {
    get {
        List<OrgUnit__c> ouList =[select OUCODE__C, OUName__C from OrgUnit__c];
        if (orgUnits == null) {
             orgUnits=New List<OrgUnitRetObj>();
             for (OrgUnit__c oUnit:ouList){
                  OrgUnitRetObj curOU=new OrgUnitRetObj();
                  curOU.OUCode=oUnit.OUCODE__C;
                  curOU.OUName=oUnit.OUName__C;
                  orgUnits.add(curOU);    
               }
         }
      return orgUnits;          
    }
    set;
  }    
//*************************************************************************************

 /*public PageReference Create_Rep_period() {
             String actId=ApexPages.currentPage().getParameters().get('id');
             clsGlobalUtility GU = new clsGlobalUtility();
             clsReportingPeriod repPrd=new clsReportingPeriod();
             
             
             if (actId==null)
                 return null;
             repPrd.createRepPeriod(actId);
             PageReference pRef = new PageReference('/'+actId);
             return pRef;
        }    */
   

public PageReference financialPage()
   {
  
    PageReference reference=new PageReference('/apex/vfIMFinancialSnapShot?id='+IMID);       
        return reference; 
   
   }
public PageReference glassAwardPage()
   {
    // Trying to sync this with production - Ram 03/14/2013  
    //PageReference reference=new PageReference('/apex/vfDispatcherIMEdit?id='+IMID);   
    PageReference reference=new PageReference('/apex/vfIMFromAward?id='+IMID);    
        return reference; 
   
   }
   
   /** Redirect to Indicator Result page for Partner profile **/
 public pagereference partnerRedirect()
{  
    clsGlobalUtility GU = new clsGlobalUtility();
    /* Profile prof = [Select Id, Name from Profile where Name='Mission Partner'];                       
       String prf = UserInfo.getProfileId();                       
      if (prof !=null && prf.equals(prof.Id))*/
      if(GU.isMissionPartnerUser())
     {
           String imId= ApexPages.currentPage().getParameters().get('Id');           
           pagereference pageref = new pagereference('/Partners/vfIMIndicatorResultsPage?id='+imId);
           pageref.setredirect(true);
           return pageref;
     }
     else
          return null;
}




 /** Test Method */      
 @IsTest(SeeAllData=true) public static void testRFIndicatorSetup() {
 
    ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        Test.StartTest();
        String IMId= testIndicatorUtil.getIMForOrgIdNRecordType(OrgUnitId,'Advanced');
         ApexPages.currentPage().getParameters().put('Id',IMId); 
        
        Implementing_Mechanism__c  imLink=[select Id,Name,RecordTypeId from Implementing_Mechanism__c where id = :IMId];         
        ApexPages.StandardController thecontroller = new ApexPages.StandardController(imLink);
      
        clsIMEditController controller = new clsIMEditController(thecontroller );
        controller.redirect();
        controller.toggleSort();
        controller.runQuery();        
        controller.financialPage();

         ApexPages.currentPage().getParameters().put('AwardDocNum','TEST');
         ApexPages.currentPage().getParameters().put('AwardOrderNum','TEST');
         ApexPages.currentPage().getParameters().put('AwardProjTitle','TEST');
         ApexPages.currentPage().getParameters().put('AwardOrgUnit','TEST');
         ApexPages.currentPage().getParameters().put('AwardPartnerName','TEST');

        controller.runSearch();
        controller.glassAwardPage();
        controller.partnerRedirect();  
       
       OrgUnitRetObj curOU=new OrgUnitRetObj();
       curOU.OUCode='test';
       curOU.OUName='testName';
       controller.orgUnits.add(curOU);   
          
       
        Test.StopTest();
    
 }

}