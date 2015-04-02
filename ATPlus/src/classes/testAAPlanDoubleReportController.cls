/**
* testAAPlanDoubleReportController is test class for AAPlanDoubleReportController
*
* CHANGE HISTORY
* =============================================================================
* Date				Name				Description
* Nov 03 2014      	Brian Mason			Created
* =============================================================================
*/
@isTest
public class testAAPlanDoubleReportController {

    @isTest(SeeAllData=false)
    public static void test1() {
        List<AAPlan_Bureau_Phoenix_Report__c> rollupDataRows = new List<AAPlan_Bureau_Phoenix_Report__C>{
            new AAPlan_Bureau_Phoenix_Report__c(PHX_BUREAU_CD__C ='ES', 
                                                PHX_ENCUMBERED_EXPIRING_AMT__C = 2875152, 
                                                PHX_ID__C = '',
                                                PHX_PROGRAM_OE_FLAG__C = 'O', 
                                                PHX_SUB_ALLOWED_EXPIRING_AMT__C = 0, 
                                                PHX_SUB_ALLOWED_EXPIRING_ENCM_AMT__C = -2875152, 
                                                PHX_SUB_ALLOWED_PCT_EXPIRING_ENCM_AMT__C = 0, 
                                                AAP_BUREAU__C = 'Executive Secretariat (ES)', 
                                                AAP_ACTIONS__C = 0, 
                                                AAP_ACTIONSALREADYAWARDED__C = 0, 
                                                AAP_ACTIONSREMAININGTOBEEXECUTED__C = 0, 
                                                AAP_ACTIONSNOTAWARDEDUSINGEXPFUNDS__C = 0, 
                                                AAP_ACTIONSOVER25MNOTAWARDED__C = 0, 
                                                AAP_PCTACTIONSNOTAWARDEDUSINGEXPFUNDS__C = 0,
                                                AAP_ACTIONSREMAININGTOBEOBLIGATED__C = 0)};
        insert rollupDataRows;
        Test.startTest();
        
        PageReference pageRef = Page.AAPlanDoubleReport;
        Test.setCurrentPage(pageRef);   
        AAPlanDoubleReportController controller = new AAPlanDoubleReportController();
        system.assertEquals(1, controller.bureauSelectOptions.size(), 'Test 1.1 failed: Bureau select options not initialized correctly');
        
        controller.selectedBureau = controller.bureauSelectOptions[0].getvalue();
        controller.setSelectedData();
        system.assertNotEquals(NULL, controller.currentReport, 'Test 1.2 failed: Report data was not populated correctly');
        Test.stopTest();
    }
}