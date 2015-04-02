/**
 * This class contains global utility methods 
 *
 * Utility methods are methods used by all classes and triggers 
 * following methods are defined in this class - 
 * getRecordTypeId  - Arg:Object Name, Record Type Name  
 *                    Ret:Record Type Id
 * getRecordType    - Arg:Object Name, Record Type Id 
 *                    Ret:Record Type Id
 * getUserRole      - Arg:None (gets current User Id from UserInfo)
 *                    Ret:Role Code (first part of Role Name)
 * getWholeUserRole     - Arg:None (gets current User Id from UserInfo)
 *                        Ret:Role Name
 * getProfile       - Arg: Profile Name
 *                    Ret: Profile Id
 * getProfile       - Arg: Profile Id
 *                    Ret: Profile Name
 * lookup           - Arg: Id, Object Name  (If Id is null selects first record)
 *                    Ret: Object (of Object Name)
 * createSobject    - Arg: Id, Object Name , Record Type (All for all record Type)
 *                    Ret: Object (of Object Name with data in required fields)
*/
global with sharing class clsGlobalUtility { 

 static final Integer STRING_LENGTH=50;
 static final Set<String> PLT_PROFILE= new Set<String>{'PLT - Mission Profile','PLT - Read Only','PLT-User','MDA - Mission Data Admin','MRO - Mission Read Only','MRW - Mission Read/Write'};
 static final Set<String> STD_PROFILE= new Set<String>{'STD - AIDtracker Support','STD - AIDtracker Support - Read Only','STD - Edit Only - Custom','STD - Edit Only - Custom (Task)','STD - Mission Profile','STD - Read Only'};
 static final Set<String> PARTNER_PROFILE= new Set<String>{'Mission Partner'};
 static final Set<String> ADMIN_PROFILE= new Set<String>{'System Administrator(c)'};        
 
    global Map<String,String> getRecordTypeByObject(String objectType){
        Map<String,String> recTypesMap = new Map<String,String>();
        if (objectType == null){
            return null;
        }
        try{
               objectType=(objectType==null)?'Account':objectType;
               
               List<RecordType> recTypeList = [select Id, Name from RecordType where SobjectType=:objectType];
               for(RecordType rt: recTypeList){
                    recTypesMap.put(rt.Name, rt.Id);
               }
        } catch(Exception e) {
               //system.debug('Error occured in GU getRecordTypeId  -'+e.getStackTraceString());
               e.setMessage('Error occured while getting Record Type  -'+objectType+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
           }
           if (recTypesMap !=null)
               return recTypesMap;
           else 
               return null;
    }
    
    global Id getRecordTypeId(String objectType, String recordType )
    {
           RecordType recType;
           try{
               objectType=(objectType==null)?'Account':objectType;
               
               recType = [select Id from RecordType where Name=:recordType  AND SobjectType=:objectType];
               if (recType==null)
                   recType = [select Id from RecordType where Name=:recordType  AND SobjectType='Master'];
               }
           catch(Exception e) {
               //system.debug('Error occured in GU getRecordTypeId  -'+e.getStackTraceString());
               e.setMessage('Error occured while getting Record Type  -'+recordType+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
           }
           if (recType !=null)
               return recType.Id;
           else 
               return null;
   }
   global String getRecordType(String objectType, Id recordTypeId )
   {
           RecordType recType;
           
           try{
               objectType=(objectType==null)?'Account':objectType;
               
               recType = [select Id, Name from RecordType where Id=:recordTypeId  AND SobjectType=:objectType];
               if (recType==null)
                   recType = [select Id, Name from RecordType where Id=:recordTypeId  AND SobjectType='Master'];
           }
           catch(Exception e) {
               //system.debug('Error occured in GU getRecordType  -'+e.getStackTraceString());
               e.setMessage('Error occured while getting Record Type  -'+recordTypeId+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
           }
           if (recType!=null)
               return recType.Name;
           else 
               return null;
   }
 
   global String getUserRole()
   {
    
           UserRole userRole;
           String userRoldId=UserInfo.getUserRoleId();
          
           try{
               
              userRole=[Select Id, Name from UserRole where Id = :userRoldId];
              
           }
           catch(Exception e) {
                
                //system.debug('Error occured in GU getRecordType  -'+e.getStackTraceString());
                e.setMessage('Error occured while getting User Role  -'+userRoldId+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
               
           }
           if (userRole !=null)
               return  userRole.Name.split('\\|')[0].normalizeSpace();
           else 
               return null;
   }
   global String getWholeUserRole()
   {
    
           UserRole userRole;
           String userRoldId=UserInfo.getUserRoleId();
          
           try{
               
              userRole=[Select Id, Name from UserRole where Id = :userRoldId];
              
           }
           catch(Exception e) {
              //system.debug('Error occured in GU getRecordType  -'+e.getStackTraceString());
              e.setMessage('Error occured while getting User Role  -'+userRoldId+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
           }
           if (userRole !=null)
               return  userRole.Name;
           else 
               return null;
   }
   global String getProfile(){
        Profile profile;
           String userProfileId = UserInfo.getProfileId();
           try{
               
               profile = [Select Id, Name from Profile where id=:userProfileId Limit 1];
              
           }
           catch(Exception e) {
                //system.debug('Error occured in GU getProfile  -'+e.getStackTraceString());
                e.setMessage('Error occured while getting User Profile  -'+userProfileId+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
           }
           if (profile!=null)
               return profile.Name;
           else 
               return null; 
   }
   global Id getProfile (String profileName )
   {
           Profile profile;
           
           try{
               
               profile = [Select Id, Name from Profile where Name=:profileName Limit 1];
              
           }
           catch(Exception e) {
                //system.debug('Error occured in GU getProfile  -'+e.getStackTraceString());
                e.setMessage('Error occured while getting User Profile  -'+profileName+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
           }
           if (profile!=null)
               return profile.Id;
           else 
               return null;
   } 
   global String getObjectNameById(String recordId){
        try{            
            String keyCode  = (string)recordId.subString(0,3);
            String objectName;
            //system.debug(' Object Key Code ----------------->' + keyCode);        
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
            for(Schema.SObjectType objectInstance : gd.values()){
                if(keyCode.equals(objectInstance.getDescribe().getKeyPrefix())){
                    objectName = objectInstance.getDescribe().getName();
                }
            }
            return objectName;
            
        } catch(Exception e){
            //system.debug('Error occured in GU getObjectNameById  -'+e.getStackTraceString());
            e.setMessage('Error occured while getting Object Name  -'+recordId+'\\n'+'Error -'+e.getMessage()+' occured in class clsGlobalUtility at line number -'+e.getLineNumber() );    
        }
        return null;
    
   }
   global String getProfile (Id profileId )
   {
           Profile profile;
           
           try{
               
               profile = [Select Id, Name from Profile where Id=:profileId Limit 1];
              
           }
           catch(Exception e) {
                //system.debug('Error occured in GU getProfile  -'+e.getStackTraceString());
                e.setMessage('Error occured while getting User Profile  -'+profileId+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
 }
           if (profile!=null)
               return profile.Name;
           else 
               return null;
   }   
   global  SObject lookup(Id id, String objectType){
        
       Set <String> objFields=getSObjectFields(objectType);
     //  objFields.add('createdBy.UserName');
       String relatedUserFields = ',createdBy.firstName,createdBy.lastName,LastModifiedBy.FirstName,LastModifiedBy.LastName';   
       String objFieldCols= joinSet(objFields);
       String query='Select '+objFieldCols+relatedUserFields+' FROM '+objectType;
       if(id==null)
          query+= ' LIMIT 1';
       else
          query+= ' WHERE Id=\''+id+'\' LIMIT 1';
       try{
            return Database.query(query);
        } catch(QueryException e){
            //system.debug('Error occured in GU lookup  -'+e.getStackTraceString());
            e.setMessage('Error occured while selecting data from  -'+objectType+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
        }
        return null;
    }
    
   
    
    global  List<SObject> lookup(String id,String whereCol, String objectType){
        
       Set <String> objFields=getSObjectFields(objectType);
       String relatedUserFields = ',createdBy.firstName,createdBy.lastName,LastModifiedBy.FirstName,LastModifiedBy.LastName';
    //   objFields.add('createdBy.UserName');
       String objFieldCols= joinSet(objFields);
       String query='Select '+objFieldCols+relatedUserFields+' FROM '+objectType;
       if(id==null || id == '')
          query+= '';
       else
          query+= ' WHERE '+whereCol+'=\''+id+'\'';
       try{
            //system.debug('Reporting Periods Creation::' +query);
            return Database.query(query);
        } catch(QueryException e){
            //system.debug('Error occured in GU lookup  -'+e.getStackTraceString());
            e.setMessage('Error occured while selecting data from  -'+objectType+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
        }
        return null;
    }
    global  List<SObject> lookup(set<Id> ids,String whereCol, String objectType){
        
       Set <String> objFields=getSObjectFields(objectType);
       String relatedUserFields = ',createdBy.firstName,createdBy.lastName,LastModifiedBy.FirstName,LastModifiedBy.LastName';
    //   objFields.add('createdBy.UserName');
       String objFieldCols= joinSet(objFields);
       String query='Select '+objFieldCols+relatedUserFields+' FROM '+objectType;
       if(ids.isEmpty())
          query+= '';
       else
          query+= ' WHERE '+whereCol+' in '+prepareINclause(ids);
       try{
            system.debug('Reporting Periods Creation::' +query);
            return Database.query(query);
        } catch(QueryException e){
            //system.debug('Error occured in GU lookup  -'+e.getStackTraceString());
            e.setMessage('Error occured while selecting data from  -'+objectType+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
        }
        return null;
    }
        
    global  List<SObject> lookup(String id,String whereCol, String andStr, String objectType, String orderByStr){
        
       Set <String> objFields=getSObjectFields(objectType);
       String relatedUserFields = ',createdBy.firstName,createdBy.lastName,LastModifiedBy.FirstName,LastModifiedBy.LastName';
      // objFields.add('createdBy.UserName');
       String objFieldCols= joinSet(objFields);
       String query='Select '+objFieldCols+relatedUserFields+' FROM '+objectType;
       if(id==null || id == ''){
          query+= '';
       }else {
         if (andStr != null){
            query+= ' WHERE '+whereCol+'=\''+id+ '\'' +andStr;
         } else {
            query+= ' WHERE '+whereCol+'=\''+id+ '\'';
         }
       }
       if (orderByStr!=null){
         query+= ' Order By '+orderByStr;   
       }
       try{
            //system.debug('Reporting Periods Creation::' +query);
            return Database.query(query);
        } catch(QueryException e){
            //system.debug('Error occured in GU lookup  -'+e.getStackTraceString());
            e.setMessage('Error occured while selecting data from  -'+objectType+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
        }
        return null;
    }
    
    global  List<SObject> lookupWithFilter(String filterStr, String objectType){
        
       Set <String> objFields=getSObjectFields(objectType);
       String relatedUserFields = ',createdBy.firstName,createdBy.lastName,LastModifiedBy.FirstName,LastModifiedBy.LastName';
       String objFieldCols= joinSet(objFields);       
       String query='Select '+objFieldCols+relatedUserFields+' FROM '+objectType;
       if (filterStr != null){
        query+= filterStr;  
       }
       try{
            system.debug('Reporting Periods Creation::' +query);
            return Database.query(query);
        } catch(QueryException e){
            //system.debug('Error occured in GU lookup  -'+e.getStackTraceString());
            e.setMessage('Error occured while selecting data from  -'+objectType+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
        }
        return null;
    }
    
    global static Map<String,Schema.Sobjectfield> getSObjectFields(Schema.SObjectType sObjectType) {
        String sObjectTypeAsString = String.valueOf(sObjectType);
        try{
            Map<String, Map<String,Schema.Sobjectfield>> sObjectFieldCache =new Map<String, Map<String,Schema.Sobjectfield>>();
            // If it's not already in the cache, add the sObject's field map to the cache
            if (!sObjectFieldCache.containsKey(sObjectTypeAsString)) {
               sObjectFieldCache.put(sObjectTypeAsString, sObjectType.getDescribe().fields.getMap());
            }
            return sObjectFieldCache.get(sObjectTypeAsString);
        } catch(Exception e){
            //system.debug('Error occured in GU getSObjectFields  -'+e.getStackTraceString());
            e.setMessage('Error occured while getting fields for -'+sObjectType+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
        }
        return null;
    }
        //Return columns for given Object Type
    global static Set<String> getSObjectFields(String sObjectType) {
        try{
            Map<String,Schema.SObjectField> field_o=Schema.getGlobalDescribe().get(sObjectType).getDescribe().fields.getMap();          
            return  field_o.keySet();
        } catch(Exception e){
            //system.debug('Error occured in GU getSObjectFields  -'+e.getStackTraceString());
            e.setMessage('Error occured while getting fields for -'+sObjectType+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
        }
        return null;
    }
    global String joinSet(Set<String> values) {
        List<String> valueCopy = new List<String>(values);
        if(valueCopy.isEmpty())
            return null;
        String result = valueCopy[0];
         valueCopy.remove(0);
        while(!valueCopy.isEmpty()) {
            result += ',' + valueCopy[0];
            valueCopy.remove(0);
        }
        return result;
   }
   
   global String createBreadCrumps(String recId){
        if (recId == null) return null;
        String bCrumpsRightToLeft = buildBreadCrumps(recId);        
        String result;
        //system.debug('Right to Left bcrums :::::'+bCrumpsRightToLeft);
        List<String> crumpsList = bCrumpsRightToLeft.split('->>>-');
        system.debug('Right to Left bcrums :::::'+crumpsList.size());
        system.debug('Right to Left bcrums :::::'+crumpsList);
        Integer i=crumpsList.size()-1;
        system.debug('I Val :::::'+i);
        while (i>=2){        
            if (i==2){
                if(result == null){
                    result = crumpsList.get(i).replaceAll('&#124;',' | ');
                } else {
                    result += crumpsList.get(i).replaceAll('&#124;',' | ');
                }
                system.debug('without >'+crumpsList.get(i)+'& I &'+i);
            } else if (i == crumpsList.size()-1) {                  
                result = crumpsList.get(i).replaceAll('&#124;',' | ') + ' > ' ;
                system.debug('with > & result'+crumpsList.get(i)+'& I &'+i); 
            } else {
                result += crumpsList.get(i).replaceAll('&#124;',' | ') + ' > ' ;
                system.debug('with > & result+'+crumpsList.get(i)+'& I &'+i); 
            }
            i--;             
            
        }
        system.debug('Right to Left bcrums :::::'+result);
        return result;
   }
   
   private String buildBreadCrumps(String recId){
        String profileName = getProfile((Id)Userinfo.getProfileId());
        String result = '->>>-';
        String bTitle;
        String bTitleTruc;
        String hrefPage;
        String hrefPage1;
        String objName = getObjectNameById(recId);
        if (objName=='Reporting_Period__c'){
            Reporting_Period__c rPeriod = (Reporting_Period__c) lookup(recId, 'Reporting_Period__c');
           // bTitle = 'Reporting Period | ' +rPeriod.Name  ;
            bTitle = rPeriod.Name  ;
            bTitleTruc = bTitle.length() > STRING_LENGTH ? bTitle.left(STRING_LENGTH)+'...' :bTitle;
            
            if (profileName == 'Mission Partner'){  
            hrefPage = '/Partners/'+rPeriod.Id ;
            } else{
            hrefPage = '/'+rPeriod.Id ;
            }
            result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>';
            
            if (getRecordType('Reporting_Period__c',rPeriod.RecordTypeId).equalsIgnoreCase('Activity')){
                result = result + buildBreadCrumps(rPeriod.Activity_Id__c);
            } else if(getRecordType('Reporting_Period__c',rPeriod.RecordTypeId).equalsIgnoreCase('Implementing Mechanism')){
                result = result + buildBreadCrumps(rPeriod.Implementing_Mechanism_Id__c);
            }           
            
        } else if(objName=='LF_Reporting_Period__c'){
            LF_Reporting_Period__c lrPeriod = (LF_Reporting_Period__c) lookup(recId, 'LF_Reporting_Period__c');
            //bTitle = 'LF Reporting Period | ' +lrPeriod.Name  ;
            bTitle = lrPeriod.Name  ;
            bTitleTruc = bTitle.length() > STRING_LENGTH ? bTitle.left(STRING_LENGTH)+'...' :bTitle;
             
            hrefPage = '/'+lrPeriod.Id ;
            result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>';
            
            if (getRecordType('LF_Reporting_Period__c',lrPeriod.RecordTypeId).equalsIgnoreCase('LF Goal')){
                result = result + buildBreadCrumps(lrPeriod.LF_Goal_Id__c);
            } else if(getRecordType('LF_Reporting_Period__c',lrPeriod.RecordTypeId).equalsIgnoreCase('LF Purpose')){
                result = result + buildBreadCrumps(lrPeriod.LF_Purpose_Id__c);
            } else if(getRecordType('LF_Reporting_Period__c',lrPeriod.RecordTypeId).equalsIgnoreCase('LF Sub-Purpose')){
                result = result + buildBreadCrumps(lrPeriod.LF_SubPurpose_Id__c);
            } else if(getRecordType('LF_Reporting_Period__c',lrPeriod.RecordTypeId).equalsIgnoreCase('LF Output')){
                result = result + buildBreadCrumps(lrPeriod.LF_Output_Id__c);
            } else if(getRecordType('LF_Reporting_Period__c',lrPeriod.RecordTypeId).equalsIgnoreCase('LF Input')){
                result = result + buildBreadCrumps(lrPeriod.LF_Input_Id__c);
            }
        } else if(objName=='RF_Reporting_Period__c'){
            RF_Reporting_Period__c rrPeriod = (RF_Reporting_Period__c) lookup(recId, 'RF_Reporting_Period__c');
            //bTitle = 'RF Reporting Period | ' +rrPeriod.Name  ;
            bTitle = rrPeriod.Name  ;
            bTitleTruc = bTitle.length() > STRING_LENGTH ? bTitle.left(STRING_LENGTH)+'...' :bTitle;
             
            hrefPage = '/'+rrPeriod.Id ;
            result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>';
            
            if(getRecordType('RF_Reporting_Period__c',rrPeriod.RecordTypeId).equalsIgnoreCase('RF Goal')){
                result = buildBreadCrumps(rrPeriod.Goal_Id__c);
            } else if(getRecordType('RF_Reporting_Period__c',rrPeriod.RecordTypeId).equalsIgnoreCase('RF DO')){
                result = result + buildBreadCrumps(rrPeriod.DO_Id__c);
            } else if(getRecordType('RF_Reporting_Period__c',rrPeriod.RecordTypeId).equalsIgnoreCase('RF IR')){
                result = result + buildBreadCrumps(rrPeriod.IR_Id__c);
            } else if(getRecordType('RF_Reporting_Period__c',rrPeriod.RecordTypeId).equalsIgnoreCase('RF SUB IR')){
                result = result + buildBreadCrumps(rrPeriod.SIR_Id__c);
            }  
        }
        if (objName == 'CDCSGoal__c'){
            CDCSGoal__c goalRec = (CDCSGoal__c) lookup(recId, 'CDCSGoal__c');
            //result += goalRec.Name;
            bTitle = 'Goal |' +goalRec.Name  ;
            bTitleTruc = bTitle.length() > STRING_LENGTH ? bTitle.left(STRING_LENGTH)+'...' :bTitle;
            hrefPage = '/'+goalRec.Id ;
            hrefPage1 = '/apex/vfResultsFrameworkOverview?id='+goalRec.Id ;
            String sfdcURL = URL.getCurrentRequestUrl().toExternalForm();
            System.debug('Base URL: ' + sfdcURL );
            if(sfdcURL.contains('vfRFGoalDetail')){
                result += '->>>-<a href=\"'+hrefPage1+'\" title= RF Overview"> RF Overview </a>->>>-' ;
            } else {
                result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>->>>-';
                result += '<a href=\"'+hrefPage1+'\" title= RF Overview"> RF Overview </a>' ;
                System.debug('Result: ' + result );
            }
            //result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>' +buildBreadCrumps(goalRec.ouId__c);
        }
        if (objName == 'DO__c'){
            DO__c doRec = (DO__c) lookup(recId, 'DO__c');
            //result += doRec.Name;
            bTitle = doRec.DO_Name__c  ;
            bTitleTruc = bTitle.length() > STRING_LENGTH ? bTitle.left(STRING_LENGTH)+'...' :bTitle;
            hrefPage = '/'+doRec.Id ;
            result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>' +  buildBreadCrumps(doRec.CDCS_Goal__c);             
        }
        if (objName == 'IR__c'){
            IR__c irRec = (IR__c) lookup(recId, 'IR__c');
            //result += irRec.Name;
            //result = result + buildBreadCrumps(irRec.DO_Id__c);
            bTitle = irRec.IR_Name__c  ;
            bTitleTruc = bTitle.length() > STRING_LENGTH ? bTitle.left(STRING_LENGTH)+'...' :bTitle;
            hrefPage = '/'+irRec.Id ;
            result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>' +  buildBreadCrumps(irRec.DO_Id__c);
            
        }
        if (objName == 'Sub_IR__c'){
            Sub_IR__c sirRec = (Sub_IR__c) lookup(recId, 'Sub_IR__c');
            //result += sirRec.Name;
            //result = result + buildBreadCrumps(sirRec.IR_Id__c);
            bTitle = sirRec.SIR_Name__c  ;
            bTitleTruc = bTitle.length() > STRING_LENGTH ? bTitle.left(STRING_LENGTH)+'...' :bTitle;
            hrefPage = '/'+sirRec.Id ;
            result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>' + buildBreadCrumps(sirRec.IR_Id__c);
            
        }
        if (objName == 'LF_Goal__c'){
            LF_Goal__c lfGoalRec = (LF_Goal__c) lookup(recId, 'LF_Goal__c');
            //result += projRec.Name;
            //result = result + buildBreadCrumps(projRec.ouId__c);
            
            bTitle = 'Goal | '+lfGoalRec.LF_Goal_Name__c  ;
            bTitleTruc = bTitle.length() > STRING_LENGTH ? bTitle.left(STRING_LENGTH)+'...' :bTitle;
            //bTitleTruc =  bTitle;
            hrefPage = '/'+lfGoalRec.Id ;
            result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>' + buildBreadCrumps(lfGoalRec.Project_id__c);
            System.debug('Result Goal: ' + result );
        }
        if (objName == 'Project__c'){
            Project__c projRec = (Project__c) lookup(recId, 'Project__c');
            bTitle = 'Project | '+projRec.Public_Name__c ;
            bTitleTruc = bTitle.length() > STRING_LENGTH ? bTitle.left(STRING_LENGTH)+'...' :bTitle;
            hrefPage = '/apex/vfProjectFactSheet?id='+projRec.Id ;
            hrefPage1 = '/apex/vfLogFrameOverview?id='+projRec.Id ;
            String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm();
            //String sfdcURL = URL.getCurrentRequestUrl().toExternalForm();
            System.debug('Base URL: ' + sfdcURL ); 
            System.debug('Result: ' + result );
            system.debug('Test1::'+result.contains('vfProjectFactSheet'));
            if(sfdcURL.contains('vfLogFrameOverview') && !result.contains('vfProjectFactSheet')){
                result += '->>>-<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>->>>-';
                System.debug('Result Project: ' + result ); 
            } else if (!result.contains('vfLogFrameOverview')){
                result += '<a href=\"'+hrefPage1+'\" title= LF Goal"> LF Overview </a>->>>-' ;
                result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>';
                System.debug('Result Project: ' + result );
            } 
        }
        
        if (objName == 'LF_Purpose__c'){
            LF_Purpose__c lfpRec = (LF_Purpose__c) lookup(recId, 'LF_Purpose__c');
            //result += lfpRec.Name;
            //result = result + buildBreadCrumps(lfpRec.Project_Id__c);
            String sfdcURL = URL.getCurrentRequestUrl().toExternalForm();
            bTitle = 'Purpose | '+lfpRec.LF_Purpose_Name__c  ;
            bTitleTruc = bTitle.length() > STRING_LENGTH ? bTitle.left(STRING_LENGTH)+'...' :bTitle;
            hrefPage = '/'+lfpRec.Id ;
            //result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>' + buildBreadCrumps(lfpRec.LF_Goal_Id__c);
            if(sfdcURL.contains('vfProjectIRSIRLink')){
                result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>->>>-'+'<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>' + buildBreadCrumps(lfpRec.LF_Goal_Id__c) ;
            } else {
                result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>' + buildBreadCrumps(lfpRec.LF_Goal_Id__c);
            }
            System.debug('Result Purpose: ' + result );
        }
        if (objName == 'LF_SubPurpose__c'){
            LF_SubPurpose__c lfspRec = (LF_SubPurpose__c) lookup(recId, 'LF_SubPurpose__c');
            bTitle = 'Sub-Purpose | '+lfspRec.LF_SubPurpose_Name__c  ;
            bTitleTruc = bTitle.length() > STRING_LENGTH ? bTitle.left(STRING_LENGTH)+'...' :bTitle;
            hrefPage = '/'+lfspRec.Id ;
            result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>' + buildBreadCrumps(lfspRec.LF_Purpose_Id__c);
            System.debug('Result Sub-Purpose: ' + result );
        }
        if (objName == 'LF_Output__c'){
            LF_Output__c lfoptRec = (LF_Output__c) lookup(recId, 'LF_Output__c');
            bTitle = 'Output | '+lfoptRec.LF_Output_Name__c  ;
            bTitleTruc = bTitle.length() > STRING_LENGTH ? bTitle.left(STRING_LENGTH)+'...' :bTitle;
            hrefPage = '/'+lfoptRec.Id ;
            if (lfoptRec.LF_SubPurpose_Id__c == null){
                result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>' + buildBreadCrumps(lfoptRec.LF_Purpose_Id__c);
            } else {
                result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>' + buildBreadCrumps(lfoptRec.LF_SubPurpose_Id__c);
            }
        }
        if (objName == 'LF_Input__c'){
            LF_Input__c lfInputRec = (LF_Input__c) lookup(recId, 'LF_Input__c');
            bTitle = 'Input | '+lfInputRec.LF_Input_Name__c  ;
            bTitleTruc = bTitle.length() > STRING_LENGTH ? bTitle.left(STRING_LENGTH)+'...' :bTitle;
            hrefPage = '/'+lfInputRec.Id ;
            result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>' + buildBreadCrumps(lfInputRec.LF_Output_Id__c);
            System.debug('Result Input: ' + result );
        }
        if (objName == 'Implementing_Mechanism__c'){
            Implementing_Mechanism__c imRec = (Implementing_Mechanism__c) lookup(recId, 'Implementing_Mechanism__c');
            String sfdcURL = URL.getCurrentRequestUrl().toExternalForm(); 
            bTitle = 'IM | '+imRec.Implementing_Mechanism_Name__c;
            bTitleTruc = bTitle.length() > STRING_LENGTH ? bTitle.left(STRING_LENGTH)+'...' :bTitle;
            if (profileName == 'Mission Partner'){  
            hrefPage = '/Partners/apex/vfIMBasicDetailFactSheet?Id='+imRec.Id ;
            }else {
            hrefPage = '/apex/vfIMBasicDetailFactSheet?Id='+imRec.Id ;
            }
            if(sfdcURL.contains('vfActivityDetail') || sfdcURL.contains('vfLocationDetail')){
                result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>';
            } else {
                result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>->>>-'+'<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>';
            }
        }
        if (objName == 'Activity__c'){
            Activity__c taskRec = (Activity__c) lookup(recId, 'Activity__c');
            bTitle = 'Task | '+taskRec.Activity_Name__c;
            bTitleTruc = bTitle.length() > STRING_LENGTH ? bTitle.left(STRING_LENGTH)+'...' :bTitle;
            hrefPage = '/apex/vfActivityDetail?Id='+taskRec.Id ;
            result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>' + buildBreadCrumps(taskRec.ImpMech_Id__c);
        }
        
        if (objName == 'orgUnitSector__c'){
            orgUnitSector__c secRec = (orgUnitSector__c) lookup(recId, 'orgUnitSector__c');
            bTitle = 'Sector | '+secRec.secName__c;
            bTitleTruc = bTitle.length() > STRING_LENGTH ? bTitle.left(STRING_LENGTH)+'...' :bTitle;
            hrefPage = '/apex/vfSectorDetail?Id='+secRec.Id ;
            result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>' + buildBreadCrumps(secRec.ouId__c);
        }
        
        if (objName == 'Office__c'){
            Office__c offRec = (Office__c) lookup(recId, 'Office__c');
            bTitle = 'Sector | '+offRec.offName__c;
            bTitleTruc = bTitle.length() > STRING_LENGTH ? bTitle.left(STRING_LENGTH)+'...' :bTitle;
            hrefPage = '/apex/vfOfficeDetail?Id='+offRec.Id ;
            result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>' + buildBreadCrumps(offRec.ouId__c);
        }
        
        if (objName == 'orgUnitGeography__c'){
            orgUnitGeography__c geoRec = (orgUnitGeography__c) lookup(recId, 'orgUnitGeography__c');
            bTitle = 'Organization Geography | '+geoRec.cntryName__c;
            bTitleTruc = bTitle.length() > STRING_LENGTH ? bTitle.left(STRING_LENGTH)+'...' :bTitle;
            hrefPage = '/apex/vfGeographyDetail?Id='+geoRec.Id ;
            result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>' + buildBreadCrumps(geoRec.orgUnitId__c);
        }
        
        if (objName == 'Sub_Awardee__c'){
            Sub_Awardee__c subawRec = (Sub_Awardee__c) lookup(recId, 'Sub_Awardee__c');
            bTitle = 'Organization Geography | '+subawRec.SubAwardee_Name__c;
            bTitleTruc = bTitle.length() > STRING_LENGTH ? bTitle.left(STRING_LENGTH)+'...' :bTitle;
            hrefPage = '/apex/vfSubAwardeeDetail?Id='+subawRec.Id ;
            result = buildBreadCrumps(subawRec.ImpMech_Id__c);
        }
        
        
        if (objName == 'Project_Location__c'){
            Project_Location__c prjLocRec = (Project_Location__c) lookup(recId, 'Project_Location__c');
            bTitle = 'Location | '+prjLocRec.Name;
            bTitleTruc = bTitle.length() > STRING_LENGTH ? bTitle.left(STRING_LENGTH)+'...' :bTitle;
            hrefPage = '/apex/vfLocationDetail?Id='+prjLocRec.Id ;
            result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>' + buildBreadCrumps(prjLocRec.ActivityId__c);
            //result = buildBreadCrumps(subawRec.ImpMech_Id__c);
        }
        
        if (objName == 'OrgUnit__c'){
            OrgUnit__c orgRec = (OrgUnit__c) lookup(recId, 'OrgUnit__c');
            //result += orgRec.Name;
            String sfdcURL = URL.getCurrentRequestUrl().toExternalForm(); 
            bTitle = orgRec.ouName__c;
            bTitleTruc = bTitle.length() > STRING_LENGTH ? bTitle.left(STRING_LENGTH)+'...' :bTitle;
            hrefPage = '/'+orgRec.Id ;
            if(sfdcURL.contains('vfOrgUnitIndListPage') || sfdcURL.contains('vfManageOrganizationIndicators')){
                result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>->>>-'+'<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>';
            } else {
                result += '<a href=\"'+hrefPage+'\" title=\"'+bTitle+'\">' +bTitleTruc +'</a>';
            }
            //result += bTitleTruc;
        }
        
        return result;
   }
   
   global Map<String, CDCSLink__c> getCDCSLinkForRFElement(Set<String> recIds,String objName){
        String inVlaues = '( ';
        if (recIds.isEmpty()){
            return null;
        } else {
            Integer i =0;
            for(String s: recIds){
                if (i < recIds.size()-1){
                    inVlaues +=  '\'' + s + '\',';
                } else {
                    inVlaues +=  '\'' + s + '\')';
                }   
                i ++;
            }
        }
        Map<String,CDCSLINK__c> cLinkMap = new Map<String,CDCSLINK__c>();
        List<SObject> cLinkList = new List<SObject>();
        //String objName = getObjectNameById(recId);
        String andStr;
        String whereStr;
        
        if (objName == 'CDCSGoal__c'){
            whereStr = ' Where CDCSGoal_Id__c IN ' +inVlaues ;
            andStr = ' AND Link_Type__c = \'Primary\'';
            cLinkList = lookupWithFilter(whereStr+andStr,'CDCSLink__c');
            
            for(Sobject sobj: cLinkList){
                CDCSLINK__c  cLink = (CDCSLINK__c) sobj; 
                cLinkMap.put(cLink.CDCSGoal_Id__c,cLink);
            }
        } else if (objName == 'DO__c'){
            whereStr = ' Where DO_Id__c IN ' +inVlaues ;
            andStr = ' AND Link_Type__c = \'Primary Goal\'';
            cLinkList = lookupWithFilter(whereStr+andStr,'CDCSLink__c');
            for(Sobject sobj: cLinkList){
                CDCSLINK__c  cLink = (CDCSLINK__c) sobj; 
                cLinkMap.put(cLink.DO_Id__c,cLink);
            }
        } else if (objName == 'IR__c'){
            whereStr = ' Where IR_Id__c IN ' +inVlaues ;
            andStr = ' AND Link_Type__c = \'Primary DO\'';
            cLinkList = lookupWithFilter(whereStr+andStr,'CDCSLink__c');
            for(Sobject sobj: cLinkList){
                CDCSLINK__c  cLink = (CDCSLINK__c) sobj; 
                cLinkMap.put(cLink.IR_Id__c,cLink);
            }
        } else if (objName == 'Sub_IR__c'){
            whereStr = ' Where SIR_Id__c IN ' +inVlaues ;
            andStr = 'AND Link_Type__c = \'Primary IR\'';
            cLinkList = lookupWithFilter(whereStr+andStr,'CDCSLink__c');
            for(Sobject sobj: cLinkList){
                CDCSLINK__c  cLink = (CDCSLINK__c) sobj; 
                cLinkMap.put(cLink.SIR_Id__c,cLink);
            }
        } else {
            return null;
        }
        
        
        return cLinkMap;
   }
   
   global Map<String,LogFrame_Tree__c> getLogFrameLinkForLFElement(Set<String> recIds,String objName){
        String inVlaues = '( ';
        if (recIds.isEmpty()){
            return null;
        } else {
            Integer i =0;
            for(String s: recIds){
                if (i < recIds.size()-1){
                    inVlaues +=  '\'' + s + '\',';
                } else {
                    inVlaues +=  '\'' + s + '\')';
                }   
                i ++;
            }
        }
        
        
        Map<String,LogFrame_Tree__c> cLinkMap = new Map<String,LogFrame_Tree__c>();
        List<SObject> cLinkList = new List<SObject>();
        //String objName = getObjectNameById(recId);
        String andStr;
        String whereStr;
        
        if (objName == 'LF_Goal__c'){
            whereStr = ' Where LF_Goal_Id__c IN ' +inVlaues ;
            andStr = ' AND Link_Type__c = \'Primary\'';
            cLinkList = lookupWithFilter(whereStr+andStr,'LogFrame_Tree__c');
            
            for(Sobject sobj: cLinkList){
                LogFrame_Tree__c  cLink = (LogFrame_Tree__c) sobj; 
                cLinkMap.put(cLink.LF_Goal_Id__c,cLink);
            }           
            
        } else if (objName == 'LF_Purpose__c'){
            whereStr = ' Where LF_Purpose_Id__c IN ' +inVlaues ;
            andStr = ' AND Link_Type__c = \'Primary Goal\'';
            cLinkList = lookupWithFilter(whereStr+andStr,'LogFrame_Tree__c');
            
            for(Sobject sobj: cLinkList){
                LogFrame_Tree__c  cLink = (LogFrame_Tree__c) sobj; 
                cLinkMap.put(cLink.LF_Purpose_Id__c,cLink);
            }
        } else if (objName == 'LF_SubPurpose__c'){
            whereStr = ' Where LF_SubPurpose_Id__c IN ' +inVlaues ;
            andStr = ' AND Link_Type__c = \'Primary Purpose\'';
            cLinkList = lookupWithFilter(whereStr+andStr,'LogFrame_Tree__c');
            
            for(Sobject sobj: cLinkList){
                LogFrame_Tree__c  cLink = (LogFrame_Tree__c) sobj; 
                cLinkMap.put(cLink.LF_SubPurpose_Id__c,cLink);
            }           
        } else if (objName == 'LF_Output__c'){
            whereStr = ' Where LF_Output_Id__c IN ' +inVlaues ;
            andStr = ' AND Link_Type__c IN (\'Primary Sub-Purpose\' , \'Primary Purpose Output\' )';
            cLinkList = lookupWithFilter(whereStr+andStr,'LogFrame_Tree__c');
            
            for(Sobject sobj: cLinkList){
                LogFrame_Tree__c  cLink = (LogFrame_Tree__c) sobj; 
                cLinkMap.put(cLink.LF_Output_Id__c,cLink);
            }
        } else if (objName == 'LF_Input__c'){
            whereStr = ' Where LF_Input_Id__c IN ' +inVlaues ;
            andStr = ' AND Link_Type__c = \'Primary Output\'';
            cLinkList = lookupWithFilter(whereStr+andStr,'LogFrame_Tree__c');
            
            for(Sobject sobj: cLinkList){
                LogFrame_Tree__c  cLink = (LogFrame_Tree__c) sobj; 
                cLinkMap.put(cLink.LF_Input_Id__c,cLink);
            }
        } else {
            return null;
        }
        
        return cLinkMap;
   } 
   
   global Map<Id,List<User>> getIMTaskApproverRecs(Set<Id> recIds){
        if (recIds.isEmpty() == null) return null;
        String whereStr = ' Where Id IN ' + prepareINclause(recIDs);        
        List<String> approverUserIds = new List<String>();
        List<SObject> sObjList = lookupWithFilter(whereStr,'Implementing_Mechanism__c');
        Map<ID,List<User>> imUsersMap = new Map<ID,List<User>>();
        //Set<Id> allUserIds = new Set<Id>();
        List<String> allUserIds = new List<String>();
        for(SObject sObj:sObjList){
           // List<String> tempList = new List<String>();
            Implementing_Mechanism__c im = (Implementing_Mechanism__c) sObj;
            if (im.AOR__c != null){
                allUserIds.add(im.AOR__c);                 
            }            
            if (im.COR__c != null){
                allUserIds.add(im.COR__c);                 
            }
            
            if (im.Alternate_AOR__c != null){
                allUserIds.add(im.Alternate_AOR__c);                   
            }
            
            if (im.Alternate_COR__c != null){
                allUserIds.add(im.Alternate_COR__c);                   
            }
            //imUsersMap.put(im.Id,tempList); 
        } 
        System.debug('All User Ids::' +allUserIds);
       // Map<Id,User> userMap = new Map<Id,User>([Select Id, Name, Email From User where ID IN :allUserIds]);        
        Map<Id,User> userMap = new Map<Id,User>();
        List<User> userList = new List<User>([Select Id, Name, Email From User where ID IN :allUserIds]);
        for(User u: userList){
            userMap.put(u.Id,u);
        }
       // String userQuery = 'Select Id, Name, Email From User where ID IN '+prepareINclause(allUserIds);
       //  System.debug('User Query String::' +userQuery);
      //  for(User u: Database.query(userQuery)){
      //      userMap.put(u.Id,u);
      //  }
        System.debug('Users Map::' +userMap);
        for(SObject sObj:sObjList){
            List<User> tempList = new List<USer>();
            Implementing_Mechanism__c im = (Implementing_Mechanism__c) sObj;
            if (im.AOR__c != null){
                tempList.add(userMap.get(im.AOR__c));                 
            }            
            if (im.COR__c != null){
                tempList.add(userMap.get(im.COR__c));                 
            }
            
            if (im.Alternate_AOR__c != null){
                tempList.add(userMap.get(im.Alternate_AOR__c));                   
            }
            
            if (im.Alternate_COR__c != null){
                tempList.add(userMap.get(im.Alternate_COR__c));                   
            }
            System.debug('Temp List of Users::' +tempList);
            imUsersMap.put(im.Id,tempList); 
        }
        
        System.debug('IM User Map Before Return::' +imUsersMap);      
        return imUsersMap;  
   }
  /* global Map<ID,List<Id>> getIMTaskApprovers(Set<Id> recIds){
        if (recIds.isEmpty() == null) return null;
        String inVlaues = '( ';
        if (recIds.isEmpty()){
            return null;
        } else {
            Integer i =0;
            for(String s: recIds){
                if (i < recIds.size()-1){
                    inVlaues +=  '\'' + s + '\',';
                } else {
                    inVlaues +=  '\'' + s + '\')';
                }   
                i ++;
            }
        }
        String whereStr = ' Where Id IN ' +inVlaues ;
        //String andStr = ' AND Link_Type__c = \'Primary\'';
        List<String> approverUserIds = new List<String>();
        List<SObject> sObjList = lookupWithFilter(whereStr,'Implementing_Mechanism__c');
        Map<ID,List<Id>> imUsersMap = new Map<ID,List<Id>>();
        for(SObject sObj:sObjList){
            List<String> tempList = new List<String>();
            Implementing_Mechanism__c im = (Implementing_Mechanism__c) sObj;
            if (im.AOR__c != null){
                tempList.add(im.AOR__c);                 
            }            
            if (im.COR__c != null){
                tempList.add(im.COR__c);                 
            }
            
            if (im.Alternate_AOR__c != null){
                tempList.add(im.Alternate_AOR__c);                   
            }
            
            if (im.Alternate_COR__c != null){
                tempList.add(im.Alternate_COR__c);                   
            }
            imUsersMap.put(im.Id,tempList); 
        }       
        return imUsersMap;  
   } */
   
   global Map<ID,List<User>> getIMPartnerUserRecs(Set<Id> recIds){
        if (recIds.isEmpty() == null) return null;
        String whereStr = ' Where Id IN ' +prepareINclause(recIDs);        
        List<String> approverUserIds = new List<String>();
        List<SObject> sObjList = lookupWithFilter(whereStr,'Implementing_Mechanism__c');
        Map<ID,List<User>> imUsersMap = new Map<ID,List<User>>();
        Set<Id> allUserIds = new Set<Id>();
        
        for(SObject sObj:sObjList){            
            Implementing_Mechanism__c im = (Implementing_Mechanism__c) sObj;
            if (im.Partner_User_1__c != null){
                allUserIds.add(im.Partner_User_1__c);
                                                
            }
             if (im.Partner_User_2__c != null){
                allUserIds.add(im.Partner_User_2__c);                 
            }
             if (im.Partner_User_3__c != null){
                allUserIds.add(im.Partner_User_3__c);                 
            }
             if (im.Partner_User_4__c != null){
                allUserIds.add(im.Partner_User_4__c);                 
            }
            //allUserIds.addAll(tempList);
           // imUsersMap.put(im.Id,tempList); 
        } 
        
        Map<Id,User> userMap = new Map<Id,User>([Select Id, Name, Email From User where ID in: allUserIds]);
        
        for(SObject sObj:sObjList){
            List<User> tempList = new List<User>();
            Implementing_Mechanism__c im = (Implementing_Mechanism__c) sObj;
            if (im.Partner_User_1__c != null){
                tempList.add(userMap.get(im.Partner_User_1__c));                                
            }
             if (im.Partner_User_2__c != null){
                tempList.add(userMap.get(im.Partner_User_2__c));                 
            }
             if (im.Partner_User_3__c != null){
                tempList.add(userMap.get(im.Partner_User_3__c));                 
            }
             if (im.Partner_User_4__c != null){
                tempList.add(userMap.get(im.Partner_User_4__c));                 
            }
            imUsersMap.put(im.Id,tempList);
        }
         
        return imUsersMap;
        
   }
   
  /* global Map<ID,List<Id>> getIMPartnerUsers(Set<Id> recIds){
        if (recIds.isEmpty() == null) return null;
        String inVlaues = '( ';
        if (recIds.isEmpty()){
            return null;
        } else {
            Integer i =0;
            for(String s: recIds){
                if (i < recIds.size()-1){
                    inVlaues +=  '\'' + s + '\',';
                } else {
                    inVlaues +=  '\'' + s + '\')';
                }   
                i ++;
            }
        }
        String whereStr = ' Where Id IN ' +inVlaues ;
        //String andStr = ' AND Link_Type__c = \'Primary\'';
        List<String> approverUserIds = new List<String>();
        List<SObject> sObjList = lookupWithFilter(whereStr,'Implementing_Mechanism__c');
        Map<ID,List<Id>> imUsersMap = new Map<ID,List<Id>>();
        for(SObject sObj:sObjList){
            List<String> tempList = new List<String>();
            Implementing_Mechanism__c im = (Implementing_Mechanism__c) sObj;
            if (im.Partner_User_1__c != null){
                tempList.add(im.Partner_User_1__c);                 
            }
             if (im.Partner_User_2__c != null){
                tempList.add(im.Partner_User_2__c);                 
            }
             if (im.Partner_User_3__c != null){
                tempList.add(im.Partner_User_3__c);                 
            }
             if (im.Partner_User_4__c != null){
                tempList.add(im.Partner_User_4__c);                 
            }
            imUsersMap.put(im.Id,tempList); 
        }       
        return imUsersMap;  
   }  */
   
   
  /* global Map<Id,String> getUserEmailAddress(Set<Id> recIds){
        if (recIds.isEmpty() == null) return null;
        String inVlaues = '( ';
        if (recIds.isEmpty()){
            return null;
        } else {
            Integer i =0;
            for(String s: recIds){
                if (i < recIds.size()-1){
                    inVlaues +=  '\'' + s + '\',';
                } else {
                    inVlaues +=  '\'' + s + '\')';
                }   
                i ++;
            }
        }
        String whereStr = ' Where Id IN ' +inVlaues ;
        Map<Id,String> userEmailMap = new Map<Id,String>();
        List<SObject> sObjList = lookupWithFilter(whereStr,'User');
        for(SObject sObj:sObjList){
            User u = (User) sObj;
            userEmailMap.put(u.Id,u.Email);             
        }           
        return userEmailMap;
   } */
   
   
  /* global List<String> getIMTaskApprovers(String recId){
        if (recID == null) return null;         
        List<String> approverUserIds = new List<String>();
        
        String objName = getObjectNameById(recId);
        if (objName.equalsIgnoreCase('Implementing_Mechanism__c')){
            Implementing_Mechanism__c im = (Implementing_Mechanism__c) lookup(recId,'Implementing_Mechanism__c');
            if (im.AOR__c != null){
                approverUserIds.add(im.AOR__c);                 
            }
            
            if (im.COR__c != null){
                approverUserIds.add(im.COR__c);                 
            }
            
            if (im.Alternate_AOR__c != null){
                approverUserIds.add(im.Alternate_AOR__c);                   
            }
            
            if (im.Alternate_COR__c != null){
                approverUserIds.add(im.Alternate_COR__c);                   
            }
        } else {
            return null;
        }           
        
        return approverUserIds;
   }   */
   
   
    
   //Get IM Partner Users
  /*  global List<String> getIMPartnerUsers(String recId){
        if (recID == null) return null;         
        List<String> PartnerUserIds = new List<String>();
        
        String objName = getObjectNameById(recId);
        if (objName.equalsIgnoreCase('Implementing_Mechanism__c')){
            Implementing_Mechanism__c im = (Implementing_Mechanism__c) lookup(recId,'Implementing_Mechanism__c');
            if (im.Partner_User_1__c != null){
                PartnerUserIds.add(im.Partner_User_1__c);                 
            }
             if (im.Partner_User_2__c != null){
                PartnerUserIds.add(im.Partner_User_2__c);                 
            }
             if (im.Partner_User_3__c != null){
                PartnerUserIds.add(im.Partner_User_3__c);                 
            }
             if (im.Partner_User_4__c != null){
                PartnerUserIds.add(im.Partner_User_4__c);                 
            }
            
        } else {
            return null;
        }           
        
        return PartnerUserIds ;
   }   */
   
  /* public Map<String, List<Note>> getRecordNotes(ID parentId){
        if (parentId == null)
            return null;
        
        Map<String, List<Note>> parentNotesMap = new Map<String, List<Note>>();         
        
        List<Sobject> notesList = lookup(parentId,'ParentId','Note');
        if (notesList.isEmpty())
            return null;
        List<Note> tempNoteList = new List<Note>();
        for(SObject so: notesList){
            Note n = (Note)so;
            tempNoteList.add(n);
        }
        parentNotesMap.put(parentId, tempNoteList); 
        return parentNotesMap;
   }
   
   public Map<String, List<Attachment>> getRecordAttachments(ID parentId){
        if (parentId == null)
            return null;
        
        Map<String, List<Attachment>> parentAttachmentsMap = new Map<String, List<Attachment>>();       
        
        List<Sobject> AttachmentsList = lookup(parentId,'ParentId','Attachment');
        if (AttachmentsList.isEmpty())
            return null;
        List<Attachment> tempAttachmentList = new List<Attachment>();
        for(SObject so: AttachmentsList){
            Attachment n = (Attachment)so;
            tempAttachmentList.add(n);
        }
        parentAttachmentsMap.put(parentId, tempAttachmentList);
        return  parentAttachmentsMap;
   } */
   
   public String getHTMLRemovedText(String inputStr){
        if (inputStr == null || inputStr == '' )
            return '';
       // String result = inputStr.replaceAll('<br/>', '\n');
       // result = result.replaceAll('<br />', '\n');
       string result = inputStr.replaceAll('<li.*?>', '<br>');
        result = result.replaceAll('</li.*?>', '');
        result = result.replaceAll('<p.*?>', '<br>');
        result = result.replaceAll('</p.*?>', '');
        result = result.replaceAll('<div.*?>', '<br>');
        result = result.replaceAll('<table.*?>', '');
        result = result.replaceAll('</table.*?>', '');
        result = result.replaceAll('<tr.*?>', '');
        result = result.replaceAll('</tr.*?>', '');
        result = result.replaceAll('<td.*?>', '');
        result = result.replaceAll('</td.*?>', '');
        result = result.replaceAll('<ul.*?>', '');
        result = result.replaceAll('</ul.*?>', '');
        result = result.replaceAll('<ol.*?>', '');
        result = result.replaceAll('</ol.*?>', '');
        result = result.replaceAll('</div.*?>', '');
      //  string HTML_TAG_PATTERN = '<.*?>';
      //  pattern myPattern = pattern.compile(HTML_TAG_PATTERN);
      //  matcher myMatcher = myPattern.matcher(result);
      //  result = myMatcher.replaceAll('');
        return result;          
      //return inputStr;
        
   }
   public String prepareINclause(Set<Id> ids){
        if (ids.isEmpty())
            return null;
                    
        String inValues;
        for(ID id: ids){
            if (inValues == null){
                inValues = '\'' +id +'\'';
            } else {
                inValues += ', \'' + id + '\'';
            }            
        }       
        return '( '+inValues +' )'; 
   }
   
   

   global  List<SObject> createSobject(String SObjectName,String recordType){
        
        //get all the fields
        Map<String,Schema.SObjectField> field_o=Schema.getGlobalDescribe().get(SObjectName).getDescribe().fields.getMap();          
        
        String rt_query ='select Id, Name from RecordType WHERE SobjectType=\''+SObjectName+'\'';
        
        //if the recordtype =='all'
        if(recordType!='' && recordType!='all')
            rt_query+=' AND Name=\''+recordType+'\'';   
        else{
            // Added IsActive = True to avoid permission problems where record types could not be deleted on PROD due to profiles without object access having default record types assigned
            rt_query += ' AND IsActive=True';
        }
        //get the list of the recordtypes :-
        List<RecordType> recordtype_list= Database.Query(rt_query);
     
        
        /* dynamically create an instance of the object same as
           eg : new <SOjectName>()
        */
        SObject s= createSObject(SObjectName);
        
        String fldType ;
        
        for(String field_name : field_o.keySet()){
            
            Schema.Sobjectfield field = field_o.get(field_name); 
            Schema.Describefieldresult fieldDesc = field.getDescribe();
            fldType = fieldDesc.getType().name();
            /*
             if the field is not required or the field is formula skip it
            */ 
            if(!fieldDesc.isCreateable() || fieldDesc.isDefaultedOnCreate() || fieldDesc.isCalculated() || fieldDesc.isAutoNumber() || fieldDesc.isNillable())
                continue;
            
            /*
              Below we are populating the values based on the datatype
            */
           
            if(fldType.equalsIgnoreCase('string') || fldType.equalsIgnoreCase('TextArea')){
                s.put(field_name,' String 1');
                continue;
            }
            
            if(fldType.equalsIgnoreCase('Email')){
                s.put(field_name,'test@test.com');
                continue;
            }
            
            if(fldType.equalsIgnoreCase('URL')){
                s.put(field_name,'www.test.com');
                continue;
            }
            
            if(fldType.equalsIgnoreCase('double') || fldType.equalsIgnoreCase('Integer')|| fldType.equalsIgnoreCase('Currency')){
                s.put(field_name,2000);
                continue;   
            }
            
            if(fldType.equalsIgnoreCase('boolean')){
                s.put(field_name,true);
                continue;   
            }
            
            if(fldType.equalsIgnoreCase('date')){
                s.put(field_name,date.today());
                continue;   
            }
            
            if(fldType.equalsIgnoreCase('datetime')){
                s.put(field_name,datetime.now());
                continue;   
            }
            
            /* for lookups we need to get the Id of the reference object */
            if(fldType.equalsIgnoreCase('Reference')){
                
                List <Schema.sObjectType> reference=fieldDesc.getReferenceTo();               
                //get the object:-
                //system.debug('Reference Object Name--->'+String.valueOf(reference[0]));
                String lookupobject=String.valueOf(reference[0]);
                if(lookupobject.equals('RecordType'))
                    continue;
                Id id=null;
                SObject obj = lookup(id,lookupobject);
                
                //if the object is not found we do a recursive call to the same method so create
                //the lookup object first as it is needed here
         
            if(obj==null) {
                    List<SObject> objs=createSobject(lookupobject, '');
                    obj=objs[0];
                }
                
                //system.debug('LOOKUP Object---->'+obj);
                s.put(field_name,obj.Id);
                continue;   
            }
            
            if(fldType.equalsIgnoreCase('Picklist')){
                List<Schema.PicklistEntry> P =fieldDesc.getPicklistValues();
                s.put(field_name,P[0].getValue());
                continue;   
            }            
        }
        
        //finally insert the records :-
        List<SObject> objsToInsert = new List<SObject>();
        if(recordtype_list.size() ==0 || recordtype_list==null){
            //create the object return  
            objsToInsert.add(s);
            //insert objsToInsert;
            //return objsToInsert;           
        }else{               
            for(RecordType rt : recordtype_list){
                //go thru all the fields 
                SObject clone= s.clone(false,true);
                clone.put('RecordTypeId',rt.Id);
                objsToInsert.add(clone);
            }
        }
        try{
            insert objsToInsert;
            return objsToInsert;
        } catch(Exception e){
            //system.debug('Error occured in GU createSobject  -'+e.getStackTraceString());
            e.setMessage('Error occured while inserting data in-'+SObjectName+'\\n'+'Error -'+e.getMessage()+' occured in class clsAwardUtility at line number -'+e.getLineNumber() );
        }
        return null;
    }
    
    // Helper that instantiates a generic SObject
    private static SObject createSObject(String objectName)
    {
        Schema.SObjectType t = Schema.getGlobalDescribe().get(objectName);
        SObject s = t.newSObject();
        return s;
    }
    
    /**
     Method used to check and return true if user has Partner Profile. 
    */
    
    public boolean isPartnerProfileUser(){
      return checkProfileUser('PARTNER');   
    }

    /**
     Method used to check and return true if user has Partner Profile. 
    */    
    
   public boolean isPLTProfileUser(){
      return checkProfileUser('PLT');   
    }
   
    /**
     Method used to check and return true if user has Partner Profile. 
    */ 
     public boolean isSTDProfileUser(){    
      return checkProfileUser('STD');    
    }
    
    /**
     Method used to check and return true if user has Partner Profile. 
    */
    public boolean isADMINProfileUser(){  
      return checkProfileUser('ADMIN');    
    }
    
   /**
     Method used to check and return true if user has PLT - Mission Profile. 
    */
    public boolean isPLTMissionUser(){      
      // return checkProfileUser('PLT - Mission Profile');  
       return checkProfileUser('MDA - Mission Data Admin');  
    }  
    
       /**
     Method used to check and return true if user has PLT - Read Only. 
    */
    public boolean isPLTReadOnlyUser(){      
      // return checkProfileUser('PLT - Read Only');  
       return checkProfileUser('MRO - Mission Read Only');
    }  
       /**
     Method used to check and return true if user has PLT-User Profile. 
    */
    public boolean isPLTUser(){      
       //return checkProfileUser('PLT-User');  
       return checkProfileUser('MRW - Mission Read/Write');       
    }  
       /**
     Method used to check and return true if user has STD - AIDtracker Support. 
    */
    public boolean isSTDAidtrackSupportUser(){      
       return checkProfileUser('STD - AIDtracker Support');  
    }  
       /**
     Method used to check and return true if user has STD - AIDtracker Support - Read Only Profile. 
    */
    public boolean isSTDAidtrackSupReadOnlyUser(){      
       return checkProfileUser('STD - AIDtracker Support - Read Only');  
    }  
    
       /**
     Method used to check and return true if user has STD - Edit Only - Custom. 
    */
    public boolean isSTDEditOnlyCustomUser(){      
       return checkProfileUser('STD - Edit Only - Custom');  
    }  
       /**
     Method used to check and return true if user has STD - Edit Only - Custom (Task). 
    */
    public boolean isSTDEditOnlyCustomTaskUser(){      
       return checkProfileUser('STD - Edit Only - Custom (Task)');  
    }  
       /**
     Method used to check and return true if user has STD - Mission Profile. 
    */
    public boolean isSTDMissionProfileUser(){      
       return checkProfileUser('STD - Mission Profile');  
    }  
       /**
     Method used to check and return true if user has STD - Read OnlyProfile. 
    */
    public boolean isSTDReadOnlyUser(){      
       return checkProfileUser('STD - Read Only');  
    }  
    
   /**
     Method used to check and return true if user has Mission Partner. 
    */
    public boolean isMissionPartnerUser(){      
       return checkProfileUser('Mission Partner');  
    }          
   /**
     Helper Method used to check User exist in given profile
    */
    
    public boolean checkProfileUser(String reqProfName){    
    boolean isUserExist= false;
    String profileName = getProfile((Id)Userinfo.getProfileId());
    if(reqProfName== 'PLT'){
       if(PLT_PROFILE.contains(profileName)){
          isUserExist=true;
        }
    }else if(reqProfName == 'STD'){
       if(STD_PROFILE.contains(profileName)){
          isUserExist=true;
        }
    }else if(reqProfName == 'PARTNER'){
        if(PARTNER_PROFILE.contains(profileName)){
           isUserExist=true;
        }
    }else if(reqProfName == 'ADMIN'){
        if(ADMIN_PROFILE.contains(profileName)){
          isUserExist=true;
        }
    }else if(reqProfName == profileName){      
          isUserExist=true;       
    }
    return isUserExist;    
    }


  /*  public static testMethod void testAPGlobalRoutines1(){
       Id recordTypeId;
       //profile
       // link to external resources
       clsGlobalUtility AAGutils= new clsGlobalUtility();
      List<Implementing_Mechanism__c> ims;
                          try{ 
       ims=AAGutils.createSobject('Implementing_Mechanism__c','all');
                  }catch(Exception e){
           }
       Test.StartTest();

    try{ 
           String Id = AAGutils.getRecordTypeId('Implementing_Mechanism__c','All');
           AAGutils.getRecordTypeId('Implementing_Mechanism','');
           AAGutils.getProfile('');
           AAGutils.getRecordType('Implementing_Mechanism__c', ims[0].recordTypeId);
  

           
           }catch(Exception e){
           }
           
       Test.StopTest();
    }
   */
    
    
}