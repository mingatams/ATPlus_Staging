global class ClsTruncateFinancialExts implements Database.Batchable<sObject>{
  

    public final String Query;
  //	global integer batchCount;
  	
   // list<string> lstid = new list<string> () ; 
    
    
    public ClsTruncateFinancialExts(String q){   
      	//batchCount = 0;
      	Query = q;
       /* Query = ' SELECT AWARD_KEY__c, count(Id)  '
         + ' FROM Fintxn_Smry_Fsnap_Ext__c '
         + ' GROUP BY AWARD_KEY__c '; */
         
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope){
     // List<String> listAwardKeys = new List<String>();
      try{
        
            
       /* for(AggregateResult s : scope){
          //Award_Ext__c ae = new Award_Ext__c();
          //ae = (Award_Ext__c)s;
          listAwardKeys.add((String)s.get('Award_Key__c'));
        }
         
        // set<String> 
        // List<Fintxn_Ext__c> fintxnsToDelete = new List<Fintxn_Ext__c>([Select id, Name From Fintxn_Ext__c where Award_Key__c in :listAwardKeys]);
        // delete fintxnsToDelete;
        // Database.emptyRecycleBin(fintxnsToDelete);
         
         List<Fintxn_SMRY_FSNAP_Ext__c> fsnapsToDelete = new List<Fintxn_SMRY_FSNAP_Ext__c>([Select id, Name From Fintxn_SMRY_FSNAP_Ext__c where Award_Key__c in :listAwardKeys]);
         delete fsnapsToDelete;
         if(fsnapsToDelete != null && fsnapsToDelete.size() > 0){
         	Database.emptyRecycleBin(fsnapsToDelete);
         }
         
         List<Fintxn_SMRY_FACTS_Ext__c> factsToDelete = new List<Fintxn_SMRY_FACTS_Ext__c>([Select id, Name From Fintxn_SMRY_FACTS_Ext__c where Award_Key__c in :listAwardKeys]);
         delete factsToDelete;
         if(factsToDelete!= null && factsToDelete.size() > 0){
         	Database.emptyRecycleBin(factsToDelete);
      	 }       
         
         List<Award_Financials_Ext__c> aFinToDelete = new List<Award_Financials_Ext__c>([Select id, Name From Award_Financials_Ext__c where Award_Key__c in :listAwardKeys]);
         delete aFinToDelete;
         if(aFinToDelete!= null && aFinToDelete.size() > 0){         
         	Database.emptyRecycleBin(aFinToDelete);
         }         
         
         if (batchCount == 0){
         	List<Award_Ext__c> awardsToDelete = new List<Award_Ext__c>([Select id, Name From Award_Ext__c]);
         	delete awardsToDelete;
         	if(awardsToDelete!= null && awardsToDelete.size() > 0){         
         		Database.emptyRecycleBin(awardsToDelete);
         	}
         }
         
         batchCount = batchCount + 1; */
         
         delete scope;
         if(scope!= null && scope.size() > 0){
         	Database.emptyRecycleBin(scope);
      	 }	
      } catch(Exception e){
        
      }   
    }
    
    public void finish(Database.BatchableContext BC){
    }
    


}