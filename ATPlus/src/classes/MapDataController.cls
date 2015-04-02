public with sharing class MapDataController {
    public String CallBack {get; private set;}
    public String RequestAction {get; private set;}
    public String FilterProvince {get; private set;}
    public Set<String> FilterSectors {get; private set;}
    public Set<String> FilterInitiatives {get; private set;}
    public Set<String> FilterSubInitiatives {get; private set;}
    public Set<String> FilterLocations {get; private set;}
    public Date FilterStartDateFrom {get; private set;}
    public Date FilterStartDateTo {get; private set;} 
    public String ProjectId {get; private set;}
    public SnapShot SnapShot {get; private set;}
    public String SnapShotJSON {get; private set;}
    public String error {get; private set;}
    public String LocationRange {get; private set;}
    public String LocationFocus {get; private set;}
    public Set<String> LocationNames {get; private set;}
    public String ViewMode {get; private set;}
    static String[] PreDefinedInitiatives = new String[] {
        'Global Health Initiative',
        'Feed the Future'
    };  
    public MapDataController() {
        System.Debug(LoggingLevel.INFO, ApexPages.currentPage().getUrl());
        this.ProjectId = ApexPages.currentPage().getParameters().get('d');
        this.FilterProvince = ApexPages.currentPage().getParameters().get('p');
        this.CallBack = ApexPages.currentPage().getParameters().get('callback');
        this.RequestAction = ApexPages.currentPage().getParameters().get('r');
        this.LocationRange = ApexPages.currentPage().getParameters().get('l');// global, regional, local
        if (this.LocationRange == null || this.LocationRange.length() == 0) {
            this.LocationRange = '';
        }
        this.LocationFocus = ApexPages.currentPage().getParameters().get('w');// asia, kneya etc.
        if (this.LocationFocus == null || this.LocationFocus.length() == 0) {
            this.LocationFocus = '';
        }        
        this.FilterSectors = new Set<String>();
        String ss = ApexPages.currentPage().getParameters().get('s');
        if (ss != null && ss.length() > 0) {
            for (String s : ss.split(':::')) {
                this.FilterSectors.add(s);
            }
        }            
        this.FilterInitiatives = new Set<String>();
        ss = ApexPages.currentPage().getParameters().get('i');
        if ( ss != null && ss.length() > 0) {
            for (String s : ss.split(':::')) {
                this.FilterInitiatives.add(s);
            }
        } 
        this.FilterSubInitiatives = new Set<String>();
        ss = ApexPages.currentPage().getParameters().get('u');
        if ( ss != null && ss.length() > 0) {
            for (String s : ss.split(':::')) {
                this.FilterSubInitiatives.add(s);
            }
        }         
        this.FilterLocations = new Set<String>();
        ss = ApexPages.currentPage().getParameters().get('c');
        if (ss != null && ss.length() > 0) {
            for (String s : ss.split(':::')) {
                this.FilterLocations.add(s);
            }
        } 
        this.FilterStartDateFrom = Datetime.newInstance(1992,0,1).date();//1992-01-01
        String ff = ApexPages.currentPage().getParameters().get('f'); 
        if (ff != null && ff.length() > 0) {
            this.FilterStartDateFrom = Datetime.newInstance(Long.valueOf(ff)).date();
        } 
        this.FilterStartDateTo = datetime.now().date();//today
        String tt = ApexPages.currentPage().getParameters().get('t'); 
        if (tt != null && tt.length() > 0) {
            this.FilterStartDateTo = Datetime.newInstance(Long.valueOf(tt)).date();
        } 
        this.SnapShot = this.takeSnapshot();
        this.LocationNames = new Set<String>();
        for (MissionInfo__c s : this.SnapShot.locations) {
           this.LocationNames.add(s.Name);
        }
        if (this.FilterSectors.size() == 0) {
            for (Sector s : this.SnapShot.sectors) {
                this.FilterSectors.add(s.name);
            }
        }
        if (this.FilterLocations.size() == 0) {
            if (this.LocationRange == 'regional') {
                for (MissionInfo__c s : this.SnapShot.locations) {
                    if (s.Region__c == this.LocationFocus) {
                        this.FilterLocations.add(s.Name);
                    }
                }           
            } else if (this.LocationRange == 'local') {
                for (MissionInfo__c s : this.SnapShot.locations) {
                    if (s.Name == this.LocationFocus) {
                        this.FilterLocations.add(s.Name);
                        break;
                    }
                }
            }  
            if (this.LocationRange == '' || this.LocationFocus == '' || this.FilterLocations.size() == 0) {
                this.FilterLocations.clear();
                for (MissionInfo__c s : this.SnapShot.locations) {
                    this.FilterLocations.add(s.Name);
                }
            }          
        }
        this.ViewMode = ApexPages.currentPage().getParameters().get('v');
        if (this.ViewMode != 'flag') {
            this.ViewMode = 'cluster';
        }
        this.SnapShotJSON = JSON.serialize(this.SnapShot);
    }
    // REST Requests
    public Boolean requestSnapshot {
        get {
            return (this.RequestAction != null) && this.RequestAction.equalsIgnoreCase('snapshot');
        }
        private set;
    }
    public Boolean requestProjectsOverview {
        get {
            return (this.RequestAction != null) && this.RequestAction.equalsIgnoreCase('overview');
        }
        private set;
    }   
    public Boolean requestProjects {
        get {
            return (this.RequestAction != null) && this.RequestAction.equalsIgnoreCase('projects');
        }
        private set;
    }  
    public Boolean requestProjectDetails {
        get {
            return (this.RequestAction != null) && this.RequestAction.equalsIgnoreCase('detail');
        }
        private set;
    }   
    // Subclasses   
    public class Sector {
        public Integer id {get; set;}
        public String label {get; set;}
        public String name {get; set;}
    }
    public class Region {
        public Integer id {get; set;}
        public String label {get; set;}
        public String name {get; set;}
    }     
    public class Initiative {
        public Integer id {get; set;}
        public String label {get; set;}
        public String name {get; set;}
    }  
    public class StartDate {
        public Long a {get; set;}
        public Long b {get; set;}
    }  
    public class ProjectDetail {
        public Integer id {get; set;}
        public String country {get; set;}
        public String province {get; set;}
        public Integer total {get; set;}
    }  
    public class Project {
        public Integer base {get; set;}
        public Integer top {get; set;}
        public Integer total {get; set;}
        public List<ProjectDetail> details {get; set;}
    }   
    public class Snapshot {
        public List<Sector> sectors {get; set;}
        public List<MissionInfo__c> locations {get; set;}
        public List<Initiative> initiatives {get; set;}
        public List<Initiative> subinitiatives {get; set;}
        //public Map<String, String[]> regions {get; set;}
        public List<Region> regions {get; set;}
        
    }
    // Actions
    // Snapshot - called (one time only) when the first time map is loading
    public Snapshot takeSnapshot() {
        Snapshot s = new Snapshot();
        s.sectors = this.Sectors;
        s.initiatives = this.Initiatives;
        s.subinitiatives = this.SubInitiatives;
        s.locations = this.Locations;
        s.regions = this.Regions;
        return s;
    }
    public List<Sector> Sectors {
        get {
            List<Sector> ss = new List<Sector>();
            Integer i = 0;
            for (Schema.PicklistEntry p : Project__c.Sector_Name__c.getDescribe().getPickListValues()) {
            //for (Integer i = 0 ; i < PreDefinedSectors.size(); i++) {
                Sector s = new Sector();
                s.id = i++;//i;//i++;
                s.name = p.getValue();//PreDefinedSectors[i];//p.getValue();
                s.label = s.name;
                ss.add(s);
            }
            return ss;//JSON.serialize(ss);
        }
        private set;
    }
    public List<Region> Regions {
        get {
            List<Region> rr = new List<Region>();
            Integer i = 0;
            for (Schema.PicklistEntry p : MissionInfo__c.Region__c.getDescribe().getPickListValues()) {
                Region r = new Region();
                r.id = i++;
                r.name = p.getValue();
                r.label = r.name;
                rr.add(r);
            }
            return rr;
        }
        private set;
    }
    public List<MissionInfo__c> Locations {
        get {
            List<MissionInfo__c> loc;
            if (this.LocationRange == 'local' && this.LocationFocus != '') {
                loc = new List<MissionInfo__c>([SELECT Name, Display_Name__c, Region__c, Website__c, Bound__c FROM MissionInfo__c 
                                                                     WHERE Visible__c = true AND Name = :this.LocationFocus]);

            } else if (this.LocationRange == 'regional' && this.LocationFocus != '') {
                loc = new List<MissionInfo__c>([SELECT Name, Display_Name__c, Region__c, Website__c, Bound__c FROM MissionInfo__c 
                                                                     WHERE Visible__c = true AND Region__c = :this.LocationFocus]);

            } else if (this.LocationRange == 'mission' && this.LocationFocus != '') {
                loc = new List<MissionInfo__c>([SELECT Name, Display_Name__c, Region__c, Website__c, Bound__c FROM MissionInfo__c 
                                                                     WHERE  Name = :this.LocationFocus]);
            } else {
                loc = new List<MissionInfo__c>([SELECT Name, Display_Name__c, Region__c, Website__c, Bound__c FROM MissionInfo__c WHERE Visible__c = true]);
            }
            return loc;//JSON.serialize(loc);
        }
        private set;
    }    
    public List<Initiative> Initiatives {
        get {
            //Integer i = 0;
            List<Initiative> init = new List<Initiative>();
            for (Integer i = 0 ; i < PreDefinedInitiatives.size(); i++) {   
            //for (Schema.PicklistEntry p : Project__c.Primary_Initiative__c.getDescribe().getPickListValues()) {
                Initiative v = new Initiative();
                v.id = i;// i++;
                v.name = PreDefinedInitiatives[i];//p.getValue();
                v.label = v.name;//p.getLabel();
                init.add(v);
            }
            return init;//JSON.serialize(init);
        }
        private set;
    }  
    public List<Initiative> SubInitiatives {
        get {
            Integer i = 0;
            List<Initiative> init = new List<Initiative>(); 
            for (Schema.PicklistEntry p : Project__c.Project_Subtype__c.getDescribe().getPickListValues()) {
                Initiative v = new Initiative();
                v.id = i++;
                v.name = p.getValue();
                v.label = p.getLabel();
                init.add(v);
            }
            return init;
        }
        private set;
    }

    // Get a summary of total project locations by country and province
    // For map "cluster" view
    // Note UI send requests by Country Name, not Mission Name
    public Project getProjectLocationSummaries() {
        Project theProject = new Project();
        theProject.total = 0;
        theProject.base = 0;
        theProject.top = 0;
        theProject.details = new List<ProjectDetail>();
        Integer i = 0;
        AggregateResult[] details;
        if (this.FilterInitiatives.size() == 0) {//Project_Subtype__c
            if (this.FilterSubInitiatives.size() == 0) {
                details = ([SELECT Region__c, count(Project__c) pn, Country__c FROM Project_Region__c 
                            WHERE Project__r.Sector_Name__c IN :this.FilterSectors
                            AND Project__r.Start_Date__c >= :this.FilterStartDateFrom
                            AND Project__r.Start_Date__c <= :this.FilterStartDateTo
                            AND Project__r.Status__c != 'Proposed'
                            AND Project__r.SBU__c = false
                            AND Region__c != null 
                            AND Project__c != null 
                            AND Country__c IN :this.LocationNames
                            AND Country__c IN :this.FilterLocations
                            //AND (Project__r.SBU__c = true AND Project__r.Publish_Status__c = 'Published')
                            GROUP BY Region__c, Country__c 
                            HAVING count(Project__c) > 0 Limit 9999]);
           } else {
                details = ([SELECT Region__c, count(Project__c) pn, Country__c FROM Project_Region__c 
                            WHERE Project__r.Sector_Name__c IN :this.FilterSectors
                            AND Project__r.Project_Subtype__c IN: this.FilterSubInitiatives
                            AND Project__r.Start_Date__c >= :this.FilterStartDateFrom
                            AND Project__r.Start_Date__c <= :this.FilterStartDateTo
                            AND Project__r.Status__c != 'Proposed'
                            AND Project__r.SBU__c = false
                            AND Region__c != null 
                            AND Project__c != null 
                            AND Country__c IN :this.LocationNames
                            AND Country__c IN :this.FilterLocations
                            //AND (Project__r.SBU__c = true AND Project__r.Publish_Status__c = 'Published')
                            GROUP BY Region__c, Country__c 
                            HAVING count(Project__c) > 0 Limit 9999]);               
           }
        } else {
            if (this.FilterSubInitiatives.size() == 0) {
                details = ([SELECT Region__c, count(Project__c) pn, Country__c FROM Project_Region__c 
                            WHERE Project__r.Sector_Name__c IN :this.FilterSectors
                            AND Project__r.Primary_Initiative__c IN: this.FilterInitiatives
                            AND Project__r.Start_Date__c >= :this.FilterStartDateFrom
                            AND Project__r.Start_Date__c <= :this.FilterStartDateTo
                            AND Project__r.Status__c != 'Proposed'
                            AND Project__r.SBU__c = false                            
                            AND Region__c != null 
                            AND Project__c != null 
                            AND Country__c IN :this.LocationNames
                            AND Country__c IN :this.FilterLocations
                            //AND (Project__r.SBU__c = true AND Project__r.Publish_Status__c = 'Published')
                            GROUP BY Region__c, Country__c 
                            HAVING count(Project__c) > 0 Limit 9999]);  
           } else {
               details = ([SELECT Region__c, count(Project__c) pn, Country__c FROM Project_Region__c 
                            WHERE Project__r.Sector_Name__c IN :this.FilterSectors
                            AND Project__r.Primary_Initiative__c IN: this.FilterInitiatives
                            AND Project__r.Project_Subtype__c IN: this.FilterSubInitiatives
                            AND Project__r.Start_Date__c >= :this.FilterStartDateFrom
                            AND Project__r.Start_Date__c <= :this.FilterStartDateTo
                            AND Project__r.Status__c != 'Proposed'
                            AND Project__r.SBU__c = false                           
                            AND Region__c != null 
                            AND Project__c != null 
                            AND Country__c IN :this.LocationNames
                            AND Country__c IN :this.FilterLocations
                            //AND (Project__r.SBU__c = true AND Project__r.Publish_Status__c = 'Published')
                            GROUP BY Region__c, Country__c 
                            HAVING count(Project__c) > 0 Limit 9999]);           
           }    
        }
        for (AggregateResult c : details) {
            ProjectDetail p = new ProjectDetail();
            p.id = i;
            p.country = (String)c.get('Country__c');
            p.province = (String)c.get('Region__c'); 
            if (p.country == null || p.province == null) continue;
            p.total = (Integer)c.get('pn');
            theProject.details.add(p);
            theProject.total = theProject.total + p.total;
            if (i == 0) {
                theProject.base = p.total;
                theProject.top = p.total;
            }
            if (p.total < theProject.base) {
                theProject.base = p.total;
            }
            if (p.total > theProject.top) {
                theProject.top = p.total;
            }
            i = i + 1;
        }
        return theProject;//JSON.serialize(theProject);
    }
    // Covert project locations overview to JSON    
    public String OverviewJSON {
        get {
            return JSON.serialize(this.getProjectLocationSummaries());
        }
        private set;
    }
    // Get a summary of total projects by country
    // For map "flag" view
    public Project getProjectSummaries() {
        Project theProject = new Project();
        theProject.total = 0;
        theProject.base = 0;
        theProject.top = 0;
        theProject.details = new List<ProjectDetail>();
        AggregateResult[] details;
        if (this.FilterInitiatives.size() == 0) {//Project_Subtype__c
            if (this.FilterSubInitiatives.size() == 0) {
                details = ([SELECT Activity_Location_Country__c, Project_Code__c FROM Location1__c
                            WHERE Activity_Location_Country__c IN :this.FilterLocations
                            AND Project_Code__r.Sector_Name__c IN :this.FilterSectors
                            //AND Project_Code__r.Primary_Initiative__c IN: this.FilterInitiatives
                            //AND Project_Code__r.Project_Subtype__c IN: this.FilterSubInitiatives
                            AND Project_Code__r.Start_Date__c >= :this.FilterStartDateFrom
                            AND Project_Code__r.Start_Date__c <= :this.FilterStartDateTo  
                            AND Project_Code__r.Status__c != 'Proposed'
                            AND Project_Code__r.SBU__c = false
                            GROUP BY Activity_Location_Country__c, Project_Code__c
                            ORDER BY Activity_Location_Country__c, Project_Code__c]);
           } else {
                details = ([SELECT Activity_Location_Country__c, Project_Code__c FROM Location1__c
                            WHERE Activity_Location_Country__c IN :this.FilterLocations
                            AND Project_Code__r.Sector_Name__c IN :this.FilterSectors
                            //AND Project_Code__r.Primary_Initiative__c IN: this.FilterInitiatives
                            AND Project_Code__r.Project_Subtype__c IN: this.FilterSubInitiatives
                            AND Project_Code__r.Start_Date__c >= :this.FilterStartDateFrom
                            AND Project_Code__r.Start_Date__c <= :this.FilterStartDateTo  
                            AND Project_Code__r.Status__c != 'Proposed'
                            AND Project_Code__r.SBU__c = false
                            GROUP BY Activity_Location_Country__c, Project_Code__c
                            ORDER BY Activity_Location_Country__c, Project_Code__c]);              
           }
        } else {
            if (this.FilterSubInitiatives.size() == 0) {
                details = ([SELECT Activity_Location_Country__c, Project_Code__c FROM Location1__c
                            WHERE Activity_Location_Country__c IN :this.FilterLocations
                            AND Project_Code__r.Sector_Name__c IN :this.FilterSectors
                            AND Project_Code__r.Primary_Initiative__c IN: this.FilterInitiatives
                            //AND Project_Code__r.Project_Subtype__c IN: this.FilterSubInitiatives
                            AND Project_Code__r.Start_Date__c >= :this.FilterStartDateFrom
                            AND Project_Code__r.Start_Date__c <= :this.FilterStartDateTo  
                            AND Project_Code__r.Status__c != 'Proposed'
                            AND Project_Code__r.SBU__c = false
                            GROUP BY Activity_Location_Country__c, Project_Code__c
                            ORDER BY Activity_Location_Country__c, Project_Code__c]);
           } else {
                details = ([SELECT Activity_Location_Country__c, Project_Code__c FROM Location1__c
                            WHERE Activity_Location_Country__c IN :this.FilterLocations
                            AND Project_Code__r.Sector_Name__c IN :this.FilterSectors
                            AND Project_Code__r.Primary_Initiative__c IN: this.FilterInitiatives
                            AND Project_Code__r.Project_Subtype__c IN: this.FilterSubInitiatives
                            AND Project_Code__r.Start_Date__c >= :this.FilterStartDateFrom
                            AND Project_Code__r.Start_Date__c <= :this.FilterStartDateTo  
                            AND Project_Code__r.Status__c != 'Proposed'
                            AND Project_Code__r.SBU__c = false
                            GROUP BY Activity_Location_Country__c, Project_Code__c
                            ORDER BY Activity_Location_Country__c, Project_Code__c]);            
           }    
        }
        String lastCountry = null;
        Integer lastCountryCount = 0;
        Integer countryIndex = 0;
        String cc = null;
        for (AggregateResult c : details) {
            cc = (String)c.get('Activity_Location_Country__c');
            if (cc == null || cc == '') continue;
            if (countryIndex == 0) {
                lastCountry = cc;
                countryIndex = countryIndex + 1;
            }
            if (cc == lastCountry) {// same country, add one
                lastCountryCount = lastCountryCount + 1;
                continue;
            } else {// another country
                ProjectDetail p = new ProjectDetail();
                p.id = countryIndex;
                p.country = lastCountry;
                p.total = lastCountryCount;
                lastCountry = cc;
                lastCountryCount = 0;
                // grand total
                theProject.details.add(p);
                theProject.total = theProject.total + p.total;
                if (countryIndex == 1) {
                    theProject.base = p.total;
                    theProject.top = p.total;
                }
                if (p.total < theProject.base) {
                    theProject.base = p.total;
                }
                if (p.total > theProject.top) {
                    theProject.top = p.total;
                }    
                countryIndex = countryIndex + 1;            
            }
        }
        if (details.size() > 0) {
            ProjectDetail p = new ProjectDetail();
            p.id = countryIndex;
            p.country = cc;
            p.total = lastCountryCount + 1;
            theProject.details.add(p);
            theProject.total = theProject.total + p.total;
            if (countryIndex == 1) {
                theProject.base = p.total;
                theProject.top = p.total;
            }
            if (p.total < theProject.base) {
                theProject.base = p.total;
            }
            if (p.total > theProject.top) {
                theProject.top = p.total;
            }       
        }       
      
        return theProject;
    }
    // Covert projects (that have at least one location) overview to JSON    
    public String MissionOverviewJSON {
        get {
            return JSON.serialize(this.getProjectSummaries());
        }
        private set;
    }
    // Get a list of projects in given province and/or country
    // When user clicks on a cluster or country flag
    public List<Project__c> Projects {
        get {
            List<Project__c> ps = new List<Project__c>();
            if (this.FilterProvince == null || this.FilterProvince.length() == 0) {
                if (this.FilterInitiatives.size() == 0) {
                    if (this.FilterSubInitiatives.size() == 0) {
                        ps = [Select Project_Name__c, Public_Name__c, Id From Project__c 
                              Where Id 
                              IN (Select Project_Code__c From Location1__c 
                                WHERE Activity_Location_Country__c IN :this.FilterLocations
                                And Project_Code__r.Sector_Name__c IN :this.FilterSectors
                                And Project_Code__r.Start_Date__c >= :this.FilterStartDateFrom
                                And Project_Code__r.Start_Date__c <= :this.FilterStartDateTo   
                                AND Project_Code__r.Status__c != 'Proposed'
                                AND Project_Code__r.SBU__c = false 
                              //AND (SBU__c = true AND Publish_Status__c = 'Published')
                                ) 
                              //AND MissionName__c IN :this.LocationNames
                              Limit 9999];   
                   } else {
                        ps = [Select Project_Name__c, Public_Name__c, Id From Project__c 
                              Where Id 
                              IN (Select Project_Code__c From Location1__c 
                                WHERE Activity_Location_Country__c IN :this.FilterLocations
                                And Project_Code__r.Sector_Name__c IN :this.FilterSectors
                                AND Project_Code__r.Project_Subtype__c IN: this.FilterSubInitiatives
                                And Project_Code__r.Start_Date__c >= :this.FilterStartDateFrom
                                And Project_Code__r.Start_Date__c <= :this.FilterStartDateTo  
                                AND Project_Code__r.Status__c != 'Proposed'
                                AND Project_Code__r.SBU__c = false   
                              //AND (SBU__c = true AND Publish_Status__c = 'Published')
                                ) 
                              //AND MissionName__c IN :this.LocationNames
                              Limit 9999];                   
                   }               
                } else {
                    if (this.FilterSubInitiatives.size() == 0) {
                        ps = [Select Project_Name__c, Public_Name__c, Id From Project__c 
                              Where Id 
                              IN (Select Project_Code__c From Location1__c 
                                WHERE Activity_Location_Country__c IN :this.FilterLocations
                                And Project_Code__r.Sector_Name__c IN :this.FilterSectors
                                And Project_Code__r.Primary_Initiative__c IN: this.FilterInitiatives
                                And Project_Code__r.Start_Date__c >= :this.FilterStartDateFrom
                                And Project_Code__r.Start_Date__c <= :this.FilterStartDateTo   
                                AND Project_Code__r.Status__c != 'Proposed'
                                AND Project_Code__r.SBU__c = false   
                              //AND (SBU__c = true AND Publish_Status__c = 'Published')
                                )
                              //AND MissionName__c IN :this.LocationNames
                              Limit 9999];
                    } else {
                        ps = [Select Project_Name__c, Public_Name__c, Id From Project__c 
                              Where Id 
                              IN (Select Project_Code__c From Location1__c 
                                WHERE Activity_Location_Country__c IN :this.FilterLocations
                                And Project_Code__r.Sector_Name__c IN :this.FilterSectors
                                And Project_Code__r.Primary_Initiative__c IN: this.FilterInitiatives
                                AND Project_Code__r.Project_Subtype__c IN: this.FilterSubInitiatives
                                And Project_Code__r.Start_Date__c >= :this.FilterStartDateFrom
                                And Project_Code__r.Start_Date__c <= :this.FilterStartDateTo
                                AND Project_Code__r.Status__c != 'Proposed'
                                AND Project_Code__r.SBU__c = false     
                              //AND (SBU__c = true AND Publish_Status__c = 'Published')
                                )
                              //AND MissionName__c IN :this.LocationNames
                              Limit 9999];                    
                    }
                }
            } else {
                if (this.FilterInitiatives.size() == 0) {
                    if (this.FilterSubInitiatives.size() == 0) {
                        ps = [Select Project_Name__c, Public_Name__c, Id From Project__c 
                              Where Id 
                              IN (Select Project_Code__c From Location1__c 
                                Where Activity_Location_Province__c = :this.FilterProvince
                                AND Activity_Location_Country__c IN :this.FilterLocations
                                And Project_Code__r.Sector_Name__c IN :this.FilterSectors
                                And Project_Code__r.Start_Date__c >= :this.FilterStartDateFrom
                                And Project_Code__r.Start_Date__c <= :this.FilterStartDateTo   
                                AND Project_Code__r.Status__c != 'Proposed'
                                AND Project_Code__r.SBU__c = false 
                              //AND (SBU__c = true AND Publish_Status__c = 'Published')
                                ) 
                              //AND MissionName__c IN :this.LocationNames
                              Limit 9999];   
                   } else {
                        ps = [Select Project_Name__c, Public_Name__c, Id From Project__c 
                              Where Id 
                              IN (Select Project_Code__c From Location1__c 
                                Where Activity_Location_Province__c = :this.FilterProvince
                                AND Activity_Location_Country__c IN :this.FilterLocations
                                And Project_Code__r.Sector_Name__c IN :this.FilterSectors
                                AND Project_Code__r.Project_Subtype__c IN: this.FilterSubInitiatives
                                And Project_Code__r.Start_Date__c >= :this.FilterStartDateFrom
                                And Project_Code__r.Start_Date__c <= :this.FilterStartDateTo  
                                AND Project_Code__r.Status__c != 'Proposed'
                                AND Project_Code__r.SBU__c = false   
                              //AND (SBU__c = true AND Publish_Status__c = 'Published')
                                ) 
                              //AND MissionName__c IN :this.LocationNames
                              Limit 9999];                   
                   }               
                } else {
                    if (this.FilterSubInitiatives.size() == 0) {
                        ps = [Select Project_Name__c, Public_Name__c, Id From Project__c 
                              Where Id 
                              IN (Select Project_Code__c From Location1__c 
                                Where Activity_Location_Province__c = :this.FilterProvince
                                AND Activity_Location_Country__c IN :this.FilterLocations
                                And Project_Code__r.Sector_Name__c IN :this.FilterSectors
                                And Project_Code__r.Primary_Initiative__c IN: this.FilterInitiatives
                                And Project_Code__r.Start_Date__c >= :this.FilterStartDateFrom
                                And Project_Code__r.Start_Date__c <= :this.FilterStartDateTo   
                                AND Project_Code__r.Status__c != 'Proposed'
                                AND Project_Code__r.SBU__c = false   
                              //AND (SBU__c = true AND Publish_Status__c = 'Published')
                                )
                              //AND MissionName__c IN :this.LocationNames
                              Limit 9999];
                    } else {
                        ps = [Select Project_Name__c, Public_Name__c, Id From Project__c 
                              Where Id 
                              IN (Select Project_Code__c From Location1__c 
                                Where Activity_Location_Province__c = :this.FilterProvince
                                AND Activity_Location_Country__c IN :this.FilterLocations
                                And Project_Code__r.Sector_Name__c IN :this.FilterSectors
                                And Project_Code__r.Primary_Initiative__c IN: this.FilterInitiatives
                                AND Project_Code__r.Project_Subtype__c IN: this.FilterSubInitiatives
                                And Project_Code__r.Start_Date__c >= :this.FilterStartDateFrom
                                And Project_Code__r.Start_Date__c <= :this.FilterStartDateTo
                                AND Project_Code__r.Status__c != 'Proposed'
                                AND Project_Code__r.SBU__c = false     
                              //AND (SBU__c = true AND Publish_Status__c = 'Published')
                                )
                              //AND MissionName__c IN :this.LocationNames
                              Limit 9999];                    
                    }
                }
            }
            return ps;
        }
        private set;
    }  
    // Covert project list to JSON
    public String ProjectsJSON {
        get {
            return JSON.serialize(this.Projects);
        }
        private set;
    }      
    // Get individual project details by its ID
    // When user clicks Project Detail link
    public List<Project__c> ProjectDetails {
        get {
            List<Project__c> ps = new List<Project__c>();
            ps = [Select Id, Project_Name__c, Public_Name__c, toLabel(MissionName__c), Sector_Name__c, Start_Date__c, End_Date__c, Public_Photo__c, Project_Theme__c, Project_Description__c, Primary_Initiative__c, Provinces__c, (SELECT Implementing_Mechanism_Number__r.Award_Amount__c, Implementing_Mechanism_Number__r.Partner_Name__c FROM ImpMechs_Projects__r) From Project__c 
                    Where Id = :this.ProjectId
                    //AND (SBU__c = true AND Publish_Status__c = 'Published')
                    Limit 1];
            return ps;
        }
        private set;
    }
    // Covert project details to JSON
    // 1. We want a empty object if nothing found
    // 2. To be safe in case query returns more than 1 result
    public String ProjectDetailsJSON {
        get {
            List<Project__c>  ps = this.ProjectDetails;
            return (ps != null && ps.size() == 1) ? JSON.serialize(ps.get(0)) : '{}';
        }
        private set;
    }    


    
    public List<Location1__c> LocationList {
        public get {
            if (LocationList == null) {
                LocationList = new List<Location1__c>([
                    SELECT Project_Code__r.Primary_Initiative__c, Project_Code__r.Sector_Name__c, Project_Code__r.Project_Name__c, Project_Code__r.End_Date__c, Project_Code__r.Start_Date__c, Project_Code__r.Name, Name, Activity_Location_Province__c, Activity_Location_Country__c
                    FROM Location1__c
                    // WHERE (SBU__c = true AND Publish_Status__c = 'Published')
                    //AND (Project_Code__r.SBU__c = true AND Project_Code__r.Publish_Status__c = 'Published')
                    Limit 999]
                );
            }
            return LocationList;
        }
        private set;
    }
   
}