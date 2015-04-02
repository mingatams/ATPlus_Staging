/**
* AAPlanDetailListController is used in AAPlanDetailList to
* list AAPlanDetail__c records.
*
* CHANGE HISTORY
* =============================================================================
* Date              Name                Description
* Sep 09 2014       Brian Mason         Created
* Oct 07 2014       Brian Mason         Added   Comments
* Oct 15 2014       Ryan Chadwick       Default to Fiscal Year of the plan instead of active year
* =============================================================================
*/
public with sharing class AAPlanDetailListController {
    
    /* Search Variables*/
    public String AandAPlanNameSearch {get; set;}
    public String FiscalYearSearch {get; set;}
    public String QuarterSearch {get; set;}
    public SelectOption[] FiscalYearOptions {get; private set;}
    public SelectOption[] QuarterOptions {get; private set;}
    public Integer queryLimit {
        get{
            return AppUtil.SOQL_LIMIT;
        }
    }

    /*Controller Variables*/
    public ApexPages.StandardSetController controller {get; private set;}
    public AAPlanDetail__c[] results {
        get {
            return controller.getRecords();
        }   
    }
    
    
    private AAPlan__c parent;
    
    public String parentId {
        get {
            if(parent == null)
                return '';
            return parent.Id;
        }
    }

    /*Header Variables*/
    public String Title {
        get {
            if(parent == null)
                return 'All';
            return parent.Name;
        }
    }
    
    public String OpUnitName {
        get {
            if(parent == null)
                return '';
            return parent.OperatingUnit__r.Name;
        }
    }
    
    public String OpUnitId {
        get {
            if(parent == null)
                return '';
            return parent.OperatingUnit__c;
        }
    }

    public String Year {
        get {
            if(parent == null)
                return '';
            return parent.Year__c;
        }
    }

    /*
        CONSTRUCTOR
    */
    public AAPlanDetailListController(ApexPages.StandardSetController controller) {
        this();
    }

    public AAPlanDetailListController() {

        //get Header Values from Parent
        Id parentId = ApexPages.currentPage().getParameters().get('ParentId');
        if(parentId != null) {
            AAPlan__c[] plans = [SELECT Id, 
                                         Name, 
                                         FiscalYear__r.Year__c, 
                                         FiscalYear__r.CurrentQuar__c, 
                                         Year__c, 
                                         OperatingUnit__c, 
                                         OperatingUnit__r.Name 
                                    FROM AAPlan__c 
                                    WHERE Id = :parentId];
            if(plans.size() > 0) {
                parent = plans[0];
            }
        }

        //init Funding Year
        initSelectOptions();

        performSearch();
    }

    /*
        PUBLIC METHODS
    */
    // search for A&A Plan, setting the controller variable
    public void searchAandAPlan() {
        try {
            performSearch();
        } catch(System.QueryException e) {
            ApexPages.addMessages(e);
        }
    }

    // method to delete record, return an updated controller with remaining records
    public void deleteRecord() {
        try {
            delete new AAPlanDetail__c(Id=ApexPages.currentPage().getParameters().get('id'));
            performSearch();
        } catch(Exception e) {
            ApexPages.addMessages(e);
        }
    }

    /*
        PRIVATE METHODS
    */
    // method to perfom the search and set the controller variable
    private void performSearch() {
        String queryString = buildQueryString();
        controller = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
        controller.setPageSize(AppUtil.SEARCH_PAGE_SIZE);
    }
    
    // builds the query string used to retrieve records used in the controller
    private String buildQueryString() {

        ConditionGroup condition = new AndCondition();
        //Plan
        if(parent != null) {
            condition.add(new FieldCondition('AandAPlan__c', parent.Id));
        }
        //Name
        if(String.isNotBlank(AandAPlanNameSearch)) {
            AandAPlanNameSearch = String.escapeSingleQuotes(AandAPlanNameSearch);
            condition.add(new FieldCondition('Name').likex('%' + AandAPlanNameSearch + '%'));
        }
        //Funding Year
        if(!String.isBlank(FiscalYearSearch)) {
            condition.add(new FieldCondition('Year__c', FiscalYearSearch));
        }
        
        if(!String.isBlank(QuarterSearch)) {
            condition.add(new FieldCondition('Quarter__c', QuarterSearch));
        }
        
        return new SoqlBuilder()
            .selectx('Id')
            .selectx('Name')
            .selectx('AwardTitle__c')
            .selectx('CORorAORName__c')
            .selectx('PartnerOrIncumbentName__c')
            .selectx('Description__c')
            .selectx('Award_Description__c')
            .selectX('Implementing_Partner__c')
            .selectx('UserRecordAccess.HasEditAccess')
            .fromx('AAPlanDetail__c')
            .wherex(condition)
            .toSoql();
    }

    // Method to initalize selector options on the page
    private void initSelectOptions() {
        
        //FiscalYear
        FiscalYearOptions = AppUtil.getFiscalYearOptionsWithNumber();
        
        //Quarter
        List<Schema.PicklistEntry> quarterValues = sObjectType.AAPlanDetail__c.fields.Quarter__c.getPickListValues();       
        QuarterOptions = new SelectOption[]{
                new SelectOption('', 'All')
        };
        for(Schema.PicklistEntry entry : quarterValues) {
            QuarterOptions.add(new SelectOption(entry.getLabel(), entry.getValue()));
        }
        
        String q = ApexPages.currentPage().getParameters().get('Quarter');
        String y = ApexPages.currentPage().getParameters().get('Year');
        if(!String.isBlank(q)) {
            QuarterSearch = q;
        }
        if(!String.isBlank(y)) {
            FiscalYearSearch = y;
        }
        
        //default to selected Plan's fiscal year
        if(String.isBlank(FiscalYearSearch) || String.isBlank(QuarterSearch)) {
            if(parent != null) {
                FiscalYearSearch = String.valueOf(parent.FiscalYear__r.Year__c);
                QuarterSearch = parent.FiscalYear__r.CurrentQuar__c;
            } else {
                FiscalYearSearch = '';
                QuarterSearch = '';
            }
        }
    }
}