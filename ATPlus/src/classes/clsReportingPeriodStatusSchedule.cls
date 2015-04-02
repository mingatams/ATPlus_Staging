global class clsReportingPeriodStatusSchedule  implements Schedulable{
    global void execute(SchedulableContext SC) {
         
        Id batchinstanceid = database.executeBatch(new clsReportingPeriodStatusBatch());
    }
    
    @IsTest public static void testclsReportingPeriodStatusSchedule () {
        test.starttest();
        clsReportingPeriodStatusSchedule sco = new clsReportingPeriodStatusSchedule();        
        String sch = '0 0 23 * * ?';        
        system.schedule('RP Status Changes', sch, sco);
        test.stopTest();
    }
}