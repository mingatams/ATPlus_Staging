/**
* AAPlanListController is used in AAPlanList to view AAPlan__c records.
*
* CHANGE HISTORY
* =============================================================================
* Date              Name                Description
* Aug 11 2014       Brian Mason         Created
* Oct 07 2014       Brian Mason         Added   Comments
* =============================================================================
*/
public with sharing class AAPlanListController {
    /* Variables */
    public Integer queryLimit {
        get{
            return AppUtil.SOQL_LIMIT;
        }
    }

    public ApexPages.StandardSetController controller {get; private set;}
    public AAPlan__c[] results {
        get {
            return controller.getRecords();
        }   
    }

    public String SearchOperatingUnitId {get; set;}
    public List<SelectOption> OperatingUnitItems {get;private set;}
    public Integer NumOpUnits {get;private set;}

    public String SearchFiscalYearId {get; set;}
    public List<SelectOption> FiscalYearItems {get; private set;}

    public String optGroupDOM {get;private set;}

    /* Constructors */
    public AAPlanListController(ApexPages.StandardSetController stdController) {
        this();
    }

    public AAPlanListController() {
        SearchOperatingUnitId = '';
        readUrlParams();
        loadOperatingUnits();
        loadOperatingUnitDOMElements();
        loadFiscalYears();
        searchAandAPlanMaster();
    }

    /* Public Methods */
    // Method to search for AAPlan__c
    public void searchAandAPlanMaster() {
        try {
            String queryString = buildQueryString();
            controller = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
            controller.setPageSize(AppUtil.SEARCH_PAGE_SIZE);
        } catch(Exception e) {
            ApexPages.addMessages(e);
        }
    }

    /*
        PRIVATE METHODS
    */
    // method to build a query string using SOQLBuilder class
    private String buildQueryString() {
        SoqlBuilder builder = new SoqlBuilder()
                .selectx('Id')
                .selectx('Name')
                .selectx('Year__c')
                .selectx('OperatingUnit__c')
                .selectx('OperatingUnit__r.Name')
                .selectx('OperatingUnit__r.Region__c')
                .selectx('ApprovalStatus__c')
                .fromx('AAPlan__c')
                .orderByx( new OrderBy('Name') );
        ConditionGroup condition = new AndCondition();
        if(!AppUtil.isMultiSelectEmpty(SearchOperatingUnitId)) {
            condition.add(new SetCondition('OperatingUnit__c').inx(AppUtil.getStringsFromMultiSelect(SearchOperatingUnitId)));
        }
        if(!AppUtil.isMultiSelectEmpty(SearchFiscalYearId)) {
            condition.add(new SetCondition('FiscalYear__c').inx(AppUtil.getStringsFromMultiSelect(SearchFiscalYearId)));
        }
        builder.wherex(condition);
        
        return builder.toSoql();
    }

    // Method to retrieve URL Parameters and set variables
    private void readUrlParams() {
        String planId = ApexPages.currentPage().getParameters().get('PlanId');
        if(!String.isBlank(planId)) {
            AAPlan__c[] plans = [SELECT OperatingUnit__c FROM AAPlan__c WHERE Id = :planId LIMIT 1];
            if(plans.size() > 0) {
                SearchOperatingUnitId = plans[0].OperatingUnit__c;
            }
        }

        String year = ApexPages.currentPage().getParameters().get('Year');
        if(!String.isBlank(year)) {
            try {
                Integer iYear = Integer.valueOf(year);
                FiscalYear__c[] years = [SELECT Id FROM FiscalYear__c WHERE Year__c = :iYear LIMIT 1];
                if(years.size() > 0) {
                    SearchFiscalYearId = years[0].Id;
                }
            } catch(System.TypeException e) {} //ignore the parameter
        }
    }
    
    private void loadOperatingUnits() {
        OperatingUnitItems = AppUtil.getOperatingUnitOptionsWithId();
        NumOpUnits = OperatingUnitItems.size();
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
    
    // Method to set FiscalYearItems selectoptions
    private void loadFiscalYears() {
        FiscalYearItems = AppUtil.getFiscalYearOptionsWithId();
    }
}