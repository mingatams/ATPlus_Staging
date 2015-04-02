trigger trGeoBoundaryBeforeUpsert On GeoBoundary__c (before insert, before update) {                                                

    for (GeoBoundary__c   rec:  trigger.new)
    {
        String ccode = rec.cntryCode__c;                                             
        String cname = rec.cntryName__c;
        string code = ccode + ' | '+ cname;
        String title = rec.name;                                                
        Integer spos, nlen;                                             
                                                    
        //GeoBoundary                                               
        if (rec.name.contains(' | '))                                               
        {                                               
           
            
            spos = rec.name.lastindexOf(' | ') +3;
            nlen = rec.name.length();
            title = rec.name.substring(spos, nlen);
                                                    
            rec.adminBndryName__c = title;                                              
        }                                               

                                    
        rec.adminBndryName__c= title;                                               
        rec.name = code + ' | ' + title;                                                
        rec.adminUniqueName__c = rec.name;
    }
                                                
}