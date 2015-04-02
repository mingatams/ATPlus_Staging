@isTest
private class parseDataTemplateTest {
     public static testmethod void parseDataTemplateTestMethod(){
         ClsTestUtility  ctu = new ClsTestUtility();
         String burId = ctu.getBureauId();
         String orgId = ctu.getOrgUnitForBureauId(burId);
         Award__c award = prepAward(1);
         insert award;
         Implementing_Mechanism__c im = ctu.insertIMForOrgId(orgId,'','Implementing Mechanism');
         im.Award_Id__c = award.Id;
         update im;
         List<Reporting_Period__c>  rpList = new List<Reporting_Period__c>([Select Id,Name, Reporting_Level__c,Implementing_Mechanism_Id__c,recordTypeId,Status__c, Start_Date__c, End_Date__c, Close_Date__c From Reporting_Period__c Where Implementing_Mechanism_Id__c = : im.Id]);  
         system.debug('Test Reporting Periods:::' +rpList);
         List<USAID_Indicator__c> uIndicators = ctu.getUSAIDIndicatorRecords();
         List<OrgUnit_Indicator__c> oMasterInds = ctu.getCustomIndicatorRecordsForOrgId(orgId);
         List<OrgUnit_Indicator__c> oIMInds = ctu.getCustomIndicatorsForType(orgId,im.Id,'IM',oMasterInds ); 
         List<Indicator_Results__c> indResults = ctu.getIndicatorResultByIM(rpList, oIMInds, im.id);
         
        // System.Test.StartTest();
         List<Data_Template__c> templates = new List<Data_Template__c>();
         templates.add(new Data_Template__c(    ouName__c = 'OUNAME',
                                                oucode__c = 'OUC',
                                                         IM_Id__c = im.Name,
                                                         IM_Award_Number__c = 'DocNum1',
                                                         Program_Element_code__c = '1.1.1',
                                                         Program_Element__c = 'Element 1',
                                                         Indicator__c = 'Standard Element Test',
                                                         Indicator_Id__c = '1.1.1-1',
                                                         Reporting_Frequency__c = 'Annual',
                                                         start_Date__c = date.newinstance(2010, 2, 17),
                                                         end_Date__c = date.newinstance(2011, 6, 10),
                                                         Time_Period__c = 'Annual',
                                                         Fiscal_Year__c = 'FY2010',
                                                         Baseline_text__c =  '10.00',
                                                         Target_Text__c = '30.00',
                                                         Actual_Text__c = '20.00'
         ));
         
        // insert dt1;
         
         templates.add( new Data_Template__c(    ouName__c = 'OUNAME',
                                                 oucode__c = 'OUC',
                                                         IM_Id__c = im.Name,
                                                         IM_Award_Number__c = 'DocNum1',
                                                         Program_Element_code__c = '1.1.1',
                                                         Program_Element__c = 'Element 1',
                                                         Indicator__c = 'Custom Sub Indicator Standard Parent',
                                                         Indicator_Id__c = 'custom',
                                                         Temp_Custom_Indicator_code__c = 'C1',
                                                         Master_Indicator_Code__c = '1.1.1-1',
                                                         Master_Indicator_Name__c = 'Standard Element Test',
                                                         Reporting_Frequency__c = 'Annual',
                                                         start_Date__c = date.newinstance(2010, 2, 17),
                                                         end_Date__c = date.newinstance(2011, 6, 10),
                                                         Time_Period__c = 'Annual',
                                                         Fiscal_Year__c = 'FY2010',
                                                         Baseline_text__c =  '5.00',
                                                         Target_Text__c = '25.00',
                                                         Actual_Text__c = '15.00'
         ));
         
         
         templates.add( new Data_Template__c(    ouName__c = 'OUNAME',
                                                 oucode__c = 'OUC',
                                                         IM_Id__c = im.Name,
                                                         IM_Award_Number__c = 'DocNum1',
                                                         Program_Element_code__c = '1.1.1',
                                                         Program_Element__c = 'Element 1',
                                                         Indicator__c = 'Custom Indicator',
                                                         Indicator_Id__c = 'custom',
                                                         Temp_Custom_Indicator_code__c = 'C2',
                                                       //  Master_Indicator_Code__c = '1.1.1-1'
                                                       //  Master_Indicator_Name__c = 'Standard Element Test'
                                                         Reporting_Frequency__c = 'Annual',
                                                         start_Date__c = date.newinstance(2010, 2, 17),
                                                         end_Date__c = date.newinstance(2011, 6, 10),
                                                         Time_Period__c = 'Annual',
                                                         Fiscal_Year__c = 'FY2010',
                                                         Baseline_text__c =  '5.00',
                                                         Target_Text__c = '25.00',
                                                         Actual_Text__c = '15.00'
         ));
         
         
         templates.add( new Data_Template__c(    ouName__c = 'OUNAME',
                                                 oucode__c = 'OUC',
                                                         IM_Id__c = im.Name,
                                                         IM_Award_Number__c = 'DocNum1',
                                                         Program_Element_code__c = '1.1.1',
                                                         Program_Element__c = 'Element 1',
                                                         Indicator__c = 'Custom Sub Indicator',
                                                         Indicator_Id__c = 'custom',
                                                         Temp_Custom_Indicator_code__c = 'C2.1',
                                                         Temp_Custom_Master_Indicator_code__c = 'C2',
                                                      //   Master_Indicator_Code__c = '1.1.1-1'
                                                         Master_Indicator_Name__c = 'Custom Indicator',
                                                         Reporting_Frequency__c = 'Annual',
                                                         start_Date__c = date.newinstance(2010, 2, 17),
                                                         end_Date__c = date.newinstance(2011, 6, 10),
                                                         Time_Period__c = 'Annual',
                                                         Fiscal_Year__c = 'FY2010',
                                                         Baseline_text__c =  '5.00',
                                                         Target_Text__c = '25.00',
                                                         Actual_Text__c = '15.00'
         ));
         
         
         templates.add( new Data_Template__c(    ouName__c = 'OUNAME',
                                                 oucode__c = 'OUC',
                                                         IM_Id__c = im.Name,
                                                         IM_Award_Number__c = 'DocNum1',
                                                         Program_Element_code__c = '1.1.1',
                                                         Program_Element__c = 'Element 1',
                                                         Indicator__c = 'Custom Sub Indicator2',
                                                         Indicator_Id__c = 'custom',
                                                         Temp_Custom_Indicator_code__c = 'C2.21',
                                                         Temp_Custom_Master_Indicator_code__c = 'C2',
                                                      //   Master_Indicator_Code__c = '1.1.1-1'
                                                         Master_Indicator_Name__c = 'Custom Indicator',
                                                         Reporting_Frequency__c = 'Annual',
                                                         start_Date__c = date.newinstance(2010, 2, 17),
                                                         end_Date__c = date.newinstance(2011, 6, 10),
                                                         Time_Period__c = 'Annual',
                                                         Fiscal_Year__c = 'FY2010',
                                                         Baseline_text__c =  '5.00',
                                                         Target_Text__c = '25.00',
                                                         Actual_Text__c = '15.00'
         ));
         
       //  insert dt2;
         insert templates;
       // System.Test.StopTest(); 
         ParseDataTemplate dataTemplates1 = new ParseDataTemplate('Master','all'); 
         ID batchprocessid1 = Database.executeBatch(dataTemplates1);
         
         ParseDataTemplate dataTemplates11 = new ParseDataTemplate('MasterInd','all'); 
         ID batchprocessid11 = Database.executeBatch(dataTemplates11);
         
         ParseDataTemplate dataTemplates2 = new ParseDataTemplate('Child','all'); 
         ID batchprocessid2 = Database.executeBatch(dataTemplates2);
         
         ParseDataTemplate dataTemplates3 = new ParseDataTemplate('Results','all'); 
         ID batchprocessid3 = Database.executeBatch(dataTemplates3);
        
     
     }
    
