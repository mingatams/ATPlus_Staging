public class AAClsUserProfileFinder {

    public List<Document> quickGuides { get; private set; }
    public List<Document> faqs { get; private set; }
    public List<ContentVersion> videos { get; private set; }
    
    public AAClsUserProfileFinder(){
        setQuickGuideLinks();
        setFAQLinks();
    }
    
    /**
    Method used to set the links to the Quick Guides documents 
    */ 
    public void setQuickGuideLinks(){
        try{
            Set<String> strDocs = new Set<String>{'A_A_Dashboard_Quickguide',
                                                  'New_Planned_Action_Additional_Award_Info_Quick_Guide',   
                                                  'New_Planned_Action_Award_Info_Tab_Quick_Guide',
                                                  'New_Planned_Action_Reporting_Questions_AARAD_Info_Tabs_Quick_Guide'};
            quickGuides = [SELECT ID, Name FROM Document WHERE DeveloperName IN :strDocs];
            
        }catch( Exception e ){
            ApexPages.addMessage( new ApexPages.message( ApexPages.Severity.Error, e.getMessage() ) );
        }
    }
    
    /**
    Method used to set the links to the FAQ documents 
    */ 
    public void setFAQLinks(){
        try{
            Set<String> strDocs = new Set<String>{'A_A_Plan_FAQ'};
            faqs = [SELECT ID, Name FROM Document WHERE DeveloperName IN :strDocs];
            
        }catch( Exception e ){
            ApexPages.addMessage( new ApexPages.message( ApexPages.Severity.Error, e.getMessage() ) );
        }
    }
}