global class Moon_Timesheets_AddTimesheets_Batch implements Database.Batchable<sObject>,Schedulable {
    public static final Date TIMESHEET_STARTDATE = Date.newInstance(2020,06,29) ; 
    public static final Integer TIMESHEET_FORECAST_MONTHS = 6 ; 


    public String query = 'SELECT Id,CreatedDate,EntryDate__c FROM USER ' +
                            'WHERE isActive = true ' + 
                            'AND TimesheetUser__c = true  ';

    global Moon_Timesheets_AddTimesheets_Batch() {
        this.query = query;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, list<Sobject> scope) {
        List<User> lUsers = (List<User>)scope ; 
        System.debug('lUsers > '+lUsers) ; 
        Date dEndDate = Date.Today().addMonths(Moon_Timesheets_AddTimesheets_Batch.TIMESHEET_FORECAST_MONTHS+1) ;         
        System.debug('dEndDate : +7 mois > '+dEndDate) ; 

        dEndDate = Date.newInstance(dEndDate.year(),dEndDate.month(),1);         
        System.debug('dEndDate  > 1 jour du 7eme mois '+dEndDate) ; 

        Map<String,Date> mapOwnerLastTSDate = new Map<String,Date>() ;
        {
            for(AggregateResult oResult : [SELECT OwnerId,MAX(MondayDate__c)lastTSDate  FROM Timesheet__c WHERE OwnerId IN :lUsers
                                            GROUP BY OwnerId]){
                mapOwnerLastTSDate.put((String)oResult.get('OwnerId'),(Date)oResult.get('lastTSDate')) ; 
            }
            for(User oUser : lUsers){
                if(!mapOwnerLastTSDate.containsKey(oUser.Id)){
                    mapOwnerLastTSDate.put((String)oUser.Id,Moon_Timesheets_AddTimesheets_Batch.TIMESHEET_STARTDATE) ;
                }
            }
        }
        System.debug('mapOwnerLastTSDate > '+mapOwnerLastTSDate) ; 

        List<Timesheet__c> lTimesheetsToUpsert = new List<Timesheet__c>() ; 
        for(User oUser : lUsers){
            Date oCurrentDate = mapOwnerLastTSDate.get(oUser.Id) ;
            System.debug('oCurrentDate > '+oCurrentDate) ; 
            while(oCurrentDate+7 < dEndDate){
                oCurrentDate = oCurrentDate + 7 ;
                lTimesheetsToUpsert.add(Moon_TimesheetDomain.createTimesheet(oUser,oCurrentDate));
            }            
        }
        
        Database.upsert(lTimesheetsToUpsert,Timesheet__c.ExternalId__c,true ); 

    }

    global void finish(Database.BatchableContext BC) {

    }
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new Moon_Timesheets_AddTimesheets_Batch(),1);    
    }
}