public without sharing Class MissionUsersReport{
public List<CustomUser> missionUsers{get;set;}
public List<User> partnerUsers{get;set;}
public Map<String,List<CustomUser>> missionUsersByRole{get;set;}
public String selectedUserRole{get;set;}
public string selectedLoginFilter{get;set;}
public Integer totalUserCount{get;set;}
public Map<String,Integer> userCountByRole{get;set;}
public String loginUserRole{get;set;}
public List<String> uniqueRoles{
get{    
    List<string> returnList = new List<String>();
    returnList.addAll(missionUsersByRole.keySet());
    returnList.sort();
    return returnList;
   }

set;}
    

public boolean isAdmin{get;set;}
public List<selectOption> getLoginFilters(){
    List<selectOption> loginFilters = new List<selectOption>();
    loginFilters.add(new selectoption('All', 'All'));
    loginFilters.add(new selectoption('7', 'Past 7 Days'));
    loginFilters.add(new selectoption('30', 'Past 30 Days'));
    loginFilters.add(new selectoption('60', 'Past 60 Days'));
    loginFilters.add(new selectoption('90', 'Past 90 Days'));
    loginFilters.add(new selectoption('Never', 'Never Logged In'));
    
    return loginFilters;
    
}

public List<selectOption> getRoles(){
    
     List<selectOption> missionRoles = new List<selectOption>();
     missionRoles.add(new selectoption('AIDTracker Support', 'All'));
     for (UserRole ur: [Select Id, Name From UserRole Order by Name]){
         if (ur.Name.contains('|')){
             missionRoles.add(new selectoption(ur.Name, Ur.Name));
         }    
     }     
     return missionRoles;
     
}

public MissionUsersReport(){
      //  isAdmin = false;        
      //  missionUsersByRole = new Map<String,List<CustomUser>>();
      //  missionUsers = new List<CustomUser>();
        Map<Id,UserRole> roleMap = new Map<Id, UserRole>([Select Id, Name From UserRole]);
        if (roleMap.containsKey(UserInfo.getUserRoleId())){
            loginUserRole = roleMap.get(UserInfo.getUserRoleId()).Name;
        }
        
       getMissionUsers(loginUserRole,null,'All');

    }

public PageReference FilterMissionUsers(){
    system.debug('Login User Role::'+loginUserRole);
    system.debug('selected User Role::'+selectedUserRole);
    system.debug('selected User Role::'+selectedLoginFilter);
    getMissionUsers(loginUserRole,selectedUserRole,selectedLoginFilter);
    return null;
}

    
public void getMissionUsers(String lUserRole,string selUserRole,string selLoginFilter){
    isAdmin = false;   
    totalUserCount = 0;     
    missionUsersByRole = new Map<String,List<CustomUser>>();
    missionUsers = new List<CustomUser>();
    userCountByRole = new Map<string,Integer>();
    if (lUserRole != null){
        String Query = '';
       if(lUserRole == 'AIDTracker Support' || lUserRole == 'Root System Administrator' ){
            isAdmin = true;
            if (selUserRole == null || selUserRole == 'AIDTracker Support' || selUserRole == 'Root System Administrator'){
                if(selLoginFilter.equalsIgnoreCase('All')){
                    query = 'Select UserRole.Name, profile.name,username, '+
                            ' FirstName, LastNAme, LastLoginDate, isActive '+
                    ' From User where userRoleId <> null and isPortalEnabled = false ' + 
                    ' order by UserRole.Name asc, LastName asc, firstname asc ';
                } else if(selLoginFilter.equalsIgnoreCase('Never')){
                    query = 'Select UserRole.Name, profile.name,username, '+
                            ' FirstName, LastNAme, LastLoginDate, isActive '+
                    ' From User where userRoleId <> null and isPortalEnabled = false and LastLoginDate = null ' + 
                    ' order by UserRole.Name asc, LastName asc, firstname asc ';
                } else {
                    Integer d = Integer.valueof(selLoginFilter);
                    query = 'Select UserRole.Name, profile.name,username, '+
                            ' FirstName, LastNAme, LastLoginDate, isActive '+
                    ' From User where userRoleId <> null and isPortalEnabled = false and LastLoginDate = LAST_N_DAYS:'+ d + 
                    ' order by UserRole.Name asc, LastName asc, firstname asc ';
                }
             /*   for(User usr:[Select UserRole.Name, profile.name,username,
                    FirstName, LastNAme, LastLoginDate, isActive 
                    From User 
                    where userRoleId <> null and isPortalEnabled = false 
                    order by UserRole.Name asc, LastName asc, firstname asc
                    ]){          
                    List<CustomUser> tempCustUsers = new List<CustomUser>();
                    if(missionUsersByRole.containsKey(usr.UserRole.Name)){
                        tempCustUsers = missionUsersByRole.get(usr.UserRole.Name);          
                    }
                    tempCustUsers.add(new CustomUser(usr.UserRole.Name, usr.profile.name, usr.firstName, usr.lastName, 
                                                    usr.lastlogindate, usr.isactive,usr.userName));
                    missionUsersByRole.put(usr.UserRole.Name,tempCustUsers);
                } */
            } else {
                if(selLoginFilter.equalsIgnoreCase('All')){
                    query = 'Select UserRole.Name, profile.name,username, '+
                            ' FirstName, LastNAme, LastLoginDate, isActive '+
                    ' From User where userRole.Name = \''+selUserRole +'\' and isPortalEnabled = false ' + 
                    ' order by UserRole.Name asc, LastName asc, firstname asc ';
                } else if(selLoginFilter.equalsIgnoreCase('Never')){
                    query = 'Select UserRole.Name, profile.name,username, '+
                            ' FirstName, LastNAme, LastLoginDate, isActive '+
                    ' From User where userRole.Name = \''+selUserRole +'\' and isPortalEnabled = false and LastLoginDate = null ' + 
                    ' order by UserRole.Name asc, LastName asc, firstname asc ';
                } else {
                    Integer d = Integer.valueof(selLoginFilter);
                    query = 'Select UserRole.Name, profile.name,username, '+
                            ' FirstName, LastNAme, LastLoginDate, isActive '+
                    ' From User where userRole.Name = \''+selUserRole +'\' and isPortalEnabled = false and LastLoginDate = LAST_N_DAYS:'+ d + 
                    ' order by UserRole.Name asc, LastName asc, firstname asc ';
                }
               /* for(User usr:[Select UserRole.Name, profile.name,username,
                    FirstName, LastNAme, LastLoginDate, isActive 
                    From User 
                    where userRole.Name = :selUserRole and isPortalEnabled = false 
                    order by LastName asc, firstname asc]){          
                    List<CustomUser> tempCustUsers = new List<CustomUser>();
                    if(missionUsersByRole.containsKey(usr.UserRole.Name)){
                        tempCustUsers = missionUsersByRole.get(usr.UserRole.Name);          
                    }
                    tempCustUsers.add(new CustomUser(usr.UserRole.Name, usr.profile.name, usr.firstName, usr.lastName, 
                                        usr.lastlogindate, usr.isactive,usr.userName));
                    missionUsersByRole.put(usr.UserRole.Name,tempCustUsers);
                } */    
            } 
            for(User usr: Database.query(Query)){  
                    totalUserCount = totalUserCount + 1;        
                    List<CustomUser> tempCustUsers = new List<CustomUser>();
                    if(missionUsersByRole.containsKey(usr.UserRole.Name)){
                        tempCustUsers = missionUsersByRole.get(usr.UserRole.Name);          
                    }
                    tempCustUsers.add(new CustomUser(usr.UserRole.Name, usr.profile.name, usr.firstName, usr.lastName, 
                                        usr.lastlogindate, usr.isactive,usr.userName));
                    missionUsersByRole.put(usr.UserRole.Name,tempCustUsers);
                    userCountByRole.put(usr.UserRole.Name,tempCustUsers.size());
           }
          //  uniqueRoles = new List<String>();
          //  uniqueRoles.addAll(missionUsersByRole.keySet());
        } else {
            isAdmin = false;
            for(User usr:[Select UserRole.Name, profile.name,username,
                FirstName, LastNAme, LastLoginDate, isActive 
                From User 
                where UserRole.Name = :lUserRole  
                order by LastName asc, firstname asc]){
                missionUsers.add(new CustomUser(usr.UserRole.Name, usr.profile.name, usr.firstName, usr.lastName, 
                                                usr.lastlogindate, usr.isactive,usr.userName));
            
            }
        }   
    system.debug('custom Users::'+missionUsers);
    }     


}    
public class CustomUser{
        public String roleName{get;set;}
        public String profileName{get;set;}
        public String FirstName{get;set;}
        public String LastName{get;set;}
        public DateTime lastLogin{get;set;}
        public Boolean isActive{get;set;}
        public String userName{get;set;}
        
        public CustomUser(String rName, String pName, String fName, String lName, DateTime lLogin, Boolean isActive,string userName){
            this.roleName = rName;
            this.profileName = pName;
            this.FirstName = fName;
            this.LastName = lName;
            this.lastLogin = lLogin;
            this.isActive = isActive;
            this.userName = userName;
        
        }
    
    }


}