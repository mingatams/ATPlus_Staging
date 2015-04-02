trigger trOrgUnitBeforeUpsert On OrgUnit__c (before insert, before update) {
  
    Integer spos, nlen;
    if(!ApplicationConstants.byPassOrgUnitBeforeUpsert) {            
    //OrgUnit
    for( OrgUnit__c   rec : trigger.new){
    String code = rec.ouCode__c;
    String title = rec.name;
    if (rec.name.contains(' | '))
    {
        spos = rec.name.indexOf(' | ')+3;
        nlen = rec.name.length();
        title = rec.name.substring(spos, nlen);
        rec.ouName__c = title;
    }
  
    rec.ouName__c= title;
    rec.name = code + ' | ' + title;
  
  
    }
    //Asigning Queue as a Owner Based on the Display name
    
    set<string> OrgIds = new set<string>();
    Set<string> MissionName = new set<string>();
    Set<string> QueueName= new set<string>();
    Map<String,String> MapOUQueueName = new Map<String,String>();
    Map<String,String> MapGrpQueueName = new Map<String,String>();
    Map<String,String> MapOrgIDQueueNames = new Map<String,String>();
    try{
    for(OrgUnit__c o : trigger.new ){
    QueueName.add(o.ouQueue__c);
    MapOuQueueName.put(o.ouQueue__c,o.ouDisplayName__c);
    MapOrgIDQueueNames.put(o.id,o.ouQueue__c);
    system.debug(' MapOuQueueName===>' +MapOuQueueName);
    system.debug(' MapOrgIDQueueNames===>' +MapOrgIDQueueNames);
    }
    Group[] lstgrp = [select id,name from Group where type='Queue' and name in:QueueName];
    system.debug('lstgrp ===>' +lstgrp);
    
    for(Group g : lstgrp ){
      
    MapGrpQueueName.put(g.name,g.id);
    system.debug('MapGrpQueueName===>' +MapGrpQueueName);
    }
    
    for(OrgUnit__c o : trigger.new ){
    try{
    if ( MapGrpQueueName.get(o.ouQueue__c)== null ){
            o.addError('Please Create a Queue for the OrgUnit '  );
           }else {
             o.ownerid=MapGrpQueueName.get(o.ouQueue__c);
           }
    
   // system.debug(' o.ownerid===>' + o.ownerid);
    }catch(exception e){
    }
    
    }
    }catch(exception e){
    }
    
   } 
    
}