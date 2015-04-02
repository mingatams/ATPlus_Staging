global with sharing class ClsSiteLoginController {
      
public Boolean Isaccept {get;set;}
 public String Description {get;set;}
 public String lang {get;set;}
 public string username {get;set;} 
 public string password {get;set;}
 public string strlabel{get;set;}
 public boolean hasError{get;set;}
 public Boolean isPortalUser {get;set;}
 public string passwordStatus{get;set;}
 public LoginHistory lHistory{get;set;}
 public string uId{get;set;}
 Public boolean isSubDomain{
  get {
      system.debug('URL Base:;'+URL.getSalesforceBaseUrl().toExternalForm());
      if (URL.getSalesforceBaseUrl().toExternalForm().contains('atpartner.usaid.gov')){
          return true;
      }
      return false;    
  }
  private set;
 }     
    
  public ClsSiteLoginController() {
       lang =  ApexPages.currentPage().getParameters().get('lang');
       username=  ApexPages.currentPage().getParameters().get('username');
       if (lang == null ) { lang = 'en'; }
       if (username== null ) { username= ''; }  
  }
     
   public pagereference Login(){     
     PageReference pagePref;
     String pageReferrence= '/VFIMTab'; 
     if(username != NULL && username !=''){  
     //LoginHistory lHistory = [SELECT Status,UserId FROM LoginHistory WHERE UserId=:username limit 1];
     //passwordStatus = lHistory.Status; 
     
     Integer countUser = [SELECT count() FROM User WHERE username=:username];
       if(countUser > 0){
           User userRb= [SELECT Id,username,RB_Indicator__c, IsPortalEnabled,RB_Valid_Until_Date__c FROM User WHERE username=:username];
                isPortalUser  = userRb.IsPortalEnabled;                
                if(!userRb.RB_Indicator__c || ( userRb.RB_Indicator__c && system.today() > userRb.RB_Valid_Until_Date__c) ){
                            pageReferrence = '/Partners/vfUserRulesOfBehaviour'; 
                          }
                 } 
            
         }
        pagePref = Site.login(username, password,pageReferrence);
        
        if(username != NULL && username !=''){
            User uRec =  [SELECT Id, Username FROM User WHERE username=:username];
            uId = uRec.Id;
            if(!Test.isRunningTest()){            
                lHistory = [SELECT Status,UserId FROM LoginHistory WHERE UserId=:uId order by LoginTime desc limit 1];
                passwordStatus = lHistory.Status;
            }    
        } 
        hasError = ApexPages.hasMessages();
        return pagePref; 
    }
  
  
 public pagereference Accept(){ 
  String userId = UserInfo.getUserId();
  User userRBUpdate = [select Id,username,RB_Indicator__c,RB_Signed_Date__c,RB_Valid_Until_Date__c from User where isActive = true and Id=:userId];
       if(userRBUpdate != null){       
            userRBUpdate.RB_Indicator__c = true;
            userRBUpdate.RB_Signed_Date__c =system.today();   
            userRBUpdate.RB_Valid_Until_Date__c=system.today()+1;     
            update userRBUpdate;       
        }
   // <!--PageReference reference=new PageReference('/home/home.jsp'); --> 
   PageReference reference=new PageReference('/Partners/apex/VFIMTab?save_new=1&sfdc.override=1');       
        return reference; 
     }
     
  @IsTest(SeeAllData=true) global static void testSiteLoginController () {
        // Instantiate a new controller with all parameters in the page
         
         
         Account ac = new Account(Name='ABC Corp');
         insert ac;
         
         Contact cont=new Contact(LastName = 'Testing',AccountId = ac.Id);
         insert cont;
         Profile partnerUserProf = [SELECT Id FROM Profile WHERE Name= 'Mission Partner'];
         User portalUser  = new User(Alias = 'standt', 
                                    Email='standarduser1@testorg.com', 
                                    isActive=true,       
                                    EmailEncodingKey='UTF-8', 
                                    LastName='Testing1', 
                                    LanguageLocaleKey='en_US',        
                                    LocaleSidKey='en_US',                                   
                                    ProfileId = partnerUserProf.Id, 
                                    contactId = cont.Id,      
                                    TimeZoneSidKey='America/Los_Angeles', 
                                    UserName='test@salesforce.com');
         
         insert portalUser;
        
        ClsSiteLoginController controller = new ClsSiteLoginController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456';
        
         
        
         controller.Login();
         controller.Accept();       
        System.assertEquals(controller.login(),null);                           
    } 
}