public with sharing class ClsOrgUnitIndicatorSController {
    
    public string defaultTab {
        get{
            if (ApexPages.currentPage().getParameters().get('sSrc') != null){
                return ApexPages.currentPage().getParameters().get('sSrc');
            }
            return 'Standard';
        }
    
    }
    public string selectedOrgUnit {get;set;}
    public string selectedObjective {get;set;}
    public string selectedSource {get;set;}
    public String selectedTab1 {get;set;}    
    public string xmlString{get;set;} 
    public string xmlString1{get;set;} 
    public string changedRowIds{get;set;} 
    public string showError{get;set;}
    
    string orgId;
    //String orgId;
    
    public String buttonId{
        get;
        set {
            buttonId = value;
            system.debug('Button value from the controller:::' +value +':: Button Id::' +buttonId);
        }
    }
    public String buttonId1{
        get;
        set {
            buttonId1 = value;
            system.debug('Button value from the controller:::' +value +':: Button Id1::' +buttonId1);
        }
    }
    
    Map<String,String> objectivesMap = new Map<String, String>();
    Map<String, IndicatorTree> iTreeMap = new Map<String, IndicatorTree>();
    public ClsOrgUnitIndicatorSController(){
        if (selectedTab1 == null){
            selectedTab1 = 'Standard';
        }    
        
        objectivesMap.put('1', 'Peace and Security');
        objectivesMap.put('2', 'Governing Justly and Democratically');
        objectivesMap.put('3', 'Investing in People');
        objectivesMap.put('4', 'Economic Growth');
        objectivesMap.put('5', 'Humanitarian Assistance');
        objectivesMap.put('6', 'Program Support');
        objectivesMap.put('C', 'Care');
        objectivesMap.put('H', 'Health System Strengthening');
        objectivesMap.put('P', 'Prevention');
        objectivesMap.put('T', 'Treatment');
        
        selectedOrgUnit = ApexPages.currentPage().getParameters().get('Id');
        system.debug('Selected Org Unit 1:::::'+selectedOrgUnit);
        
        if (ApexPages.currentPage().getParameters().get('sSrc') != null){
          this.selectedSource = ApexPages.currentPage().getParameters().get('sSrc');
          ApexPages.currentPage().getParameters().put('sSrc','');
        }
        if (ApexPages.currentPage().getParameters().get('sObj') != null){
          this.selectedObjective = ApexPages.currentPage().getParameters().get('sObj');      
           ApexPages.currentPage().getParameters().put('sObj','');
        }
        if (this.selectedSource == null && this.selectedObjective == null){
            getTreeXML1();
        } else {
            getTreeXMLNew();        
        }     
        
    }
        
    public List<selectOption> getOrgUnits(){
        List<selectOption> OrgUnitList = new List<selectOption>();
        List<OrgUnit__c> orgList = new List<OrgUnit__c>([Select ouId__c, ouCode__c, ouName__c from OrgUnit__c ORDER BY ouName__c]);        
        for(OrgUnit__c org: orgList){
            system.debug('Org Id:::'+org.ouId__c);
            OrgUnitList.add(new selectOption((String)org.ouId__c, (String)org.ouName__c));
        }
        return OrgUnitList;
    }
    
    public List<selectOption> getObjectives(){
        List<selectOption> programObjectives = new List<selectOption>();
        programObjectives.add(new selectOption('1', '1. Peace and Security'));
        programObjectives.add(new selectOption('2', '2. Governing Justly and Democratically'));
        programObjectives.add(new selectOption('3', '3. Investing in People'));
        programObjectives.add(new selectOption('4', '4. Economic Growth'));
        programObjectives.add(new selectOption('5', '5. Humanitarian Assistance'));
        programObjectives.add(new selectOption('6', '6. Program Support'));
        objectivesMap.put('1', 'Peace and Security');
        objectivesMap.put('2', 'Governing Justly and Democratically');
        objectivesMap.put('3', 'Investing in People');
        objectivesMap.put('4', 'Economic Growth');
        objectivesMap.put('5', 'Humanitarian Assistance');
        objectivesMap.put('6', 'Program Support');
        return programObjectives;
    }
    
    public List<selectOption> getPepfarObjectives(){
        List<selectOption> programObjectives = new List<selectOption>();
        programObjectives.add(new selectOption('C', 'C. Care'));
        programObjectives.add(new selectOption('H', 'H. Health System Strengthening'));
        programObjectives.add(new selectOption('P', 'P. Prevention'));
        programObjectives.add(new selectOption('T', 'T. Treatment'));
        objectivesMap.put('C', 'Care');
        objectivesMap.put('H', 'Health System Strengthening');
        objectivesMap.put('P', 'Prevention');
        objectivesMap.put('T', 'Treatment');
        return programObjectives;
    }
    
    public PageReference getTreeXML1(){
        String orgId1 = this.selectedOrgUnit != null ? this.selectedOrgUnit : ApexPages.currentPage().getParameters().get('Id');
        system.debug('Selected Org Unit 1:::::'+selectedOrgUnit);
        system.debug('Selected Org Unit 2:::::'+orgId1);
        ClsIndicatorWizardUtility IWU = new ClsIndicatorWizardUtility();
        IWU.getOrgUnitIndicatorsByRecordType(orgId1, 'Master');
        
        IWU.initializeXML();
            Map<String,OrgUnit_Indicator__c> orgInd1 = IWU.getOrgUnitIndicatorsByRecordType1(orgId1, 'Master');
            Map<String,OrgUnit_Indicator__c> sorgInd1 = IWU.getOrgUnitSubIndicators(orgId, 'Master');
            Map<String,List<OrgUnit_Indicator__c>> subIndicators = IWU.getSubIndicatorsForIndicators(orgInd1.values(),sorgInd1.values());
            if(orgInd1.isEmpty()){
                showError = 'true'; 
            } else {
                showError = 'false';
            }
            for(String ind: orgInd1.keySet()){
                OrgUnit_Indicator__c ind1 = orgInd1.get(ind);
                if(ind1.Custom__c){
                    IWU.getCustomXMLString('Custom Indicator',orgInd1.get(ind));
                  //  Map<String,OrgUnit_Indicator__c> cSubIndicators = IWU.getOUIndsWithOUIndIdAndUSAIDIndIdAsKeyByPrCode(ind, 'Custom Sub Indicator');
                   if(subIndicators.containsKey(ind)){  
                    for(OrgUnit_Indicator__c cSubInd: subIndicators.get(ind)){            
                        IWU.getCustomXMLString('Custom Sub Indicator',cSubInd);               
                        IWU.terminateRow();
                    } 
                   } 
                    IWU.terminateRow();
                     
                } else {
                    IWU.getCustomXMLString('Indicator',orgInd1.get(ind));
                   // Map<String,OrgUnit_Indicator__c> cSubIndicators = IWU.getOUIndsWithOUIndIdAndUSAIDIndIdAsKeyByPrCode(ind, 'Custom Sub Indicator');
                   if(subIndicators.containsKey(ind)){ 
                    for(OrgUnit_Indicator__c cSubInd: subIndicators.get(ind)){
                      if(cSubInd.custom__c){            
                        IWU.getCustomXMLString('Custom Sub Indicator',cSubInd);               
                        IWU.terminateRow();
                      } else {
                        IWU.getCustomXMLString('Sub Indicator',cSubInd);               
                        IWU.terminateRow();  
                      }  
                    } 
                   
                   } 
                  //  Map<String,OrgUnit_Indicator__c> cSubIndicators1 = IWU.getOUIndsWithOUIndIdAndUSAIDIndIdAsKeyByPrCode(ind, 'Sub Indicator');
                 //   for(OrgUnit_Indicator__c cSubInd: cSubIndicators1.values()){            
                 //       IWU.getCustomXMLString('Sub Indicator',cSubInd);               
                 //       IWU.terminateRow();
                 //   }
                    IWU.terminateRow(); 
                }
        }       
        IWU.terminateXML();
        system.debug('XML Strin so far::::' +IWU.getXMLString());   
        xmlString1 = IWU.getXMLString();
        xmlString1 = xmlString1.replaceAll('\'','');
        return null;        
    }
    
    
    public PageReference getTreeXMLNew(){
      //  if (this.selectedSource == null && ApexPages.currentPage().getParameters().get('sSrc') != null){
      //      this.selectedSource = ApexPages.currentPage().getParameters().get('sSrc');
      //      ApexPages.currentPage().getParameters().put('sSrc','');
      //  }
      //  if (this.selectedSource.equalsIgnoreCase(ApexPages.currentPage().getParameters().get('sSrc')) &&  this.selectedObjective == null && ApexPages.currentPage().getParameters().get('sObj') != null){
      //      this.selectedObjective = ApexPages.currentPage().getParameters().get('sObj');
      //      ApexPages.currentPage().getParameters().put('sSrc','');
      //      ApexPages.currentPage().getParameters().put('sObj','');
       // }
        String src = this.selectedSource != null ? this.selectedSource : 'Standard';
        String objective = this.selectedObjective != null ? this.selectedObjective : '1';
        String orgId = this.selectedOrgUnit != null ? this.selectedOrgUnit : ApexPages.currentPage().getParameters().get('Id');
      //  ApexPages.currentPage().getParameters().put('sSrc') = '';
      //  ApexPages.currentPage().getParameters().put('sObj') = '';
        //system.debug('Selected Org Unit 1:::::'+selectedOrgUnit);
        //system.debug('Selected Org Unit 3:::::'+orgId);
        ClsIndicatorWizardUtility IWU = new ClsIndicatorWizardUtility();
        IWU.getFrameworksByObjective(objective,src);
        IWU.getUSAIDIndicatorsByObjectiveAndSource(objective,src);
        IWU.getOrgUnitIndicatorsByOrgUnitId(orgId);
        IWU.getOrgUnitIndicatorsByRecordType(orgId, 'Master');
        
        IWU.initializeXML();
        if (selectedSource.equalsIgnoreCase('Standard')){
            IWU = prepStandardTree(IWU,objective);
            
        } else if (selectedSource.equalsIgnoreCase('PEPFAR')){
            IWU.getXMLString('Framework', 'Program Objective', '1', objective, objectivesMap.get(objective), null,null,true,false,false,false,false,null,null);
            prepIndicatorChain(objective, IWU);
            prepCustomIndicatorChain(objective, IWU);
            Map<String, USAID_Indicator__c> pepfarAreas = IWU.getPepfarAreasByObjective(objective);
            for(String parentPep: pepfarAreas.keySet()){
                USAID_Indicator__c pUind = pepfarAreas.get(parentPep);
                IWU.getXMLString('Framework', 'Program Area', pUind.prCode__c, pUind.prCode__c, pUind.prName__c, null,null,true, false,false,false,false,null,null);
                prepIndicatorChain((String)pUind.prCode__c, IWU);
                prepCustomIndicatorChain((String)pUind.prCode__c, IWU);
                IWU.terminateRow();             
            }
            IWU.terminateRow();
        }   else if (selectedSource.equalsIgnoreCase('FTF')){   
            IWU = prepStandardTree(IWU,'3');
            IWU.terminateRow();
            IWU = prepStandardTree(IWU,'4');
        }else if (selectedSource.equalsIgnoreCase('Custom')){   
            Map<String,OrgUnit_Indicator__c> customIndicators = IWU.getOrgUnitIndicatorsByRecordTypeandCustom(orgId, 'Master', True);
                for(String ind: customIndicators.keySet()){
                OrgUnit_Indicator__c ind1 = customIndicators.get(ind);
                if(ind1.indCode__c.contains('Z')){
                    IWU.getCustomXMLString('Custom Indicator',customIndicators.get(ind));
                    Map<String,OrgUnit_Indicator__c> cSubIndicators = IWU.getOUIndsWithOUIndIdAndUSAIDIndIdAsKeyByPrCode(ind, 'Custom Sub Indicator');
                    for(OrgUnit_Indicator__c cSubInd: cSubIndicators.values()){            
                        IWU.getCustomXMLString('Custom Sub Indicator',cSubInd);               
                        IWU.terminateRow();
                    }
                    IWU.terminateRow(); 
                } else if(ind1.sIndCode__c != null && ind1.sIndCode__c.contains('Z')){
                    Map<String,OrgUnit_Indicator__c> cSubIndicators = IWU.getOUIndsWithOUIndIdAndUSAIDIndIdAsKeyByPrCode(ind, 'Custom Sub Indicator');
                    for(OrgUnit_Indicator__c cSubInd: cSubIndicators.values()){            
                        IWU.getCustomXMLString('Custom Sub Indicator',cSubInd);               
                        IWU.terminateRow();
                    }
                }
            }
        }       
        IWU.terminateXML();
        system.debug('XML Strin so far::::' +IWU.getXMLString());   
        xmlString = IWU.getXMLString();
        xmlString = xmlString.replaceAll('\'','');
        
        //Pagereference ref = new PageReference('/apex/vfManageOrganizationIndicators?id=' + selectedOrgUnit);
        //ref.getParameters().put('Id',selectedOrgUnit);
        //system.debug('Selected Org Unit 4:::::'+selectedOrgUnit); 
        ApexPages.currentPage().getParameters().put('Id',selectedOrgUnit);
        return null;        
    }
   
  
    
    public ClsIndicatorWizardUtility prepStandardTree(ClsIndicatorWizardUtility IWU, String objective){
        IWU.getXMLString('Framework', 'Program Objective', objective, objective, objectivesMap.get(objective), null,null,true,false,false,false,false,null,null);
        prepIndicatorChain(objective, IWU);
        prepCustomIndicatorChain(objective, IWU);
        Map<String, List<Framework__c>> objectiveAreas = IWU.getFrameworkByPrCode(objective, 'Program Area');       
        for(Framework__c area: objectiveAreas.get(objective)){
            IWU.getXMLString('Framework', 'Program Area', area.Id, area.paCode__c, area.paName__c, null,null,true, false,false,false,false,null,null);          
            prepIndicatorChain((String)area.paCode__c, IWU);
            prepCustomIndicatorChain((String)area.paCode__c, IWU);
            
            Map<String, List<Framework__c>> areaElements = IWU.getFrameworkByPrCode(area.paCode__c, 'Program Element');
            for(Framework__c element: areaElements.get(area.paCode__c)){
                IWU.getXMLString('Framework', 'Program Element', element.Id, element.peCode__c, element.peName__c, null,null,true,false,false,false,false,null,null);
                prepIndicatorChain((String)element.peCode__c, IWU);
                prepCustomIndicatorChain((String)element.peCode__c, IWU);
                
                Map<String, List<Framework__c>> elementSubs = IWU.getFrameworkByPrCode(element.peCode__c, 'Program Sub Element');               
                for(Framework__c selement: elementSubs.get(element.peCode__c)){
                    IWU.getXMLString('Framework', 'Program Sub Element', selement.Id, selement.seCode__c, selement.seName__c, null,null,true,false,false,false,false,null,null);
                    prepIndicatorChain((String)selement.seCode__c,IWU);
                    prepCustomIndicatorChain((String)selement.seCode__c, IWU);                  
                    IWU.terminateRow();
                } 
                IWU.terminateRow();  
            }           
            IWU.terminateRow();
        }
        
        return IWU;
    }
    
    public void prepIndicatorChain(String code, ClsIndicatorWizardUtility IWU){
        Map<String,List<USAID_Indicator__c>> pIndicators = IWU.getUSAIDIndsByPrCode(code, 'Indicator');
        Map<String, OrgUnit_Indicator__c> pOrgIndicators = IWU.getOUIndsWithOUIndIdAndUSAIDIndIdAsKeyByPrCode(code, 'Indicator'); 
        system.debug('Prep Indicators::'+code +':: Indicators:' +pIndicators);     
        for(USAID_Indicator__c pInd: pIndicators.get(code)){
            
            if (pOrgIndicators.containsKey(pInd.Id)){
                //system.debug('Indicator OrgUnit Match 1' +pInd.Id);
                OrgUnit_Indicator__c oind = pOrgIndicators.get(pInd.Id);                
                //if (IWU.isIndicatorResultExists(oind.id, oind.RecordTypeId, code, 'Indicator')){
                    IWU.getXMLString('Indicator', '', pInd.Id, pInd.indCode__c, pInd.indName__c, pInd,oind.User_Defined_Tags__c,(oind.IM_Indicators_Established__c||oind.RF_Indicators_Established__c||oind.LF_Indicators_Established__c),true,oind.PPR__c,oind.isActive__c,oind.Custom__c,oind.indDataType__c,oind.indType1__c);
                //} else {
                 //   IWU.getXMLString('Indicator', '', pInd.Id, pInd.indCode__c, pInd.indName__c, pInd,oind.User_Defined_Tags__c,oind.Targets_Established__c,true,oind.PPR__c,oind.isActive__c,oind.indDataType__c);
                //}           
            } else {
                //system.debug('Indicator OrgUnit does not Match');
                IWU.getXMLString('Indicator', '', pInd.Id, pInd.indCode__c, pInd.indName__c, pInd,null,false,false,false,false,false,pInd.indDataType__c,pInd.indType__c);
            }
            
            prepStandardSubIndicators(pInd.indCode__c, IWU);
            prepCustomSubIndicators(pInd.indCode__c, IWU);
            IWU.terminateRow();
        }       
    }
    
    public void prepCustomIndicatorChain(String code, ClsIndicatorWizardUtility IWU){
        Map<String,OrgUnit_Indicator__c> cIndicators = IWU.getOUIndsWithOUIndIdAndUSAIDIndIdAsKeyByPrCode(code, 'Custom Indicator');
        for(OrgUnit_Indicator__c cInd: cIndicators.values()){
            //if (IWU.isIndicatorResultExists(cInd.Id, cInd.RecordTypeId ,code, 'Indicator')){
              IWU.getXMLString('Custom Indicator', '', cInd.Id, cInd.indCode__c, cInd.indName__c, null,cInd.User_Defined_Tags__c,(cInd.IM_Indicators_Established__c||cInd.RF_Indicators_Established__c||cInd.LF_Indicators_Established__c),true,cInd.PPR__c,cInd.isActive__c,cInd.Custom__c,cInd.indDataType__c,cInd.indType1__c);
             //} else {
            //    IWU.getXMLString('Custom Indicator', '', cInd.Id, cInd.indCode__c, cInd.indName__c, null,cInd.User_Defined_Tags__c,cInd.Targets_Established__c,true,cInd.PPR__c,cInd.isActive__c,cInd.indDataType__c);
            //}           
            prepCustomSubIndicators(cInd.indCode__c, IWU);
            IWU.terminateRow();
        }
    }
    
    public void prepStandardSubIndicators(String code, ClsIndicatorWizardUtility IWU ){
        Map<String,List<USAID_Indicator__c>> pSubIndicators = IWU.getUSAIDIndsByPrCode(code, 'Sub Indicator');
        Map<String, OrgUnit_Indicator__c> pOrgSubIndicators = IWU.getOUIndsWithOUIndIdAndUSAIDIndIdAsKeyByPrCode(code, 'Sub Indicator');
        //Map<String, OrgUnit_Indicator__c> pMasterOrgSubIndicators = IWU.getOUIndsWithMasterIdByprCodeAndLevel(code, 'Sub Indicator');
        //system.debug('Indicator Code Sub Indicators:::'+ code +' ::::List::' +pSubIndicators );
        for(USAID_Indicator__c pSubInd: pSubIndicators.get(code)){              
            if (pOrgSubIndicators.containsKey(pSubInd.Id)){
                OrgUnit_Indicator__c osind = pOrgSubIndicators.get(pSubInd.Id);
                //if(IWU.isIndicatorResultExists(osind.Id, osind.RecordTypeId ,code, 'Sub Indicator')){
                    //System.debug('Sub Indicator Result Exist::: '+IWU.isIndicatorResultExists(osind.Id, osind.RecordTypeId ,code, 'Sub Indicator'));
                 IWU.getXMLString('Sub Indicator', '', pSubInd.Id, pSubInd.sindCode__c, pSubInd.sindName__c, pSubInd,osind.User_Defined_Tags__c,(osind.IM_Indicators_Established__c||osind.RF_Indicators_Established__c||osind.LF_Indicators_Established__c),true,osind.PPR__c,osind.isActive__c,osInd.Custom__c,osInd.indDataType__c,osInd.indType1__c);
                 // } else {
               //     System.debug('Sub Indicator Result does not Exist::: '+IWU.isIndicatorResultExists(osind.Id, osind.RecordTypeId ,code, 'Sub Indicator'));
               //     IWU.getXMLString('Sub Indicator', '', pSubInd.Id, pSubInd.sindCode__c, pSubInd.sindName__c, pSubInd,osind.User_Defined_Tags__c,osind.Targets_Established__c,true,osind.PPR__c,osind.isActive__c,osInd.indDataType__c);
               // }                                   
            } else {
                IWU.getXMLString('Sub Indicator', '', pSubInd.Id, pSubInd.sindCode__c, pSubInd.sindName__c, pSubInd,null,false,false,false,false,false,pSubInd.indDataType__c,pSubInd.indType__c);
            }   
            IWU.terminateRow();
        }
    }
    
    public void prepCustomSubIndicators(String code, ClsIndicatorWizardUtility IWU){
        Map<String,OrgUnit_Indicator__c> cSubIndicators = IWU.getOUIndsWithOUIndIdAndUSAIDIndIdAsKeyByPrCode(code, 'Custom Sub Indicator');
        for(OrgUnit_Indicator__c cSubInd: cSubIndicators.values()){
            //if(IWU.isIndicatorResultExists(cSubInd.Id, cSubInd.RecordTypeId ,code, 'Sub Indicator')){
             IWU.getXMLString('Custom Sub Indicator', '', (String)cSubInd.Id, cSubInd.sindCode__c, cSubInd.sindName__c, null,cSubInd.User_Defined_Tags__c,(cSubInd.IM_Indicators_Established__c||cSubInd.RF_Indicators_Established__c||cSubInd.LF_Indicators_Established__c),true,cSubInd.PPR__c,cSubind.isActive__c,cSubind.Custom__c,cSubind.indDataType__c,cSubind.indType1__c);
             //} else {
            //    IWU.getXMLString('Custom Sub Indicator', '', (String)cSubInd.Id, cSubInd.sindCode__c, cSubInd.sindName__c, null,cSubInd.User_Defined_Tags__c,cSubInd.Targets_Established__c,true,cSubInd.PPR__c,cSubind.isActive__c,cSubind.indDataType__c);
            //}   
            IWU.terminateRow();
        }
    }
    
    public PageReference doSaveIndicators(){
        system.debug('Selected Tab:::' +selectedTab1);
        system.debug('Changed Row Ids' +changedRowIds);
        system.debug('Selected Objective:::' +selectedObjective);
        system.debug('Selected Source:::' +selectedSource);
        //system.debug('XML String in Save:::' +xmlString);
        ClsGlobalUtility GU = new ClsGlobalUtility();
        ClsIndicatorWizardUtility IWU = new ClsIndicatorWizardUtility();
        IWU.getUSAIDIndicatorsByObjectiveAndSource(selectedObjective,selectedSource);
        //system.debug('OrgUnit Selected::::' +selectedOrgUnit);
        IWU.getOrgUnitIndicatorsByOrgUnitId(selectedOrgUnit);
        OrgUnit__c org = (orgUnit__c) GU.lookup(selectedOrgUnit, 'OrgUnit__c');
        List<String> chndIds = changedRowIds.split(',');
        if (chndIds.size() == 0){
            chndIds.add(changedRowIds);
        }       
        Map<String,OrgUnit_Indicator__c> oInds = IWU.getOUIndsWithOUIndIdAndUSAIDIndIdAsKey();
        Map<String,OrgUnit_Indicator__c> oCIndByCode = IWU.getOUIndsWithIndCodeSIndCodeAsKey();
        Map<String,USAID_Indicator__c> uInds = IWU.getUSAIDIndsWithUSAIDIndIdAsKey();
        List<OrgUnit_Indicator__c> oIndsToUpsert = new List<OrgUnit_Indicator__c>(); 
        List<OrgUnit_Indicator__c> oIndsToDelete = new List<OrgUnit_Indicator__c>(); 
        parse(xmlString);
        //system.debug('iTreeMap:::' +oCIndByCode);
        system.debug('iTreeMap:::' +iTreeMap);
        //system.debug('Existing Org Unit Indicators:::' +oInds);
        system.debug('Changed Row Id list::'+chndIds); 
        for(String cId: chndIds){
            system.debug('Changed Row Id Full::' +cId);
            //system.debug('Changed Row Id Substring1::' +cId.substring(1));
            OrgUnit_Indicator__c oIndicatorNew = new OrgUnit_Indicator__c();
            if (iTreeMap.containsKey(cId)){
                IndicatorTree iTree = iTreeMap.get(cId);
                 system.debug('iTree :::'+iTree);
                system.debug('iTree Selected Property:::'+cId +' :::: '+iTree.selected);
                if (iTree.selected){
                    system.debug('iTree Selected Property:::'+cId +' :::: '+iTree.selected);
                    system.debug('Org Inds:::'+oInds);
                    system.debug('USAID Inds:::'+uInds);
                    if (oInds.containsKey(cId.substring(1))){
                        system.debug('Org Unit Indicator Id Matched::' +cId.substring(1));
                        oIndicatorNew = oInds.get(cId.substring(1));
                        oIndicatorNew.indCode__c = iTree.indCode;
                        if (iTree.sIndCode == null || iTree.sIndCode == ''){
                            oIndicatorNew.Name = iTree.indCode;
                        } else {
                            oIndicatorNew.Name = iTree.sIndCode;
                        }    
                        oIndicatorNew.indName__c = iTree.indName;
                        oIndicatorNew.sIndCode__c = iTree.sIndCode;
                        oIndicatorNew.sIndName__c = iTree.sIndName;
                        //oIndicatorNew.USAID_Indicator_Id__c = cId.substring(1);
                        oIndicatorNew.indDataType__c = iTree.dataType;
                        oIndicatorNew.indType1__c = iTree.indType;
                        oIndicatorNew.PPR__c = iTree.pprFlag;
                        oIndicatorNew.isActive__c = iTree.activeFlag;
                        oIndicatorNew.User_Defined_Tags__c = iTree.userTag;
                        
                    } else {
                        if (uInds.containsKey(cId.substring(1))){
                            USAID_Indicator__c ui = uInds.get(cId.substring(1));
                            if (ui.indLevel__c == 'Indicator'){
                                oIndicatorNew.indCode__c = iTree.indCode;
                                oIndicatorNew.indName__c = iTree.indName;
                                oIndicatorNew.Name = iTree.indCode;
                            } else {
                                oIndicatorNew.indCode__c = ui.indCode__c;
                                oIndicatorNew.Name = iTree.sindCode;
                                oIndicatorNew.indName__c = ui.indName__c;
                                oIndicatorNew.sIndCode__c = iTree.sindCode;
                                oIndicatorNew.sIndName__c = iTree.sindName;
                            }  
                            system.debug('Org Unit Indicator Id not Matched::' +cId.substring(1)); 
                            oIndicatorNew.User_Defined_Tags__c = iTree.userTag;
                            oIndicatorNew.PPR__c = iTree.pprFlag;
                            oIndicatorNew.isActive__c = iTree.activeFlag;
                            oIndicatorNew.USAID_Indicator_Id__c = cId.substring(1);
                            oIndicatorNew.indDataType__c = ui.indDataType__c;
                            oIndicatorNew.prCode__c = ui.prCode__c;
                            oIndicatorNew.prName__c = ui.prName__c;
                            oIndicatorNew.Custom__c = false;
                            oIndicatorNew.UOM__c = ui.UOM__c;
                            oIndicatorNew.indDataType__c = ui.indDataType__c;
                            oIndicatorNew.indType1__c = iTree.indType;
                            //oIndicatorNew.indDataMax__c = ui.indDataMax__c;
                            //oIndicatorNew.indDataMin__c = ui.indDataMin__c;
                            oIndicatorNew.Source__c = ui.Source__c;
                            oIndicatorNew.ouId__c = selectedOrgUnit;
                        } else {
                            if (iTree.sIndCode == null && String.isNotEmpty(iTree.indName)){
                                if(oCIndByCode.containsKey(iTree.indCode)){
                                    oIndicatorNew = oCIndByCode.get(iTree.indCode);
                                } 
                                oIndicatorNew.prCode__c = iTree.prCode;
                                oIndicatorNew.prName__c = iTree.prName;
                                oIndicatorNew.indDataType__c = iTree.dataType;
                                oIndicatorNew.indType1__c = iTree.indType;
                                oIndicatorNew.indCode__c = iTree.indCode;
                                oIndicatorNew.Name = iTree.IndCode;
                                system.debug('Ind Name::::'+iTree.IndName);
                                oIndicatorNew.indName__c = iTree.indName;
                                oIndicatorNew.sIndCode__c = iTree.sIndCode;
                                oIndicatorNew.sIndName__c = iTree.sIndName;
                                oIndicatorNew.PPR__c = iTree.pprFlag;
                                oIndicatorNew.isActive__c = iTree.activeFlag;
                                oIndicatorNew.User_Defined_Tags__c = iTree.userTag;
                                oIndicatorNew.Custom__c = true;
                                oIndicatorNew.Source__c = selectedSource;
                                oIndicatorNew.ouId__c = selectedOrgUnit;                            
                                
                            }   else if (String.isNotEmpty(iTree.sIndName)){
                                if(oCIndByCode.containsKey(iTree.sindCode)){
                                    oIndicatorNew = oCIndByCode.get(iTree.sIndCode);
                                }
                                oIndicatorNew.prCode__c = iTree.prCode;
                                oIndicatorNew.prName__c = iTree.prName;
                                oIndicatorNew.indDataType__c = iTree.dataType;
                                oIndicatorNew.indType1__c = iTree.indType;
                                oIndicatorNew.indCode__c = iTree.indCode;
                                oIndicatorNew.Name = iTree.sIndCode;
                                oIndicatorNew.indName__c = iTree.indName;
                                oIndicatorNew.sIndCode__c = iTree.sIndCode;
                                oIndicatorNew.sIndName__c = iTree.sIndName;
                                oIndicatorNew.PPR__c = iTree.pprFlag;
                                oIndicatorNew.isActive__c = iTree.activeFlag;
                                oIndicatorNew.User_Defined_Tags__c = iTree.userTag;
                                oIndicatorNew.Custom__c = true;
                                oIndicatorNew.Source__c = selectedSource;
                                oIndicatorNew.ouId__c = selectedOrgUnit;
                                
                            }
                        }                                               
                    }
                    oIndsToUpsert.add(oIndicatorNew);
                } else {
                    if (oInds.containsKey(cId.substring(1))){
                     oIndicatorNew = oInds.get(cId.substring(1));
                     oIndsToDelete.add(oIndicatorNew);
                    }
                }
            }
        }
         
        //system.debug('List to Insert:::::::::'+oIndsToUpsert);
        //system.debug('List to Delete:::::::::'+oIndsToDelete);
        upsert oIndsToUpsert;
        delete oIndsToDelete;
        if (!oIndsToUpsert.isEmpty()){
            org.Indicators_Established__c = true;
            //system.debug('Upsert Org:::::::::'+org);
            ApplicationConstants.byPassOrgUnitBeforeUpsert = true;
            Applicationconstants.byPassOrgUnitAfterUpdateGoals = true;
            upsert org;
            ApplicationConstants.byPassOrgUnitBeforeUpsert = false;
            Applicationconstants.byPassOrgUnitAfterUpdateGoals = false;
        }
        system.debug('Button Id:::::::::'+buttonId);
        system.debug('Button Id:::::::::'+buttonId1);
        PageReference ref;
        if(buttonId.equalsIgnoreCase('saveClose')){
            ref = new PageReference('/' + selectedOrgUnit); 
        }
        if(buttonId != null && buttonId.equalsIgnoreCase('save')) {
            //system.debug('Selected Tab:::' +selectedTab1);            
            ref = new PageReference('/apex/vfManageOrganizationIndicators?id=' + selectedOrgUnit+'&sSrc='+selectedSource+'&sObj='+selectedObjective); 
          //changedRowIds = null;
          //getTreeXMLNewMethod();
          //return null;
        } else {
            ref = new PageReference('/' + selectedOrgUnit); 
        }
        //PageReference ref = new PageReference('/' + selectedOrgUnit);
        //PageReference ref = new PageReference('/apex/vfManageOrganizationIndicators?id=' + selectedOrgUnit);    
        ref.setRedirect(true);
        return ref;
    }
    
    
    private void parse(String toParse) {
        DOM.Document doc = new DOM.Document();    
        Map<String, IndicatorTree> iTreeMap = new Map<String, IndicatorTree>();  
        try {
            system.debug('Parse String:::' +toParse);
            doc.load(toParse);    
            DOM.XMLNode root = doc.getRootElement();   
            //system.debug('Root Tag Name:::' +root.getName()); 
                
            for(Dom.XMLNode child: root.getChildElements()){
                walkThrough(child);
            }           
        } catch (System.XMLException e) {  
            //system.debug( e.getMessage());
        }
    }
    
    private void walkThrough(DOM.XMLNode node) {        
        Integer childCount = 0;
        Boolean rowInserted = false;
        IndicatorTree iTree = new IndicatorTree();
        
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT && node.getName().equalsIgnoreCase('row')) {
            String rowId = node.getAttributeValue(node.getAttributeKeyAt(0), node.getAttributeKeyNsAt(0));
            system.debug('Inside Walkthrough:::' +rowId);       
            
            for (Dom.XMLNode child: node.getChildElements()) {
                
                if(child.getName().equalsIgnoreCase('cell')){
                    if (childCount == 0){
                        if (rowId.startsWith('F'))  {
                            iTree.prCode = child.getAttributeValue(child.getAttributeKeyAt(0), child.getAttributeKeyNsAt(0));
                            //system.debug('Program Code:::'+iTree.prCode);                           
                        }  else if (rowId.startsWith('I')){
                            iTree.indCode = child.getAttributeValue(child.getAttributeKeyAt(0), child.getAttributeKeyNsAt(0));
                            if (iTreeMap.containsKey(child.getParent().getParent().getAttributeValue(child.getParent().getParent().getAttributeKeyAt(0), child.getParent().getParent().getAttributeKeyNsAt(0)))){
                                IndicatorTree fTree = iTreeMap.get(child.getParent().getParent().getAttributeValue(child.getParent().getParent().getAttributeKeyAt(0), child.getParent().getParent().getAttributeKeyNsAt(0)));
                                iTree.prCode = fTree.prCode;
                                iTree.prName = fTree.prName;
                            }
                            //system.debug('Indicator Code:::'+iTree.indCode);
                            //system.debug('Indicator Parent Code::'+child.getParent().getParent().getAttributeValue(child.getParent().getParent().getAttributeKeyAt(0), child.getParent().getParent().getAttributeKeyNsAt(0)));
                        } else if (rowId.startsWith('S')){
                            iTree.sindCode = child.getAttributeValue(child.getAttributeKeyAt(0), child.getAttributeKeyNsAt(0));
                            if (iTreeMap.containsKey(child.getParent().getParent().getParent().getAttributeValue(child.getParent().getParent().getParent().getAttributeKeyAt(0), child.getParent().getParent().getParent().getAttributeKeyNsAt(0)))){
                                IndicatorTree fTree = iTreeMap.get(child.getParent().getParent().getParent().getAttributeValue(child.getParent().getParent().getParent().getAttributeKeyAt(0), child.getParent().getParent().getParent().getAttributeKeyNsAt(0)));
                                iTree.prCode = fTree.prCode;
                                iTree.prName = fTree.prName;
                            }
                            if (iTreeMap.containsKey(child.getParent().getParent().getAttributeValue(child.getParent().getParent().getAttributeKeyAt(0), child.getParent().getParent().getAttributeKeyNsAt(0)))){
                                IndicatorTree fTree = iTreeMap.get(child.getParent().getParent().getAttributeValue(child.getParent().getParent().getAttributeKeyAt(0), child.getParent().getParent().getAttributeKeyNsAt(0)));
                                iTree.indCode = fTree.indCode;
                                iTree.indName = fTree.indName;
                            }
                            
                            //system.debug('Sub Indicator Code:::'+iTree.sindCode);
                            //system.debug('Sub Indicator Parent Code::'+child.getParent().getParent().getParent().getAttributeValue(child.getParent().getParent().getParent().getAttributeKeyAt(0), child.getParent().getParent().getParent().getAttributeKeyNsAt(0)));
                            //system.debug('Sub Indicator Parent Code::'+child.getParent().getParent().getParent().getText());
                        }                       
                    } else if (childCount == 1){
                        if (rowId.startsWith('F'))  {
                            iTree.prName = child.getText();
                        }  else if (rowId.startsWith('I')){
                            iTree.indName = child.getText();
                        } else if (rowId.startsWith('S')){
                            iTree.sindName = child.getText();
                        } 
                    } else if (childCount == 2){
                        iTree.usaidTag = child.getText(); 
                    } else if (childCount == 3){
                        iTree.userTag = child.getText();
                    } else if (childCount == 4){
                        if(child.getText() == '1'){
                            iTree.dataType = 'Numeric';
                        } else if(child.getText() == '2'){
                            iTree.dataType = 'Percentage';
                        } else if(child.getText() == '3'){
                            iTree.dataType = 'Currency';
                        } else if(child.getText() == '4'){
                            iTree.dataType = 'Text';
                        } else {
                            iTree.dataType = child.getText();
                        }
                    } else if (childCount == 5){
                        if(child.getText() == '1'){
                            iTree.indType = 'Direct';
                        } else if(child.getText() == '2'){
                            iTree.indType = 'Import';
                        } else if(child.getText() == '3'){
                            iTree.indType = 'Outcome';
                        } else if(child.getText() == '4'){
                            iTree.indType = 'Output';
                        } else {
                            iTree.indType = child.getText();
                        }
                    } else if (childCount == 6){
                        if (child.getText() == '1'){
                            iTree.pprFlag = true;   
                        } else {
                            iTree.pprFlag = false;
                        }                       
                    } else if (childCount == 7){
                        if (child.getText() == '1'){
                            iTree.activeFlag = true;    
                        } else {
                            iTree.activeFlag = false;
                        }                       
                    } else if (childCount == 8){
                        if (child.getText() == '1'){
                            iTree.customFlag = true;  
                        } else {
                            iTree.customFlag = false;
                        }
                    } else if (childCount == 9){
                        if (child.getText() == '1' || child.getText() == 'true'){
                            iTree.selected = true;  
                        } else {
                            iTree.selected = false;
                        }  
                        iTreeMap.put(rowId, iTree);
                        rowInserted = true;                 
                    }
                    childCount++;
                }  else {                   
                    walkThrough(child); 
                } 
                
            }
            if (!rowInserted){
                iTreeMap.put(rowId, iTree);
            }   
        }
         
    }   
   
    public class IndicatorTree{
        public String rowId;
        public String prCode;
        public String prName;       
        public String indCode;
        public String indName;
        public String sIndCode;
        public String sIndName;
        public String usaidTag;
        public String userTag;
        public String indType;
        public Boolean pprFlag;
        public Boolean activeFlag;
        public Boolean customFlag;
        public Boolean selected;
        public String dataType;
    }
    
   Public pageReference Cancel(){ 
   
        PageReference pageRef;
        
         String cancelReturn= ApexPages.currentpage().getParameters().get('retURL');         
         if(cancelReturn!= null){
            pageRef = new PageReference(cancelReturn);  
         }else{ 
                if(selectedOrgUnit != null && selectedOrgUnit !='')
                   pageRef = new PageReference('/' + selectedOrgUnit );  
                else
                   pageRef = new PageReference('/apex/vfMonitoringTab');  
        }
        pageRef.setRedirect(true);
        return pageRef ;
   } 
   
     @IsTest public static void testClsOrgUnitIndicatorSController() {
            
            
            ClsTestUtility testIndicatorUtil = new ClsTestUtility();
            Framework__c objective = testIndicatorUtil.getFrameworks('Objective');
            Framework__c area = testIndicatorUtil.getFrameworks('Area');
            Framework__c element = testIndicatorUtil.getFrameworks('Element');
            Framework__c sElement = testIndicatorUtil.getFrameworks('SubElement');
            List<Framework__c> ftfList = testIndicatorUtil.getFTFFrameworks();
            
            String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
            List<USAID_Indicator__c> uInds = testIndicatorUtil.getUSAIDIndicatorRecords();
            List<OrgUnit_Indicator__c> masterInds = testIndicatorUtil.getIndicatorsForOrgId(OrgUnitId, uInds);
            List<OrgUnit_Indicator__c> cmasterInds =testIndicatorUtil.getCustomIndicatorRecordsForOrgId(OrgUnitId);
            
            String changedIds;            
           // OrgUnit_Indicator__c sInd = new OrgUnit_Indicator__c();
           // OrgUnit_Indicator__c pInd = new OrgUnit_Indicator__c();
           // OrgUnit_Indicator__c fInd = new OrgUnit_Indicator__c(); 
            for(OrgUnit_Indicator__c oInd: masterInds){
             //   if (oInd.Source__c == 'Standard' && oInd.prCode__c == '1'){
             //       sInd = oInd;
             //   } else if(oInd.Source__c == 'FTF'){
             //       fInd = oInd;
             //   } else if(oInd.Source__c == 'PEPFAR'){
             //       pInd = oInd;
             //   }
                if (oInd.sIndCode__c == null){
                 if(changedIds != null){
                     changedIds =   changedIds + ',I'+ oInd.Id;             
                 } else {  changedIds =  'I'+ oInd.Id; }  
                } else {
                    if(changedIds != null){
                     changedIds =   changedIds + ',S'+ oInd.Id;             
                     } else {  changedIds =  'S'+ oInd.Id; } 
                
                
                } 
            }
            
            for(OrgUnit_Indicator__c oInd: cmasterInds){
                if (oInd.sIndCode__c == null){
                 if(changedIds != null){
                     changedIds =   changedIds + ',I'+ oInd.Id;             
                 } else {  changedIds =  'I'+ oInd.Id; }  
                } else {
                    if(changedIds != null){
                     changedIds =   changedIds + ',S'+ oInd.Id;             
                     } else {  changedIds =  'S'+ oInd.Id; } 
                
                
                } 
            }
            //changedIds = sInd.Id + ','+fInd.Id+','+pInd.Id;
            ApexPages.currentPage().getParameters().put('Id', OrgUnitId); 
            ClsOrgUnitIndicatorSController controller = new ClsOrgUnitIndicatorSController();
            
            controller.selectedOrgUnit= OrgUnitId;                        
            controller.getOrgUnits();
            controller.selectedSource='Standard';
            controller.getObjectives();
            controller.selectedObjective = '1';
            
            controller.getPepfarObjectives();
            controller.getTreeXMLNew();
            //String xmlStr = controller.get
            controller.changedRowIds = changedIds;
            controller.buttonId = 'Save';
            controller.doSaveIndicators();
           // controller.buttonId = 'SaveClose';
            //controller.doSaveIndicators();
            controller.Cancel();
            
            controller.selectedSource='PEPFAR';
            controller.selectedObjective = 'C';
            controller.getObjectives();
            controller.getPepfarObjectives();
            controller.getTreeXMLNew();
            controller.doSaveIndicators();
            controller.Cancel();
            
            controller.selectedSource='FTF';
            controller.selectedObjective = '3';
            controller.getObjectives();
            controller.getPepfarObjectives();
            controller.getTreeXMLNew();
            controller.doSaveIndicators();
            controller.Cancel();
            
            controller.selectedSource='Custom';
            controller.getObjectives();
            controller.getPepfarObjectives();
            controller.getTreeXMLNew();
            controller.doSaveIndicators();
            controller.Cancel();
     }   
  
}