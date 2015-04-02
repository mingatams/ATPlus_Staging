public class DashboardController {
    
    public List<SelectOption> RegionItems {get; private set;}
	public SelectOption[] OperatingUnitOptions {get; private set;}
	public SelectOption[] FiscalYearOptions {get; private set;}
    
	public DashboardController() {
		FiscalYearOptions = AppUtil.getFiscalYearOptionsWithId();
		OperatingUnitOptions = AppUtil.getOperatingUnitOptionsWithId();
		RegionItems = AppUtil.getRegionOptions();
	}
	
	@RemoteAction
	public static ChartData getChartData(String region, String operatingUnitIds, String fiscalYearIds) {
		Id[] planIds = getAAPlanIds(region, operatingUnitIds, fiscalYearIds);
		
		AggregateResult[] tecCount = 		[SELECT count(Id) cnt, TotalEstimateCost__c lbl				FROM AAPlanDetail__c WHERE TotalEstimateCost__c != null 			GROUP BY TotalEstimateCost__c];
		AggregateResult[] awardTypeCount = 	[SELECT count(Id) cnt, ActionOrAwardType__c lbl				FROM AAPlanDetail__c WHERE ActionOrAwardType__c != null 			GROUP BY ActionOrAwardType__c];
		//AggregateResult[] partnerCount = 	[SELECT count(Id) cnt, PartnerOrIncumbentName__c lbl		FROM AAPlanDetail__c WHERE PartnerOrIncumbentName__c != null 		GROUP BY PartnerOrIncumbentName__c];
		AggregateResult[] opUnitCount = 	[SELECT count(Id) cnt, AandAPlan__r.OperatingUnit__c lbl	FROM AAPlanDetail__c WHERE AandAPlan__r.OperatingUnit__c != null 	GROUP BY AandAPlan__r.OperatingUnit__c];
		AggregateResult[] priorityCount = 	[SELECT count(Id) cnt, AwardPriority__c lbl					FROM AAPlanDetail__c WHERE AwardPriority__c != null 				GROUP BY AwardPriority__c];
		AggregateResult[] statusCount = 	[SELECT count(Id) cnt, Status__c lbl						FROM AAPlanDetail__c WHERE Status__c != null 						GROUP BY Status__c];
		
		ChartData data = new ChartData();
		data.tecCount = gatherLabelValuesFrom(tecCount);
		data.awardTypeCount = gatherLabelValuesFrom(awardTypeCount);
		//data.partnerCount = gatherLabelValuesFrom(partnerCount);
		data.partnerCount = new LabelValue[0];
		data.opUnitCount = gatherLabelValuesFrom(opUnitCount);
		data.priorityCount = gatherLabelValuesFrom(priorityCount);
		data.statusCount = gatherLabelValuesFrom(statusCount);
		return data;
	}
	
	@RemoteAction
	public static LabelValue[] getPartnerCount(String region, String operatingUnitIds, String fiscalYearIds) {
		Id[] planIds = getAAPlanIds(region, operatingUnitIds, fiscalYearIds);
		MultiSet planCount = new MultiSet();
		for(AAPlanDetail__c plan : [SELECT PartnerOrIncumbentName__c FROM AAPlanDetail__c WHERE AandAPlan__c IN :planIds]) {
			planCount.inc(plan.PartnerOrIncumbentName__c);
		}
		return gatherLabelValuesFrom(planCount);
	}
	
	@RemoteAction
	public static StatData getStatData(String region, String operatingUnitIds, String fiscalYearIds) {
		Id[] planIds = getAAPlanIds(region, operatingUnitIds, fiscalYearIds);
		StatData stats = new StatData();
		stats.nbrActions = 			(Integer) [SELECT count(Id) cnt FROM AAPlanDetail__c WHERE AandAPlan__c IN :planIds][0].get('cnt');
		stats.nbrAwarded = 			(Integer) [SELECT count(Id) cnt FROM AAPlanDetail__c WHERE AandAPlan__c IN :planIds AND Status__c = 'Awarded'][0].get('cnt');
		stats.nbrRemaingAwarded = 	(Integer) [SELECT count(Id) cnt FROM AAPlanDetail__c WHERE AandAPlan__c IN :planIds AND Status__c != 'Awarded'][0].get('cnt');
		stats.nbrOver25NotAwarded = (Integer) [SELECT count(Id) cnt FROM AAPlanDetail__c WHERE AandAPlan__c IN :planIds AND Status__c != 'Awarded' AND TotalEstimateCost__c IN (
				'$25,000,001 - $75,000,000', 
				'$75,000,001 - $500,000,000', 
				'$500,000,001 - $2 billion', 
				'$2 billion+ to $5 billion', 
				'$5 billion+'
		)][0].get('cnt');
		return stats;
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
		return condition;
	}
	
	private static LabelValue[] gatherLabelValuesFrom(AggregateResult[] aggResults) {
		LabelValue[] values = new LabelValue[0];
		for(AggregateResult ar : aggResults) {
			values.add(new LabelValue(String.valueOf(ar.get('lbl')), ((Integer) ar.get('cnt'))));
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
	
	
	public class ChartData {
        public LabelValue[] tecCount;
        public LabelValue[] awardTypeCount;
        public LabelValue[] partnerCount;
        public LabelValue[] opUnitCount;
        public LabelValue[] priorityCount;
        public LabelValue[] statusCount;
    }
	
	public class StatData {
		public Integer nbrActions;
		public Integer nbrAwarded;
		public Integer nbrRemaingAwarded;
		public Integer nbrOver25NotAwarded;
	}
	
	class LabelValue {
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
}