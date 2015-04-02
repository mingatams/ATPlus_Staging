/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
//@IsTest(SeeAllData=true)
public class testAidTrackerProjectListDataController {
    public static testMethod void testAll() {
        
        List<geoCountry__c> gcList = new List<geoCountry__c>();
        //List<Project_Geography__c> pgList = new List<Project_Geography__c>();    
        
        
        Test.startTest();
        
        
        geoRegion__c gr = new geoRegion__c();
        gr.regCode__c = 'gr1' ;
        gr.Name = 'gr1 | Name';
        
        insert gr;
        for(Integer country = 1; country < 3; country++ ){
            geoCountry__c gc = new geoCountry__c();            
            gc.cntryCode__c = 'gc' +country;
            gc.Name = 'gc' +  country + ' | Name';
            gc.cntrydispName__c = 'gc' + country + ' | Disp';
            gc.visible__c = true;
            gc.regId__c = gr.Id;            
            gcList.add(gc);
        }
        
        
        insert gcList;  
        
        
        
        
        
        AidTrackerProjectListDataController c = new AidTrackerProjectListDataController();
        System.assertNotEquals(null, c.OverviewJSON);
        System.assertNotEquals(null, c.MissionOverviewJSON);
        System.assertNotEquals(null, c.ProjectsJSON);
        System.assertNotEquals(null, c.ProjectDetailsJSON);
        System.assertNotEquals(null, c.SnapShotJSON);
        System.assertNotEquals(null, c.getProjectSummaries());
        System.assertNotEquals(null, c.getProjectLocationSummaries());
        System.assertNotEquals(null, c.retrieveProjectDetailLocations());
        System.assertNotEquals(null, c.searchProject());
        System.assertNotEquals(null,c.requestProjectDetails);
        System.assertNotEquals(null,c.requestProjects);
        System.assertNotEquals(null,c.requestSnapshot);
        System.assertNotEquals(null, c.requestProjectsOverview);
        
        Map<String, String> x = ApexPages.currentPage().getParameters();
        x.put('r', 'overview');
        x.put('s', 'Education');
        c = new AidTrackerProjectListDataController();
        System.assertNotEquals(null, c.OverviewJSON);
        System.assertNotEquals(null, c.ProjectsJSON);

        x.put('r', 'overview');
        x.put('c', 'Ghana');
        c = new AidTrackerProjectListDataController();
        System.assertNotEquals(null, c.OverviewJSON);
        System.assertNotEquals(null, c.ProjectsJSON);
        
        x.put('r', 'overview');
        x.put('m', 'India');
        c = new AidTrackerProjectListDataController();
        System.assertNotEquals(null, c.OverviewJSON);
        System.assertNotEquals(null, c.ProjectsJSON);
        
        x.put('r', 'overview');
        x.put('i', 'Global Health Initiative');
        c = new AidTrackerProjectListDataController();
        System.assertNotEquals(null, c.OverviewJSON);
        System.assertNotEquals(null, c.ProjectsJSON);

        x.put('r', 'overview');
        x.put('f', '34343434343');
        x.put('t', '343434343434');   
        c = new AidTrackerProjectListDataController();
        System.assertNotEquals(null, c.OverviewJSON);
        System.assertNotEquals(null, c.ProjectsJSON);
    
        x.put('r', 'overview');
        x.put('l', 'local');
        x.put('w', 'India');   
        c = new AidTrackerProjectListDataController();
        System.assertNotEquals(null, c.OverviewJSON);
        System.assertNotEquals(null, c.ProjectsJSON);
        
        x.put('r', 'overview');
        x.put('l', 'local');
        x.put('w', 'IN');   
        x.put('v', 'list');
        x.put('s', 'WCC');
        c = new AidTrackerProjectListDataController();
        System.assertNotEquals(null, c.OverviewJSON);
        System.assertNotEquals(null, c.ProjectsJSON);
        System.assertNotEquals(null, c.ProjectSearchResultsJSON);
        
        x.put('r', 'overview');
        x.put('l', 'regional');
        x.put('w', 'ASIA'); 
        x.put('v', 'list');   
        c = new AidTrackerProjectListDataController();
        System.assertNotEquals(null, c.OverviewJSON);
        System.assertNotEquals(null, c.ProjectsJSON);
        System.assertNotEquals(null, c.ProjectSearchResultsJSON);
        
        x.put('q', 'education');
        x.put('o', 'NAME');
        c = new AidTrackerProjectListDataController();
        System.assertNotEquals(null, c.ProjectSearchResultsJSON);
        System.assertNotEquals(null, c.SnapShotJSON);
        System.assertNotEquals(null, c.OverviewJSON);
        System.assertNotEquals(null, c.MissionOverviewJSON);
        System.assertNotEquals(null, c.ProjectsJSON);
        System.assertNotEquals(null, c.ProjectDetailsJSON);
        System.assertNotEquals(null, c.ProjectSearchResultsJSON);
        System.assertNotEquals(null, c.ProjectDetailLocationsJSON);    
        System.assertNotEquals(null, c.getProjectSummaries());
        System.assertNotEquals(null,c.requestProjectDetails);
        System.assertNotEquals(null,c.requestProjects);
        System.assertNotEquals(null,c.requestSnapshot);
        System.assertNotEquals(null, c.requestProjectsOverview);     
        System.assertNotEquals(null, c.requestProjectSearch);               
        Test.stopTest();
    }
}