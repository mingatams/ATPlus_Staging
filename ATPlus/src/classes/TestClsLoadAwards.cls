@isTest
private class TestClsLoadAwards {
    public static testmethod void testMethodClsLoadAwards(){
        List<Award_Ext__c> awardExtList = new List<Award_Ext__c>();
        
        Test.startTest();
        for(Integer i=1; i<5; i++){         
            awardExtList.add(prepAwardExt(i));          
        }
        
        insert awardExtList;
        
        ClsLoadAwards awardsLoad = new ClsLoadAwards(); 
        ID batchprocessid1 = Database.executeBatch(awardsLoad);   
        
        awardExtList.clear();
        for (Integer i = 6; i<8; i++){          
            awardExtList.add(prepAwardExt(i));
        }
        
        
        ClsLoadAwards awardsLoad1 = new ClsLoadAwards(); 
        ID batchprocessid2 = Database.executeBatch(awardsLoad1);
        Test.StopTest();
        
    }
    
        
    public static testmethod void testMethodClsLoadFintxnSmryFacts(){
        List<Fintxn_SMRY_FACTS_EXT__c> fSmryFactsExtList = new List<Fintxn_SMRY_FACTS_EXT__c>();
        
        Test.startTest();
        for(Integer i=1; i<5; i++){
            fSmryFactsExtList.add(prepFintxnSmryFactsExt(i));           
        }
        
        insert fSmryFactsExtList;
        
        ClsLoadFintxnFacts fSmryFactsLoad = new ClsLoadFintxnFacts(); 
        ID batchprocessid1 = Database.executeBatch(fSmryFactsLoad);   
        
        fSmryFactsExtList.clear();
        for (Integer i = 6; i<8; i++){          
            fSmryFactsExtList.add(prepFintxnSmryFactsExt(i));
        }
        
        
        ClsLoadFintxnFacts fSmryFactsLoad1 = new ClsLoadFintxnFacts(); 
        ID batchprocessid2 = Database.executeBatch(fSmryFactsLoad1);
        Test.StopTest();
        
    }
    
    
    
    public static testmethod void testMethodClsLoadFintxnSmryFsnap(){
        List<Fintxn_SMRY_FSNAP_EXT__c> fSmryFsnapExtList = new List<Fintxn_SMRY_FSNAP_EXT__c>();
        
        Test.startTest();
        for(Integer i=1; i<5; i++){
            fSmryFsnapExtList.add(prepFintxnSmryFsnapExt(i));           
        }
        
        insert fSmryFsnapExtList;
        
        ClsLoadFintxnFsnap fSmryFsnapLoad = new ClsLoadFintxnFsnap(); 
        ID batchprocessid1 = Database.executeBatch(fSmryFsnapLoad);   
        
        fSmryFsnapExtList.clear();
        for (Integer i = 6; i<8; i++){          
            fSmryFsnapExtList.add(prepFintxnSmryFsnapExt(i));
        }
        
        
        ClsLoadFintxnFsnap fSmryFsnapLoad1 = new ClsLoadFintxnFsnap(); 
        ID batchprocessid2 = Database.executeBatch(fSmryFsnapLoad1);
        Test.StopTest();
        
    }
    
    
    public static testmethod void testMethodClsLoadIMFinancials(){
        List<Award_Financials_Ext__c> awardFinancialsExtList = new List<Award_Financials_Ext__c>();
        List<Award__c> awardList = new List<Award__c>();
        List<Implementing_Mechanism__c> imList = new List<Implementing_Mechanism__c>();
        
        Test.startTest();
        OrgUnit__c ou = new OrgUnit__c();
        ou = prepOrgUnit();
        
        for(Integer i=1; i<5; i++){
            awardFinancialsExtList.add(prepAwardFinancialsExt(i));
            awardList.add(prepAward(i));            
        }
        
        insert awardFinancialsExtList;
        insert awardList;
        
        Map<String,Award__c> awardsMap = new Map<String,Award__c>();
        for(Award__c a: awardList){
            awardsMap.put(a.Name,a);
        }       
        
        
        
        for(Integer i=1; i<5; i++){
            imList.add(prepIMBasicRecord(i,ou,awardsMap.get('AKEY'+String.valueOf(i))));                    
        } 
        
        insert imList;
        
        
        ClsLoadIMFinancials imFinancialsLoad = new ClsLoadIMFinancials(); 
        ID batchprocessid2 = Database.executeBatch(imFinancialsLoad);       
        
        Test.stopTest();
        
    }
    
