@isTest
public class Moon_TimesheetsContainer_LC_TEST {

    @TestSetup
    public static void initTestData(){        
        TESTDataFactory.initSetupData() ; 
    }

    @isTest
    public static  void test_TSContainerLC_OK() {
        
        String sToDeleteId = [SELECT Id FROM TimesheetEntry__c LIMIT 1][0].Id ;
        Test.startTest(); 
          Moon_TimesheetsContainer_LC.TimeSheetsDetailsWrapper oTSWrapper = Moon_TimesheetsContainer_LC.getTimeSheetsDetailsWrapper() ; 
          List<Assignment__c>  lAssignments = Moon_TimesheetsContainer_LC.getAssignements('2020-06-29') ; 
          Moon_TimesheetsContainer_LC.TimeSheetsDetailsWrapper oTSWrapperWithDate = Moon_TimesheetsContainer_LC.getTimeSheetsDetailsWrapper('2020-06-29') ; 
          Map<String,Object> oMapTS = Moon_TimesheetsContainer_LC.saveTimesheetsEntries(JSON.serialize(oTSWrapperWithDate.mapWeekTSEntries.values()[0]),
                                                  new List<String>{sToDeleteId},false) ;  

        Test.stopTest();

    }
   
}