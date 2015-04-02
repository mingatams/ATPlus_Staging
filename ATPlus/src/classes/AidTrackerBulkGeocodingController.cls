public with sharing class AidTrackerBulkGeocodingController {

    public String activityId {get; set;} 
    public String activityPath {get; set;} 
    public String countryId {get; set;} 
    public Boolean displayErrorMsg {get;set;} 
    public String jobId {get;set;} 
    public Boolean jobDone {get;set;} 
    public String jobError {get;set;} 
    public Activity__c theActivity {get;set;} 
    public List<SelectOption> countries {get; set;}
    public Map<String, String> countryBounds {get; set;}
    public AidTrackerBulkGeocodingController() {
        activityId = ApexPages.currentPage().getParameters().get('activityId');
        activityPath = ApexPages.currentPage().getParameters().get('retURL'); 
        countries = getCountryItems();
    }
    
    private Map<String, String> retrieveGeoBoundary() {
        String c = ApexPages.currentPage().getParameters().get('countryName');   
        Map<String, String> boundaries = new Map<String, String>();
        for (GeoBoundary__c gr : [SELECT cntryName__c, cntryId__c, adminBndryName__c, adminBndryLatitude__c, adminBndryLongitude__c FROM GeoBoundary__c
                                  WHERE cntryId__r.visible__c = true
                                  AND cntryName__c = :c]) {
            if (countryId == null) countryId = gr.cntryId__c; 
            boundaries.put(gr.adminBndryName__c + ',' + gr.cntryName__c, gr.adminBndryLatitude__c + ',' + gr.adminBndryLongitude__c);
        }
        return boundaries;
    }
    
    public String GeoBoundaryJSON {
        get {
            return JSON.serialize(this.retrieveGeoBoundary());
        }
        private set;
    }   
    
    public String CountryBoundJSON {
        get {
            return JSON.serialize(this.countryBounds);
        }
        private set;
    } 
        
    public void startGeocoding () {
        //return null;
    }  
    
    public PageReference saveLocation() {
        this.jobDone = false;
        this.jobError = '';
        String name = ApexPages.currentPage().getParameters().get('locationName');
        this.jobId = ApexPages.currentPage().getParameters().get('rowId');
        List<Project_Location__c> checkLocation = [SELECT Id, ActivityId__c FROM Project_Location__c WHERE Name=:name AND ActivityId__c =:activityId ];
        if (checkLocation != null && checkLocation.size() > 0) {
            displayErrorMsg = true;  
            jobError = 'The location "' + name + '" already exists.';
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The location "' + name + '" already exists.'));  
            return null;
        }          
        String boundary = ApexPages.currentPage().getParameters().get('boundary');
        List<GeoBoundary__c> gcs = [SELECT Id FROM GeoBoundary__c
                                  WHERE cntryId__r.visible__c = true
                                  AND adminBndryName__c = :boundary
                                  AND cntryId__c = :countryId];
        if (gcs == null || gcs.size() == 0) {
            displayErrorMsg = true;  
            jobError = 'The Admin 1 boundary name is invalid.';
            //jobError = 'The boundary "' + boundary + '" does not exists.';            
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The boundary "' + boundary + '" does not exists.'));  
            return null;
        }                                  
        String lat = ApexPages.currentPage().getParameters().get('latitude');
        String lng = ApexPages.currentPage().getParameters().get('longitude');
        String city = ApexPages.currentPage().getParameters().get('city');
        String address = ApexPages.currentPage().getParameters().get('address');
        String admin2 = ApexPages.currentPage().getParameters().get('admin2boundary');
        String funding = ApexPages.currentPage().getParameters().get('funding');
        String info = ApexPages.currentPage().getParameters().get('info');
        String extent = ApexPages.currentPage().getParameters().get('extent');
        String method = ApexPages.currentPage().getParameters().get('method');
        Project_Location__c loc = new Project_Location__c(
           ActivityId__c = activityId,
           cntryId__c = countryId,
           Method__c = (String.isBlank(method)) ? 'Bulk Geocoding' : method,
           Name = name,
           admin1BndryId__c = gcs[0].Id,
           Latitude__c = Decimal.valueOf(lat),
           Longitude__c = Decimal.valueOf(lng),
           address__c = address,
           City__c = city,
           Location_Funding_Amount__c = (funding == null) ? 0 : Decimal.valueOf(funding),
           Precision_Extent__c = extent,
           admin2BndryName__c = admin2,
           Additional_Location_Information__c = info
        );
        try {
           upsert loc;
           this.jobDone = true;
        } catch (System.DmlException e) {
            displayErrorMsg = true;  
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getDmlMessage(0)));  
            for (Integer i = 0; i < e.getNumDml(); i++) {          
                System.Debug(e.getDmlMessage(i));
                jobError += e.getDmlMessage(i);   
            }
        }
        return null;
    }     
     
    private List<SelectOption> getCountryItems(){
        countryBounds = new Map<String, String>();
        List<selectOption> options = new List<selectOption>();
        List<Activity__c> activity = [SELECT Id, Activity_Code__c, Activity_Name__c, Activity_Start_Date__c, Activity_End_Date__c, Project_Name__c, Project_Code__c, ImpMech_Name__c, ImpMech_Id__c, ouId__c,ouType__c, ouName__c
                                        FROM Activity__c WHERE Id=:activityId];     
        if (activity.size() > 0) {
            theActivity = activity[0];
            String unit = activity[0].ouId__c;
            String countryName = '';
            List<orgUnitGeography__c> countries = [SELECT cntryID__r.cntryName__c, cntryID__r.altCntryName__c, cntryID__r.cntrydispName__c, cntryID__r.cntryBounds__c FROM orgUnitGeography__c WHERE orgUnitId__c = :unit ORDER BY cntryID__r.cntryName__c];
            for (orgUnitGeography__c c : countries) {
                options.add(new selectOption(c.cntryID__r.cntryName__c, c.cntryID__r.cntryName__c ));
                countryBounds.put(c.cntryID__r.cntryName__c, c.cntryID__r.cntryBounds__c);
            }
        }       
        return options;        
    } 
    
    public PageReference cancel() {   
        PageReference page = new PageReference(activityPath);
        page.setRedirect(true);
        return page;
    }      
    
    
    @IsTest public static void testAidTrackerBulkGeocodingController(){
         ClsTestUtility testIndicatorUtil = new ClsTestUtility();
         String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
         Project__c projectId = testIndicatorUtil.getIMProjectRecordForOrgId(OrgUnitId);
         Implementing_Mechanism__c imId = testIndicatorUtil.getIMRecordForOrgId(OrgUnitId);         
         String taskId = testIndicatorUtil.getTask(imId.ID, projectId.Id);
         String PImId = testIndicatorUtil.getPublicIMLinkId(imId.ID, projectId.ID);
         GeoRegion__c gr = testIndicatorUtil.getGeoRegion();
         GeoCountry__c gc = testIndicatorUtil.getGeoCountry(gr.Id);
         OrgUnitGeography__c og = testIndicatorUtil.getOrgUnitGeography(OrgUnitId,gc.Id);
         List<GeoBoundary__c> gbList = testIndicatorUtil.getGeoBoundary(gc.Id);
         
         
         Test.Starttest() ; 
         Test.setCurrentPage(new PageReference('/apex/AidTrackerBulkGeocoding'));
         ApexPages.currentPage().getParameters().put('ActivityID', taskId);
         ApexPages.currentPage().getParameters().put('retURL','/'+taskId);
         ApexPages.currentPage().getParameters().put('countryName', 'India');
         ApexPages.currentPage().getParameters().put('locationName', 'Rajasthan');
         
         
         ApexPages.currentPage().getParameters().put('latitude', '20.000');
         ApexPages.currentPage().getParameters().put('longitude', '70.000');
         ApexPages.currentPage().getParameters().put('city', 'Rajasthan');
         ApexPages.currentPage().getParameters().put('address', '1234 Address');
         ApexPages.currentPage().getParameters().put('admin2boundary', '');
         ApexPages.currentPage().getParameters().put('info', 'Info');
         ApexPages.currentPage().getParameters().put('extent', 'Exact');
         ApexPages.currentPage().getParameters().put('method', 'Bulk Geo Code');
         ApexPages.currentPage().getParameters().put('boundary', 'Rajasthan');
         AidTrackerBulkGeocodingController controller = new AidTrackerBulkGeocodingController();
         
         controller.retrieveGeoBoundary();
         controller.activityId = taskId;
         controller.countryId = gc.Id;
         controller.saveLocation();    
         controller.cancel();
                 
         Test.Stoptest(); 
         
     }     
}