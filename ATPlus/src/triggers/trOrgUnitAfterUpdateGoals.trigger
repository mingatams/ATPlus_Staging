trigger trOrgUnitAfterUpdateGoals on OrgUnit__c (after insert, after update) {
  if (!Applicationconstants.byPassOrgUnitAfterUpdateGoals){  
    List<CDCSGoal__c> goals = new list<CDCSGoal__c>();
    set<string> egoalsset = new set<string>();
    List<CDCSGoal__c> ggoals = [Select id, ouId__c from CDCSGoal__c];
    Map<String, CDCSGoal__c> eGoalsMap = new Map<String,CDCSGoal__c>();
    for(CDCSGoal__c d:ggoals){
        egoalsset.add(d.ouId__c);
        eGoalsMap.put(d.ouId__c, d);
    }
    
    for (OrgUnit__c ou : trigger.new)                                           
    { 
        if(!eGoalsMap.containsKey(ou.Id)){
            CDCSGoal__c go = new CDCSGoal__c();
            go.ouId__c = ou.Id;
            go.Name = ou.ouName__c + ' Results Framework';
            goals.add(go); 
        } else {
            goals.add(eGoalsMap.get(ou.Id));
        }
    } 
    if (!goals.isEmpty()){
        upsert goals;   
    }
 }    
}