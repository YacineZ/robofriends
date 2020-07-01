public with sharing class Moon_TimesheetDomain {



    public static final Date TIMESHEET_STARTDATE_MANDATORY = Date.newInstance(2020,06,29) ; 
    
    public List<Id> lIdUsers {get;set;} 

    public static final String TIMESHEET_STATUT_OPEN = 'Open' ; 
    public static final String TIMESHEET_STATUT_TOBEUPDATED = 'Rejected' ; 
    public static final String TIMESHEET_STATUT_APPROVAL = 'Submitted For Approval' ; 
    public static final List<String> PROJECTSTAGE_STATUT_CLOSED = new List<String>{'Closed'} ; 

    private List<Assignment__c> lAssignements  ; 

    private Date dtCurrentTS  ;

    private List<TimesheetEntry__c> lTimesheetEntries  ;    

    public Moon_TimesheetDomain() {
        lIdUsers = new List<id>() ;
        String idUser = UserInfo.getUserId() ; 
        lIdUsers.add(idUser) ; 
    }

    public Moon_TimesheetDomain(Date dtCurrentTS) {
        this.dtCurrentTS= dtCurrentTS ; 
        lIdUsers = new List<id>() ;
        String idUser = UserInfo.getUserId() ; 
        lIdUsers.add(idUser) ; 
    }

    public Moon_TimesheetDomain(List<Id> lIdUsers) {
        this.lIdUsers = lIdUsers ;
    }

    public List<Assignment__c> getAssignements(){
      return getAssignements(this.getCurrentTSDate()) ; 
    }

    //sDAte
    public List<Assignment__c> getAssignements(Date dtDate){

      this.lAssignements = [SELECT Id, Name__c,ProjectName__c,Name,ProjectStage__r.ProjectName__c,StartDate__c, EndDate__c,
                                    ProjectStage__r.ProjectName__r.Account__r.Name,ProjectStage__r.Name,
                                    ProjectStage__r.Statut__c
                                  FROM Assignment__c 
                                  WHERE ProjectStage__r.Statut__c  NOT IN :Moon_TimesheetDomain.PROJECTSTAGE_STATUT_CLOSED
                                  AND AssignedUser__c IN :lIdUsers
                                  ORDER BY Name__c ASC ] ; 
      return this.lAssignements  ; 
    }

    public List<TimesheetEntry__c> getTimesheetEntries(){

      return this.getTimesheetEntries(this.getCurrentTSDate()) ; 
    }



    public List<TimesheetEntry__c> getTimesheetEntries(Date dtDate){
      return getTimesheetEntriesWithRange(dtDate,600)  ;                
    }
    public List<TimesheetEntry__c> getTimesheetEntriesWithRange(Date dtDate,Integer iRangeDays){
      Date dtMondeyDate = dtDate.toStartofWeek() ; 
      System.debug('dtMondeyDate - iRangeDays > '+(dtMondeyDate - iRangeDays)) ;
      System.debug('dtMondeyDate + iRangeDays > '+(dtMondeyDate + iRangeDays)) ;
      System.debug('lIdUsers > '+lIdUsers) ;
      lTimesheetEntries = [SELECT Id,MondayDate__c,Assignee__c, MondayAM__c, MondayPM__c, ThursdayAM__c, ThursdayPM__c,Status__c,
                             WednesdayAM__c, WednesdayPM__c, TuesdayAM__c, TuesdayPM__c, FridayAM__c, FridayPM__c,ExternalId__c,
                             Timesheet__r.Status__c,Assignee__r.Name,Assignment__r.ProjectStage__r.Name, Timesheet__r.Id
                             FROM TimesheetEntry__c
                             WHERE Assignee__c IN :lIdUsers
                             AND MondayDate__c >= :dtMondeyDate - iRangeDays
                             AND MondayDate__c <= :dtMondeyDate + iRangeDays 
                             ] ;
      return lTimesheetEntries ;                    
    }

    public Date getCurrentTSDate(){
      if(dtCurrentTS==null){      
          this.dtCurrentTS = Date.today().toStartofWeek() ; 
          List<Timesheet__c> lTimesheets = [SELECT Id, MondayDate__c 
                                            FROM Timesheet__c
                                            WHERE 
                                            ( Status__c = :Moon_TimesheetDomain.TIMESHEET_STATUT_OPEN
                                              OR 
                                            Status__c = :Moon_TimesheetDomain.TIMESHEET_STATUT_TOBEUPDATED
                                            )
                                            AND OwnerId IN :lIdUsers
                                            AND MondayDate__c!=null
                                            ORDER BY MondayDate__c ASC
                                            LIMIT 1  ] ; 
          if(lTimesheets.size()>0)                                            
            this.dtCurrentTS = lTimesheets[0].MondayDate__c ;     
          if(Moon_TimesheetDomain.TIMESHEET_STARTDATE_MANDATORY >this.dtCurrentTS  ){            
            this.dtCurrentTS = Moon_TimesheetDomain.TIMESHEET_STARTDATE_MANDATORY ;    

          }                                  
      } 
      return this.dtCurrentTS ; 

    }

    public static  Timesheet__c createTimesheet(User oUser,Date oMondayDate){

      String sExternalId = oMondayDate.year()+(''+oMondayDate.month()).leftPad(2,'0')+(''+oMondayDate.day()).leftPad(2,'0')+'-'+oUser.Id;
      return new Timesheet__c(MondayDate__c=oMondayDate,OwnerId=oUser.Id,ExternalId__c=sExternalId ) ; 
    }


}