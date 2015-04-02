public with sharing class AAPlanDetailDeleteController {

    public AAPlanDetail__c aaPlanDetail { get; private set; }
    private ApexPages.StandardController sc { get; private set; }
    
    public AAPlanDetailDeleteController(ApexPages.StandardController stdController){
       	this.aaPlanDetail = (AAPlanDetail__c)stdController.getRecord();
        sc = stdController;
    }
    
    public PageReference deletex(){
        try{
            if( aaPlanDetail != NULL && String.isNotBlank( aaPlanDetail.Delete_Reason__c ) ){
                String planID = aaPlanDetail.AandAPlan__c;
                PageReference p = Page.AAPlanDetailList;
                if( planID != NULL ){
                    p.getParameters().put( 'ParentId', planID );
                }
                update aaPlanDetail;
                delete aaPlanDetail;
                return p;
            }else if( String.isBlank( aaPlanDetail.Delete_Reason__c ) ){
                ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Please populated the reason for deleting the record.' ) );
                return null;
            }
        }catch( Exception E ){
            ApexPages.addMessage(  new ApexPages.Message( ApexPages.Severity.Error,  e.getMessage() ) );
            return null;
        }
        return null;
    }
}