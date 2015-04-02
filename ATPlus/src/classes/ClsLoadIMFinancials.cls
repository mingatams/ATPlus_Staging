public class ClsLoadIMFinancials implements Database.Batchable<sObject> {
    public final String Query;
    public integer batchCount;
    
    public ClsLoadIMFinancials(){
        batchCount = 0;
      
        Query = ' SELECT Id, Name , '         
         + ' Award_Id__c, '
         + ' Award_Key__c, '         
         + ' ouCode__c,ouName__c '                  
         + ' FROM Implementing_Mechanism__c '
         + ' WHERE Award_Id__c != Null '
         + ' Order by Name, ouCode__c, Award_Id__c';
        
    }
    
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Implementing_Mechanism__c> scope){
        set<String> awardKeys= new set<String>();
        List<Implementing_Mechanism__c> imUpdateList = new List<Implementing_Mechanism__c>();
        Map<String,Award_Financials_Ext__c> awardFinancialsMap = new Map<String,Award_Financials_Ext__c>();
        Map<String, Integer> fundciteMap = new Map<String,Integer>();
        try {
            for(sObject s : scope){
                Implementing_Mechanism__c im = new Implementing_Mechanism__c();
                im = (Implementing_Mechanism__c)s;
                awardKeys.add((String)im.Award_Key__c);           
            }
            
            //Get all the IMFinancials Matching with set of imNames
            
            
            
            List<Award_Financials_Ext__c> awardFinancialsList = new List<Award_Financials_Ext__c>([
                                                    select id, name, Award_Key__c, ouCode__c, ouName__c,
                                                            totAccr__c, TotAdv__c,
                                                            totDisb__c, totAward__c, totObl__c, DisbP1Mth__c, DisbP2Mth__c, 
                                                            DisbP2Qtr__c, DisbP1Qtr__c, DisbCMth__c, DisbCQtr__c
                                                        From Award_Financials_Ext__c 
                                                        Where Award_Key__c in :awardKeys
                                                        order by ouCode__c, Award_Key__c ]);
                                                        
            List<AggregateResult> fsanpList = new List<AggregateResult>([
                                                    select Award_Key__c, Organization_Id__c oCode, sum(OBLIGATION_AMT__c) totObl 
                                                    From Fintxn_SMRY_FSNAP__c 
                                                    where Award_Key__c in :awardKeys
                                                    group by Award_Key__c, Organization_Id__c
                                                    order by Award_Key__c asc, Organization_Id__c asc
                                                     ]);
            
            for(AggregateResult ar: fsanpList){
                fundciteMap.put((String)ar.get('Award_Key__c')+(String)ar.get('oCode'), Integer.valueOf((Decimal)ar.get('totObl')));
            }                                        
                                                                                                 
            for(Award_Financials_Ext__c imf : awardFinancialsList ){
                awardFinancialsMap.put((String)imf.Award_Key__c, imf );
                
            }                                           
            
            for(sObject s : scope){
                Implementing_Mechanism__c imUpdate = new Implementing_Mechanism__c();
                imUpdate = (Implementing_Mechanism__c)s;
                Award_Financials_Ext__c newAwardFinancials = new Award_Financials_Ext__c();
                
                if (awardFinancialsMap.containsKey((String)imUpdate.Award_Key__c)){
                    newAwardFinancials = awardFinancialsMap.get((String)imUpdate.Award_Key__c);
                    imupdate.Award_Amount__c = newAwardFinancials.totObl__c; 
                    imupdate.totAward__c = newAwardFinancials.totAward__c;
                    imupdate.totObl__c = newAwardFinancials.totObl__c; 
                    imUpdate.TotAdv__c = newAwardFinancials.TotAdv__c;
                    imUpdate.totAccr__c = newAwardFinancials.totAccr__c;
                    //imUpdate.As_of_Date__c = newAwardFinancials.As_Of_Date__c;
                    imUpdate.totDisb__c = newAwardFinancials.totDisb__c;
                    imUpdate.DisbP1Mth__c = newAwardFinancials.DisbP1Mth__c;
                    imUpdate.DisbP2Mth__c = newAwardFinancials.DisbP2Mth__c;
                    imUpdate.DisbP2Qtr__c = newAwardFinancials.DisbP2Qtr__c;
                    imUpdate.DisbP1Qtr__c = newAwardFinancials.DisbP1Qtr__c;
                    imUPdate.DisbCMth__c = newAwardFinancials.DisbCMth__c;
                    imUPdate.DisbCQtr__c = newAwardFinancials.DisbCQtr__c;
                    if (fundciteMap.containsKey((String)imUpdate.Award_Key__c+(String)imUpdate.ouId__c)){
                        imUpdate.FundCite_Obligation__c = fundciteMap.get((String)imUpdate.Award_Key__c+(String)imUpdate.ouId__c);
                    } 
                    ApplicationConstants.bypassIMSharingRulesTriggerLogic = true;
                    ApplicationConstants.bypassIMCreateVendorTriggerLogic = true;  
                    imUpdateList.add(imUpdate);
                }
                            
            }                                           
            
            update imUpdateList;
        } catch (Exception e){
            
        }   
    }
    
    public void finish(Database.BatchableContext BC){
    }
    
}