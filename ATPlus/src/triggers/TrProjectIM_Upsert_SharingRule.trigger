trigger TrProjectIM_Upsert_SharingRule on Public_IM_Link__c (after delete, after insert, after update) {

    /*
        1.  Read Public_IM_Link__c Record to get IM Reference ID and Project Reference ID.
        2.  Based on IM reference ID get the Implementing Partner Reference and Implementing Partner Users.
        3.  Based on Implementing Partner Reference in Step 2 get list of contacts.
        4.  Get Active User Records for both primary partner users and contact users.
        5.  Prepare List of Manual Shares on Project Reference ID from step 1.
        6.  Prepare list of new project shares to be added and list of project shares to be deleted based on two sets of users and existing project
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
  
    
    list<Project__Share> projectShareList = new list<Project__Share>();    
    List<Project__Share> ExistingSharesList = new List<Project__Share>();
    Map<String,Project__Share> ExistingSharesMap = new Map<String,Project__Share>();
    List<Project__Share> deleteShareList = new List<Project__Share>();
    List<Project__Share> insertShareList = new List<Project__Share>();
    set<String> insertShareKeys = new set<String>();
    Project__Share projectShare = new Project__Share(); 
    Public_IM_Link__c thisProjectIM = new Public_IM_Link__c();   
    
    List<Contact> Contacts = new List<Contact>();
    
    List<User> ContactUser = new List<User>();
    Map<ID,User> PrimaryPartners = new Map<ID,User>();
        
    if((trigger.isInsert) || (trigger.isUpdate)){
        for(Public_IM_Link__c pil:trigger.new){           
            MechID= pil.Implementing_Mechanism_Number__c;
            RecordID=pil.Project_Code__c;  
            thisProjectIM=pil;       
        }
    }      
        
    if((trigger.isDelete)){
        for(Public_IM_Link__c pil:trigger.old){           
            MechID= pil.Implementing_Mechanism_Number__c;
            RecordID=pil.Project_Code__c;  
            thisProjectIM=pil;       
        }
    }
    
  //  system.debug('1~~~~~~~~~~~~~MechID~~~~~~~~~~~~~~~~~'+MechID+' '+MechID.ImpMech_Name__c);
   
          
    if( MechID!=null){
    	System.debug('Before Org Details:' +RecordID);
    	System.debug('Before Org Details:' +MechID);
        list<Public_IM_Link__c> OrganizationIDList= [   Select id, pil.Implementing_Mechanism_Number__r.Partner_User_1__c, 
                                                                pil.Implementing_Mechanism_Number__r.Partner_User_1__r.isActive, 
                                                                pil.Implementing_Mechanism_Number__r.Partner_User_2__c, 
                                                                pil.Implementing_Mechanism_Number__r.Partner_User_2__r.isActive, 
                                                                pil.Implementing_Mechanism_Number__r.Partner_User_3__c, 
                                                                pil.Implementing_Mechanism_Number__r.Partner_User_3__r.isActive, 
                                                                pil.Implementing_Mechanism_Number__r.Partner_User_4__c, 
                                                                pil.Implementing_Mechanism_Number__r.Partner_User_4__r.isActive, 
                                                                pil.Implementing_Mechanism_Number__r.Partner_Id__c, 
                                                                pil.Implementing_Mechanism_Number__r.Name 
                                                        From Public_IM_Link__c pil where Project_Code__c =:RecordID Or Implementing_Mechanism_Number__c =:MechID];
          
          for(Public_IM_Link__c pil:OrganizationIDList){  
            OrganizationID=pil.Implementing_Mechanism_Number__r.Partner_Id__c;          
            OrganizationName= pil.Implementing_Mechanism_Number__r.Name;
            
            system.debug('3~~~~~~~~~~~~~OrganizationID~~~~~~~~~~~~~~~~~'+OrganizationID+' IM Name :'+OrganizationName);
            Partner_1=pil.Implementing_Mechanism_Number__r.Partner_User_1__c;    
            system.debug('3~~~~~~~~~~~~~Partner_1~~~~~~~~~~~~~~~~~'+Partner_1);
            Partner_2=pil.Implementing_Mechanism_Number__r.Partner_User_2__c;    
            system.debug('3~~~~~~~~~~~~Partner_2~~~~~~~~~~~~~~~~~'+Partner_2);
            Partner_3=pil.Implementing_Mechanism_Number__r.Partner_User_3__c;    
            system.debug('3~~~~~~~~~~~~~Partner_3~~~~~~~~~~~~~~~~~'+Partner_3);
            Partner_4=pil.Implementing_Mechanism_Number__r.Partner_User_4__c;   
            system.debug('3~~~~~~~~~~~~~Partner_4~~~~~~~~~~~~~~~~~'+Partner_4); 
         
          }
          
          PrimaryPartners = new Map<Id,User>([Select Id, isActive, Name from User where (isActive=true and ( Id =:Partner_1 Or Id =:Partner_2 Or Id =:Partner_3 Or Id =:Partner_4)) ]);
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
                                    From Project__Share p where (p.ParentId=:RecordID AND p.RowCause='Manual')];
    system.debug('~~~~~~~~~~~~~deleted~~~~~~~~~~~~~~~~~'+String.valueOf(ExistingSharesList.size()));
    for(Project__Share ps: ExistingSharesList){
        ExistingSharesMap.put((String)ps.ParentID+(String)ps.UserOrGroupId, ps);
    }
    
    //Insert
    if((trigger.isInsert) || (trigger.isUpdate)){
        if(MechID != null){                                    
            if(OrganizationID != null){
                if(primaryPartners.size()>0){ 
                    for(Id pUserID: primaryPartners.keySet()){      
                        //system.debug('~~~~~~~~~~~~~Share~~~~~~~~~~~~~~~~~'+pUserID+' ' +pUserID.Name);                            
                        AddShare(pUserID, 'Read', RecordID);                    
                    }
                }
                
           /*   if(Contacts.size()>0){
                    if(ContactUser.size()>0){                 
                        for(User cUserID:ContactUser) {  
                            if (!primaryPartners.containsKey(cUserID.Id)){
                                system.debug('~~~~~~~~~~~~~Partner~~~~~~~~~~~~~~~~~'+cUserID.Id);                    
                                AddShare(cUserID.id, 'Read', RecordID);     
                            }   
                        }
                    }                
                }  */
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
     
   
           
    private void AddShare(String UserID, String userRight, String RecordParentID){      
        system.debug('~~~~~~~~~~~~~function starts~~~~~~~~~~~~~~~'+UserID);
        if (!ExistingSharesMap.containsKey(RecordParentID+UserID)){
            projectShare = new Project__Share(ParentID=RecordParentID, AccessLevel = userRight, RowCause ='Manual', UserOrGroupId=UserID);
            insertShareList.add(projectShare);
            insertShareKeys.add(RecordParentID+UserID);
        }
    }
}