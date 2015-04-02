trigger trProjectTypeAfterInsertUpdate on Project__c (after insert, after update) {
  clsGlobalUtility GU = new clsGlobalUtility();
  
   for( Project__c proj : Trigger.New){
    
      String recTypeName=GU.getRecordType('Project__c', proj.RecordTypeid );
    
      if(recTypeName == 'LF Project'){     
         
        List<LF_Goal__c> lfGoalList = GU.lookup(proj.id,'Project_Id__c','LF_Goal__c');
            if(lfGoalList == null || lfGoalList.size() <=0){
                LF_Goal__c lf= new LF_Goal__c();
                lf.Project_Id__c = proj.id;
                lf.LF_Goal_Name__c = proj.Public_Name__c;
                Database.saveresult sr = database.insert(lf);
                    if(sr.isSuccess()){                     
                      LF_Purpose__c lfPurpose = new LF_Purpose__c();
                      lfPurpose.LF_Goal_Id__c = lf.id;
                      lfPurpose.LF_Purpose_Name__c=proj.Public_Name__c;
                      insert lfPurpose;
                    }           
             }  
      }
  }
}