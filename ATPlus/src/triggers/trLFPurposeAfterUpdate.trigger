trigger trLFPurposeAfterUpdate on LF_Purpose__c (after insert, after update) {
    Map<String,LF_Purpose__c> purposesMap = new Map<String,LF_Purpose__c>();
    List<LogFrame_Tree__c> cLinkList = new List<LogFrame_Tree__c>();
    Map<String,LogFrame_Tree__c> eLinkMap = new Map<String,LogFrame_Tree__c>();
    
    clsGlobalUtility GU = new clsGlobalUtility();
    if (Trigger.isInsert){
        for(LF_Purpose__c purp: Trigger.new){
            purposesMap.put(purp.Id,purp);  
        }   
    } else if(Trigger.isUpdate) {        
        for(LF_Purpose__c purp: Trigger.old){
            purposesMap.put(purp.Id,purp); 
        } 
    }
    
    List<LogFrame_Tree__c> eLinkList = new List<LogFrame_Tree__c>([Select id, LF_Purpose_Id__c From LogFrame_Tree__c where LF_Purpose_Id__c in :purposesMap.keySet() and Link_Type__c =: 'Primary Goal']);
    
    for(LogFrame_Tree__c el : eLinkList){
        eLinkMap.put((String)el.LF_Purpose_Id__c,el);
    }    
    
    if(Trigger.isInsert){
        for(LF_Purpose__c xPurpose: Trigger.new){
            LogFrame_Tree__c cLink = new LogFrame_Tree__c(LF_Goal_Id__c = xPurpose.LF_Goal_Id__c,LF_Purpose_Id__c = xPurpose.Id, Link_Type__c = 'Primary Goal'); 
            cLinkList.add(cLink);
        }
    } else if(Trigger.isUpdate) {
        System.debug('Record is in the update Mode2::');
        for(LF_Purpose__c xPurpose: Trigger.old){
            LogFrame_Tree__c cLink = new LogFrame_Tree__c();
            if (eLinkMap.containsKey((String)xPurpose.Id)){ 
                System.debug('Found eLink...::'+xPurpose.Id);            
                cLink = eLinkMap.get((String)xPurpose.Id);              
                
            }                 
            LF_Purpose__c xPurposeNew =new LF_Purpose__c();
            xPurposeNew = Trigger.newMap.get(xPurpose.id);
            cLink.LF_Goal_Id__c = xPurposeNew.LF_Goal_Id__c;            
            cLink.LF_Purpose_Id__c = xPurposeNew.Id;
            cLink.Link_Type__c = 'Primary Goal';
            //cLink.ownerId = xPurposeNew.ownerId;            
            cLinkList.add(cLink);
        }
        
    }       
    if (trigger.isInsert || trigger.isUpdate){
        upsert cLinkList;
    }
    
    Map<String,LogFrame_Tree__c> linksMap = GU.getLogFrameLinkForLFElement(purposesMap.keySet(),'LF_Purpose__c');
    for(String key: purposesMap.keySet()){
        clsReportingPeriod reptPeriod = new clsReportingPeriod();
        LF_Purpose__c purp = new LF_Purpose__c();
        //purp = purposesMap.get(key);
        purp = Trigger.newMap.get(key);
        LogFrame_Tree__c cl = linksMap.get(purp.Id);
        Project__c proj = (Project__c) GU.lookup(purp.Project_Id__c,'Project__c');
        if (proj.Start_Date__c != null && proj.End_Date__c != null){       
            reptPeriod.createRepPeriod((String)purp.Id,'LF_Purpose__c','LF_Purpose_Id__c','Annual',proj.Start_Date__c.year(),proj.End_Date__c.year(),null,cl);
        }     
    }  
}