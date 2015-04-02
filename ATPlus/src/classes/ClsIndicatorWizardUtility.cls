public with sharing class ClsIndicatorWizardUtility {
    clsGlobalUtility GU = new clsGlobalUtility();
    Map<String, Framework__c> fMap = new Map<String, Framework__c>();
    Map<String, USAID_Indicator__c> uMap = new Map<String, USAID_Indicator__c>();
    Map<String,List<USAID_Indicator__c>> uMapByElements = new Map<String,List<USAID_Indicator__c>>();
    Map<String,List<USAID_Indicator__c>> uMapByIndicators = new Map<String,List<USAID_Indicator__c>>();
    Map<String, OrgUnit_Indicator__c> oMap = new Map<String, OrgUnit_Indicator__c>();
    Map<String, OrgUnit_Indicator__c> oMMap = new Map<String, OrgUnit_Indicator__c>();
    Map<String, Indicator_Results__c> rMap = new Map<String, Indicator_Results__c>();
    //public boolean isPartnerProfileUser;
    public boolean isPLTProfileUser;
    //public boolean isSTDProfileUser;
    //public boolean isADMINProfileUser;
    public boolean isPLTMissionUser;
    public boolean isPLTReadOnlyUser;
    //public boolean isPLTUser;
    //public boolean isSTDAidtrackSupportUser;
    //public boolean isSTDAidtrackSupReadOnlyUser;
    //public boolean isSTDEditOnlyCustomUser;
    //public boolean isSTDEditOnlyCustomTaskUser;
    //public boolean isSTDMissionProfileUser;
    //public boolean isSTDReadOnlyUser;
    public boolean isMissionPartnerUser;
    
    Xmlstreamwriter xmlW = new Xmlstreamwriter();
    
    
    /* Cunstructor
    */
    public void ClsIndicatorWizardUtility(){
                          
    }
    
    /* This method takes Framework Code and Framework Level and returns
        List of child Frameworks for that Framework code(fCode).
    */
    public Map<String, List<Framework__c>> getFrameworkByPrCode(String fCode, String fLevel){       
        List<Framework__c> fList = new List<Framework__c>();
        for(Framework__c fWork: fMap.values()){
            if(fLevel.equalsIgnoreCase('Program Area')){
                if(fCode.equalsIgnoreCase((String)fWork.poCode__c) && fWork.paCode__c != null && fWork.peCode__c == null && fWork.seCode__c == null){
                    fList.add(fWork);
                }   
            } else if(fLevel.equalsIgnoreCase('Program Element')){
                if(fCode.equalsIgnoreCase((String)fWork.paCode__c) && fWork.paCode__c != null && fWork.peCode__c != null && fWork.seCode__c == null){
                    fList.add(fWork);
                }               
            } else if(fLevel.equalsIgnoreCase('Program Sub Element')){
                if(fCode.equalsIgnoreCase((String)fWork.peCode__c) && fWork.paCode__c != null && fWork.peCode__c != null && fWork.seCode__c != null){
                    fList.add(fWork);
                }               
            }           
        }
        Map<String, List<Framework__c>> selFrameWorks = new Map<String,List<Framework__c>>();
        selFrameWorks.put(fCode,fList);
        return selFrameWorks;       
    }
    
    /* This method takes the Program Code and Indicator Level to provide list of Indicators for a
        Program category or List of sub Indicators for an Indicator provided.   
    */  
    public Map<String, List<USAID_Indicator__c>> getUSAIDIndsByPrCode(String fCode, String fLevel){  
        Map<String, List<USAID_Indicator__c>> uIndicators = new Map<String, List<USAID_Indicator__c>>();
        List<USAID_Indicator__c> uList = new List<USAID_Indicator__c>();
        
       /* for(USAID_Indicator__c uIndicator: uMap.values()){          
            if(fLevel.equalsIgnoreCase('Indicator')){
                if (fCode.equalsIgnoreCase((String)uIndicator.prCode__c)){
                    if(uIndicator.sIndCode__c == null){
                        uList.add(uIndicator);
                    }   
                }   
            } else if(fLevel.equalsIgnoreCase('Sub Indicator')){
                if (fCode.equalsIgnoreCase((String)uIndicator.indCode__c)){
                    if(uIndicator.sIndCode__c != null){
                        uList.add(uIndicator);
                    }               
                }   
            }                               
        } */
        
         if(fLevel.equalsIgnoreCase('Indicator')){
            if (uMapByElements.containsKey(fCode)){
                uList = uMapByElements.get(fCode);
            }
        } else if(fLevel.equalsIgnoreCase('Sub Indicator')){
            if (uMapByIndicators.containsKey(fCode)){
                uList = uMapByIndicators.get(fCode);
            }
        }
        
        uIndicators.put(fCode,uList);
        system.debug('UIndicators before return for f Code::: ' +fCode +' ::::' +uIndicators);
        return uIndicators;
    }
    
    
    public Boolean isIndicatorResultExists(String ouIndRecId, String recTypeId, String fCode, String fLevel){       
        String recTypeName = GU.getRecordType('OrgUnit_Indicator__c',recTypeId);
        Map<String, Indicator_Results__c> iResults = getIndResultsWithOUIndIdAsKey();
        if(recTypeName.equalsIgnoreCase('Master')){
            Map<String, OrgUnit_Indicator__c> childOUIndicators = getOUIndsWithMasterIdByprCodeAndLevel(fCode,fLevel);
            if(childOUIndicators.containsKey(ouIndRecId)){
                OrgUnit_Indicator__c childOUInd = childOUIndicators.get(ouIndRecId);
                return iResults.containsKey(childOUInd.Id);
            }
        } else {            
            return iResults.containsKey(ouIndRecId);            
        }
        
        return false;
    }
    
    public void profileFinder(){
    
      isMissionPartnerUser = GU.isMissionPartnerUser();
      isPLTProfileUser = GU.isPLTProfileUser();
      isPLTMissionUser = GU.isPLTMissionUser();
      isPLTReadOnlyUser = GU.isPLTReadOnlyUser();
    }
    public void initializeXML(){
        xmlW.writeStartDocument('UTF-8','1.0');
        xmlW.writeStartElement(null,'rows', null);
        xmlW.writeAttribute(null,null,'id','0');
    }
    
    public void getCustomXMLString(String treeLevel,OrgUnit_Indicator__c OInd){
        xmlW.writeStartElement(null,'row',null);
        if (treeLevel.equalsIgnoreCase('Indicator') || treeLevel.equalsIgnoreCase('Custom Indicator')){ 
                xmlW.writeAttribute(null,null,'id','I'+OInd.Id);
            } else {
                xmlW.writeAttribute(null,null,'id','S'+OInd.Id);
            }
        xmlW.writeAttribute(null,null,'locked','1');
        xmlW.writeStartElement(null,'cell',null);
        if(treeLevel.equalsIgnoreCase('Custom Indicator')){
            xmlW.writeAttribute(null,null,'image','custom-indicator.png');
            xmlW.writeAttribute(null,null,'Id',OInd.indCode__c);
            xmlW.writeCharacters('&nbsp'+OInd.indCode__c);
        } else if(treeLevel.equalsIgnoreCase('Indicator')){
            xmlW.writeAttribute(null,null,'image','indicator.png');
            xmlW.writeAttribute(null,null,'Id',OInd.indCode__c);
            xmlW.writeCharacters('&nbsp'+OInd.indCode__c);
        } else if(treeLevel.equalsIgnoreCase('Custom Sub Indicator')){
            xmlW.writeAttribute(null,null,'image','custom-sub-indicator.png');
            xmlW.writeAttribute(null,null,'Id',OInd.sindCode__c);
            xmlW.writeCharacters('&nbsp'+OInd.sindCode__c);
        } else if(treeLevel.equalsIgnoreCase('Sub Indicator')){
            xmlW.writeAttribute(null,null,'image','sub-indicator.png');
            xmlW.writeAttribute(null,null,'Id',OInd.sindCode__c);
            xmlW.writeCharacters('&nbsp'+OInd.sindCode__c);
        } 
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        if(treeLevel.equalsIgnoreCase('Indicator') || treeLevel.equalsIgnoreCase('Custom Indicator')){
            if (OInd.indName__c.length() != 0){
                xmlW.writeCharacters(OInd.indName__c);
             }
        } else if(treeLevel.equalsIgnoreCase('Sub Indicator') || treeLevel.equalsIgnoreCase('Custom Sub Indicator')){    
            if (OInd != null && OInd.sindName__c.length() != 0){
                xmlW.writeCharacters(OInd.sindName__c);
             }
        }
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        if (OInd.indDataType__c != null){
            xmlw.writeCharacters(OInd.indDataType__c);
        }            
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        if (OInd.indType1__c != null){
            xmlw.writeCharacters(OInd.indType1__c);
        }            
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        if (OInd.USAID_Tags__c != null){
            xmlw.writeCharacters(OInd.USAID_Tags__c);
        }            
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        if (OInd.User_Defined_Tags__c != null){
            xmlw.writeCharacters(OInd.User_Defined_Tags__c);
        }            
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        if (OInd.PPR__c){
                xmlw.writeCharacters('true');
        }             
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        if (OInd.Custom__c){
                xmlw.writeCharacters('true');
        }             
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        if (OInd.isActive__c){
                xmlw.writeCharacters('true');
        }             
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        if (OInd!= null && OInd.Source__c != null){
            if(OInd.Source__c == 'STANDARD'){ 
                xmlw.writeCharacters('1');
            } else if(OInd.Source__c == 'FTF'){ 
                xmlw.writeCharacters('2');
            } else if(OInd.Source__c == 'PEPFAR'){ 
                xmlw.writeCharacters('3');
            }
         }
        xmlW.writeEndElement();        
    }
    
    
    public void getCustomXMLString1(String treeLevel,OrgUnit_Indicator__c OInd){
        xmlW.writeStartElement(null,'row',null);
        if (treeLevel.equalsIgnoreCase('Indicator') || treeLevel.equalsIgnoreCase('Custom Indicator')){ 
                xmlW.writeAttribute(null,null,'id','I'+OInd.Id);
            } else {
                xmlW.writeAttribute(null,null,'id','S'+OInd.Id);
            }
        xmlW.writeAttribute(null,null,'locked','1');
        xmlW.writeStartElement(null,'cell',null);
        if(treeLevel.equalsIgnoreCase('Custom Indicator')){
            xmlW.writeAttribute(null,null,'image','custom-indicator.png');
            xmlW.writeAttribute(null,null,'Id',OInd.indCode__c);
            xmlW.writeCharacters('&nbsp<a style="color:blue;" href=/apex/vfIndicatorFactsheet?id='+Oind.id+'>'+OInd.indCode__c+'</a>');
        } else if(treeLevel.equalsIgnoreCase('Indicator')){
            xmlW.writeAttribute(null,null,'image','indicator.png');
            xmlW.writeAttribute(null,null,'Id',OInd.indCode__c);
            xmlW.writeCharacters('&nbsp<a style="color:blue;" href=/apex/vfIndicatorFactsheet?id='+Oind.id+'>'+OInd.indCode__c+'</a>');
        } else if(treeLevel.equalsIgnoreCase('Custom Sub Indicator')){
            xmlW.writeAttribute(null,null,'image','custom-sub-indicator.png');
            xmlW.writeAttribute(null,null,'Id',OInd.sindCode__c);
            xmlW.writeCharacters('&nbsp<a style="color:blue;" href=/apex/vfIndicatorFactsheet?id='+Oind.id+'>'+OInd.sindCode__c+'</a>');
        } else if(treeLevel.equalsIgnoreCase('Sub Indicator')){
            xmlW.writeAttribute(null,null,'image','sub-indicator.png');
            xmlW.writeAttribute(null,null,'Id',OInd.sindCode__c);
            xmlW.writeCharacters('&nbsp<a style="color:blue;" href=/apex/vfIndicatorFactsheet?id='+Oind.id+'>'+OInd.sindCode__c+'</a>');
        } 
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        if(treeLevel.equalsIgnoreCase('Indicator') || treeLevel.equalsIgnoreCase('Custom Indicator')){
            if (OInd.indName__c.length() != 0){
                xmlW.writeCharacters(OInd.indName__c);
             }
        } else if(treeLevel.equalsIgnoreCase('Sub Indicator') || treeLevel.equalsIgnoreCase('Custom Sub Indicator')){    
            if (OInd.sindName__c.length() != 0){
                xmlW.writeCharacters(OInd.sindName__c);
             }
        }
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        if (OInd.IM_Indicators_Established__c == true){
            xmlw.writeCharacters('true');
        }            
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        if (OInd.RF_Indicators_Established__c == true){
            xmlw.writeCharacters('true');
        }            
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        if (OInd.LF_Indicators_Established__c == true){
            xmlw.writeCharacters('true');
        }            
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        if(treeLevel.equalsIgnoreCase('Indicator') || treeLevel.equalsIgnoreCase('Custom Indicator')){
            xmlW.writeCharacters('&nbsp'+OInd.indCode__c);
        } else if(treeLevel.equalsIgnoreCase('Sub Indicator') || treeLevel.equalsIgnoreCase('Custom Sub Indicator')){    
            xmlW.writeCharacters('&nbsp'+OInd.sindCode__c);
        }
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        if (OInd!= null && OInd.Source__c != null){
            if(OInd.Source__c == 'STANDARD'){ 
                xmlw.writeCharacters('1');
            } else if(OInd.Source__c == 'FTF'){ 
                xmlw.writeCharacters('2');
            } else if(OInd.Source__c == 'PEPFAR'){ 
                xmlw.writeCharacters('3');
            }
         }
        xmlW.writeEndElement();
       /* string whereUsed = '';
        if (OInd.IM_Indicators_Established__c){
            whereUsed = 'IM';
        }
        if (OInd.RF_Indicators_Established__c){
            if ('' == whereUsed || null == whereUsed){
                whereUsed = 'RF';
            } else {
                whereUsed = whereUsed+ ', RF';
            }    
        }
        if (OInd.LF_Indicators_Established__c){
            if ('' == whereUsed || null == whereUsed){
                whereUsed = 'LF';
            } else {
                whereUsed = whereUsed+ ', LF';
            }    
        }
        xmlW.writeStartElement(null,'cell',null);
        xmlW.writeCharacters(whereUsed);
        xmlW.writeEndElement(); */
                
    }
    
    
    public void getXMLString(String treeLevel,String programLevel,String fId,String fCode, 
                                                String fName, USAID_Indicator__c uInd, String uTag, 
                                                Boolean rowLock, Boolean preSelected, Boolean pprFlag, 
                                                Boolean activeFlag,Boolean customFlag, String dataType, String indType){
        if(treeLevel.equalsIgnoreCase('Framework')){
            xmlW.writeStartElement(null,'row',null); 
            xmlW.writeAttribute(null,null,'id','F'+fId);
            xmlW.writeAttribute(null,null,'locked','1');            
            if (programLevel.equalsIgnoreCase('Program Objective')){
                xmlW.writeAttribute(null,null,'open','1');
            }
            xmlW.writeStartElement(null,'cell',null);
            xmlW.writeAttribute(null,null,'Id',fCode);            
            if (programLevel.equalsIgnoreCase('Program Objective')){
                xmlW.writeAttribute(null,null,'image','po.png');
                xmlW.writeAttribute(null,null,'open','0');
            }   else if(programLevel.equalsIgnoreCase('Program Area')){
                xmlW.writeAttribute(null,null,'image','pa.png');
            }   else if(programLevel.equalsIgnoreCase('Program Element')){
                xmlW.writeAttribute(null,null,'image','pe.png');
            }   else if(programLevel.equalsIgnoreCase('Program Sub Element')){
                xmlW.writeAttribute(null,null,'image','pse.png');
            }    
            xmlw.writeCharacters('&nbsp'+fCode);        
            xmlW.writeEndElement();
            xmlW.writeStartElement(null,'cell',null); 
            xmlW.writeAttribute(null,null,'type','ro');           
            xmlw.writeCharacters(fName);
            xmlW.writeEndElement();
            xmlW.writeStartElement(null,'cell',null);
            xmlW.writeEndElement();
            xmlW.writeStartElement(null,'cell',null);
            xmlW.writeEndElement();
            xmlW.writeStartElement(null,'cell',null);
            xmlW.writeEndElement();
        } else {
            xmlW.writeStartElement(null,'row',null);
            if (treeLevel.equalsIgnoreCase('Indicator') || treeLevel.equalsIgnoreCase('Custom Indicator')){
                xmlW.writeAttribute(null,null,'id','I'+fId);
            } else {
                xmlW.writeAttribute(null,null,'id','S'+fId);
            }   
            xmlW.writeStartElement(null,'cell',null);
            if (treeLevel.equalsIgnoreCase('Indicator')){
                xmlW.writeAttribute(null,null,'image','indicator.png'); 
            } else if(treeLevel.equalsIgnoreCase('Sub Indicator')){
                xmlW.writeAttribute(null,null,'image','sub-indicator.png');
            } else if(treeLevel.equalsIgnoreCase('Custom Indicator')){
                xmlW.writeAttribute(null,null,'image','custom-indicator.png');
            } else if(treeLevel.equalsIgnoreCase('Custom Sub Indicator')){
                xmlW.writeAttribute(null,null,'image','custom-sub-indicator.png');
            }                   
            xmlW.writeAttribute(null,null,'Id',fCode);            
            xmlW.writeCharacters('&nbsp'+fCode);
            xmlW.writeEndElement();
            xmlW.writeStartElement(null,'cell',null);
            //xmlW.writeAttribute(null,null,'type','ro');
            if(rowLock ||(!(treeLevel.equalsIgnoreCase('Custom Sub Indicator')) && !(treeLevel.equalsIgnoreCase('Custom Indicator')))){
                xmlW.writeAttribute(null,null,'type','ro');
            }
            if (fName.length() != 0){
                xmlW.writeCharacters(fName);
             }
            xmlW.writeEndElement();
            
            xmlW.writeStartElement(null,'cell',null);
            if (uInd != null && uInd.USAID_Tags__c != null){
                xmlw.writeCharacters(uInd.USAID_Tags__c);
             }
            xmlW.writeEndElement();
            
            xmlW.writeStartElement(null,'cell',null);
            if (uTag != null){
                xmlw.writeCharacters(uTag);
            }
            xmlW.writeEndElement();
            xmlW.writeStartElement(null,'cell',null);
            system.debug('Tree Level::::'+treeLevel+':::Row Lock Value:::'+rowLock);
            if(rowLock || (!(treeLevel.equalsIgnoreCase('Custom Sub Indicator')) && !(treeLevel.equalsIgnoreCase('Custom Indicator')))){
                  xmlW.writeAttribute(null,null,'type','ro');
            }
            if (dataType != null){
                xmlw.writeCharacters(dataType);
            } 
            xmlW.writeEndElement();
            xmlW.writeStartElement(null,'cell',null);
            if(rowLock || (!(treeLevel.equalsIgnoreCase('Custom Sub Indicator')) && !(treeLevel.equalsIgnoreCase('Custom Indicator')))){
                  xmlW.writeAttribute(null,null,'type','ro');
            }
            if (indType != null){
                xmlw.writeCharacters(indType);
            }
            xmlW.writeEndElement();
            xmlW.writeStartElement(null,'cell',null);
            if (pprFlag){
                xmlw.writeCharacters('true');
            }   
            xmlW.writeEndElement();
            xmlW.writeStartElement(null,'cell',null);
                if (activeFlag){
                    xmlw.writeCharacters('true');
                }
            xmlW.writeEndElement();
            xmlW.writeStartElement(null,'cell',null);
            xmlW.writeAttribute(null,null,'disabled','true');
                if (customFlag){
                    xmlw.writeCharacters('true');
                }
            xmlW.writeEndElement();
            xmlW.writeStartElement(null,'cell',null);
            if (preSelected){
                if (rowLock) {
                    xmlW.writeAttribute(null,null,'disabled','true');
                    xmlw.writeCharacters('true');
                } else {
                    xmlw.writeCharacters('true');
                }   
            }
            xmlW.writeEndElement(); 
            
            
        } 
    }
    
public void getTargetsXMLString(String treeLevel, OrgUnit_Indicator__c oInd, Indicator_Results__c iResult,
                                LF_Indicator_Result__c lfiResult, RF_Indicator_Result__c rfiResult, String resultType, String profileName){
        xmlW.writeStartElement(null,'row',null);
        if (treeLevel.equalsIgnoreCase('Indicator')){ 
            xmlW.writeAttribute(null,null,'id',oInd.Id);
        } else {
            xmlW.writeAttribute(null,null,'id',oInd.Id);
        }
        xmlW.writeStartElement(null,'cell',null);
        if (treeLevel.equalsIgnoreCase('Indicator')){
            xmlW.writeAttribute(null,null,'image','indicator.png');
            xmlW.writeAttribute(null,null,'Id',oInd.indCode__c);
            xmlW.writeCharacters('&nbsp&nbsp&nbsp'+oInd.indCode__c);    
        } else if(treeLevel.equalsIgnoreCase('Sub Indicator')){
            xmlW.writeAttribute(null,null,'image','sub-indicator.png');
            xmlW.writeAttribute(null,null,'Id',oInd.sindCode__c);
            xmlW.writeCharacters('&nbsp&nbsp&nbsp'+oInd.sindCode__c);
        } else if(treeLevel.equalsIgnoreCase('Custom Indicator')){
            xmlW.writeAttribute(null,null,'image','custom-indicator.png');
            xmlW.writeAttribute(null,null,'Id',oInd.indCode__c);
            xmlW.writeCharacters('&nbsp&nbsp&nbsp'+oInd.indCode__c);
        } else if(treeLevel.equalsIgnoreCase('Custom Sub Indicator')){
            xmlW.writeAttribute(null,null,'image','custom-sub-indicator.png');
            xmlW.writeAttribute(null,null,'Id',oInd.sindCode__c);
            xmlW.writeCharacters('&nbsp&nbsp&nbsp'+oInd.sindCode__c);
        }           
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        if (treeLevel.equalsIgnoreCase('Indicator') || treeLevel.equalsIgnoreCase('Custom Indicator') ){
            xmlW.writeCharacters(oInd.indName__c);
        } else if(treeLevel.equalsIgnoreCase('Sub Indicator') || treeLevel.equalsIgnoreCase('Custom Sub Indicator')){ 
            xmlW.writeCharacters(oInd.sindName__c);
        }
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        if (resultType.equalsIgnoreCase('Reporting_Period__c')){
            //if (profileName == 'Mission Partner' || (iResult != null && (iResult.Status__c == 'Submitted' || iResult.Status__c == 'Publish'))){ 
            //if (GU.isMissionPartnerUser() || (iResult != null && (iResult.Status__c == 'Submitted' || iResult.Status__c == 'Publish'))){   
            if (isPLTReadOnlyUser || isMissionPartnerUser || (iResult != null && (iResult.Status__c == 'Submitted' || iResult.Status__c == 'Publish'))){   
                xmlW.writeAttribute(null,null,'type','ro');
            } else {
                xmlW.writeAttribute(null,null,'style','border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;'); 
            }
            if (iResult != null && iResult.Baseline__c != null){
                xmlw.writeCharacters(String.valueOf(iResult.Baseline__c));
            }   
        } else if (resultType.equalsIgnoreCase('LF_Reporting_Period__c')){
            if (isPLTReadOnlyUser){
                xmlW.writeAttribute(null,null,'type','ro');
            } else {
                xmlW.writeAttribute(null,null,'style','border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;');
            }    
            if (lfiResult != null && lfiResult.Baseline__c != null){
                xmlw.writeCharacters(String.valueOf(lfiResult.Baseline__c));
            }
        } else if (resultType.equalsIgnoreCase('RF_Reporting_Period__c')){
            if (isPLTReadOnlyUser){
                xmlW.writeAttribute(null,null,'type','ro');
            } else {
                xmlW.writeAttribute(null,null,'style','border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;');
            }    
            if (rfiResult != null && rfiResult.Baseline__c != null){
                xmlw.writeCharacters(String.valueOf(rfiResult.Baseline__c));
            }
        }
         
        xmlW.writeEndElement();
        
        xmlW.writeStartElement(null,'cell',null);
        if (resultType.equalsIgnoreCase('Reporting_Period__c')){
            //if (profileName == 'Mission Partner' || (iResult != null && (iResult.Status__c == 'Submitted' || iResult.Status__c == 'Publish'))){
            //if (GU.isMissionPartnerUser() || (iResult != null && (iResult.Status__c == 'Submitted' || iResult.Status__c == 'Publish'))){    
            if (isPLTReadOnlyUser || isMissionPartnerUser || (iResult != null && (iResult.Status__c == 'Submitted' || iResult.Status__c == 'Publish'))){    
                xmlW.writeAttribute(null,null,'type','ro');
            } else {
                xmlW.writeAttribute(null,null,'style','border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;'); 
            }
            if (iResult != null && iResult.Target__c != null){
                xmlw.writeCharacters(String.valueOf(iResult.Target__c));
            }
        } else if (resultType.equalsIgnoreCase('LF_Reporting_Period__c')){
            if (isPLTReadOnlyUser){
                xmlW.writeAttribute(null,null,'type','ro');
            } else {
                xmlW.writeAttribute(null,null,'style','border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;');
            }
            if (lfiResult != null && lfiResult.Target__c != null){
                xmlw.writeCharacters(String.valueOf(lfiResult.Target__c));
            }
        } else if (resultType.equalsIgnoreCase('RF_Reporting_Period__c')){
            if (isPLTReadOnlyUser){
                xmlW.writeAttribute(null,null,'type','ro');
            } else {
                xmlW.writeAttribute(null,null,'style','border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;');
            }
            if (rfiResult != null && rfiResult.Target__c != null){
                xmlw.writeCharacters(String.valueOf(rfiResult.Target__c));
            }
        }
         
        xmlW.writeEndElement();
        
        xmlW.writeStartElement(null,'cell',null);
        if (resultType.equalsIgnoreCase('Reporting_Period__c')){
            if (iResult != null && (iResult.Status__c == 'Submitted' || iResult.Status__c == 'Publish' || isPLTReadOnlyUser || isPLTMissionUser)){ 
                xmlW.writeAttribute(null,null,'type','ro');
            } else {
                xmlW.writeAttribute(null,null,'style','border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;');
            }
            if (iResult != null && iResult.Actual__c != null){
                xmlw.writeCharacters(String.valueOf(iResult.Actual__c));
            }
        } else if (resultType.equalsIgnoreCase('LF_Reporting_Period__c')){
            if (isPLTReadOnlyUser){
                xmlW.writeAttribute(null,null,'type','ro');
            } else {
                xmlW.writeAttribute(null,null,'style','border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;');
            }
            if (lfiResult != null && lfiResult.Actual__c != null){
                xmlw.writeCharacters(String.valueOf(lfiResult.Actual__c));
            }
        } else if (resultType.equalsIgnoreCase('RF_Reporting_Period__c')){
            if (isPLTReadOnlyUser){
                xmlW.writeAttribute(null,null,'type','ro');
            } else {
                xmlW.writeAttribute(null,null,'style','border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;');
            }
            if (rfiResult != null && rfiResult.Actual__c != null){
                xmlw.writeCharacters(String.valueOf(rfiResult.Actual__c));
            }
        }
        xmlW.writeEndElement();
        
        xmlW.writeStartElement(null,'cell',null);
        if (resultType.equalsIgnoreCase('Reporting_Period__c')){
            if (iResult != null && iResult.Variance__c != null){
                    xmlw.writeCharacters(String.valueOf(iResult.Variance__c));
            }   
        } else if (resultType.equalsIgnoreCase('LF_Reporting_Period__c')){
            if (lfiResult != null && lfiResult.Variance__c != null){
                xmlw.writeCharacters(String.valueOf(lfiResult.Variance__c));
            }
        } else if (resultType.equalsIgnoreCase('RF_Reporting_Period__c')){
            if (rfiResult != null && rfiResult.Variance__c != null){
                xmlw.writeCharacters(String.valueOf(rfiResult.Variance__c));
            }
        }
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        if (resultType.equalsIgnoreCase('Reporting_Period__c')){
            if (iResult != null && iResult.Rating__c != null){
                xmlw.writeCharacters(String.valueOf(iResult.Rating__c));
            }   
        } else if (resultType.equalsIgnoreCase('LF_Reporting_Period__c')){
            if (lfiResult != null && lfiResult.Rating__c != null){
                xmlw.writeCharacters(String.valueOf(lfiResult.Rating__c));
            }
        } else if (resultType.equalsIgnoreCase('RF_Reporting_Period__c')){
            if (rfiResult != null && rfiResult.Rating__c != null){
                xmlw.writeCharacters(String.valueOf(rfiResult.Rating__c));
            }
        }
        xmlW.writeEndElement();
        
        xmlW.writeStartElement(null,'cell',null);
        if (resultType.equalsIgnoreCase('Reporting_Period__c')){
            //if ( profileName != 'Mission Partner' || (iResult != null && (iResult.Status__c == 'Submitted' || iResult.Status__c == 'Publish'))){
            //if ( GU.isMissionPartnerUser()==false || (iResult != null && (iResult.Status__c == 'Submitted' || iResult.Status__c == 'Publish'))){  
            if (isPLTReadOnlyUser || isMissionPartnerUser == false || (iResult != null && (iResult.Status__c == 'Submitted' || iResult.Status__c == 'Publish'))){  
                xmlW.writeAttribute(null,null,'type','ro');
            } else {
                xmlW.writeAttribute(null,null,'style','border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;'); 
            }
            if (iResult != null && iResult.Notes_Comments_Partner__c != null && iResult.Notes_Comments_Partner__c != ''){
                xmlw.writeCharacters(String.valueOf(iResult.Notes_Comments_Partner__c));
            }
        }
        xmlW.writeEndElement();
        
        xmlW.writeStartElement(null,'cell',null);
        if (resultType.equalsIgnoreCase('Reporting_Period__c')){
            //if (profileName == 'Mission Partner' || (iResult != null && (iResult.Status__c == 'Submitted' || iResult.Status__c == 'Publish'))){ 
            //if (GU.isMissionPartnerUser() || (iResult != null && (iResult.Status__c == 'Submitted' || iResult.Status__c == 'Publish'))){   
            if (isPLTReadOnlyUser || isMissionPartnerUser || (iResult != null && (iResult.Status__c == 'Submitted' || iResult.Status__c == 'Publish'))){   
                xmlW.writeAttribute(null,null,'type','ro');
            } else {
                xmlW.writeAttribute(null,null,'style','border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;'); 
            }
            if (iResult != null && iResult.Note_Comments__c != null && iResult.Note_Comments__c != ''){
                xmlw.writeCharacters(String.valueOf(iResult.Note_Comments__c));
            }   
        } else if (resultType.equalsIgnoreCase('LF_Reporting_Period__c')){
            if (isPLTReadOnlyUser){
                xmlW.writeAttribute(null,null,'type','ro');
            } else {
                xmlW.writeAttribute(null,null,'style','border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;');
            }
            if (lfiResult != null && lfiResult.Note_Comments__c != null && lfiResult.Note_Comments__c != ''){
                xmlw.writeCharacters(String.valueOf(lfiResult.Note_Comments__c));
            }
        } else if (resultType.equalsIgnoreCase('RF_Reporting_Period__c')){
            if (isPLTReadOnlyUser){
                xmlW.writeAttribute(null,null,'type','ro');
            } else {
                xmlW.writeAttribute(null,null,'style','border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;');
            }
            if (rfiResult != null && rfiResult.Note_Comments__c != null && rfiResult.Note_Comments__c != ''){
                xmlw.writeCharacters(String.valueOf(rfiResult.Note_Comments__c));
            }
        }
        xmlW.writeEndElement();
                
        xmlW.writeStartElement(null,'cell',null);
        if (oInd != null && oInd.Source__c != null){
            if(oInd.Source__c == 'STANDARD'){ 
                xmlw.writeCharacters('1');
            } else if(oInd.Source__c == 'FTF'){ 
                xmlw.writeCharacters('2');
            } else if(oInd.Source__c == 'PEPFAR'){ 
                xmlw.writeCharacters('3');
            }
         }
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        if (oInd != null && oInd.indDataType__c != null){
            xmlw.writeCharacters(oInd.indDataType__c);
         }
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        if (oInd != null && oInd.indDataMax__c != null){
            xmlw.writeCharacters(oInd.indDataMax__c);
         }
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        if (oInd != null && oInd.indDataMin__c != null){
            xmlw.writeCharacters(oInd.indDataMin__c);
         }
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        //system.debug('Test::::'+oInd.UOM__c);
         if (oInd != null && oInd.UOM__c != null){
            //system.debug('Test::::'+String.valueOf(oInd.UOM__c));
            xmlw.writeCharacters(oInd.UOM__c);
         }
        xmlW.writeEndElement();
    }
    
    public void getTargetsXMLString(String treeLevel, OrgUnit_Indicator__c oInd, Indicator_Results__c iResult,
                                LF_Indicator_Result__c lfiResult, RF_Indicator_Result__c rfiResult, String resultType, String profileName, Reporting_Period__c rResult){
        xmlW.writeStartElement(null,'row',null);
        if (treeLevel.equalsIgnoreCase('Indicator')){ 
            xmlW.writeAttribute(null,null,'id',oInd.Id);
        } else {
            xmlW.writeAttribute(null,null,'id',oInd.Id);
        }
        xmlW.writeStartElement(null,'cell',null);
        xmlW.writeAttribute(null,null,'name','Indicator');
        if (treeLevel.equalsIgnoreCase('Indicator')){
            xmlW.writeAttribute(null,null,'image','indicator.png');
            xmlW.writeAttribute(null,null,'Id',oInd.indCode__c);
            xmlW.writeCharacters('&nbsp&nbsp&nbsp'+oInd.indCode__c);    
        } else if(treeLevel.equalsIgnoreCase('Sub Indicator')){
            xmlW.writeAttribute(null,null,'image','sub-indicator.png');
            xmlW.writeAttribute(null,null,'Id',oInd.sindCode__c);
            xmlW.writeCharacters('&nbsp&nbsp&nbsp'+oInd.sindCode__c);
        } else if(treeLevel.equalsIgnoreCase('Custom Indicator')){
            xmlW.writeAttribute(null,null,'image','custom-indicator.png');
            xmlW.writeAttribute(null,null,'Id',oInd.indCode__c);
            xmlW.writeCharacters('&nbsp&nbsp&nbsp'+oInd.indCode__c);
        } else if(treeLevel.equalsIgnoreCase('Custom Sub Indicator')){
            xmlW.writeAttribute(null,null,'image','custom-sub-indicator.png');
            xmlW.writeAttribute(null,null,'Id',oInd.sindCode__c);
            xmlW.writeCharacters('&nbsp&nbsp&nbsp'+oInd.sindCode__c);
        }           
        xmlW.writeEndElement();
        system.debug('isMissionPartnerUser =  '+isMissionPartnerUser);
        system.debug('isPLTProfileUser =  '+isPLTProfileUser);
        xmlW.writeStartElement(null,'cell',null);
        xmlW.writeAttribute(null,null,'name','IndicatorName');
        if (treeLevel.equalsIgnoreCase('Indicator') || treeLevel.equalsIgnoreCase('Custom Indicator') ){
            xmlW.writeCharacters(oInd.indName__c);
        } else if(treeLevel.equalsIgnoreCase('Sub Indicator') || treeLevel.equalsIgnoreCase('Custom Sub Indicator')){ 
            xmlW.writeCharacters(oInd.sindName__c);
        }
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        xmlW.writeAttribute(null,null,'name','Baseline');
        if (resultType.equalsIgnoreCase('Reporting_Period__c')){
            //if (rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed' || profileName == 'Mission Partner'){
            //if (rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed' || GU.isMissionPartnerUser()){    
            if (rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed' || isMissionPartnerUser || isPLTReadOnlyUser){    
                xmlW.writeAttribute(null,null,'type','ro');
            } else {
                xmlW.writeAttribute(null,null,'style','border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;'); 
            }
            if (iResult != null && iResult.Baseline__c != null){
                xmlw.writeCharacters(String.valueOf(iResult.Baseline__c));
            }   
        }          
        xmlW.writeEndElement();
        system.debug('isMissionPartnerUser =  '+isMissionPartnerUser);
        system.debug('isPLTProfileUser =  '+isPLTProfileUser);
        xmlW.writeStartElement(null,'cell',null);
        xmlW.writeAttribute(null,null,'name','Target');
        if (resultType.equalsIgnoreCase('Reporting_Period__c')){
            //if (profileName == 'Mission Partner' || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed'){  
            //if (GU.isMissionPartnerUser() || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed'){ 
            system.debug('isMissionPartnerUser =  '+isMissionPartnerUser); 
            if (isPLTReadOnlyUser || isMissionPartnerUser || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed'){  
                xmlW.writeAttribute(null,null,'type','ro');
            } else {
                xmlW.writeAttribute(null,null,'style','border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;'); 
            }
            if (iResult != null && iResult.Target__c != null){
                xmlw.writeCharacters(String.valueOf(iResult.Target__c));
            }
        }          
        xmlW.writeEndElement();
        
        xmlW.writeStartElement(null,'cell',null);
        xmlW.writeAttribute(null,null,'name','Actual');
        if (resultType.equalsIgnoreCase('Reporting_Period__c')){
            //if ((profileName == 'PLT - Mission Profile' && rResult.Status__c == 'Open') || (profileName == 'Mission Partner' && rResult.Status__c != 'Open') || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed'){ 
            //if ((GU.isPLTProfileUser() && rResult.Status__c == 'Open') || (GU.isMissionPartnerUser() && rResult.Status__c != 'Open') || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed'){ 
            if ((isPLTReadOnlyUser || isPLTMissionUser && rResult.Status__c == 'Open') || (isMissionPartnerUser && rResult.Status__c != 'Open') || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed'){ 
                xmlW.writeAttribute(null,null,'type','ro');
            } else {
                xmlW.writeAttribute(null,null,'style','border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;');
            }
            //if (profileName == 'PLT - Mission Profile' && rResult.Status__c == 'Open'){
            //if (GU.isPLTProfileUser() && rResult.Status__c == 'Open'){
            if (isPLTMissionUser && rResult.Status__c == 'Open'){
                if (iResult != null && iResult.Actual__c != null){
                    xmlw.writeCharacters(String.valueOf(iResult.Actual__c));
                } else { xmlw.writeCharacters('');}
            } else if (iResult != null && iResult.Actual__c != null){
                xmlw.writeCharacters(String.valueOf(iResult.Actual__c));
            }
        } 
        xmlW.writeEndElement();
        
        xmlW.writeStartElement(null,'cell',null);
        xmlW.writeAttribute(null,null,'name','Variance');
        if (resultType.equalsIgnoreCase('Reporting_Period__c')){
            //if (profileName == 'PLT - Mission Profile' && rResult.Status__c == 'Open'){
            //if (GU.isPLTProfileUser() && rResult.Status__c == 'Open'){
            if (isPLTMissionUser && rResult.Status__c == 'Open'){
                
            } else if (iResult != null && iResult.Variance__c != null){
                    xmlw.writeCharacters(String.valueOf(iResult.Variance__c));
            } 
        } 
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        xmlW.writeAttribute(null,null,'name','Rating');
        if (resultType.equalsIgnoreCase('Reporting_Period__c')){
            if (iResult != null && iResult.Rating__c != null){
                xmlw.writeCharacters(String.valueOf(iResult.Rating__c));
            }   
        } 
        xmlW.writeEndElement();
        
        xmlW.writeStartElement(null,'cell',null);
        xmlW.writeAttribute(null,null,'name','Pcomments');
        if (resultType.equalsIgnoreCase('Reporting_Period__c')){
            //if ((profileName == 'PLT - Mission Profile' && rResult.Status__c == 'Open') || (profileName == 'Mission Partner' && rResult.Status__c != 'Open') || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed'){
            //if ((GU.isPLTProfileUser() && rResult.Status__c == 'Open') || (GU.isMissionPartnerUser() && rResult.Status__c != 'Open') || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed'){
            if ((isPLTMissionUser && rResult.Status__c == 'Open') || (isMissionPartnerUser && rResult.Status__c != 'Open') || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed' || isPLTReadOnlyUser){
                xmlW.writeAttribute(null,null,'type','ro');
            } else {
                xmlW.writeAttribute(null,null,'style','border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;'); 
            }
            //if (profileName == 'PLT - Mission Profile' && rResult.Status__c == 'Open'){
            //if (GU.isPLTProfileUser() && rResult.Status__c == 'Open'){
            if (isPLTMissionUser && rResult.Status__c == 'Open'){
                
            } else if (iResult != null && iResult.Notes_Comments_Partner__c != null && iResult.Notes_Comments_Partner__c != ''){
                xmlw.writeCharacters(String.valueOf(iResult.Notes_Comments_Partner__c));
            }
        }
        xmlW.writeEndElement();
        
        xmlW.writeStartElement(null,'cell',null);
        xmlW.writeAttribute(null,null,'name','Mcomments');
        if (resultType.equalsIgnoreCase('Reporting_Period__c')){
            //if (profileName == 'Mission Partner' || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed'){  
            //if (GU.isPLTProfileUser() || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed'){  
            if (isPLTReadOnlyUser || isMissionPartnerUser || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed'){  
                xmlW.writeAttribute(null,null,'type','ro');
            } else {
                xmlW.writeAttribute(null,null,'style','border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;'); 
            }
            if (iResult != null && iResult.Note_Comments__c != null && iResult.Note_Comments__c != ''){
                xmlw.writeCharacters(String.valueOf(iResult.Note_Comments__c));
            }   
        } 
        xmlW.writeEndElement();
        
        
        xmlW.writeStartElement(null,'cell',null);
        xmlW.writeAttribute(null,null,'name','Source');
        if (oInd != null && oInd.Source__c != null){
            if(oInd.Source__c == 'STANDARD'){ 
                xmlw.writeCharacters('1');
            } else if(oInd.Source__c == 'FTF'){ 
                xmlw.writeCharacters('2');
            } else if(oInd.Source__c == 'PEPFAR'){ 
                xmlw.writeCharacters('3');
            }
         }
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        xmlW.writeAttribute(null,null,'name','IndicatorDataType');
        if (oInd != null && oInd.indDataType__c != null){
            xmlw.writeCharacters(oInd.indDataType__c);
         }
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        xmlW.writeAttribute(null,null,'name','IndicatorDataMax');
        if (oInd != null && oInd.indDataMax__c != null){
            xmlw.writeCharacters(oInd.indDataMax__c);
         }
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        xmlW.writeAttribute(null,null,'name','IndicatorDataMin');
        if (oInd != null && oInd.indDataMin__c != null){
            xmlw.writeCharacters(oInd.indDataMin__c);
         }
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        xmlW.writeAttribute(null,null,'name','UOM');
        //system.debug('Test::::'+oInd.UOM__c);
         if (oInd != null && oInd.UOM__c != null){
            //system.debug('Test::::'+String.valueOf(oInd.UOM__c));
            xmlw.writeCharacters(oInd.UOM__c);
         }
        xmlW.writeEndElement();
    }

    public void getIMTargetsXMLString(String treeLevel, OrgUnit_Indicator__c oInd, Indicator_Results__c iResult,
                                LF_Indicator_Result__c lfiResult, RF_Indicator_Result__c rfiResult, String resultType, String profileName, Reporting_Period__c rResult){
        xmlW.writeStartElement(null,'row',null);
        if (treeLevel.equalsIgnoreCase('Indicator')){ 
            xmlW.writeAttribute(null,null,'id',oInd.Id);
        } else {
            xmlW.writeAttribute(null,null,'id',oInd.Id);
        }
        xmlW.writeStartElement(null,'Indicator',null);
        if (treeLevel.equalsIgnoreCase('Indicator')){
            xmlW.writeAttribute(null,null,'image','indicator.png');
            xmlW.writeAttribute(null,null,'Id',oInd.indCode__c);
            xmlW.writeCharacters('&nbsp&nbsp&nbsp'+oInd.indCode__c);    
        } else if(treeLevel.equalsIgnoreCase('Sub Indicator')){
            xmlW.writeAttribute(null,null,'image','sub-indicator.png');
            xmlW.writeAttribute(null,null,'Id',oInd.sindCode__c);
            xmlW.writeCharacters('&nbsp&nbsp&nbsp'+oInd.sindCode__c);
        } else if(treeLevel.equalsIgnoreCase('Custom Indicator')){
            xmlW.writeAttribute(null,null,'image','custom-indicator.png');
            xmlW.writeAttribute(null,null,'Id',oInd.indCode__c);
            xmlW.writeCharacters('&nbsp&nbsp&nbsp'+oInd.indCode__c);
        } else if(treeLevel.equalsIgnoreCase('Custom Sub Indicator')){
            xmlW.writeAttribute(null,null,'image','custom-sub-indicator.png');
            xmlW.writeAttribute(null,null,'Id',oInd.sindCode__c);
            xmlW.writeCharacters('&nbsp&nbsp&nbsp'+oInd.sindCode__c);
        }           
        xmlW.writeEndElement();
        system.debug('isMissionPartnerUser =  '+isMissionPartnerUser);
        system.debug('isPLTProfileUser =  '+isPLTProfileUser);
        xmlW.writeStartElement(null,'IndicatorName',null);
        if (treeLevel.equalsIgnoreCase('Indicator') || treeLevel.equalsIgnoreCase('Custom Indicator') ){
            xmlW.writeCharacters(oInd.indName__c);
        } else if(treeLevel.equalsIgnoreCase('Sub Indicator') || treeLevel.equalsIgnoreCase('Custom Sub Indicator')){ 
            xmlW.writeCharacters(oInd.sindName__c);
        }
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'Baseline',null);
        if (resultType.equalsIgnoreCase('Reporting_Period__c')){
            //if (rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed' || profileName == 'Mission Partner'){
            //if (rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed' || GU.isMissionPartnerUser()){    
            if (rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed' || isMissionPartnerUser || isPLTReadOnlyUser){    
                xmlW.writeAttribute(null,null,'type','ro');
            } else {
                xmlW.writeAttribute(null,null,'style','border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;'); 
            }
            if (iResult != null && iResult.Baseline__c != null){
                xmlw.writeCharacters(String.valueOf(iResult.Baseline__c));
            }   
        }          
        xmlW.writeEndElement();
        system.debug('isMissionPartnerUser =  '+isMissionPartnerUser);
        system.debug('isPLTProfileUser =  '+isPLTProfileUser);
        xmlW.writeStartElement(null,'Target',null);
        if (resultType.equalsIgnoreCase('Reporting_Period__c')){
            //if (profileName == 'Mission Partner' || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed'){  
            //if (GU.isMissionPartnerUser() || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed'){ 
            system.debug('isMissionPartnerUser =  '+isMissionPartnerUser); 
            if (isPLTReadOnlyUser || isMissionPartnerUser || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed'){  
                xmlW.writeAttribute(null,null,'type','ro');
            } else {
                xmlW.writeAttribute(null,null,'style','border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;'); 
            }
            if (iResult != null && iResult.Target__c != null){
                xmlw.writeCharacters(String.valueOf(iResult.Target__c));
            }
        }          
        xmlW.writeEndElement();
        
        xmlW.writeStartElement(null,'Actual',null);
        if (resultType.equalsIgnoreCase('Reporting_Period__c')){
            //if ((profileName == 'PLT - Mission Profile' && rResult.Status__c == 'Open') || (profileName == 'Mission Partner' && rResult.Status__c != 'Open') || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed'){ 
            //if ((GU.isPLTProfileUser() && rResult.Status__c == 'Open') || (GU.isMissionPartnerUser() && rResult.Status__c != 'Open') || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed'){ 
            if ((isPLTReadOnlyUser || isPLTMissionUser && rResult.Status__c == 'Open') || (isMissionPartnerUser && rResult.Status__c != 'Open') || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed'){ 
                xmlW.writeAttribute(null,null,'type','ro');
            } else {
                xmlW.writeAttribute(null,null,'style','border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;');
            }
            //if (profileName == 'PLT - Mission Profile' && rResult.Status__c == 'Open'){
            //if (GU.isPLTProfileUser() && rResult.Status__c == 'Open'){
            if (isPLTMissionUser && rResult.Status__c == 'Open'){
                if (iResult != null && iResult.Actual__c != null){
                    xmlw.writeCharacters(String.valueOf(iResult.Actual__c));
                } else { xmlw.writeCharacters('');}
            } else if (iResult != null && iResult.Actual__c != null){
                xmlw.writeCharacters(String.valueOf(iResult.Actual__c));
            }
        } 
        xmlW.writeEndElement();
        
        xmlW.writeStartElement(null,'Variance',null);
        if (resultType.equalsIgnoreCase('Reporting_Period__c')){
            //if (profileName == 'PLT - Mission Profile' && rResult.Status__c == 'Open'){
            //if (GU.isPLTProfileUser() && rResult.Status__c == 'Open'){
            if (isPLTMissionUser && rResult.Status__c == 'Open'){
                
            } else if (iResult != null && iResult.Variance__c != null){
                    xmlw.writeCharacters(String.valueOf(iResult.Variance__c));
            } 
        } 
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'Rating',null);
        if (resultType.equalsIgnoreCase('Reporting_Period__c')){
            if (iResult != null && iResult.Rating__c != null){
                xmlw.writeCharacters(String.valueOf(iResult.Rating__c));
            }   
        } 
        xmlW.writeEndElement();
        
        xmlW.writeStartElement(null,'Pcomments',null);
        if (resultType.equalsIgnoreCase('Reporting_Period__c')){
            //if ((profileName == 'PLT - Mission Profile' && rResult.Status__c == 'Open') || (profileName == 'Mission Partner' && rResult.Status__c != 'Open') || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed'){
            //if ((GU.isPLTProfileUser() && rResult.Status__c == 'Open') || (GU.isMissionPartnerUser() && rResult.Status__c != 'Open') || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed'){
            if ((isPLTMissionUser && rResult.Status__c == 'Open') || (isMissionPartnerUser && rResult.Status__c != 'Open') || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed' || isPLTReadOnlyUser){
                xmlW.writeAttribute(null,null,'type','ro');
            } else {
                xmlW.writeAttribute(null,null,'style','border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;'); 
            }
            //if (profileName == 'PLT - Mission Profile' && rResult.Status__c == 'Open'){
            //if (GU.isPLTProfileUser() && rResult.Status__c == 'Open'){
            if (isPLTMissionUser && rResult.Status__c == 'Open'){
                
            } else if (iResult != null && iResult.Notes_Comments_Partner__c != null && iResult.Notes_Comments_Partner__c != ''){
                xmlw.writeCharacters(String.valueOf(iResult.Notes_Comments_Partner__c));
            }
        }
        xmlW.writeEndElement();
        
        xmlW.writeStartElement(null,'Mcomments',null);
        if (resultType.equalsIgnoreCase('Reporting_Period__c')){
            //if (profileName == 'Mission Partner' || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed'){  
            //if (GU.isPLTProfileUser() || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed'){  
            if (isPLTReadOnlyUser || isMissionPartnerUser || rResult.Status__c == 'Submitted' || rResult.Status__c == 'Approved' || rResult.Status__c == 'Closed'){  
                xmlW.writeAttribute(null,null,'type','ro');
            } else {
                xmlW.writeAttribute(null,null,'style','border-top: #d7d7d7 2px solid; border-left: #d7d7d7 2px solid; border-right: #acacac 2px solid; border-bottom: #acacac 2px solid;'); 
            }
            if (iResult != null && iResult.Note_Comments__c != null && iResult.Note_Comments__c != ''){
                xmlw.writeCharacters(String.valueOf(iResult.Note_Comments__c));
            }   
        } 
        xmlW.writeEndElement();
        
        
        xmlW.writeStartElement(null,'Source',null);
        if (oInd != null && oInd.Source__c != null){
            if(oInd.Source__c == 'STANDARD'){ 
                xmlw.writeCharacters('1');
            } else if(oInd.Source__c == 'FTF'){ 
                xmlw.writeCharacters('2');
            } else if(oInd.Source__c == 'PEPFAR'){ 
                xmlw.writeCharacters('3');
            }
         }
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'IndicatorDataType',null);
        if (oInd != null && oInd.indDataType__c != null){
            xmlw.writeCharacters(oInd.indDataType__c);
         }
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'IndicatorDataMax',null);
        if (oInd != null && oInd.indDataMax__c != null){
            xmlw.writeCharacters(oInd.indDataMax__c);
         }
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'IndicatorDataMin',null);
        if (oInd != null && oInd.indDataMin__c != null){
            xmlw.writeCharacters(oInd.indDataMin__c);
         }
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'UOM',null);
        //system.debug('Test::::'+oInd.UOM__c);
         if (oInd != null && oInd.UOM__c != null){
            //system.debug('Test::::'+String.valueOf(oInd.UOM__c));
            xmlw.writeCharacters(oInd.UOM__c);
         }
        xmlW.writeEndElement();
    }








    
    public void terminateRow(){
        xmlW.writeEndElement(); 
    }
    public void terminateXML(){
        xmlW.writeEndElement(); //Tree    
        xmlW.writeEndDocument(); //Close XML document   
    }   
    
    public String getXMLString(){
        //system.debug('XML String So Far:::::'+xmlW.getXmlString());
        return xmlW.getXmlString();
    }       
    
    /* This method returns a map of Indicator Results preselected by an Orgunit Id. The Map contains 
    OrgUnit Indicator Id as key. This is used only to check if there were any Indicator results by an OrgUnit Indicator Id. */ 
    
    
    public Map<String, Indicator_Results__c > getIndResultsWithOUIndIdAsKey(){
        Map<String,Indicator_Results__c> indResults = new Map<String,Indicator_Results__c>();
        for(Indicator_Results__c iRes: rMap.values()){
            if (iRes.Organization_Indicator_Id__c != null){
                indResults.put(iRes.Organization_Indicator_Id__c, iRes);
            } 
        }
        return indResults;
    } 
    
    
    /* This method returns Map of USAID Indicators selected by a Program Objective and Source. Returned Map
        will have USAID Indicator Id as a Key */
    
    public Map<String, USAID_Indicator__c > getUSAIDIndsWithUSAIDIndIdAsKey(){
        return uMap;
    } 
    
    public Map<String, USAID_Indicator__c> getPepfarAreasByObjective(String pObjective){
        Map<String, USAID_Indicator__c> pepFarAreas = new Map<String, USAID_Indicator__c>();
        //System.debug('USAID Indicators' +uMap);
        for(USAID_Indicator__c uInd : uMap.values()){
            pepFarAreas.put(uInd.prCode__c,uInd);           
        }
        return pepFarAreas;
    }
    
    public Map<String,List<OrgUnit_Indicator__c>> getSubIndicatorsForIndicators(List<OrgUnit_Indicator__c> indicators, List<OrgUnit_Indicator__c> subIndicators){
        Map<String,List<OrgUnit_Indicator__c>> returnMap = new Map<String,List<OrgUnit_Indicator__c>>();
        for(OrgUnit_Indicator__c oInd: indicators){
          for (OrgUnit_Indicator__c sInd: subIndicators){  
            if(sind.sindCode__c != null && sind.indcode__c == oind.indCode__c){
                List<Orgunit_Indicator__c> tempIndicators = new List<Orgunit_Indicator__c>();
                if(returnMap.containsKey(oind.indCode__c)){
                    tempIndicators = returnMap.get(oind.indCode__c);
                }
                tempIndicators.add(sind);
                returnMap.put(oind.indCode__c,tempIndicators);
            }
          }  
        }
        System.debug('Return Map of Sub Indicators'+returnMap);
        return returnMap;
    }
    /* This method returns map of OrgUnit Indicators for a given Program Code from preselected OrgUnit Indicators 
        by an OrgUnit Id and Record Type  (Or) This method returns map of OrgUnit Sub Indicators for a given Indicator Code 
        from preselected OrgUnit Indicators by an OrgUnit Id and Record Type.
        
        The returned map will have USAID Indicator Id as key for standarad/PEPFAR  and 
        OrgUnit Indicator Id as key for custom Indicators */
        
    public Map<String, OrgUnit_Indicator__c> getOUIndsWithOUIndIdAndUSAIDIndIdAsKeyByPrCode(String fCode, String fLevel){
        //Map<String, List<OrgUnit_Indicator__c>> oIndicators = new Map<String, List<OrgUnit_Indicator__c>>();
        Map<String, OrgUnit_Indicator__c> oList = new Map<String, OrgUnit_Indicator__c>();
        system.debug('Fcode::'+fCode+'fLevel::'+fLevel);
        for(OrgUnit_Indicator__c oIndicator: oMMap.values()){           
            if(fLevel.equalsIgnoreCase('Indicator')){
                if (fCode.equalsIgnoreCase((String)oIndicator.prCode__c)){
                    if(oIndicator.sIndCode__c == null){
                        if (oIndicator.USAID_Indicator_Id__c == null){
                            oList.put(oIndicator.Id,oIndicator);
                        } else {
                            oList.put(oIndicator.USAID_Indicator_Id__c,oIndicator); 
                        }                       
                    }   
                }   
            } else if(fLevel.equalsIgnoreCase('Sub Indicator')){
                if (fCode.equalsIgnoreCase((String)oIndicator.indCode__c)){
                    if(oIndicator.sIndCode__c != null){
                        if (oIndicator.USAID_Indicator_Id__c == null){
                            oList.put(oIndicator.Id,oIndicator);
                        } else {
                            oList.put(oIndicator.USAID_Indicator_Id__c,oIndicator); 
                        }
                    }               
                }   
            } else if(fLevel.equalsIgnoreCase('Custom Indicator')){
                if (fCode.equalsIgnoreCase((String)oIndicator.prCode__c)){
                    if(oIndicator.sIndCode__c == null && oIndicator.Custom__c ){
                        oList.put(oIndicator.Id,oIndicator);
                    }               
                }   
            } else if(fLevel.equalsIgnoreCase('Custom Sub Indicator')){
                if (fCode.equalsIgnoreCase((String)oIndicator.indCode__c)){
                    if(oIndicator.sIndCode__c != null && oIndicator.Custom__c){
                        oList.put(oIndicator.Id,oIndicator);
                    }               
                }   
            }                               
        }
        
        return oList;   
    }       
        
    
    /* This method returns map of OrgUnit Indicators for a given Program Code and with level 'Indicator' (Or) 
        This method returns map of OrgUnit Sub Indicators for a given Indicator Code and with level 'Sub Indicator'. 
        The Map returned will have Master OrgUnit Indicator Id as a Key. */    
    
    public Map<String, OrgUnit_Indicator__c > getOUIndsWithMasterIdByprCodeAndLevel(String fCode, String flevel){
        Map<String,OrgUnit_Indicator__c> usaidOMMap = new Map<String,OrgUnit_Indicator__c>();
        for(OrgUnit_Indicator__c oInd: oMap.values()){          
            if(fLevel.equalsIgnoreCase('Indicator')){
                if (fCode.equalsIgnoreCase((String)oInd.prCode__c)){
                    if(oInd.sIndCode__c == null && oInd.Organization_Indicator_Id__c != null){
                        usaidOMMap.put(oInd.Organization_Indicator_Id__c,oInd);
                    }   
                }   
            } else if(fLevel.equalsIgnoreCase('Sub Indicator')){
                if (fCode.equalsIgnoreCase((String)oInd.indCode__c)){
                    if(oInd.sIndCode__c != null && oInd.Organization_Indicator_Id__c != null){
                        usaidOMMap.put(oInd.Organization_Indicator_Id__c,oInd);
                    }               
                }   
            } 
        }
        return usaidOMMap;      
    } 
    
    
    /* This method returns map of OrgUnit Indicators from the OrgUnit Indicators selected for
        an OorgUnit with key value as USIAD Indicator Id for Standard/PEPFAR Indicators and 
        OrgUnit Indicator ID for Custom Indicators */
    
    public Map<String, OrgUnit_Indicator__c > getOUIndsWithOUIndIdAndUSAIDIndIdAsKey(){
        Map<String,OrgUnit_Indicator__c> usaidOMap = new Map<String,OrgUnit_Indicator__c>();
        for(OrgUnit_Indicator__c oInd: oMap.values()){
            if (oInd.USAID_Indicator_Id__c != null){
                if(oInd.Organization_Indicator_Id__c == null){
                    usaidOMap.put(oInd.USAID_Indicator_Id__c, oInd);
                } else {
                    usaidOMap.put(oInd.Id, oInd);
                }    
            } else {
                usaidOMap.put(oInd.Id, oInd);
            }   
        }
        return usaidOMap;
    }
    
    public Map<String, OrgUnit_Indicator__c > getOUIndsWithIndCodeSIndCodeAsKey(){
        Map<String,OrgUnit_Indicator__c> usaidOMap = new Map<String,OrgUnit_Indicator__c>();
        for(OrgUnit_Indicator__c oInd: oMap.values()){
            if (oInd.Custom__c){
                if (oInd.sIndCode__c != null){
                    usaidOMap.put(oInd.sIndCode__c, oInd);
                } else {
                    usaidOMap.put(oInd.indCode__c, oInd);
                }   
            }
                
        }
        return usaidOMap;
    }
    
    public Map<String, OrgUnit_Indicator__c> getOUIndsWithOUIndIdAsKey(String fCode,String fLevel){
        
        Map<String, OrgUnit_Indicator__c> tempMap = new Map<String, OrgUnit_Indicator__c>();
        for(OrgUnit_Indicator__c oIndicator: oMMap.values()){           
            if(fLevel.equalsIgnoreCase('Indicator')){               
                if(oIndicator.sIndCode__c == null){                     
                    tempMap.put(oIndicator.Id,oIndicator);                                              
                }               
            } else if(fLevel.equalsIgnoreCase('Sub Indicator')) {
                if (fCode.equalsIgnoreCase((String)oIndicator.indCode__c)){
                    if(oIndicator.sIndCode__c != null){                     
                        tempMap.put(oIndicator.Id,oIndicator);                                              
                    }   
                }
            } else if (fLevel.equalsIgnoreCase('All')){
                tempMap.put(oIndicator.Id,oIndicator);
            }
        }   
        return tempMap;
        
    }
    
