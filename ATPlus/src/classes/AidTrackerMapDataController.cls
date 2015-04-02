public with sharing class AidTrackerMapDataController {
    // URL Parameters List
    public String CallBack {get; private set;}
    public String RequestAction {get; private set;}
    public String ProjectId {get; private set;}
    public String LocationRange {get; private set;}
    public String LocationFocus {get; private set;}
    public String ViewMode {get; private set;}
    // Filters
    public String FilterProvince {get; private set;}
    public Set<String> FilterSectors {get; private set;}
    public Set<String> FilterInitiatives {get; private set;}
    public Set<String> FilterReverseInitiative {get; private set;} //2013
    public Set<String> FilterSubInitiatives {get; private set;}
    public Set<String> FilterLocations {get; private set;}
    public Set<String> FilterOffices {get; private set;}
    public String FilterOrgUnit {get; private set;}
    public Date FilterStartDateFrom {get; private set;}
    public Date FilterStartDateTo {get; private set;} 
    // Internals
    public String proxy {get; private set;}
    public String error {get; private set;}
    public Boolean Internal {get; private set;}
    // Subclasses   
    public class CustomObjectProxy {
        public String label {get; set;}
        public String name {get; set;}
    }
    public class GeoCustomObjectProxy {//WHY CANNOT EXTEND?
        public String code {get; set;} //#2013
        public String label {get; set;}
        public String name {get; set;}      
        public String bound {get; set;}
        public String url {get; set;}
        public String parent {get; set;}
    }
    public class StartDateProxy {
        public Long a {get; set;}
        public Long b {get; set;}
    }  
    public class ProjectDetail {
        public Integer id {get; set;}
        public String country {get; set;}
        public String province {get; set;}
        public Integer total {get; set;}
    }  
    public class ProjectOverview {
        public Integer base {get; set;}
        public Integer top {get; set;}
        public Integer total {get; set;}
        public List<ProjectDetail> details {get; set;}
    }
    public class Snapshot {
        public List<CustomObjectProxy> sectors {get; set;}
        public List<GeoCustomObjectProxy> locations {get; set;}
        public List<CustomObjectProxy> initiatives {get; set;}
        public List<CustomObjectProxy> subinitiatives {get; set;}
        public List<CustomObjectProxy> offices {get; set;}        
        public List<GeoCustomObjectProxy> regions {get; set;}    
        public Map<String, String> boundaries {get; set;} //2013-02    
    }

    public AidTrackerMapDataController() {
        //System.Debug(LoggingLevel.INFO, ApexPages.currentPage().getUrl());
        //System.Debug(LoggingLevel.INFO, UserInfo.getSessionId());
        //System.Debug(LoggingLevel.INFO, UserInfo.getUserId());
        //System.Debug(LoggingLevel.INFO, UserInfo.getUserType());
        this.Internal = 'Guest'.equalsIgnoreCase(UserInfo.getUserType()) ? false : true;
        //System.Debug(LoggingLevel.INFO, this.Internal);
        this.CallBack = ApexPages.currentPage().getParameters().get('callback');
        this.RequestAction = ApexPages.currentPage().getParameters().get('r');
        this.ProjectId = ApexPages.currentPage().getParameters().get('d');
        this.FilterProvince = ApexPages.currentPage().getParameters().get('p');
        this.LocationRange = ApexPages.currentPage().getParameters().get('l');// global, regional, local
        this.FilterOrgUnit = ApexPages.currentPage().getParameters().get('m');
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
        this.ViewMode = ApexPages.currentPage().getParameters().get('v');
        if (this.ViewMode != 'flag') {
            this.ViewMode = 'cluster';
        }         
        // Take Snapshot (configures and per-defines)     
        Snapshot shot = this.takeSnapshot();
        // Recorrect Filters
        if (this.FilterLocations.size() == 0) {
            if (this.LocationRange == 'regional') {
                this.FilterLocations.clear();
                for (GeoCustomObjectProxy s : shot.locations) {
                    if (s.parent == this.LocationFocus) {
                        this.FilterLocations.add(s.name);
                    }
                }           
            } else if (this.LocationRange == 'local') {
                this.FilterLocations.clear();
                this.FilterLocations.add(this.LocationFocus);
            } else if (this.FilterOrgUnit != null && this.FilterOrgUnit.trim().length() > 0) {
                this.FilterLocations.clear();
                for (orgUnitGeography__c og : [SELECT cntryID__r.cntryName__c FROM orgUnitGeography__c WHERE orgUnitCode__c = :this.FilterOrgUnit]) {
                   this.FilterLocations.add(og.cntryID__r.cntryName__c);
                }
                if (this.FilterLocations.size() == 0) {
                    this.FilterLocations.add('none');
                }
            }
        }
        //2013 Recorrect initiatives
        this.FilterReverseInitiative = new Set<String>();
        if (shot.initiatives.size() == this.FilterInitiatives.size()) {//all checked === no filter
            this.FilterInitiatives.clear();
            this.FilterSubInitiatives.clear();
            this.FilterReverseInitiative.clear();
        }
        if (this.FilterInitiatives.contains('Others')) {
            // build reverse filter
            for (CustomObjectProxy f : shot.initiatives) {
                if (!this.FilterInitiatives.contains(f.name) && !'Others'.equalsIgnoreCase(f.name)) {
                    this.FilterReverseInitiative.add(f.name);
                }
            }
            this.FilterInitiatives.clear();
            this.FilterSubInitiatives.clear();
        }
        //2013  
    }
    
    // Supported REST Requests
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

    // Web Services
    // Get Snapshot in JSON    
    public String SnapShotJSON {
        get {
            return this.proxy != null ? this.proxy : JSON.serialize(this.takeSnapshot());
        }
        private set;
    }    
    // Covert project locations overview to JSON  - Cluster View
    public String OverviewJSON {
        get {
            return JSON.serialize(this.getProjectLocationSummaries());
        }
        private set;
    }
    // Covert projects (that have at least one location) overview to JSON - Flag View    
    public String MissionOverviewJSON {
        get {
            return JSON.serialize(this.getProjectSummaries());
        }
        private set;
    } 
    // Covert project list to JSON
    public String ProjectsJSON {
        get {
            return JSON.serialize(this.getProjectList());
        }
        private set;
    } 
    // Covert project details to JSON
    // 1. We want a empty object if nothing found
    // 2. To be safe in case query returns more than 1 result
    public String ProjectDetailsJSON {
        get {
            List<Project__c>  ps = this.getProjectDetail();
            return (ps != null && ps.size() == 1) ? JSON.serialize(ps.get(0)) : '{}';
        }
        private set;
    }
                 
    // Supported Request Handlers
    // Snapshot - called (one time only) when the first time map is loading
    public Snapshot takeSnapshot() {
        Snapshot s = new Snapshot();
        s.sectors = new List<CustomObjectProxy>();
        for (Sector__c ss : [SELECT secCode__c, secName__c FROM Sector__c]) {
            CustomObjectProxy cp = new CustomObjectProxy();
            cp.name = ss.secCode__c;
            cp.label = ss.secName__c;
            s.sectors.add(cp);
        }
        s.initiatives = new List<CustomObjectProxy>();
        for (Schema.PicklistEntry p : Project__c.Primary_Initiative__c.getDescribe().getPickListValues()) {
            CustomObjectProxy cp = new CustomObjectProxy();
            cp.name = p.getValue();
            cp.label = p.getLabel();
            s.initiatives.add(cp);
        }        
        //2013
        CustomObjectProxy cothers = new CustomObjectProxy();
        cothers.name = 'Others';
        cothers.label = 'Others';
        s.initiatives.add(cothers);    
        //2013          
        s.subinitiatives = new List<CustomObjectProxy>();
        for (Schema.PicklistEntry p : Project__c.Project_Subtype__c.getDescribe().getPickListValues()) {
            CustomObjectProxy cp = new CustomObjectProxy();
            cp.name = p.getValue();
            cp.label = p.getLabel();
            s.subinitiatives.add(cp);
        }  
        // #2013-02
        s.boundaries = new Map<String, String>();
        for (GeoBoundary__c gr : [SELECT cntryName__c, adminBndryName__c, adminBndryLatitude__c, adminBndryLongitude__c FROM GeoBoundary__c
                                  WHERE cntryId__r.visible__c = true or cntryId__r.Map_Preview__c = true]) {
            /*GeoCustomObjectProxy cp = new GeoCustomObjectProxy();
            cp.name = gr.adminBndryName__c + ',' + gr.cntryName__c;
            cp.bound = gr.adminBndryLatitude__c + ',' + gr.adminBndryLongitude__c;
            s.boundaries.add(cp);*/
            s.boundaries.put(gr.adminBndryName__c + ',' + gr.cntryName__c, gr.adminBndryLatitude__c + ',' + gr.adminBndryLongitude__c);
        }          
        //               
        s.locations = new List<GeoCustomObjectProxy>();
        List<geoCountry__c> loc;
        if (this.LocationRange == 'local' && this.LocationFocus != '') {
            loc = new List<geoCountry__c>([SELECT cntryCode__c, cntryName__c, cntrydispName__c, regName__c, regCode__c, cntryWebSiteURL__c, cntryBounds__c, Center_Latitude__c, Center_Longitude__c FROM geoCountry__c 
                                                                 WHERE visible__c = true AND (cntryName__c = :this.LocationFocus OR cntryCode__c = :this.LocationFocus)]);//2013
        } else if (this.LocationRange == 'regional' && this.LocationFocus != '') {
            loc = new List<geoCountry__c>([SELECT cntryCode__c, cntryName__c, cntrydispName__c, regName__c, regCode__c, cntryWebSiteURL__c, cntryBounds__c, Center_Latitude__c, Center_Longitude__c FROM geoCountry__c 
                                                                 WHERE visible__c = true AND (regName__c = :this.LocationFocus OR regCode__c = :this.LocationFocus)]);
        } else if (this.FilterOrgUnit != null && this.FilterOrgUnit.trim().length() > 0) {   
            Set<String> orgs = new Set<String>();
            for (orgUnitGeography__c og : [SELECT cntryID__r.cntryCode__c, cntryID__r.cntryName__c FROM orgUnitGeography__c WHERE orgUnitCode__c = :this.FilterOrgUnit]) {
               orgs.add(og.cntryID__r.cntryCode__c);
               //orgs.add(og.cntryCode__c);
            }
            if (orgs.size() == 0) {
                orgs.add('none');
            }                   
            loc = new List<geoCountry__c>([SELECT cntryCode__c, cntryName__c, cntrydispName__c, regName__c, regCode__c, cntryWebSiteURL__c, cntryBounds__c, Center_Latitude__c, Center_Longitude__c FROM geoCountry__c
                                           WHERE cntryCode__c IN :orgs]);
        } else {           
            loc = new List<geoCountry__c>([SELECT cntryCode__c, cntryName__c, cntrydispName__c, regName__c, regCode__c, cntryWebSiteURL__c, cntryBounds__c, Center_Latitude__c, Center_Longitude__c FROM geoCountry__c 
                                           WHERE visible__c = true]);
        }
        for (geoCountry__c gc : loc) {
            GeoCustomObjectProxy cp = new GeoCustomObjectProxy();
            cp.name = gc.cntryName__c;
            cp.label = gc.cntrydispName__c;
            cp.url = gc.cntryWebSiteURL__c;
            cp.bound = gc.cntryBounds__c;
            cp.parent = gc.regCode__c; //gc.regName__c;
            cp.code = gc.cntryCode__c; //2013
            s.locations.add(cp);  
            // #2013-02
            /*GeoCustomObjectProxy cb = new GeoCustomObjectProxy();
            cb.name = gc.cntryName__c;
            cb.bound = gc.Center_Latitude__c + ',' + gc.Center_Longitude__c;*/
            s.boundaries.put(gc.cntryName__c, gc.Center_Latitude__c + ',' + gc.Center_Longitude__c);                      
        }        
        s.regions = new List<GeoCustomObjectProxy>();
        for (geoRegion__c gr : [SELECT regCode__c, regName__c, regWebSiteURL__c, regBounds__c FROM geoRegion__c]) {
            GeoCustomObjectProxy cp = new GeoCustomObjectProxy();
            cp.name = gr.regCode__c;
            cp.label = gr.regName__c;
            cp.url = gr.regWebSiteURL__c;
            cp.bound = gr.regBounds__c;
            s.regions.add(cp);
        }        
        s.offices = new List<CustomObjectProxy>();

        return s;
    }
 
    // Get a summary of total project locations by country and province
    // For map "cluster" view
    // Note UI send requests by Country Name, not Mission Name
    public ProjectOverview getProjectLocationSummaries() {
        ProjectOverview theProject = new ProjectOverview();
        theProject.total = 0;
        theProject.base = 0;
        theProject.top = 0;
        theProject.details = new List<ProjectDetail>();
        Integer i = 0;
        AggregateResult[] details;
        List<String> conditions = new List<string>();
        Set<String> FilterLocations = this.FilterLocations;
        Set<String> FilterSectors = this.FilterSectors;
        Date FilterStartDateFrom =  this.FilterStartDateFrom;
        Date FilterStartDateTo = this.FilterStartDateTo;
        Set<String> FilterInitiatives = this.FilterInitiatives;
        Set<String> FilterSubInitiatives = this.FilterSubInitiatives;
        Set<String> FilterReverseInitiative = this.FilterReverseInitiative;//2013
        String proposed = 'Proposed'; 
        String q ='SELECT admin1BndryId__r.Name name, COUNT_DISTINCT(Project_Id__c) pn FROM Project_Location__c';      
        if (this.FilterLocations.size() != 0) {
            conditions.add('(cntryId__r.cntryName__c IN :FilterLocations OR cntryId__r.cntryCode__c IN :FilterLocations)');//2013
        }
        //System.debug('Filter Locations Diaplayed:::' +FilterLocations);
        if (this.FilterSectors.size() != 0) {
            conditions.add('secCode__c IN :FilterSectors');
        }
        if (this.FilterInitiatives.size() != 0) {
            conditions.add('Primary_Initiative__c IN :FilterInitiatives');
        }      
        if (this.FilterReverseInitiative.size() != 0) {
            conditions.add('Primary_Initiative__c NOT IN :FilterReverseInitiative');
        }            
        if (this.FilterSubInitiatives.size() != 0) {
            conditions.add('Project_Subtype__c IN :FilterSubInitiatives');
        }
        conditions.add('Start_Date__c >= :FilterStartDateFrom');
        conditions.add('Start_Date__c <= :FilterStartDateTo');        
        if (!this.Internal) {
            conditions.add('ActivityId__r.Project_Code__r.Status__c != :proposed');
            conditions.add('ActivityId__r.Project_Code__r.SBU__c = false');
            conditions.add('cntryId__r.visible__c = true');
        }          
        q += ' WHERE ' + conditions[0];
        for (Integer j = 1; j < conditions.size(); j++) {
            q += ' AND ' + conditions[j];
        }
        q += ' GROUP BY admin1BndryId__r.Name HAVING (count(Id) > 0) LIMIT 9999';
        for (AggregateResult c : Database.query(q)) {
            ProjectDetail p = new ProjectDetail();
            p.id = i;
            //System.Debug(LoggingLevel.INFO, ((String)c.get('name')));
            String[] fullName = ((String)c.get('name')).split('\\|'); // Country_Code | Country_Name | Province
            //System.Debug(LoggingLevel.INFO, fullName.size()); 
            if (fullName.size() != 3) continue;
            p.country = fullName[1].trim();
            p.province = fullName[2].trim();
            if (p.country == '' || p.province == '') continue;
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
        return theProject;
    }

    // Get a summary of total projects by country
    // For map "flag" view
    //
    public ProjectOverview getProjectSummaries() {
        ProjectOverview theProject = new ProjectOverview();
        theProject.total = 0;
        theProject.base = 0;
        theProject.top = 0;
        theProject.details = new List<ProjectDetail>();
        Integer i = 0;
        AggregateResult[] details;
        List<String> conditions = new List<string>();
        Set<String> FilterLocations = this.FilterLocations;
        Set<String> FilterSectors = this.FilterSectors;
        Date FilterStartDateFrom =  this.FilterStartDateFrom;
        Date FilterStartDateTo = this.FilterStartDateTo;
        Set<String> FilterInitiatives = this.FilterInitiatives;
        Set<String> FilterSubInitiatives = this.FilterSubInitiatives;
        Set<String> FilterReverseInitiative = this.FilterReverseInitiative;//2013
        String proposed = 'Proposed';
        String q ='SELECT cntryId__r.Name name, COUNT_DISTINCT(Project_Id__c) pn FROM Project_Location__c';
        if (this.FilterLocations.size() != 0) {
            conditions.add('(cntryId__r.cntryName__c IN :FilterLocations OR cntryId__r.cntryCode__c IN :FilterLocations)');//2013
        }
        if (this.FilterSectors.size() != 0) {
            conditions.add('secCode__c IN :FilterSectors');
        }
        if (this.FilterInitiatives.size() != 0) {
            conditions.add('Primary_Initiative__c IN :FilterInitiatives');
        }       
        if (this.FilterReverseInitiative.size() != 0) {
            conditions.add('Primary_Initiative__c NOT IN :FilterReverseInitiative');
        }         
        if (this.FilterSubInitiatives.size() != 0) {
            conditions.add('Project_Subtype__c IN :FilterSubInitiatives');//Text(ActivityId__r.Project_Code__r.Project_Subtype__c)
        }
        conditions.add('Start_Date__c >= :FilterStartDateFrom');
        conditions.add('Start_Date__c <= :FilterStartDateTo');        
        if (!this.Internal) {
            conditions.add('ActivityId__r.Project_Code__r.Status__c != :proposed');
            conditions.add('ActivityId__r.Project_Code__r.SBU__c = false');
            conditions.add('cntryId__r.visible__c = true');
        }          
        q += ' WHERE ' + conditions[0];
        for (Integer j = 1; j < conditions.size(); j++) {
            q += ' AND ' + conditions[j];
        }
        q += '  GROUP BY cntryId__r.Name LIMIT 9999';//HAVING (COUNT_DISTINCT(Project_Id__c) > 0) 
        for (AggregateResult c : Database.query(q)) {
            ProjectDetail p = new ProjectDetail();
            p.id = i;
            //System.Debug(LoggingLevel.INFO, ((String)c.get('name')));
            String[] fullName = ((String)c.get('name')).split('\\|'); // Country_Code | Country_Name
            //System.Debug(LoggingLevel.INFO, fullName.size()); 
            if (fullName.size() != 2) continue;
            p.country = fullName[1].trim();//code
            if (p.country == '') continue;
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
        return theProject;
    }

    // Get a list of projects in given province and/or country
    // When user clicks on a cluster or country flag
    public List<Project__c> getProjectList() {
        List<String> conditions = new List<string>();
        Set<String> FilterLocations = this.FilterLocations;
        Set<String> FilterSectors = this.FilterSectors;
        Date FilterStartDateFrom =  this.FilterStartDateFrom;
        Date FilterStartDateTo = this.FilterStartDateTo;
        Set<String> FilterInitiatives = this.FilterInitiatives;
        Set<String> FilterSubInitiatives = this.FilterSubInitiatives;
        Set<String> FilterReverseInitiative = this.FilterReverseInitiative;//2013
        String FilterProvince = this.FilterProvince;
        String proposed = 'Proposed';
        String q ='Select cntryId__c, ActivityId__r.Project_Code__c pc From Project_Location__c';// Group By  cntryId__c, ActivityId__r.Project_Id__c';// group by cntryId__r.Name, ActivityId__r.Project_Id__c';
        if (this.FilterLocations.size() != 0) {
            conditions.add('(cntryId__r.cntryName__c IN :FilterLocations OR cntryId__r.cntryCode__c IN :FilterLocations)');//2013
        }
        if (this.FilterSectors.size() != 0) {
            conditions.add('secCode__c IN :FilterSectors');
        }
        if (this.FilterInitiatives.size() != 0) {
            conditions.add('Primary_Initiative__c IN :FilterInitiatives');
        }      
        if (this.FilterReverseInitiative.size() != 0) {
            conditions.add('Primary_Initiative__c NOT IN :FilterReverseInitiative');
        }            
        if (this.FilterSubInitiatives.size() != 0) {
            conditions.add('Project_Subtype__c IN :FilterSubInitiatives');
        }
        conditions.add('Start_Date__c >= :FilterStartDateFrom');
        conditions.add('Start_Date__c <= :FilterStartDateTo');
        if (this.FilterProvince != null && this.FilterProvince != '') {
            conditions.add('admin1BndryName__c = :FilterProvince');
        }        
        if (!this.Internal) {
            conditions.add('ActivityId__r.Project_Code__r.Status__c != :proposed');
            conditions.add('ActivityId__r.Project_Code__r.SBU__c = false');
            conditions.add('cntryId__r.visible__c = true');
        }
          
        q += ' WHERE ' + conditions[0];
        for (Integer j = 1; j < conditions.size(); j++) {
            q += ' AND ' + conditions[j];
        }
        q += '  GROUP BY cntryId__c, ActivityId__r.Project_Code__c LIMIT 9999';
        Set<ID> projectIds = new Set<ID>();
        for (AggregateResult c : Database.query(q)) {
            projectIds.add((ID)c.get('pc'));
        }
        return [SELECT Public_Name__c, Id FROM Project__c WHERE Id IN :projectIds  ORDER BY Public_Name__c];
    }  
   
    // Get individual project details by its ID
    // When user clicks Project Detail link
    public List<Project__c> getProjectDetail() {
        List<Project__c> ps = new List<Project__c>();
        if (!this.Internal) {
            ps = [Select Id, Public_Name__c, secName__c, Start_Date__c, End_Date__c, Public_Photo__c, Project_Description__c, Primary_Initiative__c, (SELECT Implementing_Mechanism_Number__r.Award_Amount__c, Implementing_Mechanism_Number__r.Partner_Name__c FROM ImpMechs_Projects__r) From Project__c 
                    Where Id = :this.ProjectId
                    AND (SBU__c = false AND Status__c != 'Proposed')
                    Limit 1];
        } else {
            ps = [Select Id, Public_Name__c, secName__c, Start_Date__c, End_Date__c, Public_Photo__c, Project_Description__c, Primary_Initiative__c, (SELECT Implementing_Mechanism_Number__r.Award_Amount__c, Implementing_Mechanism_Number__r.Partner_Name__c FROM ImpMechs_Projects__r) From Project__c 
                    Where Id = :this.ProjectId
                    Limit 1];        
        }        
        return ps;
    }

    public Boolean requestProjectDetailLocations {
        get {
            return (this.RequestAction != null) && this.RequestAction.equalsIgnoreCase('pd');
        }
        private set;
    }      
    public String ProjectDetailLocationsJSON {
        get {
            return JSON.serialize(this.retrieveProjectDetailLocations());
        }
        private set;
    } 
    public List<Project_Location__c> retrieveProjectDetailLocations() {
        String projectId = ApexPages.currentPage().getParameters().get('id');
        String projectId15 = projectId;
        if (projectId != null && projectId.length() == 18) {
            projectId15 = projectId.left(15);
        }
        if (projectId15 != projectId) {// id is 18 characters
            return [SELECT admin1BndryName__c , admin1BndryLatitude__c, admin1BndryLongitude__c FROM Project_Location__c WHERE (Project_Id__c = :projectId OR Project_Id__c = :projectId15)];
        } else {// 15
            projectId = projectId + '___';
            return [SELECT admin1BndryName__c , admin1BndryLatitude__c, admin1BndryLongitude__c FROM Project_Location__c WHERE (Project_Id__c  like :projectId)];           
        }
    }        
}