/**
* PlanningUnitTriggerHelper is used to assist with the 
* Planning Unit triggers
*
* CHANGE HISTORY
* =============================================================================
* Date              Name                Description
* Aug 22 2014       Ryan Chadwick       Created
* Oct 07 2014       Brian Mason         Added   Comments
* =============================================================================
*/
public with sharing class PlanningUnitTriggerHelper extends TriggerHelper{
    
    public static final String EDIT_LABEL_PREFIX = 'A&A Edit ';
    public static final String READ_LABEL_PREFIX = 'A&A Read ';
    
    public static final String EDIT_API_PREFIX = 'A_A_edit_';
    public static final String READ_API_PREFIX = 'A_A_read_';
    
    public override void processAfterInsert(){ createDefaultGroups(); }
    
    private void createDefaultGroups(){
        
        //holder for new Public Group insert operation
        List<Group> groupsInsert = new List<Group>();
        //holder to quickly grab all the new Public Group records by name
        List<String> names = new List<String>();
        
        //Operating Unit Id to list of Public Groups (will alwys be 2 in size)
        Map<String, List<Group>> ouToGroups = new Map<String, List<Group>>();
        //Operating Unit Id to Planning Unit Group (will always be 2 in size)
        Map<String, List<Planning_Unit_Group__c>> ouToPlUG = new Map<String, List<Planning_Unit_Group__c>>();
        
        //get all the parent IDs of any of the Planning Units hitting this trigger
        List<Id> parentIDs = new List<Id>();
        for( OperatingUnit__c opu : (List<OperatingUnit__c>)trigger.new ){
            parentIDs.add(opu.Parent__c);
        }
        //get all the Planning Unit Group junction objects for parents of Planning Units hitting this trigger
        //these will be used for getting and nesting the parent within its childrens groups
        List<Planning_Unit_Group__c> parentPlugs = [SELECT Id, Planning_Unit__r.Id, Group_ID__c, Access_Level__c
                                                    FROM Planning_Unit_Group__c 
                                                    WHERE Planning_Unit__c IN :parentIDs];
        
        for( OperatingUnit__c opu : (List<OperatingUnit__c>)trigger.new ){
            List<Group> tempPubGrp = new List<Group>();
            List<Planning_Unit_Group__c> tempPlug = new List<Planning_Unit_Group__c>();
            
            //create edit Public Group
            Group editGrp = new Group();
            editGrp.Name = EDIT_LABEL_PREFIX + cleanName(opu.Name).trim();
            editGrp.DeveloperName = EDIT_API_PREFIX + cleanAPIName(opu.Name).trim();
            editGrp.Type = 'Regular';
            editGrp.DoesIncludeBosses = false;
            //correlation identifiers
            groupsInsert.add(editGrp);
            tempPubGrp.add(editGrp);
            names.add(editGrp.Name);
            
            //create edit Planning Unit Group junction object
            Planning_Unit_Group__c editPlug = new Planning_Unit_Group__c();
            editPlug.Planning_Unit__c = opu.Id;
            editPlug.Access_Level__c = 'Edit';
            //correlation identifiers
            tempPlug.add(editPlug);
            
            //create read Public Group
            Group readGrp = new Group();
            readGrp.Name = READ_LABEL_PREFIX + cleanName(opu.Name).trim();
            readGrp.DeveloperName = READ_API_PREFIX + cleanAPIName(opu.Name).trim();
            readGrp.Type = 'Regular';
            readGrp.DoesIncludeBosses = false;
            //correlation identifiers
            groupsInsert.add(readGrp);
            tempPubGrp.add(readGrp);
            names.add(readGrp.Name);
            
            //create read Planning Unit Group junction object
            Planning_Unit_Group__c readPlug = new Planning_Unit_Group__c();
            readPlug.Planning_Unit__c = opu.Id;
            readPlug.Access_Level__c = 'Read';
            //correlation identifiers
            tempPlug.add(readPlug);
            
            //correlation crap for after public group create
            ouToGroups.put(''+ opu.Id, tempPubGrp);
            ouToPlUG.put(''+ opu.Id, tempPlug);
        }
        
        //insert Public Groups
        Database.insert(groupsInsert,false);
        
        //holder for new parent group insertions into children as group members
        List<String> parentMembersJSON = new List<String>();
        
        //get IDs of the newley inserted groups to add to the Planning Unit Group junction objects
        List<Group> groupsWIds = [SELECT Name, Id FROM Group WHERE Name IN :names];
        
        for(OperatingUnit__c opu : (List<OperatingUnit__c>)trigger.new){
            List<Planning_Unit_Group__c> plugList = ouToPlUG.get(''+ opu.Id);
            List<Group> initialGroupList = ouToGroups.get(''+ opu.Id);
            
            for(Group grp : groupsWIds){
                if( grp.Name == initialGroupList[0].Name ){
                    //set the grp Id on the Planning Unit Group at [0]
                    plugList[0].Group_ID__c = grp.Id;
                    //for each Planning Unit Group junction
                    for(Planning_Unit_Group__c parentPlug : parentPlugs){
                        //if the Operating Unit has a parent
                        //find it in the parent Planning Unit Group list
                        //and add it as a group member
                        if( opu.Parent__c == parentPlug.Planning_Unit__r.Id &&
                            parentPlug.Access_Level__c == 'Edit' ){
                            
                            GroupMemberHolder memberHolder = 
                                new GroupMemberHolder(grp.Id, parentPlug.Group_ID__c);
                            parentMembersJSON.add(JSON.serialize(memberHolder));
                        }
                    }
                }
                if( grp.Name == initialGroupList[1].Name ){
                    //set the grp Id on the Planning Unit Group at [1]
                    plugList[1].Group_ID__c = grp.Id;
                    //for each Planning Unit Group junction
                    for(Planning_Unit_Group__c parentPlug : parentPlugs){
                        //if the Operating Unit has a parent
                        //find it in the parent Planning Unit Group list
                        //and add it as a group member
                        if( opu.Parent__c == parentPlug.Planning_Unit__c && 
                            parentPlug.Access_Level__c == 'Read' ){
                            
                            GroupMemberHolder memberHolder = 
                                new GroupMemberHolder(grp.Id, parentPlug.Group_ID__c);
                            parentMembersJSON.add(JSON.serialize(memberHolder));
                        }
                    }
                }
            }
        }
        
        //combine all the Planning Unit Group junction objects to insert
        List<Planning_Unit_Group__c> plugInsert = new List<Planning_Unit_Group__c>();
        for(String ouId : ouToPlUG.keySet() ){
            plugInsert.add(ouToPlUG.get(ouId)[0]);
            plugInsert.add(ouToPlUG.get(ouId)[1]);
        }
        //insert the Planning Unit Group junction objects
        Database.insert(plugInsert,false);
        
        //holder for new shares
        List<OperatingUnit__Share> oushares = new List<OperatingUnit__Share>();
        //share each planning unit with the groups created for it
        for(Planning_Unit_Group__c plug : plugInsert){
            //create an operating unit share between the group and the planning unit
            OperatingUnit__Share share = new OperatingUnit__Share();
            share.ParentId = plug.Planning_Unit__c;
            share.UserOrGroupId = plug.Group_ID__c;
            share.AccessLevel = plug.Access_Level__c;
            share.RowCause = Schema.OperatingUnit__Share.RowCause.A_A_Plan_Group_Access__c;
            
            oushares.add(share);
        }
        //insert the group shares
        Database.insert(oushares);
        
        //insert the parent/child groups
        insertGroupMembers(parentMembersJSON);
    }
    
    //cleans up the name of the planning unit so it can be
    //used as an api name for the public group creation
    public static String cleanAPIName(String name){
        name = name.trim();
        name = name.replaceAll('[^a-z^A-Z^0-9]', '_');
        name = name.replaceAll('_+', '_');
        //public group name length is capped at 40
        //cut off 10 chars from end so we can add naming convention ('A_A_edit_' and 'A_A_read_')
        if(name.length() > 30){
            name = name.substring(0,30);
        }
        //if last character is a '_', hack it off the end
        if(name.lastIndexOf('_') == name.length() - 1 ){
            name = name.substring(0, name.length() - 1 );
        }
        return name;
    }
    
    //shortens the name of the planning unit so that it can be
    //used as the name for the public group creation
    public static String cleanName(String name){
        if(name.length() > 30){
            name = name.substring(0,30);
        }
        return name;
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