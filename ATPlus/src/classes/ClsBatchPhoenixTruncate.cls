global class ClsBatchPhoenixTruncate implements Schedulable {
    
    global void execute(SchedulableContext sc) {
      try {        
          String qurey =    ' SELECT id, Name  '
                            + ' FROM Award_Ext__c ';
          ClsTruncateFinancialExts  awardExts= new ClsTruncateFinancialExts(qurey);
          database.executebatch(awardExts);        
         
          qurey =   ' SELECT id, Name  '
                  + ' FROM Fintxn_Smry_Fsnap_Ext__c ';
          ClsTruncateFinancialExts  fsnapExts = new ClsTruncateFinancialExts(qurey);
          database.executebatch(fsnapExts); 
          
          qurey =   ' SELECT id, Name  '
                  + ' FROM Fintxn_Smry_Facts_Ext__c ';
          ClsTruncateFinancialExts  factsExts = new ClsTruncateFinancialExts(qurey);
          database.executebatch(factsExts);
          
          qurey =   ' SELECT id, Name  '
                  + ' FROM Award_Financials_Ext__c ';
          ClsTruncateFinancialExts  awardFinExts = new ClsTruncateFinancialExts(qurey);
          database.executebatch(awardFinExts); 
            
      } catch (Exception e){
      
      }
        
        
        
    }
    
    
    @IsTest public static void testClsBatchPhoenixTruncate() {
        test.starttest();
        ClsBatchPhoenixTruncate sco = new ClsBatchPhoenixTruncate();        
        String sch = '0 0 23 * * ?';        
        system.schedule('RP Status Changes', sch, sco);
        test.stopTest();
    }
    
    /*
    Fintxn_Load = new Fintxn_Load ();
    String sch = '0 3 * * * ?';
    System.schedule('Process Fintxn_Load Job', sch, AEL);
    */
    
}