/*****************************************************************************************************/
/*************************************** QUERY METHODS ***********************************************/
/*****************************************************************************************************/

    /* This method retrieves Indicator Results By and OrgUnit Indicator Id */
    public void getIndicatorResultsByOrgUnitId(String orgUnitId){        
        List<SObject> sList = new List<SObject>();
        String orderByStr = 'Id ';      
        sList = GU.lookup(orgUnitId,'ouId__c',null,'Indicator_Results__c', orderByStr);
        
        for(SObject sObj: sList){
            Indicator_Results__c iResult = (Indicator_Results__c)sObj;
            rMap.put(iResult.Id,iResult);
        }       
    }
    
    public Map<String, Indicator_Results__c> getIndicatorResultsByRepPeriodId(String repPeriodId, String andStr){       
        List<SObject> sList = new List<SObject>();
        Map<String, Indicator_Results__c> tempMap = new Map<String, Indicator_Results__c>();
        String orderByStr = 'Id ';      
        sList = GU.lookup(repPeriodId,'Reporting_Period_Id__c',andStr,'Indicator_Results__c', orderByStr);
        
        for(SObject sObj: sList){
            Indicator_Results__c iResult = (Indicator_Results__c)sObj;
            tempMap.put(iResult.Organization_Indicator_Id__c,iResult);
        }   
        
        return tempMap; 
    }  
    
    public Map<String, LF_Indicator_Result__c> getIndicatorResultsByLFRepPeriodId(String repPeriodId){       
        List<SObject> sList = new List<SObject>();
        Map<String, LF_Indicator_Result__c> tempMap = new Map<String, LF_Indicator_Result__c>();
        String orderByStr = 'Id ';      
        sList = GU.lookup(repPeriodId,'LF_Reporting_Period_Id__c',null,'LF_Indicator_Result__c', orderByStr);
        
        for(SObject sObj: sList){
            LF_Indicator_Result__c iResult = (LF_Indicator_Result__c)sObj;
            tempMap.put(iResult.Organization_Indicator_Id__c,iResult);
        }   
        
        return tempMap; 
    }
    
    public Map<String, RF_Indicator_Result__c> getIndicatorResultsByRFRepPeriodId(String repPeriodId){       
        List<SObject> sList = new List<SObject>();
        Map<String, RF_Indicator_Result__c> tempMap = new Map<String, RF_Indicator_Result__c>();
        String orderByStr = 'Id ';      
        sList = GU.lookup(repPeriodId,'RF_Reporting_Period_Id__c',null,'RF_Indicator_Result__c', orderByStr);
        
        for(SObject sObj: sList){
            RF_Indicator_Result__c iResult = (RF_Indicator_Result__c)sObj;
            tempMap.put(iResult.Organization_Indicator_Id__c,iResult);
        }    
        
        return tempMap; 
    }
    
    /* This method retrieves OrgUnit Indicators by an OrgUnit Id */
    public void getOrgUnitIndicatorsByOrgUnitId(String orgUnitId){       
        List<SObject> sList = new List<SObject>();
        String orderByStr = 'PrCode__c, IndCode__c, sIndCode__c ';      
        sList = GU.lookup(orgUnitId,'ouId__c',null,'OrgUnit_Indicator__c', orderByStr);
        
        for(SObject sObj: sList){
            OrgUnit_Indicator__c oIndicator = (OrgUnit_Indicator__c)sObj;
                oMap.put(oIndicator.Id,oIndicator); 
        }   
    }
    
    /* This method retrieves OrgUnit Indicators by an OrgUnit ID and Record Type Name */
    public void getOrgUnitIndicatorsByRecordType(String orgUnitId, String recordType){       
        List<SObject> sList = new List<SObject>();
        String orderByStr = 'PrCode__c, IndCode__c, sIndCode__c ';
        String recordTypeId = GU.getRecordTypeId('OrgUnit_Indicator__c',recordType);
        String andStr = 'AND RecordTypeID = \'' +recordTypeId + '\'';
        sList = GU.lookup(orgUnitId,'ouId__c',andStr,'OrgUnit_Indicator__c', orderByStr);
        
        for(SObject sObj: sList){
            OrgUnit_Indicator__c oIndicator = (OrgUnit_Indicator__c)sObj;
            oMMap.put(oIndicator.Id,oIndicator);
        }       
    }
    
    public void getOrgUnitIndicatorsByRecordType2(String orgUnitId, String recordType, String Frequcncy){       
        List<SObject> sList = new List<SObject>();
        String orderByStr = 'PrCode__c, IndCode__c, sIndCode__c ';
        String recordTypeId = GU.getRecordTypeId('OrgUnit_Indicator__c',recordType);
        String andStr = 'AND RecordTypeID = \'' +recordTypeId + '\'';
        andStr = andStr +' AND Collection_Frequency__c = \''+Frequcncy+ '\'';
        sList = GU.lookup(orgUnitId,'ouId__c',andStr,'OrgUnit_Indicator__c', orderByStr);
        
        for(SObject sObj: sList){
            OrgUnit_Indicator__c oIndicator = (OrgUnit_Indicator__c)sObj;
            oMMap.put(oIndicator.Id,oIndicator);
        }       
    }
    public Map<String,OrgUnit_Indicator__c> getOrgUnitSubIndicators(String orgUnitId, String recordType){
        Map<String,OrgUnit_Indicator__c> subIndicators = new Map<String,OrgUnit_Indicator__c>();
        for(OrgUnit_Indicator__c oi: oMMap.values()){
            if(oi.sIndCode__c != null){
                subIndicators.put(oi.Name,oi);
            }    
        }
        return subIndicators; 
    }
    public Map<String,OrgUnit_Indicator__c> getOrgUnitIndicatorsByRecordType1(String orgUnitId, String recordType){       
        Map<String,OrgUnit_Indicator__c> Indicators = new Map<String,OrgUnit_Indicator__c>();
        for(OrgUnit_Indicator__c oi: oMMap.values()){
            if(oi.sIndCode__c == null){
                Indicators.put(oi.indCode__c,oi);
            }    
        }
        return Indicators;       
    }
    
    public Map<String,OrgUnit_Indicator__c> getOrgUnitIndicatorsByRecordTypeandCustom(String orgUnitId, String recordType, Boolean Custom){       
        Map<String,OrgUnit_Indicator__c> customIndicators = new Map<String,OrgUnit_Indicator__c>();
        for(OrgUnit_Indicator__c oi: oMMap.values()){
            if (oi.custom__c){
                customIndicators.put(oi.indCode__c,oi); 
            }
        }
        return customIndicators;       
    }
    
    public void getOrgUnitIndicatorsByRecordType(String recordType, String lookupColName, String lookupColValue){        
        List<SObject> sList = new List<SObject>();
        String orderByStr = 'PrCode__c, IndCode__c, sIndCode__c ';
        String recordTypeId = GU.getRecordTypeId('OrgUnit_Indicator__c',recordType);
        String andStr = ' AND ' +lookupColName+ ' =\''+lookupColValue+'\'';
        sList = GU.lookup(recordTypeId,'RecordTypeID',andStr,'OrgUnit_Indicator__c', orderByStr);
        
        for(SObject sObj: sList){
            OrgUnit_Indicator__c oIndicator = (OrgUnit_Indicator__c)sObj;
            oMMap.put(oIndicator.Id,oIndicator);
        }       
    }
    
    public void getOrgUnitIndicatorsByRecordType2(String recordType, String lookupColName, String lookupColValue, String Frequency){        
        List<SObject> sList = new List<SObject>();
        String orderByStr = 'PrCode__c, IndCode__c, sIndCode__c ';
        String recordTypeId = GU.getRecordTypeId('OrgUnit_Indicator__c',recordType);
        String andStr = ' AND ' +lookupColName+ ' =\''+lookupColValue+'\'';
        andStr = andStr +' AND Collection_Frequency__c = \''+Frequency+ '\'';
        sList = GU.lookup(recordTypeId,'RecordTypeID',andStr,'OrgUnit_Indicator__c', orderByStr);
        system.debug('AND STR:::'+andStr);
        system.debug('List:::'+sList);
        for(SObject sObj: sList){
            OrgUnit_Indicator__c oIndicator = (OrgUnit_Indicator__c)sObj;
            oMMap.put(oIndicator.Id,oIndicator);
        }       
    }
    
    /* This method retrieves USAID Indicators by a program Objective and source */  
    /*public void getUSAIDIndicatorsByObjectiveAndSource(String pObjective, String source){        
        List<SObject> sList = new List<SObject>();
        String orderByStr = 'PrCode__c, IndCode__c, sIndCode__c ';
        String andStr = 'AND Source__c = \'' +source +'\''; 
        sList = GU.lookup(pObjective,'Program_Objective__c',andStr,'USAID_Indicator__c', orderByStr);
        system.debug('List:::'+sList);
        for(SObject sObj: sList){
            USAID_Indicator__c uIndicator = (USAID_Indicator__c)sObj;
            uMap.put(uIndicator.Id,uIndicator);
        }       
    } */
    
    /* This method retrieves USAID Indicators by a program Objective and source */  
    public void getUSAIDIndicatorsByObjectiveAndSource(String pObjective, String source){        
        List<SObject> sList = new List<SObject>();
        String filterStr;
        if(source.equalsIgnoreCase('PEPFAR')){
            filterStr = ' Where Program_Objective__c = \'' +pObjective +'\' AND source__c = \'' +source+ '\' order by PrCode__c, IndCode__c, sIndCode__c';      
        } else if(source.equalsIgnoreCase('Standard')){
          filterStr = ' Where Program_Objective__c = \'' +pObjective +'\' AND source__c = \'' +source+ '\' AND indStatus__c = \'Active\' order by PrCode__c, IndCode__c, sIndCode__c';
        //  filterStr = ' Where Program_Objective__c = \'' +pObjective +'\' AND source__c = \'' +source+ '\'  order by PrCode__c, IndCode__c, sIndCode__c';
        } else if(source.equalsIgnoreCase('FTF')){
            filterStr = ' Where source__c = \'' +source+ '\' AND indStatus__c = \'Active\' order by PrCode__c, IndCode__c, sIndCode__c';
        }
        
        sList = GU.lookupWithFilter(filterStr,'USAID_Indicator__c');
        for(SObject sObj: sList){
            USAID_Indicator__c uIndicator = (USAID_Indicator__c)sObj;
            uMap.put(uIndicator.Id,uIndicator);
        }
        
         for(USAID_Indicator__c ui: uMap.values()){
            List<USAID_Indicator__c> tempUIList = new List<USAID_Indicator__c>();            
                       
            List<USAID_Indicator__c> tempUIList1 = new List<USAID_Indicator__c>();
            if (ui.sIndCode__c != null){            
                if(uMapByIndicators.containsKey(ui.indCode__c)){
                    tempUIList1 = uMapByIndicators.get(ui.indCode__c);               
                }
                tempUIList1.add(ui);
                uMapByIndicators.put(ui.indCode__c,tempUIList1);
           } else {
               if(uMapByElements.containsKey(ui.prCode__c)){
                tempUIList = uMapByElements.get(ui.prCode__c);               
               }
                tempUIList.add(ui);
                uMapByElements.put(ui.prCode__c,tempUIList);
           }     
        }           
    } 
    
    /* This method retrieves Framework records by a Program Objective. */   
    public void getFrameworksByObjective(String pObjective,String source){         
        List<SObject> sList = new List<SObject>();
        String filterStr;
        filterStr = ' Where poCode__c = \'' +pObjective+ '\' AND Indicator_Wizard_Display__c like \'%'+source+'%\' order by poCode__c, paCode__c, peCode__c, seCOde__c';
        if (source.equalsIgnoreCase('FTF')){
            filterStr = ' Where poCode__c in (\'3\',\'4\') AND Indicator_Wizard_Display__c like \'%'+source+'%\' order by poCode__c, paCode__c, peCode__c, seCOde__c';
        } 
        
        sList = GU.lookupWithFilter(filterStr,'Framework__c');
        for(SObject sObj: sList){
            Framework__c fWork = (Framework__c)sObj;
            fMap.put(fWork.Id,fWork);
        }       
    }
    
    public Reporting_Period__c getReportingPeriodById(ID Id){ 
        return (Reporting_Period__c)GU.lookup(Id,'Reporting_Period__c');
    }
    
    public SObject getObjectRecordByIdAndName(ID Id, String objName){ 
        return GU.lookup(Id,objName);
    }
    
    public String getReportingPeriodRecTypeName(String objName,ID Id){ 
        return GU.getRecordType(objName,Id);
    }
    
    public String getReportingPeriodColumnNameByRecTypeID(ID Id){       
        if (GU.getRecordType('Reporting_Period__c',Id).equalsIgnoreCase('Activity')){
            return 'Activity_Id__c';
        } else if(GU.getRecordType('Reporting_Period__c',Id).equalsIgnoreCase('Implementing Mechanism')){
            return 'Implementing_Mechanism_Id__c';
        } else if(GU.getRecordType('Reporting_Period__c',Id).equalsIgnoreCase('LF Goal')){
            return 'Project_Id__c';
        } else if(GU.getRecordType('Reporting_Period__c',Id).equalsIgnoreCase('LF Purpose')){
            return 'LF_Purpose_Id__c';
        } else if(GU.getRecordType('Reporting_Period__c',Id).equalsIgnoreCase('LF Sub-Purpose')){
            return 'LF_Sub_Purpose_Id__c';
        } else if(GU.getRecordType('Reporting_Period__c',Id).equalsIgnoreCase('LF Output')){
            return 'LF_Output_Id__c';
        } else if(GU.getRecordType('Reporting_Period__c',Id).equalsIgnoreCase('RF Goal')){
            return 'Goal_Id__c';
        } else if(GU.getRecordType('Reporting_Period__c',Id).equalsIgnoreCase('RF DO')){
            return 'DO_Id__c';
        } else if(GU.getRecordType('Reporting_Period__c',Id).equalsIgnoreCase('RF IR')){
            return 'IR_Id__c';
        } else if(GU.getRecordType('Reporting_Period__c',Id).equalsIgnoreCase('RF SUB IR')){
            return 'SIR_Id__c';
        }
        return null;        
    }
    
    public string getBreadcrums(string recId){
        return GU.createBreadCrumps(recId);  
    }
    
    
}