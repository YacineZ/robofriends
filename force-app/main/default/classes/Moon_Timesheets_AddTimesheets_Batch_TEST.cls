@isTest
public class Moon_Timesheets_AddTimesheets_Batch_TEST {
/* 
    @isTest
    public static  void test_RunBatch_Schedule() {

      Moon_Timesheets_AddTimesheets_Batch oBatch = new Moon_Timesheets_AddTimesheets_Batch() ; 
      Boolean isSuccess = true ; 
      Test.startTest() ; 
        try{
          String sch ='20 30 8 10 2 ?';
          String jobID = system.schedule('Merge Job', sch, oBatch);

        }catch(Exception e){
          isSuccess = false ; 
        }
      Test.stopTest() ; 
      System.assert(isSuccess) ;       

    }
    */
    @isTest
    public static  void test_RunBatch_Batch() {

      Moon_Timesheets_AddTimesheets_Batch oBatch =new Moon_Timesheets_AddTimesheets_Batch() ; 
      Integer iTSESize = [SELECT Id FROM TimesheetEntry__c].size() ; 
      Test.startTest() ; 
        try{
          Database.executeBatch(oBatch,1) ; 
        }catch(Exception e){
        }
      Test.stopTest() ;      

    }
}