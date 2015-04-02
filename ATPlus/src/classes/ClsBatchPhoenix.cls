global class ClsBatchPhoenix implements Schedulable {
    
    global void execute(SchedulableContext sc) {
      try {        
          ClsLoadAwards awards = new ClsLoadAwards();
          database.executebatch(awards);
        
         // LoadFintxn financials = new LoadFintxn();
         // database.executebatch(financials);
          
          ClsLoadFintxnFsnap snapSummaries = new ClsLoadFintxnFsnap();
          database.executebatch(snapSummaries);
          
          ClsLoadFintxnFacts factsSummaries = new ClsLoadFintxnFacts();
          database.executebatch(factsSummaries);
          
          ClsLoadIMFinancials imUpdates = new ClsLoadIMFinancials();
          database.executebatch(imUpdates);
            
      } catch (Exception e){
      
      }
        
        
        
    }
    
    @IsTest public static void testClsBatchPhoenix() {
        test.starttest();
        ClsBatchPhoenix sco = new ClsBatchPhoenix();        
        String sch = '0 0 23 * * ?';        
        system.schedule('Phoenix Loads', sch, sco);
        test.stopTest();
    }
    
    
    /*
    Fintxn_Load = new Fintxn_Load ();
    String sch = '0 3 * * * ?';
    System.schedule('Process Fintxn_Load Job', sch, AEL);
    */
    
}