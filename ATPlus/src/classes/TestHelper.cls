public with sharing class TestHelper {
	
	public static User getAdminUser(boolean create)
    {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User u = new User(Alias = 'admtp', Email='sysAdmin@aaplan.dev', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/New_York', UserName='sysAdmin'+Math.random()+'@aaplan.dev');
            
        if(create)
            insert u;
        return u;
    }
    
    public static User getStandardUser(boolean create)
    {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser@aaplan.dev', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/New_York', UserName='standarduser'+Math.random()+'@aaplan.dev');
            
        if(create)
            insert u;
        return u;
    }
    
    //still need to add profile for aa plan testing
    public static User getAAPlanTestUser(boolean create){
    	Profile p = [SELECT Id FROM Profile WHERE Name = 'AAPlan Testing User'];
        User u = new User(Alias = 'aaplantesting', Email='aaplantesting@aaplan.dev', 
            EmailEncodingKey='UTF-8', FirstName = 'AAPlan', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/New_York', UserName='standarduser'+Math.random()+'@aaplan.dev');
            
        if(create)
            insert u;
        return u;
    }
    
    public static FiscalYear__c getFiscalYear(boolean create){
    	FiscalYear__c tempFY = new FiscalYear__c(
    						Name = 'FY2015',
    						CurrentQuar__c = 'Q1',
    						EndDate__c = Date.newInstance(2015, 12, 31),
    						StartDate__c = Date.newInstance(2015, 1, 1),
    						IsActive__c = true);
    						
    	if(create)
    		insert tempFY;
    	return tempFY;
    }
    
    public static OperatingUnit__c getOperatingUnit(boolean create){
    	OperatingUnit__c tempOU = new OperatingUnit__c(
    						Name = 'testing ou name',
    						Region__c = 'Washington Bureau');
    	
    	if(create)
    		insert tempOU;
    	return tempOU;
    }
    
    public static AAPlan__c getAAPlan(boolean create, FiscalYear__c fy, OperatingUnit__c ou){
    	AAPlan__c tempAAP = new AAPlan__c(
    						Name = 'Testing AA Plan',
    						ApprovalStatus__c = 'New',
    						FiscalYear__c = fy.Id,
    						OperatingUnit__c = ou.Id);
    	
    	if(create)
    		insert tempAAP;
    	return tempAAP;
    }
    
    //not filled out
    //no need yet since we don't have any trigger code for plan details
    /*
    public static AAPlanDetail__c getAAPlanDetail(boolean create){
    	
    }
    */
}