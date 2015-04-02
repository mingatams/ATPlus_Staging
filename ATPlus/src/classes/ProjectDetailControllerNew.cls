public with sharing class ProjectDetailControllerNew {
    
    public Project__c project {get;set;}
    public Public_IM_Link__c imLink {get;set;}
    public List<Location1__c> locations {get;set;}
    public Decimal AwardAmount {get;set;}
    public Decimal AvgAmount {get;set;}
    public Integer Startyear {get;set;}
    public Integer Endyear {get;set;}
    public Integer Thisyear {get;set;}
    public String projectId{get;set;}
    public String region{get;set;}
    public String sector{get;set;}   
    
    
    
    public String ProjstartDate {get;set;}   
    public String ProjendDate {get;set;} 
    public String Projsector {get;set;}
    public integer yearsdiff ;
    public string  imgURL{get;set;}
    public integer imgURLString{get;set;}
    public string imgURLStringfinal{get;set;}
    public string imgID{get;set;}
    public boolean photoflag{get;set;}

    public string AdditionalLinks {get;set;}
    
    public string publicName {get;set;}
    
    public string projectDesc {get;set;}
    public string projectResults {get;set;}
    
    public integer SameMissionProjs; 
    public string  AwardamountStr {get;set;}  
    public List<String> primaryPartners {get; private set;}     
    
    public ProjectDetailControllerNew() {
        AwardAmount  = 0 ;
        AwardamountStr  = '';
        Photoflag=true;
        project = null; 
        imLink = null;
        sector = 'Blank';
        
        
        // Get name of project from URL
        projectId = ApexPages.currentPage().getParameters().get('id');
         
        if( projectId != null ) {
        
         project = [SELECT Id, Name, Public_Name__c, Start_Date__c, End_Date__c, Project_Subtype__c, Status__c,//#2013
                          Public_Photo__c, Project_Description__c, Sector_Name__c, secName__c, secCode__c, burCode__c, MissionName__c, 
                          Primary_Initiative__c, Results__c, AdditionalLinksRelatedInfo__c
                   FROM Project__c 
                   WHERE (Id=:projectId) Limit 1];
        
        // Get total projects on same Mission Name, to calcualte the Avg Amount
        if(project.Public_Name__c != null){
            publicName = project.Public_Name__c;
            publicName = publicName.replace('\'', '');
        }
        System.debug('Displaying the Sector Code:::' +project.secCode__c);
        
        SameMissionProjs = [SELECT Count() 
                            FROM Project__c 
                            WHERE MissionName__c =: project.MissionName__c ] ;
        
        System.Debug('SameMissionProjs ==> '+ SameMissionProjs );

        
        
        //Parse Project_Description__c for new line character and replace with space.
        
        //Pattern newLinePat = Pattern.compile('
        IF(project.Project_Description__c != null){
            projectDesc = project.Project_Description__c.replaceAll('\\r?\\n','');
         } else {
            projectDesc = ' '; 
         }
         
         //Pattern newLinePat = Pattern.compile('
        IF(project.Results__c != null){
            projectResults = project.Results__c.replaceAll('\\r?\\n','');
         } else {
            projectResults = ' '; 
         }
                
        AdditionalLinks =project.AdditionalLinksRelatedInfo__c;
        //Assigning Region based on the mission
       /* if ( project.MissionName__c != null ){
          If(( project.MissionName__c=='Afghanistan') || (project.MissionName__c=='Pakistan')){
           region='Afghanistan & Pakistan';
           }
            If(( project.MissionName__c=='India') || (project.MissionName__c=='Nepal') || (project.MissionName__c=='Philippines') || (project.MissionName__c=='Cambodia') ||
            (project.MissionName__c=='Timor-Leste') || (project.MissionName__c=='Bangladesh') || (project.MissionName__c=='Indonesia') || (project.MissionName__c=='Central Asia Republics') || (project.MissionName__c=='Regional Development Mission for Asia') ){
           region='Asia';
           }

            If(( project.MissionName__c=='Montenegro') || (project.MissionName__c=='Russia') || (project.MissionName__c=='Georgia')
            || (project.MissionName__c=='Serbia') || (project.MissionName__c=='Albania')){
           region='Europe & Eurasia';
           }

            If(( project.MissionName__c=='Haiti') || (project.MissionName__c=='Ecuador') || (project.MissionName__c=='Peru') ||
            (project.MissionName__c=='El Salvador') || (project.MissionName__c=='Mexico') || (project.MissionName__c=='Dominican Republic') || (project.MissionName__c=='Guatemala')){
           region='Latin America & The Carribean';
           }

            If(( project.MissionName__c=='Lebanon') || (project.MissionName__c=='Iraq') || (project.MissionName__c=='WB Gaza') ||
            (project.MissionName__c=='Morocco')){
           region='MIddle East';
           }
            If(( project.MissionName__c=='Democratic Republic of the Congo') || (project.MissionName__c=='Ethiopia') ||
            (project.MissionName__c=='Kenya') || (project.MissionName__c=='Nigeria') || (project.MissionName__c=='South Africa') ||
            (project.MissionName__c=='Uganda') || (project.MissionName__c=='Rwanda') || (project.MissionName__c=='South Sudan')
            || (project.MissionName__c=='Ghana') || (project.MissionName__c=='Liberia') || (project.MissionName__c=='Mozambique') ||
            (project.MissionName__c=='Senegal') || (project.MissionName__c=='Tanzania') || (project.MissionName__c=='Zimbabwe') ||
            (project.MissionName__c=='Tanzania') || (project.MissionName__c=='Angola')
                ){
           region='SUB SAHARAN AFRICA';
           }
        } */
        
        //Displaying sector images based on the sector value
       /* If((Project.sector_Name__c == null) || (Project.sector_Name__c == '')){
            sector='Blank';            
        }else{
            sector='Blank';
            If(Project.sector_Name__c.contains('Gender')){
            sector='Gender';
            }
            If(Project.sector_Name__c.contains('Democracy')){
            sector='Democracy';
            }
             If(Project.sector_Name__c.contains('Environment')){
            sector='Environment';
            }
            If(Project.sector_Name__c.contains('Science')){
            sector='Science';
            }
             If(Project.sector_Name__c.contains('Agriculture')){
            sector='Agriculture';
            }
            If(Project.sector_Name__c.contains('Economic')){
            sector='Economic';
            }
             If(Project.sector_Name__c.contains('Water')){
            sector='Water';
            }
            If(Project.sector_Name__c.contains('Global Health')){
            sector='Global Health';
            }
            If(Project.sector_Name__c.contains('Education')){
            sector='Education';
            }
            If(Project.sector_Name__c.contains('Crises')){
            sector='Crises';
            }
            
        } */
        

        //getting an Image ID from public Photo field
      //   project__c img=[select Id,Name,Public_Photo__c from project__c where id=:projectId ];
       
       imgURL = project.Public_Photo__c;
       
       if (imgURL != null){
            imgURL = imgURL.replaceAll('amp;','');    
           String regex = 'src\\s*=\\s*([\"\'])?([^\"\']*)';
           Matcher m = Pattern.compile(regex).matcher(imgURL);        
           if (m.find()){
               imgID = m.group(2); 
               photoflag = false;           
           }  else {
               imgID = ' ';
               photoflag = true;
            }    
       } else {
         imgID = ' ';
         photoflag = true;
       }
      
        
        /* Uppercase workaround */
          if ( project.MissionName__c != null )
           project.MissionName__c = project.MissionName__c.touppercase();
            
          if ( project.Sector_Name__c != null ){
            project.Sector_Name__c = project.Sector_Name__c.touppercase();
           } else {
            project.Sector_Name__c = ' ';   
           }
          if ( project.Primary_Initiative__c != null )
            project.Primary_Initiative__c = project.Primary_Initiative__c.touppercase();
          if ( project.Project_Subtype__c != null )
            project.Project_Subtype__c = project.Project_Subtype__c.touppercase(); 
          
          Date startDate,endDate ;
         if ( project.Start_Date__c != null ){
             startDate = project.Start_Date__c ;
             ProjstartDate = startDate.day() +'/'+startDate.month()+'/'+startDate.year();
         }
         if ( project.End_Date__c != null ){
             endDate = project.End_Date__c ;
             ProjendDate = endDate.day() +'/'+endDate.month()+'/'+endDate.year();
         }
         
         if ( project.Start_Date__c != null && project.End_Date__c != null ){ 
  
         Startyear = startDate.year();
         Endyear = endDate.year();
         Thisyear = system.now().year();
          
         yearsdiff =  startDate.monthsBetween(endDate)/12  ;
        }

        
        if(project == null) { throw new NullValueNotAllowedException(); } 
        
        AggregateResult[] AvgAmountArray =  [Select Avg(i.Award_Amount__c) From Implementing_Mechanism__c i
                                               Where i.Id in (SELECT Implementing_Mechanism_Number__c FROM Public_IM_Link__c WHERE Mission_Name__C = :project.MissionName__c)];
          
         if (AvgAmountArray[0].get('expr0') != null) {                                    
            AvgAmount = ((Decimal)AvgAmountArray[0].get('expr0')).round();
         } else {  
            AvgAmount  = 0;
         }

        // Get Project IM Link object to display Primary Partner field
        List<Public_IM_Link__c> primaryPartnersList = new List<Public_IM_Link__c>([Select 
         p.Project_Name__c, p.Implementing_Mechanism_Number__r.Partner_Name__c, 
        p.Implementing_Mechanism_Number__r.Award_Amount__c, p.Implementing_Mechanism_Number__r.Name, 
        p.Implementing_Mechanism_Number__c, p.Id From Public_IM_Link__c p 
        where p.Project_code__c = :projectId]);     //(Project_Code__r.Publicly_disclosable__c =:true) AND 
       
       
    Integer TotalPublicImLinks = primaryPartnersList.size() ;
        Decimal TotalAwardAmount ;
        primaryPartners = new List<String>();
        for(Public_IM_Link__c pp: primaryPartnersList) {
              imLink = pp;
              
              Implementing_Mechanism__c im = (Implementing_Mechanism__c)pp.Implementing_Mechanism_Number__r;
          if ( im.Award_Amount__c != null ){   
              AwardAmount  = AwardAmount  + im.Award_Amount__c; 
             // AvgAmount = AwardAmount  /  yearsdiff ;
             TotalAwardAmount = im.Award_Amount__c ;        
             
          }    
          
           if (im.Partner_Name__c != null){                  
                  imLink.Implementing_Mechanism_Number__r.Partner_Name__c = 
                    imLink.Implementing_Mechanism_Number__r.Partner_Name__c.toUppercase(); 
                    primaryPartners.add(im.Partner_Name__c.toUppercase());                 
               //break;
              }
            
          
        } 
       if(AwardAmount  == 0){ 
         AvgAmount = 0 ;
       }else {       
        // AvgAmount =       decimal.valueof( ( AwardAmount  / TotalPublicImLinks ).round() );
        // AvgAmount = AwardAmount  / SameMissionProjs ;
         AwardamountStr = '$ '+AwardAmount  +'';
       }
             
              
             /* if ( imLink.Implementing_Mechanism_Number__r.PrimaryPartner__r.Name != null ){
             //   imLink.Implementing_Mechanism_Number__r.PrimaryPartner__r.Name = 
             //       imLink.Implementing_Mechanism_Number__r.PrimaryPartner__r.Name.toUppercase();
             //       prtnerName =   imLink.Implementing_Mechanism_Number__r.PrimaryPartner__r.Name;
            
                  break;
              } */
            }  
          
         }
    public String getReferer(){
       return ApexPages.currentPage().getHeaders().get('Referer');
    }
    public class NullValueNotAllowedException extends Exception {}

}