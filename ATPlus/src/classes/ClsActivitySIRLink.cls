public with sharing class ClsActivitySIRLink {
    public string actId;
    public string actStr;
    public string xmlStr{get;set;}
    public Activity__c act{get;set;}
    public CDCSGoal__c goal{get;set;}
    public DO__c devObj{get;set;}
    public IR__c intRes{get;set;}
    public String selectedSIrs{get;set;}
    Public String ShowErrors{get;set;} 
     
    List<String> sortedDoListKeys = new List<String>();
    List<String> sortedIrListKeys = new List<String>();
    List<String> sortedSIrListKeys = new List<String>();
     
    List<Portfolio_RF_Linkage__c> eLinks = new List<Portfolio_RF_Linkage__c>();
      
    set<string> goalSet = new set<string>();
    set<string> doSet = new set<string>();
    set<string> irset = new set<string>();
    set<String> sirSet = new set<string>();
    
    Map<string,DO__c> doMap = new Map<string,DO__c>();
    Map<string,IR__c> irMap = new Map<string,IR__c>();
    Map<string,Sub_IR__c> sirMap = new Map<string,Sub_IR__c>();
    
    Map<String,list<string>> goalDoMap = new Map<String,list<string>>();
    Map<String,list<IR__c>> doIrMap = new Map<String,list<IR__c>>();
    Map<String,list<Sub_IR__c>> irSirMap = new Map<String,list<Sub_IR__c>>();
    
    Map<String,Portfolio_RF_Linkage__c> eLinkMap = new Map<String,Portfolio_RF_Linkage__c>();
    
    Public ClsActivitySIRLink (apexpages.standardcontroller controller){
        try {
        actId= ApexPages.currentpage().getParameters().get('Lid');
        
        act=[select ID, Name, ouId__c, ouCode__c, Activity_Name__c, Project_Code__c from Activity__c where id = :actId];
        
        System.debug(' Activity Id:::' +actId);
        System.debug(' Org Unit Id:::' +act.ouId__c);
        System.debug(' Activity Name:::' +act.Activity_Name__c);
        ShowErrors = 'false';
        goal = [select ID, Name, Goal_Statement__c from CDCSGoal__c where ouId__c =: act.ouId__c limit 1];
        
        if (goal != null){
            System.debug(' Goal:::' +goal);
    
            actStr = ((String)act.ouId__c).left(15);        
            
            System.debug(' 15 Byte OU ID:::' +actStr);
            
            list<DO__c> doList = new list<DO__c>([select ID, Name, DO_Code__c, DO_Title__c from DO__c where ouId__c =: actStr and ouCode__c =: act.ouCode__c order by DO_Code__c ASC]);
            
            list<IR__c> irList = new list<IR__c>([Select i.ouName__c, i.ouId__c, i.ouCode__c, i.Unique_Name__c,  
                                                  i.OwnerId, i.Name, i.LastModifiedDate, i.LastModifiedById, i.IsDeleted, 
                                                   i.Id, i.IR_Title__c, 
                                                   i.IR_Code__c,  i.DO_Title__c, 
                                                  i.DO_Id__c, i.DO_Code__c,  
                                                  i.Goal_Id__c From IR__c i where ouId__c =: actStr and ouCode__c =: act.ouCode__c
                                                  order by DO_Code__c,IR_Code__c]);
            
            list<Sub_IR__c> sirList = new list<Sub_IR__c>([Select id, Name, Do_Name__c, DO_Code__c,
                                                                Do_Title__c, IR_Code__c, IR_Id__c, IR_Title__c,
                                                                Goal_Id__c, SIR_Code__c, SIR_Title__c  
                                                         From Sub_IR__c where ouId__c = :actStr and ouCode__c =: act.ouCode__c
                                                         Order By Do_Code__c, IR_Code__c, SIR_Code__c ]);
            
        //  list<CDCSLINK__c> cdcsList = new list<CDCSLINK__c>([select DO_Id__c, IR_Name__c, Goal_Id__c from CDCSLINK__c where ouId__c =: pr]);
            
            
            for(DO__c d : doList){
                sortedDoListKeys.add(d.Id);
                doMap.put(d.Id, d); 
            }
            
            for(IR__c ir: irList)
             {
              sortedIrListKeys.add(ir.Id);
              irMap.put(ir.Id, ir);
             }
            
            for(Sub_IR__c sir: sirList)
             {
              sortedSIrListKeys.add(sir.Id);
              sirMap.put(sir.Id, sir);
             }
            if (!sirList.isEmpty()){ 
                System.debug('SIR Map:::'+sirMap);
                for(String dStr: sortedDoListKeys){
                    List<IR__c> tempIRList = new List<IR__c>();
                    for(String iStr: sortedIrListKeys){
                        IR__c ir1 = new IR__c();
                        ir1 = irMap.get(iStr);  
                        if(dStr == ir1.DO_Id__c){
                            tempIRList.add(ir1);
                        }
                        List<Sub_IR__c> tempSIRList = new List<Sub_IR__c>();
                        for(String sirStr: sortedSIrListKeys){
                            Sub_IR__c sir1 = new Sub_IR__c();
                            sir1 = sirMap.get(sirStr);  
                            if(iStr == sir1.IR_Id__c){
                                tempSIRList.add(sir1);
                            }
                        }
                        irSirMap.put(iStr,tempSIRList);
                        System.debug(' IrSIRMap:::' +irSirMap);
                    }
                    doIrMap.put(dStr, tempIRList);
                    //System.debug(' doIrMap:::' +doIrMap);         
                }
                
                
                eLinks = ([Select p.goal_Id__c, p.SIR_Name__c, p.SIR_Id__c, p.SIR_Code__c, 
                          p.Project_Name__c, p.Project_Id__c, p.Project_Code__c, p.Name, p.Id, p.IR_Name__c, p.IR_Id__c, 
                          p.IR_Code__c, p.Do_Name__c, p.DO_Id__c, p.DO_Code__c, p.Activity_Name__c, p.Activity_Id__c, 
                          p.Activity_Code__c From Portfolio_RF_Linkage__c p where Activity_Id__c =:act.id]);
            
                    for(Portfolio_RF_Linkage__c c : eLinks){
                        
                        eLinkMap.put(c.SIR_Id__c, c);
                        
                    }
                 System.debug('Existing Links:::::::::::'+eLinkMap);   
                prepareSIrsXML();
            } else {
                ShowErrors = 'True';
            }        
        } else {
            ShowErrors = 'True';
        }
    } catch(Exception e){
            ShowErrors='true';
            //ApexPages.Message myMsg =new ApexPages.Message(ApexPages.Severity.ERROR, 'my error msg');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Loading the Results Framework Table. Please contact your System Admin.'));
        }
     }
    public void prepareSIrsXML()
    {
        Xmlstreamwriter xmlW = new Xmlstreamwriter();
        xmlW.writeStartDocument('UTF-8','1.0');
        xmlW.writeStartElement(null,'rows', null);
        xmlW.writeAttribute(null,null,'id','0');
        
       // for(String s: goalSet)
       // {
            xmlW.writeStartElement(null,'row',null); 
            xmlW.writeAttribute(null,null,'id',goal.Id);
            xmlW.writeAttribute(null,null,'open','1'); 
            xmlW.writeStartElement(null,'cell',null);
            xmlw.writeCharacters(goal.Name);
            xmlW.writeEndElement();     
            xmlW.writeStartElement(null,'cell',null);
            xmlw.writeCharacters(goal.Goal_Statement__c);
            xmlW.writeEndElement();
            //xmlW.writeStartElement(null,'cell',null);
            //xmlW.writeEndElement();
            for(string dStr: sortedDoListKeys){
                DO__c d1 = new DO__c();
                d1 = doMap.get(dStr);
                xmlW.writeStartElement(null,'row',null); 
                xmlW.writeAttribute(null,null,'id',d1.Id);
                xmlW.writeAttribute(null,null,'open','1'); 
                xmlW.writeStartElement(null,'cell',null);
                xmlw.writeCharacters(d1.DO_Code__c);
                xmlW.writeEndElement();     
                xmlW.writeStartElement(null,'cell',null);
                xmlw.writeCharacters(d1.DO_Title__c);
                xmlW.writeEndElement();
                //xmlW.writeStartElement(null,'cell',null);
                //xmlW.writeEndElement();  
                                
                for(IR__c i: doIrMap.get(dStr)){
                    
                    //IR__c i1 = new IR__c();
                    //i1 = irMap.get(i);
                    xmlW.writeStartElement(null,'row',null); 
                    xmlW.writeAttribute(null,null,'id',goal.Id+':'+d1.Id+':'+i.Id);
                    xmlW.writeAttribute(null,null,'open','1'); 
                    xmlW.writeStartElement(null,'cell',null);
                    xmlw.writeCharacters(i.IR_Code__c);
                    xmlW.writeEndElement();     
                    xmlW.writeStartElement(null,'cell',null);
                    xmlw.writeCharacters(i.IR_Title__c);
                    xmlW.writeEndElement();
                    //xmlW.writeStartElement(null,'cell',null);
                    //xmlW.writeEndElement();
                    
                    for(Sub_IR__c sir: irSirMap.get(i.Id)){
                        xmlW.writeStartElement(null,'row',null); 
                        xmlW.writeAttribute(null,null,'id',goal.Id+':'+d1.Id+':'+i.Id+':'+sir.Id);
                        xmlW.writeAttribute(null,null,'open','1'); 
                        xmlW.writeStartElement(null,'cell',null);
                        xmlw.writeCharacters(sir.SIR_Code__c);
                        xmlW.writeEndElement();     
                        xmlW.writeStartElement(null,'cell',null);
                        xmlw.writeCharacters(sir.SIR_Title__c);
                        xmlW.writeEndElement();
                        //xmlW.writeStartElement(null,'cell',null);
                        //xmlW.writeEndElement();
                        xmlW.writeStartElement(null,'cell',null);
                        System.debug(' IR ID:::' +i.Id);  
                        if (eLinkMap.containsKey(sir.Id)){ 
                                    
                            xmlw.writeCharacters('true');
                            } 
                        xmlW.writeEndElement();
                        xmlW.writeEndElement();
                    }               
                      
                    xmlW.writeEndElement();
                }
                xmlW.writeEndElement();
            }
            xmlW.writeEndElement();
    //    }
         xmlW.writeEndElement(); //Tree    
         xmlW.writeEndDocument(); //Close XML document
         xmlStr = xmlW.getXmlString();
         System.debug(' Activity SIR XML String:::' +xmlStr);
    }    
    
    Public pageReference insertSIrs(){  
    
      List<Portfolio_RF_Linkage__c> newlinkList = new List<Portfolio_RF_Linkage__c>();
      List<Portfolio_RF_Linkage__c> dellinkList = new List<Portfolio_RF_Linkage__c>();
      List<String> selectedSIrList = new List<String>(); 
      
      if (selectedSIrs != null && selectedSIrs != ''){
            selectedSIrList = selectedSIrs.split(',');
      
          for(String irStr: selectedSIrList ){
            String gId = irStr.split(':')[0];
            String dId = irStr.split(':')[1];
            String iId = irStr.split(':')[2];
            String sId = irStr.split(':')[3];
            if (!eLinkMap.containsKey(sId)){
                Portfolio_RF_Linkage__c linkRec = new Portfolio_RF_Linkage__c();
                IR__c  irRec = irMap.get(iId);
                linkRec.goal_Id__c = gId;
                linkRec.DO_Id__c = dId;
                linkRec.IR_Id__c = iId;
                linkRec.Activity_Id__c = act.Id;
                linkRec.Project_Id__c = act.Project_Code__c;
                linkRec.SIR_Id__c = sId;
                //cdcsLinkRec.SIR_Name__c = subIntRes.id;
                //cdcsLinkRec.Link_Type__c = 'Secondary IR';
                
                newlinkList.add(linkRec);   
            }
          }
        upsert newlinkList; 
      }
      
      Set<String> selectedSirsSet = new Set<String>();
      for(String sirStr : selectedSirList){     
        selectedSirsSet.add(sirStr.split(':')[3]);  
      }
      
      for(String sirId: eLinkMap.keySet()){
        if(selectedSirsSet.isEmpty() || !selectedSirsSet.contains(sirId)){
            dellinkList.add(eLinkMap.get(sirId));
        }
      }
     delete dellinkList;
     
     PageReference pageRef = new PageReference('/' + actId ); 
     pageRef.setRedirect(true);
     return pageRef ; 
 }        
 
  Public pageReference Cancel(){ 
  
    PageReference pageRef = new PageReference('/' + actId );  
    pageRef.setRedirect(true);
    return pageRef ;
   } 
}