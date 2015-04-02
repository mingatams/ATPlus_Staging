public with sharing class PlaceLocatorController {
  
    public Id objId {public get; private set;}
    public Project_Location__c obj {public get; private set;}
    //public String addressOrName {public get; private set;}
    public String autoSearch {public get; private set;}
   
    public PlaceLocatorController(ApexPages.StandardController stdController) {
        this.objId = stdController.getId();
        obj = [SELECT Id, Name, address__c, admin1BndryLatitude__c, admin1BndryLongitude__c, cntryId__c, admin1BndryId__c,admin2BndryName__c, City__c, Project_Code__c, ActivityId__c, Latitude__c, Longitude__c FROM Project_Location__c WHERE (Id = :this.objId) LIMIT 1];    
        autoSearch = (obj.admin1BndryLatitude__c == null || obj.admin1BndryLongitude__c == null) ? 'true' : 'false';
    }
  
    public Decimal Latitude {public get; public set;}
    public Decimal Longitude {public get; public set;}
    public String Country {public get; public set;}
    public String State {public get; public set;}
    public String Region {public get; public set;}
    public String City {public get; public set;}
    public String Location_Name {public get; public set;}
    public String Extent {public get; public set;}
  
    public String getAddressOrName() {
        String addr = obj.address__c;
        if (addr == null || addr.trim().length() == 0) {
            addr = obj.Name;
        }  
    
        List<Activity__c> activity = new List<Activity__c>([SELECT Id, Project_Code__c, ouType__c, ouName__c FROM Activity__c WHERE Id=:obj.ActivityId__c LIMIT 1]);     
        
        if (activity.size() > 0 && activity[0].ouType__c == 'Field Mission')
            addr = addr + ', ' + activity[0].ouName__c;
        return addr;
    }

/*    public PageReference doLocation() {

        //Query Geo Country
        List<geoCountry__c> geoCountry = new List<geoCountry__c>([SELECT Id, cntrydispName__c, cntryName__c FROM geoCountry__c WHERE cntrydispName__c =:Country LIMIT 1]);
        if(geoCountry.size() > 0) {
            obj.cntryId__c = geoCountry[0].Id;
            //Query Geo Boundary
            List<GeoBoundary__c> geoBoundary = new List<GeoBoundary__c>([SELECT Id, adminBndryLatitude__c, adminBndryLongitude__c FROM GeoBoundary__c WHERE cntryId__c =:geoCountry[0].Id AND adminBndryName__c =:State LIMIT 1]);
            if(geoBoundary.size() > 0) 
                obj.admin1BndryId__c = geoBoundary[0].Id;
        }
        obj.Latitude__c = Latitude;
        obj.Longitude__c = Longitude;
        obj.admin2BndryName__c = Region;
        obj.City__c = City;
    
        if (obj.address__c == null) {
            obj.Name = Location_Name;
        }
        obj.address__c = Location_Name;

        autoSearch = 'false';
        update obj;
        return null;
    } */
    public PageReference doLocation() {

        obj.Latitude__c = Latitude;
        obj.Longitude__c = Longitude;
        obj.admin2BndryName__c = Region;
        obj.City__c = City;
        obj.Precision_Extent__c = Extent;
        
        if(obj.Precision_Extent__c == null) {
            obj.Precision_Extent__c = '4 - First Order Admin';
        }
    
        if (obj.address__c == null) {
            obj.Name = Location_Name;
        }
        obj.address__c = Location_Name;

        Set<String> countries = new Set<String>();
        //Query Geo Country
        List<geoCountry__c> geoCountry = new List<geoCountry__c>([SELECT Id, cntrydispName__c, cntryName__c FROM geoCountry__c WHERE cntrydispName__c =:Country LIMIT 1]);
        List<Activity__c> activity = new List<Activity__c>([SELECT Id, Project_Code__c, ouType__c, ouName__c, ouId__c FROM Activity__c WHERE Id=:obj.ActivityId__c LIMIT 1]); 
        if (activity.size() > 0 && activity[0].ouType__c == 'Field Mission') {
            countries.add(activity[0].ouName__c);
        } else if (activity.size() > 0) {
            System.Debug(activity[0]);
            List<orgUnitGeography__c> geo = new List<orgUnitGeography__c>([SELECT Id, orgUnitName__c, orgUnitId__c, cntryName__c FROM orgUnitGeography__c WHERE orgUnitId__c=:activity[0].ouId__c]);
            for(orgUnitGeography__c g : geo) {
                countries.add(g.cntryName__c);
            }
        }
       
        System.Debug(countries);
        System.Debug(Country);
        System.Debug(geoCountry);
        if(countries.size() > 0 && countries.contains(Country) && geoCountry.size() > 0 ) {
            obj.cntryId__c = geoCountry[0].Id;
            //Query Geo Boundary
            List<GeoBoundary__c> geoBoundary = new List<GeoBoundary__c>([SELECT Id, adminBndryLatitude__c, adminBndryLongitude__c FROM GeoBoundary__c WHERE cntryId__c =:geoCountry[0].Id AND adminBndryName__c =:State LIMIT 1]);
            if(geoBoundary.size() > 0) {
                obj.admin1BndryId__c = geoBoundary[0].Id; 
            } else {
               //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Selected State is not valid. Please try again.'));  
               return null;                
            }
        } else { 
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Selected Country is not valid. Please try again.'));  
            return null;
        }

        autoSearch = 'false';
        System.Debug(obj);
        update obj;        
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
}