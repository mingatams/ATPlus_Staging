public with sharing class ClsOrgUnitSector {
    public string orgUnitId;
    Public String xmlStr{get;set;}  
    public OrgUnit__c orgUnit{get;set;}
    public String selectedSectors{get;set;}
    
    Public String ShowCreateButton{get;set;}
    Public String ShowErrors{get;set;}
    Public String LErrors{get;set;}
    
    Map<String,orgUnitSector__c> orgSectorMap = new Map<String,orgUnitSector__c>();
    Map<String, Sector__c> SectorMap = new Map<String,Sector__c>();
    List<String> selectedSectorList = new List<String>();
    
    //Constructor
    Public ClsOrgUnitSector(apexpages.standardcontroller controller){
        
    orgUnitId = ApexPages.currentpage().getParameters().get('Lid');
    
    orgUnit = [select ID, ouName__c, ouId__c, ouCode__c, ouDisplayName__c from OrgUnit__c where id = :orgUnitId];
    
    List<orgUnitSector__c> orgSectorList = new List<orgUnitSector__c>([
                                            select ID,Name, ouId__c, ouCode__c, ouName__c, secId__c, secCode__c, secName__c 
                                            From orgUnitSector__c Where ouId__c = :orgUnitId]);
    
    List<Sector__c> SectorList = new List<Sector__c>([
                                            select ID,Name, secCode__c, secName__c 
                                            From Sector__c]);                                           
                                            
    for(orgUnitSector__c os: orgSectorList) 
        {
            orgSectorMap.put(os.secId__c,os);            
        }
        
    for(Sector__c sl: SectorList)
        {        
            SectorMap.put(sl.ID,sl);            
        } 
        
        ShowCreateButton='false';
        
        ShowErrors ='false';     
        LErrors='';

    prepareGeoSectorXML();  
        
}

public void prepareGeoSectorXML(){
        Xmlstreamwriter xmlW = new Xmlstreamwriter();
        xmlW.writeStartDocument('UTF-8','1.0');
        xmlW.writeStartElement(null,'rows', null);
        xmlW.writeAttribute(null,null,'id','0');
        Integer displayCount = 0;
        for(String rId: SectorMap.keySet())
        {
            Sector__c orSector = new Sector__c();
            orSector = SectorMap.get(rId);
            
            xmlW.writeStartElement(null,'row',null); 
            xmlW.writeAttribute(null,null,'id',orSector.Id);
            if (orgSectorMap.containsKey(orSector.Id)){
            	xmlW.writeAttribute(null,null,'locked','1');
            	xmlW.writeAttribute(null,null,'style','background-color: #E0DADA');
            	
            }
            xmlW.writeAttribute(null,null,'open','1'); 
            xmlW.writeStartElement(null,'cell',null);
            xmlW.writeAttribute(null,null,'image',orSector.secCode__c+'.png');
            xmlw.writeCharacters('&nbsp&nbsp&nbsp'+orSector.secCode__c);
            xmlW.writeEndElement();     
            xmlW.writeStartElement(null,'cell',null);
            xmlw.writeCharacters(orSector.secName__c);
            xmlW.writeEndElement();
            xmlW.writeStartElement(null,'cell',null);
            if (orgSectorMap.containsKey(orSector.Id)){
            	xmlw.writeCharacters('true');
            }
            xmlW.writeEndElement();
            xmlW.writeEndElement();
            displayCount++;
        
        }
        xmlW.writeEndElement();
        xmlW.writeEndDocument();
        xmlStr = xmlW.getXmlString();
        xmlStr = xmlStr.replaceAll('\'','');
        System.debug('Region Countries XML String:::' +xmlStr);
        
        if(displayCount > 0){
                ShowCreateButton='true';
            } else {
                ShowCreateButton='false'; 
                LErrors = 'All the available Sectors for this Org Unit were selected.';
                } 
        
}

Public pageReference insertSector(){  
    
  List<orgUnitSector__c> orgSectorList = new List<orgUnitSector__c>();
  List<String> selectedSectorList = new List<String>(); 
  
  System.debug('Selected Sectors:::::' +selectedSectors);
   
  if (selectedSectors != null && selectedSectors != ''){
  	selectedSectorList = selectedSectors.split(',');
  	  	 System.debug('Selected Sectors List:::::' +selectedSectorList);
	  for(String sectorStr: selectedSectorList ){
	    orgUnitSector__c orgSector = new orgUnitSector__c();
	    orgSector.ouId__c = orgUnit.Id;
	    orgSector.secId__c = sectorStr;
	    orgSectorList.add(orgSector);
	  }
	 upsert orgSectorList; 
  }
     
  
  PageReference pageRef = new PageReference('/' + orgUnitId ); 
  pageRef.setRedirect(true);
  return pageRef ;
   }        
 
  Public pageReference Cancel(){ 
  
  PageReference pageRef = new PageReference('/' + orgUnitId ); 
  pageRef.setRedirect(true);
  return pageRef ;
   } 
   
   
}