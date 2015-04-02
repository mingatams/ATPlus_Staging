public with sharing class ProjectDetailController {
    
    public Project__c project {public get; private set;}
    public Public_IM_Link__c imLink {public get; private set;}
    public List<Location1__c> locations {public get; private set;}
     
    public ProjectDetailController() {
        
        project = null; 
        imLink = null;
        
        // Get name of project from URL
        String projectId = ApexPages.currentPage().getParameters().get('Id');
        
        // Get list of projects that are publicly disclosable
        List<Project__c> projects = new List<Project__c> ([SELECT Id, Name, Public_Name__c, Start_Date__c, End_Date__c, Project_Subtype__c, Public_Photo__c, Project_Description__c, Sector_Name__c, MissionName__c, Primary_Initiative__c, Results__c, AdditionalLinksRelatedInfo__c FROM Project__c WHERE (Id=:projectId)]); //(Publicly_disclosable__c =:true) AND 
        
        if (projects == null || projects.IsEmpty()) return;
        
        project = projects[0];
        
        if(project == null) return;

        // Get Project IM Link object to display Primary Partner field
        List<Public_IM_Link__c> primaryPartners = new List<Public_IM_Link__c> ([SELECT Id, Project_Name__c, Implementing_Mechanism_Number__c, Implementing_Mechanism_Number__r.Award_Amount__c, Implementing_Mechanism_Number__r.Primary_Partner__c FROM Public_IM_Link__c WHERE (Project_Code__c = :project.Id)]);     //(Project_Code__r.Publicly_disclosable__c =:true) AND 
        for(Public_IM_Link__c pp: primaryPartners) {
              imLink = pp;
              break;
        } 
    }

}