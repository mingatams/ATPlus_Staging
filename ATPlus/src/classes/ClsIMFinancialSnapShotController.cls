public with sharing class ClsIMFinancialSnapShotController {
    private final Implementing_Mechanism__c imObject; 
    private Integer actualPlotsCount = 0;
    private Integer projectedPlotsCount = 0;
    
    private List<AggregateResult> finTxnList = new List<AggregateResult>(); 
    private Map<String,AggregateResult> fintxnMap = new Map<String,AggregateResult>();
    public Integer obligationAmt{get;set;}
    public Date asOfDate {get;set;}
    public string sTitle {get;set;}
    
    public ClsIMFinancialSnapShotController(ApexPages.StandardController stdController){ 
        this.obligationAmt =0;    
        asOfDate = Date.toDay().addDays(-1);
        sTitle = 'Financial SnapShot as of ' + String.valueOf(asOfDate.format());
        this.imObject =                             [SELECT  im.Name,
                                                            im.Start_Date__c,
                                                      //      im.Mission_Name__c,
                                                            im.End_Date__c,
                                                            im.Partner_Id__r.Name,
                                                            im.Award_Key__c,
                                                            im.totMthsContract__c,
                                                            im.Award_Id__c,
                                                            im.totMthsElapsed__c,
                                                            im.totAward__c,
                                                            im.pcObl2Award__c,
                                                            im.totObl__c,   
                                                            im.pcExp2Award__c,
                                                            im.totDisb__c,
                                                            im.pcExp2Obl__c,
                                                            im.totAccr__c,
                                                            im.pcUnliqBal2Obl__c,
                                                            im.totExp__c,
                                                            im.totPline__c,
                                                            im.DisbP2Qtr__c,
                                                            im.DisbP1Qtr__c,
                                                            im.DisbP2Mth__c,
                                                            im.DisbP1Mth__c,
                                                            im.ouName__c,
                                                            im.ERateHist__c,
                                                            im.ERateP2Qtr__c,
                                                            im.ERateP1Qtr__c,
                                                            im.ERateP2Mth__c,
                                                            im.ERateP1Mth__c,
                                                            im.UnliqBalMthHist__c,
                                                            im.UnliqBalMthP2Qtr__c,
                                                            im.UnliqBalMthP1Qtr__c,
                                                            im.UnliqBalMthP2Mth__c,
                                                            im.UnliqBalMthP1Mth__c 
                                                    FROM Implementing_Mechanism__c im
                                                    WHERE im.id = :stdController.getId()
                                                        ];
                                                        
        finTxnList = [ SELECT   f.Fiscal_Year__c,
                                f.Fiscal_Quarter__c,
                       //         f.OBFS_OP_UNIT__c,
                                SUM(f.OBFS_FUND_CRCY_DISB_AMT__c) disb_amt, 
                                SUM(f.OBLIGATION_AMT__c) oblig_amt                                                                                 
                        FROM Fintxn_SMRY_FSNAP__c f
                      //  WHERE   f.Award_Id__c =:imObject.Award_Id__c                                                                 
                        WHERE f.Award_Key__c =:imObject.Award_Key__c 
                        GROUP BY f.Fiscal_Year__c,
                                f.Fiscal_Quarter__c
                 //               f.OBFS_OP_UNIT__c
                        ORDER BY f.Fiscal_Year__c asc, 
                                f.Fiscal_Quarter__c asc
                   //             f.OBFS_OP_UNIT__c asc
                                
                    ];  
        for (AggregateResult ar : finTxnList){
        	String qtr = (String)ar.get('Fiscal_Quarter__c');
        	if (qtr.length() == 2){
        		qtr = qtr.substring(1);
        	}
        	String year = (String)ar.get('Fiscal_Year__c');
        	fintxnMap.put('\'Q'+qtr.trim()+'/'+year.subString(2)+'\'',ar);
           // fintxnMap.put('\'Q'+(String.valueOf(ar.get('Fiscal_Quarter__c'))).subString(1)+'/'+(String.valueOf(ar.get('Fiscal_Year__c'))).subString(2)+'\'',ar);
            
        }                                                          
        
        if (imObject.totObl__c != null){
            this.obligationAmt = Math.round((Decimal)imObject.totObl__c);
        } else { this.obligationAmt = 0; }
                
    }
        
    public List<Double> getProjectedValues(){
        List<Double> returnList = new List<Double>(); 
        System.debug('Inside Projected Values function 1'+imObject.Start_Date__c+':::' +imObject.End_Date__c ); 
        Decimal totalEstimatedCost = (Decimal)imObject.totAward__c;
        Decimal totalObligationAmount = (Decimal)imObject.totObl__c;
        Integer totalElapsedQtrsByObligation = 0;
        Decimal avgQtrlyProjectedAwardAmount = 0.00;
        Decimal cumulativeProjectedAmount = 0;
        System.debug('Inside Projected Values function 2' +imObject.totMthsContract__c);
        if ((imObject.totMthsContract__c > 0) && (totalObligationAmount > 0 )){
            avgQtrlyProjectedAwardAmount = (totalObligationAmount / imObject.totMthsContract__c) * 3;
        }
        if ((avgQtrlyProjectedAwardAmount > 0.00) && (totalObligationAmount > 0) ){           
           totalElapsedQtrsByObligation = Integer.valueOf(Math.ceil(totalObligationAmount / avgQtrlyProjectedAwardAmount));
        }   
        
        //System.debug('Projected Values function: '+totalElapsedQtrsByObligation);
        for (Integer i=1; i<=totalElapsedQtrsByObligation ; i++){
            cumulativeProjectedAmount = cumulativeProjectedAmount + avgQtrlyProjectedAwardAmount;
            if (i == totalElapsedQtrsByObligation){
            	returnList.add(Math.round(totalObligationAmount));
            } else {
            	returnList.add(Math.round(cumulativeProjectedAmount));
            }
            projectedPlotsCount++;
        }       
        //System.debug('Inside Projected Values function3:'+returnList.size());
        return returnList;
        
    }
    
    public List<String> getObligationValues(){
        List<String> returnList = new List<String>();
        List<String> xCatsList = new List<String>(getXcategories());
        Decimal cumulativeAmount = 0;
        String returnListStr = '';
        
        String currentFiscalQuarter = getCurrentFiscalQuarter(); 
        System.debug('Current Quarter Obligation: '+currentFiscalQuarter);
        for (String str: xCatsList ){
            String qtrYear = '';
            Boolean qtrFound = false;
                
            for (AggregateResult ar: finTxnList){
                qtrYear = ar.get('Fiscal_Quarter__c')+'/'+(String.valueOf(ar.get('Fiscal_Year__c'))).subString(2);
                qtrYear='\''+qtrYear+'\'';
                System.debug('Value From X-Cat: '+str);
                if (str.equalsIgnoreCase(qtrYear)){                   
                    cumulativeAmount = cumulativeAmount + (Decimal)ar.get('oblig_amt');                            
                }     
                returnListStr = '{y: '+ Math.round(cumulativeAmount) +  '}';            
            }            
            returnList.add(returnListStr);      
            if (str.equalsIgnoreCase(currentFiscalQuarter)){
                System.debug('Before Break');
                break;
            }
        }        
        return  returnList;
    }
    
    public List<String> getActualValues(){
        List<String> returnList = new List<String>();
        String returnListStr = '';
        Decimal cumulativeAmount = 0;
        Decimal totalObligAmount = 0.00;
        if (imObject.totObl__c  != null){
            totalObligAmount = (Decimal)imObject.totObl__c;
        }   
        Decimal totalDisbursementAmount = 0.00;
        if (imObject.totDisb__c != null){
            totalDisbursementAmount = (Decimal)imObject.totDisb__c;
        }   
        Integer totalMonthsElapsed = 0;
        if (imObject.totMthsElapsed__c != null){
            totalMonthsElapsed  = (Integer)imObject.totMthsElapsed__c;
        } 
        Decimal actualAvgBurnRate = 0;
        Integer totalfuturePoints = 0;
        Decimal futurePointAmount = 0;
        String imAwardRec = (String) imObject.Award_Key__c;
        System.debug('Actual Values function: '+imObject.Award_Key__c);
    
      
                                                                    
        List<String> xCatsList = new List<String>(getXcategories());
                                                                   
        System.debug('X-Cats List Size: '+xCatsList.size());                                                            
        System.debug('Actual Data List Size: '+finTxnList.size());
        
        String currentFiscalQuarter = getCurrentFiscalQuarter(); 
        System.debug('Current Quarter: '+currentFiscalQuarter);
        for (String str: xCatsList ){
            String qtrYear = '';
            Boolean qtrFound = false;
            if (fintxnMap.containsKey(str)){
                AggregateResult ar = fintxnMap.get(str);
                cumulativeAmount = cumulativeAmount + (Decimal)ar.get('disb_amt');              
            }  
            returnListStr = '{y: '+ Math.round(cumulativeAmount) +  '}';
            actualPlotsCount++;
            returnList.add(returnListStr);      
            if (str.equalsIgnoreCase(currentFiscalQuarter)){
                System.debug('Before Break');
                break;
            }
        }        
        
                                                                  
                                                          
        
        if (!finTxnList.isEmpty()){
            //actualAvgBurnRate = totalDisbursementAmount / finTxnList.size();
            if (totalMonthsElapsed == 0){
                actualAvgBurnRate = 0.00;
            }   else {
                actualAvgBurnRate = (totalDisbursementAmount / totalMonthsElapsed) * 3;
            }
        }   
    
        if (actualAvgBurnRate > 0){
            //totalfuturePoints = Integer.valueOf(Math.floor((totalObligAmount - totalDisbursementAmount )/ actualAvgBurnRate));
            totalfuturePoints = xCatsList.size() - actualPlotsCount;
            System.debug('Total actual burn rate points:' +totalfuturePoints);  
        }
        
        
        for (Integer i=1; i<=totalfuturePoints; i++){
            cumulativeAmount = cumulativeAmount + actualAvgBurnRate;
            if (cumulativeAmount <= totalObligAmount+actualAvgBurnRate ){
                returnListStr = '{y: '+ Math.round(cumulativeAmount) + ', marker: { symbol: \'triangle\', radius: 5, fillColor: \'red\'}}';
                // actualPlotsCount++;
                returnList.add(returnListStr);
            }   
        }
        
        return returnList;
    }
    
    public List<String> getXcategories(){
        List<String> returnList = new List<String>();
        Integer categoriesCount = 0;
        System.debug('Plot Counts: Actual' +actualPlotsCount +'Projected:' +projectedPlotsCount);
        if (actualPlotsCount > projectedPlotsCount){
            categoriesCount = actualPlotsCount;
        } else  {
            categoriesCount = projectedPlotsCount;
        }
    
        System.debug('Categories Count2' +categoriesCount );
    
        return getYearQuarters(imObject.Start_Date__c,imObject.End_Date__c);
    }
    
    private List<String> getYearQuarters(Date startDate, Date endDate){
        List<String> returnList = new List<String>();   
        Integer cQtr = 0;
        Integer cYear = 0;
        String cYearStr = String.valueOf(cYear);
        if (startDate != null && endDate!= null){
            cQtr = getQuarterNumberOfMonth(startDate.month());
            cYear = startDate.year();
            cYearStr = String.valueOf(cYear);      
            
            Integer monthsBetween = Integer.valueOf(imObject.totMthsContract__c);            
            Integer adjustedMonths = agjustMonthsByEndMonth(endDate.month(),agjustMonthsByStartMonth(startDate.month(),monthsBetween));
            System.debug('Adjusted Months:'+adjustedMonths); 
            for (Integer i=1;i<=adjustedMonths; i=i+3){         
                if (cQtr <= 4){
                    returnList.add('\''+'Q'+String.valueOf(cQtr)+'/'+cYearStr.substring(2)+'\'');               
                } else {
                    cQtr = 1;
                    cYear++;
                    cYearStr = String.valueOf(cYear );
                    returnList.add('\''+'Q'+String.valueOf(cQtr)+'/'+cYearStr.substring(2)+'\'');               
                }           
                cQtr++;
            }
        
    
        }
        return returnList;
    } 
    
    private String getCurrentFiscalQuarter(){
        Date currDate = Date.toDay();
        Integer currYear = currDate.year();
        Integer currMonth = currDate.month();
        
        String returnQtr = '';
        if (currDate.month() > 9){
            returnQtr = '\''+'Q1'+'/' + (String.valueOf(currYear+1)).subString(2)+'\'';         
        } else if (currDate.month() > 6 && currDate.month() <= 9){
            returnQtr = '\''+'Q4'+'/' + (String.valueOf(currYear)).subString(2)+'\'';           
        } else if (currDate.month() > 3 && currDate.month() <= 6){
            returnQtr = '\''+'Q3'+'/' + (String.valueOf(currYear)).subString(2)+'\'';           
        } else {
            returnQtr = '\''+'Q2'+'/' + (String.valueOf(currYear)).subString(2)+'\'';
        }
        
        return returnQtr;
    }
    
    private Integer getQuarterNumberOfMonth(Integer mth){
        Integer calQtr = 0;
        if (mth > 9){
            calQtr = 4;         
        } else if(mth <= 9 && mth > 6){
            calQtr = 3;         
        } else if (mth <= 6 && mth > 3){
            calQtr = 2;
        } else {
            calQtr = 1;
        }
        return calQtr;
    }
    
    
    private Integer agjustMonthsByStartMonth(Integer mth,Integer mthsBet){
        Integer returnVal =mthsBet;
        if ((mth == 10) || (mth == 1) || (mth == 4) || (mth == 7)){
            returnVal = returnVal + 0;
        } else if ((mth == 11) || (mth == 2) || (mth == 5) || (mth == 8)){
            returnVal = returnVal + 1;
        } else if ((mth == 12) || (mth == 3) || (mth == 6) || (mth == 8)){
            returnVal = returnVal + 2;
        }       
        return returnVal;       
    }
    
    private Integer agjustMonthsByEndMonth(Integer mth,Integer mthsBet){
        Integer returnVal =mthsBet;
        if ((mth == 10) || (mth == 1) || (mth == 4) || (mth == 7)){
            returnVal = returnVal + 2;
        } else if ((mth == 11) || (mth == 2) || (mth == 5) || (mth == 8)){
            returnVal = returnVal + 1;
        } else if ((mth == 12) || (mth == 3) || (mth == 6) || (mth == 8)){
            returnVal = returnVal + 0;
        }       
        return returnVal;       
    }
}