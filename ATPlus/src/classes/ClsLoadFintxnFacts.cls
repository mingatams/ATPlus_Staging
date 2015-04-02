public class ClsLoadFintxnFacts implements Database.Batchable<sObject>{

    public final String Query;
  
    list<string> lstid = new list<string> () ; 
    
    
    public ClsLoadFintxnFacts(){
   
      
        Query = ' SELECT Id, Name , '
         + ' OBFS_FUND_CRCY_OUTS_ADV_AMT__c,'
         + ' AWARD_KEY__c, OBFS_BBFY__c, OBFS_EBFY__c, OBFS_FUND__c, '
         + ' OBFS_FUND_CRCY_DISB_AMT__c, '
         + ' Fiscal_Year__c, Facts_Program_Area__c, Facts_Program_Element__c,Facts_Sub_Element__c,'
         + ' Phoenix_Program_Area__c, Phoenix_Program_Element__c,Phoenix_Sub_Element__c,'
         + ' OBLIGATION_AMT__c '         
         + ' FROM Fintxn_SMRY_FACTS_Ext__c Order by AWARD_KEY__c, Fiscal_Year__c, Phoenix_Program_Area__c, Phoenix_Program_Element__c,Phoenix_Sub_Element__c, OBFS_BBFY__c, OBFS_EBFY__c, OBFS_FUND__c';
         
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Fintxn_SMRY_FACTS_Ext__c> scope){
            
            Map<String,Award__c> awardsMap = new Map<String, Award__c>([select Award_Key__c, Implementing_Mechanism__c From Award__c]);
            Framework__c[] frameworks = [SELECT Id, Name, paCode__c, paName__c, peCode__c, peName__c, seCode__c, seName__c
                                        From Framework__c];
       
            Fintxn_SMRY_FACTS__c[] fFacts = [SELECT Id, Name,        
                                OBFS_FUND_CRCY_OUTS_ADV_AMT__c, Award_Key__c,
                                OBFS_FUND_CRCY_DISB_AMT__c, OBFS_BBFY__c, OBFS_EBFY__c, OBFS_FUND__c, 
                                Fiscal_Year__c ,OBLIGATION_AMT__c, 
                                Facts_Program_Area__c, Facts_Program_Element__c, Facts_Sub_Element__c,
                                Phoenix_Program_Area__c, Phoenix_Program_Element__c, Phoenix_Sub_Element__c, Framework_Id__c         
                                FROM Fintxn_SMRY_FACTS__c Order by AWARD_KEY__c,Fiscal_Year__c, Phoenix_Program_Area__c, Phoenix_Program_Element__c, Phoenix_Sub_Element__c, OBFS_BBFY__c, OBFS_EBFY__c, OBFS_FUND__c]  ;
          
        Set<String> fFactsKeys = new Set<String> () ;
        map<String,String>   frameworkMap = new map<String,String>() ;
        map<String,Fintxn_SMRY_FACTS__c>   fFactsMap = new  map<String,Fintxn_SMRY_FACTS__c>  () ;
        
        for(Framework__c frm:frameworks){           
            frameworkMap.put(prepFrameworkKey(frm),frm.Id);         
        }
        
        for ( Fintxn_SMRY_FACTS__c f : fFacts   ) {
            //fFactsMap.put((String)f.Award_Key__c+(String)f.Fiscal_Year__c+(String)f.Phoenix_Program_Area__c+(String)f.Phoenix_Program_Element__c+(String)f.Phoenix_Sub_Element__c+(String)f.OBFS_BBFY__c +(String)f.OBFS_EBFY__c +(String)f.OBFS_FUND__c,f); 
              fFactsMap.put(prepFintxnFactsKey(f),f);
          
        }           
      
        
        list<Fintxn_SMRY_FACTS__c> fFactsUpdateList = new list<Fintxn_SMRY_FACTS__c>();
        list<Fintxn_SMRY_FACTS__c> fFactsInsertList = new list<Fintxn_SMRY_FACTS__c>();
        set<string> keys = new set<string> () ;
        
        System.debug('Framework Map::::' +frameworkMap);
        for(sObject s : scope){
            Fintxn_SMRY_FACTS_EXT__c fFactsExt = new Fintxn_SMRY_FACTS_EXT__c();
            fFactsExt = (Fintxn_SMRY_FACTS_EXT__c)s;
            Fintxn_SMRY_FACTS__c fFactsUpdRec = new Fintxn_SMRY_FACTS__c();
            //if (fFactsMap.containsKey((String)fFactsExt.Award_Key__c+(String)fFactsExt.Fiscal_Year__c+(String)fFactsExt.Phoenix_Program_Area__c+(String)fFactsExt.Phoenix_Program_Element__c+(String)fFactsExt.Phoenix_Sub_Element__c+(String)fFactsExt.OBFS_BBFY__c +(String)fFactsExt.OBFS_EBFY__c +(String)fFactsExt.OBFS_FUND__c)){
              if (fFactsMap.containsKey(prepFintxnFactsKey(fFactsExt))){
               // fFactsUpdRec = fFactsMap.get((String)fFactsExt.Award_Key__c+(String)fFactsExt.Fiscal_Year__c+(String)fFactsExt.Phoenix_Program_Area__c+(String)fFactsExt.Phoenix_Program_Element__c+(String)fFactsExt.Phoenix_Sub_Element__c+(String)fFactsExt.OBFS_BBFY__c +(String)fFactsExt.OBFS_EBFY__c +(String)fFactsExt.OBFS_FUND__c);
                fFactsUpdRec = fFactsMap.get(prepFintxnFactsKey(fFactsExt));
                fFactsUpdRec.Award_Key__c = fFactsExt.AWARD_KEY__c;             
                fFactsUpdRec.Phoenix_Program_Area__c = fFactsExt.Phoenix_Program_Area__c;
                fFactsUpdRec.Phoenix_Program_Element__c = fFactsExt.Phoenix_Program_Element__c;
                fFactsUpdRec.Phoenix_Sub_Element__c = fFactsExt.Phoenix_Sub_Element__c;             
                fFactsUpdRec.Facts_Program_Area__c = fFactsExt.Facts_Program_Area__c;
                fFactsUpdRec.Facts_Program_Element__c = fFactsExt.Facts_Program_Element__c;
                fFactsUpdRec.Facts_Sub_Element__c = fFactsExt.Facts_Sub_Element__c;
                fFactsUpdRec.Fiscal_Year__c = fFactsExt.Fiscal_Year__c;  
                fFactsUpdRec.OBFS_FUND_CRCY_DISB_AMT__c = fFactsExt.OBFS_FUND_CRCY_DISB_AMT__c;
                fFactsUpdRec.OBFS_FUND_CRCY_OUTS_ADV_AMT__c = fFactsExt.OBFS_FUND_CRCY_OUTS_ADV_AMT__c;             
                fFactsUpdRec.OBLIGATION_AMT__c = fFactsExt.OBLIGATION_AMT__c;
                fFactsUpdRec.OBFS_FUND__c = fFactsExt.OBFS_FUND__c;
                fFactsUpdRec.OBFS_BBFY__c = fFactsExt.OBFS_BBFY__c;
                fFactsUpdRec.OBFS_EBFY__c = fFactsExt.OBFS_EBFY__c;
                
                System.debug('Update Logic::' +(String)fFactsExt.Facts_Program_Area__c+(String)fFactsExt.Facts_Program_Element__c+(String)fFactsExt.Facts_Sub_Element__c);
                
                
                if(frameworkMap.containsKey(prepFrameworkKey(fFactsExt))){
                    fFactsUpdRec.Framework_Id__c = frameworkMap.get(prepFrameworkKey(fFactsExt));
                }
                
                if (awardsMap.containsKey(fFactsExt.AWARD_KEY__c)){
                    Award__c awd = awardsMap.get(fFactsExt.AWARD_KEY__c); 
                    fFactsUpdRec.Implementing_Mechanism_Id__c = awd.Implementing_Mechanism__c;
                } 
                    
                fFactsUpdateList.add(fFactsUpdRec);
            } else {
                Fintxn_SMRY_FACTS__c fFactsInsertRec = new Fintxn_SMRY_FACTS__c();
                fFactsInsertRec.Award_Key__c = fFactsExt.AWARD_KEY__c;              
                fFactsInsertRec.Phoenix_Program_Area__c = fFactsExt.Phoenix_Program_Area__c;
                fFactsInsertRec.Phoenix_Program_Element__c = fFactsExt.Phoenix_Program_Element__c;
                fFactsInsertRec.Phoenix_Sub_Element__c = fFactsExt.Phoenix_Sub_Element__c;              
                fFactsInsertRec.Facts_Program_Area__c = fFactsExt.Facts_Program_Area__c;
                fFactsInsertRec.Facts_Program_Element__c = fFactsExt.Facts_Program_Element__c;
                fFactsInsertRec.Facts_Sub_Element__c = fFactsExt.Facts_Sub_Element__c;                
                fFactsInsertRec.Fiscal_Year__c = fFactsExt.Fiscal_Year__c;  
                fFactsInsertRec.OBFS_FUND_CRCY_DISB_AMT__c = fFactsExt.OBFS_FUND_CRCY_DISB_AMT__c;
                fFactsInsertRec.OBFS_FUND_CRCY_OUTS_ADV_AMT__c = fFactsExt.OBFS_FUND_CRCY_OUTS_ADV_AMT__c;              
                fFactsInsertRec.OBLIGATION_AMT__c = fFactsExt.OBLIGATION_AMT__c;
                fFactsInsertRec.OBFS_FUND__c = fFactsExt.OBFS_FUND__c;
                fFactsInsertRec.OBFS_BBFY__c = fFactsExt.OBFS_BBFY__c;
                fFactsInsertRec.OBFS_EBFY__c = fFactsExt.OBFS_EBFY__c;
                
                System.debug('Insert Logic::' +(String)fFactsExt.Facts_Program_Area__c+(String)fFactsExt.Facts_Program_Element__c+(String)fFactsExt.Facts_Sub_Element__c);
                
                if(frameworkMap.containsKey(prepFrameworkKey(fFactsExt))){
                    fFactsInsertRec.Framework_Id__c = frameworkMap.get(prepFrameworkKey(fFactsExt));
                }
                
                if (awardsMap.containsKey(fFactsExt.AWARD_KEY__c)){
                    Award__c awd = awardsMap.get(fFactsExt.AWARD_KEY__c); 
                    fFactsInsertRec.Implementing_Mechanism_Id__c = awd.Implementing_Mechanism__c;
                } 
                
                                    
                fFactsInsertList.add(fFactsInsertRec);              
            }           
        }
        
        try {   
        
         database.insert(fFactsInsertList,  false) ;
         System.debug('Update List:::'+fFactsUpdateList);             
         database.update(fFactsUpdateList,  false) ;
         
        // database.delete(Awardsdelete,false) ; 
      } catch ( exception e ) {
       
       }  
            
             
            
    }
    
    public void finish(Database.BatchableContext BC){
    }
    
    public String prepFrameworkKey(Framework__c frm){
        String frameworkKey;
        if (frm.paCode__c != null){
            frameworkKey = ((String)frm.paCode__c).trim();
        }
        if (frm.peCode__c != null){
            frameworkKey = frameworkKey+((String)frm.peCode__c).trim();
        }
        if (frm.seCode__c != null){
            frameworkKey = frameworkKey+((String)frm.seCode__c).trim();
        }
        return frameworkKey;
    }
    
    public String prepFrameworkKey(Fintxn_SMRY_Facts__c facts){
        String factsKey;
        if (facts.Facts_Program_Area__c != null){
            factsKey = ((String)facts.Facts_Program_Area__c).trim();
        }
        if (facts.Facts_Program_Element__c != null){
            factsKey = factsKey+((String)facts.Facts_Program_Element__c).trim();
        }
        if (facts.Facts_Sub_Element__c != null){
            factsKey = factsKey+((String)facts.Facts_Sub_Element__c).trim();
        }   
        
        return factsKey;
        
    }    
    
    public String prepFrameworkKey(Fintxn_SMRY_Facts_Ext__c factsExt){
        String factsExtKey;
        if (factsExt.Facts_Program_Area__c != null){
            factsExtKey = ((String)factsExt.Facts_Program_Area__c).trim();
        }
        if (factsExt.Facts_Program_Element__c != null){
            factsExtKey = factsExtKey+((String)factsExt.Facts_Program_Element__c).trim();
        }
        if (factsExt.Facts_Sub_Element__c != null){
            factsExtKey = factsExtKey+((String)factsExt.Facts_Sub_Element__c).trim();
        }   
        
        return factsExtKey;
    }
    
     
    public String prepFintxnFactsKey(Fintxn_SMRY_Facts_Ext__c factsExt){
        String factsExtKey;
        if (factsExt.Award_Key__c != null){
            factsExtKey = ((String)factsExt.Award_Key__c).trim();
        }
        if (factsExt.Fiscal_Year__c != null){
            factsExtKey = factsExtKey + ((String)factsExt.Fiscal_Year__c).trim();
        }
        if (factsExt.Phoenix_Program_Area__c != null){
            factsExtKey = factsExtKey+((String)factsExt.Phoenix_Program_Area__c).trim();
        }
        if (factsExt.Phoenix_Program_Element__c != null){
            factsExtKey = factsExtKey+((String)factsExt.Phoenix_Program_Element__c).trim();
        }
        if (factsExt.Phoenix_Sub_Element__c != null){
            factsExtKey = factsExtKey+((String)factsExt.Phoenix_Sub_Element__c).trim();
        }       
        if (factsExt.OBFS_BBFY__c != null){
            factsExtKey = factsExtKey+((String)factsExt.OBFS_BBFY__c).trim();
        }
        if (factsExt.OBFS_EBFY__c != null){
            factsExtKey = factsExtKey+((String)factsExt.OBFS_EBFY__c).trim();
        }
        if (factsExt.OBFS_FUND__c != null){
            factsExtKey = factsExtKey+((String)factsExt.OBFS_FUND__c).trim();
        }
        
        return factsExtKey;
    }
    
    public String prepFintxnFactsKey(Fintxn_SMRY_Facts__c facts){
        String factsKey;
        if (facts.Award_Key__c != null){
            factsKey = ((String)facts.Award_Key__c).trim();
        }
        if (facts.Fiscal_Year__c != null){
            factsKey = factsKey + ((String)facts.Fiscal_Year__c).trim();
        }
        if (facts.Phoenix_Program_Area__c != null){
            factsKey = factsKey+((String)facts.Phoenix_Program_Area__c).trim();
        }
        if (facts.Phoenix_Program_Element__c != null){
            factsKey = factsKey+((String)facts.Phoenix_Program_Element__c).trim();
        }
        if (facts.Phoenix_Sub_Element__c != null){
            factsKey = factsKey+((String)facts.Phoenix_Sub_Element__c).trim();
        }       
        if (facts.OBFS_BBFY__c != null){
            factsKey = factsKey+((String)facts.OBFS_BBFY__c).trim();
        }
        if (facts.OBFS_EBFY__c != null){
            factsKey = factsKey+((String)facts.OBFS_EBFY__c).trim();
        }
        if (facts.OBFS_FUND__c != null){
            factsKey = factsKey+((String)facts.OBFS_FUND__c).trim();
        }
        
        return factsKey;
    }
    
}