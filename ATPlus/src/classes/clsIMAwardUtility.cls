/**
 * This class contains  CRUD methods for Implementing_Mechanism and Award
 *
 * These methods are used by IMFromAward vf page and controller
 * following methods are defined in this class - 
 * getAward         - Arg:Award id
 *                    Ret:Award Object for the id
 * getAwardObj      - Arg:Award id
 *                    Ret:currently selected Award Object  
 * getAwardObj      - Arg:Award id
 *                    Ret:currently selected Award Object  
*/

public with sharing class clsIMAwardUtility {

        private List<Award__c> awList;
        public String errMsg {get; set;}
        public String query {get;set;}
        public integer counter=0;  //keeps track of the offset
        public integer list_size=25; //sets the page size or number of rows
        public integer total_size; //used to show user the total size of the list
        private integer recordsFetched;
        public String queryFields =' Id,Name, Implementing_Mechanism__c, PROJECTTITLE__c,Award_Number__c, Source__c,DocNum__c,OrderNum__c,VENDOR_NM__c,TEC__c,StartDate__c,EndDate__c,ACTIVE_STATUS__c,AWARD_KEY__c,OrgUnit_Code__c, OrgUnit_Name__c';
        //public String whereclause =' OrgUnit_Code__c = \'LBN\'';
        public String whereclause ='';
        public string orderBy='';
        public string limit_r='';
        public Integer FiscalYearStartMonth = 0;
        Map<String,String> mappings = new Map<String,String>();       
        private Implementing_Mechanism__c impMech;
       
        public clsIMAwardUtility(){
              
              total_size = [select count() from Award__c];
              recordsFetched=total_size;
        }
        public clsIMAwardUtility(String userRole){
            String qry='Select count()  FROM Award__c';
            if(whereclause !=null) qry+=' WHERE '+whereclause;
            try{
                total_size = Database.countQuery(qry);
                
            }catch(Exception e){
                errMsg= 'Error encountered while getting total size  -'+e.getMessage();
                system.debug(errMsg);

            }
        }

        public Award__c getAward(String id){
            try{
                if(id==null)
                    return null;
                String query ='Select '+queryFields+' FROM Award__c WHERE Id =\''+id+'\'';    
                return database.query(query);
            }catch (QueryException  e) {
                system.debug('Query Error occured in getAward  -'+e.getStackTraceString());
                e.setMessage('Error occured while selecting Award for -'+id+'\\n'+' Query Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );

            } catch(Exception e){
                 system.debug('Error occured in getAward -'+e.getStackTraceString());
                 e.setMessage('Could not Select Award for -'+id+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
                 throw(e);
            } 
            return null;
        }

        public Award__c getAwardObj(String id){
            if (awList==null)
                return null;
            for (Award__c aw:awList){
                if(aw.Id==id)
                    return aw;
            }
            return null;
        }
        public Integer setTotalSize(){
            String qry='Select count()  FROM Award__c';
            if(whereclause !=null && whereclause != '') 
                qry+=' WHERE '+whereclause;
            try{
            System.Debug('setTotalSize ***  ' + qry);
                total_size=Database.countQuery(qry);           
            } catch(Exception e){
                 system.debug('Error occured in setTotalSize -'+e.getStackTraceString());
                 e.setMessage('Could not Select Award size \\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
                 throw(e);
            } 
             return total_size;
        }
       public void resetTotalSize(){
             total_size=recordsFetched;
        }
        /*
         get the list of project building relations :-
        */
        public List<Award__c> listdata (){            
            query ='Select '+queryFields+' FROM Award__c';
            
            if(whereclause !='' && whereclause !=null) query+=' WHERE '+whereclause;
            if(orderBy!='' && orderBy!=null) query+=' ORDER BY '+orderBy;
            if(list_size != 0 && list_size!=null) query+=' LIMIT '+list_size;
            if(counter !=0 && counter!=null) query+=' offset '+counter;
            
            try{
                 awList =  Database.query(query);
                 setTotalSize();
                 return  awList;
            } catch(Exception e){
                 system.debug('Error occured in setTotalSize -'+e.getStackTraceString());
                 e.setMessage('Could not Select Award size \\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
                 throw(e);
            } 
            return null;            
        }
        public Implementing_Mechanism__c getIMPMech(String imId){
            try{
                impMech=[select id,Name,Award_Id__c,Implementing_Mechanism_Name__c,RecordTypeId,Award_Number__c,Partner_Name__c, Partner_User_1__c,Partner_User_2__c,Partner_User_3__c,Partner_User_4__c from Implementing_Mechanism__c where id = :imId Limit 1];
                return impMech;
            }catch (QueryException  e) {
                system.debug('Query Error occured in getIMPMech  -'+e.getStackTraceString());
                e.setMessage('Error occured while selecting Award for -'+imId+'\\n'+' Query Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
                throw(e);
            } catch(Exception e){
                 system.debug('Error occured while creating Implementing Mechanism -'+e.getStackTraceString());
                 e.setMessage('Could not Select Implementing Mechanism for -'+imId+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
                 throw(e);
            }    
            return null;
        }
        public void updateIM(Implementing_Mechanism__c im){
            try{
                if (im !=null ){
                    //Initialize financials associated with previously selected award
                    im.totAccr__c=null;
                    im.TotAdv__c=null;
                    im.totDisb__c=null;
                    im.totAward__c=null;
                    im.totObl__c=null;
                    im.DisbCMth__c=null;
                    im.DisbCQtr__c=null;
                    im.DisbP1Mth__c=null;
                    im.DisbP2Mth__c=null;
                    im.DisbP2Qtr__c=null;
                    im.DisbP1Qtr__c=null;
                    im.As_of_Date__c=null; 
                    update im;
                }
            } catch (Exception e) {
                system.debug('Error occured in updateIM -'+e.getStackTraceString());
                 e.setMessage('Could not update Implementing Mechanism -'+im.Name+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
                throw(e);
            }
        }
        public void updateIM(Id imId){
            Implementing_Mechanism__c im = [Select Id, Award_Id__c from Implementing_Mechanism__c where Id=:imId];
            try{
                if (im !=null ){
                    //Initialize financials associated with previously selected award

                    update im;
                }
            } catch (Exception e) {
                system.debug('Error occured in updateIM -'+e.getStackTraceString());
                 e.setMessage('Could not update Implementing Mechanism -'+im.Name+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
                throw(e);
            }
        }
        public void updateAward(String awardId, String imId){
            Award__c award;
            try{
                if (awardId !=null ){
                    award=[select Id,Implementing_mechanism__c from Award__c where Id =:awardId Limit 1];
                    if (award != null){
                        award.Implementing_mechanism__c=imId;
                    }
                }
                updateAward(award);
            } catch (Exception e) {
                system.debug('Error occured in updateAward -'+e.getStackTraceString());
                e.setMessage('Could not select  award for -'+awardId+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() ); 
                throw(e); 
            }
        }
        private void updateAward(Award__c aw){
            try{
                if (aw !=null)
                    update aw;
            } catch (Exception e) {
                 system.debug('Error occured in updateAward-'+e.getStackTraceString());
                 e.setMessage('Could not update award -'+aw.Name+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() ); 
                 throw(e);
            }
        }
        public String createIM(Implementing_Mechanism__c im){
            try{
                insert im;
                return im.Id;
            }catch(Exception e){
                 system.debug('Query Exception occured in createIM -'+e.getStackTraceString());
                 e.setMessage('Could not select  Implementing Mechanism -'+im.Name+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
                 throw(e);
            }
            return null;
        }
    /*    public String createRepPeriod(Activity__c act){
            if (act==null)
                return null;
            List<Reporting_Period__c> rpList = new List<Reporting_Period__c>();
            Date qrtrStartDate=getStartDate(act.Activity_Start_Date__c);
            Date qrtrEndDate=getEndDate(act.Activity_End_Date__c);
            Date repPeriod =qrtrStartDate;
            system.debug('StartDate-'+qrtrStartDate+'-End Date-'+qrtrEndDate);
            try{
             //   for(integer i=1;i<=act.Activity_Start_Date__c.daysBetween(act.Activity_End_Date__c);i++){
               integer j=12;
               j = act.Periodicity__c=='Quarterly'?2:6;
               System.Debug('qrtrStartDate **** ' + qrtrStartDate);
               System.Debug('qrtrEndDate   **** ' + qrtrEndDate);
               System.Debug('qrtrStartDate.monthsBetween(qrtrEndDate) **** ' + qrtrStartDate.monthsBetween(qrtrEndDate));
               for(integer i=1;i<=qrtrStartDate.monthsBetween(qrtrEndDate);i=i+j){
                    
                    Reporting_Period__c rp = new Reporting_Period__c();
                    rp.Activity_Id__c=act.Id;
                    String fiscalPeriod = getFiscalPeriod(act.Periodicity__c,repPeriod);
                    rp.Fiscal_Period__c=fiscalPeriod;
                    rp.Name= fiscalPeriod+'-'+repPeriod.year();
                    rp.Fiscal_Year__c=String.Valueof(repPeriod.year());
                    
                    rpList.add(rp);
                    repPeriod = repPeriod.addMonths(3);
                   // Activity_Start_Date__c Activity_End_Date__c
                }//end for
                insert rpList;
                system.debug('Reporting Periods -'+rpList);
                return null;
            }catch(Exception e){
                 system.debug('Query Exception occured in createIM -'+e.getStackTraceString());
                 e.setMessage('Could not create Reporting Period for Activity -'+act.Name+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
                 throw(e);
            }
            return null;
        }//end createRepPeriod
 
        private Date getStartDate(Date startDate){
            if (startDate ==null)
                return null;
            //Integer FiscalYearStartMonth = 10;
            if(FiscalYearStartMonth <=0)
            FiscalYearStartMonth =10;
            Date fiscalYearStartDate;
            Integer quarter;

            if(system.today().month() >= FiscalYearStartMonth)
            {
                fiscalYearStartDate = date.newinstance(startDate.year(), FiscalYearStartMonth, 1);
                quarter = ((startDate.month() - FiscalYearStartMonth) / 3) + 1;
            }
            else
            {
                fiscalYearStartDate = date.newinstance(startDate.year() - 1, FiscalYearStartMonth, 1);
                quarter = ((12 + startDate.month() - FiscalYearStartMonth) / 3) + 1;
            }    
            Date firstDateOfNextQuarter = fiscalYearStartDate;

            // this is the last date of the current quarter
            firstDateOfNextQuarter = firstDateOfNextQuarter.addMonths(quarter); 
            return firstDateOfNextQuarter;
        }
        private Date getEndDate(Date endDate){
            if (endDate ==null)
                return null;
           // Integer FiscalYearStartMonth = 10;
              if(FiscalYearStartMonth <=0)
            FiscalYearStartMonth =10;
            Date fiscalYearStartDate;
            Integer quarter;

            if(system.today().month() >= FiscalYearStartMonth)
            {
                fiscalYearStartDate = date.newinstance(endDate.year(), FiscalYearStartMonth, 1);
                quarter = ((endDate.month() - FiscalYearStartMonth) / 3) + 1;
            }
            else
            {
                fiscalYearStartDate = date.newinstance(endDate.year() - 1, FiscalYearStartMonth, 1);
                quarter = ((12 + endDate.month() - FiscalYearStartMonth) / 3) + 1;
            }    
            Integer addMonths = quarter * 3;
            Date lastDateOfThisQuarter = fiscalYearStartDate;

            // this is the last date of the current quarter
            lastDateOfThisQuarter = lastDateOfThisQuarter.addMonths(addMonths).addDays(-1);
            return lastDateOfThisQuarter;
        }
        private String getFiscalPeriod(String periodicity, Date startDate){
            if (startDate ==null)
                return null;
                
            if (periodicity=='Quarterly' && startDate.month() <4)
                return 'Q1';
            if (periodicity=='Quarterly' && startDate.month() <8)
                return 'Q2';
            if (periodicity=='Quarterly' && startDate.month() <10)
                return 'Q3';
            if (periodicity=='Quarterly' && startDate.month() <13)
                return 'Q4';
            if (periodicity=='Semi-Annual' && startDate.month() <7)
                return 'SA1';
            if (periodicity=='Semi-Annual' && startDate.month() <13)
                return 'SA2';
            
            return 'Annual';
        } */
     
     
      @IsTest(SeeAllData=true) public static void testclsIMAwardUtility() {
 
    ClsTestUtility testIndicatorUtil = new ClsTestUtility();      
      Test.StartTest();  
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());       
        String IMId= testIndicatorUtil.getIMForOrgIdNRecordType(OrgUnitId,'Advanced');                     
          Award__c testAward = new Award__c(Name='AwardTest');
          insert testAward;    
         ApexPages.currentPage().getParameters().put('Id',IMId);  
       
        clsIMAwardUtility controller = new clsIMAwardUtility();
         clsIMAwardUtility controller1 = new clsIMAwardUtility('TEST');
          List<Award__c> awList1 = new List<Award__c>();
          awList1.add(testAward);
          controller.awList = awList1;
            controller.getAward(testAward.id);
        controller.getAwardObj(testAward.id);
        //controller.setTotalSize();
        controller.resetTotalSize();
        controller.whereclause=null;
        controller.listdata ();
        controller.whereclause='id != null ';
        controller.listdata ();
        controller.getIMPMech(IMId);
        Implementing_Mechanism__c  imLink=[select Id,Name from Implementing_Mechanism__c where id = :IMId];         
        controller.updateIM(imLink);
        controller.updateIM(IMId);
        controller.updateAward(testAward.id, IMId);
        controller.updateAward(testAward);
        
        
         User u3 = [select id from User where alias='tuser' limit 1];
       System.RunAs(u3){
           controller.updateAward(testAward);
       System.debug('Inserting a record with 501 miles... (negative test case)');
        }
        
        
        Implementing_Mechanism__c testIM = new Implementing_Mechanism__c();
        testIM.ouId__c=OrgUnitId ;
        testIM.Implementing_Mechanism_Name__c= 'TestIM2';
        controller.createIM(testIM );
      
        Date startDate = Date.valueOf('2012-04-30');
        Date endDate = Date.valueOf('2012-09-30');
       
     //   controller.FiscalYearStartMonth=04;
     //   controller.getStartDate(startDate );
        
     //   controller.getEndDate(endDate );
     //   controller.getFiscalPeriod('Quarterly', endDate );
    
        Test.StopTest();
    
 }
 
      @IsTest(SeeAllData=true) public static void testclsIMAwardUtility2() {
 
    ClsTestUtility testIndicatorUtil = new ClsTestUtility();      
      Test.StartTest();  
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());       
        String IMId= testIndicatorUtil.getIMForOrgIdNRecordType(OrgUnitId,'Advanced');        
         ApexPages.currentPage().getParameters().put('Id',IMId);
        clsIMAwardUtility controller = new clsIMAwardUtility();      
        
          
               controller.getAward(null);
        controller.getAwardObj(null);
      
        controller.resetTotalSize();
      
     
        controller.updateAward(null, null);
        controller.updateAward(null);
       
     
         
        Project__c testProject=  testIndicatorUtil.getProjectRecordForOrgId(OrgUnitId);
        String testActivityString=testIndicatorUtil.getTask(IMId, testProject.id) ;    
        //controller.getIMPMech(null);
       Activity__c  testActivity=[select Id,Name from  Activity__c where id = :testActivityString];         
         Date testDate =  date.newInstance(0001, 1, 1); 
          Date startDate = Date.valueOf('2012-04-30');
        Date endDate = Date.valueOf('2012-09-30');
         // Date testDate = date.newInstance(0001, 1, 1);  
          testActivity.Activity_Start_Date__c=startDate ;
          testActivity.Activity_End_Date__c = endDate ;
         // testIndicatorUtil.setGroupNQueue();
    //    controller.createRepPeriod(testActivity);
    //   controller.getFiscalPeriod('Quarterly', Date.valueOf('2012-03-30'));
    //     controller.getFiscalPeriod('Quarterly', Date.valueOf('2012-07-30'));
    //       controller.getFiscalPeriod('Quarterly', Date.valueOf('2012-09-30'));
    //         controller.getFiscalPeriod('Semi-Annual', Date.valueOf('2012-06-30'));
    //           controller.getFiscalPeriod('Quarterly', Date.valueOf('2012-06-30'));
    //            controller.getFiscalPeriod('Semi-Annual', Date.valueOf('2012-12-30'));
    //           controller.getFiscalPeriod('Quarterly', Date.valueOf('2012-12-30'));
      
    
        Test.StopTest();
    
 }
     
     
     
      /*  public static testMethod void testAwardsInfo(){
          clsGlobalUtility AAGutils= new clsGlobalUtility();
          Award__c award = new Award__c(Name= 'Project Testing');
          insert award;
          List<OrgUnit__c> ou;

          ou=AAGutils.createSobject('OrgUnit__c','all');

          Implementing_Mechanism__c im = new Implementing_Mechanism__c();
          im.Implementing_Mechanism_Name__c='Name';
          im.ouId__c=ou[0].Id;
          im.Award_Id__c=award.ID;
          
          clsIMAwardUtility MPCCtr = new clsIMAwardUtility('');
          MPCCtr = new clsIMAwardUtility(' OrgUnit_Code__c = \'LBN\'');
          award.Implementing_Mechanism__c=MPCCtr.createIM(im);
          MPCCtr.updateAward(award);
          MPCCtr.getAward(award.id);
          MPCCtr.listdata();
          MPCCtr.getAward(null);
         
         
        } */
        
}//end class