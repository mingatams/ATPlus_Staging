public with sharing class ClsProjectFrameworkLink {

public String xmlStr{get;set;}
public string prId;
public string projectName{get;set;}
public string prStr;
public Project__c prj{get;set;}
public string selectedElements{get;set;}
public String navigationLink { get; set;}      
public clsGlobalUtility globalUtil = new clsGlobalUtility();   

Set<Framework__c> objSet = new Set<Framework__c>();
Map<String,List<Framework__c>> MasterMap = new Map<String,List<Framework__c>>();
//Map<String,Framework_Linkage__c> existLinkMap = new Map<String,Framework_Linkage__c>();
Map<String,FWTree> iTreeMap = new Map<String,FWTree>();


Public ClsProjectFrameworkLink(apexpages.standardcontroller controller){
    
    prId= ApexPages.currentpage().getParameters().get('Lid');   
    
         if(prId!= null)
            navigationLink= globalUtil.createBreadCrumps(prId);      
          System.Debug('navigationLink*****  ' + navigationLink);
    
    prj=[select ID, Name, ouId__c, ouCode__c, Public_Name__c from Project__c where id = :prId];
    projectName = prj.Public_Name__c;
    
    /*List<Framework_Linkage__c> existLinkList = new List<Framework_Linkage__c>([Select ouName__c, ouCode__c, Project_Name__c, Project_Id__c, OwnerId, Organization_Id__c, 
                                                Name, Id, Framework_Id__c, Facts_Name__c, Facts_Element_Type__c From Framework_Linkage__c 
                                                where Project_Id__c =: prId]);  
    for(Framework_Linkage__c eLink : existLinkList){
            existLinkMap.put(eLink.Framework_Id__c,eLink);          
    }*/
        
    
    List<Framework__c> FWTreeList = new List<Framework__c>([Select seName__c, seCode__c, poName__c, poCode__c, peName__c, 
                           peCode__c, paName__c,paCode__c, factsName__c, factsCode__c, SystemModstamp, Selection_Indicator__c, 
                           OwnerId, Name, LastModifiedDate, LastModifiedById, IsDeleted, Indicator_Wizard_Display__c, Id, 
                           CreatedDate, CreatedById, Facts_Element_Type__c From Framework__c 
                           Order By poCode__c, paCode__c, peCode__c, seCode__c]);
                           
        List<Framework__c> tempList = new List<Framework__c>();
        for(Framework__c FWTree: FWTreeList){
            //List<Framework__c> tempList = new List<Framework__c>();   
            if(FWTree.Facts_Element_Type__c == 'Objective'){                
                objSet.add(FWTree);
            } else if(FWTree.Facts_Element_Type__c == 'Area') {         
                if(MasterMap.containsKey(FWTree.poCode__c)){
                    tempList =  MasterMap.get(FWTree.poCode__c);
                } else {
                    tempList = new List<Framework__c>();
                }
                tempList.add(FWTree);
                MasterMap.put(FWTree.poCode__c,tempList);
            } else if(FWTree.Facts_Element_Type__c == 'Element' && FWTree.Selection_Indicator__c == true){
                if(MasterMap.containsKey(FWTree.paCode__c)){
                    tempList =  MasterMap.get(FWTree.paCode__c);
                } else {
                    tempList = new List<Framework__c>();
                }
                tempList.add(FWTree);
                MasterMap.put(FWTree.paCode__c,tempList);
            } else if(FWTree.Selection_Indicator__c == true){
                if(MasterMap.containsKey(FWTree.peCode__c)){
                    tempList =  MasterMap.get(FWTree.peCode__c);
                } else {
                    tempList = new List<Framework__c>();
                }
                tempList.add(FWTree);
                MasterMap.put(FWTree.peCode__c,tempList);
            }
        }
        system.debug('Objectives Display:::' +objSet);
        system.debug('Master Map Display:::' +MasterMap);
        
    prepareElementXML();
}

private Map<String,Framework_Linkage__c> getexistLinkMap(){
    Map<String,Framework_Linkage__c> existLinkMap = new Map<String,Framework_Linkage__c>();
    List<Framework_Linkage__c> existLinkList = new List<Framework_Linkage__c>([Select ouName__c, ouCode__c, Project_Name__c, Project_Id__c, OwnerId, Organization_Id__c, 
                                                Name, Id, Framework_Id__c, Facts_Name__c, Facts_Element_Type__c From Framework_Linkage__c 
                                                where Project_Id__c =: prId]);  
    for(Framework_Linkage__c eLink : existLinkList){
            existLinkMap.put(eLink.Framework_Id__c,eLink);          
    }
    return existLinkMap;
    
}

    public void prepareElementXML() {
        
            Map<String,Framework_Linkage__c> existLinkMap = getexistLinkMap();
            Xmlstreamwriter xmlW = new Xmlstreamwriter();
            xmlW.writeStartDocument('UTF-8','1.0');
            xmlW.writeStartElement(null,'rows', null);
            xmlW.writeAttribute(null,null,'id','0');
            for (Framework__c obj: objSet){
                if(MasterMap.containsKey(obj.factsCode__c)){
                xmlW.writeStartElement(null,'row',null); 
                xmlW.writeAttribute(null,null,'id',obj.Id);
                xmlW.writeAttribute(null,null,'open','1'); 
                xmlW.writeStartElement(null,'cell',null);
                if(obj.poCode__c != null){
                xmlW.writeAttribute(null,null,'image','po.png');
                xmlw.writeCharacters(obj.poCode__c);
                }
                xmlW.writeEndElement();     
                xmlW.writeStartElement(null,'cell',null);
                if(obj.poName__c != null){
                xmlw.writeCharacters(obj.poName__c);
                }
                xmlW.writeEndElement();
                    for(Framework__c pa: MasterMap.get(obj.factsCode__c)){
                        if(MasterMap.containsKey(pa.factsCode__c)){
                        xmlW.writeStartElement(null,'row',null); 
                        xmlW.writeAttribute(null,null,'id',pa.Id);
                        xmlW.writeAttribute(null,null,'open','1'); 
                        xmlW.writeStartElement(null,'cell',null);
                        if(pa.paCode__c != null){
                        xmlW.writeAttribute(null,null,'image','pa.png');
                        xmlw.writeCharacters(pa.paCode__c);
                        }
                        xmlW.writeEndElement();     
                        xmlW.writeStartElement(null,'cell',null);
                        if(pa.paName__c != null){
                        xmlw.writeCharacters(pa.paName__c);
                        }
                        xmlW.writeEndElement();
                           for(Framework__c pe: MasterMap.get(pa.factsCode__c)){
                                if(MasterMap.containsKey(pe.factsCode__c)){
                                xmlW.writeStartElement(null,'row',null); 
                                xmlW.writeAttribute(null,null,'id',pe.Id);
                                xmlW.writeAttribute(null,null,'open','1'); 
                                xmlW.writeStartElement(null,'cell',null);
                                if(pe.peCode__c != null){
                                xmlW.writeAttribute(null,null,'image','pe.png');
                                xmlw.writeCharacters(pe.peCode__c);
                                }
                                xmlW.writeEndElement();     
                                xmlW.writeStartElement(null,'cell',null);
                                if(pe.peName__c != null){
                                xmlw.writeCharacters(pe.peName__c);
                                }
                                xmlW.writeEndElement();
                                xmlW.writeStartElement(null,'cell',null);
                                if (existLinkMap.containsKey(pe.Id)){
                                xmlw.writeCharacters('true');   
                                }
                                xmlW.writeEndElement();
                                    for(Framework__c se: MasterMap.get(pe.factsCode__c)){
                                        xmlW.writeStartElement(null,'row',null); 
                                        xmlW.writeAttribute(null,null,'id',se.Id);
                                        xmlW.writeAttribute(null,null,'open','1'); 
                                        xmlW.writeStartElement(null,'cell',null);
                                        if(se.seCode__c != null){
                                        xmlW.writeAttribute(null,null,'image','pse.png');
                                        xmlw.writeCharacters(se.seCode__c);
                                        }
                                        xmlW.writeEndElement();     
                                        xmlW.writeStartElement(null,'cell',null);
                                        if(se.seName__c != null){
                                        xmlw.writeCharacters(se.seName__c);
                                        }
                                        xmlW.writeEndElement();
                                        xmlW.writeStartElement(null,'cell',null);
                                        if (existLinkMap.containsKey(se.Id)){
                                        xmlw.writeCharacters('true');   
                                        }
                                        xmlW.writeEndElement();
                                        xmlW.writeEndElement();
                                    }
                                xmlW.writeEndElement();    
                                }
                            }
                        xmlW.writeEndElement();
                        }
                    }
                    xmlW.writeEndElement();
                }
                
            }
            xmlW.writeEndDocument();
            system.debug('XML Strin so far::::' +xmlW.getXmlString());   
            xmlStr = xmlW.getXmlString();
            xmlStr = xmlStr.replaceAll('\'','');
    }   

    Public pageReference saveElements(){
        
        system.debug('Changed Row Ids::::' +selectedElements);
        system.debug('XML to Parse::::' +xmlStr);
        
        xmlStr = xmlStr.replaceAll('&','');
        
        Map<String,Framework_Linkage__c> existLinkMap = getexistLinkMap();
        List<Framework_Linkage__c> linkRecsIns = new List<Framework_Linkage__c>();
        List<Framework_Linkage__c> linkRecsDel = new List<Framework_Linkage__c>();
        
        List<String> chndIds = new List<String>();
        if(selectedElements != '' && selectedElements != null){
            if(selectedElements.contains(',')){
                chndIds = selectedElements.split(',');
            } else {
                chndIds.add(selectedElements);
            }
        }
        system.debug('Change Ids Before Processing:::' +chndIds);
        parse(xmlStr);
        Map<Id,Framework__c> selectedTreeMap = new Map<Id,Framework__c>([Select seName__c, seCode__c, poName__c, poCode__c, peName__c, 
                           peCode__c, paName__c,paCode__c, factsName__c, factsCode__c, SystemModstamp, Selection_Indicator__c, 
                           OwnerId, Name, LastModifiedDate, LastModifiedById, IsDeleted, Indicator_Wizard_Display__c, Id, 
                           CreatedDate, CreatedById, Facts_Element_Type__c From Framework__c 
                           Order By poCode__c, paCode__c, peCode__c, seCode__c]);
        
        for(String cId: chndIds){
            System.debug('Change Ids::: ' +cId);
            System.debug('iTree Map:::::' +iTreeMap); 
            if (iTreeMap.containsKey(cId)){
                FWTree lTree = iTreeMap.get(cId);
                if (!lTree.selected && existLinkMap.get(cId) != null){                  
                    linkRecsDel.add(existLinkMap.get(cId));                 
                }               
            } 
        
            if(selectedTreeMap.containsKey(cId)){
                Framework_Linkage__c linkNew = new Framework_Linkage__c();
                Framework__c lTree = new Framework__c();                
                lTree = selectedTreeMap.get(cId);
                if (existLinkMap.containsKey(cId)){
                    linkNew = existLinkMap.get(cId);
                }
                linkNew.Name = lTree.factsCode__c;
                linkNew.Framework_Id__c = lTree.Id;
                linkNew.Project_Id__c = prId;
                linkNew.Facts_Element_Type__c = lTree.Facts_Element_Type__c;
                
                linkRecsIns.add(linkNew);
            } 
        } 
        
        if (!linkRecsIns.isEmpty()){
            System.debug('Test Upsert::::' +linkRecsIns);
            upsert linkRecsIns;
        }
        
        if (!linkRecsDel.isEmpty()){
            System.debug('Test Delete:::::' +linkRecsDel);
            delete linkRecsDel;
        }
        
        PageReference pageRef = new PageReference('/' + prId);  
        pageRef.setRedirect(true);
        return pageRef ;
    }
    
    private void parse(String toParse) {
        system.debug('To Parse String:::' +toParse); 
        DOM.Document doc = new DOM.Document();    
          
        try {
            doc.load(toParse);    
            DOM.XMLNode root = doc.getRootElement();   
            system.debug('Root Tag Name:::' +root.getName()); 
                
            for(Dom.XMLNode child: root.getChildElements()){
                walkThrough(child);
            }           
        } catch (System.XMLException e) {  
            system.debug( e.getMessage());
        }
    }
    
    private void walkThrough(DOM.XMLNode node) {        
        Integer childCount = 0;
        Boolean rowInserted = false;
        FWTree iTree = new FWTree();
        
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT && node.getName().equalsIgnoreCase('row')) {
            String rowId = node.getAttributeValue(node.getAttributeKeyAt(0), node.getAttributeKeyNsAt(0));       
            iTree.rowId = rowId;
            for (Dom.XMLNode child: node.getChildElements()) {
                
                if(child.getName().equalsIgnoreCase('cell')){
                    if (childCount == 0){      
                        iTree.Code = child.getText();                      
                    } else if (childCount == 1){      
                        iTree.NameStr = child.getText();                      
                    } else if (childCount == 2){    
                        if (child.getText() == '1'){
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
       System.debug('iTree Map:::::' +iTreeMap);  
    } 
    
    public PageReference cancel(){
        PageReference pageRef = new PageReference('/' + prId);  
        pageRef.setRedirect(true);
        return pageRef ;        
    }
    
    public class FWTree{        
        public String rowId;
        public String Code;   
        public String NameStr;          
        public Boolean selected;        
    }
    
     @IsTest(seealldata=false) public static void testClsProjectFrameworkLink() {
          ClsTestUtility testIndicatorUtil = new ClsTestUtility(); 
          List<Framework__c> frmList = new List<Framework__c>([select factsCode__c,poCode__c,paCode__c,peCode__c, seCode__c From Framework__c ]);
          System.debug('Existing Frsmeworks:::' +frmList); 
          Framework__c frm1 = new Framework__c();
          if (frmList.isEmpty()){      
              Framework__c frmo = testIndicatorUtil.getFrameworks('Objective');
              Framework__c frma = testIndicatorUtil.getFrameworks('Area');
              frm1 = testIndicatorUtil.getFrameworks('Element');
              Framework__c frms = testIndicatorUtil.getFrameworks('SubElement');
          }
          for(Framework__c frm: frmList){
              if(frm.peCode__c != null && frm.seCode__c == null){
                  frm1 = frm;
              }
          }
          String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());
          String projectId = testIndicatorUtil.getProjectForOrgId(OrgUnitId);    
          
          Framework_Linkage__c frmLink =  testIndicatorUtil.getFrameworkLinks(projectId,frm1.id, 'Program Element');  
          ApexPages.currentPage().getParameters().put('Lid', projectId);
          Project__c proj = [Select Id, Name, Start_Date__c, End_Date__c From Project__c where ouId__c= :OrgUnitId and Public_Name__c= 'Test Project' ];
          ApexPages.StandardController sc = new ApexPages.StandardController(proj);
          ClsProjectFrameworkLink CLF = new ClsProjectFrameworkLink(sc);
          CLF.saveElements(); 
          CLF.cancel();
      
     }

}