    public static testmethod void testMethodClsIMFinancialSnapShotController(){
        PageReference pageRef = Page.vfIMFinancialSnapShot;        
        Test.setCurrentPageReference(pageRef);
        
        Test.startTest();
        
        OrgUnit__c ou = new OrgUnit__c();
        ou = prepOrgUnit();
        
        Award__c award = new Award__c();
        award = prepAward(1);
        insert award;
        
        Fintxn_SMRY_FSNAP__c fsnap = new Fintxn_SMRY_FSNAP__c();
        fsnap = prepFintxnSmryFsnap(1);
        insert fsnap;
        
        Implementing_Mechanism__c im = new Implementing_Mechanism__c();
        im = prepIMBasicRecord(1,ou,award);
        im.totAccr__c = 10000.12;
        im.TotAdv__c = 9000.32;
        im.totAward__c = 200000.00;
        im.totDisb__c = 150000.00;
        im.totObl__c = 175000.00;
        im.DisbCMth__c = 2000.00;
        im.DisbCQtr__c = 8000.00;
        im.DisbP1Mth__c = 1000.00;
        im.DisbP1Qtr__c = 4000.00;
        im.DisbP2Mth__c = 2000.00;
        im.DisbP2Qtr__c = 5000.00;
        
        insert im;
        
        ApexPages.Standardcontroller sc = new ApexPages.StandardController(im);    
        ClsIMFinancialSnapShotController finCntrlExt = new ClsIMFinancialSnapShotController(sc);          
        finCntrlExt.getXcategories();    
        finCntrlExt.getObligationValues();    
        finCntrlExt.getActualValues();    
        finCntrlExt.getProjectedValues();
        
        Test.stopTest();
        
        
    }
    
    public static testmethod void testMethodClsTruncateFinancialExts(){
        
        List<Award_Ext__c> awardExtList = new List<Award_Ext__c>();
        List<Award_Financials_Ext__c> awardFinancialsExtList = new List<Award_Financials_Ext__c>();
        List<Fintxn_SMRY_FACTS_EXT__c> fSmryFactsExtList = new List<Fintxn_SMRY_FACTS_EXT__c>();
        List<Fintxn_SMRY_FSNAP_EXT__c> fSmryFsnapExtList = new List<Fintxn_SMRY_FSNAP_EXT__c>();
        
        Test.startTest();
        OrgUnit__c ou = new OrgUnit__c();
        ou = prepOrgUnit();
        
        for(Integer i=1; i<5; i++){
            awardExtList.add(prepAwardExt(i));
            fSmryFactsExtList.add(prepFintxnSmryFactsExt(i));
            fSmryFsnapExtList.add(prepFintxnSmryFsnapExt(i));
            awardFinancialsExtList.add(prepAwardFinancialsExt(i));                      
        }
        
        insert awardExtList;
        insert fSmryFactsExtList;
        insert fSmryFsnapExtList;
        insert awardFinancialsExtList;
        
        String query = ' Select id, Name From Award_Ext__c ';
        ClsTruncateFinancialExts awardsTruncate = new ClsTruncateFinancialExts(query); 
        ID batchprocessid = Database.executeBatch(awardsTruncate);      
        
        query = ' Select id, Name From Fintxn_SMRY_FSNAP_EXT__c ';
        ClsTruncateFinancialExts fsnapTruncate = new ClsTruncateFinancialExts(query); 
        ID batchprocessid1 = Database.executeBatch(fsnapTruncate);
        
        query = ' Select id, Name From Fintxn_SMRY_FACTS_EXT__c ';
        ClsTruncateFinancialExts factsTruncate = new ClsTruncateFinancialExts(query); 
        ID batchprocessid2 = Database.executeBatch(factsTruncate);
        
        query = ' Select id, Name From Award_Financials_Ext__c ';
        ClsTruncateFinancialExts awardFinTruncate = new ClsTruncateFinancialExts(query); 
        ID batchprocessid3 = Database.executeBatch(awardFinTruncate);
        
        Test.stopTest();
        
    }
    
    
    
