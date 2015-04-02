public with sharing class ClsProjectIRLink {

    public string prId;
    public string pr;
    public string xmlStr{get;set;}
    public Project__c prj{get;set;}
    CDCSGoal__c goal = new CDCSGoal__c();
    public DO__c devObj{get;set;}
    public IR__c intRes{get;set;}
    public String selectedIrs{get;set;}
    Public String ShowErrors{get;set;}
    Public String Message{get;set;} 
     
    List<String> sortedDoListKeys = new List<String>();
    List<String> sortedIrListKeys = new List<String>(); 
    List<Portfolio_RF_Linkage__c> eLinks = new List<Portfolio_RF_Linkage__c>();
      
    set<string> goalSet = new set<string>();
    set<string> doSet = new set<string>();
    set<string> irset = new set<string>();
    
    Map<string,DO__c> doMap = new Map<string,DO__c>();
    Map<string,IR__c> irMap = new Map<string,IR__c>();
    Map<String,list<string>> goalDoMap = new Map<String,list<string>>();
    Map<String,list<IR__c>> doIrMap = new Map<String,list<IR__c>>();
    Map<String,Portfolio_RF_Linkage__c> eLinkMap = new Map<String,Portfolio_RF_Linkage__c>();
    
    Public ClsProjectIRLink (apexpages.standardcontroller controller){
        try{        
        
        
            prId= ApexPages.currentpage().getParameters().get('Lid');
            
            prj=[select ID, Name, ouId__c, ouCode__c, Public_Name__c from Project__c where id = :prId];
            
            System.debug(' Project Id:::' +prId);
            System.debug(' Org Unit Id:::' +prj.ouId__c);
            System.debug(' Project Name:::' +prj.Public_Name__c);
            
            ShowErrors = 'false';
            goal = [select ID, Name, Goal_Statement__c from CDCSGoal__c where ouId__c =: prj.ouId__c limit 1];
            
            if (goal != null){
                        
                System.debug(' Goal:::' +goal);
        
                pr = prj.ouId__c;
                
                pr = pr.substring(0, 15);
                
                System.debug(' OU ID pr:::' +pr);
                
                list<DO__c> doList = new list<DO__c>([select ID, Name, DO_Code__c,Do_Name__c, DO_Title__c from DO__c where ouId__c =: pr and ouCode__c =: prj.ouCode__c order by DO_Code__c ASC]);
                
                list<IR__c> irList = new list<IR__c>([Select i.ouName__c, i.ouId__c, i.ouCode__c, i.Unique_Name__c,  
                                                      i.Name, i.Id, i.IR_Title__c,i.IR_Code__c,  i.DO_Title__c,i.IR_Name__c, 
                                                      i.DO_Id__c, i.DO_Code__c,  
                                                      i.Goal_Id__c From IR__c i where ouId__c =: pr and ouCode__c =: prj.ouCode__c  
                                                      order by DO_Code__c,IR_Code__c]);
                
            //  list<CDCSLINK__c> cdcsList = new list<CDCSLINK__c>([select DO_Id__c, IR_Name__c, Results_Framework_Id__c from CDCSLINK__c where ouId__c =: pr]);
                
                
                for(DO__c d : doList){
                    sortedDoListKeys.add(d.Id);
                    doMap.put(d.Id, d); 
                }
                
                for(IR__c ir: irList)
                 {
                  sortedIrListKeys.add(ir.Id);
                  irMap.put(ir.Id, ir);
                 }
                
              if (!irList.isEmpty()){  
                for(String dStr: sortedDoListKeys){
                    List<IR__c> tempIRList = new List<IR__c>();
                    for(String iStr: sortedIrListKeys){
                        IR__c ir1 = new IR__c();
                        ir1 = irMap.get(iStr);  
                        if(dStr == ir1.DO_Id__c){
                            tempIRList.add(ir1);
                        }
                    }
                    doIrMap.put(dStr, tempIRList);
                    System.debug(' doIrMap:::' +doIrMap);           
                }   
                eLinks = ([Select  p.goal_Id__c, p.SIR_Name__c, p.SIR_Id__c, p.SIR_Code__c, 
                          p.Project_Name__c, p.Project_Id__c, p.Project_Code__c, p.Name, p.Id, p.IR_Name__c, p.IR_Id__c, 
                          p.IR_Code__c, p.Do_Name__c, p.DO_Id__c, p.DO_Code__c, p.Activity_Name__c, p.Activity_Id__c, 
                          p.Activity_Code__c From Portfolio_RF_Linkage__c p where Project_Id__c =:prj.id]);
            
                    for(Portfolio_RF_Linkage__c c : eLinks){
                        
                        eLinkMap.put(c.IR_Id__c, c);
                        
                    }
                 System.debug('Existing Links:::::::::::'+eLinkMap);
                 prepareIrsXML();   
              } else {
                ShowErrors='true';
              }  
            }  else {
                ShowErrors='true';
            } 
        } catch(Exception e){
            ShowErrors='true';
            //ApexPages.Message myMsg =new ApexPages.Message(ApexPages.Severity.ERROR, 'my error msg');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Loading the Results Framework Table. Please contact your System Admin.'));
        }
    }
    
    public void prepareIrsXML()
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
            xmlw.writeCharacters((string)goal.Goal_Statement__c);
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
                xmlw.writeCharacters(d1.Do_Title__c);
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
                    xmlW.writeStartElement(null,'cell',null);
                    //System.debug(' IR ID:::' +i.Id);  
                    if (eLinkMap.containsKey(i.Id)){ 
                                
                        xmlw.writeCharacters('true');
                        } 
                    xmlW.writeEndElement();   
                    xmlW.writeEndElement();
                }
                xmlW.writeEndElement();
            }
            xmlW.writeEndElement();
    //    }
         xmlW.writeEndElement(); //Tree    
         xmlW.writeEndDocument(); //Close XML document
         xmlStr = xmlW.getXmlString();
         System.debug(' Project IR XML String:::' +xmlStr);
    }    
    
    Public pageReference insertIrs(){  
    
      List<Portfolio_RF_Linkage__c> newlinkList = new List<Portfolio_RF_Linkage__c>();
      List<Portfolio_RF_Linkage__c> dellinkList = new List<Portfolio_RF_Linkage__c>();
      List<String> selectedIrList = new List<String>(); 
      
      if (selectedIrs != null && selectedIrs != ''){
          selectedIrList = selectedIrs.split(',');
      
          for(String irStr: selectedIrList ){
            String gId = irStr.split(':')[0];
            String dId = irStr.split(':')[1];
            String iId = irStr.split(':')[2];
            if (!eLinkMap.containsKey(iId)){
                Portfolio_RF_Linkage__c linkRec = new Portfolio_RF_Linkage__c();
                IR__c  irRec = irMap.get(iId);
                linkRec.goal_Id__c = gId;
                linkRec.DO_Id__c = dId;
                linkRec.IR_Id__c = iId;
                linkRec.Project_Id__c = prj.id;
                //cdcsLinkRec.SIR_Name__c = subIntRes.id;
                //cdcsLinkRec.Link_Type__c = 'Secondary IR';
                
                newlinkList.add(linkRec);   
            }       
          }
          upsert newlinkList;
      }
      Set<String> selectedIrsSet = new Set<String>();
      for(String irStr : selectedIrList){       
        selectedIrsSet.add(irStr.split(':')[2]);    
      }
      
      for(String irId: eLinkMap.keySet()){
        //System.debug('Inside the preparation of Delete List:'+selectedIrsSet);
        if(selectedIrsSet.isEmpty() || !selectedIrsSet.contains(irId)){         
            dellinkList.add(eLinkMap.get(irId));
        }
      }
     delete dellinkList;
     
     PageReference pageRef = new PageReference('/' + prId ); 
     pageRef.setRedirect(true);
     return pageRef ;         
   }        
 
  Public pageReference Cancel(){ 
  
    PageReference pageRef = new PageReference('/' + prId );   
    pageRef.setRedirect(true);
    return pageRef ;
   } 
}