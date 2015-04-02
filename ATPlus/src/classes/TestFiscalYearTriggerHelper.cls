@IsTest
public with sharing class TestFiscalYearTriggerHelper {
	@IsTest
	static void testDuplicates_insert() {
		//arrange
		insert new FiscalYear__c(Year__c=2014);
		FiscalYear__c fy = new FiscalYear__c(Year__c=2014);
		
		//act
		try {
			insert fy;
			//assert
			System.assert(false);
		} catch(DMLException e) {}
		
		System.assertEquals(1, [SELECT Id FROM FiscalYear__c].size());
	}
	
	@IsTest
	static void testDuplicates_insert_bulk() {
		//arrange
		insert new FiscalYear__c(Year__c=2014);
		FiscalYear__c[] years = new FiscalYear__c[]{
				new FiscalYear__c(Year__c=2010),
				new FiscalYear__c(Year__c=2011),
				new FiscalYear__c(Year__c=2012),
				new FiscalYear__c(Year__c=2013), 
				new FiscalYear__c(Year__c=2014)
		};
		
		//act
		try {
			insert years;
			//assert
			System.assert(false);
		} catch(DMLException e) {}
		
		System.assertEquals(1, [SELECT Id FROM FiscalYear__c].size());
	}
	
	@IsTest
	static void testDuplicates_update() {
		//arrange
		FiscalYear__c[] years = new FiscalYear__c[]{new FiscalYear__c(Year__c=2013), new FiscalYear__c(Year__c=2014)};
		insert years;
		years[0].Year__c = 2014;
		
		//act
		try {
			update years[0];
			//assert
			System.assert(false);
		} catch(DMLException e) {}
		
		System.assertEquals(1, [SELECT Id FROM FiscalYear__c WHERE Year__c = 2014].size());
	}
	
	
	@IsTest
	static void testDuplicates_update_bulk() {
		//arrange
		FiscalYear__c[] years = new FiscalYear__c[]{
				new FiscalYear__c(Year__c=2010),
				new FiscalYear__c(Year__c=2011),
				new FiscalYear__c(Year__c=2012),
				new FiscalYear__c(Year__c=2013), 
				new FiscalYear__c(Year__c=2014)
		};
		insert years;
		years[0].Year__c = 2014;
		
		//act
		try {
			update years[0];
			//assert
			System.assert(false);
		} catch(DMLException e) {}
		
		System.assertEquals(1, [SELECT Id FROM FiscalYear__c WHERE Year__c = 2014].size());
	}
	
	@IsTest
	static void testSingleActive_insert() {
		//arrange
		insert new FiscalYear__c(Year__c=2014, IsActive__c=true);
		FiscalYear__c fy = new FiscalYear__c(Year__c=2000, IsActive__c=true);
		//act
		try {
			insert fy;
			//assert
			System.assert(false);
		} catch(DMLException e) {}
		
		System.assertEquals(1, [SELECT Id FROM FiscalYear__c].size());
	}
	
	@IsTest
	static void testSingleActive_insert_bulk() {
		//arrange
		FiscalYear__c[] years = new FiscalYear__c[]{
				new FiscalYear__c(Year__c=2010, IsActive__c=true),
				new FiscalYear__c(Year__c=2011),
				new FiscalYear__c(Year__c=2012),
				new FiscalYear__c(Year__c=2013), 
				new FiscalYear__c(Year__c=2014, IsActive__c=true)
		};
		
		//act
		try {
			insert years;
			//assert
			System.assert(false);
		} catch(DMLException e) {}
		
		System.assertEquals(0, [SELECT Id FROM FiscalYear__c].size());
	}
	
	@IsTest
	static void testSingleActive_update() {
		//arrange
		FiscalYear__c[] years = new FiscalYear__c[]{new FiscalYear__c(Year__c=2013), new FiscalYear__c(Year__c=2014, IsActive__c=true)};
		insert years;
		years[0].IsActive__c=true;
		
		//act
		try {
			update years[0];
			//assert
			System.assert(false);
		} catch(DMLException e) {}
		
		System.assertEquals(true, [SELECT IsActive__c FROM FiscalYear__c WHERE Year__c = 2014].IsActive__c);
	}
	
	@IsTest
	static void testSingleActive_update_bulk() {
		//arrange
		FiscalYear__c[] years = new FiscalYear__c[]{
				new FiscalYear__c(Year__c=2010),
				new FiscalYear__c(Year__c=2011),
				new FiscalYear__c(Year__c=2012),
				new FiscalYear__c(Year__c=2013), 
				new FiscalYear__c(Year__c=2014, IsActive__c=true)
		};
		insert years;
		years[0].IsActive__c=true;
		
		//act
		try {
			update years[0];
			//assert
			System.assert(false);
		} catch(DMLException e) {}
		
		System.assertEquals(true, [SELECT IsActive__c FROM FiscalYear__c WHERE Year__c = 2014].IsActive__c);
	}
}