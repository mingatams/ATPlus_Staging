/*
 * 
 * 
 * 
 * 
 * 
 */
global class PlanningUnitGroupRefIntegrityCheck Implements Schedulable {

    global void execute(SchedulableContext SC){
        //Query Planning_Unit_Group for Planning_Unit_Groups without blank Group_ID__c
        Map<ID, Planning_Unit_Group__c> pug = 
            new Map<ID, Planning_Unit_Group__c>([SELECT ID,
                                                        Access_Level__c,
                                                        Group_ID__c, 
                                                        Planning_Unit__r.Name
                                                    FROM Planning_Unit_Group__c 
                                                    WHERE Group_ID__c != NULL]);
        Map<ID, List<Planning_Unit_Group__c>> mapPubGroupIDtoPUG = null;
        if( !pug.isEmpty() ){
            mapPubGroupIDtoPUG = new Map<ID, List<Planning_Unit_Group__c>>();
            for( ID pID : pug.keySet() ){
                if( pug.get(pID).Group_ID__c != NULL){
                    if( !mapPubGroupIDtoPUG.containsKey( (ID)pug.get( pID ).Group_ID__c ) ){
                        mapPubGroupIDtoPUG.put( (ID)pug.get( pID ).Group_ID__c, new List<Planning_Unit_Group__c> { pug.get( pID ) } );
                    }else if( mapPubGroupIDtoPUG.containsKey( (ID)pug.get( pID ).Group_ID__c ) ){
                        mapPubGroupIDtoPUG.get( (ID)pug.get( pID ).Group_ID__c ).add( pug.get( pID ) );
                    }
                }
            }
        }
        if( !mapPubGroupIDtoPUG.isEmpty() ){
            List<Planning_Unit_Group__c> pugsToUpdate = new List<Planning_Unit_Group__c>();
            Set<ID> setGroupIDs = new Map<ID, Group>([SELECT ID, Name FROM Group WHERE Type LIKE 'Regular']).keySet();
            for( ID gID : mapPubGroupIDtoPUG.keySet() ){
                if( !setGroupIDs.contains( gID ) ){
                    for( Planning_Unit_Group__c p : mapPubGroupIDtoPUG.get( gID ) ){
                        pugsToUpdate.add( p );
                    }
                }
            }
            
            if( !pugsToUpdate.isEmpty() ){
                for( Planning_Unit_Group__c p : pugsToUpdate ){
                    p.Group_ID__c = null;
                }
                update pugsToUpdate;
                
                A_A_Public_Group_Integrity_Check_Config__c config = A_A_Public_Group_Integrity_Check_Config__c.getValues('Default Config');
                if( String.isNotBlank( config.To_Addresses__c ) ){
                    
                    // the current transaction is committed.
                    Messaging.reserveSingleEmailCapacity(1);
                    
                    // Processes and actions involved in the Apex transaction occur next,
                    // which conclude with sending a single email.
                    
                    // Now create a new single email message object
                    // that will send out a single email to the addresses in the To, CC & BCC list.
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    // Strings to hold the email addresses to which you are sending the email.
                    String[] ccAddresses = new String[]{};
                    String[] bccAddresses = new String[]{};
                    String[] toAddresses = config.To_Addresses__c.split(','); 
                    if( string.isNotBlank( config.CC_Addresses__c ) ){
                        ccAddresses = config.CC_Addresses__c.split(',');     
                    }
                    if( string.isNotBlank( config.BCC_Addresses__c ) ){
                        bccAddresses = config.BCC_Addresses__c.split(',');     
                    }
                    
                    String pugOutput = '';
                    for( Planning_Unit_Group__c p : pugsToUpdate ){
                        pugOutput += pugOutput + p.Planning_Unit__r.Name + ' ' + p.Access_Level__c + '\n';
                    }
                    
                    // Assign the addresses for the To, CC and BCC lists to the mail object.
                    mail.setToAddresses(toAddresses);
                    mail.setCcAddresses(ccAddresses);
                    mail.setBccAddresses(bccAddresses);
                    if( String.isNotBlank( config.Reply_To_Address__c ) ){
                        // Specify the address used when the recipients reply to the email. 
                        mail.setReplyTo( config.Reply_To_Address__c );
                    }
                    if( String.isNotBlank( config.From_Address_Display_Name__c ) ){
                        // Specify the name used as the display name.
                        mail.setSenderDisplayName( config.From_Address_Display_Name__c );
                    }
                    // Specify the subject line for your email address.
                    mail.setSubject('Groups IDs in Planning_Unit_Group__c Check Failed');
                    
                    // Set to True if you want to BCC yourself on the email.
                    mail.setBccSender(false);
                    
                    // Optionally append the salesforce.com email signature to the email.
                    // The email address of the user executing the Apex Code will be used.
                    mail.setUseSignature(false);
                    
                    // Specify the text content of the email.
                    mail.setPlainTextBody('The below Planning Unit Groups do not have associated Public Groups.\n' +
                                          'The orginal Public Groups assigned no longer exist in the system.\n' +
                                          'Please use the \'Edit Default Planning Unit\' option for the affected Planning Unit.\n\n' +
                                          pugOutput);
                    
                    mail.setHtmlBody('<b>The below Planning Unit Groups do not have associated Public Groups.<br>' +
                                          'The orginal Public Groups assigned no longer exist in the system.<br>' +
                                          'Please use the \'Edit Default Planning Unit\' option for the affected Planning Unit.</b><br><br>' +
                                          pugOutput);
                    
                    // Send the email you have created.
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
            }
        }
    }
}