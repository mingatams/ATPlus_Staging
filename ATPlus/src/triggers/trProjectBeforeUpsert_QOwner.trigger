trigger trProjectBeforeUpsert_QOwner on Project__c (Before Insert,Before Update) {

   //Trigger assigns Queue as a record owner based on the org Unit name in the Project Record
   
   Set<String> OrgUnits= new Set<String> () ;
   Set<String> QueueNames = new Set<String> () ;
   Map<String,String> GroupIds = New Map<String,String> () ;
   Map<String,String> MapQueueNames  = New Map<String,String> () ;
   Map<String,String> org_Qname  = New Map<String,String> () ;
   
    Map<String,String> org_Names  = New Map<String,String> () ;
    Map<String,String> Sec_Names  = New Map<String,String> () ;
    Set<String> secFullNames = new set<String>();
    Map<String,orgUnitSector__c> orgSectorsMap = new Map<String,orgUnitSector__c>();
    Map<String,orgUnitSector__c> orgSectorsMapN = new Map<String,orgUnitSector__c>();
    List<orgUnitSector__c> newOUSList = new List<orgUnitSector__c>();
    List<Sector__c> secList = new List<Sector__c>([Select Id, Name, secName__c from Sector__c]);
    Map<String,Sector__c> secMap = new Map<String,Sector__c>();
    for(Sector__c s: secList){
    	secMap.put(s.secName__c, s);
    }
     for(Project__c P : trigger.new){
        OrgUnits.add(p.ouId__c);
        org_Names.put(p.ouid__c,p.ouName__c);
       // Sec_Names.put(p.secid__c,p.secname__c);
        secFullNames.add(p.Sector_Name__c);
       // system.debug('OrgUnits==> '+OrgUnits);         
     }
   
    if (!secFullNames.isEmpty()){
    	List<orgUnitSector__c> orgSectors = new List<orgUnitSector__c>([select Id, ouId__c, secId__c, secName__c 
    									From orgUnitSector__c where ouId__c in :OrgUnits and secName__c in :secFullNames ]); 
    	
    	//System.Debug('Org Sectors::' +orgSectors);								
    	for(orgUnitSector__c os: orgSectors){
    		orgSectorsMap.put(os.ouId__c+os.secName__c,os);
    	}	
    } 
   
    for(Project__c P : trigger.new){
      if (p.Sector_Name__c != null)	{
    	if (!orgSectorsMap.containsKey(P.ouId__c+p.Sector_Name__c)){
    		Sector__c s = secMap.get((String)p.Sector_Name__c);
    		orgUnitSector__c ous = new orgUnitSector__c(ouId__c = P.ouId__c, secId__c = s.Id);
    		newOUSList.add(ous);
    	}
      }	
    }     
    
    if (!newOUSList.isEmpty()){
    	upsert newOUSList;
    }
   
    If(OrgUnits.size() > 0){
     
      OrgUnit__c[] OUnits=[SELECT id,ouCode__c,ouDisplayName__c,ouName__c,Queue_Name__c 
                     FROM  OrgUnit__c WHERE id IN: OrgUNits];
      orgUnitSector__c[] ouSectorList = [SELECT id,ouId__c,secName__c 
                     FROM  orgUnitSector__c WHERE ouId__c IN: OrgUNits];   
      
      for(orgUnitSector__c ous1: ouSectorList){
      	orgSectorsMapN.put(ous1.ouId__c+ous1.secName__c,ous1);
      }               
                                 
        for ( OrgUnit__c ou: OUnits  ) {
          QueueNames.add(ou.Queue_Name__c); 
          MapQueueNames.put(ou.ouName__c,ou.Queue_Name__c); 
          org_Qname.put(ou.Queue_Name__c,ou.Id);  
        }       
          system.debug('QueueNames ==> '+QueueNames);   
        
      Group[] lstGroup =  [SELECT Id,Name 
                            FROM Group 
                          WHERE type='Queue' and Name IN: org_Qname.keyset()] ;
              system.debug('lstGroup ==> '+lstGroup);    
           for ( Group g: lstGroup ) {
           system.debug('g.name'+g.name);
              GroupIds.put(org_Qname.get(g.Name),g.Id); 
           } 
       
              system.debug('GroupIds ==> '+GroupIds);     
        // Update the OWner Ids
          for(Project__c P : trigger.new){
            if( GroupIds.get(p.ouId__c) != null ) {
               p.OwnerId = GroupIds.get(p.ouId__c) ;
               
               If(p.Sector_Name__c!=null){
               	 orgUnitSector__c os1 = orgSectorsMapN.get(P.ouId__c+p.Sector_Name__c);
               	p.secId__c = os1.Id; 
              // p.Sector_Name__c=Sec_Names.get(p.secid__c);
               }
               
               If(p.missionName__c==null){
               p.missionName__c=org_names.get(p.ouid__c);
               }
               
               }
        }
                 
    }
   
}