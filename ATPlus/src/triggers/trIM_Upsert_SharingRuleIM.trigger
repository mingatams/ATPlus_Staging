trigger trIM_Upsert_SharingRuleIM on Implementing_Mechanism__c  (after insert, after update) {
    String ssString = '';
    string RecordId='';    
    String OrganizationID=''; 
    String OrganizationName=''; 
    String MechID ='';    
    Account primaryPartner;  
    String contactIdsString = '';   
    String ActivityIdsString='';
    String ActivityIdsString1='';
    String ActivityIdsString2='';
    String ActivityShareIdsString1='';
    String ActivityShareIdsString2='';
    String Manual='\''+'Manual'+'\'';   
    String alreadyExists='';
    String thisTriggerType='';    
    String Objectname='';
    String orgUnitID = '';
    
    String Partner_1='';      
    String Partner_2='';      
    String Partner_3='';        
    String Partner_4='';  
    String COTR='';
    String AOTR='';
    
   
       
    Implementing_Mechanism__c impMech = new Implementing_Mechanism__c();     
       
    Implementing_Mechanism__Share ImShare = new Implementing_Mechanism__Share();
    list<Implementing_Mechanism__Share> implementingMechanismShareListAll = new list<Implementing_Mechanism__Share>();
    list<Implementing_Mechanism__Share> implementingMechanismShareList = new list<Implementing_Mechanism__Share>();
    
    Activity__Share acShare = new Activity__Share(); 
    list<Activity__c> activityList = new list<Activity__c>();
    list<Activity__Share> activityShareList = new list<Activity__Share>();
    list<Activity__Share> activityShareListAll = new list<Activity__Share>();
     
    OrgUnit__Share orgShare = new OrgUnit__Share(); 
    list<OrgUnit__c> orgUnitList = new list<OrgUnit__c>();
    list<OrgUnit__Share> orgUnitShareList = new list<OrgUnit__Share>();
    list<OrgUnit__Share> orgUnitShareListAll = new list<OrgUnit__Share>();
    
    Reporting_Period__Share rPeriodShare = new Reporting_Period__Share(); 
    list<Reporting_Period__c> rPeriodList = new list<Reporting_Period__c>();
    list<Reporting_Period__Share> rPeriodShareList = new list<Reporting_Period__Share>();
    list<Reporting_Period__Share> rPeriodShareListAll = new list<Reporting_Period__Share>();
    
    
    Project__Share projectShare = new Project__Share(); 
    list<Public_IM_Link__c> projectIMList = new list<Public_IM_Link__c>();
    list<Project__Share> projectShareList = new list<Project__Share>();
    list<Project__Share> projectShareListAll = new list<Project__Share>();
    
    OrgUnit_Indicator__Share orgUnitIndicatorShare = new OrgUnit_Indicator__Share(); 
    list<OrgUnit_Indicator__c> orgUnitIndicatorList = new list<OrgUnit_Indicator__c>();
    list<OrgUnit_Indicator__Share> orgUnitIndicatorShareList = new list<OrgUnit_Indicator__Share>();
    list<OrgUnit_Indicator__Share> orgUnitIndicatorShareListAll = new list<OrgUnit_Indicator__Share>();
    list<OrgUnit_Indicator__Share> orgUnitIndicatorMasterShareList = new list<OrgUnit_Indicator__Share>();
    list<OrgUnit_Indicator__Share> orgUnitIndicatorMasterShareListAll = new list<OrgUnit_Indicator__Share>();    
        
    public list<User> PrimaryPartners {get;set;}   
    public list<Contact> Contacts {get;set;}      
    public list<User> ContactUser {get;set;}  
    public list<User> COTRS {get;set;}   
    public set<Id> uniquePartnerIds = new set<id>();
    
    clsReportingPeriod repPrd=new clsReportingPeriod();
    
  /*  List<Reporting_Period__c> rPeriodsUpd = new List<Reporting_Period__c>();
    List<Reporting_Period__c> rPeriods = new List<Reporting_Period__c>([Select Id, AOR__c, COR__c, 
                                        Alternate_AOR__c, Alternate_COR__c 
                                        From Reporting_Period__c where Implementing_Mechanism_Id__c = :trigger.new[0].Id]);
    
    for(Reporting_Period__c rPeriod: rPeriods){        
        
        rPeriod.COR__c = trigger.new[0].COR__c;
        if (trigger.new[0].AOR__c != null){
            rPeriod.AOR__c = trigger.new[0].AOR__c;
        } else {
            rPeriod.AOR__c = trigger.new[0].COR__c;
        }
        
        if (trigger.new[0].Alternate_AOR__c != null){
            rPeriod.Alternate_AOR__c = trigger.new[0].Alternate_AOR__c;
        } else {
            rPeriod.Alternate_AOR__c = trigger.new[0].COR__c;
        }
        
        if (trigger.new[0].Alternate_COR__c != null){
            rPeriod.Alternate_COR__c = trigger.new[0].Alternate_COR__c;
        } else {
            rPeriod.Alternate_COR__c = trigger.new[0].COR__c;
        }
        
         
        rPeriodsUpd.add(rPeriod);       
    }
    
    if(!rPeriodsUpd.isEmpty()){
        update rPeriodsUpd;
    } */
    
   if(!ApplicationConstants.bypassIMSharingRulesTriggerLogic){  
    if((trigger.isInsert) || (trigger.isUpdate)){
     for(Implementing_Mechanism__c tim:trigger.new){           
       RecordID=tim.ID;  
       orgUnitID = tim.ouId__c;
       impMech=tim;       
      }
    }
    
   // repPrd.createRepPeriod(RecordID);  
   system.debug('Sharing Rule Trigger New Map::'+trigger.newMap);
   system.debug('Sharing Rule Trigger New Map::'+trigger.oldMap); 
   repPrd.createIMReportingPeriods(trigger.newMap);
        
    if((trigger.isDelete)){
      thisTriggerType='delete';    
     for(Implementing_Mechanism__c tim:trigger.old){           
       RecordID=tim.ID;  
       orgUnitID = tim.ouId__c;
       impMech=tim;    
       }
    }   

    OrganizationID=impMech.Partner_Id__c;          
    String IMName=impMech.Name;
         
           

     system.debug('3~~~~~~~~~~~~~OrganizationID~~~~~~~~~~~~~~~~~'+OrganizationID+' '+ImName);
     Partner_1=impMech.Partner_User_1__c;    
     Partner_2=impMech.Partner_User_2__c;    
     Partner_3=impMech.Partner_User_3__c;    
     Partner_4=impMech.Partner_User_4__c; 
    // COTR= impMech.COTR__c; 
   //  AOTR= impMech.AOTR__c; 
 
     list<Implementing_Mechanism__c> OrganizationIDList= [   Select id, story.Partner_User_1__c, 
     story.Partner_User_1__r.isActive, story.Partner_User_2__c, story.Partner_User_2__r.isActive, story.Partner_User_3__c, story.Partner_User_3__r.isActive, story.Partner_User_4__c, story.Partner_User_4__r.isActive, story.Partner_Id__c, story.Name From Implementing_Mechanism__c story where id=:RecordID ];
    
    // for(Implementing_Mechanism__c sst:OrganizationIDList){ 
      PrimaryPartners = [ Select Id, isActive, Name from User where (isActive=true and ( Id =:Partner_1 Or Id =:Partner_2 Or Id =:Partner_3 Or Id =:Partner_4)) ];         
      for(User u: PrimaryPartners){
          uniquePartnerIds.add(u.Id);
      }
      //COTRS=[ Select Id, isActive, Name from User where (isActive=true and ( Id =:COTR Or Id =:AOTR)) ];         
         
         //}         

        
    
 /*   if(OrganizationID!=null){   
        Contacts = [   Select id From Contact where AccountId =: OrganizationID  ];
      
         if(Contacts.size()>0){
            for(Contact c: Contacts){
                contactIdsString += '\''+c.Id+'\'';
                contactIdsString += ',';
            }
            contactIdsString = contactIdsString.substring(0,contactIdsString.length()-1);        
            contactIdsString= 'Select Id, isActive from User where isActive=true and ContactId IN ('+contactIdsString+')';           
            ContactUser = Database.query(contactIdsString);           
            system.debug('3~~~~~~~~~~~~~Contacts Users~~~~~~~~~~~~~~~~~'+String.valueOf(ContactUser.size()));   
            system.debug('~~~~~~~~~~~contact user~~~~~~~~~~~~~~~~'+contactIdsString);      
          
          }
        } */

    
    
    // so we are done with primary partners and contacts .. next is to set up related objects      
    
       
    getRelatedObjectsbySelect();
    getSharingObjects();
    deleteDB();
    
   if(OrganizationID!=null){
    resetLists();   
    getALLSharingObjects();
    insertNewShares();
    updateDB();       
   }    
   
   }
   
 //insert new shares
    private void insertNewShares(){
       if(thisTriggerType!='delete' ){
        if(primaryPartners.size()>0){  
        for(User PrimaryUsID:primaryPartners){   
                   
            AddShare(PrimaryUsID.id, 'Edit', RecordID, 'IM');  
            AddShare(PrimaryUsID.id, 'Read', orgUnitID, 'OrgUnit');
            for(Activity__c ss:activityList){
             AddShare(PrimaryUsID.id, 'Edit', ss.ID, 'Activity');   
            }   
            
            for(Reporting_period__c rp:rPeriodList){
             AddShare(PrimaryUsID.id, 'Edit', rp.ID, 'RPeriod');   
            }
            
            for(Public_IM_Link__c pil: projectIMList){
                AddShare(PrimaryUsID.id, 'Read', pil.Project_Code__c, 'Project');
            } 
            
            
            for(OrgUnit_Indicator__c oi: orgUnitIndicatorList){
                AddShare(PrimaryUsID.id, 'Edit', oi.Id, 'OrgUnit_Indicator');
                AddShare(PrimaryUsID.id, 'Edit', oi.Organization_Indicator_Id__c, 'OrgUnit_Indicator');
            }     
          
          }        
          }         
         }
         }              
       
 //
 //Insert into Database
    private void updateDB(){
        if(primaryPartners.size()>0){    
            if(implementingMechanismShareList.size()>0){  
                insert implementingMechanismShareList;
            }        
            if(activityShareList.size()>0){      
                insert activityShareList; 
            }
            System.debug('OrgUnit Share Records:::'+orgUnitShareList);
            if(orgUnitID != Null){      
                upsert orgUnitShareList; 
            }
            
           if(projectShareList.size()>0){      
                insert projectShareList; 
            }
            
            if(orgUnitIndicatorShareList.size()>0){      
                insert orgUnitIndicatorShareList; 
            }
            
            if(rPeriodShareList.size()>0){      
                insert rPeriodShareList; 
            }
        }
        
      
    }
    
    //Delete from Database
    private void deleteDB(){
        if(primaryPartners.size()>0){
         if(implementingMechanismShareList.size()>0){ 
            delete implementingMechanismShareList;
         }
         if(activityShareList.size()>0){  
            delete activityShareList;   
         }
         if(orgUnitShareList.size() > 0){  
            delete orgUnitShareList;   
         } 
         
         if(rPeriodShareList.size() > 0){  
            delete rPeriodShareList;   
         } 
        system.debug('ProjecShare Delete DEbug:::' +projectShareList); 
        if(projectShareList.size()>0){  
            delete projectShareList;   
         }  
         
         if(orgUnitIndicatorShareList.size()>0){  
            delete orgUnitIndicatorShareList;   
         }  
           
        } 
    }
    
    private void getRelatedObjectsbySelect(){
        activityList = new list<Activity__c>();
        projectIMList = new list<Public_IM_Link__c>();
        //orgUnitList = new list<Public_IM_Link__c>();      
        activityList = [ Select Id, ImpMech_Id__c from Activity__c where ImpMech_Id__c=:RecordId];
        projectIMList = [ Select Id, Project_Code__c from Public_IM_Link__c where Implementing_Mechanism_Number__c =:RecordId];
        rPeriodList = [ Select Id, Name, Implementing_Mechanism_Id__c from Reporting_Period__c where Implementing_Mechanism_Id__c =:RecordId];
        orgUnitIndicatorList = [Select Id, Organization_Indicator_Id__c, Implementing_Mechanism_Id__c from OrgUnit_Indicator__c where Implementing_Mechanism_Id__c =:RecordId and Organization_Indicator_Id__c != null ];
    //  orgUnitList = [ Select Id, Project_Code__c from Public_IM_Link__c where Implementing_Mechanism_Number__c =:RecordId];       
    }
    
   private void getSharingObjects(){ 
      implementingMechanismShareList=    [Select Id, ParentId, UserOrGroupId from Implementing_Mechanism__Share where ParentId=:RecordID and RowCause = 'Manual'];
      //orgUnitShareList = [Select Id, ParentId, UserOrGroupId from OrgUnit__Share where ParentId=:orgUnitID and RowCause = 'Manual'];
      projectShareList= [Select Id, ParentId, UserOrGroupId from Project__Share 
                                                                        where ParentId IN (Select Project_Code__c from Public_IM_Link__c where Implementing_Mechanism_Number__c =:RecordId)
                                                                        and RowCause = 'Manual'];
      
      orgUnitIndicatorShareList= [Select Id, ParentId, UserOrGroupId from OrgUnit_Indicator__Share 
                                                                        where ParentId IN (Select Id from OrgUnit_Indicator__c where Implementing_Mechanism_Id__c =:RecordId) 
                                                                        and RowCause = 'Manual'];
      rPeriodShareList= [Select Id, ParentId, UserOrGroupId from Reporting_Period__Share 
                                                                        where ParentId IN (Select Id from Reporting_Period__c where Implementing_Mechanism_Id__c =:RecordId) 
                                                                        and RowCause = 'Manual'];                                                                  
     
     orgUnitIndicatorMasterShareList= [Select Id, ParentId, UserOrGroupId from OrgUnit_Indicator__Share 
                                                                        where ParentId IN (Select Organization_Indicator_Id__c from OrgUnit_Indicator__c where Implementing_Mechanism_Id__c =:RecordId)
                                                                        and UserOrGroupId IN :uniquePartnerIds
                                                                        and RowCause = 'Manual'];
    
     orgUnitIndicatorShareList.addAll(orgUnitIndicatorMasterShareList);
    /*  if(activityShareList.size()>0){  
        delete activityShareList;   
      } */
   }
        
   private void resetLists(){
        implementingMechanismShareList = new list<Implementing_Mechanism__Share>();
        activityShareList = new list<Activity__Share>();
        projectShareList = new list<Project__Share>();
        rPeriodShareList = new list<REporting_Period__share>();
        orgUnitIndicatorShareList = new list<OrgUnit_Indicator__Share>();
    }
    
    
   private void getALLSharingObjects(){ 
        implementingMechanismShareListAll =  [Select Id, ParentId, UserOrGroupId from Implementing_Mechanism__Share 
                                                                                where ParentId=:RecordID and RowCause = 'Manual'];
        if(activityList.size()>0){ 
            activityShareListAll= [Select Id, ParentId, UserOrGroupId from Activity__Share 
                                                                        where ParentId IN (Select Id from Activity__c where ImpMech_Id__c=:RecordId)];
        }
        
        if(orgUnitID != Null){ 
            orgUnitShareListAll= [Select Id, ParentId, UserOrGroupId from OrgUnit__Share 
                                                                        where ParentId = :orgUnitID];
        }
        
        if(projectIMList.size()>0){ 
            projectShareListAll= [Select Id, ParentId, UserOrGroupId from Project__Share 
                                                                        where ParentId IN (Select Project_Code__c from Public_IM_Link__c where Implementing_Mechanism_Number__c =:RecordId)];
        }
        
        if(rPeriodList.size()>0){ 
            rPeriodShareListAll= [Select Id, ParentId, UserOrGroupId from Reporting_Period__Share 
                                                                        where ParentId IN (Select Id from Reporting_Period__c where Implementing_Mechanism_Id__c =:RecordId)];
        }
        
        if(orgUnitIndicatorList.size()>0){ 
            orgUnitIndicatorShareListAll= [Select Id, ParentId, UserOrGroupId from OrgUnit_Indicator__Share 
                                                                        where ParentId IN (Select Id from OrgUnit_Indicator__c where Implementing_Mechanism_Id__c =:RecordId)];
            
            orgUnitIndicatorMasterShareListAll= [Select Id, ParentId, UserOrGroupId from OrgUnit_Indicator__Share 
                                                                        where ParentId IN (Select Organization_Indicator_Id__c from OrgUnit_Indicator__c where Implementing_Mechanism_Id__c =:RecordId)];
            
            orgUnitIndicatorShareListAll.addAll(orgUnitIndicatorMasterShareListAll);   
        }
        
   }
        
    private void AddShare(String UserID, String UserRight, String RecordParentID, String Obname){
        alreadyExists='no';           
        
        if(Obname=='IM'){                  
            for(Implementing_Mechanism__Share thisfs: implementingMechanismShareListAll ){
                if(UserID==thisfs.UserOrGroupId && thisfs.Id==RecordParentID){ 
                    alreadyExists='yes';
                    break;
                }
            }
            if(alreadyExists=='no'){ 
                ImShare=new Implementing_Mechanism__Share(ParentId = RecordParentID, AccessLevel = UserRight, UserOrGroupId=UserID);
                implementingMechanismShareList.add(ImShare);
                implementingMechanismShareListAll.add(ImShare);
            }
        } 
        
        if(Obname=='Activity'){ 
            for(Activity__Share ac: ActivityShareListAll ){
                if(UserID==ac.UserOrGroupId && ac.ParentID==RecordParentID){ 
                    alreadyExists='yes';
                    break;
                }
            }
            
            if(alreadyExists=='no'){
                acShare=new Activity__Share(ParentId = RecordParentID, AccessLevel = UserRight, UserOrGroupId=UserID);
                ActivityShareList.add(acShare);
                ActivityShareListAll.add(acShare);
            }
        }
        
        if(Obname=='RPeriod'){ 
            for(Reporting_Period__Share rs: rPeriodShareListAll ){
                if(UserID==rs.UserOrGroupId && rs.ParentID==RecordParentID){ 
                    alreadyExists='yes';
                    break;
                }
            }
            
            if(alreadyExists=='no'){
                rPeriodShare=new Reporting_Period__Share(ParentId = RecordParentID, AccessLevel = UserRight, UserOrGroupId=UserID);
                rPeriodShareList.add(rPeriodShare);
                rPeriodShareListAll.add(rPeriodShare);
            }
        }
        
        if(Obname=='OrgUnit'){ 
            for(OrgUnit__Share ou: orgUnitShareListAll ){
                if(UserID==ou.UserOrGroupId && ou.ParentID==RecordParentID){ 
                    alreadyExists='yes';
                    break;
                } 
            }
            
            if(alreadyExists=='no'){
                orgShare=new OrgUnit__Share(ParentId = RecordParentID, AccessLevel = UserRight, UserOrGroupId=UserID);
                orgUnitShareList.add(orgShare);
                orgUnitShareListAll.add(orgShare);
            }
        }
        
        if(Obname=='Project'){ 
            for(Project__Share pr: projectShareListAll ){
                if(UserID==pr.UserOrGroupId && pr.ParentID==RecordParentID){ 
                    alreadyExists='yes';
                    break;
                }
            }
            
            if(alreadyExists=='no'){
                projectShare=new Project__Share(ParentId = RecordParentID, AccessLevel = UserRight, UserOrGroupId=UserID);
                projectShareList.add(projectShare);
                projectShareListAll.add(projectShare);
            }
        }
        
        
        if(Obname=='OrgUnit_Indicator'){ 
            for(OrgUnit_Indicator__Share oi: orgUnitIndicatorShareListAll ){
                if(UserID==oi.UserOrGroupId && oi.ParentID==RecordParentID){ 
                    alreadyExists='yes';
                    break;
                }
            }
            
            if(alreadyExists=='no'){
                OrgUnitIndicatorShare=new OrgUnit_Indicator__Share(ParentId = RecordParentID, AccessLevel = UserRight, UserOrGroupId=UserID);
                orgUnitIndicatorShareList.add(OrgUnitIndicatorShare);
                orgUnitIndicatorShareListAll.add(OrgUnitIndicatorShare);
            }
        }
        
        
        
    }

   

    
}