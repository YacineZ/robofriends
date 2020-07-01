@isTest
public class Moon_TimesheetDomain_TEST {

        @TestSetup
    public static void initTestData(){        
        TESTDataFactory.initSetupData() ; 
    }

    @isTest
    public static  void test_AllGetterStudentDomain_OK() {
        
        Moon_TimesheetDomain oTSDomain = new Moon_TimesheetDomain() ; 

        Test.startTest(); 
          List<Assignment__c> lAssignments = oTSDomain.getAssignements() ; 
          List<TimesheetEntry__c> lTSEntries = oTSDomain.getTimesheetEntries() ; 
          Timesheet__c oNewTimesheet = Moon_TimesheetDomain.createTimesheet([SELECT Id FROM User WHERE Id =:UserInfo.getUserId()][0],
                                                                Moon_TimesheetDomain.TIMESHEET_STARTDATE_MANDATORY+7) ; 
        Test.stopTest();

        System.assert(lAssignments.size()>0) ; 
        System.assert(lTSEntries.size()>0) ; 
        System.assert(oNewTimesheet!=null) ; 
    }

    @isTest
    public  static void test_AllGetterStudentDomain2_OK() {
        
        Moon_TimesheetDomain oTSDomain = new Moon_TimesheetDomain(Moon_TimesheetDomain.TIMESHEET_STARTDATE_MANDATORY) ; 

        Test.startTest(); 
          List<Assignment__c> lAssignments = oTSDomain.getAssignements() ; 
          List<TimesheetEntry__c> lTSEntries = oTSDomain.getTimesheetEntries() ; 
          Timesheet__c oNewTimesheet = Moon_TimesheetDomain.createTimesheet([SELECT Id FROM User WHERE Id =:UserInfo.getUserId()][0],
                                                                Moon_TimesheetDomain.TIMESHEET_STARTDATE_MANDATORY+7) ; 

        Test.stopTest();

        System.assert(lAssignments.size()>0) ; 
        System.assert(lTSEntries.size()>0) ; 
        System.assert(oNewTimesheet!=null) ;         
    }    
}