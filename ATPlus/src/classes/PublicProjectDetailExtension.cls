public with sharing class PublicProjectDetailExtension{
    private ClsGlobalUtility GU = new ClsGlobalUtility();
    public Project__c proj;
    public string photoUrl{
        get{
            string retPhotoUrl;
            string imageUrl = proj.Public_Photo__c;
             if (imageUrl != null){
               imageUrl = imageUrl.replaceAll('amp;','');    
               String regex = 'src\\s*=\\s*([\"\'])?([^\"\']*)';
               Matcher m = Pattern.compile(regex).matcher(imageUrl);        
               if (m.find()){
                   imageUrl = m.group(2);  
                   return imageUrl;                           
               }  
            }
            return null;
        }
        private set;
    }
    public string publicResults{
        get {
            return GU.getHTMLRemovedText(proj.Results__c);
        }
        private set;
    }
    public string projectDescription {
        get {            
            return GU.getHTMLRemovedText(proj.Project_Description__c);
        }
        private set;
    }
    public double awardAmount{
        get{
            Decimal totalAwardAmount = 0.0;
             List<Public_IM_Link__c> primaryPartnersList = new List<Public_IM_Link__c>([Select 
                                             p.Project_Name__c, p.Implementing_Mechanism_Number__r.Partner_Name__c, 
                                             p.Implementing_Mechanism_Number__r.Award_Amount__c, p.Implementing_Mechanism_Number__r.Name, 
                                             p.Implementing_Mechanism_Number__c, p.Id From Public_IM_Link__c p 
                                            where p.Project_code__c = :proj.Id]);
             for(Public_IM_Link__c pp: primaryPartnersList) {
                 Implementing_Mechanism__c im = (Implementing_Mechanism__c)pp.Implementing_Mechanism_Number__r;
                 if (im.Award_Amount__c != null){
                     totalAwardAmount = totalAwardAmount + im.Award_Amount__c;
                 }    
             }
             return totalAwardAmount;
        }
        private set;
    }
    
    public string flagName{get;set;}
    public string cntryName{get;set;}
  //  public string flagName{
  //      get{
  //          orgUnitGeography__c orgGeography = [Select cntryCode__c From orgUnitGeography__c where orgUnitId__c = :proj.ouId__c limit 1];
  //          
  //          return orgGeography.cntryCode__c.trim();
  //      }
  //      private set;
  //  }
    
    public PublicProjectDetailExtension(ApexPages.StandardController controller){
        clsGlobalUtility GU = new clsGlobalUtility();
        proj = (Project__c)controller.getRecord();
        proj = (Project__c)GU.lookup(proj.Id,'Project__c');
        string cName = ApexPages.currentPage().getParameters().get('cid');
      //  List<Project_Location__c> pLocations = new List<Project_Location__c>([Select cntryCode__c, cntryName__c 
      //                                                                         From Project_Location__c 
      //                                                                         Where Name = :proj.Name limit 1]);
        List<geoCountry__c> countries = new List<geoCountry__c>([select cntryCode__c, cntryName__c
                                                                 From geoCountry__c
                                                                 where cntryName__c = :cName limit 1]);
        if (!countries.isEmpty()){    
            flagName = countries[0].cntryCode__c;
            cntryName = countries[0].cntryName__c;                                                                       
        }    
    }


}