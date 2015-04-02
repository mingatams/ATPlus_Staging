/**
 * 
 * 
 * 
 * 
 * 
 */
@isTest
public class testPlanningUnitGroupRefIntegrityCheck {

    @isTest(SeeAllData=false)
    public static void test1(){
        List<FiscalYear__c> fys = new List<FiscalYear__c>{
                                new FiscalYear__c( Name = '2013', Year__c = 2013, CurrentQuar__c = 'Q4', isActive__c = False ),
                                new FiscalYear__c( Name = '2015', Year__c = 2015, CurrentQuar__c = 'FY', isActive__c = False )
                            };        
        FiscalYear__c fy = new FiscalYear__c( Name = '2014', Year__c = 2014, CurrentQuar__c = 'Q1', isActive__c = True );
        fys.add(fy);
        insert fys;
        OperatingUnit__c o = new OperatingUnit__c( name = 'Test Planning Unit', Region__c = 'Test Planning Unit' );
        insert o;
        Planning_Unit_User__c puu = new Planning_Unit_User__c( Planning_Unit__c = o.id, User__c = UserInfo.getUserId() );
        insert puu;
        AAPlan__c a = new AAPlan__c( Name = 'Test A&A Plan', FiscalYear__c = fy.id, OperatingUnit__c = o.id );
        insert a;
        AAPlanDetail__c b = new AAPlanDetail__c( AandAPlan__c = a.id, 
                                                AwardTitle__c = 'Test A&A Action', 
                                                ObligatedAmount__c = 123, 
                                                Quarter__c = 'Q1' );
        insert b;
        List<Fund_Type__c> fts = new List<Fund_Type__c>{ new Fund_Type__c( A_A_Action__c = b.id, Funding_Type__c = 'TEST', Funding_Year__c = '2014'),
                                                         new Fund_Type__c( A_A_Action__c = b.id, Funding_Type__c = 'TEST2', Funding_Year__c = '2014')};
        insert fts;
        
        List<Planning_Unit_Group__c> pug = [SELECT ID, Group_ID__c FROM Planning_Unit_Group__c WHERE Planning_Unit__c = :o.id];
        A_A_Public_Group_Integrity_Check_Config__c conf = new A_A_Public_Group_Integrity_Check_Config__c( name = 'Default Config',
                                                                                                          To_Addresses__c = 'test@usaid.gov,test1@usaid.gov',
                                                                                                          CC_Addresses__c = 'test2@usaid.gov',
                                                                                                          BCC_Addresses__c = 'test3@usaid.gov',
                                                                                                          Reply_To_Address__c = 'test4@usaid.gov',
                                                                                                          From_Address_Display_Name__c = 'User Test');
        insert conf;

        //User u = [SELECT ID FROM User WHERE Profile.Name = 'System Administrator'AND ID != :UserInfo.getUserID()].get(0);
        User u = TestHelper.getAdminUser(true);
        for( Planning_Unit_Group__c p : pug ){
            
            System.runAs(u){
                delete new Group(id=(ID)p.Group_ID__c);
            }
        }
        update pug;
        
        Test.startTest();
        PlanningUnitGroupRefIntegrityCheck az = new PlanningUnitGroupRefIntegrityCheck();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, az);

        Test.stopTest();
        System.assert( [SELECT ID FROM Planning_Unit_Group__c WHERE Group_ID__c != null].size() == 0, 'Test 1.1: Group_ID__c is not null' );
    }
}