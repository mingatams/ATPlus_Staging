/**
 * An apex page controller that exposes the change password functionality
 */
public with sharing class ClsChangePasswordController {
    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;}
    public String usrName {get; set;}        
    public Map<String, String> headerMap{get;set;}
    public Map<String,system.cookie> ckMap{get;set;}
 
    public PageReference changePassword() {
       usrName = Userinfo.getUserName();
       System.debug('In Change Password:::' +usrName);
       PageReference pr = Site.changePassword(newPassword, verifyNewPassword, oldpassword);
        if (pr == null){
            return null;
        } else {
          return pr;
        }  
        
    }     
    
    public ClsChangePasswordController() {}
    
    @IsTest(SeeAllData=true) public static void testChangePasswordController() {
        // Instantiate a new controller with all parameters in the page
        ClsChangePasswordController controller = new ClsChangePasswordController();
        controller.oldPassword = '123456';
        controller.newPassword = 'qwerty1'; 
        controller.verifyNewPassword = 'qwerty1';                
        
        System.assertEquals(controller.changePassword(),null);                           
    }    
}