/**
* AdminController is used in A&A Admin page to
* assist with administering the A&A Application
*
* CHANGE HISTORY
* =============================================================================
* Date				Name				Description
* Aug 12 2014      	Brian Mason			Created
* Oct 07 2014		Brian Mason			Added	Comments
* =============================================================================
*/
public with sharing class AdminController {

	public List<FiscalYear__c> fiscalYearList {get;set;}
	public FiscalYear__c dummyFiscalYearRecord {get; private set;}

	public List<OperatingUnit__c> operatingUnitList {get;set;}
	public OperatingUnit__c dummyOperatingUnit {get; private set;}

    public List<operatingUnitGroupWrapper> operatingUnitGrpWrapper { get; set; }
    public transient String JSONGroups { get; private set; }
    private transient map<ID, List<operatingUnitGroupDetails>> mapOperatingUnitGroups {private get; private set;}

    public String selectedQuarter { get; set;}

	/*
		CONSTRUCTOR
	*/
	public AdminController() {

		dummyFiscalYearRecord = new FiscalYear__c();
		dummyOperatingUnit = new OperatingUnit__c();

		queryYears();
		queryOperatingUnits();
        
        if (fiscalYearList != NULL) {
            for(FiscalYear__c fy :fiscalYearList){
                if(fy.IsActive__c == TRUE){
                    selectedQuarter = fy.CurrentQuar__c;
                }
            }
        }
		
	}

	/*
		PUBLIC METHODS
	*/
	// Method to return fiscal years for display
	public void queryYears(){
		fiscalYearList = [SELECT Year__c, startDate__c, endDate__c, CurrentQuar__c, IsActive__c FROM FiscalYear__c ORDER BY Year__c DESC LIMIT 10000 ];
	}

	// Method to query Planning Units and Planning_Unit_Groups for display
	// as well as build the JSON object used in the dropdown
	public void queryOperatingUnits(){
		operatingUnitList = [SELECT Name, 
                             		OperatingUnitName__c, 
                             		Parent__r.OperatingUnitName__c,
                             		Region__c, 
                             		( SELECT Access_Level__c, 
                                     		 Group_ID__c, 
                                     		 Planning_Unit__c 
                                     	FROM Planning_Unit_Groups__r ) 
                             FROM 
                             		OperatingUnit__c 
                             ORDER BY 
                             		OperatingUnitName__c ASC 
                             LIMIT 10000 ];
        operatingUnitGrpWrapper = new List<operatingUnitGroupWrapper>();
        mapOperatingUnitGroups = new Map<ID, List<operatingUnitGroupDetails>>();
        if( operatingUnitList != null && !operatingUnitList.isEmpty() ){
            Set<ID> ids = new Set<ID>();
            for( OperatingUnit__c ou : operatingUnitList ){
                if( ou.Planning_Unit_Groups__r != null && !ou.Planning_Unit_Groups__r.isEmpty() ){
                    for( Planning_Unit_Group__c pug : ou.Planning_Unit_Groups__r ) {
                        if( String.isNotBlank( pug.Group_ID__c ) ) {
                        	ids.add( pug.Group_ID__c );
                    	}
                    }
                }
            }
            Map<ID, Group> lstGroups = new Map<ID, Group>([SELECT ID, Name, DeveloperName FROM Group WHERE Type= 'Regular' AND ID IN :ids]);
            for( OperatingUnit__c ou : operatingUnitList ) {
                List<operatingUnitGroupDetails> grpDetails = new List<operatingUnitGroupDetails>();
                if( ou.Planning_Unit_Groups__r != null && !ou.Planning_Unit_Groups__r.isEmpty() ){
                    for( Planning_Unit_Group__c pug : ou.Planning_Unit_Groups__r ) {
                        if( pug.Group_ID__c != null && lstGroups.containsKey( (ID)pug.Group_ID__c ) ) {
                            grpDetails.add( new operatingUnitGroupDetails( pug.Group_ID__c,
                                										   pug.Access_Level__c, 
																		   lstGroups.get( (ID)pug.Group_ID__c ).Name,
																		   lstGroups.get( (ID)pug.Group_ID__c ).DeveloperName ) );
                        }
                    }
                }
                operatingUnitGrpWrapper.add( new operatingUnitGroupWrapper( ou, grpDetails ) );
                
                mapOperatingUnitGroups.put( ou.id, grpDetails );
            }
        	JSONGroups = System.json.serialize(mapOperatingUnitGroups);
        }
	}

	// Method to create new Fiscal Year
	public pageReference createNewYear(){

		try{
			insert dummyFiscalYearRecord;
			queryYears();
		}catch(DmlException e){
			System.debug('The following Exception have occured: '+ e.getMessage());
		}
		return null;
	}

	// Method to create new Planning Unit
	public pageReference createNewOU(){

		try{
			insert dummyOperatingUnit;
			queryOperatingUnits();
		}catch(DmlException e){
			System.debug('The following Exception have occured: '+ e.getMessage());
		}
		return null;
	}

	// Method fired when Update Quarter button is clicked.
	// changes Quarter to value in selected dropdown
    public void updateCurrentQuarter(){
        boolean updateRec = false;
        if(selectedQuarter != null && selectedQuarter.length() > 0){
            queryYears();
            
            if (fiscalYearList != NULL) {
                for(FiscalYear__c fy :fiscalYearList){
                    if(fy.IsActive__c == TRUE){
                        fy.CurrentQuar__c = selectedQuarter;
                        updateRec = true;
                    }
                }
            }
            if(updateRec){
                update fiscalYearList;
                ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.CONFIRM , 'Quarter Successfully Changed' ) );
            }
        }
    }

	// Method to return selectoptions to dropdown for Quarters
    public List<SelectOption> getQuarterOptions(){
        Schema.DescribeFieldResult currentQuarDescription = FiscalYear__c.CurrentQuar__c.getDescribe();
        list<SelectOption> lstOptions = new list<SelectOption>();
        
        for (Schema.Picklistentry picklistEntry : currentQuarDescription.getPicklistValues())
        {
            
            lstOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        
        return lstOptions;
    }
    /*
		REMOTE ACTIONS
	*/
	// Remote Action Method callef when "Create new Quarter" button is clicked
	// to fire a batch job in the background.
	@RemoteAction
	public static void createNewQuarterRecords(){
		BatchQuarterlyRecordCreation bqrc = new BatchQuarterlyRecordCreation();
		Database.executeBatch(bqrc, 150);
	}
    
    /*
		PRIVATE CLASSES
	*/
	// Private class to join Planning Unit with Public Group
    private class operatingUnitGroupWrapper {
        public OperatingUnit__c operatingUnit{ get; private set; }
        public List<operatingUnitGroupDetails> operatingUnitGroupDetails{ get; private set; }
        
        public operatingUnitGroupWrapper( OperatingUnit__c opUnit, List<operatingUnitGroupDetails> opUnitGroupDetails ){
            this.operatingUnit = opUnit;
            this.operatingUnitGroupDetails = opUnitGroupDetails;
        }
    }

	// Private class to wrap the Planning_Unit_Group -> Group details for access
	private class operatingUnitGroupDetails {
        public String groupID { get; private set; }
        public String accessLevel { get; private set; }
        public String groupName { get; private set; }
        public String groupAPIName { get; private set; }
        
        public operatingUnitGroupDetails( String grpID, String accLevel, String grpName, String grpAPIName ){
            this.groupID = grpID;
            this.accessLevel = accLevel;
            this.groupName = grpName;
            this.groupAPIName = grpAPIName;
        }
    }
    
    
}