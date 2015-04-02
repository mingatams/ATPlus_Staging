global class BatchQuarterlyRecordCreation implements Database.Stateful, Database.Batchable<sObject>{
	public class applicationException extends Exception {}
    
    global String nextQuarter;
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        //Get the current Year
        currentInfo ci = getCurrentYearAndQuarter();
        
        if(ci.currentYear == null){
            return null;
        }
        return Database.getQueryLocator( getAAPlanDetailForCurrentYearNew(ci.currentYear, ci.currentQuarter ) );
    }
    
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
        List<AAPlanDetail__c> aaPlanDetailList = new List<AAPlanDetail__c>();
        Map<ID, ID> origIDs = new Map<ID, ID>(); //Map to contain mapping of original ID (Key) to new ID (value)
        for(sObject s: scope){
            AAPlanDetail__c aaPlanDetail = (AAPlanDetail__c) s;
            AAPlanDetail__c newAAPlanDetail = new AAPlanDetail__c();
            
            newAAPlanDetail = aaPlanDetail.clone(false, true); // Don't copy ID , copy related Parent Information
            newAAPlanDetail.Quarter__c = nextQuarter; //Update it to next Quarter
            newAAPlanDetail.Original_Record_ID__c = aaPlanDetail.Id; //Update Original_Record_ID__c to original records SF ID
            aaPlanDetailList.add(newAAPlanDetail);
            origIDs.put(aaPlanDetail.Id, null);
        }
        insert aaPlanDetailList;
        for( AAPlanDetail__c a : aaPlanDetailList ){
            if( origIDs.containsKey( (ID)a.Original_Record_ID__c ) ){
                origIDs.put( (ID)a.Original_Record_ID__c, a.id );
            }
        }
        List<Fund_Type__c> fts = [SELECT A_A_Action__c, 
                                     		Funding_Type__c, 
                                     		Funding_Year__c 
                                     	FROM Fund_Type__c 
                                     	WHERE A_A_Action__c 
                                     	IN :origIDs.keySet()];
        if( !fts.isEmpty()){
            List<Fund_Type__c> ftsToInsert = new List<Fund_type__c>();
            for( Fund_Type__c ft : fts ){
                Fund_Type__c newFundType = new Fund_Type__c();
                
                newFundType = ft.clone(false, false); // Don't copy ID , Don't copy related Parent Information
                newFundType.A_A_Action__c = origIDs.get( (ID)ft.A_A_Action__c );
                ftsToInsert.add( newFundType );
            }
            if( !ftsToInsert.isEmpty() ){
                insert ftsToInsert;
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
        //NA
    }
    
    
    
    /*PRIVATE METHODS*/
    private currentInfo getCurrentYearAndQuarter(){
        
        //Find the current Year
        List<FiscalYear__c> fiscalYearList = [SELECT Year__c, IsActive__c , CurrentQuar__c
                                              FROM FiscalYear__c
                                              WHERE IsActive__c = true
                                              ORDER BY Year__c DESC];
        
        //List Empty Check
        if(fiscalYearList.size() == 0){
            return null;
        }
        
        currentInfo ci = new currentInfo();
        
        ci.currentYear = Integer.valueOf(fiscalYearList[0].Year__c);
        ci.currentQuarter = String.valueOf(fiscalYearList[0].CurrentQuar__c);
        
        nextQuarter = findNextQuarter(ci.currentQuarter);
        
        return ci;
    }
    
    private String getAAPlanDetailForCurrentYearNEW(Integer currentYear, String currentQuarter){
        
        List<AA_Quarterly_Update_Fields__c> lstfields = AA_Quarterly_Update_Fields__c.getall().values();
        if( lstfields.isEmpty() ){
            throw new applicationException('There are no fields to query defined in the \'A&A Quarterly Update Fields\' Custom Setting. ' +
                                           	'Please define all fields for the record(s) to be cloned.');
            return null;
        }
        String fields = '';
        for( AA_Quarterly_Update_Fields__c f : lstfields ){
            fields += f.Field_API_Name__c + ',';
        }
        fields = fields.removeEnd( ',' );
		
        String currentYearInString = String.valueOf(currentYear);
        
        return 'SELECT ' + fields + 
                ' FROM AAPlanDetail__c' + 
                ' WHERE AandAPlan__r.Year__c = \'' + currentYearInString + '\'' +
                ' AND Quarter__c LIKE \'' + currentQuarter + '\'';
    }
    
    private String findNextQuarter(String currentQuarter){
        
        if(currentQuarter == null) {
            return 'Q1';
        } else if(currentQuarter == 'Q1') {
            return 'Q2';
        } else if(currentQuarter == 'Q2') {
            return 'Q3';
        } else if(currentQuarter == 'Q3') {
            return 'Q4';
        } else if(currentQuarter == 'Q4') {
            return 'Q1';
        } else {
            return 'Q1';
        }
    }
    
    public class currentInfo{
        Integer currentYear;
        String currentQuarter;
    }

}