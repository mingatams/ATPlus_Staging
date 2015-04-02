trigger trGeoRegionBeforeUpsert On GeoRegion__c (before insert, before update) {
  
    for (GeoRegion__c   rec  :  trigger.new) {
         String code = rec.regCode__c;
         String title = rec.name;
         Integer spos, nlen;
  
         //Geo Region
         if (rec.name.contains(' | '))
         {
             spos = rec.name.indexOf(' | ')+3;
             nlen = rec.name.length();
             title = rec.name.substring(spos, nlen);
             rec.regName__c = title;
         }
  
         rec.regName__c= title;
         rec.name = code + ' | ' + title;
   }  
  
}