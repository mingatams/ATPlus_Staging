public class ClsLoadAwards implements Database.Batchable<sObject>{

    public final String Query;
  
    list<string> lstid = new list<string> () ;
    
    
    public ClsLoadAwards(){
   
      
        Query = ' SELECT Id, Name , '
         + ' ACTIVE_STATUS__c, ADDR_LINE_1__c, ADDR_LINE_2__c ,'
         + ' ADDR_FORMAT__c, Award_Number__c, CCR_REGI_STATUS__c ,'
         + ' ADDR_CITY__c, COR__c, ADDR_COUNTRY__c,DFLT_PYMT_TYPE_ID__c , '
         + ' DFLT_PPAY_TYPE_ID__c, DOCNUM__c, DUNS_NUM__c , '
         + ' ENDDATE__c, XTRN_VEND_FL__c, FORM_1099_FLAG__c ,GLAAS_SITE__c, '
         + ' LAST_MODIFICATION__c, MISC_FLAG__c, MISSION_NAME__c,ORDERNUM__c,'
         + ' PVNT_NEW_SPNG__c, PROJECTTITLE__c, SHORTDESCR__c,SMALL_BIZ_FLAG__c, '
         + ' STARTDATE__c, ADDR_STATE__c, TIN_VERIFY_ACTION__c,TEC__c, '
         + ' VENDOR_ADDR_CD__c, VENDOR_CD__c, VENDOR_NM__c,Contract_Grant__c, Award_Type__c,'
         + ' VENDOR_TYPE_ID__c, VEND_UNIQUE_ID__c,Zip_Code__c ,Award_Key__c, OrgUnit_Code__c, OrgUnit_Name__c '
         + ' FROM Award_Ext__c Order by Award_Key__c'   ;
         
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Award_Ext__c> scope){
       
            Award__c[] Awards = [SELECT Id, Name,        
         ACTIVE_STATUS__c, ADDR_LINE_1__c, ADDR_LINE_2__c ,
         ADDR_FORMAT__c, CCR_REGI_STATUS__c ,
         ADDR_CITY__c, COR__c, ADDR_COUNTRY__c,DFLT_PYMT_TYPE_ID__c , 
         DFLT_PPAY_TYPE_ID__c, DOCNUM__c, DUNS_NUM__c , 
         ENDDATE__c, XTRN_VEND_FL__c, FORM_1099_FLAG__c ,GLAAS_SITE__c, 
         LAST_MODIFICATION__c, MISC_FLAG__c, MISSION_NAME__c,ORDERNUM__c,
         PVNT_NEW_SPNG__c, PROJECTTITLE__c, SHORTDESCR__c,SMALL_BIZ_FLAG__c, 
         STARTDATE__c, ADDR_STATE__c, TIN_VERIFY_ACTION__c,TEC__c, 
         VENDOR_ADDR_CD__c, VENDOR_CD__c, VENDOR_NM__c,ADDR_ZIPCODE__c,
         VENDOR_TYPE_ID__c, VEND_UNIQUE_ID__c, Award_Key__c, Contract_Grant__c, Award_Type__c, OrgUnit_Code__c, OrgUnit_Name__c
         FROM Award__c Order by Award_Key__c]  ;
         
        Set<String> AwdKeys = new Set<String> () ;
        map<String,Award__c>   awardkey = new  map<String,Award__c>  () ;
            for ( Award__c a : Awards   ) {
               String orgUnitCode = '';
                if( a.OrgUnit_code__c != null ) {
                    orgUnitCode = (String)a.OrgUnit_code__c ; 
                }
                if ( ! awardkey.containskey(a.Award_Key__c+'_'+orgUnitCode) ) {
                  awardkey.put(a.Award_Key__c+'_'+orgUnitCode ,a); 
                  AwdKeys.add(a.Award_Key__c);
               }
            }
            
      //  list<Award_Ext__c> AwardExtRecs = new list<Award_Ext__c>();
        
        list<Award__c> AwardsUpdate = new list<Award__c>();
        list<Award__c> AwardsInsert = new list<Award__c>();
        set<string> keys = new set<string> () ;
            
             
            for(sObject s : scope){
              //  Award_Ext__c a = (Award_Ext__c)s;
                  Award_Ext__c AwardExtRec = new Award_Ext__c();
                    Award__c awardrec = new Award__c ();
                  AwardExtRec = (Award_Ext__c)s;
                 String ExtOrgUnitCode = '';
                if( AwardExtRec.Orgunit_Code__c != null ) {
                    ExtOrgUnitCode = AwardExtRec.Orgunit_Code__c ; 
                }
                
                System.Debug(' AwardExtRec ==> ' + AwardExtRec.Award_Key__c+'_'+AwardExtRec.mission_name__c);
               String AwdExtkey_OrgUnit = AwardExtRec.Award_Key__c+'_'+ExtOrgUnitCode  ;
                if ( awardkey.containskey(AwdExtkey_OrgUnit) ){//|| awardkey.get(AwardExtRec.Award_Key__c+'_'+AwardExtRec.mission_name__c) != null ) {
               
                  //  Award__c tmp_a = new Award__c (); 
                    awardrec  =   Awardkey.get(AwdExtkey_OrgUnit) ;
                    
                    AwardRec.Award_Key__c=AwardExtRec.Award_Key__c;
                AwardRec.ACTIVE_STATUS__c=AwardExtRec.ACTIVE_STATUS__c;
                AwardRec.ADDR_LINE_1__c=AwardExtRec.ADDR_LINE_1__c;
                AwardRec.ADDR_LINE_2__c=AwardExtRec.ADDR_LINE_2__c;
                AwardRec.ADDR_FORMAT__c=AwardExtRec.ADDR_FORMAT__c;
             
                AwardRec.CCR_REGI_STATUS__c=AwardExtRec.CCR_REGI_STATUS__c;
                AwardRec.ADDR_CITY__c=AwardExtRec.ADDR_CITY__c;
                AwardRec.COR__c=AwardExtRec.COR__c;
                AwardRec.ADDR_COUNTRY__c=AwardExtRec.ADDR_COUNTRY__c;
                AwardRec.DFLT_PYMT_TYPE_ID__c=AwardExtRec.DFLT_PYMT_TYPE_ID__c;
                AwardRec.DFLT_PPAY_TYPE_ID__c=AwardExtRec.DFLT_PPAY_TYPE_ID__c;
                AwardRec.DOCNUM__c=AwardExtRec.DOCNUM__c;
                AwardRec.DUNS_NUM__c=AwardExtRec.DUNS_NUM__c;
                AwardRec.ENDDATE__c=AwardExtRec.ENDDATE__c;
                AwardRec.XTRN_VEND_FL__c=AwardExtRec.XTRN_VEND_FL__c;
                AwardRec.FORM_1099_FLAG__c=AwardExtRec.FORM_1099_FLAG__c;
                AwardRec.GLAAS_SITE__c=AwardExtRec.GLAAS_SITE__c;
                AwardRec.LAST_MODIFICATION__c=AwardExtRec.LAST_MODIFICATION__c;
                AwardRec.MISC_FLAG__c=AwardExtRec.MISC_FLAG__c;
                AwardRec.MISSION_NAME__c=AwardExtRec.MISSION_NAME__c;
                AwardRec.ORDERNUM__c=AwardExtRec.ORDERNUM__c;
                AwardRec.PVNT_NEW_SPNG__c=AwardExtRec.PVNT_NEW_SPNG__c;
                AwardRec.PROJECTTITLE__c=AwardExtRec.PROJECTTITLE__c;
                system.debug('Award Title Displayed::' +AwardExtRec.PROJECTTITLE__c);
                if (AwardExtRec.PROJECTTITLE__c != null){
                	AwardRec.PROJECTTITLE__c=AwardExtRec.PROJECTTITLE__c;
                } else {
                	AwardRec.PROJECTTITLE__c = 'N/A';                	
                }       
                AwardRec.SHORTDESCR__c=AwardExtRec.SHORTDESCR__c;
                AwardRec.SMALL_BIZ_FLAG__c=AwardExtRec.SMALL_BIZ_FLAG__c;
                AwardRec.STARTDATE__c=AwardExtRec.STARTDATE__c;
                AwardRec.ADDR_STATE__c=AwardExtRec.ADDR_STATE__c;
                AwardRec.TIN_VERIFY_ACTION__c=AwardExtRec.TIN_VERIFY_ACTION__c;
                AwardRec.TEC__c=AwardExtRec.TEC__c;
                AwardRec.VENDOR_ADDR_CD__c=AwardExtRec.VENDOR_ADDR_CD__c;
                AwardRec.VENDOR_CD__c=AwardExtRec.VENDOR_CD__c;
                AwardRec.VENDOR_NM__c=AwardExtRec.VENDOR_NM__c;
                AwardRec.VENDOR_TYPE_ID__c=AwardExtRec.VENDOR_TYPE_ID__c;
                AwardRec.VEND_UNIQUE_ID__c=AwardExtRec.VEND_UNIQUE_ID__c;
                AwardRec.ADDR_ZIPCODE__c=AwardExtRec.Zip_Code__c;
                AwardRec.Contract_Grant__c = AwardExtRec.CONTRACT_GRANT__c;
                AwardRec.Award_Type__c = AwardExtRec.AWARD_TYPE__c;
                AwardRec.OrgUnit_Code__c = AwardExtRec.OrgUnit_Code__c;
                AwardRec.OrgUnit_Name__c = AwardExtRec.OrgUnit_Name__c;
                
                     If(AwardExtRec.ORDERNUM__c!=null){
                AwardRec.name=AwardExtRec.name ;
              
               }
               
               else{
               AwardRec.name=AwardExtRec.name ;               
           
                } 
                    
                    AwardsUpdate.add(awardrec); 
                   // keys.add(AwardExtRec.Award_Key__c);
                } else {
                 Award__c awardrec2 = new Award__c ();
                 
                AwardRec2.Award_Key__c=AwardExtRec.Award_Key__c;
                AwardRec2.ACTIVE_STATUS__c=AwardExtRec.ACTIVE_STATUS__c;
                AwardRec2.ADDR_LINE_1__c=AwardExtRec.ADDR_LINE_1__c;
                AwardRec2.ADDR_LINE_2__c=AwardExtRec.ADDR_LINE_2__c;
                AwardRec2.ADDR_FORMAT__c=AwardExtRec.ADDR_FORMAT__c;
             //   AwardRec.Award_Number__c=AwardExtRec.Award_Number__c;
                AwardRec2.CCR_REGI_STATUS__c=AwardExtRec.CCR_REGI_STATUS__c;
                AwardRec2.ADDR_CITY__c=AwardExtRec.ADDR_CITY__c;
                AwardRec2.COR__c=AwardExtRec.COR__c;
                AwardRec2.ADDR_COUNTRY__c=AwardExtRec.ADDR_COUNTRY__c;
                AwardRec2.DFLT_PYMT_TYPE_ID__c=AwardExtRec.DFLT_PYMT_TYPE_ID__c;
                AwardRec2.DFLT_PPAY_TYPE_ID__c=AwardExtRec.DFLT_PPAY_TYPE_ID__c;
                AwardRec2.DOCNUM__c=AwardExtRec.DOCNUM__c;
                AwardRec2.DUNS_NUM__c=AwardExtRec.DUNS_NUM__c;
                AwardRec2.ENDDATE__c=AwardExtRec.ENDDATE__c;
                AwardRec2.XTRN_VEND_FL__c=AwardExtRec.XTRN_VEND_FL__c;
                AwardRec2.FORM_1099_FLAG__c=AwardExtRec.FORM_1099_FLAG__c;
                AwardRec2.GLAAS_SITE__c=AwardExtRec.GLAAS_SITE__c;
                AwardRec2.LAST_MODIFICATION__c=AwardExtRec.LAST_MODIFICATION__c;
                AwardRec2.MISC_FLAG__c=AwardExtRec.MISC_FLAG__c;
                AwardRec2.MISSION_NAME__c=AwardExtRec.MISSION_NAME__c;
                AwardRec2.ORDERNUM__c=AwardExtRec.ORDERNUM__c;
                AwardRec2.PVNT_NEW_SPNG__c=AwardExtRec.PVNT_NEW_SPNG__c;
                AwardRec2.PROJECTTITLE__c=AwardExtRec.PROJECTTITLE__c;
                system.debug('Award Title Displayed::' +AwardExtRec.PROJECTTITLE__c);
                if (AwardExtRec.PROJECTTITLE__c != null){
                	AwardRec2.PROJECTTITLE__c=AwardExtRec.PROJECTTITLE__c;
                } else {
                	AwardRec2.PROJECTTITLE__c = 'N/A';                	
                }
                AwardRec2.SHORTDESCR__c=AwardExtRec.SHORTDESCR__c;
                AwardRec2.SMALL_BIZ_FLAG__c=AwardExtRec.SMALL_BIZ_FLAG__c;
                AwardRec2.STARTDATE__c=AwardExtRec.STARTDATE__c;
                AwardRec2.ADDR_STATE__c=AwardExtRec.ADDR_STATE__c;
                AwardRec2.TIN_VERIFY_ACTION__c=AwardExtRec.TIN_VERIFY_ACTION__c;
                AwardRec2.TEC__c=AwardExtRec.TEC__c;
                AwardRec2.VENDOR_ADDR_CD__c=AwardExtRec.VENDOR_ADDR_CD__c;
                AwardRec2.VENDOR_CD__c=AwardExtRec.VENDOR_CD__c;
                AwardRec2.VENDOR_NM__c=AwardExtRec.VENDOR_NM__c;
                AwardRec2.VENDOR_TYPE_ID__c=AwardExtRec.VENDOR_TYPE_ID__c;
                AwardRec2.VEND_UNIQUE_ID__c=AwardExtRec.VEND_UNIQUE_ID__c;
                AwardRec2.Contract_Grant__c = AwardExtRec.CONTRACT_GRANT__c;
                AwardRec2.Award_Type__c = AwardExtRec.AWARD_TYPE__c;
                AwardRec2.OrgUnit_Code__c = AwardExtRec.OrgUnit_Code__c;
                AwardRec2.OrgUnit_Name__c = AwardExtRec.OrgUnit_Name__c;
                    
                    If(AwardExtRec.ORDERNUM__c!=null){
              //  AwardRec.name=AwardExtRec.name +' '+ AwardExtRec.DOCNUM__c +' '+ AwardExtRec.ORDERNUM__c;
                 AwardRec2.name=AwardExtRec.name;
               }
               else{
              // AwardRec.name=AwardExtRec.name +' '+ AwardExtRec.DOCNUM__c;               
               AwardRec2.name=AwardExtRec.name ;
                } 
                    
                    AwardsInsert.add(awardrec2); 
                
                }
                    
             }     
         
         System.debug('Insert List Size::::'+AwardsInsert.size());
         System.debug('Update List Size::::'+AwardsUpdate.size()+AwardsUpdate);
     /*    for(Award__c a: AwardsInsert ){
             System.Debug('InsertList Id::::' +a.Id+'  :::Award:::'+a.Award_key__c);
             
         }
         
         for(Award__c a: AwardsUpdate){
             System.Debug('UpdateList Id::::' +a.Id+'  :::Award:::'+a.Award_key__c);
             
         }*/
         
        // AwardsUpdate.addAll(AwardsInsert);
       //  Schema.SObjectField f = Award__c.Fields.Process_Key__c ;
         
          try {   
         database.insert(AwardsInsert,  false) ;
             
         database.update (AwardsUpdate,  false) ; 
        // database.delete(Awardsdelete,false) ; 
      } catch ( exception e ) {
       
       }  
    }
    
    public void finish(Database.BatchableContext BC){
    }
    
}