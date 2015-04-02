public with sharing class PlacesLocatorController {
  
  public Id objId {public get; private set;}
  public Location1__c obj {public get; private set;}
  //public String addressOrName {public get; private set;}
  public String autoSearch {public get; private set;}
  
  public PlacesLocatorController(ApexPages.StandardController stdController) {
    this.objId = stdController.getId();
    
    obj = [SELECT Id, Name, Activity_Location_Address__c , Activity_Location_Latitude__c, Activity_Location_Longitude__c, Activity_Location_Country__c, Activity_Location_Province__c,Activity_Location_Region__c,Activity_Location_City__c, Project_Code__c, Project_Code__r.MissionName__c FROM Location1__c WHERE (Id = :this.objId) LIMIT 1];
    //addressOrName = obj.Location_Address__c;
    //if (addressOrName == null || addressOrName.trim().length() == 0) {
    //addressOrName = obj.Name; // Search by address doesn't work
    //}
    autoSearch = (obj.Activity_Location_Latitude__c == null || obj.Activity_Location_Longitude__c == null) ? 'true' : 'false';
  }
  
  public Decimal Latitude {public get; public set;}
  public Decimal Longitude {public get; public set;}
  public String Country {public get; public set;}
  public String State {public get; public set;}
  public String Region {public get; public set;}
  public String City {public get; public set;}
  public String Location_Name {public get; public set;}
  
  public String getAddressOrName() {
    String addr = obj.Activity_Location_Address__c;
    if (addr == null || addr.trim().length() == 0) {
      addr = obj.Name;
    }
    
    if (obj.Project_Code__c != null && obj.Project_Code__r.MissionName__c != null)
        addr = addr + ', ' + obj.Project_Code__r.MissionName__c;
    
    return addr;
  }
      
  public PageReference doLocation() {

    obj.Activity_Location_Latitude__c = Latitude;
    obj.Activity_Location_Longitude__c = Longitude;
    obj.Activity_Location_Country__c = Country;
    obj.Activity_Location_Province__c = State;
    obj.Activity_Location_Region__c = Region;
    obj.Activity_Location_City__c = City;

    if (obj.Activity_Location_Address__c == null) {
        obj.Name = Location_Name;
    }
    obj.Activity_Location_Address__c = Location_Name;
    
    update obj;
 /*   try { update obj; }
    catch (DMLException e) {  
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The location already exists.'));  
            return null; 
    }*/
    
    return null;
  }

  
  public Decimal North {
    get {
        g2maps__Settings__c settings = g2maps__Settings__c.getInstance();
        if (settings == null || settings.g2maps__Include_North__c == null) return 90;
        return settings.g2maps__Include_North__c;
    }
  }
  
  public Decimal South {
    get {
        g2maps__Settings__c settings = g2maps__Settings__c.getInstance();
        if (settings == null || settings.g2maps__Include_South__c == null) return -90;
        return settings.g2maps__Include_South__c;
    }
  }
  
  public Decimal East {
    get {
        g2maps__Settings__c settings = g2maps__Settings__c.getInstance();
        if (settings == null || settings.g2maps__Include_East__c == null) return 180;
        return settings.g2maps__Include_East__c;
    }
  }
  
  public Decimal West {
    get {
        g2maps__Settings__c settings = g2maps__Settings__c.getInstance();
        if (settings == null || settings.g2maps__Include_West__c == null) return -180;
        return settings.g2maps__Include_West__c;
    }
  }
}