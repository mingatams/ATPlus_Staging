/**
 * 
 * 
 * 
 * 
 * 
 */
@isTest
public class testOperatingUnits {

    @isTest(SeeAllData=false)
    public static void test1(){
        
        List<FiscalYear__c> fys = new List<FiscalYear__c>{
                                new FiscalYear__c( Name = '2013', Year__c = 2013, CurrentQuar__c = 'Q4', isActive__c = False ),
                                new FiscalYear__c( Name = '2015', Year__c = 2015, CurrentQuar__c = 'FY', isActive__c = False )
                            };        
        insert fys;
        FiscalYear__c fy = new FiscalYear__c( Name = '2014', Year__c = 2014, CurrentQuar__c = 'Q1', isActive__c = True );
        insert fy;
        OperatingUnit__c o = new OperatingUnit__c( name = 'Test Planning Unit', Region__c = 'Test Planning Unit' );
        insert o;
        Planning_Unit_User__c puu = new Planning_Unit_User__c( Planning_Unit__c = o.id, User__c = UserInfo.getUserId() );
        insert puu;
        AAPlan__c a = new AAPlan__c( Name = 'Test A&A Plan', FiscalYear__c = fy.id, OperatingUnit__c = o.id );
        insert a;
        AAPlanDetail__c b = new AAPlanDetail__c( AandAPlan__c = a.id, 
                                                AwardTitle__c = 'Test A&A Action', 
                                                ObligatedAmount__c = 123, 
                                                Quarter__c = 'Q1' );
        insert b;
        List<Fund_Type__c> fts = new List<Fund_Type__c>{ new Fund_Type__c( A_A_Action__c = b.id, Funding_Type__c = 'TEST', Funding_Year__c = '2014'),
                                                         new Fund_Type__c( A_A_Action__c = b.id, Funding_Type__c = 'TEST2', Funding_Year__c = '2014')};
        insert fts;
        
        Test.startTest();
        
        OperatingUnits ou = new OperatingUnits();
        system.assert( ou.operatingUnits.size() > 0 , 'Test 1.1: operatingUnits are not being populated correctly' );
        system.assert( OperatingUnits.getOperatingUnitsHierarchy() != NULL, 'Test 1.2: results are not being returned correctly' );
        
        Test.stopTest();
    }
}