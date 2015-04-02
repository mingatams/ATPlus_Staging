/**
* JOB_Bureau_Rollup is a scheduled job to roll the values in salesforce up along with 
* the values coming in from the Phoenix ETL job, into the combined 
* AAPlan_Bureau_Phoenix_Report__c object.
*
* CHANGE HISTORY
* =========================================================================================
* Date        		Name			Description
* Sep 08 2014		Ryan Chadwick	Created
* Dec 05 2014		Brian Mason		Updated to take into account multiple LAB/IDEA rows
									Changed "Office of Human Resources" =>
									"Office of Human Capital and Talent Management (HCTM)"
* =========================================================================================
*/
global with sharing class JOB_Bureau_Rollup implements Schedulable{
	
	global void execute(SchedulableContext sc){
		updateFlashReports();
	}
	
	//scheduled at 7am daily
	//Phoenix load from Informatica takes place at 6am daily (dependent data)
	public static void scheduleReportUpdate(){
		JOB_Bureau_Rollup reportSched = new JOB_Bureau_Rollup();
        String sch = '0 0 7 * * ?';
        system.schedule('Daily A&A Planning Bureau Report Rollup', sch, reportSched);
	}
	
	public List<Schema.PicklistEntry> getBureauListPLE(){
   		Schema.DescribeFieldResult fieldResult = AAPlan__c.Bureau__c.getDescribe();
   		List<Schema.PicklistEntry> bureauList = fieldResult.getPicklistValues();
   		return bureauList;
	}
	
	public List<String> getBureauListStr(){
		List<String> bureauList = new List<String>();
   		List<Schema.PicklistEntry> ple = getBureauListPLE();
   		for( Schema.PicklistEntry f : ple){ bureauList.add(f.getValue()); }
   		return bureauList;
	}
	
	public static final Map<String,String> shortToLong = new Map<String,String>
	{
		'A'				=> 'Office of the Administrator (AID/A)',
		'AFR' 			=> 'Bureau for Africa (AFR)',
		'ASIA' 			=> 'Bureau for Asia (ASIA)',
		'BFS' 			=> 'Bureau for Food Security (FS)',
		'DCHA' 			=> 'Bureau for Democracy, Conflict and Humanitarian Assistance (DCHA)',
		'E+E' 			=> 'Bureau for Europe and Eurasia (E&E)',
		'EGEE' 			=> 'Bureau for Economic Growth, Education and Environment (E3)',
		'ES' 			=> 'Executive Secretariat (ES)',
		'FA' 			=> 'Foreign Assistance (FA)',
		'GC' 			=> 'Office of General Counsel (GC)',
		'GH' 			=> 'Bureau for Global Health (GH)',
		'HR' 			=> 'Office of Human Capital and Talent Management (HCTM)',
		'LAB' 			=> 'U.S. Global Development Lab (LAB)',
		'LAC' 			=> 'Bureau for Latin America and the Caribbean (LAC)',
		'LPA' 			=> 'Legislative and Public Affairs (LPA)',
		'M' 			=> 'Bureau for Management (M)'
	};
	
	public static final Map<String,String> longToShort = new Map<String,String>
	{
		'Office of the Administrator (AID/A)'								=> 'A',
		'Bureau for Africa (AFR)' 											=> 'AFR',
		'Bureau for Asia (ASIA)' 											=> 'ASIA',
		'Bureau for Food Security (FS)' 									=> 'BFS',
		'Bureau for Democracy, Conflict and Humanitarian Assistance (DCHA)'	=> 'DCHA',
		'Bureau for Europe and Eurasia (E&E)' 								=> 'E+E',
		'Bureau for Economic Growth, Education and Environment (E3)' 		=> 'EGEE',
		'Executive Secretariat (ES)' 										=> 'ES',
		'Foreign Assistance (FA)' 											=> 'FA',
		'Office of General Counsel (GC)' 									=> 'GC',
		'Bureau for Global Health (GH)' 									=> 'GH',
		'Office of Human Capital and Talent Management (HCTM)'				=> 'HR',
		'U.S. Global Development Lab (LAB)' 								=> 'LAB',
		'Bureau for Latin America and the Caribbean (LAC)' 					=> 'LAC',
		'Legislative and Public Affairs (LPA)' 								=> 'LPA',
		'Bureau for Management (M)' 										=> 'M'
	};
	
	private static final Set<String> over25M = new Set<String>{'$25M - $49.99M',
																'$50M - $74.99M',
																'$75M - $149.99M',
																'$150M - $299.99M',
																'$300M - $499.99M',
																'$500M - $999.99M',
																'$1B+'};
	
	private static final set<String> awardTypes = new Set<String>{'Contract',
																'Grant',
																'Development Innovation Accelerator (DIA)',
																'Collaborative Agreement',
            													'Cooperative Agreement',
            													'Associate Award',
            													'Blanket Purchase Agreement (BPA)',
            													'Indefinite Delivery Indefinite Quantity Contract (IDIQ)',
            													'Leader with Associate Award (LWA)',
            													'Public International Organization Award (PIO)',
            													'Small Business Task Order',
            													'Task Order/Delivery Order (TO/DO)'};
	
	public void updateFlashReports(){
		//holder for upserting report data objects
		List<AAPlan_Bureau_Phoenix_Report__c> upsertHolder = new List<AAPlan_Bureau_Phoenix_Report__c>();
		
		//get the values of the pick list that denote the bureaus
		List<String> bureauList = getBureauListStr();
		
		//get all the current report object ids if they exist to attach at upsert
		List<AAPlan_Bureau_Phoenix_Report__c> existingReportObjs = 
															[SELECT Id, AAP_Bureau__c, PHX_Program_OE_Flag__c
															FROM AAPlan_Bureau_Phoenix_Report__c
															WHERE AAP_Bureau__c IN :bureauList];
															
		//get current Phoenix data to be added to the consolidated reports
		List<A_A_Phoenix_Data__c> existingPhoenixData = [SELECT Id, BUREAU_CD__c, Encumbered_Expiring_Amt__c, id__c, 
														Program_OE_Flag__c, Sub_Allowed_Expiring_Amt__c, Sub_Allowed_Expiring_Encm_Amt__c, 
														Sub_Allowed_Pct_Exprng_Encm_Amt__c 
														FROM A_A_Phoenix_Data__c];
		
		//holder for all of a bureaus actions
		Map<String,List<AAPlanDetail__c>> bureauActions = new Map<String,List<AAPlanDetail__c>>();
		
		//get all the A&A Plan Action details associated with its child A&A Plans
			List<AAPlanDetail__c> actionList = [SELECT Id,
													   AandAPlan__r.OperatingUnit__r.Bureau__c,
													   AwardNumber__c,
													   Is_this_Action_using_Expiring_Funds__c,
													   TotalEstimateCost__c
												FROM AAPlanDetail__c
												WHERE AandAPlan__r.OperatingUnit__r.Bureau__c IN :bureauList
												AND ActionOrAwardType__c IN :awardTypes];
		//for every bureau
		for(String bureau : bureauList){
			List<AAPlanDetail__c> actions = new List<AAPlanDetail__c>();
			for( AAPlanDetail__c a : actionList ){
				if( bureau == a.AandAPlan__r.OperatingUnit__r.Bureau__c ){
					actions.add( a );
				}
			}
			bureauActions.put(bureau, actions);
		}
		
		//for every phoenix data entry
		//exceptions for LAB and IDEA built in - per Mike Pontiakos
		//IDEA 'O' and LAB 'O' are added together and labeled as LAB 'O'
		//IDEA 'P' is labeled as LAB 'P'
		for(A_A_Phoenix_Data__c phxData : existingPhoenixData){
			String bLongName = shortToLong.get(phxData.BUREAU_CD__c);
			AAPlan_Bureau_Phoenix_Report__c reportObj = new AAPlan_Bureau_Phoenix_Report__c(AAP_ActionsRemainingToBeExecuted__c 	 = 0,
																								AAP_Actions__c 							 = 0,
																								AAP_ActionsAlreadyAwarded__c 			 = 0,
																								AAP_ActionsNotAwardedUsingExpFunds__c 	 = 0,
																								AAP_ActionsOver25MNotAwarded__c 		 = 0,
																								AAP_PctActionsNotAwardedUsingExpFunds__c = 0,
																								AAP_ActionsRemainingToBeObligated__c 	 = 0,
																								PHX_Encumbered_Expiring_Amt__c 			 = 0,
																								PHX_Sub_Allowed_Expiring_Amt__c 		 = 0,
																								PHX_Sub_Allowed_Expiring_Encm_Amt__c 	 = 0,
																								PHX_Sub_Allowed_Pct_Expiring_Encm_Amt__c = 0);
			if( bLongName == null && phxData.BUREAU_CD__c == 'IDEA' /*&& phxData.Program_OE_Flag__c == 'P'*/ ){
				bLongName = shortToLong.get('LAB');
				// Check if a LAB record exists in records to be upserted.
				// if it does, use that record and add values to it
				for( Integer i = 0; i < upsertHolder.size(); i++){
					if( upsertHolder[i].PHX_BUREAU_CD__c == 'LAB' 
						&& upsertHolder[i].PHX_Program_OE_Flag__c == phxData.Program_OE_Flag__c ){
						reportObj = upsertHolder.remove( i );
					}
				}
			}
			if( bLongName != null ){
				//build up the report object using A&A Plan rolled up data

				// Check in general for existing records already 
				// in the set to be upserted. if it exists already
				// use that record and add values to it.
				for( Integer i = 0; i < upsertHolder.Size(); i++){
					if( upsertHolder[i].PHX_BUREAU_CD__c == phxData.BUREAU_CD__c 
						&& upsertHolder[i].PHX_Program_OE_Flag__c == phxData.Program_OE_Flag__c ){
						reportObj = upsertHolder.remove( i );
					}
				}
				reportObj.AAP_ActionsRemainingToBeExecuted__c += 0;
				reportObj.AAP_Actions__c += bureauActions.get(bLongName).size();
				reportObj.AAP_ActionsAlreadyAwarded__c += 0;
				reportObj.AAP_ActionsNotAwardedUsingExpFunds__c += 0;
				reportObj.AAP_ActionsOver25MNotAwarded__c += 0;
				
				for( AAPlanDetail__c detail : bureauActions.get(bLongName)){
					if(detail.AwardNumber__c != 'TBD'){
						reportObj.AAP_ActionsAlreadyAwarded__c++;
					}else{
						reportObj.AAP_ActionsRemainingToBeExecuted__c++;
						if(detail.Is_this_Action_using_Expiring_Funds__c == 'Yes'){
							reportObj.AAP_ActionsNotAwardedUsingExpFunds__c++;
						}
						if(over25M.contains(detail.TotalEstimateCost__c)){
							reportObj.AAP_ActionsOver25MNotAwarded__c++;
						}
					}
				}
				
				if(reportObj.AAP_Actions__c == 0){
					reportObj.AAP_PctActionsNotAwardedUsingExpFunds__c += 0;
					reportobj.AAP_ActionsRemainingToBeObligated__c += 0;
				}else{
					reportObj.AAP_PctActionsNotAwardedUsingExpFunds__c = 
						(reportObj.AAP_ActionsNotAwardedUsingExpFunds__c / reportObj.AAP_Actions__c) * 100.00;
					reportObj.AAP_ActionsRemainingToBeObligated__c = 
						(reportObj.AAP_ActionsRemainingToBeExecuted__c / reportObj.AAP_Actions__c) * 100.00;
				}
				
				//add the appropriate long and short bureau names
				//long name is the current bureau string we are on
				reportObj.AAP_Bureau__c = bLongName;
				reportObj.PHX_BUREAU_CD__c = phxData.BUREAU_CD__c;
				
				//short name is the abrreviation that is matched to the current bureau name
				if(phxData.BUREAU_CD__c == 'IDEA' && phxData.Program_OE_Flag__c == 'P'){
					reportObj.PHX_BUREAU_CD__c = 'LAB';
				}else{
					reportObj.PHX_BUREAU_CD__c = phxData.BUREAU_CD__c;
				}
				
				
				//add phoenix data
				//if this is LAB - get and add the IDEA data as well
				//LAB only has an 'O' row so add 'O' IDEA data to it 
				//per Mike Pontiakos
				if(phxData.BUREAU_CD__c == 'LAB' && phxData.Program_OE_Flag__c == 'O'){

					try{
						A_A_Phoenix_Data__c IDEAdata =
														[SELECT Id, BUREAU_CD__c, Encumbered_Expiring_Amt__c, id__c, 
														Program_OE_Flag__c, Sub_Allowed_Expiring_Amt__c, Sub_Allowed_Expiring_Encm_Amt__c, 
														Sub_Allowed_Pct_Exprng_Encm_Amt__c 
														FROM A_A_Phoenix_Data__c
														WHERE BUREAU_CD__c = 'IDEA' AND Program_OE_Flag__c = 'O'];
														
						reportObj.PHX_Encumbered_Expiring_Amt__c  += phxData.Encumbered_Expiring_Amt__c +
															  			IDEAdata.Encumbered_Expiring_Amt__c;
						reportObj.PHX_id__c						  = phxData.id__c;
						reportObj.PHX_Program_OE_Flag__c		  = phxData.Program_OE_Flag__c;
						Double sub_allowed_exp 					  = phxData.Sub_Allowed_Expiring_Amt__c +
																		IDEAdata.Sub_Allowed_Expiring_Amt__c;
						reportObj.PHX_Sub_Allowed_Expiring_Amt__c += sub_allowed_exp;
						Double sub_allowed_encm 				  = phxData.Sub_Allowed_Expiring_Encm_Amt__c +
																		IDEAdata.Sub_Allowed_Expiring_Encm_Amt__c;
						reportObj.PHX_Sub_Allowed_Expiring_Encm_Amt__c += sub_allowed_encm;
						
						//need to redo the percentage
						if(sub_allowed_exp == 0){
							reportObj.PHX_Sub_Allowed_Pct_Expiring_Encm_Amt__c	+= 0;
						}else if( reportObj.PHX_Sub_Allowed_Pct_Expiring_Encm_Amt__c == null 
									|| reportObj.PHX_Sub_Allowed_Pct_Expiring_Encm_Amt__c == 0 ){
							reportObj.PHX_Sub_Allowed_Pct_Expiring_Encm_Amt__c = (sub_allowed_encm / sub_allowed_exp) * 100.00;
						}else if( reportObj.PHX_Sub_Allowed_Pct_Expiring_Encm_Amt__c != null 
									&& reportObj.PHX_Sub_Allowed_Pct_Expiring_Encm_Amt__c != 0 ){
							reportObj.PHX_Sub_Allowed_Pct_Expiring_Encm_Amt__c = ((((sub_allowed_encm / sub_allowed_exp) * 100.00) + reportObj.PHX_Sub_Allowed_Pct_Expiring_Encm_Amt__c) /2);
						}
					}catch( Exception e ){
						//IDEAdata returns no rows, roll up the data just to to LAB
						reportObj.PHX_Encumbered_Expiring_Amt__c			+= phxData.Encumbered_Expiring_Amt__c;
						reportObj.PHX_id__c									= phxData.id__c;
						reportObj.PHX_Program_OE_Flag__c					= phxData.Program_OE_Flag__c;
						reportObj.PHX_Sub_Allowed_Expiring_Amt__c			+= phxData.Sub_Allowed_Expiring_Amt__c;
						reportObj.PHX_Sub_Allowed_Expiring_Encm_Amt__c		+= phxData.Sub_Allowed_Expiring_Encm_Amt__c;
						reportObj.PHX_Sub_Allowed_Pct_Expiring_Encm_Amt__c	+= phxData.Sub_Allowed_Pct_Exprng_Encm_Amt__c;
						
					}
					
					
				}else if(phxData.BUREAU_CD__c == 'LAB' && phxData.Program_OE_Flag__c == 'P'){
					try{
						A_A_Phoenix_Data__c IDEAdata =
														[SELECT Id, BUREAU_CD__c, Encumbered_Expiring_Amt__c, id__c, 
														Program_OE_Flag__c, Sub_Allowed_Expiring_Amt__c, Sub_Allowed_Expiring_Encm_Amt__c, 
														Sub_Allowed_Pct_Exprng_Encm_Amt__c 
														FROM A_A_Phoenix_Data__c
														WHERE BUREAU_CD__c = 'IDEA' AND Program_OE_Flag__c = 'P'];
														
						reportObj.PHX_Encumbered_Expiring_Amt__c  += phxData.Encumbered_Expiring_Amt__c +
															  			IDEAdata.Encumbered_Expiring_Amt__c;
						reportObj.PHX_id__c						  = phxData.id__c;
						reportObj.PHX_Program_OE_Flag__c		  = phxData.Program_OE_Flag__c;
						Double sub_allowed_exp 					  = phxData.Sub_Allowed_Expiring_Amt__c +
																		IDEAdata.Sub_Allowed_Expiring_Amt__c;
						reportObj.PHX_Sub_Allowed_Expiring_Amt__c += sub_allowed_exp;
						Double sub_allowed_encm 				  = phxData.Sub_Allowed_Expiring_Encm_Amt__c +
																		IDEAdata.Sub_Allowed_Expiring_Encm_Amt__c;
						reportObj.PHX_Sub_Allowed_Expiring_Encm_Amt__c += sub_allowed_encm;
						
						//need to redo the percentage
						if(sub_allowed_exp == 0){
							reportObj.PHX_Sub_Allowed_Pct_Expiring_Encm_Amt__c	+= 0;
						}else if( reportObj.PHX_Sub_Allowed_Pct_Expiring_Encm_Amt__c == null 
									|| reportObj.PHX_Sub_Allowed_Pct_Expiring_Encm_Amt__c == 0 ){
							reportObj.PHX_Sub_Allowed_Pct_Expiring_Encm_Amt__c = (sub_allowed_encm / sub_allowed_exp) * 100.00;
						}else if( reportObj.PHX_Sub_Allowed_Pct_Expiring_Encm_Amt__c != null 
									&& reportObj.PHX_Sub_Allowed_Pct_Expiring_Encm_Amt__c != 0 ){
							reportObj.PHX_Sub_Allowed_Pct_Expiring_Encm_Amt__c = ((((sub_allowed_encm / sub_allowed_exp) * 100.00) + reportObj.PHX_Sub_Allowed_Pct_Expiring_Encm_Amt__c) /2);
						}
					}catch( Exception e ){
						//IDEAdata returns no rows, roll up the data just to to LAB
						reportObj.PHX_Encumbered_Expiring_Amt__c			+= phxData.Encumbered_Expiring_Amt__c;
						reportObj.PHX_id__c									= phxData.id__c;
						reportObj.PHX_Program_OE_Flag__c					= phxData.Program_OE_Flag__c;
						reportObj.PHX_Sub_Allowed_Expiring_Amt__c			+= phxData.Sub_Allowed_Expiring_Amt__c;
						reportObj.PHX_Sub_Allowed_Expiring_Encm_Amt__c		+= phxData.Sub_Allowed_Expiring_Encm_Amt__c;
						reportObj.PHX_Sub_Allowed_Pct_Expiring_Encm_Amt__c	+= phxData.Sub_Allowed_Pct_Exprng_Encm_Amt__c;
						
					}
				}else{
					//if it is not LAB (everything else)
					//add the phoenix data
					reportObj.PHX_Encumbered_Expiring_Amt__c			+= phxData.Encumbered_Expiring_Amt__c;
					reportObj.PHX_id__c									= phxData.id__c;
					reportObj.PHX_Program_OE_Flag__c					= phxData.Program_OE_Flag__c;
					reportObj.PHX_Sub_Allowed_Expiring_Amt__c			+= phxData.Sub_Allowed_Expiring_Amt__c;
					reportObj.PHX_Sub_Allowed_Expiring_Encm_Amt__c		+= phxData.Sub_Allowed_Expiring_Encm_Amt__c;
					reportObj.PHX_Sub_Allowed_Pct_Expiring_Encm_Amt__c	+= phxData.Sub_Allowed_Pct_Exprng_Encm_Amt__c;
				}
				
				
				//check to see if a record already exists for this bureau.  if so, add the id.
				//we will be doing nightly refresh on data
				//it will be created outright the first time but updated every run after
				for(AAPlan_Bureau_Phoenix_Report__c reportData : existingReportObjs){
					if( reportData.AAP_Bureau__c == bLongName && reportData.PHX_Program_OE_Flag__c == phxData.Program_OE_Flag__c){
						reportObj.Id = reportData.Id;
					}
				}
				
				//add the reportObj to the upsert list
				upsertHolder.add(reportObj);
			}
		}
		
		//upsert all report data objects
		Database.upsert(upsertHolder,false);
	}
	
}