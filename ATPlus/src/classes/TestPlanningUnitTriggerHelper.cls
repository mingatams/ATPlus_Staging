@isTest
private class TestPlanningUnitTriggerHelper {

	@isTest
    private static void testCleanAPIName() {
    	User u = TestHelper.getAdminUser(true);

        System.runAs(u) {
    		//prep
    		String dirtyName = 'This is @ dirty Name & it is supp0sed to be very 1ong';
    		String expectedResult = 'This_is_dirty_Name_it_is_supp0';
    		
    		String toCleanAPI = '';
    		
    		//execute
    		Test.startTest();
    		toCleanAPI = PlanningUnitTriggerHelper.cleanAPIName(dirtyName);
    		Test.stopTest();
    		
    		//asert
    		System.debug(dirtyName);
    		System.debug(expectedResult);
    		System.debug(toCleanAPI);
    		System.assertEquals(expectedResult, toCleanAPI);
        }
    }
    
    @isTest
    private static void testCleanName() {
    	User u = TestHelper.getAdminUser(true);

        System.runAs(u) {
    		//prep
    		String dirtyName = 'This is @ dirty Name & it is supp0sed to be very 1ong';
    		String expectedResult = 'This is @ dirty Name & it is s';
    		
    		String toCleanName = '';
    		
    		//execute
    		Test.startTest();
    		toCleanName = PlanningUnitTriggerHelper.cleanName(dirtyName);
    		Test.stopTest();
    		
    		//asert
    		System.debug(dirtyName);
    		System.debug(expectedResult);
    		System.debug(toCleanName);
    		System.assertEquals(expectedResult, toCleanName);
        }
    }
}