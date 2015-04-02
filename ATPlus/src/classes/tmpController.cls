/**
* tmpController is used in tmp (Current Dashboard) page to provide links 
* and data to the tmp page.
*
* CHANGE HISTORY
* =============================================================================
* Date              Name                Description
* Aug 12 2014       Brian Mason         Created
* Oct 09 2014       Brian Mason         Added   Comments
* =============================================================================
*/
global with sharing class tmpController {
    /* VARIABLES */
    public List<SelectOption> RegionItems {get; private set;}
    public SelectOption[] OperatingUnitOptions {get; private set;}
    public Integer NumOpUnits {get; private set;}
    public String optGroupDOM {get;private set;}
    public SelectOption[] FiscalYearOptions {get; private set;}
    
    public String SearchBureau {get; set;}
    public List<SelectOption> BureauItems {get; private set;}

    public String SearchBureauChildId {get; set;}
    public List<SelectOption> BureauChildItems {get; private set;}

    public transient String JSONBureaus { get; private set; }

    private List<Report> reportLinks {get;set;}
    
    public Id Actions_by_Status {get;set;}
    public Id Actions_by_TEC_Threshold {get;set;}
    public Id Actions_By_Mechanism_Type {get;set;}
    public Id Actions_by_Partner {get;set;}
    public Id Actions_by_Planning_Unit {get;set;}
    public Id Actions_by_Priority {get;set;}
    public Id Actions_Awarded_Not_Awarded {get;set;}
    
    public FiscalYear__c Year {get; private set;}
    
    /* CONTROLLER */
    public tmpController() {
        FiscalYearOptions = AppUtil.getFiscalYearOptionsWithId();
        OperatingUnitOptions = AppUtil.getOperatingUnitOptionsWithId();
        NumOpUnits = OperatingUnitOptions.size();
        loadOperatingUnitDOMElements();
        system.debug([SELECT Name FROM OperatingUnit__c WHERE Name != null ORDER BY OperatingUnitName__c].size() );
        RegionItems = AppUtil.getRegionOptions();
        BureauItems = AppUtil.getBureaus();
        JSONBureaus = system.json.serialize( setJsonBureaus() );

        reportLinks = [SELECT Id, Name FROM Report WHERE Name IN ('Actions by Status', 
                                                            'Actions by TEC Threshold', 
                                                            'Actions By Mechanism Type',
                                                            'Actions by Partner',
                                                            'Actions by Planning Unit',
                                                            'Actions by Priority',
                                                            'Actions Awarded Not Awarded')];
        
        for(Report rt : reportLinks){
            if(rt.Name == 'Actions by Status'){
                Actions_by_Status = rt.Id;
            }
            if(rt.Name == 'Actions by TEC Threshold'){
                Actions_by_TEC_Threshold = rt.Id;
            }
            if(rt.Name == 'Actions By Mechanism Type'){
                Actions_By_Mechanism_Type = rt.Id;
            }
            if(rt.Name == 'Actions by Partner'){
                Actions_by_Partner = rt.Id;
            }
            if(rt.Name == 'Actions by Planning Unit'){
                Actions_by_Planning_Unit = rt.Id;
            }
            if(rt.Name == 'Actions by Priority'){
                Actions_by_Priority = rt.Id;
            }
            if(rt.Name == 'Actions Awarded Not Awarded'){
                Actions_Awarded_Not_Awarded = rt.Id;
            }
        }
        
        Year = AppUtil.getActiveYear();
    }

    // Method to search for M/B/IOs
    public void searchBureaus() {
        try{
            if( !AppUtil.isMultiSelectEmpty( SearchBureau ) ) {
                BureauChildItems = AppUtil.getBureauChildren( 
                                        AppUtil.getStringsFromMultiSelect( SearchBureau ) );
            }else if( AppUtil.isMultiSelectEmpty( SearchBureau ) ){
                BureauChildItems.clear();
            }
        }catch( Exception e ){
            ApexPages.addMessages( e );
        }
    }

    /* REMOTE ACTIONS */
    @RemoteAction
    global static ChartData getChartData(String region, String operatingUnitIds, String fiscalYearIds) {
        Id[] planIds = getAAPlanIds(region, operatingUnitIds, fiscalYearIds);
        
        AggregateResult[] tecCount =        [SELECT count(Id) val, TotalEstimateCost__c lbl                 FROM AAPlanDetail__c WHERE AandAPlan__c IN :planIds AND TotalEstimateCost__c != null             GROUP BY TotalEstimateCost__c                             LIMIT 50];
        AggregateResult[] awardTypeCount =  [SELECT count(Id) val, ActionOrAwardType__c lbl                 FROM AAPlanDetail__c WHERE AandAPlan__c IN :planIds AND ActionOrAwardType__c != null             GROUP BY ActionOrAwardType__c                                 LIMIT 50];
        //AggregateResult[] partnerCount =  [SELECT count(Id) val, PartnerOrIncumbentName__c lbl            FROM AAPlanDetail__c WHERE AandAPlan__c IN :planIds AND PartnerOrIncumbentName__c != null        GROUP BY PartnerOrIncumbentName__c                             LIMIT 50];
        AggregateResult[] opUnitCount =     [SELECT count(Id) val, AandAPlan__r.OperatingUnit__r.Name lbl   FROM AAPlanDetail__c WHERE AandAPlan__c IN :planIds AND AandAPlan__r.OperatingUnit__c != null    GROUP BY AandAPlan__r.OperatingUnit__r.Name                             LIMIT 50];
        AggregateResult[] priorityCount =   [SELECT count(Id) val, AwardPriority__c lbl                     FROM AAPlanDetail__c WHERE AandAPlan__c IN :planIds AND AwardPriority__c != null                 GROUP BY AwardPriority__c                                 LIMIT 50];
        AggregateResult[] statusCount =     [SELECT count(Id) val, Status__c lbl                            FROM AAPlanDetail__c WHERE AandAPlan__c IN :planIds AND Status__c != null                        GROUP BY Status__c                                 LIMIT 50];
        AggregateResult[] estimateCount =     [SELECT count(Id) val, TotalEstimateCost__c lbl               FROM AAPlanDetail__c WHERE AandAPlan__c IN :planIds AND TotalEstimateCost__c != null             GROUP BY TotalEstimateCost__c                      LIMIT 50];
        //AggregateResult[] statusAmount =    [SELECT sum(ObligatedAmount__c) val, Status__c lbl              FROM AAPlanDetail__c WHERE AandAPlan__c IN :planIds AND Status__c != null                        GROUP BY Status__c ORDER BY sum(ObligatedAmount__c) DESC NULLS LAST         LIMIT 10];
        
        ChartData data = new ChartData();
        data.tecCount = gatherLabelValuesFrom(tecCount);
        data.awardTypeCount = gatherLabelValuesFrom(awardTypeCount);
        //data.partnerCount = gatherLabelValuesFrom(partnerCount);
        data.partnerCount = new LabelValue[0];
        data.opUnitCount = gatherLabelValuesFrom(opUnitCount);
        data.priorityCount = gatherLabelValuesFrom(priorityCount);
        data.statusCount = gatherLabelValuesFrom(statusCount);
        data.estimateCount = gatherLabelValuesFrom(estimateCount);
        //data.statusAmount = gatherLabelValuesFrom(statusAmount);
        return data;
    }
    
    @RemoteAction
    global static LabelValue[] getPartnerCount(String region, String operatingUnitIds, String fiscalYearIds) {
        Id[] planIds = getAAPlanIds(region, operatingUnitIds, fiscalYearIds);
        MultiSet planCount = new MultiSet();
        for(AAPlanDetail__c plan : [SELECT PartnerOrIncumbentName__c FROM AAPlanDetail__c WHERE AandAPlan__c IN :planIds LIMIT 50]) {
            planCount.inc(plan.PartnerOrIncumbentName__c);
        }
        return gatherLabelValuesFrom(planCount);
    }
    
    @RemoteAction
    global static StatData getStatData(String region, String operatingUnitIds, String fiscalYearIds) {
        Id[] planIds = getAAPlanIds(region, operatingUnitIds, fiscalYearIds);
        FiscalYear__c curentYear = AppUtil.getActiveYear();
        StatData stats = new StatData();
        stats.nbrActions =                  getVal([SELECT count(Id) val FROM AAPlanDetail__c WHERE AandAPlan__c IN :planIds]);
        stats.nbrAwarded =                  getVal([SELECT count(Id) val FROM AAPlanDetail__c WHERE AandAPlan__c IN :planIds AND Status__c = 'Awarded' AND AandAPlan__r.FiscalYear__c = :curentYear.Id]);
        stats.nbrNotAwarded =               getVal([SELECT count(Id) val FROM AAPlanDetail__c WHERE AandAPlan__c IN :planIds AND Status__c != 'Awarded' AND AandAPlan__r.FiscalYear__c = :curentYear.Id]);
        stats.nbrOver25NotAwarded =         getVal([SELECT count(Id) val FROM AAPlanDetail__c WHERE AandAPlan__c IN :planIds AND Status__c != 'Awarded' AND TotalEstimateCost__c IN (
                '$25M - $49.99M',
                '$50M - $74.99M', 
                '$75M - $149.99M', 
                '$150M - $299.99M', 
                '$300M - $499.99M',
                '$500M - $999.99M',
                '$1B+'
        )]);
        stats.nbrOver75NotAwarded =         getVal([SELECT count(Id) val FROM AAPlanDetail__c WHERE AandAPlan__c IN :planIds AND Status__c != 'Awarded' AND TotalEstimateCost__c IN (
                '$75M - $149.99M', 
                '$150M - $299.99M', 
                '$300M - $499.99M',
                '$500M - $999.99M',
                '$1B+'
        )]);
        // Sept 3 2014 - Commented out by Brian Mason - Is_this_Action_using_Expiring_Funds__c will be used to track expiring funds instead of years.
        //stats.nbrNotAwardedExpiringFunds =  getVal([SELECT count(Id) val FROM AAPlanDetail__c WHERE AandAPlan__c IN :planIds AND Status__c != 'Awarded' AND FundingYear__c NOT IN ('2012/2016','2013/2017','Other')]);
        stats.nbrNotAwardedExpiringFunds =  getVal([SELECT count(Id) val FROM AAPlanDetail__c WHERE AandAPlan__c IN :planIds AND Status__c != 'Awarded' AND Is_this_Action_using_Expiring_Funds__c LIKE 'Yes']);
        stats.pctNotAwardedExpiringFunds =  stats.nbrActions == 0 ? 0 : stats.nbrNotAwardedExpiringFunds * (Decimal)(100) / stats.nbrActions;
        stats.pctRemainingObligated =       stats.nbrActions == 0 ? 0 : stats.nbrNotAwarded * (Decimal)(100) / stats.nbrActions;
        return stats;
    }
    
    @RemoteAction
    global static String getActionsByOU(String region, String operatingUnitIds, String fiscalYearIds) {
        return region+' '+operatingUnitIds+' '+fiscalYearIds;
    }
    
    @RemoteAction
    global static Id[] getPlanIds(String region, String operatingUnitIds, String fiscalYearIds) {
        if(     AppUtil.isMultiSelectEmpty(region) &&
                AppUtil.isMultiSelectEmpty(operatingUnitIds) &&
                AppUtil.isMultiSelectEmpty(fiscalYearIds))
            return new Id[0];
        return getAAPlanIds(region, operatingUnitIds, fiscalYearIds);
    }
    
    /* PRIVATE METHODS */
    private static Integer getVal(AggregateResult[] aggResults) {
        if(aggResults.size() > 0)
            return (Integer) aggResults[0].get('val');
        return 0;
    }
    
    private static Id[] getAAPlanIds(String region, String operatingUnitIds, String fiscalYearIds) {
        Id[] planIds = new Id[0];
        String sql = buildSql(region, operatingUnitIds, fiscalYearIds);
        for(AAPlan__c plan : Database.query(sql)) {
            planIds.add(plan.Id);
        }
        return planIds;
    }
    
    private static String buildSql(String region, String operatingUnitIds, String fiscalYearIds) {
        Condition condition = bulidCondition(region, operatingUnitIds, fiscalYearIds);
        return new SoqlBuilder()
                .selectx('Id')
                .fromx('AAPlan__c')
                .wherex(condition)
                .toSoql();
    }
    
    private static ConditionGroup bulidCondition(String region, String operatingUnitIds, String fiscalYearIds) {
        ConditionGroup condition = new AndCondition();
        if(!AppUtil.isMultiSelectEmpty(region)) {
            AndCondition a = new AndCondition();
            a.add(new FieldCondition('OperatingUnit__c').notEquals(null));
            a.add(new SetCondition('OperatingUnit__r.Region__c').inx(AppUtil.getStringsFromMultiSelect(region)));
            condition.add(a);
        }
        if(!AppUtil.isMultiSelectEmpty(fiscalYearIds)) {
            condition.add(new SetCondition('FiscalYear__c').inx(AppUtil.getStringsFromMultiSelect(fiscalYearIds)));
        }
        if(!AppUtil.isMultiSelectEmpty(operatingUnitIds)) {
            condition.add(new SetCondition('OperatingUnit__c').inx(AppUtil.getStringsFromMultiSelect(operatingUnitIds)));
        }
        if(AppUtil.isMultiSelectEmpty(fiscalYearIds)) {
            condition.add(new FieldCondition('FiscalYear__c').equals(AppUtil.getActiveYear().id));
        }
        return condition;
    }
    
    private static LabelValue[] gatherLabelValuesFrom(AggregateResult[] aggResults) {
        LabelValue[] values = new LabelValue[0];
        for(AggregateResult ar : aggResults) {
            values.add(new LabelValue(String.valueOf(ar.get('lbl')), ((Decimal) ar.get('val'))));
        }
        return values;
    }
    
    private static LabelValue[] gatherLabelValuesFrom(MultiSet multiSet) {
        LabelValue[] values = new LabelValue[0];
        for(String str : multiSet.keySet()) {
            values.add(new LabelValue(str, multiSet.get(str)));
        }
        return values;
    }

    private Map<String, List<ID>> setJsonBureaus() {
        List<OperatingUnit__c> bureaus = [SELECT ID,
                                                 Bureau__c,
                                                 Name
                                            FROM OperatingUnit__c
                                            WHERE Bureau__c != NULL
                                            Order By Bureau__c ASC, Name ASC];
        Map<String, List<ID>> ids = new Map<String,List<ID>>();
        if( bureaus != null && !bureaus.isEmpty() ) {
            for( OperatingUnit__c ou : bureaus ) {
                if( ids.containsKey( ou.bureau__c.toUpperCase() ) ) {
                    ids.get( ou.bureau__c.toUpperCase() ).add( ou.id );
                }else if( !ids.containsKey( ou.bureau__c.toUpperCase() ) ) {
                    ids.put( ou.bureau__c.toUpperCase(), new List<ID>{ ou.id } );
                }
            }
        }
        return ids;
    }
    
    /* INTERNAL CLASSES */
    global class ChartData {
        public LabelValue[] tecCount;
        public LabelValue[] awardTypeCount;
        public LabelValue[] partnerCount;
        public LabelValue[] opUnitCount;
        public LabelValue[] priorityCount;
        public LabelValue[] statusCount;
        public LabelValue[] estimateCount;
    }
    
    global class StatData {
        public Integer nbrActions;
        public Integer nbrAwarded;
        public Integer nbrNotAwarded;
        public Integer nbrOver25NotAwarded;
        public Integer nbrNotAwardedExpiringFunds;
        public Decimal pctNotAwardedExpiringFunds;
        public Decimal pctRemainingObligated;
        public Integer nbrOver75NotAwarded;
    }
    
    global class LabelValue {
        public String Label;
        public Decimal Value;
        public LabelValue(String l, Decimal v) {
            Label = l;
            Value = v;
        }
    }
    
    /*
        A collection of frequencies of Strings
        The string cannot be null
    */
    class MultiSet {
        private Map<String, Integer> lookup = new Map<String, Integer>();
        
        public void put(String s, Integer i) {
            if(s == null)
                return;
            lookup.put(s, i);
        }
        
        public Integer get(String s) {
            return lookup.get(s);
        }
        
        public void inc(String s) {
            if(s == null)
                return;
            Integer i = lookup.get(s);
            if(i != null) {
                lookup.put(s, i+1);
            } else {
                lookup.put(s, 1);
            }
        }
        
        public Set<String> keySet() {
            return lookup.keySet();
        }
    }
    
    private void loadOperatingUnitDOMElements() {
        optGroupDOM = '';
        
        List<OperatingUnit__c> opunits = [SELECT Id, Name, Bureau__c FROM OperatingUnit__c Order By Bureau__c ASC, Name ASC];
        
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