Public class MassUploadLocationNationalProjectGeo{
  public string ActivityId;
  Public String ActivityName{get;set;}
  Public String MissionName{get;set;}

  
  Public String xmlStr{get;set;} 
  Public String selectedProv{get;set;} 

 
  public Activity__c Acty{get;set;} 
  Public String LocCountry{get;set;}
  public  list<location1__c> loclist = new list<location1__c>();
 
 
  Public List<Project_Location__c> plocs{get;set;}
   
  Public Set<String> uniquelocs{get;set;} 
  Public String LocationsInserted{get;set;} 
  public Location1__c Loc{get;set;}
 
  Public String ShowCreateButton{get;set;}
  Public String ShowErrors{get;set;}
  Public String LErrors{get;set;}
  public String pgBlockTitle{get; set;}
  public List<GeoBoundary__c> prov;
  public List<geoRegion__c> georeg;  
  public Map<String,List<GeoBoundary__c>> geoCountryMap=new Map <String,List<GeoBoundary__c>>();
  public Map<String,List <GeoCountry__c>> geoRegCountryMap=new Map <String, List<GeoCountry__c>>();
  public Map<String,String> geoReg_Country_String_Map=new Map <String, String>();
  public List<GeoBoundary__c> geoboundaries=new List<GeoBoundary__c>();   
  Set<String>countries=new Set<string>();
  Set<String>georegs=new Set<string>();
  Map<String, GeoBoundary__c> geoBoundsMap = new Map<String,GeoBoundary__c>();
  
  public Set<String> uniqueLocations {get; set;}
  public Set<String> uniqueCountries {get; set;}
  
  public Map<String, GeoBoundary__c> provinceMap = new Map<String,GeoBoundary__c>();
  public List<GeoBoundary__c> selectedProvinces = new List<GeoBoundary__c>(); 
       
  Public String ShowExistingLocations{get;set;}
  public String methodText;
 
  Public MassUploadLocationNationalProjectGeo(apexpages.standardcontroller controller){
      System.debug('Inside the Constructor::' +controller);

      ActivityId = ApexPages.currentpage().getParameters().get('Lid');
      Id regionalRT=Schema.SObjectType.Activity__c.getRecordTypeInfosByName().get('Regional').getRecordTypeId();      
      Id globalRT = Schema.SObjectType.Activity__c.getRecordTypeInfosByName().get('Global').getRecordTypeId();
      
      Acty=[select name,id,activity_name__c,project_code__c,project_Name__c, Mission_Name__c, RecordTypeId, ouId__c from activity__c where id=: Activityid];    
     // locs=[select name, Activity_Location_Province__c, Activity_Location_Country__c, id from Location1__c where Activity__c=:Acty.ID];
      plocs = [select name, admin1BndryName__c, cntryName__c, id from Project_Location__c where ActivityId__c =:Acty.ID];
      // In place of this locations object ProjectLocations object should be used. Needs clarification on Project Location Object fields.
      
      Set<String>locsSet=new Set<String>();
      uniquelocs = new Set<String>();
      System.debug('Loc set Key'+plocs);
      for(Project_Location__c exloc:plocs){
       locsSet.add(exloc.admin1BndryName__c+'::'+exloc.cntryName__c);       
       uniquelocs.add(exloc.Name);      
      }
       
      system.debug('locs size ==>'+plocs.size());
      if (Acty.RecordTypeId != null){
         if (Acty.RecordTypeId == regionalRT ){                    
            pgBlockTitle = 'Create New Locations for Regional Project'; 
            methodText = 'Regional Project';        
         } else if(Acty.RecordTypeId == globalRT){
            pgBlockTitle = 'Create New Locations for Global Project';
            methodText = 'Global Project';
         }         
      } else {
         pgBlockTitle = 'Create New Locations for National Project';
         methodText = 'National Project';
      }
      
      system.debug('Mission name ==>'+Acty.Mission_Name__c);

      MissionName=Acty.Mission_Name__c;
      ShowCreateButton='false';
      ShowExistingLocations='false';
      ShowErrors ='false';     
      LErrors='';
      
      if(Acty.ouId__c != null){
        //  OrgUnit__c org=[select ID, ouName__c, ouId__c, ouCode__c, 
        //              ouDisplayName__c from OrgUnit__c where ((ouDisplayName__c =:Acty.Mission_Name__c) or (ouName__c=:Acty.Mission_Name__c))];
            
            OrgUnit__c org=[select ID, ouName__c, ouId__c, ouCode__c, 
                        ouDisplayName__c from OrgUnit__c where ID = :Acty.ouId__c];
            system.debug('orgUnit ..found'+org.id);
            list<orgUnitGeography__c> OrgUnitsGeo=[select id, cntryID__c, cntryName__c, cntryCode__c, 
                            orgUnitId__c, orgUnitName__c, UniqueRecordName__c from orgUnitGeography__c where orgUnitId__c =:org.id];
            Set<String>orgUnitgeos=new Set<string>();
            for(orgUnitGeography__c geos : OrgUnitsGeo){
                orgUnitgeos.add(geos.cntryID__c);
            }
            
            
            List<geoCountry__c> geocounties= [select ID, bgaCode__c, cntryBounds__c, cntryCode__c, cntryName__c, 
                                cntrydispName__c, regCode__c, regId__c, regName__c from geoCountry__c where id=:orgUnitgeos];
            for(geoCountry__c country : geocounties){
                countries.add(country.ID);
                system.debug('region ------here='+country.regName__c);
            }      
            
            geoboundaries= [select ID, adminBndryBounds__c, adminBndryId__c, adminBndryLatitude__c, adminBndryLongitude__c, adminBndryName__c, 
                            adminUniqueName__c, cntryId__c, cntryCode__c, cntryName__c from GeoBoundary__c where cntryId__c=:countries];
            
  
            for(GeoBoundary__c gb:geoboundaries){ 
                geoBoundsMap.put(gb.Id,gb);                
                String countryn=gb.cntryName__c;
                String namekey =gb.adminBndryName__c+ '::'+gb.cntryName__c;
                //System.debug('Name Key:::' +namekey);
                List <GeoBoundary__c> geobouns=new List<GeoBoundary__c>();   
                if(!locsSet.contains( namekey)){    
                    if(geoCountryMap.containsKey(countryn)){
                        geobouns=geoCountryMap.get(countryn);
                        geobouns.add(gb); 
                    } else {
                        geobouns.add(gb);          
                    }     
                    geoCountryMap.put(countryn, geobouns); 
                }         
            }

            for(geoCountry__c country : geocounties){
                System.debug('Country Disp Name:::'+country.cntryName__c+':Map:'+geoCountryMap);
                if( geoCountryMap.containsKey(country.cntryName__c)){       
                    countries.add(country.ID);
                    georegs.add(country.regName__c);
                    geoReg_Country_String_Map.put(country.cntrydispName__c, country.regName__c);
                    String countryr=country.regName__c;
                    List <GeoCountry__c> geocou=new List<GeoCountry__c>();        
                    if(geoRegCountryMap.containsKey(countryr)){
                        geocou=geoRegCountryMap.get(countryr);
                        geocou.add(country); 
                    } else {
                        geocou.add(country);          
                    }     
                    geoRegCountryMap.put(countryr, geocou); 
                }
              
            }   
            
            if(!geoCountryMap.isEmpty()){
                ShowCreateButton='true';
            } else {
                ShowCreateButton='false'; 
                if (!OrgUnitsGeo.isEmpty()){
                    LErrors = 'All the available Administrative 1 Boundaries (States, Proviences, etc.) for this activity were created as locations.';
                } else {
                    LErrors = 'Geography is not defined for this Orgunit.';
                }   
                
            } 


     } else {
        ShowErrors='true';        
        LErrors='Your activity does not have Mission. Please enter Mission Name for your activity.';
        system.debug('Error  ==> '+ShowErrors);
        }
        
       getProvinces();
}
 
  public void getProvinces(){ 
    
    
       
    Xmlstreamwriter xmlW = new Xmlstreamwriter();
    xmlW.writeStartDocument('UTF-8','1.0');
    xmlW.writeStartElement(null,'rows', null);
    xmlW.writeAttribute(null,null,'id','0');
    
    for(String region:georegs){
       system.debug('region ------'+region);
        xmlW.writeStartElement(null,'row',null); 
        xmlW.writeAttribute(null,null,'id',region);
        xmlW.writeAttribute(null,null,'open','1'); 
        xmlW.writeStartElement(null,'cell',null);
        xmlw.writeCharacters(region);
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        xmlW.writeEndElement();
        xmlW.writeStartElement(null,'cell',null);
        //xmlw.writeCharacters(pwl.countryName);
        xmlW.writeEndElement();     
        List <GeoCountry__c> geocoun=new List<GeoCountry__c>();    
        geocoun= geoRegCountryMap.get(region); 
        // for loop for country
 
        for(GeoCountry__c gc:geocoun){
          xmlW.writeStartElement(null,'row',null);
           system.debug('Country ------'+geocoun);
          xmlW.writeAttribute(null,null,'id',gc.cntrydispName__c);
           
          xmlW.writeAttribute(null,null,'open','1'); 
          xmlW.writeStartElement(null,'cell',null);
          string flagName = ((string)gc.cntryName__c).replaceAll(' ','_');
          system.debug('Flag1 ------'+flagName);
          xmlW.writeAttribute(null,null,'image',flagName+'.png');
          xmlw.writeCharacters('&nbsp&nbsp&nbsp'+gc.cntrydispName__c);
          xmlW.writeEndElement();
          xmlW.writeStartElement(null,'cell',null);
          xmlW.writeEndElement(); 
          xmlW.writeStartElement(null,'cell',null);
          xmlW.writeEndElement(); 
          xmlW.writeStartElement(null,'cell',null);
        
          xmlW.writeEndElement();
          // for loop for boundaries
          List<GeoBoundary__c> bounList = new List<GeoBoundary__c>();
          bounList=geoCountryMap.get(gc.cntryName__c);
            for(GeoBoundary__c bo : bounList){
            xmlW.writeStartElement(null,'row',null); 
            
            xmlW.writeAttribute(null,null,'id',bo.Id); 
            xmlW.writeAttribute(null,null,'open','1'); 
            xmlW.writeStartElement(null,'cell',null);
            string flagName1 = ((string)gc.cntryName__c).replaceAll(' ','_');
            system.debug('Flag-1 ------'+flagName1);
            xmlW.writeAttribute(null,null,'image',flagName1+'.png');
            xmlw.writeCharacters('&nbsp&nbsp&nbsp'+bo.adminBndryName__c);
            xmlW.writeEndElement();
            xmlW.writeStartElement(null,'cell',null);
            If(bo.adminBndryLatitude__c != null){
                xmlw.writeCharacters(bo.adminBndryLatitude__c);
            }
            xmlW.writeEndElement(); 
            xmlW.writeStartElement(null,'cell',null);
            If(bo.adminBndryLongitude__c != null){
                xmlw.writeCharacters(bo.adminBndryLongitude__c);
            }
            xmlW.writeEndElement(); 
            xmlW.writeStartElement(null,'cell',null);
            xmlW.writeEndElement();
            xmlW.writeEndElement();
             }
          // end loop for boundaries
          xmlW.writeEndElement();     
               
         }         
        //end loop for country 
        xmlW.writeEndElement();
      }    
          
    xmlW.writeEndElement(); //Tree    
    xmlW.writeEndDocument(); //Close XML document
    xmlStr = xmlW.getXmlString();
    System.debug('Countries XML String:::' +xmlStr);
    
  }
  
  public void getSelected(){
      System.debug('Inside getSelected:');  
      selectedProvinces.clear();
      
      List<String> uniqueSelected = selectedProv.split(',');
      
      if (!uniqueSelected.isEmpty()){
        for(String keyStr : uniqueSelected ){
            if (geoBoundsMap.containsKey(keyStr)){
                selectedProvinces.add(geoBoundsMap.get(keyStr));
            }
        }
        
      }
      
     
  }
  
  public List<GeoBoundary__c> GetSelectedProvinces(){
      if(selectedProvinces.size()>0){
          return selectedProvinces;
      } else {
          return null;
      }
  }
  
  Public pageReference insertLocations(){
        
      System.debug('************Insert Begin****************'); 
      getSelected();    
      List<Location1__c> locationsList = prepareLocations();
      upsert locationsList; 
      
      List<Project_Location__c> prLocationsList = prepareProjectLocations();
      upsert prLocationsList; 
      
      LocationsInserted='yes'; 
      PageReference pageRef = new PageReference('/' + ActivityId ); 
      pageRef.setRedirect(true);
      System.debug('************Insert End****************');
      return pageRef ;
      
   }        
 
  Public pageReference Cancel(){  
      PageReference pageRef = new PageReference('/' + ActivityId ); 
      pageRef.setRedirect(true);
      return pageRef ;
   }          
  
  
  
  public List<Location1__c> prepareLocations(){
    //getSelected();
    List<Location1__c> lList = new List<Location1__c>();    
    for(GeoBoundary__c pr: selectedProvinces ){
        Location1__c locan = new Location1__c();        
        locan.Name=pr.adminBndryName__c;
        locan.project_code__c=acty.project_Code__c;     
        locan.Activity_Location_Province__c  = pr.adminBndryName__c;      
             //  locan.Activity_Location_Country__c=MissionName;
        locan.Activity_Location_Country__c=pr.cntryName__c;
        system.debug('Location Latitude  ==> '+pr.adminBndryLatitude__c);
        locan.Activity_Location_Latitude__c=Decimal.Valueof(pr.adminBndryLatitude__c);
        locan.Activity_Location_Longitude__c=Decimal.Valueof(pr.adminBndryLongitude__c);
        locan.Activity__c=Acty.ID;
        
      
        lList.add(locan);   
    }
    return lList;   
  } 
  
  public List<Project_Location__c> prepareProjectLocations(){
   // getSelected();
    
    List<Project_Location__c> prLocationList = new List<Project_Location__c>();
    for(GeoBoundary__c pr: selectedProvinces ){
            
        Project_Location__c prLocation = new Project_Location__c();
        prLocation.Name = pr.adminBndryName__c;
        prLocation.ActivityId__c = Acty.ID;
        prLocation.admin1BndryId__c = pr.Id;
        prLocation.cntryId__c = pr.cntryId__c;
        prLocation.Precision_Extent__c = '4 - First Order Admin';
      //  prLocation.Project_Code__c =  acty.project_code__c;
        prLocation.method__c = methodText;
        
        prLocationList.add(prLocation);
       
    }
    return prLocationList;   
  }
  
  
}