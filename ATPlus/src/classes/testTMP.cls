/**
 * 
 * 
 * 
 * 
 * 
 */
@isTest
public class testTMP {
    
    //Test function to verify the reports are available
    @isTest(SeeAllData=true)
    public static void test1(){
        
        
        Test.startTest();
        
        //Testing the page with no ID provided
        PageReference pageRef = Page.tmp;
        Test.setCurrentPage(pageRef);       
        tmpController controller = new tmpController();
        System.assert( controller.RegionItems.size() > 0, 'Test 1.1: Regions options not returned correctly' );
        
        Test.stopTest();
    }
    
    @isTest(SeeAllData=false)
    public static void test2(){
        List<FiscalYear__c> fys = new List<FiscalYear__c>{
                                new FiscalYear__c( Name = '2013', Year__c = 2013, CurrentQuar__c = 'Q4', isActive__c = False ),
                                new FiscalYear__c( Name = '2015', Year__c = 2015, CurrentQuar__c = 'FY', isActive__c = False )
                            };        
        FiscalYear__c fy = new FiscalYear__c( Name = '2014', Year__c = 2014, CurrentQuar__c = 'Q1', isActive__c = True );
        fys.add(fy);
        insert fys;
        OperatingUnit__c o = new OperatingUnit__c( name = 'Test Planning Unit', Region__c = 'Test Planning Unit', bureau__c = 'Test Bureau' );
        insert o;
        /*
        Planning_Unit_User__c puu = new Planning_Unit_User__c( Planning_Unit__c = o.id, User__c = UserInfo.getUserId() );
        insert puu;
        */
        AAPlan__c a = new AAPlan__c( Name = 'Test A&A Plan', FiscalYear__c = fy.id, OperatingUnit__c = o.id );
        insert a;
        AAPlanDetail__c b = new AAPlanDetail__c( AandAPlan__c = a.id, 
                                                AwardTitle__c = 'Test A&A Action', 
                                                ObligatedAmount__c = 123, 
                                                Quarter__c = 'Q1',
                                                TotalEstimateCost__c = '$150,000 - $499,999',
                                                ActionOrAwardType__c ='Contract',
                                                AwardPriority__c = 'Normal',
                                                Status__c = 'Activity Approval',
                                                PartnerOrIncumbentName__c = 'Test Incumbent');
        insert b;
        List<Fund_Type__c> fts = new List<Fund_Type__c>{ new Fund_Type__c( A_A_Action__c = b.id, Funding_Type__c = 'TEST', Funding_Year__c = '2014'),
                                                         new Fund_Type__c( A_A_Action__c = b.id, Funding_Type__c = 'TEST2', Funding_Year__c = '2014')};
        insert fts;
        Test.startTest();
        
        //Testing the page with no ID provided
        PageReference pageRef = Page.tmp;
        Test.setCurrentPage(pageRef);       
        tmpController controller = new tmpController();
        System.assert( controller.RegionItems.size() > 0, 'Test 1.1: Regions options not returned correctly' );
        System.assert( controller.OperatingUnitOptions.size() == 1, 'Test 1.2: Operating Unit options not returned correctly' );
        System.assert( controller.FiscalYearOptions.size() == 3, 'Test 1.3: Fiscal Year options not returned correctly' );
        
        system.assert(tmpController.getChartData( 'Test Planning Unit', (String)o.id, (string)fy.id) != null, 
                      'Test 1.4: ChartData is not being returned correctly');
        system.assert(tmpController.getPartnerCount( 'Test Planning Unit', (String)o.id, (string)fy.id) != null, 
                      'Test 1.5: Label Values are not being returned correctly');
        system.assert(tmpController.getStatData( 'Test Planning Unit', (String)o.id, (string)fy.id) != null, 
                      'Test 1.6: StatData is not being returned correctly');
        system.assert(tmpController.getActionsByOU( 'Test Planning Unit', (String)o.id, (string)fy.id).length() > 0, 
                      'Test 1.7: Actions by OU string is not being returned correctly');
        system.assert(tmpController.getPlanIds( 'Test Planning Unit', (String)o.id, (string)fy.id).size() > 0, 
                      'Test 1.8: PlanIDs are not being returned correctly');
        Test.stopTest();
    }
}