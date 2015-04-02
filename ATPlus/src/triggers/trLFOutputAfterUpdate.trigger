trigger trLFOutputAfterUpdate on LF_Output__c (after insert, after update) {
    Map<String,LF_Output__c> outputsMap = new Map<String,LF_Output__c>();
    List<LogFrame_Tree__c> cLinkList = new List<LogFrame_Tree__c>();
    Map<String,LogFrame_Tree__c> eLinkMap = new Map<String,LogFrame_Tree__c>();
    Map<Id,LF_SubPurpose__c> sPurposeMap= new Map<Id,LF_SubPurpose__c>();
    Set<Id> subpurposeIds = new Set<Id>();
    String purposeId;
    
    clsGlobalUtility GU = new clsGlobalUtility();
    if (Trigger.isInsert){
        for(LF_Output__c output: Trigger.new){
            outputsMap.put(output.Id,output); 
            if (output.LF_SubPurpose_Id__c != null){
                subpurposeIds.add(output.LF_SubPurpose_Id__c);
            } 
        }   
    } else if(Trigger.isUpdate) {        
        for(LF_Output__c output: Trigger.old){
            outputsMap.put(output.Id,output); 
        } 
    } 
    
    sPurposeMap = new Map<Id,LF_SubPurpose__c>([Select id, LF_Purpose_Id__c From LF_SubPurpose__c where Id in :subpurposeIds]);
    List<LogFrame_Tree__c> eLinkList = new List<LogFrame_Tree__c>([Select id, LF_Output_Id__c From LogFrame_Tree__c where LF_Output_Id__c in :outputsMap.keySet() and Link_Type__c IN ('Primary Sub-Purpose', 'Primary Purpose Output')]);
    
    for(LogFrame_Tree__c el : eLinkList){
        eLinkMap.put((String)el.LF_Output_Id__c,el);
    }    
    
    if(Trigger.isInsert){
        for(LF_Output__c xOutput: Trigger.new){
            String lType = 'Primary Sub-Purpose';
            if (xOutput.LF_SubPurpose_Id__c == null){
                lType = 'Primary Purpose Output';
                purposeId = null; 
            } else {
                LF_SubPurpose__c sPur = sPurposeMap.get(xOutput.LF_SubPurpose_Id__c);
                purposeId = sPur.LF_Purpose_Id__c;
            }
            LogFrame_Tree__c cLink = new LogFrame_Tree__c(LF_Goal_Id__c = xOutput.LF_Goal_Id__c,
                                                            LF_Purpose_Id__c = purposeId ,
                                                            LF_SubPurpose_Id__c = xOutput.LF_SubPurpose_Id__c,
                                                            LF_Output_Id__c = xOutput.Id, 
                                                            Link_Type__c = lType); 
            cLinkList.add(cLink);
        }
    } else if(Trigger.isUpdate) {
        System.debug('Record is in the update Mode2::');
        for(LF_Output__c xOutput: Trigger.old){
            LogFrame_Tree__c cLink = new LogFrame_Tree__c();
            if (eLinkMap.containsKey((String)xOutput.Id)){ 
                System.debug('Found eLink...::'+xOutput.Id);            
                cLink = eLinkMap.get((String)xOutput.Id);              
                 
            }                 
            LF_Output__c xOutputNew =new LF_Output__c();
            xOutputNew = Trigger.newMap.get(xOutput.id);
            cLink.LF_Goal_Id__c = xOutputNew.LF_Goal_Id__c;            
            cLink.LF_Purpose_Id__c = xOutputNew.LF_Purpose_Id__c;
            cLink.LF_SubPurpose_Id__c = xOutputNew.LF_SubPurpose_Id__c;
            cLink.LF_Output_Id__c = xOutputNew.Id;
            if (xOutputNew.LF_SubPurpose_Id__c == null){
                cLink.Link_Type__c = 'Primary Purpose Output';
            } else {
                cLink.Link_Type__c = 'Primary Sub-Purpose';
            }
            
          //  cLink.ownerId = xOutputNew.ownerId;            
            cLinkList.add(cLink);
        }
        
    }       
    if (trigger.isInsert || trigger.isUpdate){
        upsert cLinkList;  
    }
    
        Map<String,LogFrame_Tree__c> linksMap = GU.getLogFrameLinkForLFElement(outputsMap.keySet(),'LF_Output__c');
        for(String key: outputsMap.keySet()){
            clsReportingPeriod reptPeriod = new clsReportingPeriod();
            LF_Output__c output = new LF_Output__c();
            //output = outputsMap.get(key);
            output = Trigger.newMap.get(key);
            LogFrame_Tree__c cl = linksMap.get(output.Id);
            Project__c proj = (Project__c) GU.lookup(output.Project_Id__c,'Project__c');  
            if (proj.Start_Date__c != null && proj.End_Date__c != null){     
                reptPeriod.createRepPeriod((String)output.Id,'LF_Output__c','LF_Output_Id__c','Annual',proj.Start_Date__c.year(),proj.End_Date__c.year(),null,cl);
            }     
        } 
    }