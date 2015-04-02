/**
* AppUtil is used in various classes throughout the A&A Application.
*
* CHANGE HISTORY
* =============================================================================
* Date				Name				Description
* Aug 11 2014      	Brian Mason			Created
* Oct 07 2014		Brian Mason			Added	Comments
* =============================================================================
*/
public with sharing class AppUtil {

    public static final Integer SOQL_LIMIT = 10000;
    public static final Integer SEARCH_PAGE_SIZE = 25;

    /*
        Helper to prepare all the options for the dropdown List
    */
    public static List<SelectOption> prepareSelectOption(Schema.DescribeFieldResult describeField){

        List<SelectOption> selectOptions = new List<SelectOption>();
        List<Schema.PickListEntry> pickListEntries = describeField.getPicklistValues();

        for(Schema.PickListEntry opt : pickListEntries){
            selectOptions.add(new SelectOption(opt.getLabel(), opt.getValue()));
        }

        return selectOptions;
    }

    // Method to return SelectOptions of Fiscal Years with IDs in dropdowns
    public static SelectOption[] getFiscalYearOptionsWithId() {
        SelectOption [] fiscalYearOptions = new SelectOption[]{};
        for(FiscalYear__c fy : [SELECT Year__c FROM FiscalYear__c ORDER BY Year__c DESC LIMIT :AppUtil.SOQL_LIMIT]) {
            fiscalYearOptions.add(new SelectOption(String.valueOf(fy.Id), String.valueOf(fy.Year__c)));
        }
        return fiscalYearOptions;
    }

    // Method to return SelectOptions of Fiscal Years with Year as number in dropdowns
    public static SelectOption[] getFiscalYearOptionsWithNumber() {
        SelectOption [] fiscalYearOptions = new SelectOption[]{};
        for(FiscalYear__c fy : [SELECT Year__c FROM FiscalYear__c ORDER BY Year__c DESC LIMIT :AppUtil.SOQL_LIMIT]) {
            fiscalYearOptions.add(new SelectOption(String.valueOf(fy.Year__c), String.valueOf(fy.Year__c)));
        }
        return fiscalYearOptions;
    }

    // Method to return Planning Units with IDs in dropdowns
    public static SelectOption[] getOperatingUnitOptionsWithId() {
        List<SelectOption> selectOptions = new List<SelectOption>();
        for(OperatingUnit__c oul : [SELECT Name FROM OperatingUnit__c WHERE Name != null ORDER BY OperatingUnitName__c]) {
            selectOptions.add(new SelectOption(oul.Id, oul.Name));
        }
        return selectOptions;
    }
    
    // Method to return Bureaus in dropdowns
    public static SelectOption[] getBureaus() {
        List<SelectOption> selectOptions = new List<SelectOption>();
        List<AggregateResult> bureaus = [Select Bureau__c From OperatingUnit__c Group By Bureau__c Having COUNT( Bureau__c ) > 1];
        if( !bureaus.isEmpty() ){
        	for( AggregateResult ar : bureaus ){
        		selectOptions.add( new SelectOption( (String)ar.get( 'Bureau__c' ), (String)ar.get( 'Bureau__c' ) ) );
        	}
        }
		selectOptions.sort();
        return selectOptions;
    }
    
    public static SelectOption[] getBureauChildren( String[] bureaus ) {
        List<SelectOption> selectOptions = new List<SelectOption>();
    	if( !bureaus.isEmpty() ) {
    		for( OperatingUnit__c ou : [SELECT ID, Name, Bureau__c FROM OperatingUnit__c WHERE Bureau__c IN :bureaus ORDER BY Bureau__c ASC, Name ASC LIMIT :AppUtil.SOQL_LIMIT] ) {
    			selectOptions.add( new SelectOption( ou.id, ou.Name ) );
    		}
    	}
    	return selectOptions;
    }

	// Method to return NAICS options in dropdowns
    public static SelectOption[] getNAICSCodeOptions() {
        List<SelectOption> selectOptions = new List<SelectOption>();
        selectOptions.add(new SelectOption('', 'All'));
        for(NAICSCode__c r : [SELECT Name, Description__c FROM NAICSCode__c WHERE Name != null]) {
            selectOptions.add(new SelectOption(r.Id, r.Name+' '+r.Description__c));
        }
        return selectOptions;
    }

	// Method to return Type options in dropdowns
    public static SelectOption[] getRegionOptions() {
        return prepareSelectOption(sObjectType.OperatingUnit__c.fields.Region__c);
    }

	// Method for returning a single NAICSCode__c by name
    public static NAICSCode__c getNAICSCodeOptions(String naicsCode) {
        NAICSCode__c result = null;
        for(NAICSCode__c r : [SELECT Name, Description__c FROM NAICSCode__c WHERE Name = :naicsCode]) {
            result = r;
            break;
        }
        return result;
    }

	// Method for returning a single FiscalYear__c
    public static FiscalYear__c getActiveYear() {
        FiscalYear__c[] active = [SELECT Year__c, CurrentQuar__c FROM FiscalYear__c WHERE IsActive__c = TRUE LIMIT 1];
        if(active.size() > 0) {
            return active[0];
        }
        return null;
    }

	// Method for returning SelectOptions for Business_Forecast_Listing__c values
    public static SelectOption[] getBFLOptions(){
        return prepareSelectOption(sObjectType.AAPlanDetail__c.fields.Business_Forecast_Listing__c);
    }

	// Method to return a value from current page parameters
    public static String urlParam(String key) {
        return ApexPages.currentPage().getParameters().get(key);
    }

	// Method to check if a Multiselect option is empty
    public static boolean isMultiSelectEmpty(String values) {
        return String.isBlank(values) || values == '[]';
    }

	//  Method to retrieve values from Multiselect
    public static String[] getStringsFromMultiSelect(String values) {
    	String[] retval = values.removeStart('[').removeEnd(']').split(',');
    	for( Integer i = 0; i < retval.size(); i++ ){
    		retval[i] = retval[i].trim();
    	}
        return retval;
    }

	// Method to return URL to report from criteria passed in
    public static String getReportUrlFromCriteria(Id reportUrl, String fieldName, String[] fieldValues, String[] bflValues) {
    	if(fieldValues.size() == 0)
			return '/'+reportUrl;
		else
        	return '/'+reportUrl+'?'+makeBFReportUrlParams(fieldName, fieldValues, bflValues);
    }

	// Method to create the URL for the Full AA Report
    public static String makeFullAAReportUrlParams( String[] mbioValues, String[] bflValues ){

        String paramStr = '';
        string boolFilter = '';

        if( mbioValues != NULL && !mbioValues.isEmpty() ){
            paramStr = 'pv0=';
            for( String str : mbioValues ){
                paramStr += (str + ',');
            }
            paramStr = paramStr.removeEnd(',');
            paramStr += '&';
            boolFilter = 'bool_filter=1+AND+2';
        }else if( mbioValues != NULL && mbioValues.isEmpty() ) {
            paramStr = 'pv0=';
            Set<ID> ouIDs = new Set<ID>();
            for( SelectOption s : getOperatingUnitOptionsWithId() ) {
                ouIDs.add( s.getValue() );
            }

            for( AAPlan__c a : [SELECT ID FROM AAPlan__c WHERE OperatingUnit__c IN :ouIDs] ) {
                paramStr += ( String.valueOf(a.id).left(15) + ',' );
            }
            paramStr = paramStr.removeEnd(',');
            paramStr += '&';
            boolFilter = 'bool_filter=1+AND+2';
        }
        
        if( bflValues != NULL && !bflValues.isEmpty() ){
            paramStr += 'pv1=';
            for( String str : bflValues ){
                paramStr += (str + ',');
            }
            paramStr = paramStr.removeEnd(',');
            paramStr += '&';

            boolFilter = 'bool_filter=1+AND+2';

        }else if( bflValues != NULL && bflValues.isEmpty() ) {
            paramStr += 'pv1=Yes,No,&';
            boolFilter = 'bool_filter=1+AND+2';
        }
        return paramStr + boolFilter;
    }

	// Method to create the URL for all other reports
   	public static String makeReportUrlParams(String[] mbioValues, String[] bflValues, String[] tecValues,String[] atValues) {
        String ofiBFLid = Object_Field_IDs__c.getValues('AAPlanDetail.Business_Forecast_Listing').Field_ID__c;
        String ofiTECid = Object_Field_IDs__c.getValues('AAPlanDetail.TotalEstimatedCost').Field_ID__c;
        String ofiATid = Object_Field_IDs__c.getValues('AAPlanDetail.ActionOrAwardType').Field_ID__c;
        String ofiOBJid = 'CUST_ID';
		
        String paramStr = '';
        List<String> paramList = new List<String>();
        String mbioCriteria = '';
        String tecCriteria = '';
        String bflCriteria = '';
        String atCriteria = '';
        String finalCriteria = '';
        Integer curParam = 0;
		
		/*
        //add params for M/B/IO
        if( mbioValues.size() > 1 )
        	mbioCriteria += '(';
        for( String mbio : mbioValues){
        	//build and add the param
        	paramList.add( 'pc' + curParam + '=' + ofiOBJid + '&pn' + curParam + '=' + 'eq' + '&pv' + curParam + '=' + mbio );
        	//add the filter criteria
        	if( mbioValues[mbioValues.size()-1] != mbio && mbioValues.size() > 1 )
        		mbioCriteria += (curParam + 1) + ' OR ';
        	else
        		mbioCriteria += (curParam + 1);
        	//increment current parameter counter
        	curParam++;
        }
        if( mbioValues.size() > 1 )
        	mbioCriteria += ')';
        */
        
        //add param for M/B/IO
        if(mbioValues.size() > 1){
        	String mbioList = '';
	        for(String mbio : mbioValues){
	        	mbioList += mbio;
	        	if( mbio != mbioValues[mbioValues.size()-1] ){
	        		mbioList += ',';
	        	}
	        }
	        mbioList = 'pc'+curParam + '=' + ofiOBJid + '&pn'+curParam + '=eq' + '&pv'+curParam + '=' + mbioList;
	        paramList.add(mbioList);
	        mbioCriteria += (curParam +1);
	        curParam++;
        }
        
        //add param for Award Type
        if(atValues.size() > 0){
        	String atList = '';
        	for(String atval : atValues){
        		atList += atval;
        		if( atval != atValues[atValues.size()-1] ){
	        		atList += ',';
	        	}
        	}
        	atList = 'pc'+curParam + '=' + ofiATid + '&pn'+curParam + '=eq' + '&pv'+curParam + '=' + atList;
	        paramList.add(atList);
	        atCriteria += (curParam +1);
	        curParam++;
        }
        
        //add param for TEC values
        if( tecValues.size() > 0){
        	//build the parameter
	        String tecParam = 'pc' + curParam + '=' + ofiTECid + '&pn' + curParam + '=' + 'co' + '&pv' + curParam + '=';
	        //build the contains list
	        String tecpv = '';
	        for( String tec : tecValues){
	        	//last one, no comma
	        	if( tecValues[tecValues.size()-1] == tec )
	        		tecpv += tec;
	        	else
	        		tecpv += tec + ',';
	        }
	        //add the parameter 
	        paramList.add( tecParam + EncodingUtil.urlEncode( tecpv, 'UTF-8'));
	        //add the filter criteria
	        tecCriteria += (curParam +1);
	        //increment current parameter counter
	        curParam++;
        }
		
        //add params for Business Forcast Listing
        if( bflValues.size() > 1 )
        	bflCriteria += '(';
        for( String bfl : bflValues){
        	//build and add the param
        	paramList.add( 'pc' + curParam + '=' + ofiBFLid + '&pn' + curParam + '=' + 'eq' + '&pv' + curParam + '=' + bfl );
        	//add the filter criteria
        	if( bflValues[bflValues.size()-1] != bfl && bflValues.size() > 1 )
        		bflCriteria += (curParam + 1) + ' OR ';
        	else
        		bflCriteria += (curParam + 1);
        	//increment current parameter counter
        	curParam++;
        }
        if( bflValues.size() > 1 )
        	bflCriteria += ')';
		
        //build final criteria and add paramter
        if( !String.isBlank(mbioCriteria) ){
        	finalCriteria += mbioCriteria;
        	if( !String.isBlank(tecCriteria) || !String.isBlank(bflCriteria) || !String.isBlank(atCriteria) ){
        		finalCriteria += ' AND ';
        	}
        }
        if( !String.isBlank(tecCriteria) ){
        	finalCriteria += tecCriteria;
        	if( !String.isBlank(bflCriteria) || !String.isBlank(atCriteria) ){
        		finalCriteria += ' AND ';
        	}
        }
        if( !String.isBlank(atCriteria) ){
        	finalCriteria += atCriteria;
        	if( !String.isBlank(bflCriteria) ){
        		finalCriteria += ' AND ';
        	}
        }
        if( !String.isBlank(bflCriteria) ){
        	finalCriteria += bflCriteria;
        }
        finalCriteria = 'bool_filter=' + EncodingUtil.urlEncode(finalCriteria, 'UTF-8');
        paramList.add(finalCriteria);
		
        //combine all the parameters together for the final URL parameter string
        for(String param : paramList){
        	if( paramList.get(paramList.size()-1) != param )
        		paramStr += param + '&';
        	else
        		paramStr += param;
        }
        return paramStr;
    }
   	
   	// Method to create the URL for Business Forecast Report
    public static String makeBFReportUrlParams(String fieldName, String[] fieldValues, String[] bflValues) {
        Object_Field_IDs__c ofi = Object_Field_IDs__c.getValues('AAPlanDetail.Business_Forecast_Listing');
        String url = '';
        String filterCriteria = '(1';
        String bflField = '';
        String bflCriteria = '';
        if( bflValues != null && bflValues.size() > 1 && fieldValues.size() > 0 ){
            String str = '';
            for(String s : bflValues){
                str += s + ',';
            }
            bflField = 'pc'+fieldValues.size()+'='+ ofi.Field_ID__c +'&pn'+fieldValues.size() +'=co&pv'+ fieldValues.size() +'='+str.removeEnd(',');
            bflCriteria = ' AND ' + (fieldValues.size() + 1);
        }else if( bflValues != null && bflValues.size() > 1 && fieldValues.size() == 0 ){
            String str = '';
            for(String s : bflValues){
                str += s + ',';
            }
            bflField = 'pc'+fieldValues.size()+'='+ ofi.Field_ID__c +'&pn'+fieldValues.size() +'=co&pv'+ fieldValues.size() +'='+str.removeEnd(',');
            bflCriteria = '1';
        }else if( bflValues != null && bflValues.size() == 1 && fieldValues.size() == 0 ){
            bflField = 'pc'+fieldValues.size()+'='+ ofi.Field_ID__c +'&pn'+fieldValues.size() +'=eq&pv'+ fieldValues.size() +'='+bflValues[0];
            bflCriteria = '1';
        }else if( bflValues != null && bflValues.size() == 1 && fieldValues.size() > 0 ){
            bflField = 'pc'+fieldValues.size()+'='+ ofi.Field_ID__c +'&pn'+fieldValues.size() +'=eq&pv'+ fieldValues.size() +'='+bflValues[0];
            bflCriteria = ' AND ' + (fieldValues.size() + 1);
        }
        if( fieldValues.size() > 0 ){
            for(Integer i=0; i<fieldValues.size(); i++) {
                url += 'pc'+i+'='+fieldName+'&pn'+i+'=eq&pv'+i+'='+fieldValues[i]+'&';
                if(i > 0){
                    filterCriteria += ' OR '+(i+1);
                }
            }
            filterCriteria += filterCriteria =')';
        }else{
            filterCriteria ='';
        }
        return url + bflField + '&bool_filter=' + EncodingUtil.urlEncode(filterCriteria + bflCriteria, 'UTF-8');
    }

    //should only be used once on move to PROD
    //creates a blank Plan for all operating units
    public static void createBlankPlans2015(){

    	//holder for new plans
    	List<AAPlan__c> plans2015 = new List<AAPlan__c>();

    	List<OperatingUnit__c> opus = [SELECT Id,Parent__c,OperatingUnitName__c
    									FROM OperatingUnit__c
    									LIMIT :SOQL_LIMIT];

    	FiscalYear__c fy = [SELECT Id
    						FROM FiscalYear__c
    						WHERE Year__c = 2015];

    	for(OperatingUnit__c opu : opus){
    		AAPlan__c plan = new AAPlan__c();
    		if(opu.OperatingUnitName__c.length() > 73){
    			plan.Name = opu.OperatingUnitName__c.subString(0,74) + ' FY2015';
    		}else{
    			plan.Name = opu.OperatingUnitName__c + ' FY2015';
    		}
    		plan.FiscalYear__c = fy.Id;
    		plan.OperatingUnit__c = opu.Id;
    		plans2015.add(plan);
    	}
    	insert plans2015;
    }
}