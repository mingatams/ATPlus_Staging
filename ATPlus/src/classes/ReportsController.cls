public with sharing class ReportsController {
    
    public String SearchOperatingUnitId {get; set;}
    public SelectOption[] OperatingUnitOptions {get; private set;}
    public Integer NumOpUnits {get; private set;}
    
    public String SearchFiscalYearId {get; set;}
    public SelectOption[] FiscalYearOptions {get; private set;}
    
    public String SearchBFL {get; set;}
    public SelectOption[] BFLOptions {get; private set;}

    public String optGroupDOM {get;private set;}

    public String FullAAPlanReportUrl {get; private set;}
    public String programPlanReportUrl {get; private set;}
    public String businessForecastReportUrl {get; private set;}
    public String aaAccountabilityUrl {get; private set;}
    public String aaBureauReportUrl {get; private set;}
    public String aaBureauSummaryUrl {get;set;}
    public String aaBureauTotalsUrl {get;set;}
    
    private Id fullAAPlanReportId;
    private Id programPlanReportId;
    private Id businessForecastReportId;
    private Id aaAccountabilityReportId;
    private Id aaBureauReportId;
    private Id aaBureauSummaryReportId;
    private Id aaBureauTotalsReportId;
    
    public Integer resultCount {get; private set;}

    public String lastRun {get; set;}
    
    private Set<String> profiles = new Set<String>{'A&A Planning All Data',
                                                   'System Administrator', 
                                                   'System Administrator(c)',
                                                   'A&A Planning Admin',
                                                   'A&A Plan System Administrator(c)'};
    public boolean reportCheck { get; private set;}
    public ReportsController() {
        loadOperatingUnitDOMElements();
        try{
            List<A_A_Phoenix_Data__c> phoenixDataRuns = [SELECT LastModifiedDate
                                        FROM A_A_Phoenix_Data__c
                                        LIMIT 1];
            if( !phoenixDataRuns.isEmpty() ){
                lastRun = phoenixDataRuns[0].lastModifiedDate.format('MM/dd/yyyy h:mm a');
            }else if( phoenixDataRuns.isEmpty() ){
                List<AAPlan_Bureau_Phoenix_Report__c> bureauAndPhoenixDataRuns = [SELECT LastModifiedDate
                                                                                    FROM AAPlan_Bureau_Phoenix_Report__c
                                                                                    LIMIT 1];
                if( !bureauAndPhoenixDataRuns.isEmpty() ){
                    lastRun = bureauAndPhoenixDataRuns[0].lastModifiedDate.format('MM/dd/yyyy h:mm a');
                }else{
                    lastRun = null;
                }
            }
        }catch(Exception e){
            lastRun = null;
        }
        
        FiscalYearOptions = AppUtil.getFiscalYearOptionsWithId();
        OperatingUnitOptions = AppUtil.getOperatingUnitOptionsWithId();
        NumOpUnits = OperatingUnitOptions.size();
        BFLOptions = AppUtil.getBFLOptions();
        
        String year = AppUtil.urlParam('year');
        if(!String.isBlank(year)) {
            SearchFiscalYearId = year;
        }
        
        String opUnit = AppUtil.urlParam('opUnit');
        if(!String.isBlank(opUnit)) {
            SearchOperatingUnitId = opUnit;
        }
        
        String BFL = AppUtil.urlParam('BFL');
        if(!String.isBlank(BFL)) {
            SearchBFL = BFL;
        }
        
        reportCheck = [SELECT ID 
                        FROM User 
                        WHERE ID = :UserInfo.getUserId() 
                        AND Profile.Name IN :profiles].size() > 0;
        
        initReportIds();
        
        searchx();
    }
    
    private void initReportIds() {
        for(Report report : [SELECT Id, DeveloperName FROM Report WHERE DeveloperName IN (
                'Full_A_A_Plan_Report', 'Program_Plan_Report', 'Business_Forecast_Report', 
                'AA_Accountability', 'A_A_Bureau_Report', 'A_A_Bureau_Summary_Report', 'A_A_Bureau_Totals_Report')]) {
            if(report.DeveloperName == 'Full_A_A_Plan_Report') {
                fullAAPlanReportId = report.Id;
            }
            if(report.DeveloperName == 'Program_Plan_Report') {
                programPlanReportId = report.Id;
            }
            if(report.DeveloperName == 'Business_Forecast_Report') {
                businessForecastReportId = report.Id;
            }
            if(report.DeveloperName == 'AA_Accountability') {
                aaAccountabilityReportId = report.Id;
            }
            if(report.DeveloperName == 'A_A_Bureau_Report') {
                aaBureauReportId = report.Id;
            }
            if(report.DeveloperName == 'A_A_Bureau_Summary_Report'){
                aaBureauSummaryReportId = report.Id;
            }
            if(report.DeveloperName == 'A_A_Bureau_Totals_Report'){
                aaBureauTotalsReportId = report.Id;
            }
        }
    }
    
    public void searchx() {
        
        String[] ids = new String[0];
        if(AppUtil.isMultiSelectEmpty(SearchFiscalYearId) &&
                AppUtil.isMultiSelectEmpty(SearchOperatingUnitId)) {
            resultCount = getCount();
        } else {
            for(AAPlan__c plan : query()) {
                ids.add(String.valueOf(plan.id).left(15));
            }
            resultCount = ids.size();
        }
        
        if(resultCount > 0) {
            String[] bflArray = new String[]{};
            if(!AppUtil.isMultiSelectEmpty(SearchBFL)){
                bflArray = AppUtil.getStringsFromMultiSelect(SearchBFL);
            }
            String params = AppUtil.makeBFReportUrlParams('CUST_ID', ids, bflArray);
            
            //Full AA Plan Report
            String fullAAPlanReportParams = AppUtil.makeFullAAReportUrlParams(ids, bflArray);
            fullAAPlanReportUrl = '/'+fullAAPlanReportId+'?'+fullAAPlanReportParams;
            
            //Planned Activity Report
            String programPlanReportParams = AppUtil.makeReportUrlParams(ids, bflArray, new String[]{}, new String[]{});
            programPlanReportUrl = '/'+programPlanReportId+'?'+programPlanReportParams;
            
            //Business Forecast Report
            String bfparams;
            if(bflArray.size() == 0){
                bfparams = AppUtil.makeReportUrlParams(ids, new String[]{'Yes'}, new String[]{}, new String[]{});
            }else{
                bfparams = AppUtil.makeReportUrlParams(ids, bflArray, new String[]{}, new String[]{});
            }
            businessForecastReportUrl = '/'+businessForecastReportId+'?'+bfparams;
            
            //AA Accountability Report
            String[] accountabilityTEC = new String[]{'$25M - $49.99M','$50M - $74.99M','$75M - $149.99M','$150M - $299.99M','$300M - $499.99M','$500M - $999.99M','$1B+'};
            String[] accountabilityAT = new String[]{'Contract','Grant','Development Innovation Accelerator (DIA)','Collaborative Agreement',
                                                    'Cooperative Agreement','Associate Award','Blanket Purchase Agreement (BPA)','Indefinite Delivery Indefinite Quantity Contract (IDIQ)',
                                                    'Leader with Associate Award (LWA)','Public International Organization Award (PIO)','Small Business Task Order',
                                                    'Task Order/Delivery Order (TO/DO)'};
            String accountabilityParams = AppUtil.makeReportUrlParams(ids, bflArray, accountabilityTEC, accountabilityAT);
            aaAccountabilityUrl = '/'+aaAccountabilityReportId+'?'+accountabilityParams;
            
            //AA Bureau Report
            String aaBureauReportParams = AppUtil.makeReportUrlParams(ids, bflArray, new String[]{}, new String[]{});
            aaBureauReportUrl = '/'+aaBureauReportId+'?'+aaBureauReportParams;
            
            //Complex Award Report
            aaBureauSummaryUrl = '/'+aaBureauSummaryReportId;
            
            //Bureau Totals Report
            String[] totalsTEC = new String[]{'$75M - $149.99M','$150M - $299.99M','$300M - $499.99M','$500M - $999.99M','$1B+'};
            String totalsParams = AppUtil.makeReportUrlParams(ids, bflArray, totalsTEC, new String[]{});
            aaBureauTotalsUrl = '/'+aaBureauTotalsReportId+'?'+ totalsParams;
        }
        
    }
    
    private Integer getCount() {
        return (Integer)[SELECT COUNT(Id) cnt FROM AAPlan__c][0].get('cnt');
    }
    
    private AAPlan__c[] query() {
        return Database.query(new SoqlBuilder()
            .selectx('Id')
            .fromx('AAPlan__c')
            .wherex(buildCondition())
            .toSoql()
        );
    }
    
    private ConditionGroup buildCondition() {
        ConditionGroup condition = new AndCondition();
        if(!AppUtil.isMultiSelectEmpty(SearchFiscalYearId)) {
            condition.add(new SetCondition('FiscalYear__c').inx(AppUtil.getStringsFromMultiSelect(SearchFiscalYearId)));
        }
        if(!AppUtil.isMultiSelectEmpty(SearchOperatingUnitId)) {
            condition.add(new SetCondition('OperatingUnit__c').inx(AppUtil.getStringsFromMultiSelect(SearchOperatingUnitId)));
        }
        return condition;
    }
    
    private void loadOperatingUnitDOMElements() {
        optGroupDOM = '';
        
        List<OperatingUnit__c> opunits = [SELECT Id, Name, Bureau__c FROM OperatingUnit__c order by bureau__c ASC, Name ASC];
        
        List<String> bureaus = new List<String>();
        for(OperatingUnit__c opunit : opunits){
            bureaus.add(opunit.Bureau__c);
        }
        
        Map<String, List<OperatingUnit__c>> optgrps = new Map<String, List<OperatingUnit__c>>();
        
        for( String bureau : bureaus ){
            List<OperatingUnit__c> bureauopunits = new List<OperatingUnit__c>();
            for(OperatingUnit__c opunit : opunits){
                if( null != opunit.Bureau__c && opunit.Bureau__c == bureau){
                    bureauopunits.add(opunit);
                }
            }
            optgrps.put(bureau, bureauopunits);
        }
        
        List<String> sortedBureaus = new List<String>(optgrps.keySet());
        sortedBureaus.sort();
        
        for( String bureau : sortedBureaus ){
            List<OperatingUnit__c> options = optgrps.get(bureau);
            
            optGroupDOM += '<optgroup label=\"' + bureau + '\">';
            
            for(OperatingUnit__c opunit : options){
                optGroupDOM += '<option value=\"' + opunit.Id + '\">' + opunit.Name + '</option>';
            }
            
            optGroupDOM += '</optgroup>';
        }

        optGroupDOM = optGroupDOM.replaceAll('\'','&#39;');
    }
}