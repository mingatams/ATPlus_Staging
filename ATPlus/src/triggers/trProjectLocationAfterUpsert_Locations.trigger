trigger trProjectLocationAfterUpsert_Locations on Project_Location__c (after delete, after insert, after update) {
	//List<Location1__c> locsToUpsert = new List<Location1__c>();
	Integer locCount;
	// Location1__c locanDelete = new Location1__c();
//	List<Location1__c> locDeleteList = new List<Location1__c>();
	List<Project_Geography__c> pgList = new List<Project_Geography__c>([Select Id, Name, Project_Id__c, cntryId__c From Project_Geography__c]);
	Map<String,Project_Geography__c> pgDeleteMap = new Map<String,Project_Geography__c>(); 
	List<Project_Geography__c> newPgs = new List<Project_Geography__c>();
	List<Project_Geography__c> pgDelete = new List<Project_Geography__c>();
	Map<String,Project_Geography__c> newPgsMap = new Map<String,Project_Geography__c>();
	Map<String,Project_Geography__c> pgMap = new Map<String,Project_Geography__c>();
	for(Project_Geography__c pg: pgList){		
		pgMap.put((String)pg.Project_Id__c+(String)pg.cntryId__c, pg);	
		//System.debug('Message From the Trigger:::' +pg.Project_Id__c+':Project:'+pg.cntryId__c);		
	}
	
	
	//System.debug('Project Geography pgMap::' +pgMap);
	
	if(Trigger.IsInsert){
		for (Project_Location__c pLoc : Trigger.new) {
			if(!pgMap.containsKey((String)pLoc.Project_Id__c+(String)pLoc.cntryId__c)){
				Project_Geography__c pg1 = new Project_Geography__c();
				pg1.cntryId__c = pLoc.cntryId__c;
				pg1.Project_Id__c = pLoc.Project_Id__c;
				pg1.Name = pLoc.Project_Code__c+ ' | ' +pLoc.cntryCode__c;
				System.debug('Message From the Trigger I:::' +pLoc.Project_Id__c+':Project:'+pLoc.cntryId__c);
				newPgsMap.put((String)pLoc.Project_Id__c+(String)pLoc.cntryId__c,pg1);
			}		
		/*	if (pLoc.Method__c == 'Geo Coding'){				
				Location1__c locan = new Location1__c();			
				locan.Name=pLoc.Name;
		        locan.project_code__c=pLoc.Project_Id__c;     
		        locan.Activity_Location_Province__c  = pLoc.admin1BndryName__c;      
		             //  locan.Activity_Location_Country__c=MissionName;
		        locan.Activity_Location_Country__c=pLoc.cntryName__c;
		        
		        //system.debug('Location Latitude  ==> '+pr.adminBndryLatitude__c);
		        locan.Activity_Location_Latitude__c=pLoc.Latitude__c;
		        locan.Activity_Location_Longitude__c=pLoc.Longitude__c;
		        locan.Activity__c=pLoc.ActivityId__c;
				
				locsToUpsert.add(locan);
		    	//ProjectIDs.add(pLoc.Project_Id__c);				
			} */
	    }
	} else if(Trigger.IsUpdate) {
		Project_Location__c pr = new Project_Location__c();
		Project_Location__c prNew = new Project_Location__c();
		pr = Trigger.Old[0];
		prNew = Trigger.New[0];
		List<AggregateResult> ar = new List<AggregateResult>([Select count(Id) locationCount From Project_Location__c where cntryId__c =: pr.cntryId__c]);
		if (ar != null){
			//System.debug('Message From the Trigger C:::' +ar[0].get('locationCount'));
			locCount = 	Integer.valueOf(ar[0].get('locationCount'));		
		}
		if(pgMap.containsKey((String)pr.Project_Id__c+(String)pr.cntryId__c)){
			Project_Geography__c pg1 = new Project_Geography__c();
			
			//System.debug('Message From the Trigger U:::' +pr.Project_Id__c+':Project:'+pr.cntryId__c);
			//System.debug('Message From the Trigger U1:::' +pr.cntryId__c+':Project:'+prNew.cntryId__c);
			if (pr.cntryId__c == prNew.cntryId__c){
				if (pgMap.containsKey((String)pr.Project_Id__c+(String)prNew.cntryId__c)){
					pg1= pgMap.get((String)pr.Project_Id__c+(String)prNew.cntryId__c);
				}
				//pg1.cntryId__c = pr.cntryId__c;
				//pg1.Project_Id__c = pr.Project_Id__c;
				//pg1.Name = pr.Project_Code__c+ ' | ' +pr.cntryCode__c;
				newPgsMap.put((String)pr.Project_Id__c+(String)pr.cntryId__c,pg1);	
			} else {				
				pg1.cntryId__c = prNew.cntryId__c;
				pg1.Project_Id__c = pr.Project_Id__c;
				pg1.Name = pr.Project_Code__c+ ' | ' +pr.cntryCode__c;
				newPgsMap.put((String)pr.Project_Id__c+(String)prNew.cntryId__c,pg1);
				
				if (locCount == 0){
					pgDeleteMap.put((String)pr.Project_Id__c+(String)pr.cntryId__c,pgMap.get((String)pr.Project_Id__c+(String)pr.cntryId__c));	
				}
				
			}
			
		}	
		
		//System.Debug('Trigger Vlaues:::' +pr.ActivityId__c +':::Name' +pr.Name +':::Country' +pr.cntryName__c);
		//locanDelete = [Select id From Location1__c Where Activity__c = :pr.ActivityId__c AND Name =:pr.Name AND Activity_Location_Country__c =: pr.cntryName__c];				
	} else if(Trigger.isDelete){
		Project_Location__c pr = new Project_Location__c();
		
		pr = Trigger.Old[0];
		
		List<AggregateResult> ar = new List<AggregateResult>([Select count(Id) locationCount From Project_Location__c where cntryId__c =: pr.cntryId__c and project_Id__c = :pr.Project_Id__c]);
		if (ar != null){
			//System.debug('Message From the Trigger C:::' +ar[0].get('locationCount'));
			locCount = Integer.valueOf(ar[0].get('locationCount'));		
		}
		if(pgMap.containsKey((String)pr.Project_Id__c+(String)pr.cntryId__c)){
			Project_Geography__c pg1 = new Project_Geography__c();
			
			//System.debug('Message From the Trigger U:::' +pr.Project_Id__c+':Project:'+pr.cntryId__c);
			
			pg1.cntryId__c = pr.cntryId__c;
			pg1.Project_Id__c = pr.Project_Id__c;
			pg1.Name = pr.Project_Code__c+ ' | ' +pr.cntryCode__c;
			
			if (locCount == 0){
				pgDeleteMap.put((String)pr.Project_Id__c+(String)pr.cntryId__c,pgMap.get((String)pr.Project_Id__c+(String)pr.cntryId__c));	
			}			
			
		}	
		
		//System.Debug('Trigger Vlaues:::' +pr.ActivityId__c +':::Name' +pr.Name +':::Country' +pr.cntryName__c);
		//Location1__c locanDelete = [Select id From Location1__c Where Activity__c = :pr.ActivityId__c AND Name =:pr.Name AND Activity_Location_Country__c =: pr.cntryName__c];
		//locDeleteList.add(locanDelete);
	}   
	    
    if (Trigger.IsInsert){
    /*	if (!locsToUpsert.isEmpty()){
    		upsert locsToUpsert;	
    	}    */
    	
    	newPgs = newPgsMap.values();
		upsert newPgs;		
    }
	if (Trigger.IsUpdate){
	   //if (locanDelete != null){
	 //  	upsert locanDelete;	
	   //}
		
		newPgs = newPgsMap.values();
		upsert newPgs;	
		
		pgDelete = pgDeleteMap.values();
		delete pgDelete;
	}
	
	if(Trigger.isDelete){
		//if (!locDeleteList.isEmpty()){
		//	delete locDeleteList;
		//}	
		pgDelete = pgDeleteMap.values();
		System.debug('To be deleted Values:::' +pgDelete);
		delete pgDelete;
	} 
	
	//System.debug('New Project Geography:::'+newPgs);
	

}