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
@isTest
private class RelatedListControllerTest {

    //----------------- TEST Methods------------------------
	static testMethod void test(){
		//Insert Account
		Account acct = new Account(Name='test');
    	insert acct;
		
		//Attach opportunities to account
		List<Opportunity> opps = new List<Opportunity>();
		for(Integer i = 0; i < 5; i++){
			opps.add(new Opportunity(
				AccountId = acct.Id,
				Name = 'test ' + i,
				StageName = 'stage',
				CloseDate = system.today(),
				Amount = 5
			));
		}	
		insert opps;
		
		//Setup controller for related list
		RelatedListController controller = new RelatedListController();
		
		//Set attribute variables
		controller.objectName = 'Opportunity';
		controller.fieldsCSV = 'Id,Name,Amount,CloseDate';
		controller.parentFieldName = 'AccountId';
		controller.parentFieldId = acct.Id;
		controller.filter = 'Amount > 0';
		controller.orderByFieldName=  'Amount';
		controller.sortDirection = 'desc';
		controller.pageSize = 2;
		
		//Call method to get records
		controller.getRecords();
	
		//Assert number of opps found = 5
		system.assertEquals(controller.ssc.getResultSize(), 5);
		
		//Delete an opp
		controller.deleteRecordId = opps[0].Id;
		controller.deleteRecord();	
		
		//Assert size of opps is now 4
		system.assertEquals(controller.ssc.getResultSize(), 4);
		
		//Sort by name
		controller.sortByField = 'Name';
		controller.sortByField(); //Clears list of records
		controller.getRecords(); //requeries list of records
	}
}