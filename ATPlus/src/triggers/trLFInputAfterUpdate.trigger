trigger trLFInputAfterUpdate on LF_Input__c (after insert, after update) {
    Map<String,LF_Input__c> inputsMap = new Map<String,LF_Input__c>();
    List<LogFrame_Tree__c> cLinkList = new List<LogFrame_Tree__c>();
    Map<String,LogFrame_Tree__c> eLinkMap = new Map<String,LogFrame_Tree__c>();
    
    clsGlobalUtility GU = new clsGlobalUtility();
    if (Trigger.isInsert){
        for(LF_Input__c input: Trigger.new){
            inputsMap.put(input.Id,input);  
        }   
    } else if(Trigger.isUpdate) {        
        for(LF_Input__c input: Trigger.old){
            inputsMap.put(input.Id,input); 
        } 
    } 
    
    List<LogFrame_Tree__c> eLinkList = new List<LogFrame_Tree__c>([Select id, LF_Input_Id__c From LogFrame_Tree__c 
                                                    where LF_Input_Id__c in :inputsMap.keySet() and Link_Type__c =: 'Primary Output']);
    
    for(LogFrame_Tree__c el : eLinkList){
        eLinkMap.put((String)el.LF_Input_Id__c,el);
    }    
    
    if(Trigger.isInsert){
        for(LF_Input__c xinput: Trigger.new){
            LogFrame_Tree__c cLink = new LogFrame_Tree__c(LF_Goal_Id__c = xinput.LF_Goal_Id__c,
                                                            LF_Purpose_Id__c = xinput.LF_Purpose_Id__c,
                                                            LF_SubPurpose_Id__c = xinput.LF_SubPurpose_Id__c,
                                                            LF_Output_Id__c = xinput.LF_Output_Id__c, 
                                                            LF_Input_Id__c = xinput.Id, 
                                                            Link_Type__c = 'Primary Output'); 
            cLinkList.add(cLink);
        }
    } else if(Trigger.isUpdate) {
        System.debug('Record is in the update Mode2::');
        for(LF_Input__c xinput: Trigger.old){
            LogFrame_Tree__c cLink = new LogFrame_Tree__c();
            if (eLinkMap.containsKey((String)xinput.Id)){ 
                System.debug('Found eLink...::'+xinput.Id);            
                cLink = eLinkMap.get((String)xinput.Id);              
                 
            }                 
            LF_Input__c xinputNew =new LF_Input__c();
            xinputNew = Trigger.newMap.get(xinput.id);
            cLink.LF_Goal_Id__c = xinputNew.LF_Goal_Id__c;            
            cLink.LF_Purpose_Id__c = xinputNew.LF_Purpose_Id__c;
            cLink.LF_SubPurpose_Id__c = xinputNew.LF_SubPurpose_Id__c;
            cLink.LF_Output_Id__c = xinputNew.LF_Output_Id__c;
            cLink.LF_Input_Id__c = xinputNew.Id;
            cLink.Link_Type__c = 'Primary Output';
           // cLink.ownerId = xinputNew.ownerId;            
            cLinkList.add(cLink);
        }
        
    }       
    if (trigger.isInsert || trigger.isUpdate){
        upsert cLinkList;
    }
    
    Map<String,LogFrame_Tree__c> linksMap = GU.getLogFrameLinkForLFElement(inputsMap.keySet(),'LF_Input__c');
    
    for(String key: inputsMap.keySet()){
        clsReportingPeriod reptPeriod = new clsReportingPeriod();
        LF_Input__c input = new LF_Input__c();
        //input = inputsMap.get(key);
        input = Trigger.newMap.get(key);
        LogFrame_Tree__c cl = linksMap.get(input.Id);
        Project__c proj = (Project__c) GU.lookup(input.Project_Id__c,'Project__c');   
        if (proj.Start_Date__c != null && proj.End_Date__c != null){    
            reptPeriod.createRepPeriod((String)input.Id,'LF_Input__c','LF_Input_Id__c','Annual',proj.Start_Date__c.year(),proj.End_Date__c.year(),null,cl);
        }     
    } 

}