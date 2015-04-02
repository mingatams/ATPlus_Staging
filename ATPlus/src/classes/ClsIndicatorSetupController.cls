public class ClsIndicatorSetupController {

      /** Public and Private Fields */
        public String selectedCustCategory {get; set;}
        public string xmlStringSetup{get;set;}       
        public String orgUnitId{get;set;}   
        public String aId {get;set;}
        public String selectedSourceIndicators{get; set;}
        public String recordTypeId {get;set;}
        public String recordTypeName {get;set;}        
       // public List<OrgUnit_Indicator__c> OrgIndicatorList {get;set;}   
       // public List<OrgUnit_Indicator__c> OrgMasterIndicatorList  {get;set;}    
        public set<id> OrgIndicatorIds {get;set;}
        public set<id> orgMasterIds {get;set;}
        public List<OrgUnit_Indicator__c> OrgRecTypeIndicatorList {get;set;}        
        public Map<String,List<String>> parentSubIndMap {get;set;}         
        public Map<String,Map<String,List<String>>> sourceParentSubIndMap {get;set;}
        private set<String> sourceNameList {get;set;}  
        private set<String> parentIndList {get;set;}  
        public boolean isIndicatorExist { get; set;}  
        public Set<String> fieldList { get; set;}        
        public String ObjectName { get; set;}  
        public String navigationLink { get; set;}        
        public String recordTypeColumnName{ get; set;} 
        public String masterIndEstablished { get; set;}  
        public sObject sObjectRecord { get; set;}   
        public clsGlobalUtility globalUtil = new clsGlobalUtility();   
        public String pageTitle {get;set;}   
        public boolean isReadOnlyUser{get;set;}     
        static final String RF_GOALS=String.valueOf('RF Goal');        
        static final String RF_DEVELOPMENT_OBJECTIVES=String.valueOf('RF DO');
        static final String RF_INTERMEDIATE_RESULTS=String.valueOf('RF IR');
        static final String RF_SUB_INTERMEDIATE_RESULTS=String.valueOf('RF SUB IR');
        static final String IMPLEMTING_MECHANISM=String.valueOf('Implementing Mechanism'); 
        static final String LF_GOALS=String.valueOf('LF Goal');        
        static final String LF_PURPOSE=String.valueOf('LF Purpose');
        static final String LF_SUB_PURPOSE=String.valueOf('LF Sub-Purpose');
        static final String LF_OUTPUT=String.valueOf('LF Output');
        static final String LF_INPUT=String.valueOf('LF Input');
        static final String MASTER=String.valueOf('Master');
        static final String ORGUNIT_INDICATOR_OBJECT_NAME=String.valueOf('OrgUnit_Indicator__c');
        static final String ORGUNIT_ID_FIELD_NAME =String.valueOf('ouId__c');
        static final String CROSS_CUTTING_SOURCE_NAME=String.valueOf('CROSS-CUTTING');
        static final String INDICATOR_ESTABLISHED_FIELD_NAME=String.valueOf('Indicators_Established__c');
        static final List<String> SOURCE_ORDER= new List<String>{'STANDARD','FTF','PEPFAR'};       
        static final String RF_INDICATOR_ESTABLISHED=String.valueOf('RF');
        static final String LF_INDICATOR_ESTABLISHED=String.valueOf('LF');
        static final String IM_INDICATOR_ESTABLISHED=String.valueOf('IM');                  
        static final String ERROR_MESSAGE=String.valueOf('Indicators are not defined for this orgUnit.');
        
             
      /** Controller */ 
        public ClsIndicatorSetupController (){
        
         isIndicatorExist =false;
         isReadOnlyUser = globalUtil.isPLTReadOnlyUser();
        //Get Id 
         if(aId == null && ApexPages.currentPage().getParameters().get('Id') != null)
           aId = ApexPages.currentPage().getParameters().get('Id');
         else if(aId == null && ApexPages.currentPage().getParameters().get('id') != null)
           aId = ApexPages.currentPage().getParameters().get('id');
         else{
              Set<String> idKey= ApexPages.currentPage().getParameters().keySet();
                if(idKey != null && idKey.size()>0){
                aId=idKey.iterator().next();
              }          
         }
         if(aId != null)
            navigationLink= globalUtil.createBreadCrumps(aId);   
         getAllInfoForId();  
    }

   /** Get all infor for requested Id */
    public void getAllInfoForId(){

     if(aId!= null){
        ObjectName = globalUtil.getObjectNameById(aId);
         if(ObjectName != null)
            {            
             sObjectRecord = globalUtil.lookup(aId,ObjectName);
             if(sObjectRecord != null){
              orgUnitId =String.valueOf(sObjectRecord.get(ORGUNIT_ID_FIELD_NAME));              
              getSetupInforOrgIndicator();
              // navigationLink= globalUtil.createBreadCrumps(aId);            
             }
            }
        }
   }

  /** Setup Org Indicator for Record Type using GlobalUtil */
   public void getSetupInforOrgIndicator(){
    
     if(sObjectRecord != null){            
   
            if(sObjectRecord.getsObjectType() == CDCSGoal__c.sObjectType){            
                     recordTypeName=RF_GOALS;    
                      pageTitle =RF_GOALS;      
                      recordTypeColumnName= 'Goal_Id__c' ;   
                      masterIndEstablished =RF_INDICATOR_ESTABLISHED;            
            }else if(sObjectRecord .getsObjectType() ==  DO__c.sObjectType){
                      recordTypeName=RF_DEVELOPMENT_OBJECTIVES;     
                      pageTitle =RF_DEVELOPMENT_OBJECTIVES;  
                      recordTypeColumnName= 'DO_Id__c' ;   
                      masterIndEstablished =RF_INDICATOR_ESTABLISHED;                      
            }else if(sObjectRecord .getsObjectType() ==  IR__c.sObjectType){
                      recordTypeName=RF_INTERMEDIATE_RESULTS;
                      pageTitle =RF_INTERMEDIATE_RESULTS;    
                      recordTypeColumnName= 'IR_Id__c' ;   
                      masterIndEstablished =RF_INDICATOR_ESTABLISHED;                   
            }else if(sObjectRecord .getsObjectType() == Sub_IR__c.sObjectType){
                      recordTypeName=RF_SUB_INTERMEDIATE_RESULTS;
                      pageTitle =RF_SUB_INTERMEDIATE_RESULTS;      
                      recordTypeColumnName= 'SIR_Id__c' ;   
                      masterIndEstablished =RF_INDICATOR_ESTABLISHED;            
            }else if(sObjectRecord .getsObjectType() ==  Implementing_Mechanism__c.sObjectType){
                      recordTypeName=IMPLEMTING_MECHANISM;
                      pageTitle =IMPLEMTING_MECHANISM;   
                      recordTypeColumnName= 'Implementing_Mechanism_Id__c' ;   
                      masterIndEstablished =IM_INDICATOR_ESTABLISHED;                  
            }else if(sObjectRecord .getsObjectType() == LF_Goal__c.sObjectType){
                      recordTypeName=LF_GOALS;
                      pageTitle =LF_GOALS;                        
                      recordTypeColumnName= 'LF_Goal_Id__c' ;   
                      masterIndEstablished =LF_INDICATOR_ESTABLISHED;                
            }else if(sObjectRecord .getsObjectType() == LF_Purpose__c.sObjectType){
                      recordTypeName=LF_PURPOSE;
                      pageTitle =LF_PURPOSE;                      
                      recordTypeColumnName= 'LF_Purpose_Id__c' ;   
                      masterIndEstablished =LF_INDICATOR_ESTABLISHED;
            }else if(sObjectRecord .getsObjectType() == LF_SubPurpose__c.sObjectType){
                      recordTypeName=LF_SUB_PURPOSE;
                      pageTitle =LF_SUB_PURPOSE;   
                      recordTypeColumnName= 'LF_SubPurpose_Id__c' ;   
                      masterIndEstablished =LF_INDICATOR_ESTABLISHED;                   
            }else if(sObjectRecord .getsObjectType() == LF_Output__c.sObjectType){
                      recordTypeName=LF_OUTPUT;
                      pageTitle =LF_OUTPUT;   
                      recordTypeColumnName= 'LF_Output_Id__c' ;   
                      masterIndEstablished =LF_INDICATOR_ESTABLISHED;                    
            }else if(sObjectRecord .getsObjectType() ==  LF_Input__c.sObjectType){
                      recordTypeName=LF_INPUT;
                      pageTitle =LF_INPUT;      
                      recordTypeColumnName= 'LF_Input_Id__c' ;   
                      masterIndEstablished =LF_INDICATOR_ESTABLISHED;                
            }          
            
            recordTypeId =globalUtil.getRecordTypeId(ORGUNIT_INDICATOR_OBJECT_NAME, recordTypeName );
           
           // String andIndString = ' and RecordType.Name ='+'\'' +MASTER+ '\'' + ' and Source__c != '+'\'' +CROSS_CUTTING_SOURCE_NAME+ '\''  ; 
            String andIndString = ' and RecordType.Name ='+'\'' +MASTER+ '\'';     
            List<OrgUnit_Indicator__c> OrgMasterIndicatorList = globalUtil.lookup(orgUnitId,ORGUNIT_ID_FIELD_NAME,andIndString,ORGUNIT_INDICATOR_OBJECT_NAME,'Source__c desc');                         
           
           // andIndString = ' and RecordType.id='+'\'' +recordTypeId+ '\'' + ' and Source__c != '+'\'' +CROSS_CUTTING_SOURCE_NAME+ '\''  ;
            andIndString = ' and RecordType.id='+'\'' +recordTypeId+ '\'' ; 
            OrgRecTypeIndicatorList = globalUtil.lookup(aId,recordTypeColumnName,andIndString ,ORGUNIT_INDICATOR_OBJECT_NAME,'Source__c desc');                         
          
            if(OrgMasterIndicatorList == null || OrgMasterIndicatorList.size() <= 0){
                ApexPages.getMessages().clear();    
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,ERROR_MESSAGE));
             }else{               
                isIndicatorExist =true;
                setOrgList(OrgMasterIndicatorList);    
              }
       }            

   }

   /** Build OrgIndicator List for Master and existing records */ 
      public void setOrgList(List<OrgUnit_Indicator__c> OrgMasterIndicatorList){
       orgMasterIds = new set<id>();
       OrgIndicatorIds = new set<id>();
       List<OrgUnit_Indicator__c> OrgIndicatorList = new List<OrgUnit_Indicator__c>();
       List<OrgUnit_Indicator__c> tmpList = new List<OrgUnit_Indicator__c>();
      if(OrgRecTypeIndicatorList.size() <=0 && OrgMasterIndicatorList.size() >0 ){
          OrgIndicatorList = OrgMasterIndicatorList;
          for(OrgUnit_Indicator__c oi: OrgMasterIndicatorList){
              orgMasterIds.add(oi.Id); 
              OrgIndicatorIds.add(oi.Id);              
          } 
          
          }
       else if(OrgMasterIndicatorList.size() <=0 && OrgRecTypeIndicatorList.size() >0){
           OrgIndicatorList = OrgRecTypeIndicatorList;
           for(OrgUnit_Indicator__c oi: OrgRecTypeIndicatorList){
              OrgIndicatorIds.add(oi.Id);              
          } 
          }
       else if(OrgMasterIndicatorList.size() > 0 && OrgRecTypeIndicatorList.size() >0){           
           for(OrgUnit_Indicator__c orgnial :OrgMasterIndicatorList){
               orgMasterIds.add(orgnial.Id);
               boolean isActExist= false;
              for(OrgUnit_Indicator__c  actExist:OrgRecTypeIndicatorList){
                if(!isActExist&& actExist.indCode__c == orgnial.indCode__c &&  actExist.sIndCode__c == orgnial.sIndCode__c){
                  actExist.Organization_Indicator_Id__c=orgnial.id;                 
                  actExist.isActive__c=orgnial.isActive__c;
                  actExist.indName__c=orgnial.indName__c;
                  actExist.sIndName__c=orgnial.sIndName__c;
                  tmpList.add(actExist) ;
                  isActExist= true;
                  OrgIndicatorIds.add(actExist.Id);
                }               
              }
             if(!isActExist){
              orgnial.Organization_Indicator_Id__c=orgnial.id;
              tmpList.add(orgnial) ;
              OrgIndicatorIds.add(orgnial.id);
             }
           }           
        //  OrgIndicatorList =tmpList;               
          }          
      }
 
   /** Get the unique source Name list */ 
        public Set<String> getSourceNameList(){ 
            clsGlobalUtility gu = new clsGlobalUtility();
            List<Sobject> sobjList = gu.lookup(OrgIndicatorIds,'ID','OrgUnit_Indicator__c');
            List<OrgUnit_Indicator__c> OrgIndicatorList = new List<OrgUnit_Indicator__c>();
            for(Sobject sobj: sobjList){
                OrgUnit_Indicator__c oi = (OrgUnit_Indicator__c)sobj;
                OrgIndicatorList.add(oi);
            }
                    
           if(OrgIndicatorList != null && OrgIndicatorList.size() > 0){
            sourceNameList = new Set<String>();
             for (OrgUnit_Indicator__c  orgInd : OrgIndicatorList ) {
                        if(orgInd.Source__c != null)
                      sourceNameList.add(orgInd.Source__c);
                    }
              }
        return sourceNameList;
    }
        
  /** Get unique Indicator Id List(Parent) */    
        public Set<String> getIndIdList(List<OrgUnit_Indicator__c> OrgIndicatorList){
          if(OrgIndicatorList!= null && OrgIndicatorList.size() > 0){
            parentIndList = new Set<String>();
             for (OrgUnit_Indicator__c  orgInd : OrgIndicatorList ) {
                       if(orgInd.indCode__c != null)
                      parentIndList.add(orgInd.indCode__c);                       
                    }
              }
        return parentIndList;
    }
        
    /** Get and set all sub indicators for the parent Indicator */ 
        public void getSubIndMap(List<OrgUnit_Indicator__c> OrgIndicatorList){        
        parentSubIndMap = new Map<String,List<String>>();        
        if(OrgIndicatorList != null){
        for (OrgUnit_Indicator__c  orgInd : OrgIndicatorList){
              if(orgInd.indCode__c != null){
              if (parentSubIndMap.containskey(orgInd.indCode__c)){
                 List<String> clist = parentSubIndMap.get(orgInd.indCode__c);
                 clist.add(orgInd.sIndCode__c);
                 parentSubIndMap.put(orgInd.indCode__c, clist);   
              }else{
                 List<String> newlist = new list<String>();
                 newlist.add(orgInd.sIndCode__c);
                 parentSubIndMap.put(orgInd.indCode__c, newlist);
              }
             }
             }
           }
    }
        
     /** Get and set all ParentSubIndicator Map to the Source */ 
        public void getsourceParentSubIndMap(List<OrgUnit_Indicator__c> OrgIndicatorList){    
           sourceParentSubIndMap = new Map<String,Map<String,List<String>>>();
            for(String souceName : sourceNameList){
                Map<String,List<String>> parSubIndMap = new Map<String,List<String>>();
                OrgIndicatorList.sort(); 
             for (OrgUnit_Indicator__c  orgInd : OrgIndicatorList ) { 
                         if(souceName == orgInd.Source__c ){                         
                               List<String> testString = parentSubIndMap.get(orgInd.indCode__c);                           
                               parSubIndMap.put(orgInd.indCode__c,testString );                             
                               sourceParentSubIndMap.put(souceName,parSubIndMap);
                         }
                   }
            }
  }

      /** Populate Nodes for XMLString for Dhtmlx */ 
        Public void getmainnodes()
        {
            Xmlstreamwriter xmlW = new Xmlstreamwriter();
            xmlW.writeStartDocument('UTF-8','1.0');
            xmlW.writeStartElement(null,'rows', null);
            xmlW.writeAttribute(null,null,'id','0');
            clsGlobalUtility gu = new clsGlobalUtility();
            List<Sobject> sobjList = gu.lookup(orgMasterIds,'ID','OrgUnit_Indicator__c');
            List<OrgUnit_Indicator__c> OrgMasterIndicatorList = new List<OrgUnit_Indicator__c>();
            for(Sobject sobj: sobjList){
                OrgUnit_Indicator__c oi = (OrgUnit_Indicator__c)sobj;
                OrgMasterIndicatorList.add(oi);
            }   
            
            List<Sobject> sobjList1 = gu.lookup(OrgIndicatorIds,'ID','OrgUnit_Indicator__c');
            List<OrgUnit_Indicator__c> OrgIndicatorList = new List<OrgUnit_Indicator__c>();
            for(Sobject sobj: sobjList1){
                OrgUnit_Indicator__c oi = (OrgUnit_Indicator__c)sobj;
                OrgIndicatorList.add(oi);
            }
            
            getSourceNameList();
            getIndIdList(OrgIndicatorList);
            getSubIndMap(OrgIndicatorList);
            getsourceParentSubIndMap(OrgIndicatorList);
            String indType='';
            String USAID_Tags='';
            String User_Defined_Tags='';
            boolean isactive=false; 
            boolean isResultExist=false;
            boolean isCustomInd=false;
            boolean isPPR=false;
            String indName='';
            String subIndName='';
            String groupBy='';
     //RamRam - begin  
        Map<string,OrgUnit_Indicator__c> OrgMasterIndicatorMap = new Map<string,OrgUnit_Indicator__c>();
      //  Map<string,OrgUnit_Indicator__c> recordTypeIndicatorsMap = new Map<string,OrgUnit_Indicator__c>();
        Map<string,OrgUnit_Indicator__c> OrgIndicatorMap = new Map<string,OrgUnit_Indicator__c>();
        
        for(OrgUnit_Indicator__c omi: OrgMasterIndicatorList){
            OrgMasterIndicatorMap.put(omi.name, omi);
        }
        
        for(OrgUnit_Indicator__c omi: OrgIndicatorList){
            OrgIndicatorMap.put(omi.name, omi);
        }    
     ////RamRam - End      
      //for(String sourOrd:SOURCE_ORDER){
          
      for(String sourceInd: sourceParentSubIndMap.keySet()) {
             if(sourceInd != null){
            
                Map<String,List<String>> parentSubIndMap =sourceParentSubIndMap.get(sourceInd);
                  
                for(String parentInd  : parentSubIndMap.keySet()){
                   indType='';
                   USAID_Tags='';
                   User_Defined_Tags='';
                   indName='';
                   isPPR=false;
                 /*  xmlW.writeStartElement(null,'row',null); 
                   xmlW.writeAttribute(null,null,'id',parentInd );                                                                            
                   xmlW.writeStartElement(null,'cell',null);*/
                 //Ramram - begin 
                 //  for (OrgUnit_Indicator__c  orgInd : OrgIndicatorList ) {
                 OrgUnit_Indicator__c orgInd = OrgIndicatorMap.get(parentInd);
                 //Ramram - end
                   /*if(orgInd.sIndCode__c == null){
                   System.Debug('orgInd  ***  '+orgInd.indCode__c +'  PPR *** ' + orgInd.PPR__c + ' SubInd*** ' + orgInd.sIndCode__c);
                     }*/
                     if(sourceInd == orgInd.Source__c &&  parentInd == orgInd.indCode__c && orgInd.sIndCode__c == null){              
                     
                    //RamRam - begin 
                    //  for(OrgUnit_indicator__c OrgIndParent : OrgMasterIndicatorList){
                    OrgUnit_Indicator__c OrgIndParent = OrgMasterIndicatorMap.get(orgInd.Name);  
                    //RamRam - end
                                    if(OrgIndParent.Source__c== orgInd.Source__c &&  OrgIndParent.indCode__c  == orgInd.indCode__c && OrgIndParent.sIndCode__c ==null){
                                      if(OrgIndParent.indType1__c != null) 
                                          indType=OrgIndParent.indType1__c;
                                      if(OrgIndParent.USAID_Tags__c != null) 
                                          USAID_Tags=OrgIndParent.USAID_Tags__c;
                                      if(OrgIndParent.User_Defined_Tags__c != null) 
                                          User_Defined_Tags=OrgIndParent.User_Defined_Tags__c;
                                       if(OrgIndParent.PPR__c == true)
                                           isPPR = true;   
                                        else
                                            isPPR = false;        
                                      if(OrgIndParent.isActive__c== true)     
                                           isactive = true;                                  
                                      if(OrgIndParent.indName__c != null) 
                                         indName=OrgIndParent.indName__c;    
                                
                                     if(OrgIndParent.Custom__c == true)
                                          isCustomInd=true; 
                                         else
                                           isCustomInd=false;   
                                           }
                                          //Ramram - begin 
                                         //  }
                                         //Ramram - end
                     
                          //system.debug('Org Ind code:::'+orgInd.indCode__c+':::Active:::'+orgInd.isActive__c);
                    /*     if(orgInd.indType1__c != null) 
                               indType=orgInd.indType1__c;
                          if(orgInd.USAID_Tags__c != null) 
                               USAID_Tags=orgInd.USAID_Tags__c;
                          if(orgInd.User_Defined_Tags__c != null) 
                               User_Defined_Tags=orgInd.User_Defined_Tags__c;
                          if(orgInd.PPR__c == true)
                                 isPPR = true;
                            else
                                 isPPR = false;         
                          if(orgInd.isActive__c== true)     
                                isactive = true;
                            else
                                isactive = false;
                          if(orgInd.indName__c != null) 
                                indName=orgInd.indName__c;     
                                
                          if(orgInd.Custom__c == true)
                                isCustomInd=true;
                              else  
                                isCustomInd=false;      */
                                
                           groupby=String.valueOf(orgInd.Group__c) ;   
                      }
                  //RamRam - begin    
                  // }
                  //RamRam - End
                   xmlW.writeStartElement(null,'row',null); 
                   xmlW.writeAttribute(null,null,'id',parentInd );                                                                            
                   xmlW.writeStartElement(null,'cell',null);
                   
                   if(isCustomInd)
                    xmlW.writeAttribute(null,null,'image','custom-indicator.png'); 
                   else   
                    xmlW.writeAttribute(null,null,'image','indicator.png'); 
                    if(parentInd  != null)
                   xmlw.writeCharacters(parentInd );             
                   xmlW.writeEndElement(); 
                   xmlW.writeStartElement(null,'cell',null);
                   xmlw.writeCharacters(indName);
                   xmlW.writeEndElement();  
                
                   xmlW.writeStartElement(null,'cell',null);                  
                   xmlw.writeCharacters(USAID_Tags);
                   xmlW.writeEndElement();                     
                   xmlW.writeStartElement(null,'cell',null);
                   xmlw.writeCharacters(User_Defined_Tags);
                   xmlW.writeEndElement();  
                   xmlW.writeStartElement(null,'cell',null);
                   xmlw.writeCharacters(indType);
                   xmlW.writeEndElement();  
                    xmlW.writeStartElement(null,'cell',null);
                    if(isPPR)                                          
                   xmlw.writeCharacters('true');                                           
                   xmlW.writeEndElement(); 
                   xmlW.writeStartElement(null,'cell',null);
                   if(isactive)                  
                   xmlw.writeCharacters('true');
                   xmlW.writeEndElement();
                   xmlW.writeStartElement(null,'cell',null);
                   if(isCustomInd)                  
                   xmlw.writeCharacters('true');
                   xmlW.writeEndElement();                        
                                         
                   xmlW.writeStartElement(null,'cell',null);                                  
                    if(isReadOnlyUser) {
                             xmlw.writeAttribute(null,null,'disabled','true');
                    }
                   //RamRam - begin                 
                   // for (OrgUnit_Indicator__c  orgInd1 : OrgIndicatorList ) {                  
                   OrgUnit_Indicator__c  orgInd1 = OrgIndicatorMap.get(parentInd);
                   //Ramram - end
                       if(sourceInd == orgInd1.Source__c &&  parentInd == orgInd1.indCode__c && orgInd1.sIndCode__c == null && orgInd1.recordtypeid==recordTypeId ){
                              
                             if(orgInd1.Results_Established__c)
                                xmlw.writeAttribute(null,null,'disabled','true');
                             else{   
                                    boolean isChildTargetEstablished =false;
                                //RamRam - Begin
                                //    for (OrgUnit_Indicator__c  orgIndChild : OrgIndicatorList ) {                                           
                                OrgUnit_Indicator__c  orgIndChild = OrgIndicatorMap.get(parentInd);
                                //Ramram - end
                                        if(isChildTargetEstablished == false && sourceInd == orgIndChild.Source__c &&  parentInd == orgIndChild.indCode__c && orgIndChild.sIndCode__c != null && orgIndChild.recordtypeid==recordTypeId && orgIndChild.Results_Established__c == true ){ 
                                             isChildTargetEstablished = true;
                                             xmlw.writeAttribute(null,null,'disabled','true');                                  
                                          }
                                   //RamRam - begin       
                                   //  }
                                   //RamRam - End
                                }
                                
                              if(checkRecordIDExist(orgInd1))                                       
                                 xmlw.writeCharacters('true');                  
                        }
                   //RamRam - Begin                       
                   // }
                   //RamRam - End
                    xmlW.writeEndElement(); 
                    
                    //Source
                      xmlW.writeStartElement(null,'cell',null);       
                      xmlw.writeCharacters(sourceInd);    
                      //xmlw.writeCharacters(groupby);   
                    /*  if(isCustomInd){
                                              xmlw.writeCharacters('Custom');    
                                            }else{  
                                           xmlw.writeCharacters(sourceInd);    
                                           }   */
                      xmlW.writeEndElement();
                     
                    for(String subInd: parentSubIndMap.get(parentInd )){
                         if(subInd != null){
                             /* xmlW.writeStartElement(null,'row',null);
                              xmlW.writeAttribute(null,null,'id',subInd);
                              xmlW.writeAttribute(null,null,'open','1');                                        
                              xmlW.writeStartElement(null,'cell',null); */
                              indType='';
                              USAID_Tags='';
                              User_Defined_Tags='';
                              isactive=false; 
                              isResultExist=false;
                              isCustomInd=false;
                              isPPR=false;
                              indName='';
                              subIndName='';
                              groupBy='';
                              //RamRam - Begin
                             // for (OrgUnit_Indicator__c  orgInd : OrgIndicatorList ) {
                              OrgUnit_Indicator__c  orgIndc = OrgIndicatorMap.get(subInd);                
                              //Ramram - end                  
                                  if(sourceInd == orgIndc.Source__c &&  parentInd == orgIndc.indCode__c && subInd ==orgIndc.sIndCode__c){ 
                                    //RamRam - Begin  
                                   // for(OrgUnit_indicator__c OrgIndParent : OrgMasterIndicatorList){
                                   OrgUnit_indicator__c OrgIndParentc = OrgMasterIndicatorMap.get(orgIndc.Name);
                                 //RamRam - End
                                    if(OrgIndParentc.Source__c== orgInd.Source__c &&  OrgIndParentc.indCode__c  == orgIndc.indCode__c && OrgIndParentc.sIndCode__c ==orgIndc.sIndCode__c){
                                      if(OrgIndParentc.indType1__c != null) 
                                          indType=OrgIndParentc.indType1__c;
                                      if(OrgIndParentc.USAID_Tags__c != null) 
                                          USAID_Tags=OrgIndParentc.USAID_Tags__c;
                                      if(OrgIndParentc.User_Defined_Tags__c != null) 
                                          User_Defined_Tags=OrgIndParentc.User_Defined_Tags__c;
                                       if(OrgIndParentc.PPR__c == true)
                                           isPPR = true;   
                                        else
                                            isPPR = false;        
                                      if(orgIndc.isActive__c== true)     
                                           isactive = true;                                  
                                      if(OrgIndParentc.sIndName__c != null)
                                           subIndName=OrgIndParentc.sIndName__c;
                                     if(OrgIndParentc.Custom__c == true)
                                          isCustomInd=true; 
                                         else
                                           isCustomInd=false;   
                                           }
                                         //RamRam - begin  
                                        //   }
                                        //Ramram - end
                                       groupby=String.valueOf(orgIndc.Group__c) ;                                            
                                    }
                                //RamRam - begin    
                               // }
                               //Ramram-end
                                  xmlW.writeStartElement(null,'row',null);
                              xmlW.writeAttribute(null,null,'id',subInd);
                              xmlW.writeAttribute(null,null,'open','1');                                        
                              xmlW.writeStartElement(null,'cell',null);
                                
                                
                                  if(isCustomInd)
                                     xmlW.writeAttribute(null,null,'image','custom-sub-indicator.png'); 
                                   else                  
                                      xmlW.writeAttribute(null,null,'image','sub-indicator.png');   
                                      xmlw.writeCharacters(subInd);             
                                      xmlW.writeEndElement();                                        
                                                        
                                       xmlW.writeStartElement(null,'cell',null);
                                       xmlw.writeCharacters(subIndName);
                                       xmlW.writeEndElement(); 
                                        
                                        xmlW.writeStartElement(null,'cell',null);
                                        xmlw.writeCharacters(USAID_Tags);
                                        xmlW.writeEndElement();
                                         
                                        xmlW.writeStartElement(null,'cell',null);
                                        xmlw.writeCharacters(User_Defined_Tags);
                                        xmlW.writeEndElement();  
                                        xmlW.writeStartElement(null,'cell',null);
                                        xmlw.writeCharacters(indType);
                                        xmlW.writeEndElement();  
                                        
                                         xmlW.writeStartElement(null,'cell',null);
                                           if(isPPR )                                          
                                           xmlw.writeCharacters('true');                                           
                                           xmlW.writeEndElement(); 
                                           
                                          xmlW.writeStartElement(null,'cell',null);
                                           if(isactive)                                          
                                           xmlw.writeCharacters('true');                                           
                                           xmlW.writeEndElement(); 
                                           xmlW.writeStartElement(null,'cell',null);
                                           if(isCustomInd)                  
                                           xmlw.writeCharacters('true');
                                           xmlW.writeEndElement();                                       
                                                             
                                        xmlW.writeStartElement(null,'cell',null);
                                        if(isReadOnlyUser) {
                                             xmlw.writeAttribute(null,null,'disabled','true');
                                        }
                                        //RamRam - begin
                                        // for (OrgUnit_Indicator__c  orgInd1 : OrgIndicatorList ) {   
                                        OrgUnit_Indicator__c  orgInd11 = OrgIndicatorMap.get(subInd);                                        
                                        //RamRam - end
                                                if(sourceInd == orgInd11.Source__c &&  parentInd == orgInd11.indCode__c && subInd ==orgInd11.sIndCode__c && orgInd11.recordtypeid==recordTypeId ){ 
                                               
                                                 if(orgInd1.Results_Established__c)
                                                     xmlw.writeAttribute(null,null,'disabled','true');    
                                                   if(checkRecordIDExist(orgInd11))                                       
                                                     xmlw.writeCharacters('true');
                                               }                                  
                                         //RamRam - begin      
                                         // }
                                         //Ramram - end
                                        xmlW.writeEndElement();
                                        //Source
                                           xmlW.writeStartElement(null,'cell',null);  
                                            xmlw.writeCharacters(sourceInd);  
                                            //xmlw.writeCharacters(groupby); 
                                         /*   if(isCustomInd){
                                              xmlw.writeCharacters('Custom');    
                                            }else{  
                                           xmlw.writeCharacters(sourceInd);    
                                           }   */
                                           xmlW.writeEndElement();
                                           
                                           xmlW.writeEndElement();  
                                        
                                         
                          }                                          
                    }
                    xmlW.writeEndElement();
                }               
              }
            }          
       //}
           
             xmlW.writeEndDocument(); //Close XML document
             System.Debug('IsReadOnly User ***  ' +isReadOnlyUser ); 
            System.Debug('XmlString: ***' +  xmlW.getXmlString());
             xmlStringSetup= xmlW.getXmlString(); 
             xmlStringSetup =  xmlStringSetup.replaceAll('\'','');
             xmlW.close();     
   }   

    /** Check ID exist for RecordType and check selected column */
    public boolean checkRecordIDExist(OrgUnit_Indicator__c  orgUnitInd){
           boolean isExist= false;
                if(aId != null){
                     if(recordTypeName == RF_GOALS && orgUnitInd.Goal_Id__c!= null && orgUnitInd.Goal_Id__c == aId) 
                     isExist=true;                     
                    if(recordTypeName == RF_DEVELOPMENT_OBJECTIVES && orgUnitInd.DO_Id__c!= null && orgUnitInd.DO_Id__c ==aId)                   
                     isExist=true;                     
                    if(recordTypeName == RF_INTERMEDIATE_RESULTS && orgUnitInd.IR_Id__c!= null && orgUnitInd.IR_Id__c == aId )
                     isExist=true;                     
                    if(recordTypeName == RF_SUB_INTERMEDIATE_RESULTS && orgUnitInd.SIR_Id__c!= null && orgUnitInd.SIR_Id__c == aId )
                     isExist=true;                 
                    if(recordTypeName == IMPLEMTING_MECHANISM && orgUnitInd.Implementing_Mechanism_Id__c!= null && orgUnitInd.Implementing_Mechanism_Id__c == aId)
                     isExist=true;
                    if(recordTypeName == LF_GOALS && orgUnitInd.LF_Goal_Id__c!= null && orgUnitInd.LF_Goal_Id__c == aId)
                     isExist=true;
                    if(recordTypeName == LF_PURPOSE && orgUnitInd.LF_Purpose_Id__c!= null && orgUnitInd.LF_Purpose_Id__c == aId)
                     isExist=true;
                    if(recordTypeName == LF_SUB_PURPOSE && orgUnitInd.LF_SubPurpose_Id__c!= null && orgUnitInd.LF_SubPurpose_Id__c == aId)
                     isExist=true;
                    if(recordTypeName == LF_OUTPUT && orgUnitInd.LF_Output_Id__c != null && orgUnitInd.LF_Output_Id__c == aId )
                     isExist=true;
                    if(recordTypeName == LF_INPUT && orgUnitInd.LF_Input_Id__c!= null &&  orgUnitInd.LF_Input_Id__c==aId)
                     isExist=true;
                    }
      return isExist;
    }
    
       /** Save Indicator for selected record type */
       public PageReference doSaveIndicatorForRecordType(){            
            Set<String> selectedIndicators = new Set<String>();   
            List<String> selectedIndKeyList = new List<String>();
            List<OrgUnit_Indicator__c> orgUnitInsertList = new List<OrgUnit_Indicator__c>();
            selectedIndKeyList = selectedSourceIndicators.split(',');
            selectedIndicators.addAll(selectedIndKeyList);
            system.debug('Selected Indicators::'+selectedIndicators);
            system.debug('Save Organization Indicators'+OrgIndicatorIds);
            clsGlobalUtility gu = new clsGlobalUtility();
           List<Sobject> sobjList = gu.lookup(OrgIndicatorIds,'ID','OrgUnit_Indicator__c');
            List<OrgUnit_Indicator__c> OrgIndicatorList = new List<OrgUnit_Indicator__c>();
            for(Sobject sobj: sobjList){
                OrgUnit_Indicator__c oi = (OrgUnit_Indicator__c)sobj;
                OrgIndicatorList.add(oi);
            }
            
          
            //Set Indicator for Sub Indcator Only selected
           for (OrgUnit_Indicator__c  existOrgPrevious : OrgIndicatorList ) {
              if( existOrgPrevious != null &&   selectedIndicators.contains(existOrgPrevious.sIndCode__c)){              
                 selectedIndicators.add(existOrgPrevious.indCode__c);              
              }
              
            }
         
         List<OrgUnit_Indicator__c> insertIndList = new List<OrgUnit_Indicator__c>{};
            for (OrgUnit_Indicator__c  existOrgInd : OrgIndicatorList ) {
                    if( existOrgInd != null  && ((selectedIndicators.contains(existOrgInd.indCode__c) && existOrgInd.sIndCode__c == null)||
                          selectedIndicators.contains(existOrgInd.sIndCode__c) )){
                          
                    OrgUnit_Indicator__c orgUnitInd = new OrgUnit_Indicator__c();                   
                    if(existOrgInd.indCode__c != null && existOrgInd.sIndCode__c==null){
                      orgUnitInd.name=existOrgInd.indCode__c;
                    }else if(existOrgInd.indCode__c != null && existOrgInd.sIndCode__c !=null){
                       orgUnitInd.name=existOrgInd.sIndCode__c;
                    }
                    orgUnitInd.ouId__c = existOrgInd.ouId__c;                           
                    orgUnitInd.Source__c = existOrgInd.Source__c;                    
                    orgUnitInd.IndCode__c = existOrgInd.indCode__c;
                    orgUnitInd.indName__c = existOrgInd.indName__c;
                    orgUnitInd.sIndCode__c = existOrgInd.sIndCode__c;
                    orgUnitInd.sIndName__c = existOrgInd.sIndName__c;
                    orgUnitInd.isActive__c  =  existOrgInd.isActive__c;
                    orgUnitInd.Custom__c  =  existOrgInd.Custom__c;
                    orgUnitInd.UOM__c = existOrgInd.UOM__c;
                    orgUnitInd.USAID_Indicator_Id__c = existOrgInd.USAID_Indicator_Id__c;
                    orgUnitInd.indDataType__c = existOrgInd.indDataType__c;
                    if(existOrgInd.recordtypeid==recordTypeId ) {                      
                      orgUnitInd.Results_Established__c = existOrgInd.Results_Established__c;
                      }
                    
                    if(existOrgInd.Organization_Indicator_Id__c != null)
                     orgUnitInd.Organization_Indicator_Id__c=existOrgInd.Organization_Indicator_Id__c;
                   else
                         orgUnitInd.Organization_Indicator_Id__c=existOrgInd.id; 
  
              
                   
                    orgUnitInd.User_Defined_Tags__c = existOrgInd.User_Defined_Tags__c;
                    orgUnitInd.RecordTypeId = recordTypeId;                     
                   
                    if(aId != null){
                     if(recordTypeName == RF_GOALS) 
                     orgUnitInd.Goal_Id__c = aId;                     
                    if(recordTypeName == RF_DEVELOPMENT_OBJECTIVES)                   
                     orgUnitInd.DO_Id__c =aId;                     
                    if(recordTypeName == RF_INTERMEDIATE_RESULTS )                    
                     orgUnitInd.IR_Id__c = aId;                     
                    if(recordTypeName == RF_SUB_INTERMEDIATE_RESULTS)
                     orgUnitInd.SIR_Id__c = aId;                    
                    if(recordTypeName == IMPLEMTING_MECHANISM)
                     orgUnitInd.Implementing_Mechanism_Id__c = aId;   
                    if(recordTypeName == LF_GOALS)
                     orgUnitInd.LF_Goal_Id__c = aId; 
                    if(recordTypeName == LF_PURPOSE)
                     orgUnitInd.LF_Purpose_Id__c=aId;  
                    if(recordTypeName == LF_SUB_PURPOSE)
                     orgUnitInd.LF_SubPurpose_Id__c=aId;
                    if(recordTypeName == LF_OUTPUT)
                     orgUnitInd.LF_Output_Id__c=aId;
                    if(recordTypeName == LF_INPUT)
                     orgUnitInd.LF_Input_Id__c=aId; 
                    }
                   
                  // if(orgUnitInd.Results_Established__c == false && ! selectedIndicators.contains(orgUnitInd.indCode__c) && ! selectedIndicators.contains(orgUnitInd.sIndCode__c))
                   if(orgUnitInd.Results_Established__c == false )  {
                     boolean isExist=false;
                    for(OrgUnit_Indicator__c newInsertList:OrgRecTypeIndicatorList){                      
                        if(orgUnitInd.sIndCode__c == newInsertList.sIndCode__c && orgUnitInd.IndCode__c == newInsertList.IndCode__c){                        
                           if((newInsertList.IndCode__c != null && newInsertList.sIndCode__c == null &&  selectedIndicators.contains(newInsertList.indCode__c) ) ||
                          (newInsertList.IndCode__c != null && newInsertList.sIndCode__c != null &&   selectedIndicators.contains(newInsertList.indCode__c)&& 
                           selectedIndicators.contains(newInsertList.sIndCode__c)) ){                    
                        
                            isExist=true;
                              break;
                          }
                         }
                       }
                       if(isExist == false)
                         insertIndList.add(orgUnitInd);  
                     }
                  }
              }
              
               
               //************************* Delete
                List<OrgUnit_Indicator__c> deleteIndSet = new List<OrgUnit_Indicator__c>{};
               if(OrgRecTypeIndicatorList != null && OrgRecTypeIndicatorList.size() > 0)  {   
                       
                       if(selectedSourceIndicators.length() > 0){      
                       for(OrgUnit_Indicator__c insertList:OrgRecTypeIndicatorList ){   
                       
            
                       if((insertList.IndCode__c != null && insertList.sIndCode__c == null &&  selectedIndicators.contains(insertList.indCode__c) == false ) ||
                          (insertList.IndCode__c != null && insertList.sIndCode__c != null &&   selectedIndicators.contains(insertList.indCode__c) == false && 
                           selectedIndicators.contains(insertList.sIndCode__c)  == false) ){                       
                               deleteIndSet.add(insertList);                       
                       }                              
                       }
                       }else{
                          deleteIndSet.addAll(OrgRecTypeIndicatorList); 
                       }
                      
                       
                        if(deleteIndSet!= null && deleteIndSet.size() > 0)  {                           
                           System.Debug('deleteIndSet****  ' + deleteIndSet);
                           delete deleteIndSet;                    
                       }       
                   }
               
               //************************* Delete End
          
                                    
                   if(insertIndList!= null && insertIndList.size() > 0)  {   
                    System.Debug('insertIndList ****  ' + insertIndList);
                     upsert insertIndList;                   
                   }
                   
               updateMasterNParent();
             PageReference pageRef; 
            // pageRef = new PageReference('/' + aId); 
            String currentRequestURL = URL.getCurrentRequestUrl().toExternalForm();
             pageRef =  new PageReference(currentRequestURL);
             pageRef.setRedirect(true);
             return pageRef ;          
           }      
           
      
         /** Update Master row and Parent object with Indicator Established column */
         public void updateMasterNParent(){
           // String andIndString = ' and RecordType.Name ='+'\'' +MASTER+ '\'' + ' and Source__c != '+'\'' +CROSS_CUTTING_SOURCE_NAME+ '\''  ;
            String andIndString = ' and RecordType.Name ='+'\'' +MASTER+ '\'' ;    
            List<orgunit_Indicator__c> OrgMasterIndicatorList = globalUtil.lookup(orgUnitId,ORGUNIT_ID_FIELD_NAME,andIndString,ORGUNIT_INDICATOR_OBJECT_NAME,'indCode__c');                         
         
           // andIndString = ' and RecordType.id='+'\'' +recordTypeId+ '\'' + ' and Source__c != '+'\'' +CROSS_CUTTING_SOURCE_NAME+ '\''   ;
            andIndString = ' and RecordType.id='+'\'' +recordTypeId+ '\''; 
            OrgRecTypeIndicatorList = globalUtil.lookup(aId,recordTypeColumnName,andIndString ,ORGUNIT_INDICATOR_OBJECT_NAME,'indCode__c');                         

         
           if(OrgRecTypeIndicatorList != null && OrgRecTypeIndicatorList.size() > 0 && sObjectRecord != null &&  sObjectRecord.get(INDICATOR_ESTABLISHED_FIELD_NAME)== false) {                      
                 sObjectRecord.put(INDICATOR_ESTABLISHED_FIELD_NAME, true);              
                 upsert sObjectRecord;
            } 
            else if(OrgRecTypeIndicatorList != null && OrgRecTypeIndicatorList.size() <=0 && sObjectRecord != null &&  sObjectRecord.get(INDICATOR_ESTABLISHED_FIELD_NAME)== true) {                      
                  sObjectRecord.put(INDICATOR_ESTABLISHED_FIELD_NAME, false);
                  upsert sObjectRecord;                  
            }         
                  
        List<OrgUnit_Indicator__c> tmpList = new List<OrgUnit_Indicator__c>();
         if(OrgMasterIndicatorList != null && OrgRecTypeIndicatorList != null && OrgMasterIndicatorList.size() > 0 && OrgRecTypeIndicatorList.size() >0){           
           for(OrgUnit_Indicator__c orgnial :OrgMasterIndicatorList){
               boolean isActExist= false;
              for(OrgUnit_Indicator__c  actExist:OrgRecTypeIndicatorList){
                if(!isActExist&& actExist.indCode__c == orgnial.indCode__c &&  actExist.sIndCode__c == orgnial.sIndCode__c){
                    isActExist= true;
                }               
              }
        
             if(isActExist){     
             if(masterIndEstablished == RF_INDICATOR_ESTABLISHED)
               orgnial.RF_Indicators_Established__c = true;
             else if( masterIndEstablished  == LF_INDICATOR_ESTABLISHED)   
              orgnial.LF_Indicators_Established__c = true;
             else if(masterIndEstablished   == IM_INDICATOR_ESTABLISHED)    
              orgnial.IM_Indicators_Established__c = true;    
               
              tmpList.add(orgnial) ;
             }
           }           
              if(tmpList != null && tmpList.size() > 0){
                 //System.Debug('Update Master **** ' + tmpList);
                 upsert tmpList;
               }          
        }      
   } 
     public PageReference CancelNGo(){
      
       Cookie previousReportPeriodCookie= new Cookie('selectedPeriod', '',null,0,false);                
             ApexPages.currentPage().setCookies(new Cookie[]{previousReportPeriodCookie}); 
             
             
            Cookie previousURLCookie = new Cookie('previousURL', '',null,0,false);                
             ApexPages.currentPage().setCookies(new Cookie[]{previousURLCookie}); 
           
             
              Cookie selectTabCookie = new Cookie('selectTabCookie', '',null,0,false);                
               ApexPages.currentPage().setCookies(new Cookie[]{selectTabCookie }); 
               
         PageReference pageRef; 
         Id inputId = ApexPages.currentpage().getParameters().get('id');
         pageRef = new PageReference('/' + inputId); 
         pageRef.setRedirect(true);
         return pageRef ;     
    }
     /** Cancel Go to Parent Page */
     public PageReference cancel() {
             PageReference pageRef; 
             pageRef = new PageReference('/' + aId); 
             pageRef.setRedirect(true);
             return pageRef ;         
          }         
          
          
 /** Test Method   */   
 /** Test Method */  
     
 @IsTest(SeeAllData=true) public static void testRFIndicatorSetup() {
      List<OrgUnit_Indicator__c> existingTypeIndcatorG= new List<OrgUnit_Indicator__c>();
      List<OrgUnit_Indicator__c> existingTypeIndcatorO= new List<OrgUnit_Indicator__c>();
    //  List<OrgUnit_Indicator__c> existingTypeIndcatorD= new List<OrgUnit_Indicator__c>();
    //  List<OrgUnit_Indicator__c> existingTypeIndcatorI= new List<OrgUnit_Indicator__c>();
    //  List<OrgUnit_Indicator__c> existingTypeIndcatorS= new List<OrgUnit_Indicator__c>();
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        String rfGoadId =  testIndicatorUtil.getRFGoalForOrgId(OrgUnitId);
        String rfDOId =  testIndicatorUtil.getRFDOForGoal(rfGoadId);
        String rfIRId =  testIndicatorUtil.getRFIRForDO(rfDOId);
        String rfSubIRId =  testIndicatorUtil.getRFSubIRForIR(rfIRId);
        
       
        String customIndicator =testIndicatorUtil.getCustomIndicatorForOrgId(OrgUnitId);
        existingTypeIndcatorO = testIndicatorUtil.getCustomIndicatorRecordsForOrgId(OrgUnitId);  
        existingTypeIndcatorG.add(testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,rfGoadId,'RFGoal'));
      //  existingTypeIndcatorD.add(testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,rfDOId,'RFDO'));
      //  existingTypeIndcatorI.add(testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,rfIRId,'RFIR'));
      //  existingTypeIndcatorS.add(testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,rfSubIRId,'RFSIR'));
          System.Test.Starttest() ;   
          //RF TEST
        testIndicatorUtil.testClsIndicatorSetupController(rfGoadId ,customIndicator,existingTypeIndcatorG,OrgUnitId,existingTypeIndcatorO) ;
        testIndicatorUtil.testClsIndicatorSetupController(rfDOId ,customIndicator,null,OrgUnitId,existingTypeIndcatorO) ;
        testIndicatorUtil.testClsIndicatorSetupController(rfIRId ,customIndicator,null,OrgUnitId,existingTypeIndcatorO) ;
        testIndicatorUtil.testClsIndicatorSetupController(rfSubIRId ,customIndicator,null,OrgUnitId,existingTypeIndcatorO) ;
         System.Test.Stoptest(); 
     
        }
              
         /** Test Method   */   
 /** Test Method */   
    
 @IsTest(SeeAllData=true) public static void testIMIndicatorSetup() {
      List<OrgUnit_Indicator__c> existingTypeIndcatorI= new List<OrgUnit_Indicator__c>();
      List<OrgUnit_Indicator__c> existingTypeIndcatorO= new List<OrgUnit_Indicator__c>();
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
        Implementing_Mechanism__c im =  testIndicatorUtil.getIMRecordForOrgId(OrgUnitId);
        String customIndicator =testIndicatorUtil.getCustomIndicatorForOrgId(OrgUnitId);  
        existingTypeIndcatorO = testIndicatorUtil.getCustomIndicatorRecordsForOrgId(OrgUnitId); 
        existingTypeIndcatorI.add(testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,im.id,'IM')); 
          System.Test.Starttest() ;     
          
            System.assertEquals(RF_GOALS, RF_GOALS);
            System.assertEquals(RF_DEVELOPMENT_OBJECTIVES, RF_DEVELOPMENT_OBJECTIVES);
            System.assertEquals(RF_INTERMEDIATE_RESULTS, RF_INTERMEDIATE_RESULTS);
            System.assertEquals(RF_SUB_INTERMEDIATE_RESULTS, RF_SUB_INTERMEDIATE_RESULTS);
            System.assertEquals(IMPLEMTING_MECHANISM, IMPLEMTING_MECHANISM);
            System.assertEquals(LF_PURPOSE, LF_PURPOSE);
            System.assertEquals(LF_SUB_PURPOSE, LF_SUB_PURPOSE);
            System.assertEquals(LF_OUTPUT, LF_OUTPUT);
            System.assertEquals(LF_INPUT, LF_INPUT);
            System.assertEquals(MASTER, MASTER);
            
            System.assertEquals(ORGUNIT_INDICATOR_OBJECT_NAME, ORGUNIT_INDICATOR_OBJECT_NAME);
            System.assertEquals(ORGUNIT_ID_FIELD_NAME, ORGUNIT_ID_FIELD_NAME);
            System.assertEquals(CROSS_CUTTING_SOURCE_NAME, CROSS_CUTTING_SOURCE_NAME);
            System.assertEquals(INDICATOR_ESTABLISHED_FIELD_NAME, INDICATOR_ESTABLISHED_FIELD_NAME);
            System.assertEquals(SOURCE_ORDER, SOURCE_ORDER);
            System.assertEquals(RF_INDICATOR_ESTABLISHED, RF_INDICATOR_ESTABLISHED);
            System.assertEquals(LF_INDICATOR_ESTABLISHED, LF_INDICATOR_ESTABLISHED);
            System.assertEquals(IM_INDICATOR_ESTABLISHED, IM_INDICATOR_ESTABLISHED);
            System.assertEquals(ERROR_MESSAGE, ERROR_MESSAGE);     
        
        // IM TEST
        ApplicationConstants.bypassIMSharingRulesTriggerLogic = true; 
        ApplicationConstants.bypassIMCreateVendorTriggerLogic = true;
        testIndicatorUtil.testClsIndicatorSetupController(testIndicatorUtil.getIMForOrgId(OrgUnitId),customIndicator,existingTypeIndcatorI,OrgUnitId,existingTypeIndcatorO) ;
      
        System.Test.Stoptest(); 
        }
              /** Test Method   */   
 /** Test Method */  
     
 @IsTest(SeeAllData=true) public static void testLFIndicatorSetup() {
      List<OrgUnit_Indicator__c> existingTypeIndcatorG= new List<OrgUnit_Indicator__c>();
      List<OrgUnit_Indicator__c> existingTypeIndcatorO= new List<OrgUnit_Indicator__c>();
    //  List<OrgUnit_Indicator__c> existingTypeIndcatorP= new List<OrgUnit_Indicator__c>();
    //  List<OrgUnit_Indicator__c> existingTypeIndcatorS= new List<OrgUnit_Indicator__c>();
    //  List<OrgUnit_Indicator__c> existingTypeIndcatorO= new List<OrgUnit_Indicator__c>();
    //  List<OrgUnit_Indicator__c> existingTypeIndcatorI= new List<OrgUnit_Indicator__c>();
      
        ClsTestUtility testIndicatorUtil = new ClsTestUtility();        
        String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
    
        
        String projectId =  testIndicatorUtil.getProjectForOrgId(OrgUnitId);
        String lfGoadId =  testIndicatorUtil.getLFGoalForProjectId(projectId);
        String lfPurposeId =  testIndicatorUtil.getLFPurposeForGoal(lfGoadId);
        String lfSubPurposeId =  testIndicatorUtil.getLFSubPurpose(lfPurposeId);
        String lfOutputId =  testIndicatorUtil.getLFOutput(lfSubPurposeId);
        String lfInputId =  testIndicatorUtil.getLFInput(lfOutputId);
           
        String customIndicator =testIndicatorUtil.getCustomIndicatorForOrgId(OrgUnitId);  
        existingTypeIndcatorG.add(testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,lfGoadId,'LFGoal'));
        
      //  existingTypeIndcatorP.add(testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,lfPurposeId,'LFPurpose'));
      //  existingTypeIndcatorS.add(testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,lfSubPurposeId,'LFSubPurpose'));
      //  existingTypeIndcatorO.add(testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,lfOutputId,'LFOutput'));
      //  existingTypeIndcatorI.add(testIndicatorUtil.getCustomIndicatorForType(OrgUnitId,lfInputId,'LFInput'));
        
          System.Test.Starttest() ;   
         
           existingTypeIndcatorO = testIndicatorUtil.getCustomIndicatorRecordsForOrgId(OrgUnitId); 
        // LF TESt
        testIndicatorUtil.testClsIndicatorSetupController(lfGoadId ,customIndicator,existingTypeIndcatorG,OrgUnitId,existingTypeIndcatorO) ;
        testIndicatorUtil.testClsIndicatorSetupController(lfPurposeId ,customIndicator,null,OrgUnitId,existingTypeIndcatorO) ;
        testIndicatorUtil.testClsIndicatorSetupController(lfSubPurposeId ,customIndicator,null,OrgUnitId,existingTypeIndcatorO) ;
        testIndicatorUtil.testClsIndicatorSetupController(lfOutputId ,customIndicator,null,OrgUnitId,existingTypeIndcatorO) ; 
      //  testIndicatorUtil.testClsIndicatorSetupController(lfInputId ,customIndicator,null,OrgUnitId,existingTypeIndcatorO) ; 
        System.Test.Stoptest(); 
        }
                   
    }