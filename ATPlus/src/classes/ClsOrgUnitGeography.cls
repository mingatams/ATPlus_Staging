public class ClsOrgUnitGeography 
{
    //Variables
    public string orgUnitId;
    Public String xmlStr{get;set;}  
    public OrgUnit__c orgUnit{get;set;}
    public String selectedCountries{get;set;}
    
    Public String ShowCreateButton{get;set;}
    Public String ShowErrors{get;set;}
    Public String LErrors{get;set;}
    
    Map<String,orgUnitGeography__c> orgGeographyMap = new Map<String,orgUnitGeography__c>();
    
    
    Map<String, geoRegion__c> regionMap = new Map<String,geoRegion__c>();
    Map<String, geoCountry__c> countryMap = new Map<String,geoCountry__c>();
    Map<String,List<geoCountry__c>> rcountryMap = new Map<String,List<geoCountry__c>>();
    List<String> selectedCountryList = new List<String>();
    
    //Constructor
    Public ClsOrgUnitGeography(apexpages.standardcontroller controller)
    {
        orgUnitId = ApexPages.currentpage().getParameters().get('Lid');
        System.debug('OrgUnit ID::' +orgUnitId);
        
        orgUnit = [select ID, ouName__c, ouId__c, ouCode__c, ouDisplayName__c from OrgUnit__c where id = :orgUnitId];
        
        List<orgUnitGeography__c> orgGeographyList = new List<orgUnitGeography__c>([
                                            select ID,Name, orgUnitId__c, orgUnitName__c, cntryID__c, cntryCode__c, cntryName__c 
                                            From orgUnitGeography__c Where orgUnitId__c = :orgUnitId]);
                
        System.debug('Before Creating OrgGeography Map:::' +orgGeographyList.size());
        
        for(orgUnitGeography__c og: orgGeographyList)
        {
            System.debug('Inside Geography Map Creation:::' +og.Id);
            orgGeographyMap.put(og.cntryID__c,og);          
        }   
        
        System.debug('After Creating OrgGeography Map:::' +orgGeographyList.size());
        
        List<geoRegion__c> geoRegionList = new List<geoRegion__c>([
                                            select ID,Name, regCode__c, regName__c 
                                            From geoRegion__c]);
                
        System.debug('GeoRegion List:::' +geoRegionList.size());
        
        for(geoRegion__c gr: geoRegionList)
        {
            regionMap.put(gr.ID,gr);            
        }
        
        List<geoCountry__c> geoCountryList = new List<geoCountry__c>([
                                            select ID,Name, cntryCode__c, cntryName__c, regId__c, regCode__c  
                                            From geoCountry__c]);
                
        System.debug('GeoCountry List:::' +geoCountryList.size());
        
        for(geoCountry__c gc: geoCountryList)
        {
            countryMap.put(gc.ID,gc);           
        }
        
     /*   for (String rID: regionMap.keySet()){
        	List<geoCountry__c> tCountries = new List<geoCountry__c>();
        	for(String cID : countryMap.keySet()){
        		geoCountry__c gc = new geoCountry__c();
        		gc = countryMap.get(cID);
        		if(rID == gc.regId__c){
        			tCountries.add(gc);		
        		}
        	}
        	rcountryMap.put(rID, tCountries);
        } */
                
        
        ShowCreateButton='false';
        ShowErrors ='false';     
        LErrors='';
                
        prepareGeoRegionCountriesXML();
                
    }
    
    public void prepareGeoRegionCountriesXML()
    {
        Xmlstreamwriter xmlW = new Xmlstreamwriter();
        xmlW.writeStartDocument('UTF-8','1.0');
        xmlW.writeStartElement(null,'rows', null);
        xmlW.writeAttribute(null,null,'id','0');
        Integer displayCount = 0;
        
        for(String rId: regionMap.keySet())
        {
            geoRegion__c gRegion = new geoRegion__c();
            gRegion = regionMap.get(rId);
           // List<geoCountry__c> dispCntryList = new List<geoCountry__c>();
           // dispCntryList = rcountryMap.get(rId);
  		//	if (!dispCntryList.isEmpty()){  				      
	            xmlW.writeStartElement(null,'row',null); 
	            xmlW.writeAttribute(null,null,'id',gRegion.Id);
	            xmlW.writeAttribute(null,null,'open','1'); 
	            xmlW.writeStartElement(null,'cell',null);
	            xmlw.writeCharacters('&nbsp&nbsp&nbsp'+gRegion.regCode__c);
	            xmlW.writeEndElement();     
	            xmlW.writeStartElement(null,'cell',null);
	            xmlw.writeCharacters(gRegion.regName__c);
	            xmlW.writeEndElement();
	            
	           // Map<String,geoCountry__c> tempCountryMap = new Map<String,geoCountry__c>();
	            for(String cId: countryMap.keySet())
	            {
	                geoCountry__c gCountry = new geoCountry__c();
	                gCountry = countryMap.get(cId);
	                if(gRegion.regCode__c == gCountry.regCode__c){	                    
	                    xmlW.writeStartElement(null,'row',null); 
	                    xmlW.writeAttribute(null,null,'id',gCountry.Id);
	                    if (orgGeographyMap.containsKey(gCountry.Id)){
	                    	xmlW.writeAttribute(null,null,'locked','1');
	                    	xmlW.writeAttribute(null,null,'style','background-color: #E0DADA');
	                    }	
	                    xmlW.writeAttribute(null,null,'open','1'); 
	                    xmlW.writeStartElement(null,'cell',null);
	                    string flagName = ((string)gCountry.cntryName__c).replaceAll(' ','_');
	                    xmlW.writeAttribute(null,null,'image',flagName+'.png');
	                    xmlw.writeCharacters('&nbsp&nbsp&nbsp'+gCountry.cntryCode__c);
	                    xmlW.writeEndElement();     
	                    xmlW.writeStartElement(null,'cell',null);
	                    xmlw.writeCharacters(gCountry.cntryName__c);
	                    xmlW.writeEndElement();
	                    xmlW.writeStartElement(null,'cell',null);
	                    if (orgGeographyMap.containsKey(gCountry.Id)){
	                    	xmlw.writeCharacters('true');
	                    }	
	                    xmlW.writeEndElement();
	                    xmlW.writeEndElement();
	                    displayCount++;                     
	                
	                }
	            }   
	            xmlW.writeEndElement();
  		//	}        
        }
        
        xmlW.writeEndElement(); //Tree    
        xmlW.writeEndDocument(); //Close XML document
        xmlStr = xmlW.getXmlString();
        System.debug('Region Countries XML String:::' +xmlStr);
        
         if(displayCount > 0){
                ShowCreateButton='true';
            } else {
                ShowCreateButton='false'; 
                LErrors = 'All the available Countries for this Org Unit were selected.';
                } 
    }
    
    
  
  Public pageReference insertGeography(){  
    
  List<orgUnitGeography__c> orgGeographyList = new List<orgUnitGeography__c>();
  List<String> selectedCountryList = new List<String>(); 
  //selectedCountryList.clear();      
  
 if (selectedCountries != null && selectedCountries != ''){ 
 	selectedCountryList = selectedCountries.split(',');
  for(String countryStr: selectedCountryList ){
    orgUnitGeography__c orgGeography = new orgUnitGeography__c();
    orgGeography.orgUnitId__c = orgUnit.Id;
    orgGeography.cntryID__c = countryStr;
    
    orgGeographyList.add(orgGeography);
  }
  
  upsert orgGeographyList; 
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