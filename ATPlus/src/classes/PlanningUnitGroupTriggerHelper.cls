public with sharing class PlanningUnitGroupTriggerHelper extends TriggerHelper{
	
	public override void processBeforeInsert(){ checkExisting(); }
	
	public override void processAfterInsert(){ addShares(); }
	
	public override void processAfterUpdate(){  }
	
	public override void processBeforeDelete(){ removeShares(); }
	
	private void checkExisting(){
		//only one read and one edit group should exist for any planning unit
		
		//get the ids of the Planning Units for the Planning Unit Group junction objects
		//hitting this trigger
		List<Id> idsBeingAdded = new List<Id>();
		for(Planning_Unit_Group__c plug : (List<Planning_Unit_Group__c>)trigger.new){
			idsBeingAdded.add(plug.Planning_Unit__c);
		}
		
		//get all the existing Planning Unit Group junction objects
		//that are associated with these Planning Units
		List<Planning_Unit_Group__c> existingPlugs = [SELECT Name, Id, Planning_Unit__r.Id, Planning_Unit__r.Name, Access_Level__c
													 FROM Planning_Unit_Group__c
													 WHERE Planning_Unit__r.Id IN :idsBeingAdded];
		
		for( Planning_Unit_Group__c newplug : (List<Planning_Unit_Group__c>)trigger.new ){
			for( Planning_Unit_Group__c oldplug : existingPlugs ){
				//if the id's for the Planning Unit and the access level match up
				//then we already have a Planning Unit Group of this type for the
				//Planning Unit in question and a duplicate is not needed
				if(newplug.Planning_Unit__c == oldplug.Planning_Unit__r.Id &&
					newplug.Access_Level__c == oldplug.Access_Level__c){
					
					newplug.addError('A group is already associated with ' + oldplug.Planning_Unit__r.Name + ' with an access level of ' + oldplug.Access_Level__c);
				}
			}
		}
	}
	
	private void addShares(){
		//holder for all the new share instances to insert later
		List<AAPlan__Share> planShares = new List<AAPlan__Share>();
		
		//get all the planning unit group association Ids
		List<Id> planningUnitIds = new List<Id>();
		for(Planning_Unit_Group__c plg : (List<Planning_Unit_Group__c>)trigger.new){
			planningUnitIds.add(plg.Planning_Unit__c);
			System.debug('Id found: ' + plg.Planning_Unit__c);
		}
		
		//get all the AAPlan records with planning unit group associations we're dealing with
		List<AAPlan__c> aaPlans = [SELECT Id, OperatingUnit__r.Id FROM AAPlan__c WHERE OperatingUnit__r.Id IN :planningUnitIds];
		
		//for every AAPlan Records
		for(AAPlan__c aaPlan : aaPlans){
			//check if it is associated with one of the planning units we're working with
			for(Planning_Unit_Group__c jg : (List<Planning_Unit_Group__c>)trigger.new){
				//if it is then add sharing for the asociated publig group matched with this planning unit
				if( aaPlan.OperatingUnit__r.Id == jg.Planning_Unit__c ){
					System.debug('Match');
					AAPlan__Share share = new AAPlan__Share();
					share.ParentId = aaPlan.Id;
					share.UserOrGroupId = jg.Group_Id__c;
					share.AccessLevel = jg.Access_Level__c.toLowerCase();
					share.RowCause = Schema.AAPlan__Share.RowCause.AAPlan_Group_Sharing__c;
					
					planShares.add(share);
				}
			}
		}
		
		Database.insert(planShares, false);
	}
	
	private void removeShares(){
		
		//get public group and planning unit ids
		List<Id> planningUnitIds = new List<Id>();
		List<Id> publicGroupIds = new List<Id>();
		
		for(Planning_Unit_Group__c plg : (List<Planning_Unit_Group__c>)trigger.old){
			planningUnitIds.add( plg.Planning_Unit__r.Id );
			publicGroupIds.add( plg.Group_ID__c );
		}
		
		//get all shares with the public group association from the shares
		List<AAPlan__Share> sharesRevokeList = [SELECT Id FROM AAPlan__Share WHERE UserOrGroupId IN :publicGroupIds];
		
		//remove shares for removed groups from AAPlan records
		if(!sharesRevokeList.isEmpty()){
			Database.Delete(sharesRevokeList,false);
		}
	}
}