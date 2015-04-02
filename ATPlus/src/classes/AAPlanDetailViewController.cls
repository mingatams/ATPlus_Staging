/**
* AAPlanDetailViewController is used in AAPlanDetailEdit and AAPlanDetailView to
* create/edit/view AAPlanDetail__c records.
*
* CHANGE HISTORY
* ==================================================================================================
* Date              Name                Description
* Aug 12 2014       Brian Mason         Created
* Oct 07 2014       Brian Mason         Updated  Constructor to set fund type 
*                                       URL info and rearranged Save function.
* Oct 08 2014       Ryan Chadwick       Added completion check and messages
* Oct 09 2014       Ryan Chadwick       Added saving of completion state to a boolean on the object
*                                       Implemented auto save functionality on AAPlanDetailEdit.page
* Dec 08 2014		Brian Mason			Add 'deleteFlag' and method to set it. Used to condition if
										'Delete' button shows
* ==================================================================================================
*/
public with sharing class AAPlanDetailViewController {
    // Variable to contain A&A Action record being accessed or created.
    @TestVisible public AAPlanDetail__c currentAandARecord {get; private set;}
    
    public AAPlanDetail__c siblings {get; private set;}
    // profiles to filter 'reportCheck' variable against.
    private Set<String> profiles = new Set<String>{'System Administrator', 
                                                   'System Administrator(c)',
                                                   'A&A Planning Admin',
                                                   'A&A Plan System Administrator(c)'};
    // reportCheck is used to make sure that user has access 
    // to the 'Sharing' button.
    public boolean reportCheck { get; private set; }
    // URL to be returned for the New Fund Type button's use
    public String fundTypeAAPDURL { get; private set; }
    // If the custom setting containing the Fund Type A&A Action field ID
    // is not found, this exception will be raised
    public class MissingCustomSettingException extends Exception {}
    
    //denotes whether all required fields are filled in
    //will be used as a toggle to display a completion message on page load
    public Boolean completeCheck {get; private set;}
    
    public List<String> failedFields {get; private set;}
    
    public Boolean deleteFlag { public get; private set; }
    
    //Constructor
    public AAPlanDetailViewController() {
        // Set currentAandARecord to the existing record or
        // to a new blank AAPlanDetail__c
        this.currentAandARecord = getAandAPlanData();
        if( currentAandARecord != null ) {
            // Check if user should have access to 'Sharing' button.
            reportCheck = [SELECT ID 
                            FROM User 
                            WHERE ID = :UserInfo.getUserId() 
                            AND Profile.Name IN :profiles].size() > 0;
            
            // Set flag which is used to determine if user has access to 'A&A Detail Delete' page
            setDeleteFlag();
            
            // Set the URL used in the New Fund_Type__c button
            if( fundTypeAAPDURL == null && Object_Field_Ids__c.getInstance( 'FundType.A_A_Action' ) != null ){
                String fieldID = String.valueOf( Object_Field_Ids__c.getInstance( 'FundType.A_A_Action' ).get( 'Field_ID__c' ) );
                String keyPrefix = Fund_Type__c.sObjectType.getDescribe().getKeyPrefix();
                fundTypeAAPDURL = '/' + keyPrefix + '/e?' + 
                                  'CF' + fieldID + '=' + currentAandARecord.name + '&' + 
                                  'CF' + fieldID + '_lkid=' + currentAandARecord.id + '&' +
                                  'retURL=' + currentAandARecord.id + '&' +
                                  'saveURL=' + currentAandARecord.id + '&' +
                                  'cancelURL=' + currentAandARecord.id;
            }else if( Object_Field_Ids__c.getInstance( 'FundType.A_A_Action' ) == null ){
                throw new MissingCustomSettingException('Fund_Type__c A_A_Action__c field ID not defined in "Object Field IDs" custom setting.');
            }
            
            failedFields = new List<String>();
            
            if(ApexPages.currentPage().getParameters().get('id') == null){
                completeCheck = false;
            }else{
                completeCheck = checkForCompletion();
            }
        }
    }

    /*
    **  PUBLIC METHODS
    */

    //Field Set Methods
    public List<Schema.FieldSetMember> getGeneralBucketFieldSet(){
        return SObjectType.AAPlanDetail__c.FieldSets.GeneralBucket.getFields();
    }

    public List<Schema.FieldSetMember> getAwardBucketFieldSet(){
        return SObjectType.AAPlanDetail__c.FieldSets.AwardBucket.getFields();
    }

    public List<Schema.FieldSetMember> getAdditionalAwardInfoBucketFieldSet(){
        return SObjectType.AAPlanDetail__c.FieldSets.AdditionalAwardInfoBucket.getFields();
    }

    public List<Schema.FieldSetMember> getSalesforceBucketFieldSet(){
        return SObjectType.AAPlanDetail__c.FieldSets.SalesforceBucket.getFields();
    }
    
    public List<Schema.FieldSetMember> getAandAReportingQuestionsBucketFieldSet(){
        return SObjectType.AAPlanDetail__c.FieldSets.A_AReportingQuestions.getFields();
    }
    
    public List<Schema.FieldSetMember> getAARADInfoBucketFieldSet(){
        return SObjectType.AAPlanDetail__c.FieldSets.AARADInfo.getFields();
    }
    
    public List<Schema.FieldSetMember> getFreeFieldBucketFieldSet(){
        return SObjectType.AAPlanDetail__c.FieldSets.FreeFields.getFields();
    }
    
    // Method to save record.
    public PageReference save(){
        // check to make sure the record exists already and this is an update
        if( currentAandARecord.id != null ){
            try {
                // Query to pull most current version of the record
                AAPlanDetail__c aaplandetail = [SELECT ID, LastModifiedDate, LastModifiedBy.Name FROM AAPlanDetail__c WHERE ID = :currentAandARecord.id LIMIT 1];
                // Check that the LastModifiedDate is equal to the LastModifiedDate 
                // from the record pulled recently (aaplandetail).
                // if they are the same, update the record.
                if( aaplandetail.LastModifiedDate == currentAandARecord.LastModifiedDate ) {
                    upsert currentAandARecord;
                }else{
                    // The LastModifiedDate's are not the same. 
                    // Raise a page message and ask user to refresh and make changes again.
                    ApexPages.addMessage( new ApexPages.Message( 
                                            ApexPages.Severity.Error, 
                                            'Your Changes Cannot Be Saved The record you were editing was modified by ' + 
                                            aaplandetail.LastModifiedBy.Name + 
                                            ' during your edit session.\n' +
                                            'Please re-display the record before editing again.') );
                    // return to the same page to display the error.
                    return null;
                }
            }catch(Exception e){
                ApexPages.addMessages(e);
                return null;
            }
        // if the record has not been commited yet, 
        // commit it.
        }else if( currentAandARecord.id == null ){
            try{
                upsert currentAandARecord;
            }catch( Exception e ){
                ApexPages.addMessages(e);
                return null;
            }
            
        }
        // return the view page of the record.
        return getViewPage();
    }
    
    // Cancel method to return to view page if the cancel
    // button is pressed.
    public PageReference cancel(){
        // Get page reference for A&A Action view page
        PageReference redirect = getViewPage();
        // if there is no page to redirect to,
        // redirect to the plandetail list.
        if(redirect == null) {
            redirect = Page.AAPlanDetailList;
            redirect.setRedirect(true);
        }
        return redirect;
    }
    
    // SharingACLs returns the Page for the
    // salesforce supplied sharing page of
    // a record.
    public PageReference sharingACLs(){
        // Get page reference for sharing page
        PageReference redirect = getSharingPage();
        // if there is no page to redirect to,
        // redirect to the plandetail list.
        if(redirect == null) {
            redirect = Page.AAPlanDetailList;
            redirect.setRedirect(true);
        }
        return redirect;
    }
    
    // Edit method to return to Edit page if the Edit
    // button is pressed.
    public PageReference edit() {
        // Get page reference for A&A Action edit page
        return getEditPage();
    }
    
    // Delete method to return to Detail list page 
    // if the delete button is pressed and record
    // deletion is successful.
    public PageReference deletex() {
        try {
            // Delete record and return A&A Detail
            // List for parent if record is deleted
            // with no exception
            delete currentAandARecord;
            return getListPage();
        } catch(DmlException e) {
            // Catch exception and add it to 
            // page messages
            ApexPages.addMessages(e);
        }
        // return to page so error can be displayed
        return null;
    }
    
    /*
        PRIVATE METHODS
    */
    
    //checks completeness of the record so that a message
    //can be displayed denoting this to the user
    private Boolean checkForCompletion(){
        Boolean retval = true;
        
        List<AAAction_Required_Field__c> reqFields = [SELECT Name, API_Name__c FROM AAAction_Required_Field__c LIMIT 100];
        
        SoqlBuilder checkBuilder = new SoqlBuilder()
            .selectx('Id');
        for(AAAction_Required_Field__c reqField : reqFields){
            checkBuilder.selectx(reqField.API_Name__c);
        }
        //FROM
        checkBuilder.fromx('AAPlanDetail__c');
        //CONDITIONS
        checkBuilder.wherex(new FieldCondition('Id', currentAandARecord.id));
        //LIMITS
        checkBuilder.limitx(1);
        
        try{
            AAPlanDetail__c detail = Database.query(checkBuilder.toSoql());
            
            String fieldName = 'FirstName';
            
            List<Schema.DescribeSObjectResult> describeSobjectsResult = Schema.describeSObjects(new List<String>{'AAPlanDetail__c'});
            Map<String, Schema.SObjectField> allFields = describeSobjectsResult[0].fields.getMap();
            
            for(AAAction_Required_Field__c reqField : reqFields){
                if( detail.get(reqField.API_Name__c) == null ){
                    retval = false;
                    System.debug('found a bull value for field: ' + reqField.API_Name__c);
                    failedFields.add( allFields.get(reqField.API_Name__c).getDescribe().getLabel() );
                }
            }
            
        }catch(Exception e){
            System.debug('no record found - setting completion to false');
            retval = false;
        }
        
        for(String field : failedFields){
            System.debug(field);
        }
        
        System.debug('complete check is: ' + retval);
        
        return retval;
    }
    
    // Returns all field sets in a list
    private List<Schema.FieldSetMember> getAllFieldSet(){
        List<Schema.FieldSetMember> allFields = new List<Schema.FieldSetMember>();

        if(getGeneralBucketFieldSet() != null){
            allFields.addAll(getGeneralBucketFieldSet());
        }

        if(getAwardBucketFieldSet() != null){
            allFields.addAll(getAwardBucketFieldSet());
        }

        if(getAdditionalAwardInfoBucketFieldSet() != null){
            allFields.addAll(getAdditionalAwardInfoBucketFieldSet());
        }


        if(getSalesforceBucketFieldSet() != null){
            allFields.addAll(getSalesforceBucketFieldSet());
        }
        
        if(getAandAReportingQuestionsBucketFieldSet() != null){
            allFields.addAll(getAandAReportingQuestionsBucketFieldSet());
        }
        
        if(getAARADInfoBucketFieldSet() != null){
            allFields.addAll(getAARADInfoBucketFieldSet());
        }
        
        if(getFreeFieldBucketFieldSet() != null){
            allFields.addAll(getFreeFieldBucketFieldSet());
        }

        return allFields;
    }

    // Returns AAPlanDetail__c associated with 'id' in the page parameters.
    // if 'id' is null a blank AAPlanDetail__c is returned.
    private AAPlanDetail__c getAandAPlanData(){

        String id = ApexPages.currentPage().getParameters().get('id');
        String parentId = ApexPages.currentPage().getParameters().get('ParentId');
        
        if(id == null){
            //default Entered Or Updated to now
            AAPlanDetail__c detail = new AAPlanDetail__c(AandAPlanDateEnteredOrUpdated__c=String.valueOf(System.today()));
            
            //set the default quarter to the currently active fiscal year's current quarter
            FiscalYear__c fy = [SELECT CurrentQuar__c FROM FiscalYear__c WHERE IsActive__c = true];
            detail.Quarter__c = fy.CurrentQuar__c;
            
            //populate the ParentId, if possible
            if(parentId != null) {
                AAPlan__c[] plans = [SELECT Id FROM AAPlan__c WHERE Id = :parentId];
                if(plans.size() > 0) {
                    detail.AandAPlan__c = plans[0].Id;
                }
            }
            return detail;
        } else {
			
            //SELECT 
            SoqlBuilder builder = new SoqlBuilder()
                .selectx('Id')
                .selectx('Name')
                .selectx('AwardTitle__c')
                .selectx('AandAPlan__c')
                .selectx('Year__c')
                .selectx('AandAPlan__r.Name')
                .selectx('CreatedBy.Name')
                .selectx('LastModifiedDate')
                .selectx('LastModifiedBy.Name')
                .selectx('UserRecordAccess.HasEditAccess')
                .selectx('UserRecordAccess.HasDeleteAccess')
                .selectx('CreatedDate');
            
            //ADD FIELDS
            for(Schema.FieldSetMember f: this.getAllFieldSet()){
                builder.selectx(f.getFieldPath());
            }

            //FROM
            builder.fromx('AAPlanDetail__c');

            //CONDITIONS
            builder.wherex(new FieldCondition('Id', id));

            //LIMITS
            builder.limitx(1);
            
            try{
                return Database.query(builder.toSoql());
            }catch( Exception E ){
                return null;
            }
        }
    }
    /*
    private void updateSiblingRecords() {
        siblings = [
                SELECT 
                    Id, 
                    AwardTitle__c 
                FROM AAPlanDetail__c 
                WHERE 
                    Year__c = :currentAandARecord.Year__c AND 
                    AandAPlan__c = :currentAandARecord.AandAPlan__c
        ];
    }
    */
    
    // Returns view page for AAPlanDetail__c record
    private PageReference getViewPage() {
        if(currentAandARecord.Id != null) {
            PageReference viewPage = Page.AAPlanDetailView;
            viewPage.setRedirect(true);
            viewPage.getParameters().put('id', currentAandARecord.id);
            return viewPage;
        }
        return null;
    }
    
    // Returns edit page for AAPlanDetail__c record
    private PageReference getEditPage() {
        PageReference editPage = Page.AAPlanDetailEdit;
        editPage.setRedirect(true);
        if(currentAandARecord.Id != null) {
            editPage.getParameters().put('id', currentAandARecord.id);
        }
        return editPage;
    }
    
    // Returns list page for AAPlanDetail__c record
    private PageReference getListPage() {
        PageReference listPage = Page.AAPlanDetailList;
        listPage.setRedirect(true);
        if(currentAandARecord.Id != null) {
            listPage.getParameters().put('ParentId', currentAandARecord.AandAPlan__c);
        }
        return listPage;
    }
    
    // Returns Sharing page for AAPlanDetail__c record
    private PageReference getSharingPage(){
        PageReference aclPage = null;
        
        if(currentAandARecord.Id != null){
            aclPage = new PageReference('/p/share/CustomObjectSharingDetail?parentId=' + (String)currentAandARecord.AandAPlan__c);
            aclPage.setRedirect(true);
        }
        return aclPage;
    }
    
    // Method to check if user has access to the 'Delete' page by profile or permission set.
    private void setDeleteFlag() {
        // First check to see if user has access because the profile has
        // access to the page.
        try{
            List<SetupEntityAccess> sea = [SELECT Id, 
                                                Parent.Name, 
                                                Parent.Profile.Name, 
                                                Parent.Profile.Id
                                            FROM SetupEntityAccess 
                                            WHERE Parent.Profile.Id = :UserInfo.getProfileId() 
                                            AND SetupEntityId IN (SELECT Id 
                                                                    FROM ApexPage 
                                                                    WHERE Name = 'AAPlanDetailDelete')];
            if( !sea.isEmpty() ){
                deleteFlag = TRUE;
            }else{
                deleteFlag = FALSE;
            }
        }catch( Exception e ){
            deleteFlag = FALSE;
        }
        if( deleteFlag != TRUE){
            // Next, check if the user has a permission set which has access to the page
            try{
                // Get all the permission sets asssigned to the user
                List<PermissionSetAssignment> psa = [SELECT ID, 
                                                            permissionsetID
                                                            FROM PermissionSetAssignment
                                                            WHERE AssigneeID = :UserInfo.getUserID()];
                // drop all permission set id into a set for use in the query.
                // 'Parent.ID' relationship cannot be traveresd in query.
                Set<ID> psaIDs = new Set<ID>();
                for( PermissionSetAssignment p : psa ){
                    psaIDs.add( p.PermissionSetID );
                }
                // query to check if assigned permission set has access to the admin page
                List<SetupEntityAccess> sea =[SELECT ID,
                                                    Parent.Name
                                                FROM SetupEntityAccess
                                                WHERE Parent.id IN :psaIDs
                                                AND SetupEntityId IN (SELECT Id 
                                                                        FROM ApexPage 
                                                                        WHERE Name = 'AAPlanDetailDelete')];
                if( !sea.isEmpty() ){
                    deleteFlag = TRUE;
                }else{
                    deleteFlag = FALSE;
                }
            }catch( Exception e ){
                deleteFlag = FALSE;
            }
        }
    }
}