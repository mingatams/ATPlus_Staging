/**
 * An apex page controller that exposes the site forgot password functionality
 */
public with sharing class ClsForgotPasswordController {
    public String username {get; set;} 
    public String successFlag {get;set;}  
       
    public ClsForgotPasswordController() {}
    
    public PageReference forgotPassword() {
        successFlag = 'E';
        boolean success = Site.forgotPassword(username);
        PageReference pr = Page.vfForgotPasswordConfirm;
        pr.setRedirect(true);
        
        if (success) {              
            return pr;
        }else{
            successFlag = 'F';
        }
        return null;
    }
    
     @IsTest(SeeAllData=true) public static void testForgotPasswordController() {
        // Instantiate a new controller with all parameters in the page
        ClsForgotPasswordController controller = new ClsForgotPasswordController();
        controller.username = 'test@salesforce.com';        
    
        System.assertEquals(controller.forgotPassword(),null); 
    }
}