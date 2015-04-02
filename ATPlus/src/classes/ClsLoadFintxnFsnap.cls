public class ClsLoadFintxnFsnap implements Database.Batchable<sObject>, Database.Stateful{

    public final String Query;
  
    
    public integer batchCount;
    
    
    public ClsLoadFintxnFsnap(){
        batchCount = 0;
      
        Query = ' SELECT Id, Name , '
         + ' OBFS_FUND_CRCY_OUTS_ADV_AMT__c,'
         + ' AWARD_KEY__c, '
         + ' OBFS_FUND_CRCY_DISB_AMT__c, '
         + ' Fiscal_Year__c,Fiscal_Quarter__c,'
         + ' OBLIGATION_AMT__c, OBL_LASTQTR_ACCR_FP__c, OBFS_OP_UNIT__c '         
         + ' FROM Fintxn_SMRY_FSNAP_Ext__c '         
         + 'Order by AWARD_KEY__c, Fiscal_Year__c,Fiscal_Quarter__c';
         
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Fintxn_SMRY_FSNAP_Ext__c> scope){
            
            Map<String,Award__c> awardsMap = new Map<String, Award__c>([select Award_Key__c, Implementing_Mechanism__c From Award__c]);
          /*  AggregateResult[] fSnapExts = [SELECT Award_Key__c, Fiscal_Year__c ,        
                                    SUM(OBFS_FUND_CRCY_OUTS_ADV_AMT__c) advAmount, 
                                    SUM(OBFS_FUND_CRCY_DISB_AMT__c) disbAmount, 
                                    SUM(OBLIGATION_AMT__c) oblAmount, 
                                    SUM(OBL_LASTQTR_ACCR_FP__c) accAmount         
                                FROM Fintxn_SMRY_FSNAP_Ext__c 
                                Where Fiscal_Month__c > '11'
                                GROUP BY Award_Key__c, Fiscal_Year__c
                                Order by AWARD_KEY__c, Fiscal_Year__c]  ; */
           Financial_Opunit_Xref__c[] xRefs = [SELECT Id, Name, OBFS_OP_UNIT__c, Organization_Id__c FROM Financial_Opunit_Xref__c 
                                                Order by OBFS_OP_UNIT__c];   
           map<String,String>   xRefsMap = new  map<String,String>();
           for(Financial_Opunit_Xref__c xref: xRefs){
                xRefsMap.put(xref.OBFS_OP_UNIT__c,xref.Organization_Id__c);             
           }                                                           
       
            Fintxn_SMRY_FSNAP__c[] fSnaps = [SELECT Id, Name,        
                                OBFS_FUND_CRCY_OUTS_ADV_AMT__c, Award_Key__c,
                                OBFS_FUND_CRCY_DISB_AMT__c, 
                                Fiscal_Quarter__c,Fiscal_Year__c ,OBLIGATION_AMT__c, OBL_LASTQTR_ACCR_FP__c, OBFS_OP_UNIT__c          
                                FROM Fintxn_SMRY_FSNAP__c Order by AWARD_KEY__c, Fiscal_Year__c, Fiscal_Quarter__c]  ;
          
        Set<String> fSnapKeys = new Set<String> () ;
        map<String,Fintxn_SMRY_FSNAP__c>   fSnapsMap = new  map<String,Fintxn_SMRY_FSNAP__c>  () ;
            for ( Fintxn_SMRY_FSNAP__c f : fSnaps   ) {              
                if ( !fSnapKeys.contains((String)f.Award_Key__c+(String)f.Fiscal_Year__c+(String)f.Fiscal_Quarter__c+(String)f.OBFS_OP_UNIT__c)) {
                  fSnapsMap.put((String)f.Award_Key__c+(String)f.Fiscal_Year__c+(String)f.Fiscal_Quarter__c+(String)f.OBFS_OP_UNIT__c,f); 
                  fSnapKeys.add((String)f.Award_Key__c+(String)f.Fiscal_Year__c+(String)f.Fiscal_Quarter__c+(String)f.OBFS_OP_UNIT__c);
               }
            }           
      
        
        list<Fintxn_SMRY_FSNAP__c> fSnapsUpdateList = new list<Fintxn_SMRY_FSNAP__c>();
        list<Fintxn_SMRY_FSNAP__c> fSnapsInsertList = new list<Fintxn_SMRY_FSNAP__c>();
        set<string> keys = new set<string> () ;
        
        for(sObject s : scope){
            Fintxn_SMRY_FSNAP_Ext__c fSnapExt = new Fintxn_SMRY_FSNAP_Ext__c();
            fSnapExt = (Fintxn_SMRY_FSNAP_Ext__c)s;
            Fintxn_SMRY_FSNAP__c fSnapUpdRec = new Fintxn_SMRY_FSNAP__c();
            if (fSnapKeys.contains((String)fSnapExt.Award_Key__c+(String)fSnapExt.Fiscal_Year__c+(String)fSnapExt.Fiscal_Quarter__c+(String)fSnapExt.OBFS_OP_UNIT__c)){
                fSnapUpdRec = fSnapsMap.get((String)fSnapExt.Award_Key__c+(String)fSnapExt.Fiscal_Year__c+(String)fSnapExt.Fiscal_Quarter__c+(String)fSnapExt.OBFS_OP_UNIT__c); 
                fSnapUpdRec.Award_Key__c = fSnapExt.AWARD_KEY__c;               
               // fSnapUpdRec.Fiscal_Month__c = fSnapExt.Fiscal_Month__c;
               // fSnapUpdRec.Fiscal_Quarter__c = getQuarterOfAMonth(Integer.valueOf((String)fSnapExt.Fiscal_Month__c));
                fSnapUpdRec.Fiscal_Quarter__c = fSnapExt.Fiscal_Quarter__c;
                fSnapUpdRec.Fiscal_Year__c = fSnapExt.Fiscal_Year__c;               
               // fSnapUpdRec.OBFS_FISC_PERIOD__c = fSnapExt.OBFS_FISC_PERIOD__c;             
                fSnapUpdRec.OBFS_FUND_CRCY_DISB_AMT__c = fSnapExt.OBFS_FUND_CRCY_DISB_AMT__c;
                fSnapUpdRec.OBFS_FUND_CRCY_OUTS_ADV_AMT__c = fSnapExt.OBFS_FUND_CRCY_OUTS_ADV_AMT__c;               
                fSnapUpdRec.OBLIGATION_AMT__c = fSnapExt.OBLIGATION_AMT__c;
                fSnapUpdRec.OBL_LASTQTR_ACCR_FP__c = fSnapExt.OBL_LASTQTR_ACCR_FP__c; 
                fSnapUpdRec.OBFS_OP_UNIT__c = fSnapExt.OBFS_OP_UNIT__c;
                if (xrefsMap.containsKey(fSnapExt.OBFS_OP_UNIT__c)){
                    fSnapUpdRec.organization_Id__c = xrefsMap.get(fSnapExt.OBFS_OP_UNIT__c);
                }  
                if (awardsMap.containsKey(fSnapExt.AWARD_KEY__c)){
                    Award__c awd = awardsMap.get(fSnapExt.AWARD_KEY__c); 
                    fSnapUpdRec.Implementing_Mechanism_Id__c = awd.Implementing_Mechanism__c;
                } 
         
                fSnapsUpdateList.add(fSnapUpdRec);
            } else {
                Fintxn_SMRY_FSNAP__c fSnapInsertRec = new Fintxn_SMRY_FSNAP__c();
                fSnapInsertRec.Award_Key__c = fSnapExt.AWARD_KEY__c;                
               // fSnapInsertRec.Fiscal_Month__c = fSnapExt.Fiscal_Month__c;
               // fSnapInsertRec.Fiscal_Quarter__c = getQuarterOfAMonth(Integer.valueOf((String)fSnapExt.Fiscal_Month__c));
                fSnapInsertRec.Fiscal_Quarter__c =  fSnapExt.Fiscal_Quarter__c;
                fSnapInsertRec.Fiscal_Year__c = fSnapExt.Fiscal_Year__c;                
               // fSnapInsertRec.OBFS_FISC_PERIOD__c = fSnapExt.OBFS_FISC_PERIOD__c;              
                fSnapInsertRec.OBFS_FUND_CRCY_DISB_AMT__c = fSnapExt.OBFS_FUND_CRCY_DISB_AMT__c;
                fSnapInsertRec.OBFS_FUND_CRCY_OUTS_ADV_AMT__c = fSnapExt.OBFS_FUND_CRCY_OUTS_ADV_AMT__c;                
                fSnapInsertRec.OBLIGATION_AMT__c = fSnapExt.OBLIGATION_AMT__c;
                fSnapInsertRec.OBL_LASTQTR_ACCR_FP__c = fSnapExt.OBL_LASTQTR_ACCR_FP__c; 
                fSnapInsertRec.OBFS_OP_UNIT__c = fSnapExt.OBFS_OP_UNIT__c;
                if (xrefsMap.containsKey(fSnapExt.OBFS_OP_UNIT__c)){
                    fSnapInsertRec.organization_Id__c = xrefsMap.get(fSnapExt.OBFS_OP_UNIT__c);
                }      
                if (awardsMap.containsKey(fSnapExt.AWARD_KEY__c)){
                    Award__c awd = awardsMap.get(fSnapExt.AWARD_KEY__c); 
                    fSnapInsertRec.Implementing_Mechanism_Id__c = awd.Implementing_Mechanism__c;
                } 
                             
                fSnapsInsertList.add(fSnapInsertRec);               
            }           
        }
        
       // System.debug('Size of the Aggregation List::::' +fSnapExts.size());
       /* if (batchCount == 0) {
        for(AggregateResult ar : fSnapExts){            
            Fintxn_SMRY_FSNAP__c fSnapUpdRec = new Fintxn_SMRY_FSNAP__c();
            if (fSnapKeys.contains((String)ar.get('Award_Key__c')+(String)ar.get('Fiscal_Year__c')+'/12')){
                fSnapUpdRec = fSnapsMap.get((String)ar.get('Award_Key__c')+(String)ar.get('Fiscal_Year__c')+'/12'); 
                fSnapUpdRec.Award_Key__c = (String)ar.get('Award_Key__c');               
                fSnapUpdRec.Fiscal_Month__c = '12';
                fSnapUpdRec.Fiscal_Quarter__c = getQuarterOfAMonth(12);
                fSnapUpdRec.Fiscal_Year__c = (String)ar.get('Fiscal_Year__c');               
                fSnapUpdRec.OBFS_FISC_PERIOD__c = (String)ar.get('Fiscal_Year__c')+'/12';       
                if (ar.get('disbAmount') != null && fSnapUpdRec.OBFS_FUND_CRCY_DISB_AMT__c != null ){                   
                    fSnapUpdRec.OBFS_FUND_CRCY_DISB_AMT__c = (Decimal)fSnapUpdRec.OBFS_FUND_CRCY_DISB_AMT__c + (Decimal)ar.get('disbAmount');                                       
                } else if (ar.get('disbAmount') == null && fSnapUpdRec.OBFS_FUND_CRCY_DISB_AMT__c == null){
                    fSnapUpdRec.OBFS_FUND_CRCY_DISB_AMT__c = 0.00;
                } else {
                    if (ar.get('disbAmount') == null){
                        fSnapUpdRec.OBFS_FUND_CRCY_DISB_AMT__c = (Decimal)fSnapUpdRec.OBFS_FUND_CRCY_DISB_AMT__c;
                    } 
                    if (fSnapUpdRec.OBFS_FUND_CRCY_DISB_AMT__c == null){
                        fSnapUpdRec.OBFS_FUND_CRCY_DISB_AMT__c = (Decimal)ar.get('disbAmount');
                    }   
                }   
                
                if (ar.get('advAmount') != null && fSnapUpdRec.OBFS_FUND_CRCY_OUTS_ADV_AMT__c != null ){                    
                        fSnapUpdRec.OBFS_FUND_CRCY_OUTS_ADV_AMT__c = (Decimal)fSnapUpdRec.OBFS_FUND_CRCY_OUTS_ADV_AMT__c + (Decimal)ar.get('advAmount');                                
                } else if (ar.get('advAmount') == null && fSnapUpdRec.OBFS_FUND_CRCY_OUTS_ADV_AMT__c == null){
                    fSnapUpdRec.OBFS_FUND_CRCY_OUTS_ADV_AMT__c = 0.00;
                } else {
                    if (ar.get('advAmount') == null){
                        fSnapUpdRec.OBFS_FUND_CRCY_OUTS_ADV_AMT__c = (Decimal)fSnapUpdRec.OBFS_FUND_CRCY_OUTS_ADV_AMT__c;
                    } 
                    if (fSnapUpdRec.OBFS_FUND_CRCY_OUTS_ADV_AMT__c == null ){
                        fSnapUpdRec.OBFS_FUND_CRCY_OUTS_ADV_AMT__c = (Decimal)ar.get('advAmount');
                    }   
                }
                
                
                if (ar.get('oblAmount') != null && fSnapUpdRec.OBLIGATION_AMT__c != null ){                 
                        fSnapUpdRec.OBLIGATION_AMT__c = (Decimal)fSnapUpdRec.OBLIGATION_AMT__c + (Decimal)ar.get('oblAmount');                                      
                } else if (ar.get('oblAmount') == null && fSnapUpdRec.OBLIGATION_AMT__c == null){
                    fSnapUpdRec.OBLIGATION_AMT__c = 0.00;
                } else {
                    if (ar.get('oblAmount') == null){
                        fSnapUpdRec.OBLIGATION_AMT__c = (Decimal)fSnapUpdRec.OBLIGATION_AMT__c;
                    } 
                    if(fSnapUpdRec.OBLIGATION_AMT__c == null) {
                        fSnapUpdRec.OBFS_FUND_CRCY_OUTS_ADV_AMT__c = (Decimal)ar.get('oblAmount');
                    }   
                }              
                
                if (ar.get('accAmount') != null && fSnapUpdRec.OBL_LASTQTR_ACCR_FP__c != null ){                    
                        fSnapUpdRec.OBL_LASTQTR_ACCR_FP__c = (Decimal)fSnapUpdRec.OBL_LASTQTR_ACCR_FP__c + (Decimal)ar.get('accAmount');                    
                } else if (ar.get('accAmount') == null && fSnapUpdRec.OBL_LASTQTR_ACCR_FP__c == null){
                    fSnapUpdRec.OBL_LASTQTR_ACCR_FP__c = 0.00;
                } else {    
                    if (ar.get('accAmount') == null){
                        fSnapUpdRec.OBL_LASTQTR_ACCR_FP__c = (Decimal)fSnapUpdRec.OBL_LASTQTR_ACCR_FP__c;
                    } 
                    if (fSnapUpdRec.OBL_LASTQTR_ACCR_FP__c == null) {
                        fSnapUpdRec.OBL_LASTQTR_ACCR_FP__c = (Decimal)ar.get('accAmount');
                    }   
                }    
                fSnapsUpdateList.add(fSnapUpdRec);
            } else {
                Fintxn_SMRY_FSNAP__c fSnapInsertRec = new Fintxn_SMRY_FSNAP__c();
                fSnapInsertRec.Award_Key__c = (String)ar.get('Award_Key__c');                
                fSnapInsertRec.Fiscal_Month__c = '12';
                fSnapInsertRec.Fiscal_Quarter__c = getQuarterOfAMonth(12);
                fSnapInsertRec.Fiscal_Year__c = (String)ar.get('Fiscal_Year__c');                
                fSnapInsertRec.OBFS_FISC_PERIOD__c = (String)ar.get('Fiscal_Year__c')+'/12';              
                fSnapInsertRec.OBFS_FUND_CRCY_DISB_AMT__c = (Decimal)ar.get('disbAmount');
              /*  if (ar.get('disbAmount') != null){
                    fSnapUpdRec.OBFS_FUND_CRCY_DISB_AMT__c = (Decimal)ar.get('disbAmount');
                } else {
                    fSnapUpdRec.OBFS_FUND_CRCY_DISB_AMT__c = 0.00;
                } */  
                
              //  fSnapInsertRec.OBFS_FUND_CRCY_OUTS_ADV_AMT__c = (Decimal)ar.get('advAmount');
               /* if (ar.get('advAmount') != null){
                    fSnapUpdRec.OBFS_FUND_CRCY_OUTS_ADV_AMT__c = (Decimal)ar.get('advAmount');
                } else {
                    fSnapUpdRec.OBFS_FUND_CRCY_OUTS_ADV_AMT__c = 0.00;
                } */ 
                               
              //  fSnapInsertRec.OBLIGATION_AMT__c = (Decimal)ar.get('oblAmount');
               /* if (ar.get('oblAmount') != null){
                    fSnapUpdRec.OBLIGATION_AMT__c = (Decimal)ar.get('oblAmount');
                } else {
                    fSnapUpdRec.OBLIGATION_AMT__c = 0.00;
                } */ 
                
           /*     if (ar.get('accAmount') != null){
                    fSnapUpdRec.OBL_LASTQTR_ACCR_FP__c = (Decimal)ar.get('accAmount');
                } else {
                    fSnapUpdRec.OBL_LASTQTR_ACCR_FP__c = 0.00;
                }                    
                fSnapsInsertList.add(fSnapInsertRec);               
            }           
        }
            batchCount = batchCount + 1;
        } */
        
        try {   
         database.insert(fSnapsInsertList,  false) ;             
         database.update (fSnapsUpdateList,  false) ; 
        // database.delete(Awardsdelete,false) ; 
      } catch ( exception e ) {
       
       }  
            
             
            
    }
   /* public String getQuarterOfAMonth(Integer mth){
        String returnQtr = '';
        if (mth <= 3){
            returnQtr = 'Q1';
        } else if ((mth > 3) && (mth <= 6)){
            returnQtr = 'Q2';
        } else if ((mth > 6) && (mth <= 9)){
            returnQtr = 'Q3';
        } else if (mth > 9){
            returnQtr = 'Q4';
        }
      //  System.debug('Quarter Method Returns:::' +returnQtr);
        return returnQtr;
    } */
    public void finish(Database.BatchableContext BC){
    }
    
}