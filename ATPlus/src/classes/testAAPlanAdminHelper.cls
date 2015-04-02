/*
 * 
 * 
 * 
 * 
 * 
 */
public class testAAPlanAdminHelper {
    public static List<Group> createPublicGroups( Integer numOfGroups, String baseName ){
        List<Group> lstGroups = null;
        if( numOfGroups != NULL && String.isNotBlank( baseName ) && numOfGroups > 0 && baseName.length() > 0 ){
            lstGroups = new List<Group>();
            for( Integer i = 0; i < numOfGroups ; i++ ){
                lstGroups.add( new Group( Name = baseName, DeveloperName = baseName + 'test' + i, Type = 'Regular' ) );
            }
            if( !lstGroups.isEmpty() ){
                insert lstGroups;
            }
        }
        return lstGroups;
    }
    
    public static OperatingUnit__c createPlanningUnit( String baseName, String planningUnitType ){
        OperatingUnit__c lstPlanningUnit = null;
        if( String.isNotBlank( baseName ) && String.isNotBlank( planningUnitType ) ){
            
            lstPlanningUnit = new OperatingUnit__c( name = baseName, Region__c = planningUnitType );
            
            insert lstPlanningUnit;
            
        }
        return lstPlanningUnit;
    }
}