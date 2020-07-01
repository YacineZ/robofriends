@isTest
public class Moon_Timesheet_Util_TEST {
    @isTest
    public static void test_ConvertDate() {
      Date oDate = Date.newInstance(2020,01,01);
      String sDate = '2020-01-01' ; 

      Test.startTest(); 
        String sNewDate = Moon_Timesheet_Util.converteToDateKey(oDate) ; 
      Test.stopTest() ; 

      System.assertEquals(sDate,sNewDate) ;  

    }
}