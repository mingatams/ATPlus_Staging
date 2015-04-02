global with sharing class DataEnrichmentController {

    global static List <Location1__c> location { get; set; }

    public DataEnrichmentController() { }
    
    @RemoteAction
    global static List<Location1__c> getLocation() {
    
        location = new List<Location1__c>([SELECT Id, Activity_Location_Latitude__c, Activity_Location_Longitude__c, Activity_Location_Province__c, Activity_Location_Country__c, isEnrich__c FROM Location1__c WHERE isEnrich__c=:false LIMIT 200]); 
        
        return location;
    }
/*    
    @RemoteAction
    global static PageReference updateLocation(Id locId, String state, String country) {

        Location1__c loc =  [SELECT Id, Activity_Location_Province__c, Activity_Location_Country__c, isEnriched__c FROM Location1__c WHERE id =:locId ];

        loc.Activity_Location_Province__c = state;
        loc.Activity_Location_Country__c = country;
        loc.isEnriched__c = true;
        
        update loc;
    
        return null;
    } 
*/    
    @RemoteAction
    global static PageReference updateLocations(List<Location1__c> loc) {

/*        try {update loc;
        } catch(Exception e) {
        	update location;
        }
*/
		update loc;    
        return null;
    }
 
    public void resetEnriched() {
        List<Location1__c> locEnrich = new List<Location1__c> ([SELECT Id, isEnrich__c FROM Location1__c WHERE isEnrich__c=:true LIMIT 500]);
        
        Integer counter = 0;
        while(true) {
            List<Location1__c> Enrich = new List<Location1__c> ([SELECT Id, isEnrich__c FROM Location1__c LIMIT 500]);
            
            for(Location1__c loc: Enrich) {
                loc.isEnrich__c = false;
            }
            
            update Enrich;
            
            
            counter = counter + 500;
            
            if(counter == locEnrich.size() || counter > locEnrich.size()) {
                break;
            }
        }
    }
    

}