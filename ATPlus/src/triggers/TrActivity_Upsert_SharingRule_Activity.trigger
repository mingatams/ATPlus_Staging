trigger TrActivity_Upsert_SharingRule_Activity on Activity__c (after delete, after insert, after update) {
   
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
   // String flag='no';
    String alreadyExists='no';

   
  
    
    list<Activity__Share> ActivityShareList = new list<Activity__Share>();
    public list <Activity__Share> mainActivityShareList {get;set;}
    Activity__Share ssShare = new Activity__Share(); 
    Activity__c thisstory = new Activity__c();   
    
    public list<Contact> Contacts {get;set;}      
    public list<User> ContactUser {get;set;}  
    public list<User> PrimaryPartners {get;set;}   
        
    if((trigger.isInsert) || (trigger.isUpdate)){
     for(Activity__c sstory:trigger.new){           
       MechID=sstory.ImpMech_Id__c;
       RecordID=sstory.ID;  
       thisstory=sstory;       
      }
    }
       
        
    if((trigger.isDelete)){
     for(Activity__c sstory:trigger.old){           
       MechID=sstory.ImpMech_Id__c;
       RecordID=sstory.ID;        
       thisstory=sstory; 
       }
    }
    
  //  system.debug('1~~~~~~~~~~~~~MechID~~~~~~~~~~~~~~~~~'+MechID+' '+MechID.ImpMech_Name__c);
   
          
     if( MechID!=null){
          list<Activity__c> OrganizationIDList= [   Select id, story.ImpMech_Id__r.Partner_User_1__c, 
          story.ImpMech_Id__r.Partner_User_1__r.isActive, story.ImpMech_Id__r.Partner_User_2__c, story.ImpMech_Id__r.Partner_User_2__r.isActive, story.ImpMech_Id__r.Partner_User_3__c, story.ImpMech_Id__r.Partner_User_3__r.isActive, story.ImpMech_Id__r.Partner_User_4__c, story.ImpMech_Id__r.Partner_User_4__r.isActive, story.ImpMech_Id__r.Partner_Id__c, story.ImpMech_Id__r.Name From Activity__c story where id=:RecordID ];
          for(Activity__c sst:OrganizationIDList){  
          OrganizationID=sst.ImpMech_Id__r.Partner_Id__c;          
          OrganizationName= sst.ImpMech_Id__r.Name;       
        
       
         system.debug('3~~~~~~~~~~~~~OrganizationID~~~~~~~~~~~~~~~~~'+OrganizationID+' IM Name :'+OrganizationName);
         Partner_1=sst.ImpMech_Id__r.Partner_User_1__c;    
         system.debug('3~~~~~~~~~~~~~Partner_1~~~~~~~~~~~~~~~~~'+Partner_1);
         Partner_2=sst.ImpMech_Id__r.Partner_User_2__c;    
         system.debug('3~~~~~~~~~~~~Partner_2~~~~~~~~~~~~~~~~~'+Partner_2);
         Partner_3=sst.ImpMech_Id__r.Partner_User_3__c;    
         system.debug('3~~~~~~~~~~~~~Partner_3~~~~~~~~~~~~~~~~~'+Partner_3);
         Partner_4=sst.ImpMech_Id__r.Partner_User_4__c;   
         system.debug('3~~~~~~~~~~~~~Partner_4~~~~~~~~~~~~~~~~~'+Partner_4); 
         
          }
      PrimaryPartners = [ Select Id, isActive, Name from User where (isActive=true and ( Id =:Partner_1 Or Id =:Partner_2 Or Id =:Partner_3 Or Id =:Partner_4)) ];      
      system.debug('~~~~~~~~~~~~~Number of PrimaryPartners~~~~~~~~~~~~~~~~~'+String.valueOf(PrimaryPartners.size()));   
      
      }
        
   
        
    
  /*  if(OrganizationID!=null){
   
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
    
     mainActivityShareList = [   Select s.UserOrGroupId, s.RowCause, s.ParentId, s.LastModifiedDate, s.LastModifiedById, s.IsDeleted, s.Id, s.AccessLevel 
                                    From Activity__Share s where (s.ParentId=:RecordID)  
                                ];   
    system.debug('~~~~~~~~~~~~~amount of shares before deletions ~~~~~~~~~~~~~~~~~'+String.valueOf(mainActivityShareList.size()));

   
    mainActivityShareList = [   Select s.UserOrGroupId, s.RowCause, s.ParentId, s.LastModifiedDate, s.LastModifiedById, s.IsDeleted, s.Id, s.AccessLevel 
                                    From Activity__Share s where (s.ParentId=:RecordID AND s.RowCause='Manual')  
                                ];
    system.debug('~~~~~~~~~~~~~deleted~~~~~~~~~~~~~~~~~'+String.valueOf(mainActivityShareList.size()));
    
    if(mainActivityShareList.size()>0){
                    delete mainActivityShareList;
    }  
    mainActivityShareList= new list<Activity__Share>();
    mainActivityShareList = [   Select s.UserOrGroupId, s.RowCause, s.ParentId, s.LastModifiedDate, s.LastModifiedById, s.IsDeleted, s.Id, s.AccessLevel 
                                    From Activity__Share s where (s.ParentId=:RecordID)  
                                ];   
    if(mainActivityShareList.size()>0){
       for(Activity__Share sid:mainActivityShareList )    {
          system.debug('~~~~~~~~~~~~~User Id still in share list after deletion~~~~~~~'+sid.UserOrGroupId+' '+sid.RowCause+'  '+ sid.AccessLevel );
            
          }                    
    }
                                
    system.debug('~~~~~~~~~~~~~still left~~~~~~~~~~~~~~~~~'+String.valueOf(mainActivityShareList.size()));


    //Insert
    if((trigger.isInsert) || (trigger.isUpdate)){
     //   for(Activity__c ss:trigger.new){           
          
   
            if(MechID != null){                                 
                                                               
                if(OrganizationID != null){
                  if(primaryPartners.size()>0){ 
                   for(User PrimaryUsID:primaryPartners){      
                      system.debug('~~~~~~~~~~~~~Share~~~~~~~~~~~~~~~~~'+PrimaryUsID.id+' ' +PrimaryUsID.Name);                            
                      AddShare(PrimaryUsID.id, 'Edit', RecordID);                    
                     }
                   }
               /*    if(Contacts.size()>0){
                   if(ContactUser.size()>0){                 
                   for(User UsID:ContactUser) {            
                      system.debug('~~~~~~~~~~~~~Partner~~~~~~~~~~~~~~~~~'+UsID);                    
                      AddShare(UsID.id, 'Edit', RecordID);      
                    }
                   }
                
                 }   */                                   
                   if(ActivityShareList.size()>0){  
                     for(Activity__Share thisfs: ActivityShareList ){
                     system.debug('~~~~~~~~~~~~~Sharelist has value~~~~~~~~~~~~~~~~~'+thisfs.UserOrGroupId);
                    }
                   insert ActivityShareList; 
                   system.debug('~~~~~~~~~~~~~inserted~~~~~~~~~~~~~~~~~'+String.valueOf(ActivityShareList.size()));
                   }    
               }  
               
               
            }
      //}
    }
           private void AddShare(String UserID, String userRight, String RecordParentID){
                    alreadyExists='no';
                    system.debug('~~~~~~~~~~~~~function starts~~~~~~~~~~~~~~~'+UserID);
                  
                    for(Activity__Share thisfs: ActivityShareList ){
                     system.debug('~~~~~~~~~~~~~ manual sharelist has user as ~~~~~~~~~~~~~~~~~'+thisfs.UserOrGroupId + ' with rights '+thisfs.AccessLevel);                   
                      if(UserID==thisfs.UserOrGroupId){
                        alreadyExists='yes';
                        system.debug('~~~~~~~~~~~~~User already exists in manual sharelist~~~~~~~~~~~~~~~~~'+thisfs.UserOrGroupId );                   
                        break;}
                     }
                    
                    if(alreadyExists=='no'){
                      for(Activity__Share tob: mainActivityShareList ){
                          system.debug('~~~~~~~~~~~~~Owner/rule sharelist has user as ~~~~~~~~~~~~~~~~~'+tob.UserOrGroupId );                   
                          if(UserID==tob.UserOrGroupId){
                             alreadyExists='yes'; 
                             system.debug('~~~~~~~~~~~~~User already exists in Sharing Rules/Owner as ~~~~~~~~~~~~~~~~~'+tob.UserOrGroupId + ' with rights '+tob.AccessLevel );                   
                             break;}
                       }
                     }
                     if(alreadyExists=='no'){
                        system.debug('~~~~~~~~~~~~~we are going to add value~~~~~~~~~~~~~~~~~'+UserID);
                        ssShare = new Activity__Share(ParentID=RecordParentID, AccessLevel = userRight, RowCause ='Manual', UserOrGroupId=UserID);
                        ActivityShareList.add(ssShare);
                    } 
 
                                         
      }
   
}