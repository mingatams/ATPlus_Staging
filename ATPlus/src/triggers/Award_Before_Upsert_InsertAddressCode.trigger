trigger Award_Before_Upsert_InsertAddressCode on Award__c ( before insert, before update ) {   
    
    
        
          
    for(Award__c a : Trigger.New){          
        if(a.Vendor_CD__c == a.Vendor_NM__c){
            a.vendor_NM__c= a.vendor_NM__c+'_'+'001';
        }
        String MissionName = '';
        if( a.Mission_Name__c  != null ) {
            MissionName = a.Mission_Name__c ;
        }
         try {
            a.Process_Key__c = a.Award_Key__c +'_'+ a.Mission_Name__c ;
       } catch ( exception e ) {
       
       }
   }  
}