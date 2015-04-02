public with sharing class AAPlanTriggerHelper extends TriggerHelper{
	
	
	public override void processAfterUpdate(){ /*addShares();*/ }
	
	//defined in AA Plan creation, not needed to auto-populate
	public override void processBeforeInsert(){ /*addPlanningUnit(); addFY();*/ }
	
	public override void processAfterInsert(){ addShares(); }
	
	/*
	private void addPlanningUnit(){
		//get the active user
		Id curUserId = UserInfo.getUserId();
		//get the active users home operating unit
		Planning_Unit_User__c junctionUser = 
			[SELECT Planning_Unit__r.Id, User__c
			FROM Planning_Unit_User__c 
			WHERE User__r.Id = :curUserId];
		//add the operating unit to all AAPlans hitting the trigger
		for(AAPlan__c aaplan : (List<AAPlan__c>)trigger.new){
			aaplan.OperatingUnit__c = junctionuser.Planning_Unit__r.Id;
		}
	}
	
	private void addFY(){
		//get the active fiscal year
		FiscalYear__c thisYear = [SELECT Id FROM FiscalYear__c WHERE isActive__c = true];
		//add it to all the AAPlans hitting the trigger
		for(AAPlan__c aaplan : (List<AAPlan__c>)trigger.new){
			aaplan.FiscalYear__c = thisYear.Id;
		}
	}
	*/
	
	private void addShares(){
		//holder for all the new share instances to insert later
		List<AAPlan__Share> planShares = new List<AAPlan__Share>();
		
		//get the inserting users home planning unit
		Id curUserId = UserInfo.getUserId();
		Planning_Unit_User__c junctionUser;
		try{
		junctionUser = 
			[SELECT Planning_Unit__r.Id, User__c
			FROM Planning_Unit_User__c 
			WHERE User__r.Id = :curUserId];
		}catch(Exception e){
			junctionUser = null;
		}
		
		//check to make sure we have a home planning unit for this user
		//if not, no sharing
		//if yes, lots of sharing
		if( junctionUser != null ){
			//get the associated Public Groups for the planning unit
			List<Planning_Unit_Group__c> junctionGroups = 
				[SELECT Planning_Unit__c, Group_ID__c, Access_Level__c 
				FROM Planning_Unit_Group__c 
				WHERE Planning_Unit__r.Id = :junctionUser.Planning_Unit__r.Id];
			
			for(AAPlan__c plan : (List<AAPlan__c>)trigger.new){
				//create a new share for each group associated with this planning unit
				for(Planning_Unit_Group__c jg : junctionGroups){
					AAPlan__Share share = new AAPlan__Share();
					share.ParentId = plan.Id;
					share.UserOrGroupId = jg.Group_Id__c;
					share.AccessLevel = jg.Access_Level__c.toLowerCase();
					share.RowCause = Schema.AAPlan__Share.RowCause.AAPlan_Group_Sharing__c;
					
					planShares.add(share);
				}
			}
		}
		
		//get all the Planning Units associated with AA Plans hitting this tirgger
		List<Id> ouIdList = new List<Id>();
		for(AAPlan__c plan : (List<AAPlan__c>)trigger.new){
			ouIdList.add(plan.OperatingUnit__c);
			System.debug('id found: ' + plan.OperatingUnit__c);
		}
		
		//get all the Planning Unit Groups (junction object) associated with Operating Units
		List<Planning_Unit_Group__c> ouListJunction = 
					[SELECT Id, Planning_Unit__r.Id, Group_ID__c, Access_Level__c 
					FROM Planning_Unit_Group__c 
					WHERE Planning_Unit__r.Id IN :ouIdList];
		
		//for all AA Plans
		for(AAPlan__c plan : (List<AAPlan__c>)trigger.new){
			//for all planning unit junction objects to groups
			for(Planning_Unit_Group__c plug : ouListJunction){
				//if the junction points to the current plans selected unit, create a share
				if( plug.Planning_Unit__r.Id == plan.OperatingUnit__c ){
					System.debug('match');
					AAPlan__Share share = new AAPlan__Share();
					share.ParentId = plan.Id;
					share.UserOrGroupId = plug.Group_Id__c;
					share.AccessLevel = plug.Access_Level__c.toLowerCase();
					share.RowCause = Schema.AAPlan__Share.RowCause.AAPlan_Selected_Unit__c;
					
					planShares.add(share);
				}
			}
		}
		
		Database.insert(planShares,false);
	}
}