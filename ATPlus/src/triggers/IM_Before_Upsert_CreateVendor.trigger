trigger IM_Before_Upsert_CreateVendor on Implementing_Mechanism__c (before insert, before update) {
                
    Set<Id> AwardIds = new Set<Id> () ; 
    Set<String> ParentAccountNames = new Set<String> () ; 
    Set<String> LinkAccountNames = new Set<String> () ;
    Set<String> NewPrntAccNames = new Set<String> () ; 
            
    list<Account> UpsertAccs = new list<Account> () ;
    list<Account>  ParentAccs = new list<Account> () ;
    list<Account> NewParentAccs = new list<Account> () ;
    list<Account> NewChildAccs = new list<Account> () ;

    list<Account> updateChildAccs = new list<Account> () ;
    Map<String,String> old_newAccsname = new Map<String,String> (); 
            
    Map<String,String> MAPChildaccs_Imid = new Map<String,String> () ;
    Map<String,String> MAPImid_Award = new Map<String,String> () ;
    Map<String,Account> AllAccs = new Map<String,Account> () ;
    Map<String,String> MAPChildaccs_Parentaccs = new Map<String,String> ();
    Map<String,Award__c> Map_AwardAddress = new Map<String,Award__c> () ;
    List<User> adminUsers = new List<User>([Select Id, Name From User 
    where Profile.Name = 'System Administrator(c)' and UserRole.Name = 'Root System Administrator' 
    and isActive = true and firstName = 'Batch'  limit 1]);        
    if (!ApplicationConstants.bypassIMCreateVendorTriggerLogic){               
         for(Implementing_Mechanism__c im: Trigger.New){
            AwardIds.add(IM.Award_Id__c);            
    }
             
    Map<Id,Award__c> AwardMap = new Map<Id,Award__c>(
                        [select id,tec__c,VEND_UNIQUE_ID__c,
                                ADDR_LINE_1__c,ADDR_LINE_2__c,CCR_REGI_STATUS__c,ADDR_CITY__c,
                                ADDR_COUNTRY__c,ADDR_STATE__c,ADDR_ZIPCODE__c,ADDR_FORMAT__c,DUNS_NUM__c,
                                SMALL_BIZ_FLAG__c,FORM_1099_FLAG__c,
                                //DFLT_PYMT_TYPE_ID__c,DFLT_PPAY_TYPE_ID__c,
                                // TIN_VERIFY_ACTION__c,   PVNT_NEW_SPNG__c,XTRN_VEND_FL__c,
                                VENDOR_TYPE_ID__c,
                                // MISC_FLAG__c,
                                ACTIVE_STATUS__c,VENDOR_CD__c,VENDOR_NM__c,VENDOR_ADDR_CD__c,PROJECTTITLE__c,
                                STARTDATE__c,ENDDATE__c,DocNum__c,
                                //Award_Id__c, 
                                Contract_Grant__c, Award_Type__c
                          from Award__c where id IN: AwardIds ]);
            
          
             
            
    for(Implementing_Mechanism__c ImpMech : Trigger.New){       
            
        if(ImpMech.Award_Id__c!=null){
            if(AwardMap.get(ImpMech.Award_Id__c).Tec__c!=null){
                ImpMech.totAward__c= AwardMap.get(ImpMech.Award_Id__c).Tec__c;                      
              
               //MNB 01/17/13 next two lines
               //if (AwardMap.get(ImpMech.Award_Id__c).Tec__c > 0){
                //ImpMech.Award_Amount__c= AwardMap.get(ImpMech.Award_Id__c).Tec__c;  
               //}
               
               //03/05/13 Commented above assignment TEC to Award Amount, instead setting TotObl from IM itself to AwardAmount
               if (ImpMech.totObl__c > 0 && ImpMech.Award_Amount__c == null ){
                ImpMech.Award_Amount__c= ImpMech.totObl__c;  
               }
               
               
               ImpMech.Award_Number__c= AwardMap.get(ImpMech.Award_Id__c).DocNum__c;
               ImpMech.Partner_Name__c= AwardMap.get(ImpMech.Award_Id__c).VENDOR_NM__c;
               ImpMech.Start_Date__c= AwardMap.get(ImpMech.Award_Id__c).STARTDATE__c;
               ImpMech.End_Date__c= AwardMap.get(ImpMech.Award_Id__c).EndDate__c;
               if (ImpMech.Implementing_Mechanism_Name__c == null){
                ImpMech.Implementing_Mechanism_Name__c = AwardMap.get(ImpMech.Award_Id__c).PROJECTTITLE__c;
               }
                                    
                // ImpMech.GLAAS_REF_Filter_Flag__c = AwardMap.get(ImpMech.Award_Id__c).GLAAS_REF_Filter_Flag__c;
          
                System.debug('TEC  '+Impmech.totAward__c);
           
            } else {
                ImpMech.totAward__c=0;
                //   ImpMech.Award_Id__c= AwardMap.get(ImpMech.Award_Id__c).Award_Key__c;
               
                ImpMech.Start_Date__c= AwardMap.get(ImpMech.Award_Id__c).STARTDATE__c;
                ImpMech.End_Date__c= AwardMap.get(ImpMech.Award_Id__c).EndDate__c;
                if (ImpMech.Implementing_Mechanism_Name__c == null){
                    ImpMech.Implementing_Mechanism_Name__c = AwardMap.get(ImpMech.Award_Id__c).PROJECTTITLE__c;
                }    
            }
                    
            if( AwardMap.get(ImpMech.Award_Id__c).Vendor_cd__c != null ){
                 String ParentName = AwardMap.get(ImpMech.Award_Id__c).Vendor_cd__c ;
                 ParentAccountNames.add( ParentName );
                 MAPChildaccs_Imid.put( ParentName , ImpMech.id );
                         
                    
                if( AwardMap.get(ImpMech.Award_Id__c).Vendor_NM__c !=null ){
                     String ChildName = AwardMap.get(ImpMech.Award_Id__c).Vendor_NM__c ;
                      if( ImpMech.Partner_Id__c != null ) {
                         old_newAccsname.put(ImpMech.Partner_Id__c,ChildName ); 
                         Award__c tmp_awd =AwardMap.get(ImpMech.Award_Id__c);
                         Map_AwardAddress.put(ImpMech.Partner_Id__c, tmp_awd);
                         
                     } else { 
                      LinkAccountNames.add(  ChildName );
                     } 
                     MAPChildaccs_Imid.put( ChildName , ImpMech.id );
                     MAPChildaccs_Parentaccs.put( ChildName  , ParentName );
                } 
                    
            }
            
            MAPImid_Award.put(ImpMech.id,AwardMap.get(ImpMech.Award_Id__c).Id);
                
        }
           
    }
         
           
   System.debug(' ParentAccountNames ==> ' +  ParentAccountNames );        
   System.debug(' LinkAccountNames ==> ' +  LinkAccountNames );        
   System.debug(' old_newAccsname ==> ' +  old_newAccsname );
           
    // Update Old Accs Name
   System.debug(' old_newAccsname ==> ' +  old_newAccsname );  
   
   if( !old_newAccsname.isEmpty() ) {
    //list<Account> updateoldaccs = new list<Account> () ;
        Account[] accounts = [ SELECT Id, Name   
                          FROM Account 
                          WHERE Id IN : old_newAccsname.keyset()  ];
        for ( Account a : accounts ) {
            a.name = old_newAccsname.get(a.Id) ; 
            Award__c aw = Map_AwardAddress.get(a.id) ;
            
            a.ADDR_LINE_1__c = Aw.ADDR_LINE_1__c ;
            a.ADDR_LINE_2__c = Aw.ADDR_LINE_2__c ;
            a.BillingStreet = Aw.ADDR_LINE_1__c  + ' ' + Aw.ADDR_LINE_2__c ;
            a.CCR_REGI_STATUS__c = Aw.CCR_REGI_STATUS__c ;
            a.ADDR_CITY__c = Aw.ADDR_CITY__c ;
            a.BillingCity = Aw.ADDR_CITY__c ;
            a.ADDR_STATE__c= Aw.ADDR_STATE__c ;
            a.BillingState = Aw.ADDR_STATE__c ;         
            a.ADDR_COUNTRY__c = Aw.ADDR_COUNTRY__c ;
            a.BillingCountry =  Aw.ADDR_COUNTRY__c ;         
            a.ADDR_ZIPCODE__c = Aw.ADDR_ZIPCODE__c ;
            a.BillingPostalCode = Aw.ADDR_ZIPCODE__c ;           
            a.ADDR_FORMAT__c = Aw.ADDR_FORMAT__c ;          
            a.DUNS_NUM__c = Aw.DUNS_NUM__c ;          
            a.SMALL_BIZ_FLAG__c = Aw.SMALL_BIZ_FLAG__c ;          
            a.FORM_1099_FLAG__c = Aw.FORM_1099_FLAG__c ;          
         // a.DFLT_PYMT_TYPE_ID__c = Aw.DFLT_PYMT_TYPE_ID__c ;          
         // a.DFLT_PPAY_TYPE_ID__c = Aw.DFLT_PPAY_TYPE_ID__c ;          
         // a.TIN_VERIFY_ACTION__c = Aw.TIN_VERIFY_ACTION__c ;          
         // a.PVNT_NEW_SPNG__c= Aw.PVNT_NEW_SPNG__c ;          
         // a.XTRN_VEND_FL__c = Aw.XTRN_VEND_FL__c ;          
            a.VENDOR_TYPE_ID__c = Aw.VENDOR_TYPE_ID__c ;          
         // a.MISC_FLAG__c = Aw.MISC_FLAG__c ;          
            a.ACTIVE_STATUS__c = Aw.ACTIVE_STATUS__c ;          
            a.VENDOR_CD__c = Aw.VENDOR_CD__c ;          
            a.VENDOR_NM__c = Aw.VENDOR_NM__c ;          
            a.VEND_UNIQUE_ID__c = Aw.VEND_UNIQUE_ID__c ;          
            a.VENDOR_ADDR_CD__c = Aw.VENDOR_ADDR_CD__c ;
            if (!adminUsers.isEmpty()){
                a.ownerId = adminUsers[0].Id;
            }    
        }                      
              
      System.debug(' accounts ==> ' +  accounts );  
      update accounts ;
   }
           
           
   // Find Parent Accounts
   
   Account[] accounts = [ SELECT Id, Name, ParentId, Parent.Name 
                            FROM Account
                     /* Ram 01-18-2013        
                            WHERE Name IN : ParentAccountNames OR
                                  Name IN : LinkAccountNames ]; */
                            WHERE Name IN : LinkAccountNames ];     
          
    System.debug(' accounts  ==> '+  accounts  );        
          
  for ( Account a : accounts ) {
      AllAccs.put(a.Name,a) ;
      
  } 
          
  System.debug(' AllAccs ==> '+  AllAccs ); 
          
  for ( String s: LinkAccountNames  ) {
      if ( AllAccs.get(s) == null ) {
          Account a = new Account () ;
          
          a.Name = s ; 
           
          // a.Address__c =
          NewChildAccs.add(a); 
      }
  }
          
  System.debug(' NewChildAccs==> '+  NewChildAccs ); 
          
  insert NewChildAccs ;
  System.debug(' NewChildAccs==> '+  NewChildAccs ); 
          
  for ( Account a : NewChildAccs ) {
      AllAccs.put(a.Name,a) ; 
  } 
  
  /* Ram - 01/18/2013 Decided not to create parent Account.        
  for (  String s : ParentAccountNames ) {            
    if ( AllAccs.get(s)  == null  ) {
        Account a = new Account () ;
        a.Name = s  ;
        NewParentAccs.add(a);
        NewPrntAccNames.add(a.Name);
    }
  } 
           
  insert NewParentAccs ;    
           
  for ( Account a : NewParentAccs ) {
      AllAccs.put(a.Name,a) ; 
  } */
  
  System.debug(' AllAccs  ==> '+ AllAccs  );  
  System.debug(' AwardMap ==> '+  AwardMap ); 
  System.debug(' parent AllAccs ==> '+  AllAccs ); 
  // Link IM and Account  
  Map<String,String> MapOldAcc_New = New  Map<String,String> () ;
         
 for(Implementing_Mechanism__c LinkIMandAcc : Trigger.New){
    if( LinkIMandAcc.Award_Id__c != null ) {
        if( AwardMap.get(LinkIMandAcc.Award_Id__c).Vendor_NM__c != null ) {      
          String childAcc =     AwardMap.get(LinkIMandAcc.Award_Id__c).Vendor_NM__c   ;
          String parentAcc =     AwardMap.get(LinkIMandAcc.Award_Id__c).Vendor_cd__c   ;  
          System.debug(' childAcc parentAcc ==> '+  childAcc );  
          if( AllAccs.get(childAcc) != null ){
            LinkIMandAcc.Partner_Id__c = AllAccs.get(childAcc).Id  ;
          }
         
        //  LinkIMandAcc.Partner_Id__c = AllAccs.get(childAcc).Id  ;
       
         if( Trigger.isUpdate ){
            for ( Implementing_Mechanism__c LinkIMandAccOld : Trigger.Old ) {
                if ( LinkIMandAcc.Partner_Id__c != LinkIMandAccOld.Partner_Id__c ) {
                    MapOldAcc_New.put(LinkIMandAccOld.Partner_Id__c,LinkIMandAcc.Partner_Id__c);
                }
            }
         }
        }     
    } 
 } 
         
 // Move Contacts 
         
 Contact[] MoveConts = [ Select Id, AccountId FROM Contact 
                         WHERE AccountId IN : MapOldAcc_New.keyset() OR 
                          AccountId IN : MapOldAcc_New.Values() ] ;
         
 List<Contact> updateCons = New List<Contact> () ;
         
 System.debug(' MoveConts ==> '+ MoveConts ); 
         
 for ( Contact c: MoveConts ) {
     C.AccountId = MapOldAcc_New.get(C.AccountId) ;
 }
 
 //  update MoveConts ;
 System.debug(' MoveConts ==> '+ MoveConts );
 System.debug(' AllAccs  ==> '+ AllAccs  );  
 System.debug(' AwardMap ==> '+ AwardMap );
 System.debug(' MAPImid_Award ==> '+ MAPImid_Award );
 System.debug(' MAPChildaccs_Imid ==> '+ MAPChildaccs_Imid );
        
        
 for ( String s : LinkAccountNames ) {
     Account a = AllAccs.get(s) ;
     /* Ram - 01-18-2013
      a.parentId = AllAccs.get( MAPChildaccs_Parentaccs.get(s) ).Id ; */
     System.debug(' s ==>> '+ s);
         // System.debug(' MAPChildaccs_Imid ==> '+ AwardMap.get(MAPChildaccs_Imid.get(s)).Address__c );
         
     System.debug(' AwardMap ==> '+ MAPChildaccs_Imid.get(s));
     System.debug(' MAPImid_Award ==> '+ MAPImid_Award.get(MAPChildaccs_Imid.get(s)) );
     System.debug(' MAPChildaccs_Imid ==> '+ AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))) );
        
     if ( MAPChildaccs_Imid.get(s) != null && MAPImid_Award.get(MAPChildaccs_Imid.get(s))!= null
          &&  AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))) != null    ) {
         // Award__c aw = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))) ;
         // System.debug(' aw  ==> '+ aw  );         
          
            a.ADDR_LINE_1__c = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).ADDR_LINE_1__c ;
            a.ADDR_LINE_2__c = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).ADDR_LINE_2__c ;
            a.BillingStreet = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).ADDR_LINE_1__c + '' + AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).ADDR_LINE_2__c ;
            a.CCR_REGI_STATUS__c = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).CCR_REGI_STATUS__c ;
            a.ADDR_CITY__c = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).ADDR_CITY__c ;
            a.BillingCity = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).ADDR_CITY__c ;
            a.ADDR_STATE__c= AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).ADDR_STATE__c ;
            a.BillingState = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).ADDR_STATE__c ;
     
            a.ADDR_COUNTRY__c = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).ADDR_COUNTRY__c ;
            a.BillingCountry = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).ADDR_COUNTRY__c ;
      
            a.ADDR_ZIPCODE__c = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).ADDR_ZIPCODE__c ;
            a.BillingPostalCode =  AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).ADDR_ZIPCODE__c ;
      
            a.ADDR_FORMAT__c = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).ADDR_FORMAT__c ;
      
            a.DUNS_NUM__c = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).DUNS_NUM__c ;
      
            a.SMALL_BIZ_FLAG__c = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).SMALL_BIZ_FLAG__c ;
      
            a.FORM_1099_FLAG__c = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).FORM_1099_FLAG__c ;
      
        //  a.DFLT_PYMT_TYPE_ID__c = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).DFLT_PYMT_TYPE_ID__c ;
      
        //  a.DFLT_PPAY_TYPE_ID__c = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).DFLT_PPAY_TYPE_ID__c ;
      
        //  a.TIN_VERIFY_ACTION__c = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).TIN_VERIFY_ACTION__c ;
      
        //  a.PVNT_NEW_SPNG__c= AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).PVNT_NEW_SPNG__c ;
      
        //  a.XTRN_VEND_FL__c = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).XTRN_VEND_FL__c ;
      
            a.VENDOR_TYPE_ID__c = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).VENDOR_TYPE_ID__c ;
      
        //  a.MISC_FLAG__c = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).MISC_FLAG__c ;
      
            a.ACTIVE_STATUS__c = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).ACTIVE_STATUS__c ;
      
            a.VENDOR_CD__c = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).VENDOR_CD__c ;
      
            a.VENDOR_NM__c = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).VENDOR_NM__c ;
      
            a.VEND_UNIQUE_ID__c = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).VEND_UNIQUE_ID__c ;
      
            a.VENDOR_ADDR_CD__c = AwardMap.get(MAPImid_Award.get(MAPChildaccs_Imid.get(s))).VENDOR_ADDR_CD__c ;      
            if (!adminUsers.isEmpty()){
                a.ownerId = adminUsers[0].Id;
            }
            
      }
      updateChildAccs.add(a);
      System.debug(' a ==> '+ a );  
    }
    
    System.debug(' updateChildAccs  ==> '+ updateChildAccs  );
    update updateChildAccs ;
     
 // New  
  if( Trigger.isInsert ){    
    Set<String> accsId = New Set<String> () ;    
    for(Implementing_Mechanism__c IM : Trigger.New) {
        accsId.add( IM.Partner_Id__c );
    }       
    
    MAP<String,Account> acc_details = NEW MAP<String,Account> ( 
                            [Select  id,VEND_UNIQUE_ID__c,
                                    ADDR_LINE_1__c,ADDR_LINE_2__c,CCR_REGI_STATUS__c,ADDR_CITY__c,
                                    ADDR_COUNTRY__c,ADDR_STATE__c,ADDR_ZIPCODE__c,ADDR_FORMAT__c,DUNS_NUM__c,
                                    SMALL_BIZ_FLAG__c,FORM_1099_FLAG__c,
                                    //DFLT_PYMT_TYPE_ID__c,DFLT_PPAY_TYPE_ID__c,
                                    //TIN_VERIFY_ACTION__c,   PVNT_NEW_SPNG__c,XTRN_VEND_FL__c,
                                    VENDOR_TYPE_ID__c,
                                    // MISC_FLAG__c,
                                    ACTIVE_STATUS__c,VENDOR_CD__c,VENDOR_NM__c,VENDOR_ADDR_CD__c
                             FROM Account WHERE ID in: accsId ] ) ;
    
    List<Account> updateAddress = New List<Account> () ;
    for ( Implementing_Mechanism__c IM : Trigger.New  ) {
    if ( AwardMap.get(IM.Award_Id__c) != null && acc_details.get(IM.Partner_Id__c) != null ) {
       Award__c aw = AwardMap.get(IM.Award_Id__c) ;
      Account a =  acc_details.get(IM.Partner_Id__c) ;
   // If(AwardMap.get(IM.Award_Id__c) !=null){
    //  If(IM.Partner_Id__c!=null){
       a.ADDR_LINE_1__c = aw.ADDR_LINE_1__c ;
       a.ADDR_LINE_2__c = aw.ADDR_LINE_2__c ;
       
      a.CCR_REGI_STATUS__c = aw.CCR_REGI_STATUS__c ;
       a.ADDR_CITY__c = aw.ADDR_CITY__c ;
        a.ADDR_STATE__c= aw.ADDR_STATE__c ;
     
      a.ADDR_COUNTRY__c = aw.ADDR_COUNTRY__c ;
      
      a.ADDR_ZIPCODE__c =aw.ADDR_ZIPCODE__c ;
      
      a.BillingStreet = Aw.ADDR_LINE_1__c  + ' ' + Aw.ADDR_LINE_2__c ;
          
          
           a.BillingCity = Aw.ADDR_CITY__c ;
          
           a.BillingState = Aw.ADDR_STATE__c ;         
          
           a.BillingCountry =  Aw.ADDR_COUNTRY__c ;         
          
           a.BillingPostalCode = Aw.ADDR_ZIPCODE__c ;
       
      a.ADDR_FORMAT__c = aw.ADDR_FORMAT__c ;
      
       a.DUNS_NUM__c = aw.DUNS_NUM__c ;
      
       a.SMALL_BIZ_FLAG__c = aw.SMALL_BIZ_FLAG__c ;
      
      a.FORM_1099_FLAG__c = aw.FORM_1099_FLAG__c ;
      
      // a.DFLT_PYMT_TYPE_ID__c = aw.DFLT_PYMT_TYPE_ID__c ;
      
     //  a.DFLT_PPAY_TYPE_ID__c = aw.DFLT_PPAY_TYPE_ID__c ;
      
     // a.TIN_VERIFY_ACTION__c =aw.TIN_VERIFY_ACTION__c ;
      
     //   a.PVNT_NEW_SPNG__c= aw.PVNT_NEW_SPNG__c ;
      
     //  a.XTRN_VEND_FL__c = aw.XTRN_VEND_FL__c ;
      
      a.VENDOR_TYPE_ID__c = aw.VENDOR_TYPE_ID__c ;
      
    //  a.MISC_FLAG__c = aw.MISC_FLAG__c ;
      
       a.ACTIVE_STATUS__c = aw.ACTIVE_STATUS__c ;
      
      a.VENDOR_CD__c = aw.VENDOR_CD__c ;
      
      a.VENDOR_NM__c = aw.VENDOR_NM__c ;
      
      a.VEND_UNIQUE_ID__c = aw.VEND_UNIQUE_ID__c ;
      
      a.VENDOR_ADDR_CD__c = aw.VENDOR_ADDR_CD__c ;
       if (!adminUsers.isEmpty()){
                a.ownerId = adminUsers[0].Id;
            }
     updateAddress.add(a);
      } 
         
    }
    update updateAddress ;
    
  }  
      
 }
}