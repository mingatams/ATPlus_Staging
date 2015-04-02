trigger AAActionBeforeDelete on AAPlanDetail__c (before delete) {

    List<AADeletedActions__c> deletedActions = new List<AADeletedActions__c>();
    
    Map<String, Schema.SObjectField> flds = Schema.SObjectType.AADeletedActions__c.fields.getMap();
    Map<String, Schema.SObjectField> newFields = flds.clone();
    Set<String> doNotCopyFields = new Set<String>{'createdbyid',
        										  'lastactivitydate',
        										  'isdeleted',
        										  'systemmodstamp',
        										  'createddate',
        										  'action_history__c',
        										  'date_updated__c',
        										  'lastmodifiedbyid',
        										  'lastmodifieddate',
												  'date_entered__c',
        										  'fund_types__c',
        										  'id',
        										  'ownerid',
        										  'lastvieweddate',
        										  'lastreferenceddate'};
    for( String strField : newFields.keySet() ) {
        if( doNotCopyFields.contains( strField ) ) {
            newFields.remove( strField );
        }
    }
    
    List<Fund_Type__c> fundTypes = [SELECT ID,
                                    	   A_A_Action__c,
                                    	   Funding_Type__c,
                                    	   Funding_Year__c
                                   		FROM Fund_Type__c
                                   		WHERE A_A_Action__c IN :trigger.oldMap.keySet()];
    
    List<AAPlanDetail__History> actionsHistory = [Select Id,
                                                      	 ParentId,
                                                  		 CreatedBy.Name,
                                                  		 CreatedDate,
                                                      	 Field,
                                                      	 OldValue,
                                                      	 NewValue
													FROM AAPlanDetail__History
                                                 	WHERE ParentID IN :trigger.oldMap.keySet()];
    Set<ID> parentIDs = new Set<ID>();
    for( AAPlanDetail__c action : trigger.old ) {
        parentIDS.add( action.AandAPlan__c );
    }
    Map<ID, AAPlan__c> aaPlans = new Map<ID, AAPlan__c>();
    if( !parentIDs.isEmpty() ) {
        aaPlans.putAll( [SELECT ID, Name FROM AAPlan__c WHERE ID IN :parentIDs] );
    }
    for( AAPlanDetail__c action : trigger.old ){
        
        if( String.isBlank( action.Delete_Reason__c ) ){
            action.addError('Delete Reason must be populated before an Action can be deleted.');
        }
        AADeletedActions__c newDetail = new AADeletedActions__c();
        
        for( String str : newFields.keySet() ) {
            newDetail.put( str, action.get( str ) );
        }
        
        String strFundType = '';
        if( !fundTypes.isEmpty() ){
            for( Fund_Type__c ft : fundTypes ) {
                if( ft.A_A_Action__c == action.id ) {
                    strFundType+= ft.Funding_Type__c + ' - ' + (String)ft.Funding_Year__c + '\n';
                }
            }
        }
        
        String strActionHistory = '';
        if( !actionsHistory.isEmpty() ){
            for( AAPlanDetail__History ah : actionsHistory ) {
                if( ah.ParentID == action.id ) {
                    strActionHistory += ah.Field + ' changed from ' + 
                        ah.OldValue + ' to ' + 
                        ah.NewValue + ' on ' +
                        ah.CreatedDate + ' by ' +
                        ah.CreatedBy.Name + '\n';
                }
            }
        }
        if( aaPlans.containsKey( action.AandAPlan__c ) ){
            newDetail.AandAPlan__c = aaPlans.get( action.AandAPlan__c ).Name;
        }
        newDetail.Year__c = action.Year__c;
        newDetail.Fund_Types__c = strFundType;
        newDetail.Action_History__c = strActionHistory;
        deletedActions.add( newDetail );
    }
    
    if( !deletedActions.isEmpty() ){
        insert deletedActions;
    }
}