public without sharing class Moon_TimesheetsContainer_LC {

  @AuraEnabled 
  public static TimeSheetsDetailsWrapper getTimeSheetsDetailsWrapper() {
    Moon_TimesheetDomain oTimesheetDomain = new Moon_TimesheetDomain() ; 

    return new TimeSheetsDetailsWrapper(oTimesheetDomain) ; 
  }

  @AuraEnabled 
  public static List<Assignment__c> getAssignements(String sDate) {
    System.debug('getAssignement >> '+sDate) ; 
    Moon_TimesheetDomain oTimesheetDomain = new Moon_TimesheetDomain() ; 

    String[] arrDate = sDate.split('-') ; 
    Date dCurrentWeek = Date.newInstance(Integer.valueOf(arrDate[0]) ,Integer.valueOf(arrDate[1]) ,Integer.valueOf(arrDate[2]) ) ; 

    return oTimesheetDomain.getAssignements(dCurrentWeek) ;
  }
  
  @AuraEnabled 
  public static TimeSheetsDetailsWrapper getTimeSheetsDetailsWrapper(String sDate) {
    Moon_TimesheetDomain oTimesheetDomain = new Moon_TimesheetDomain() ; 

    return new TimeSheetsDetailsWrapper(oTimesheetDomain) ; 
  }

  @AuraEnabled 
  public static Map<String,Object> saveTimesheetsEntries(String sTSEntries,List<String> lTSToDelete,Boolean runApproval) {

    List<Object> lRawTSEntries = (List<Object>)JSON.deserializeUntyped(sTSEntries) ;
    Date dCurrentWeek = null ; 
    String sTimesheetExternalId = null ; 
    System.Debug('aha lRawTSEntries !'+lRawTSEntries) ; 
    System.Debug('aha lTSToDelete !'+lTSToDelete) ; 
    List<TimesheetEntry__c> lTSEntries =new  List<TimesheetEntry__c>() ; 
    for(Object oTSEntry : lRawTSEntries){  
      Map<String,Object> mapTSEntry = (Map<String,Object>)oTSEntry ; 
 

      if(mapTSEntry.containsKey('Assignment__r')){
        mapTSEntry.remove('Assignment__r')  ;
        System.debug('mapTSEntry > '+mapTSEntry );
      }  
      for(String key :mapTSEntry.keySet()){
        System.debug(key) ;
      }
      String sDate = (String)mapTSEntry.get('MondayDate__c') ; 
      String[] arrDate = sDate.split('-') ; 
      sTimesheetExternalId = arrDate[0]+arrDate[1]+arrDate[2]+'-'+UserInfo.getUserid() ;
      dCurrentWeek = Date.newInstance(Integer.valueOf(arrDate[0]) ,Integer.valueOf(arrDate[1]) ,Integer.valueOf(arrDate[2]) ) ; 
      mapTSEntry.put('Mondaydate__c',dCurrentWeek)  ;
      if((String)mapTSEntry.get('Status__c')!='Accepted')
        lTSEntries.add((TimesheetEntry__c)JSON.deserialize( JSON.serialize(mapTSEntry),TimesheetEntry__c.class) ) ;
    }

    System.Debug('aha lTSEntries !'+lTSEntries) ; 

    System.Debug('aha dCurrentWeek !'+dCurrentWeek) ; 

    Boolean isSuccess = true ; 
    String sMessage ='Saved.' ; 
    List<TimesheetEntry__c> lNewTSEntries = new List<TimesheetEntry__c> () ; 
    {
        try{
          Database.upsert(lTSEntries,TimesheetEntry__c.ExternalId__c) ; 
          if(lTSToDelete!=null && lTSToDelete.size()>0){
            List<TimesheetEntry__c> lTSEntriesToDelete =new  List<TimesheetEntry__c>() ; 
            for(String idTSEntry : lTSToDelete){
              lTSEntriesToDelete.add(new TimesheetEntry__c(Id=idTSEntry,ExternalId__c=idTSEntry+'-DELETED-'+Datetime.now()) ) ; 
            }
            Database.update(lTSEntriesToDelete) ; 
            Database.delete(lTSToDelete) ; 

          }
          //Update ts entries
          if(dCurrentWeek!=null){
            if(runApproval && sTimesheetExternalId != null){
             upsert new Timesheet__c(ExternalId__c=sTimesheetExternalId, Status__c = Moon_TimesheetDomain.TIMESHEET_STATUT_APPROVAL,TECH_RunApproval__c = true  ) Timesheet__c.ExternalId__c ; 
            }
            Moon_TimesheetDomain oTimesheetDomain = new Moon_TimesheetDomain() ; 
            lNewTSEntries = oTimesheetDomain.getTimesheetEntriesWithRange(dCurrentWeek,0) ; 

          System.Debug('aha lNewTSEntries !'+lNewTSEntries) ;
          }
        }catch(System.DmlException e){
          System.debug('Error >'+e) ;
          System.debug('Error trace >'+e.getStackTraceString()) ;
          sMessage =e.getDmlMessage(0);
          isSuccess = false ;         
        }catch(Exception e){
          System.debug('Error >'+e) ;
          System.debug('Error trace >'+e.getStackTraceString()) ;
          sMessage =e+''+e.getStackTraceString() ; 
          isSuccess = false ; 
        }
    }
    return new Map<String,Object>{'isSuccess'=>isSuccess,'message'=>sMessage,'lTSEntries'=>lNewTSEntries } ; 
  }  

  public class TimeSheetsDetailsWrapper{

    @AuraEnabled 
    public Date dCurrentTSDate ; //YYYY-MM-dd
    
    @AuraEnabled 
    public String sCurrentWeekMonday ; //YYYY-MM-dd
    @AuraEnabled 
    public String sCurrentWeekNumber ; //44
    @AuraEnabled 
    public String sCurrentYear ; //2020
    @AuraEnabled 
    public String sWeekLabel ; //30 dec. to 3 jan.
    @AuraEnabled
    public List<Id> lOwnersIds ;  
    @AuraEnabled
    public String sMode ; // CAPTAIN / CREW

    @AuraEnabled
    public String sFullName ;
    @AuraEnabled
    public String sPhotoURL ;  

    @AuraEnabled
    public Map<String,List<TimesheetEntry__c>> mapWeekTSEntries = new Map<String,List<TimesheetEntry__c>>() ;  
    

    @AuraEnabled
    public Map<String,List<Assignment__c>> mapProjectAssignement = new Map<String,List<Assignment__c>>() ; 

    @AuraEnabled
    public Map<String,List<Assignment__c>> mapInternalAssignement = new Map<String,List<Assignment__c>>() ;

    //public TimeSheetsDetailsWrapper(){
    //  this.sCurrentWeekNumber = '44' ; 
    //  this.sCurrentYear = '2019' ; 
    //  this.sCurrentWeekMonday = '2019-12-27' ; 
    //  this.sWeekLabel = '30 dec. to 3 jan.' ; 
    //  this.lOwnersIds = new List<Id>{'0051v000004y5HJAAY'} ; 
    //  this.sMode = 'CREW' ; 
    //  User u = [SELECT FullPhotoUrl 
    //              FROM User 
    //              WHERE id=:Userinfo.getUserid()];
    //  this.sPhotoURL = u.FullPhotoUrl;
    //  this.sFullName = UserInfo.getFirstName()+' '+UserInfo.getLastName() ; 
    //}

    public TimeSheetsDetailsWrapper(Moon_TimesheetDomain oTimesheetDomain){
      this.dCurrentTSDate = oTimesheetDomain.getCurrentTSDate() ; 
      Datetime dttCurrentTS = Datetime.newInstance(this.dCurrentTSDate,Time.newInstance(12,0,0,0) ) ; 
      Datetime dttCurrentTSEndWeek = dttCurrentTS.addDays(4) ; 

      this.sCurrentWeekNumber = dttCurrentTS.format('w') ; 
      this.sCurrentWeekMonday = dttCurrentTS.format('YYYY-MM-dd')  ; 
      this.sCurrentYear = dttCurrentTS.format('YYYY-MM-dd')  ; 
      this.sWeekLabel = dttCurrentTS.day()+' '+dttCurrentTS.format('MMM')+'. to '+dttCurrentTSEndWeek.day()+' '+dttCurrentTSEndWeek.format('MMM')+'.' ; 
      this.lOwnersIds = oTimesheetDomain.lIdUsers   ; 
      this.sMode = (lOwnersIds.size()>1)? 'CAPTAIN' : 'CREW' ; 
      User u = [SELECT FullPhotoUrl 
                  FROM User 
                  WHERE id=:Userinfo.getUserid()];
      this.sPhotoURL = u.FullPhotoUrl;
      this.sFullName = UserInfo.getFirstName()+' '+UserInfo.getLastName() ;

      //Init timesheet entries
      System.debug('oTimesheetDomain.getTimesheetEntries size > '+oTimesheetDomain.getTimesheetEntries().size() )  ; 
      for(TimesheetEntry__c oTSEntry : oTimesheetDomain.getTimesheetEntries()){
        this.addTSEntry(oTSEntry) ; 
      }   

       for(Assignment__c oAssignement : oTimesheetDomain.getAssignements()){
          this.addAssignement(oAssignement);
       }  

    }

    public void addTSEntry(TimesheetEntry__c oTSEntry){
      
      List<TimesheetEntry__c> lTSEntries ; 
      String sDateKey = Moon_Timesheet_Util.converteToDateKey(oTSEntry.MondayDate__c) ;
      if(mapWeekTSEntries.containsKey(sDateKey)){
        lTSEntries = mapWeekTSEntries.get(sDateKey); 
      }else{        
        lTSEntries = new List<TimesheetEntry__c> (); 
        mapWeekTSEntries.put(sDateKey,lTSEntries) ;
      }

      lTSEntries.add(oTSEntry) ; 
    }

    public void addAssignement(Assignment__c oAssignement){

      Map<String,List<Assignment__c>> mapAssignement = (oAssignement.ProjectStage__r.ProjectName__r.Account__r.Name=='LEVANA')
                                                        ? mapInternalAssignement 
                                                        :  mapProjectAssignement ; 
      List<Assignment__c> lAssignements ; 
      if(mapAssignement.containsKey(oAssignement.ProjectName__c)){
        lAssignements = mapAssignement.get(oAssignement.ProjectName__c); 
      }else{        
        lAssignements = new List<Assignment__c>(); 
        mapAssignement.put(oAssignement.ProjectName__c,lAssignements) ;
      }

      lAssignements.add(oAssignement) ;       
    }


  }

  //public class TimesheetslinesWrapper{

  //  @AuraEnabled
  //  public String sOwnerName ; 

  //  @AuraEnabled
  //  public List<TimesheetEntry__c> lTSEntries ; 

  //  public TimesheetslinesWrapper(List<TimesheetEntry__c> lTimesheets,String sOwnerName){
  //    this.sOwnerName = sOwnerName ; 
  //    mWeekTimesheets = new Map<String,List<TimesheetEntry__c>>() ; 

  //    for(TimesheetEntry__c oTimesheet : lTimesheets){
  //      this.addTSEntry(oTimesheet) ; 
  //    }
  //  }
  //  public TimesheetslinesWrapper(String sOwnerName){
  //    this.sOwnerName = sOwnerName ; 
  //    mWeekTimesheets = new Map<String,List<TimesheetEntry__c>>() ; 
  //  }    

  //  public void addTSEntry(TimesheetEntry__c oTimesheet){
  //    String sDateKey = Moon_Timesheet_Util.converteToDateKey(oTimesheet.MondayDate__c) ;
  //    List<TimesheetEntry__c> lTimesheets ; 
  //    if(mWeekTimesheets.containsKey(sDateKey)){
  //      lTimesheets = mWeekTimesheets.get(sDateKey); 
  //    }else{        
  //      lTimesheets = new List<TimesheetEntry__c>(); 
  //      mWeekTimesheets.put(sDateKey,lTimesheets) ; 
  //    }
  //    lTimesheets.add(oTimesheet) ; 
  //  }

  //}




}