/*
 * 
 * 
 * 
 * 
 * 
 */
@isTest
public class testMultiselectJSController {

    @isTest(SeeAllData = false)
    public static void MultiSelectTest(){
        List<operatingUnit__c> a = new List<operatingUnit__c>{ new operatingUnit__c(Region__c='test1', name = 'test1'), 
                                                                new operatingUnit__c(Region__c='test2', name = 'test2'), 
                                                                new operatingUnit__c(Region__c='test2', name = 'test3')};
        insert a;
        
        Test.startTest();
        Map<String, String[]> mapStr = MultiselectJSController.getOpUnitDependencies();
        System.assertEquals( 3, a.size(), 'MultiSelect was not populated correctly.');
        Test.stopTest();
    }
}