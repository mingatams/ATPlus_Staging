trigger trBureauBeforeUpsert On Bureau__c (before insert, before update) {
  
   Integer spos, nlen;
   
      for(Bureau__c   rec : Trigger.new){
        String code = rec.burCode__c;
        String title = rec.name;
          if (rec.name.contains(' | ')){

            spos = rec.name.indexOf(' | ')+3;
            nlen = rec.name.length();
            title = rec.name.substring(spos, nlen);
            rec.burName__c = title;
          }
  
            rec.burName__c= title;
            rec.name = code + ' | ' + title;
      }
      
  
}