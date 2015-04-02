public with sharing class AAPlanDoubleReportController {
	
	//dropdown selector
	public String selectedBureau {get;set;}
	//dorpdown options
	public List<SelectOption> bureauSelectOptions {get; private set;}
	
	//current data to display
	public ReportData currentReport {get; private set;}
	
	//all data
	private Map<String, ReportData> allData;
	
	private static final Set<String> over25M = new Set<String>{'$25M - $49.99M',
																'$50M - $74.99M',
																'$75M - $149.99M',
																'$150M - $299.99M',
																'$300M - $499.99M',
																'$500M - $999.99M',
																'$1B+'};
	
	public AAPlanDoubleReportController(){
		//init data map for storage
		allData = new Map<String, ReportData>();
		
		//init selector list
		bureauSelectOptions = new List<SelectOption>();

		getData();
	}
	
	private void getData(){
		Set<String> bureauNames = new Set<String>();
		
		List<AAPlan_Bureau_Phoenix_Report__c> rollupDataRows = [SELECT Id, AAP_ActionsRemainingToBeExecuted__c, AAP_Actions__c,
															AAP_ActionsAlreadyAwarded__c, AAP_ActionsNotAwardedUsingExpFunds__c,
															AAP_ActionsOver25MNotAwarded__c, AAP_PctActionsNotAwardedUsingExpFunds__c,
															AAP_ActionsRemainingToBeObligated__c, AAP_Bureau__c,
															PHX_BUREAU_CD__c, PHX_Encumbered_Expiring_Amt__c,
															PHX_id__c, PHX_Program_OE_Flag__c, PHX_Sub_Allowed_Expiring_Amt__c,
															PHX_Sub_Allowed_Expiring_Encm_Amt__c, PHX_Sub_Allowed_Pct_Expiring_Encm_Amt__c
															FROM AAPlan_Bureau_Phoenix_Report__c];
		
		//get all of the bureaus
		for( AAPlan_Bureau_Phoenix_Report__c rollupDataRow : rollupDataRows ){
			bureauNames.add(rollupDataRow.AAP_Bureau__c);
		}
		//populate the selector
		for( String name : bureauNames ){
			bureauSelectOptions.add( new SelectOption(name,name));
		}
		
		//each bureau has an O and P row
		//so for each bureau loop through and grab its O and P as well as any relevant actions
		//add it all into a ReportData object
		//map it to the bureau name for grab and display later
		for( String bureau : bureauNames ){
			
			//get O and P row
			List<AAPlan_Bureau_Phoenix_Report__c> OandP = new List<AAPlan_Bureau_Phoenix_Report__c>();
			for( AAPlan_Bureau_Phoenix_Report__c rollupDataRow : rollupDataRows ){
				if(rollupDataRow.AAP_Bureau__c == bureau){
					OandP.add(rollupDataRow);
				}
			}
			
			//get all actions of 25M or greater
			List<AAPlanDetail__c> relevantActions = [SELECT Id, AwardPriority__c, Status__c, 
													AandAPlan__r.OperatingUnit__r.OperatingUnitName__c,
													Anticipated_Start_Date__c, TotalEstimateCost__c,
													ActionOrAwardType__c, AwardTitle__c, Award_Description__c													
													FROM AAPlanDetail__c
													WHERE AandAPlan__r.OperatingUnit__r.Bureau__c = :bureau
													AND TotalEstimateCost__c IN :over25M];
													
			ReportData reportInstance = new ReportData(OandP, relevantActions);
			allData.put(bureau, reportInstance);
		}
	}
	
	public void setSelectedData(){
		currentReport = allData.get(selectedBureau);
	}
	
	public class ReportData{
		
		public List<AAPlan_Bureau_Phoenix_Report__c> rollupRows {get;private set;}
		public List<AAPlanDetail__c> actionRows {get;private set;}
		//for debugging and stuff
		public String JSONtopData {get;private set;}
		public String JSONbottomData {get;private set;}
		
		private ReportData(){
			//private default constructor
		}
		
		public ReportData( List<AAPlan_Bureau_Phoenix_Report__c> rollupRows, List<AAPlanDetail__c> actionRows ){
			this.rollupRows = rollupRows;
			this.actionRows = actionRows;
			JSONtopData = JSON.serialize(rollupRows);
			JSONbottomData = JSON.serialize(actionRows);
		}
	}
}