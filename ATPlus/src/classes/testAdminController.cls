/**
* testAdminController is test class for AdminController
*
* CHANGE HISTORY
* =============================================================================
* Date				Name				Description
* Sep 09 2014      	Brian Mason			Created
* Oct 09 2014		Brian Mason			Added	Comments
* =============================================================================
*/
@isTest
public class testAdminController {

    @isTest(SeeAllData=False)
    public static void test1(){
        List<FiscalYear__c> fys = new List<FiscalYear__c>{
                                new FiscalYear__c( Name = '2013', Year__c = 2013, CurrentQuar__c = 'Q4', isActive__c = False ),
                                new FiscalYear__c( Name = '2015', Year__c = 2015, CurrentQuar__c = 'FY', isActive__c = False )
                            };        
        FiscalYear__c fy = new FiscalYear__c( Name = '2014', Year__c = 2014, CurrentQuar__c = 'Q1', isActive__c = True );
        fys.add(fy);
        insert fys;
        OperatingUnit__c o = new OperatingUnit__c( name = 'Test Planning Unit', Region__c = 'Test Planning Unit' );
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
                                                Quarter__c = 'Q1' );
        insert b;
        List<Fund_Type__c> fts = new List<Fund_Type__c>{ new Fund_Type__c( A_A_Action__c = b.id, Funding_Type__c = 'TEST', Funding_Year__c = '2014'),
                                                         new Fund_Type__c( A_A_Action__c = b.id, Funding_Type__c = 'TEST2', Funding_Year__c = '2014')};
        insert fts;
        List<AA_Quarterly_Update_Fields__c> lstCS = new List<AA_Quarterly_Update_Fields__c>{ 
            new AA_Quarterly_Update_Fields__c( name = 'AwardTitle__c', Field_API_Name__c='AwardTitle__c', Field_Label__c='AwardTitle__c' ),
            new AA_Quarterly_Update_Fields__c( name = 'Quarter__c', Field_API_Name__c='Quarter__c', Field_Label__c='Quarter__c' ),
            new AA_Quarterly_Update_Fields__c( name = 'ObligatedAmount__c', Field_API_Name__c='ObligatedAmount__c', Field_Label__c='ObligatedAmount__c' ),
            new AA_Quarterly_Update_Fields__c( name = 'AandAPlan__c', Field_API_Name__c='AandAPlan__c', Field_Label__c='AandAPlan__c' )};
        insert lstCS;
        
        
        Test.startTest();
        
        //Testing the page with no ID provided
        PageReference pageRef = Page.Admin;
        Test.setCurrentPage(pageRef);       
        AdminController controller = new AdminController();
        AdminController.createNewQuarterRecords();
        Integer opts = controller.getQuarterOptions().size();
        system.assert( opts > 0, 'Test 1.1: Dropdown options for Quarters is not set correctly.');
        system.assert( controller.selectedQuarter != null, 'Test 1.2: SelectedQuarter not set in constructor correctly.');
        system.assert( controller.operatingUnitGrpWrapper != null, 'Test 1.3: Operating units not set in constructor correctly.');
        system.assert( controller.JSONGroups != null, 'Test 1.4: JSON values not set in constructor correctly.');
        
        controller = new AdminController();
        controller.dummyFiscalYearRecord.Year__c = 2016;
        controller.dummyFiscalYearRecord.StartDate__c = date.parse('1/1/2016');
        controller.dummyFiscalYearRecord.EndDate__c = date.parse('12/31/2016');
        
        PageReference nextPage = controller.createNewYear();
        controller.selectedQuarter = 'Q1';
        controller.updateCurrentQuarter();
        System.assert(nextPage == NULL, 'Test 1.5: Year not inserted correctly');
        System.assert(controller.selectedQuarter == 'Q1', 'Test 1.6: Selected Quarter not updated correctly.');
        
        controller = new AdminController();
        controller.dummyOperatingUnit.Name = 'Test Planning Unit 2';
        controller.dummyOperatingUnit.Parent__c = null;
        controller.dummyOperatingUnit.Region__c = 'Test Planning Unit 2';
        nextPage = controller.createNewOU();
        System.assert(nextPage == NULL, 'Test 1.7: New Opperating Unit not inserted correctly');
        
        Test.stopTest();
        
        List<AAPlanDetail__c> lstDetails = [SELECT ID FROM AAPlanDetail__c];
        system.assertEquals( 2, lstDetails.size(), 'Test 1.8: AdminController.createNewQuarterRecords() call failed');
        
        List<Fund_Type__c> lstFTs = [SELECT ID FROM Fund_Type__c WHERE A_A_Action__c != :b.id];
        system.assertEquals( 2, lstFTs.size(), 'Test 1.9: AdminController.createNewQuarterRecords() call failed, no Funding_Types were copied');
    }
}