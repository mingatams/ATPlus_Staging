/**
* testAAAnnouncementsController is a test class for 
* AAAnnouncementsController.
*
* CHANGE HISTORY
* ======================================================================================
* Date              Name            Description
* Dec 05 2014       Brian Mason     Created
* ======================================================================================
*/
@isTest
Public class testJOB_Bureau_Rollup{

	@isTest(SeeAllData=false)
	public static void test1(){
		List<FiscalYear__c> fys = new List<FiscalYear__c>{
                                new FiscalYear__c( Name = '2013', Year__c = 2013, CurrentQuar__c = 'Q4', isActive__c = False ),
                                new FiscalYear__c( Name = '2015', Year__c = 2015, CurrentQuar__c = 'FY', isActive__c = False ),
                                new FiscalYear__c( Name = '2014', Year__c = 2014, CurrentQuar__c = 'Q1', isActive__c = True )
                            };
		insert fys;
		List<OperatingUnit__c> ous = new List<OperatingUnit__c>{ new OperatingUnit__c(name = 'Test Planning Unit1', Region__c = 'Test Planning Unit1', Bureau__c = 'U.S. Global Development Lab (LAB)'),
																 new OperatingUnit__c(name = 'Test Planning Unit2', Region__c = 'Test Planning Unit2', Bureau__c = 'Bureau for Economic Growth, Education and Environment (E3)'),
																 new OperatingUnit__c(name = 'Test Planning Unit3', Region__c = 'Test Planning Unit3', Bureau__c = 'Bureau for Europe and Eurasia (E&E)')
															   };
        insert ous;
        List<AAPlan__c> aaplans = new List<AAPlan__c>{ new AAPlan__c(Name = 'Test A&A Plan', FiscalYear__c = fys[2].id, OperatingUnit__c = ous[0].id),
													   new AAPlan__c(Name = 'Test A&A Plan', FiscalYear__c = fys[2].id, OperatingUnit__c = ous[1].id),
													   new AAPlan__c(Name = 'Test A&A Plan', FiscalYear__c = fys[2].id, OperatingUnit__c = ous[2].id)
													 };
        insert aaplans;
        List<AAPlanDetail__c> aaplandetails = new List<AAPlanDetail__c>{ new AAPlanDetail__c(AandAPlan__c = aaplans[0].id, AwardTitle__c = 'Test A&A Action1',
        																					 ObligatedAmount__c = 123, Quarter__c = 'Q1', 
        																					 ActionOrAwardType__c = 'Development Innovation Accelerator (DIA)',
        																					 AwardNumber__c = '123', Is_this_Action_using_Expiring_Funds__c = 'Yes',
        																					 TotalEstimateCost__c = '$25M - $49.99M'),
        																 new AAPlanDetail__c(AandAPlan__c = aaplans[1].id, AwardTitle__c = 'Test A&A Action2',
        																					 ObligatedAmount__c = 123, Quarter__c = 'Q1', 
        																					 ActionOrAwardType__c = 'Cooperative Agreement',
        																					 AwardNumber__c = 'TBD', Is_this_Action_using_Expiring_Funds__c = 'Yes',
        																					 TotalEstimateCost__c = '$25M - $49.99M'),
    																	 new AAPlanDetail__c(AandAPlan__c = aaplans[2].id, AwardTitle__c = 'Test A&A Action3',
        																					 ObligatedAmount__c = 123, Quarter__c = 'Q1', 
        																					 ActionOrAwardType__c = 'Contract',
        																					 AwardNumber__c = '789', Is_this_Action_using_Expiring_Funds__c = 'Yes',
        																					 TotalEstimateCost__c = '$4M - $9.99M')
        															   };

        insert aaplandetails;
        
        List<A_A_Phoenix_Data__c> phxData = new List<A_A_Phoenix_Data__c>{ new A_A_Phoenix_Data__c(BUREAU_CD__c = 'LAB', Encumbered_Expiring_Amt__c = 0, 
        																						   id__c = '', Program_OE_Flag__c = 'O', 
        																						   Sub_Allowed_Expiring_Amt__c = 0, Sub_Allowed_Expiring_Encm_Amt__c = 0, 
																								   Sub_Allowed_Pct_Exprng_Encm_Amt__c = 0),
																		   new A_A_Phoenix_Data__c(BUREAU_CD__c = 'LAB', Encumbered_Expiring_Amt__c = 0, 
        																						   id__c = '', Program_OE_Flag__c = 'P', 
        																						   Sub_Allowed_Expiring_Amt__c = 0, Sub_Allowed_Expiring_Encm_Amt__c = 0, 
																								   Sub_Allowed_Pct_Exprng_Encm_Amt__c = 0),
																		   new A_A_Phoenix_Data__c(BUREAU_CD__c = 'EGEE', Encumbered_Expiring_Amt__c = -38.50, 
        																						   id__c = '', Program_OE_Flag__c = 'O', 
        																						   Sub_Allowed_Expiring_Amt__c = -38.50, Sub_Allowed_Expiring_Encm_Amt__c = 0, 
																								   Sub_Allowed_Pct_Exprng_Encm_Amt__c = 0),
																		   new A_A_Phoenix_Data__c(BUREAU_CD__c = 'EGEE', Encumbered_Expiring_Amt__c = 7944.50, 
        																						   id__c = '', Program_OE_Flag__c = 'P', 
        																						   Sub_Allowed_Expiring_Amt__c = 52500507.58, Sub_Allowed_Expiring_Encm_Amt__c = 52492563.08, 
																								   Sub_Allowed_Pct_Exprng_Encm_Amt__c = 99.985),
																		   new A_A_Phoenix_Data__c(BUREAU_CD__c = 'E+E', Encumbered_Expiring_Amt__c = 1038819.50, 
        																						   id__c = '', Program_OE_Flag__c = 'P', 
        																						   Sub_Allowed_Expiring_Amt__c = 88011751.70, Sub_Allowed_Expiring_Encm_Amt__c = 86972932.20, 
																								   Sub_Allowed_Pct_Exprng_Encm_Amt__c = 98.82),
																		   new A_A_Phoenix_Data__c(BUREAU_CD__c = 'E+E', Encumbered_Expiring_Amt__c = 0, 
        																						   id__c = '', Program_OE_Flag__c = 'O', 
        																						   Sub_Allowed_Expiring_Amt__c = 834000.00, Sub_Allowed_Expiring_Encm_Amt__c = 834000.00, 
																								   Sub_Allowed_Pct_Exprng_Encm_Amt__c = 100.00),
																		   new A_A_Phoenix_Data__c(BUREAU_CD__c = 'IDEA', Encumbered_Expiring_Amt__c = 0, 
        																						   id__c = '', Program_OE_Flag__c = 'P', 
        																						   Sub_Allowed_Expiring_Amt__c = 0, Sub_Allowed_Expiring_Encm_Amt__c = 0, 
																								   Sub_Allowed_Pct_Exprng_Encm_Amt__c = 0),
																		   new A_A_Phoenix_Data__c(BUREAU_CD__c = 'IDEA', Encumbered_Expiring_Amt__c = 0, 
        																						   id__c = '', Program_OE_Flag__c = 'O', 
        																						   Sub_Allowed_Expiring_Amt__c = 0, Sub_Allowed_Expiring_Encm_Amt__c = 0, 
																								   Sub_Allowed_Pct_Exprng_Encm_Amt__c = 0)
																		 };
		insert phxData;
        List<AAPlan_Bureau_Phoenix_Report__c> rollupData =  new List<AAPlan_Bureau_Phoenix_Report__c>();
		Test.startTest();
		JOB_Bureau_Rollup jbr = new JOB_Bureau_Rollup();
		jbr.updateFlashReports();
		Test.stopTest();
		system.assertEquals(6, [SELECT ID, PHX_BUREAU_CD__c FROM AAPlan_Bureau_Phoenix_Report__c].size(), 'Test 1.1 failed: AAPlan_Bureau_Phoenix_Report__c was not populated correctly');
		
		
		
		
	}
}