trigger trLFSubPurposeAfterUpdate on LF_SubPurpose__c (after insert, after update) {
    Map<String,LF_SubPurpose__c> spurposesMap = new Map<String,LF_SubPurpose__c>();
    List<LogFrame_Tree__c> cLinkList = new List<LogFrame_Tree__c>();
    Map<String,LogFrame_Tree__c> eLinkMap = new Map<String,LogFrame_Tree__c>();
    
    clsGlobalUtility GU = new clsGlobalUtility();
    if (Trigger.isInsert){
        for(LF_SubPurpose__c spurp: Trigger.new){
            spurposesMap.put(spurp.Id,spurp);  
        }   
    } else if(Trigger.isUpdate) {        
        for(LF_SubPurpose__c spurp: Trigger.old){
            spurposesMap.put(spurp.Id,spurp); 
        } 
    } 
    
    
    List<LogFrame_Tree__c> eLinkList = new List<LogFrame_Tree__c>([Select id, LF_SubPurpose_Id__c From LogFrame_Tree__c where LF_SubPurpose_Id__c in :spurposesMap.keySet() and Link_Type__c =: 'Primary Purpose']);
    
    for(LogFrame_Tree__c el : eLinkList){
        eLinkMap.put((String)el.LF_SubPurpose_Id__c,el);
    }    
    
    if(Trigger.isInsert){
        for(LF_SubPurpose__c xPurpose: Trigger.new){
            LogFrame_Tree__c cLink = new LogFrame_Tree__c(LF_Goal_Id__c = xPurpose.LF_Goal_Id__c, 
                                                          LF_Purpose_Id__c = xPurpose.LF_Purpose_Id__c, 
                                                          LF_SubPurpose_Id__c = xPurpose.Id, 
                                                          Link_Type__c = 'Primary Purpose'); 
            cLinkList.add(cLink);
        }
    } else if(Trigger.isUpdate) {
        System.debug('Record is in the update Mode2::');
        for(LF_SubPurpose__c xPurpose: Trigger.old){
            LogFrame_Tree__c cLink = new LogFrame_Tree__c();
            if (eLinkMap.containsKey((String)xPurpose.Id)){ 
                System.debug('Found eLink...::'+xPurpose.Id);            
                cLink = eLinkMap.get((String)xPurpose.Id);              
                
            }                 
            LF_SubPurpose__c xPurposeNew =new LF_SubPurpose__c();
            xPurposeNew = Trigger.newMap.get(xPurpose.id);
            cLink.LF_Goal_Id__c = xPurposeNew.LF_Goal_Id__c;            
            cLink.LF_Purpose_Id__c = xPurposeNew.LF_Purpose_Id__c;
            cLink.LF_SubPurpose_Id__c = xPurposeNew.Id;
            cLink.Link_Type__c = 'Primary Purpose';
           // cLink.ownerId = xPurposeNew.ownerId;            
            cLinkList.add(cLink);
        }
        
    }       
    if (trigger.isInsert || trigger.isUpdate){
        upsert cLinkList;
    }
    Map<String,LogFrame_Tree__c> linksMap = GU.getLogFrameLinkForLFElement(spurposesMap.keySet(),'LF_SubPurpose__c');
    for(String key: spurposesMap.keySet()){
        clsReportingPeriod reptPeriod = new clsReportingPeriod();
        LF_SubPurpose__c spurp = new LF_SubPurpose__c();
       // spurp = spurposesMap.get(key);
        spurp = Trigger.newMap.get(key);
        LogFrame_Tree__c cl = linksMap.get(spurp.Id);
        Project__c proj = (Project__c) GU.lookup(spurp.Project_Id__c,'Project__c');  
        system.debug('Project Info::' +proj);
        system.debug('Link Info::' +cl);
        if (proj.Start_Date__c != null && proj.End_Date__c != null){     
            reptPeriod.createRepPeriod((String)spurp.Id,'LF_SubPurpose__c','LF_SubPurpose_Id__c','Annual',proj.Start_Date__c.year(),proj.End_Date__c.year(),null,cl);
        }    
    } 
}