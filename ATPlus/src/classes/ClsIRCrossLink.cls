public with sharing class ClsIRCrossLink {
    
     public string irId;
     Public String xmlStr{get;set;}  
     public IR__c intRes{get;set;}
     public DO__c devObj{get;set;}
     public String selectedDos{get;set;} 
                        
     List<DO__c> doList = new List<DO__c>();
     Map<String,DO__c> doMap = new Map<String,DO__c>();
     List<String> sortedDoKeys = new List<String>();
     List<CDCSLINK__c> eLinks = new List<CDCSLINK__c>();
     Map<String,CDCSLINK__c> eLinkMap = new Map<String,CDCSLINK__c>();    
     
    //Constructor
    
    Public ClsIRCrossLink (apexpages.standardcontroller controller) {
        
    irId= ApexPages.currentpage().getParameters().get('Lid');
    
    intRes = [select ID, Name, DO_Id__c, Goal_Id__c, ownerId from IR__c where id = :irId];
    
    devObj = [select ID, Name, ouCode__c from DO__c where id = :intRes.DO_Id__c];
    
    doList =  [SELECT DO_Code__c, ID, Name,  DO_Title__c from DO__c WHERE ouCode__c = :devObj.ouCode__c ORDER BY DO_Code__c ASC];
    
    //doList.sort();
    system.debug('Sorted List' +doList);
    
    for(DO__c d : doList){
            sortedDoKeys.add(d.Id);
            doMap.put(d.Id, d); 
   //       System.debug( '::::::::::::: ' + doMap.get(d.id)) ;
    }
 
    // Existing Cross Linkages..
 
    eLinks = [select DO_Code__c, Id, Name, DO_Id__c,  DO_Title__c, Link_Type__c From CDCSLINK__c where IR_Id__c = :irId and SIR_Id__c = null];
    
    for(CDCSLINK__c c : eLinks){
        
        eLinkMap.put(c.DO_Id__c, c);
    }
        
    prepareIrsXML();  
        
}

public void prepareIrsXML()

{
        Xmlstreamwriter xmlW = new Xmlstreamwriter();
        xmlW.writeStartDocument('UTF-8','1.0');
        xmlW.writeStartElement(null,'rows', null);
        xmlW.writeAttribute(null,null,'id','0');
        
             
        for(String rId: sortedDoKeys)
        {   
            System.debug('::::::::::::: ' +rId);
            DO__c dObj = new DO__c();
            dObj = doMap.get(rId);
            
            xmlW.writeStartElement(null,'row',null); 
            xmlW.writeAttribute(null,null,'id',dObj.Id);
            xmlW.writeAttribute(null,null,'open','1'); 
            if (eLinkMap.containsKey(dObj.Id)){
                CDCSLINK__c clinkTemp = new CDCSLINK__c();
                clinkTemp = eLinkMap.get(dObj.Id);
                System.Debug('Before the Primary DO Cond:::' +clinkTemp);
                if(clinkTemp.Link_Type__c == 'Primary DO'){
                    xmlW.writeAttribute(null,null,'locked','1');
                    xmlW.writeAttribute(null,null,'style','background-color: #E0DADA');                 
                }
                     
            } 
            xmlW.writeStartElement(null,'cell',null);
            xmlw.writeCharacters(dObj.DO_Code__c);
            xmlW.writeEndElement();     
            xmlW.writeStartElement(null,'cell',null);
            xmlw.writeCharacters(dObj.DO_Title__c);
            xmlW.writeEndElement();
            xmlW.writeStartElement(null,'cell',null);
            if (eLinkMap.containsKey(dObj.Id)){             
                xmlw.writeCharacters('true');
            } 
            xmlW.writeEndElement(); 
            xmlW.writeEndElement();
        }
        
        xmlW.writeEndElement();
        xmlW.writeEndDocument();
        xmlStr = xmlW.getXmlString();
        xmlStr = xmlStr.replaceAll('\'','');
 }

Public pageReference insertIrs(){  
    
  List<CDCSLINK__c> newlinkList = new List<CDCSLINK__c>();
  List<CDCSLINK__c> dellinkList = new List<CDCSLINK__c>();
  
  List<String> selectedDoList = new List<String>(); 
  
  if (selectedDos != null && selectedDos != ''){
    selectedDoList = selectedDos.split(',');
  
      for(String doStr: selectedDoList ){
        CDCSLINK__c cdcsLinkRec = new CDCSLINK__c();
        //System.debug('DO Str:::' +doStr);
        //System.debug('DO Map:::' +doMap);
        if (!eLinkMap.containsKey(doStr)){
            DO__c  doRec = doMap.get(doStr);
            //System.debug('DO Rec:::' +doRec);
            cdcsLinkRec.CDCSGoal_Id__c = intRes.Goal_Id__c;
            cdcsLinkRec.DO_Id__c = doRec.Id;
            cdcsLinkRec.IR_Id__c = intRes.id;
            cdcsLinkRec.Link_Type__c = 'Secondary DO';
            cdcsLinkRec.ownerId = intRes.OwnerId;
            newlinkList.add(cdcsLinkRec);   
        }
        
      }
      upsert newlinkList;
      
      Set<String> selectedDosSet = new Set<String>();
      selectedDosSet.addAll(selectedDoList);
      for(String dId: eLinkMap.keySet()){
        if(!selectedDosSet.contains(dId)){
            dellinkList.add(eLinkMap.get(dId));
        }
      }
      delete dellinkList;
       
    } 
   
      PageReference pageRef = new PageReference('/' + irId ); 
      pageRef.setRedirect(true);
      return pageRef ;
}        
 
Public pageReference Cancel(){ 
  
  PageReference pageRef = new PageReference('/' + irId ); 
  pageRef.setRedirect(true);
  return pageRef ;
}

Public pageReference displayTree(){
      
  PageReference pageRef = new PageReference('/apex/vfCDCSTree?Lid='+irId ); 
  pageRef.setRedirect(true);
  return pageRef ;
}                  

}