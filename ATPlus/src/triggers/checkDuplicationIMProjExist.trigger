trigger checkDuplicationIMProjExist on Public_IM_Link__c (before insert, before update) {
 for(Public_IM_Link__c pil:trigger.new){          
        list<Public_IM_Link__c> OrganizationIDList= [Select id From Public_IM_Link__c pil where Project_Code__c =:pil.Project_Code__c and Implementing_Mechanism_Number__c =:pil.Implementing_Mechanism_Number__c];
          if(OrganizationIDList.size() > 0){
           trigger.new[0].addError('Selected Implementing Mechanism Id already linked to Project.');
          }       
    } 
}