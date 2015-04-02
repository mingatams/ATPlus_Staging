trigger TrOrgUnitIndicator_Upsert_SharingRule on OrgUnit_Indicator__c (after delete, after insert, after update) {

    /*
        1.  Read Organization_Indicator__c Record to get IM Reference ID.
        2.  Based on IM reference ID get the Implementing Partner Reference and Implementing Partner Users.
        3.  Based on Implementing Partner Reference in Step 2 get list of contacts.
        4.  Get Active User Records for both primary partner users and contact users.
        5.  Prepare List of Manual Shares on Organization_Indicator__c ID from step 1.
        6.  Prepare list of new ORganization Indicator shares to be added and list of Organization Indicator shares to be deleted based on two sets of users and existing project
            share records.  
    */
    
    String OrganizationID='';
    String OrganizationName='';
    String MechID ='';
    Account primaryPartner;
    String contactIdsString = '';    
    String RecordID='';     
    String Partner_1='';    
    String Partner_2='';    
    String Partner_3='';    
    String Partner_4='';     
  
    Map<Id,OrgUnit_Indicator__c> recordsMap = new Map<Id,OrgUnit_Indicator__c>();
    list<Orgunit_Indicator__Share> orgIndicatorShareList = new list<Orgunit_Indicator__Share>();    
    List<Orgunit_Indicator__Share> ExistingSharesList = new List<Orgunit_Indicator__Share>();
    Map<String,Orgunit_Indicator__Share> ExistingSharesMap = new Map<String,Orgunit_Indicator__Share>();
    List<Orgunit_Indicator__Share> deleteShareList = new List<Orgunit_Indicator__Share>();
    List<Orgunit_Indicator__Share> insertShareList = new List<Orgunit_Indicator__Share>();
    set<String> insertShareKeys = new set<String>();
    Orgunit_Indicator__Share orgUnitIndicatorShare = new Orgunit_Indicator__Share(); 
    
    Map<Id,List<Id>> userListByIM = new Map<Id, List<Id>>();
    List<Id> allPartners = new List<Id>();
    
    
    List<Contact> Contacts = new List<Contact>();
    
    List<User> ContactUser = new List<User>();
    Map<ID,User> PrimaryPartners = new Map<ID,User>();
        
    if((trigger.isInsert) || (trigger.isUpdate)){
        OrgUnitIndicatorTriggerHelper.ReportingPeriodFlags(Trigger.newMap);
        for(Orgunit_Indicator__c pil:trigger.new){           
            MechID= pil.Implementing_Mechanism_Id__c;
            RecordID=pil.Id;
            if (pil.Implementing_Mechanism_Id__c != null) 
                recordsMap.put(pil.Id,pil); 
           // thisProjectIM=pil;       
        }
    }      
        
    if((trigger.isDelete)){
        OrgUnitIndicatorTriggerHelper.ReportingPeriodFlagsAfterOrgIndicatorDelete(Trigger.oldMap);
        for(Orgunit_Indicator__c pil:trigger.old){           
            MechID= pil.Implementing_Mechanism_Id__c;
            RecordID=pil.Id;
            if (pil.Implementing_Mechanism_Id__c != null) 
                recordsMap.put(pil.Id,pil);  
           // thisProjectIM=pil;       
        }
    }
    
  //  system.debug('1~~~~~~~~~~~~~MechID~~~~~~~~~~~~~~~~~'+MechID+' '+MechID.ImpMech_Name__c);
   
   if(!ApplicationConstants.bypassOrgUnitIndicatorUpsertShare){       
    if( !recordsMap.isEmpty()){
        System.debug('Before Org Details:' +RecordID);
        System.debug('Before Org Details:' +MechID);
        list<OrgUnit_Indicator__c> OrganizationIDList= [   Select id,pil.Implementing_Mechanism_Id__c, pil.Implementing_Mechanism_Id__r.Partner_User_1__c, 
                                                                pil.Implementing_Mechanism_Id__r.Partner_User_1__r.isActive, 
                                                                pil.Implementing_Mechanism_Id__r.Partner_User_2__c, 
                                                                pil.Implementing_Mechanism_Id__r.Partner_User_2__r.isActive, 
                                                                pil.Implementing_Mechanism_Id__r.Partner_User_3__c, 
                                                                pil.Implementing_Mechanism_Id__r.Partner_User_3__r.isActive, 
                                                                pil.Implementing_Mechanism_Id__r.Partner_User_4__c, 
                                                                pil.Implementing_Mechanism_Id__r.Partner_User_4__r.isActive, 
                                                                pil.Implementing_Mechanism_Id__r.Partner_Id__c, 
                                                                pil.Implementing_Mechanism_Id__r.Name 
                                                        From OrgUnit_Indicator__c pil where id in :recordsMap.keySet()];
          
          for(OrgUnit_Indicator__c pil:OrganizationIDList){  
            //OrganizationID=pil.Implementing_Mechanism_Id__r.Partner_Id__c;          
            //OrganizationName= pil.Implementing_Mechanism_Id__r.Name;
            List<Id> orgPartners = new List<Id>();
            if (pil.Implementing_Mechanism_Id__r.Partner_User_1__c != null)
                orgPartners.add(pil.Implementing_Mechanism_Id__r.Partner_User_1__c);
            
            if (pil.Implementing_Mechanism_Id__r.Partner_User_2__c != null)
                orgPartners.add(pil.Implementing_Mechanism_Id__r.Partner_User_2__c);
                
            if (pil.Implementing_Mechanism_Id__r.Partner_User_3__c != null)
                orgPartners.add(pil.Implementing_Mechanism_Id__r.Partner_User_3__c);
                
            if (pil.Implementing_Mechanism_Id__r.Partner_User_4__c != null)
                orgPartners.add(pil.Implementing_Mechanism_Id__r.Partner_User_4__c);            
            
         //   system.debug('3~~~~~~~~~~~~~OrganizationID~~~~~~~~~~~~~~~~~'+OrganizationID+' IM Name :'+OrganizationName);
         //   Partner_1=pil.Implementing_Mechanism_Id__r.Partner_User_1__c;    
         //   system.debug('3~~~~~~~~~~~~~Partner_1~~~~~~~~~~~~~~~~~'+Partner_1);
         //   Partner_2=pil.Implementing_Mechanism_Id__r.Partner_User_2__c;    
         //   system.debug('3~~~~~~~~~~~~Partner_2~~~~~~~~~~~~~~~~~'+Partner_2);
         //   Partner_3=pil.Implementing_Mechanism_Id__r.Partner_User_3__c;    
         //   system.debug('3~~~~~~~~~~~~~Partner_3~~~~~~~~~~~~~~~~~'+Partner_3);
         //   Partner_4=pil.Implementing_Mechanism_Id__r.Partner_User_4__c;   
         //   system.debug('3~~~~~~~~~~~~~Partner_4~~~~~~~~~~~~~~~~~'+Partner_4); 
             if (!orgPartners.isEmpty()){
                userListByIM.put(pil.Implementing_Mechanism_Id__c,orgPartners); 
                allPartners.addAll(orgPartners);
             }
          }
          
          PrimaryPartners = new Map<Id,User>([Select Id, isActive, Name from User where (isActive=true and ( Id in :allPartners)) ]);
          system.debug('~~~~~~~~~~~~~Number of PrimaryPartners~~~~~~~~~~~~~~~~~'+String.valueOf(PrimaryPartners.size()));
    }
     
   /* if(OrganizationID!=null){   
        Contacts = [   Select id From Contact where AccountId =: OrganizationID  ];
        system.debug('~~~~~~~~~~~~~Number of contacts ~~~~~~~~~~~~~~~~~'+String.valueOf(Contacts.size()));   
        if(Contacts.size()>0){
            for(Contact c: Contacts){
                contactIdsString += '\''+c.Id+'\'';
                contactIdsString += ',';
            }
            contactIdsString = contactIdsString.substring(0,contactIdsString.length()-1);        
            contactIdsString= 'Select Id, isActive, Name from User where isActive=true and ContactId IN ('+contactIdsString+')';           
            ContactUser = Database.query(contactIdsString);           
            system.debug('~~~~~~~~~~~~~Number of contacts users~~~~~~~~~~~~~~~~~'+String.valueOf(ContactUser.size())+ ' users: '+contactIdsString );
        }
    
    } */
    
    
    
   
    ExistingSharesList = [Select p.UserOrGroupId, p.RowCause, p.ParentId, p.LastModifiedDate, p.LastModifiedById, p.IsDeleted, p.Id, p.AccessLevel 
                                    From OrgUnit_Indicator__Share p where (p.ParentId=:RecordID AND p.RowCause='Manual')];
    system.debug('~~~~~~~~~~~~~deleted~~~~~~~~~~~~~~~~~'+String.valueOf(ExistingSharesList.size()));
    for(OrgUnit_Indicator__Share ps: ExistingSharesList){
        ExistingSharesMap.put((String)ps.ParentID+(String)ps.UserOrGroupId, ps);
    }
    
    //Insert
    if((trigger.isInsert) || (trigger.isUpdate)){
        if(!recordsMap.isEmpty()){                                    
            for(ID orgIndId: recordsMap.keySet()){
                OrgUnit_Indicator__c oIndicator = recordsMap.get(orgIndId);
                if (userListByIM.containsKey(oIndicator.Implementing_Mechanism_Id__c)){
                    for(Id uId: userListByIM.get(oIndicator.Implementing_Mechanism_Id__c)){
                        AddShare(uId, 'Edit', orgIndId);
                        AddShare(uId, 'Edit', oIndicator.Organization_Indicator_Id__c);
                    }
                }
              //  if(primaryPartners.size()>0){ 
              //      for(Id pUserID: primaryPartners.keySet()){      
                        //system.debug('~~~~~~~~~~~~~Share~~~~~~~~~~~~~~~~~'+pUserID+' ' +pUserID.Name);                            
              //          AddShare(pUserID, 'Edit', RecordID);                    
              //      }
              //  }
                
           
            }  
        }
    }
    
    for(String eShareKey : ExistingSharesMap.keySet()){
        if (insertShareKeys.contains(eShareKey)){
            deleteShareList.add(ExistingSharesMap.get(eShareKey));
        }   
    }
    
    if (!deleteShareList.isEmpty()){
        delete deleteShareList; 
    }            
    
    
    if (!insertShareList.isEmpty()){
        insert insertShareList; 
    }
     
   }
           
    private void AddShare(String UserID, String userRight, String RecordParentID){      
        system.debug('~~~~~~~~~~~~~function starts~~~~~~~~~~~~~~~'+UserID);
        if (!ExistingSharesMap.containsKey(RecordParentID+UserID)){
            orgUnitIndicatorShare = new OrgUnit_Indicator__Share(ParentID=RecordParentID, AccessLevel = userRight, RowCause ='Manual', UserOrGroupId=UserID);
            insertShareList.add(orgUnitIndicatorShare);
            insertShareKeys.add(RecordParentID+UserID);
        }
    }
}