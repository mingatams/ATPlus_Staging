trigger trSectorBeforeUpsert On Sector__c (before insert, before update) {
  
    
    Integer spos, nlen;
  
    //Sector
    
    for(Sector__c   rec : trigger.new){
    String code = rec.secCode__c;
    String title = rec.name;
    if (rec.name.contains(' | '))
    {
        spos = rec.name.indexOf(' | ')+3;
        nlen = rec.name.length();
        title = rec.name.substring(spos, nlen);
        rec.secName__c = title;
    }
  
    rec.secName__c= title;
    rec.name = code + ' | ' + title;
    }
  
}