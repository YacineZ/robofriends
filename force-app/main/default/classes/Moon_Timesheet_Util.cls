public with sharing class Moon_Timesheet_Util {


  //Convert to YYYY-MM-dd
  public static String converteToDateKey(Date oDate){
    return oDate.year()+'-'+(oDate.month()+'').leftPad(2,'0') +'-'+ (oDate.day()+'').leftPad(2,'0')  ; 
  }

}