public with sharing class PlanningUnitUserTriggerHelper extends TriggerHelper{
	
	public override void processAfterInsert(){ addToReadGroup(); sharePlanningUnit(); }
	
	public override void processBeforeDelete(){ revokeSharePlanningUnit(); }
	
	private void addToReadGroup(){
		//holder for all the new group member assignments
		List<String> gmHolderJSONList = new List<String>();
		
		//get all the Read access Groups associated with the Planning Units listed
		//in Planning Unit User junction objects hitting this trigger
		
		//first get all the planning unit ids
		List<Id> planningUnitIds = new List<Id>();
		for(Planning_Unit_User__c pluu : (List<Planning_Unit_User__c>)trigger.new){
			planningUnitIds.add(pluu.Planning_Unit__c);
			System.debug('Found Id: ' + pluu.Planning_Unit__c);
		}
		
		//second get all the Planning unit Group junction objects associated with these
		//Planning Units that have an access level of Read
		List<Planning_Unit_Group__c> plugList = [SELECT Id, Name, Access_Level__c, Group_ID__c, Planning_Unit__r.Id
											FROM Planning_Unit_Group__c 
											WHERE Planning_Unit__r.Id IN :planningUnitIds AND Access_Level__c = 'Read'];
		
		//if the id of the Planning Unit is the same in both the Planning Unit User and
		//Planning Unit Group then create a new read group member
		for(Planning_Unit_User__c pluu : (List<Planning_Unit_User__c>)trigger.new){
			for(Planning_Unit_Group__c plug : plugList){
				if(pluu.Planning_Unit__c == plug.Planning_Unit__r.Id){
					System.debug('match');
					System.debug('group Id: ' + plug.Group_ID__c);
					System.debug('user Id: ' + pluu.User__c);
					GroupMemberHolder memberHolder = 
						new GroupMemberHolder(plug.Group_ID__c, pluu.User__c);
					
					gmHolderJSONList.add(JSON.serialize(memberHolder));
				}
			}
		}
		
		//well apparently you can't add GroupMembers in MIXED_DML_OPERATIONS so
		//im going to use a future method to perform the insert seperately.
		//HERE WE GO!
		//Ok apparently you can't pass sObjects to future annotated methods.
		//So now we serialize everything using JSON to pass it over
		//and then build real sObjects on the other side.
		insertGroupMembers(gmHolderJSONList);
	}
	
	@future
	public static void insertGroupMembers(List<String> gmHolderJSONList){
		List<GroupMember> gmList = new List<GroupMember>();
		
		for(String gmhString : gmHolderJSONList){
			GroupMemberHolder gmh = (GroupMemberHolder) JSON.deserialize(gmhString, GroupMemberHolder.class);
			GroupMember tempMember = new GroupMember();
			tempMember.GroupId = gmh.GroupId;
			tempMember.UserOrGroupId = gmh.UserOrGroupId;
			
			gmList.add(tempMember);
		}
		
		Database.SaveResult[] srList = Database.insert(gmList,false);
		
		//debug time cus im mad at this shit
		// Iterate through each returned result
		for (Database.SaveResult sr : srList) {
		    if (sr.isSuccess()) {
		        // Operation was successful, so get the ID of the record that was processed
		        System.debug('Successfully inserted GroupMember. GroupMember ID: ' + sr.getId());
		    }
		    else {
		        // Operation failed, so get all errors                
		        for(Database.Error err : sr.getErrors()) {
		            System.debug('The following error has occurred.');                    
		            System.debug(err.getStatusCode() + ': ' + err.getMessage());
		            System.debug('GroupMember fields that affected this error: ' + err.getFields());
		        }
		    }
		}
	}
	
	private void sharePlanningUnit(){
		//holder for new shares on the Planning Unit
		List<OperatingUnit__Share> opuShares = new List<OperatingUnit__Share>();
		
		for(Planning_Unit_User__c pluu : (List<Planning_Unit_User__c>)trigger.new){
			OperatingUnit__Share share = new OperatingUnit__Share();
			share.ParentId = pluu.Planning_Unit__c;
			share.UserOrGroupId = pluu.User__c;
			share.AccessLevel = 'read';
			share.RowCause = Schema.OperatingUnit__Share.RowCause.AA_Plan_Home_Unit__c;
			
			opuShares.add(share);
		}
		
		Database.insert(opuShares,false);
	}
	
	private void revokeSharePlanningUnit(){
		//holder for permissions to revoke
		List<OperatingUnit__Share> revokeList = new List<OperatingUnit__Share>();
		
		List<Id> planningUnitIds = new List<Id>();
		for(Planning_Unit_User__c pluu : (List<Planning_Unit_User__c>)trigger.old){
			planningUnitIds.add(pluu.Planning_Unit__c);
		}
		
		List<OperatingUnit__Share> interimList = [SELECT Id, UserOrGroupId, ParentId
												FROM OperatingUnit__Share
												WHERE ParentId IN :planningUnitIds];
												
		for(Planning_Unit_User__c pluu : (List<Planning_Unit_User__c>)trigger.old){
			for(OperatingUnit__Share opuShare : interimList){
				if(pluu.User__c == opuShare.UserOrGroupId
					&& pluu.Planning_Unit__c == opuShare.ParentId){
					revokeList.add(opuShare);
				}
			}
		}
		
		Database.delete(revokeList,false);
	}
	
	//Holder class for passing data to future methods
	//This class encapsulates data for a GroupMember sObject
	public with sharing class GroupMemberHolder{
		public String GroupId {get;set;}
		public String UserOrGroupId {get;set;}
		
		public GroupMemberHolder(String gId, String uOgId){
			GroupId = gId;
			UserOrGroupId = uOgId;
		}
	}
}