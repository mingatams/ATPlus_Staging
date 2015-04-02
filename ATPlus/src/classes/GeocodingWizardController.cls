/*
 * This class is the controller behind the Geocoding wizard. The new wizard is comprised of two pages, 
 * each of which utilizes the same instance of this controller.
 */ 
public with sharing class GeocodingWizardController {

    private ApexPages.standardController stdController = null;
    public Project_Location__c location;
    public String activityPath {get; set;} 
    public String activityId {get; set;} 
    //public String projectCode {get; set;}
    public String queryString {get; set;}
    public String autoSearch {public get; private set;}     
    public Boolean displayAdminCountry {get;set;}
    public Boolean displayErrorMsg {get;set;} 
    public String geoCountryName {get; set;}
    
    public GeocodingWizardController(ApexPages.StandardController controller) {
    
        stdController = controller;
    
        // Check cookies for popup display
        Cookie welcomePopup = ApexPages.currentPage().getCookies().get('welcomePopup');
        if(welcomePopup == null) {
            showPopup();
        }

        // Get parameters from URL
        activityPath = ApexPages.currentPage().getParameters().get('retURL');
        activityId = ApexPages.currentPage().getParameters().get('ActivityID');       
        //projectCode = ApexPages.currentPage().getParameters().get('ProjectCode');
        if(activityPath != null || activityId != null) {            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Parameter Exists'));
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Parameter does not exist'));
        } 

        // Get url for SaveAndNew
        PageReference thisPage = ApexPages.currentPage();
        List<String> url = thisPage.getUrl().split('\\?');
        if(url.size() > 1 ) {
            queryString = url[1];
        } 
        displayAdminCountry = false; 
        displayErrorMsg = false;       
    }

    /**
     * If this is the first time the method is called, it creates an empty record for the variable. 
     */
    public Project_Location__c getLocation() {
        if(location == null) location = new Project_Location__c();        
        //if(projectCode != null || projectCode != '') { location.Project_Code__c = projectCode; } 
        if(activityId != null || activityId != '') { location.ActivityId__c = activityId; }
        
        return location;
    }
    
    /**
     * The next two methods are used to control navigation through the wizard.
     * Each returns a reference to one of the two pages in the wizard. 
     */
    public PageReference step1() {
        return Page.GeoWizardStep1;
    }
    public PageReference step2() {
        autoSearch = (location.admin1BndryLatitude__c == null || location.admin1BndryLongitude__c == null) ? 'true' : 'false';        
        return Page.GeoWizardStep2;
    }

    /** 
     * Performs the final save, and then navigates the user to the detail page for the new Location. 
     */ 
    public PageReference save() {
        //location = getLocation();
      //  try {
            String locName = location.Name;
            List<Project_Location__c> checkLocation = new List<Project_Location__c>([SELECT Id, ActivityId__c FROM Project_Location__c WHERE Name=:locName]);
            for(Project_Location__c loc: checkLocation) {
                if(loc.ActivityId__c == location.ActivityId__c) {
                    displayErrorMsg = true;  
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The location "' + location.Name + '" already exists.'));  
                    return null;
                }
            }
            //System.debug('In Save method before Boundary Id check:::R:::' +location.admin1BndryId__c+ ':::L::'+location.cntryId__c);
            if(location.admin1BndryId__c == null || location.cntryId__c == null) {
                displayErrorMsg = true;  
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The required fields Admin 1 Boundary and Country cannot be empty. Please select valid location.'));  
                return null;                
            }
            location.Method__c = 'Geo Coding';   
            
            try {
                Database.upsert(location);
            } catch (System.DmlException e) {
                for (Integer i = 0; i < e.getNumDml(); i++) {          
                    System.Debug(e.getDmlMessage(i));   
                }
            }
                
            //upsert location;       
   /*     }
        catch (DMLException e) {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The location "' + location.Name + '" already exists.'));  
            return null; 
        } */

        // Send the user to the detail page for the new location. 
        PageReference locPage = new PageReference('/' + location.id);
        locPage.setRedirect(true);
        return locPage;
    }

    /**
     * Performs a save, and then navigates the user to the beginning of the wizard. 
     * And creates a new location object to start a new location entry.
     */ 
    public PageReference saveAndNew() {    

        //try {
        
            String locName = location.Name;
            List<Project_Location__c> checkLocation = new List<Project_Location__c>([SELECT Id, ActivityId__c FROM Project_Location__c WHERE Name=:locName]);
            for(Project_Location__c loc: checkLocation) {
                if(loc.ActivityId__c == location.ActivityId__c) {
                    displayErrorMsg = true;  
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The location "' + location.Name + '" already exists.'));  
                    return null;
                }
            }
            //System.debug('In Save and new method before Boundary Id check:::R:::' +location.admin1BndryId__c+ ':::L::'+location.cntryId__c);
            if(location.admin1BndryId__c == null || location.cntryId__c == null) {
                displayErrorMsg = true;  
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The required fields Admin 1 Boundary and Country cannot be empty. Please select valid location.'));  
                return null;                
            }
            location.Method__c = 'Geo Coding';    
            upsert location; 
             
 /*       } catch (DMLException e) {  
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The location "' + location.Name + '" already exists.'));  
            return null; 
        }*/

        // Send the user to the beginning of the wizard. 
        PageReference locPage = new PageReference('/apex/GeoWizardStep1?' + queryString);
        locPage.setRedirect(true);
        return locPage;
    }

    /*
     * Cancel wizard.
     */    
    public PageReference cancel() {     
        PageReference page = new PageReference(activityPath);
        page.setRedirect(true);
        return page;
    }
    
    public Boolean displayPopup {get; set;} 
    public Boolean checkboxSelected {get; set;}   

   /*
    * Popup window.
    */    
    public void showPopup() { 
        displayPopup = true; 
    }
    public void closePopup() {    
        // Check if the checkbox was selected
        if(checkboxSelected == true) {
            Cookie welcomePopup = ApexPages.currentPage().getCookies().get('welcomePopup');
            if(welcomePopup == null) {
                welcomePopup = new Cookie('welcomePopup', 'false', null, 315360000, false);
                ApexPages.currentPage().setCookies(new Cookie[]{welcomePopup});
            }
        }               
        // Close popup
        displayPopup = false; 
    }
    
    
    /*
     * Places Locator controller.
     *
     */
    public Decimal Latitude {public get; public set;}
    public Decimal Longitude {public get; public set;}
    public String Country {public get; public set;}
    public String State {public get; public set;}
    public String Region {public get; public set;}
    public String City {public get; public set;}
    public String Location_Name {public get; public set;}
    public String Extent {public get; public set;}   
 
    public String getAddressOrName() {
        String addr = location.address__c;
        if (addr == null || addr.trim().length() == 0) {
            addr = location.Name;
        }
        String c = location.cntryId__c;
        List<geoCountry__c> countries = [SELECT Id, altCntryName__c, cntrydispName__c, cntryName__c FROM geoCountry__c 
                                        WHERE Id =:c LIMIT 1];
        if (countries.size() > 0) {
            String countryName = countries[0].altCntryName__c;
            if (String.isBlank(countryName)) {
                countryName = countries[0].cntryName__c;
                geoCountryName = countries[0].cntryName__c;
            } else {
                geoCountryName = countryName;
            }    
            addr = addr + ', ' + countryName;
            
        }                                
        
        /*        List<Activity__c> activity = new List<Activity__c>([SELECT Id, Project_Code__c, ouId__c,ouType__c, ouName__c FROM Activity__c WHERE Id=:activityId LIMIT 1]);     
        
        if (activity.size() > 0) {// && activity[0].ouType__c == 'Field Mission') {
            // check org unit geo country list
            String unit = activity[0].ouId__c;
            String countryName = '';
            List<orgUnitGeography__c> countries = [SELECT cntryID__r.cntryName__c, cntryID__r.altCntryName__c FROM orgUnitGeography__c WHERE orgUnitId__c = :unit];
            if (countries != null && countries.size() == 1) {
               countryName = countries[0].cntryID__r.altCntryName__c;
               if (String.isBlank(countryName)) countryName = countries[0].cntryID__r.cntryName__c;
               addr = addr + ', ' + countryName;
               geoCountryName = countries[0].cntryID__r.cntryName__c; // we use this one to save
            }
        }*/
        return addr;
    }
     
    public PageReference doLocation() {

        Set<String> countries = new Set<String>();
        //Query Geo Country
        List<geoCountry__c> geoCountry = [SELECT Id, altCntryName__c, cntrydispName__c, cntryName__c FROM geoCountry__c 
                                        WHERE altCntryName__c =:Country OR cntryName__c = :Country  OR cntrydispName__c = :Country LIMIT 1];
        /*List<Activity__c> activity = new List<Activity__c>([SELECT Id, Project_Code__c, ouType__c, ouName__c, ouId__c FROM Activity__c WHERE Id=:activityId LIMIT 1]); 
        if (activity.size() > 0 && activity[0].ouType__c == 'Field Mission') {
            countries.add(activity[0].ouName__c);
        } else
        if (activity.size() > 0) {
            List<orgUnitGeography__c> geo = new List<orgUnitGeography__c>([SELECT Id, cntryID__r.cntryName__c, orgUnitName__c, orgUnitId__c, cntryName__c FROM orgUnitGeography__c WHERE orgUnitId__c=:activity[0].ouId__c]);
            for(orgUnitGeography__c g : geo) {           
                //if (!String.isBlank(g.cntryID__r.altCntryName__c)) {
                //    countries.add(g.cntryID__r.altCntryName__c);
                //} else {
                    countries.add(g.cntryID__r.cntryName__c);
                //}
            }
        }*/
        //System.Debug('Display Countries:'+countries+':Geo Country:'+geoCountry+':State From Geo:'+State);
        //if(countries.size() > 0 && countries.contains(Country) && geoCountry.size() > 0 ) {
            if (!geoCountry.isEmpty()){
                location.cntryId__c = geoCountry[0].Id;
                //Query Geo Boundary
                List<GeoBoundary__c> geoBoundary = new List<GeoBoundary__c>([SELECT Id, adminBndryLatitude__c, adminBndryLongitude__c FROM GeoBoundary__c WHERE cntryId__c =:geoCountry[0].Id AND adminBndryName__c =:State LIMIT 1]);
                if(geoBoundary.size() > 0) {
                    location.admin1BndryId__c = geoBoundary[0].Id;
                } else {
                    displayErrorMsg = true;  
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Admin 1 Boundary. Please Geo Code again or manually input Admin 1 Boundary.'));
                    displayAdminCountry = true;  
                    return null;                
                }
            } else {
                displayErrorMsg = true;  
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Country. Please Geo Code again or manually input Country.'));
                displayAdminCountry = true;  
                return null;               
            }   
        //} else {
        //    displayErrorMsg = true;  
        //    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Selected Country is not valid. Please try again.'));  
        //    return null;
        //}
        
        location.Latitude__c = Latitude;
        location.Longitude__c = Longitude;
        location.admin2BndryName__c = Region;
        location.City__c = City;
        location.Precision_Extent__c = Extent;
        
        if(location.Precision_Extent__c == null) {
            location.Precision_Extent__c = '4 - First Order Admin';
        }
    
        if (location.address__c == null) {
            location.Name = Location_Name;
        }
        location.address__c = Location_Name;

        autoSearch = 'false';
        displayAdminCountry = true;
        return null;
    }
      
    public Decimal North {
        get {
            //g2maps__Settings__c settings = g2maps__Settings__c.getInstance();
            //if (settings == null || settings.g2maps__Include_North__c == null) return 90;
            //return settings.g2maps__Include_North__c; 
            return 90;
        }
    }
    public Decimal South {
        get {
            //g2maps__Settings__c settings = g2maps__Settings__c.getInstance();
            //if (settings == null || settings.g2maps__Include_South__c == null) return -90;
            //return settings.g2maps__Include_South__c;
            return -90;
        }
    }
    public Decimal East {
        get {
            //g2maps__Settings__c settings = g2maps__Settings__c.getInstance();
            //if (settings == null || settings.g2maps__Include_East__c == null) return 180;
            //return settings.g2maps__Include_East__c;
            return 180;
        }
   }
    public Decimal West {
        get {
            //g2maps__Settings__c settings = g2maps__Settings__c.getInstance();
            //if (settings == null || settings.g2maps__Include_West__c == null) return -180;
            //return settings.g2maps__Include_West__c;
            return -180;
        }
    }

    public List<SelectOption> getCountryList(){
        List<selectOption> options = new List<selectOption>();
        List<Activity__c> activity = new List<Activity__c>([SELECT Id, Project_Code__c, ouId__c,ouType__c, ouName__c FROM Activity__c WHERE Id=:activityId LIMIT 1]);     
        if (activity.size() > 0) {
            String unit = activity[0].ouId__c;
            String countryName = '';
            List<orgUnitGeography__c> countries = [SELECT cntryID__r.cntryName__c, cntryID__r.altCntryName__c, cntryID__r.cntrydispName__c FROM orgUnitGeography__c WHERE orgUnitId__c = :unit];
            for (orgUnitGeography__c c : countries) {
                options.add(new selectOption(c.cntryID__c, c.cntryID__r.cntryName__c ));
            }
        }       
        return options;        
    }
}