    private static Award_Ext__c prepAwardExt(Integer seq){
        Award_Ext__c ae = new Award_Ext__c(AWARD_KEY__c = 'AKEY' + String.valueOf(seq),
                                                Name = 'AKEY' + String.valueOf(seq),
                                                ADDR_LINE_1__c = 'Award Address Line1' + String.valueOf(seq),
                                                ADDR_LINE_2__c = 'Award Address Line2' + String.valueOf(seq),
                                                ADDR_STATE__c = 'Award State' +String.valueOf(seq),
                                                AWARD_TYPE__c= 'Award Type' +String.valueOf(seq),
                                                CONTRACT_GRANT__c = 'ContractGrant'+String.valueOf(seq),
                                                DOCNUM__c = 'DocNum'+String.valueOf(seq),
                                                OrgUnit_Code__c = ''+String.valueOf(seq),
                                                OrgUnit_Name__c = ''+String.valueOf(seq),
                                                ENDDATE__c = Date.today() - seq,
                                                STARTDATE__c = Date.today() + 365 * seq,
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
    
    
    private static Fintxn_SMRY_FACTS_EXT__c prepFintxnSmryFactsExt(Integer seq){
        Fintxn_SMRY_FACTS_EXT__c smryFactExt = new Fintxn_SMRY_FACTS_EXT__c(AWARD_KEY__c = 'AKEY' + String.valueOf(seq),
                                                Name = 'AKEY' + String.valueOf(seq),
                                                OBFS_BBFY__c = String.valueOf(Date.today().year()),
                                                OBFS_EBFY__c = String.valueOf(Date.today().year()+seq),
                                                Facts_Program_Area__c = 'FPA' + String.valueOf(seq),
                                                Facts_Program_Element__c = 'FPE' + String.valueOf(seq),
                                                Facts_Sub_Element__c = 'FPSE' + String.valueOf(seq),
                                                Fiscal_Year__c = String.valueOf(Date.today().year()),
                                                //OBFS_OP_UNIT__c = 'Senegal',
                                                OBFS_FUND__c = 'Fund' + String.valueOf(seq),
                                                phoenix_Program_Area__c = 'PPA' + String.valueOf(seq),
                                                Phoenix_Program_Element__c = 'PPE' + String.valueOf(seq),
                                                Phoenix_Sub_Element__c = 'PPSE' + String.valueOf(seq),
                                                OBFS_FUND_CRCY_OUTS_ADV_AMT__c = 1000 + 1000/seq,
                                                OBFS_FUND_CRCY_DISB_AMT__c = 2000 + 2000/seq,
                                                OBLIGATION_AMT__c = 3000 + 3000/seq
                                                );
        return smryFactExt;
    }
    
    private static Fintxn_SMRY_FSNAP_EXT__c prepFintxnSmryFsnapExt(Integer seq){
        Fintxn_SMRY_FSNAP_EXT__c smryFsnapExt = new Fintxn_SMRY_FSNAP_EXT__c(AWARD_KEY__c = 'AKEY' + String.valueOf(seq),
                                                Name = 'AKEY' + String.valueOf(seq),
                                                Fiscal_Quarter__c = '04',
                                                OBFS_OP_UNIT__c = 'Senegal',
                                                Fiscal_Year__c = String.valueOf(Date.today().year()),                                               
                                                OBFS_FUND_CRCY_OUTS_ADV_AMT__c = 1000 + 1000/seq,
                                                OBFS_FUND_CRCY_DISB_AMT__c = 2000 + 2000/seq,
                                                OBLIGATION_AMT__c = 3000 + 3000/seq
                                                );
        return smryFsnapExt;
    } 
    
    private static Fintxn_SMRY_FSNAP__c prepFintxnSmryFsnap(Integer seq){
        Fintxn_SMRY_FSNAP__c smryFsnap = new Fintxn_SMRY_FSNAP__c(AWARD_KEY__c = 'AKEY' + String.valueOf(seq),
                                                Name = 'AKEY' + String.valueOf(seq),
                                                Fiscal_Quarter__c = '04',
                                                Fiscal_Year__c = String.valueOf(Date.today().year()),
                                                OBFS_OP_UNIT__c = 'Senegal',                                               
                                                OBFS_FUND_CRCY_OUTS_ADV_AMT__c = 1000 + 1000/seq,
                                                OBFS_FUND_CRCY_DISB_AMT__c = 2000 + 2000/seq,
                                                OBLIGATION_AMT__c = 3000 + 3000/seq
                                                );
        return smryFsnap;
    } 
    
    private static Award_Financials_Ext__c prepAwardFinancialsExt(Integer seq){
        Award_Financials_Ext__c awardFinancialExt = new Award_Financials_Ext__c(AWARD_KEY__c = 'AKEY' + String.valueOf(seq),
                                                Name = 'AKEY' + String.valueOf(seq),
                                                DisbCMth__c = 1000 + 1000/seq,
                                                DisbCQtr__c = 2000 + 1000/seq,
                                                DisbP1Mth__c = 500 + 10/seq,
                                                DisbP2Mth__c = 1000 + 100/seq,
                                                DisbP2Qtr__c = 2000 + 100/seq,
                                                DisbP1Qtr__c = 1000 + 10/seq,
                                                ouCode__c = 'OUCODE',
                                                ouName__c = 'OUNAME',
                                                totAccr__c = 2000 + 1000/seq,
                                                TotAdv__c = 1000 + 1000/seq,
                                                totDisb__c = 3000 + 1000/seq,
                                                totAward__c = 5000 + 1000/seq,
                                                totObl__c = 4000 + 1000/seq                                         
                                                
                                                );
        return awardFinancialExt;
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
                                                OrgUnit_Code__c = ''+String.valueOf(seq),
                                                OrgUnit_Name__c = ''+String.valueOf(seq),
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
    
    private static Implementing_Mechanism__c prepIMBasicRecord(Integer seq, OrgUnit__c ou, Award__c award){
        RecordType recType = [Select Id From RecordType where SobjectType = 'Implementing_Mechanism__c' and Name = 'Basic'];
        System.debug('orgUnit Record::' +ou);
        System.debug('Award Record::' +award);
        Implementing_Mechanism__c imRec = new Implementing_Mechanism__c(Implementing_Mechanism_Name__c = 'IM Name' + String.valueOf(seq),
                                                RecordTypeId = recType.Id,
                                                ouId__c = ou.Id,
                                                Award_Id__c = award.Id
                                                );
        return imRec;
    } 
    
    private static OrgUnit__c prepOrgUnit(){
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
  
        Group grp = new Group();
        grp.Name = 'OUCODE User';   
        grp.Type = 'Queue';
        System.runAs(thisUSer){
        insert grp; }
        
        Group grp1 = [select id from group where name = 'OUCODE User' and Type = 'Queue'];
        List<QueueSObject> qList = new List<QueueSObject>();
        QueueSobject q = new QueueSobject();
        q.QueueId = grp1.Id;
        q.SobjectType = 'OrgUnit__c';
        qList.add(q);
        
        QueueSobject q1 = new QueueSobject();
        q1.QueueId = grp1.Id;
        q1.SobjectType = 'Project__c';
        qList.add(q1);
        
        QueueSobject q2 = new QueueSobject();
        q2.QueueId = grp1.Id;
        q2.SobjectType = 'Implementing_Mechanism__c';
        qList.add(q2);
        
        QueueSobject q3 = new QueueSobject();
        q3.QueueId = grp1.Id;
        q3.SobjectType = 'CDCSGoal__c';
        qList.add(q3);
        
        QueueSobject q4 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'CDCSLINK__c');
        qList.add(q4);   
        
        QueueSobject q5 = new QueueSobject(QueueId = grp1.Id, SobjectType = 'Reporting_Period__c');
        qList.add(q5);
             
        System.runAs(thisUSer){
        insert qList; }
        
        Bureau__c bu = new Bureau__c(burCode__c = 'BUR', burName__c = 'BUR Name', Name = 'BUR Name'); 
        Insert bu;
        OrgUnit__c ou = new OrgUnit__c(ouCode__c = 'OUCODE', ouName__c = 'OUNAME',Name = 'OUNAME', ouDisplayName__c = 'OU DISPNAME',burId__c = bu.id );    
        Insert ou;
        return ou;      
    }
    
/*  private static Map<String,Award__c> getAwards(){
        set<String> awardNames = new set<String>();
        Map<String,Award__c> aMap = new Map<String,Award__c>();
        for(Integer i=1; i<5; i++){
            awardNames.add('AKEY'+String.valueOf(i));
        }
        List<Award__c> aList = new List<Award__c>([Select Name,Id From Award__c where Name in :awardNames]);
        for (Award__c a: aList){
            aMap.put(a.Name,a);
        }
        return aMap;
        
    } */
    
}