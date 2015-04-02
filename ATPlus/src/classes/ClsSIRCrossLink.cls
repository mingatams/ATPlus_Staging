public with sharing class ClsSIRCrossLink {
    public string sirId;
    Public String xmlStr{get;set;}
    public Sub_IR__c subIntRes{get;set;}  
    public IR__c intRes{get;set;}
    public DO__c devObj{get;set;}
    public String selectedIrs{get;set;} 
    public String doId{get;set;} 
                        
     List<IR__c> irList = new List<IR__c>();
     List<String> sortedIrListKeys = new List<String>();
     Map<String,IR__c> irMap = new Map<String,IR__c>();
     List<DO__c> doList = new List<DO__c>();
     List<String> sortedDoListKeys = new List<String>();
     Map<String,DO__c> doMap = new Map<String,DO__c>();
     Map<String,List<IR__c>> doIrMap = new Map<String,List<IR__c>>(); 
     List<CDCSLINK__c> eLinks = new List<CDCSLINK__c>();
     Map<String,CDCSLINK__c> eLinkMap = new Map<String,CDCSLINK__c>();    
     
    //Constructor
    
    Public ClsSIRCrossLink (apexpages.standardcontroller controller){
    
    sirId= ApexPages.currentpage().getParameters().get('Lid');
    
    subIntRes = [select ID, Name, IR_Id__c, ownerId from Sub_IR__c where id = :sirId];
    
    intRes = [select ID, Name, DO_Id__c from IR__c where id = :subIntRes.IR_Id__c];
    
    devObj = [select ID, Name, ouCode__c from DO__c where id = :intRes.DO_Id__c];
    
    doList =  [select ID, Name, DO_Code__c, DO_Title__c, Unique_Name__c from DO__c where ouCode__c = :devObj.ouCode__c order by DO_Code__c ASC];
    
     for(DO__c d : doList){
            sortedDoListKeys.add(d.Id);
            doMap.put(d.Id, d); 
     }
     
     System.debug('DO Map.. ::' +doMap );
     
     
         
            //DO__c doObj = new DO__c();
            //doObj = doMap.get(doId);
        
            irList = [select ID, Name, IR_Code__c, IR_Title__c, DO_Code__c, DO_Id__c, Goal_Id__c from IR__c where DO_Id__c IN :doMap.keySet() order by DO_Code__c,IR_Code__c];
     
            
        for(IR__c ir: irList)
         {
            sortedIrListKeys.add(ir.Id);
            irMap.put(ir.Id, ir);
                
            
         }
         
         
     System.debug('IR Map.. ::' +irMap );     
    
    for(String d : sortedDoListKeys){
        List<IR__c> tempIrList = new List<IR__c>();
        for(String i: sortedIrListKeys){
            IR__c ir = new IR__c();
            ir = irMap.get(i);
            if (ir.DO_Id__c == d){
                tempIrList.add(ir);
            }
        }
        doIrMap.put(d,tempIrList);
    }
    
    // Existing Cross Linkages..
    
    eLinks = [select Id, Name, IR_Id__c, IR_Code__c, IR_Title__c, Link_Type__c From CDCSLINK__c where SIR_Id__c = :sirId];
    
    for(CDCSLINK__c c : eLinks){
        
        eLinkMap.put(c.IR_Id__c, c);
        
    }
    
    
    
    
    System.debug('Existing Cross Linkages.. ::' +eLinkMap );
    
   
     
    prepareIrsXML();  
        
}

public void prepareIrsXML()

{
        Xmlstreamwriter xmlW = new Xmlstreamwriter();
        xmlW.writeStartDocument('UTF-8','1.0');
        xmlW.writeStartElement(null,'rows', null);
        xmlW.writeAttribute(null,null,'id','0');
        
        List<String> sortedDoIrKeys = new List<String>();
        sortedDoIrKeys.addAll(doIrMap.keySet());
        sortedDoIrKeys.sort();
        
        for(String dId: sortedDoListKeys)
        {
            DO__c dObj = new DO__c();
            dObj = doMap.get(dId);
            
            xmlW.writeStartElement(null,'row',null); 
            xmlW.writeAttribute(null,null,'id',dObj.Id);
            xmlW.writeAttribute(null,null,'open','1'); 
            xmlW.writeStartElement(null,'cell',null);
            xmlw.writeCharacters(dObj.DO_Code__c);
            xmlW.writeEndElement();     
            xmlW.writeStartElement(null,'cell',null);
            xmlw.writeCharacters(dObj.DO_Title__c);
            xmlW.writeEndElement();
                                 
            for(IR__c ir: doIrMap.get(dId))
                {                                     
                    xmlW.writeStartElement(null,'row',null); 
                    xmlW.writeAttribute(null,null,'id',dObj.id+':'+ir.id);
                    xmlW.writeAttribute(null,null,'open','1');
                     if (eLinkMap.containsKey(ir.Id)){
                        CDCSLINK__c clinkTemp = new CDCSLINK__c();
                        clinkTemp = eLinkMap.get(ir.Id);
                        System.Debug('Before the Primary IR Cond:::' +clinkTemp);
                        if(clinkTemp.Link_Type__c == 'Primary IR'){
                        xmlW.writeAttribute(null,null,'locked','1');
                        xmlW.writeAttribute(null,null,'style','background-color: #E0DADA');                 
                        }
                     } 
                     
                    xmlW.writeStartElement(null,'cell',null);
                    xmlw.writeCharacters(ir.IR_Code__c);
                    xmlW.writeEndElement(); 
                    xmlW.writeStartElement(null,'cell',null);
                    xmlw.writeCharacters(ir.IR_Title__c);
                    xmlW.writeEndElement();     
                    xmlW.writeStartElement(null,'cell',null);
                    if (eLinkMap.containsKey(ir.Id)){           
                        xmlw.writeCharacters('true');
                        } 
                    xmlW.writeEndElement();
                    xmlW.writeEndElement();                                     
                }
                xmlW.writeEndElement();
        }
        xmlW.writeEndElement(); //Tree    
        xmlW.writeEndDocument(); //Close XML document
         xmlStr = xmlW.getXmlString();
         System.debug(' DO IR XML String:::' +xmlStr);
}
                
Public pageReference insertSirs(){  
    
  List<CDCSLINK__c> newlinkList = new List<CDCSLINK__c>();
  List<CDCSLINK__c> dellinkList = new List<CDCSLINK__c>();
  List<String> selectedIrList = new List<String>(); 
  
  if (selectedIrs != null && selectedIrs != ''){
  selectedIrList = selectedIrs.split(',');
  
  for(String irStr: selectedIrList ){
    String dId = irStr.split(':')[0];
    String iId = irStr.split(':')[1];
    CDCSLINK__c cdcsLinkRec = new CDCSLINK__c();
    if (!eLinkMap.containsKey(iId)){
    IR__c  irRec = irMap.get(iId);
    cdcsLinkRec.CDCSGoal_Id__c = irRec.Goal_Id__c;
    cdcsLinkRec.DO_Id__c = dId;
    cdcsLinkRec.IR_Id__c = irRec.Id;
    cdcsLinkRec.SIR_Id__c = subIntRes.id;
    cdcsLinkRec.Link_Type__c = 'Secondary IR';
    cdcsLinkRec.ownerId = subIntRes.OwnerId;
    newlinkList.add(cdcsLinkRec);
  }
  }
  upsert newlinkList;
  
  Set<String> selectedIrsSet = new Set<String>();
  for(String irStr: selectedIrList ){
    selectedIrsSet.add(irStr.split(':')[1]);
  }
  //selectedIrsSet.addAll(selectedIrList);
  for(String irId: eLinkMap.keySet()){
    if(!selectedIrsSet.contains(irId)){
        dellinkList.add(eLinkMap.get(irId));
    }
  }
  delete dellinkList;
   
  } 
   
  PageReference pageRef = new PageReference('/' + sirId ); 
  pageRef.setRedirect(true);
  return pageRef ;
   }        
 
  Public pageReference Cancel(){ 
  
  PageReference pageRef = new PageReference('/' + sirId ); 
  pageRef.setRedirect(true);
  return pageRef ;
   }
  Public pageReference displayTree(){
      
  PageReference pageRef = new PageReference('/apex/vfCDCSTree?Lid='+sirId ); 
  pageRef.setRedirect(true);
  return pageRef ;
   }  
    }