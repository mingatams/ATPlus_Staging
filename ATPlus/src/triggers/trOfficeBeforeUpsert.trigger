trigger trOfficeBeforeUpsert On Office__c (before insert, before update) {  
    
    Integer spos, nlen; 
    
    for(Office__c   rec : trigger.new){
    //Office 
    String code = rec.offCode__c;   
    String title = rec.name;    
    if (rec.name.contains(' | '))   
    {   
        spos = rec.name.indexOf(' | ')+3;   
        nlen = rec.name.length();   
        title = rec.name.substring(spos, nlen); 
        rec.offName__c = title; 
    }   
    
    rec.offName__c= title;  
    rec.name = code + ' | ' + title;    
    }
    
}