     private static Award__c prepAward(Integer seq){
        Award__c ae = new Award__c(AWARD_KEY__c = 'AKEY' + String.valueOf(seq),
                                                Name = 'AKEY' + String.valueOf(seq),
                                                ADDR_LINE_1__c = 'Award Address Line1' + String.valueOf(seq),
                                                ADDR_LINE_2__c = 'Award Address Line2' + String.valueOf(seq),
                                                ADDR_STATE__c = 'Award State' +String.valueOf(seq),
                                                AWARD_TYPE__c= 'Award Type' +String.valueOf(seq),
                                                CONTRACT_GRANT__c = 'ContractGrant'+String.valueOf(seq),
                                                DOCNUM__c = 'DocNum'+String.valueOf(seq),
                                                Mission_Name__c = 'OUNAME',
                                                OrgUnit_Code__c = 'OUC',
                                                OrgUnit_Name__c = 'OUNAME',
                                                ENDDATE__c = Date.today() + 365 * seq,
                                                STARTDATE__c = Date.today() - seq,
                                                PROJECTTITLE__c = ''+String.valueOf(seq),
                                                LAST_MODIFICATION__c = ''+String.valueOf(seq),
                                                TEC__c = 3000 + (3000/seq),
                                                VEND_UNIQUE_ID__c = 'VenUniqueId'+String.valueOf(seq),
                                                VENDOR_CD__c = 'VenCd'+String.valueOf(seq),
                                                VENDOR_NM__c = 'VenName'+String.valueOf(seq),
                                                VENDOR_ADDR_CD__c = 'VenAdrCd'+String.valueOf(seq)
                                                );
        return ae;
    }   
    
}