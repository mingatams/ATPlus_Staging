public  without sharing Class PartnerUsersReport {
    public List<PartnerCustomUser> partnerUsers{get;set;}
    public Map<string,List<PartnerCustomUser>> partnerUsersByRole{get;set;}
    public set<string> uniqueRoles{get;set;}
    
    public boolean isAdmin{get;set;}
    
    
    public PartnerUsersReport(){
        String loginPartnerUserRole;
        String orgname;
        PartnerUsers = new List<PartnerCustomUser>();
        partnerUsersByRole = new Map<string,List<PartnerCustomUser>>();
        uniqueRoles = new Set<string>();
        Map<Id,UserRole> profileroleMap = new Map<Id, UserRole>([Select Id, Name From UserRole]);
        if (profileroleMap.containsKey(UserInfo.getUserRoleId())){
            loginpartnerUserRole = profileroleMap.get(UserInfo.getUserRoleId()).Name;
            orgname = loginpartnerUserRole.substringAfter('| ');
        }
        if (loginpartnerUserRole != null) {
            if(loginpartnerUserRole == 'AIDTracker Support' || loginpartnerUserRole == 'Root System Administrator' ){
                for (User pusr:[Select UserRole.Name,Profile.name,FirstName,LastName,LastLoginDate, 
                                isActive, contact.ouName__c,userName 
                                From User 
                                where isportalenabled=true
                                Order by LastName asc, FirstName asc]){
                    List<PartnerCustomUser> tempPartnerUsers = new List<PartnerCustomUser>();
                    if(partnerUsersByRole.containsKey(pusr.UserRole.Name)){
                        tempPartnerUsers = partnerUsersByRole.get(pusr.UserRole.Name);
                    }
                    tempPartnerUsers.add(new PartnerCustomUser(pusr.UserRole.Name, pusr.profile.name, pusr.firstName, pusr.lastName, 
                                                    pusr.lastlogindate, pusr.isactive,pusr.contact.ouName__c,pusr.userName));
                    uniqueRoles.add(pusr.UserRole.Name);
                    partnerUsersByRole.put(pusr.UserRole.Name,tempPartnerUsers);
                    partnerUsers.add(new PartnerCustomUser(pusr.UserRole.Name, pusr.profile.name, pusr.firstName, pusr.lastName, 
                                                        pusr.lastlogindate, pusr.isactive,pusr.contact.ouName__c,pusr.userName));
                }
            
            } else {    
                for (User pusr:[Select UserRole.Name,Profile.name,FirstName,LastName,LastLoginDate, 
                                isActive, contact.ouName__c, userName 
                                From User 
                                where isportalenabled=true and contact.ouname__c = :orgname
                                Order by LastName asc, FirstName asc ]){
                    List<PartnerCustomUser> tempPartnerUsers = new List<PartnerCustomUser>();
                    if(partnerUsersByRole.containsKey(pusr.UserRole.Name)){
                        tempPartnerUsers = partnerUsersByRole.get(pusr.UserRole.Name);
                    }
                    tempPartnerUsers.add(new PartnerCustomUser(pusr.UserRole.Name, pusr.profile.name, pusr.firstName, pusr.lastName, 
                                                pusr.lastlogindate, pusr.isactive,pusr.contact.ouName__c,pusr.userName));
                    uniqueRoles.add(pusr.UserRole.Name);
                    partnerUsersByRole.put(pusr.UserRole.Name,tempPartnerUsers);
                    partnerUsers.add(new PartnerCustomUser(pusr.UserRole.Name, pusr.profile.name, pusr.firstName, pusr.lastName, 
                                                pusr.lastlogindate, pusr.isactive,pusr.contact.ouName__c,pusr.userName));
                }
            }
            system.debug('Partner custom Users::' +PartnerUsers);
        }   
    }
    public class PartnerCustomUser{
        public String roleName{get;set;}
        public String profileName{get;set;}
        public String FirstName{get;set;}
        public String LastName{get;set;}
        public DateTime lastLogin{get;set;}
        public Boolean isActive{get;set;}
        public String Orgname{get;set;}
        public string userName{get;set;}
        
        public PartnerCustomUser(String rName, String pName, String fName, String lName, DateTime lLogin, Boolean isActive,string orgName,string userName){
            this.roleName = rName;
            this.profileName = pName;
            this.FirstName = fName;
            this.LastName = lName;
            this.lastLogin = lLogin;
            this.isActive = isActive;
            this.Orgname = orgName;
            this.userName = userName;
        }   
    
    }


}