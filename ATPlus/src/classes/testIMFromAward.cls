/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 @IsTest 
 public class testIMFromAward{ 
	 static clsGlobalUtility gu= new clsGlobalUtility();
	 static clsIMAwardUtility imu = new clsIMAwardUtility();
 public static testmethod void testcreateIM(){ 
 	 Id id;
     Award__c aw=(Award__c)gu.lookup(id,'Award__c');
     PageReference pageRef = Page.vfIMFromAward;
	 Test.setCurrentPage(pageRef);
	 ApexPages.currentPage().getParameters().put('id',id);
	 clsIMFromAwardController ctrl= new clsIMFromAwardController();
	 system.debug('Fetched Award-'+aw);
	 if (aw !=NULL){
	     ctrl.setAward(aw.Id);
	     ApexPages.currentPage().getParameters().put('awardId',aw.Id);
	 }
	 ctrl.getAwards();
	 ctrl.createIM();
 }
 //add rest ere 
 public static testmethod void testupdateIM(){
 	 Id id;
	 Award__c aw=(Award__c)gu.lookup(id,'Award__c');
	 Implementing_Mechanism__c im=(Implementing_Mechanism__c)gu.lookup(id,'Implementing_Mechanism__c');
	 PageReference pageRef = Page.vfIMFromAward;
	 Test.setCurrentPage(pageRef);
	 if (im !=NULL)
	     ApexPages.currentPage().getParameters().put('id',im.Id);
	     
	 clsIMFromAwardController ctrl= new clsIMFromAwardController();
	
	 if (aw !=NULL){
	 	 ctrl.setAward(aw.Id);
	     ApexPages.currentPage().getParameters().put('awardId',aw.Id);
	 }
	 ctrl.getAwards();
	 ctrl.updateIM();
 //add rest ere 
 }
 public static testmethod void testSearch(){
// List<Award__c> award =gu.createSobject('Award__c','');
	 PageReference pageRef = Page.vfIMFromAward;
	 Test.setCurrentPage(pageRef);
	 clsIMFromAwardController ctrl= new clsIMFromAwardController();
	 ApexPages.currentPage().getParameters().put('partner','test');
	 ApexPages.currentPage().getParameters().put('awardtitle','t1');
	 ApexPages.currentPage().getParameters().put('docnumber','d1');
	 ctrl.search();
	 ctrl.getAwards();
 
 }
public static testmethod void testSearchRefresh(){
	 List<Award__c> award =gu.createSobject('Award__c','');
	 PageReference pageRef = Page.vfIMFromAward;
	 Test.setCurrentPage(pageRef);
	 clsIMFromAwardController ctrl= new clsIMFromAwardController();
	 ApexPages.currentPage().getParameters().put('partner','test');
	 ApexPages.currentPage().getParameters().put('awardtitle','t1');
	 ApexPages.currentPage().getParameters().put('docnumber','d1');
	 ctrl.search();
	 ctrl.getAwards();
	 ctrl.refresh() ;
	 ctrl.getAwards();
 }
public static testmethod void testSortMethods(){ List<Award__c> award =gu.createSobject('Award__c','');
	 PageReference pageRef = Page.vfIMFromAward;
	 Test.setCurrentPage(pageRef);
	 clsIMFromAwardController ctrl= new clsIMFromAwardController();
	 ctrl.getAwards();
	 ctrl.sortExpression='ASC';
	 String exp=ctrl.sortExpression;
	 ctrl.getSortDirection();
	 ctrl.setSortDirection('DESC');
	 ctrl.getSortDirection();
	//returns DESC ctrl.Beginning();
	 ctrl.End();
	 ctrl.previous();
	 ctrl.next();
	 ctrl.getDisableNext();
	 ctrl.getDisablePrevious();
	 ctrl.getTotal_size();
	 ctrl.getPageNumber();
	 ctrl.getTotalPages();
 }
public static testmethod void testUtilityMethods(){
	 //List<Award__c> award =gu.createSobject('Award__c','');
	 PageReference pageRef = Page.vfIMFromAward;
	 Test.setCurrentPage(pageRef);
	 clsIMFromAwardController ctrl= new clsIMFromAwardController();
	 ctrl.getAwards();
	 ctrl.save();
	 ctrl.back();
	 ctrl.viewIM();
	 ctrl.selectAward();
	// ctrl.selectedAwardId();
	 ctrl.selectAward();
	 ctrl.getAward();
	 //ctrl.setAward(award[0].Id);
	 ctrl.getAward();
	 ctrl.setImpMech('');
	 ctrl.getImpMech();
 }

}