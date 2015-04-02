trigger trGeoCountryBeforeUpsert On GeoCountry__c (before insert, before update) {
  
    for (GeoCountry__c   rec  :  trigger.new) {
         String code = rec.cntryCode__c;
         String title = rec.name;
         Integer spos, nlen;
  
         //Geo Country
         if (rec.name.contains(' | '))
         {
             spos = rec.name.indexOf(' | ')+3;
             nlen = rec.name.length();
             title = rec.name.substring(spos, nlen);
             rec.cntryName__c = title;
         }
  
         rec.cntryName__c= title;
         rec.name = code + ' | ' + title;
   }  
  
}