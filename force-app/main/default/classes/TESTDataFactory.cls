@isTest
public class TESTDataFactory {
  public static final Date MONDAY_DATE = Date.newInstance(2020,06,29) ;
  public static final String SMONDAY_DATE = '20200629' ;


  public static void initSetupData() {
    TESTDataFactory.initTSAndTSEntries(1,null,true) ; 
  }
  public static void initTSAndTSEntries(integer numAccount,String recordTypeDeveloperName,
                                              Boolean insertAndReturn)
  {
    Timesheet__c oNewTS = new Timesheet__c()  ; 
    oNewTS.put('MondayDate__c',TESTDataFactory.MONDAY_DATE) ; 
    oNewTS.put('ExternalId__c',TESTDataFactory.SMONDAY_DATE+'-'+UserInfo.getUserId()) ; 
    oNewTS.put('Status__c','Open') ; 
    insert oNewTS ; 

    List<Assignment__c> lAssignments = TESTDataFactory.insertAssignement(1,null,null,false) ; 
    insert lAssignments ; 

    TimesheetEntry__c oNewETS = new TimesheetEntry__c() ; 
    oNewETS.put('MondayDate__c',TESTDataFactory.MONDAY_DATE) ; 
    oNewETS.put('ExternalId__c',TESTDataFactory.SMONDAY_DATE+'-'+UserInfo.getUserId()+'-'+lAssignments[0].Id ) ; 
    oNewETS.put('Status__c','Draft') ; 
    oNewETS.put('Timesheet__c',oNewTS.Id) ; 
    oNewETS.put('Assignment__c',lAssignments[0].Id) ; 
    oNewETS.put('Assignee__c',UserInfo.getUserId()) ; 
    insert oNewETS ;          
  }
      //Return map of accounts fiels set for "Locataire" recordtype
   
  public static List<Assignment__c> insertAssignement(integer numAccount,String recordTypeDeveloperName,Map<String,object> mapFieldsValues,
                                              Boolean insertAndReturn)
    {
      if(mapFieldsValues==null){
          mapFieldsValues=TESTDataFactory.getAssignmentDefaultMapFields(); 
      } 
      if(!mapFieldsValues.containsKey('ProjectStage__c')){
          List<Project_Stage__c> lProjectsStages = TESTDataFactory.insertProjectStage(1,null,null,true) ; 
          mapFieldsValues.put('ProjectStage__c',lProjectsStages[0].Id) ;             
      }

      return insertSobject(numAccount,'Assignment__c',recordTypeDeveloperName,mapFieldsValues,insertAndReturn)  ;         
            
    }
      //Return map of accounts fiels set for "Locataire" recordtype
    public static Map<String,Object> getAssignmentDefaultMapFields(){
      Map<String,Object> mapFieldsValues=new Map<String,Object>() ;  
      //Initialise Opportunity fields
      //Create Locataire account
      List<Project_Stage__c> lProjectsStages = TESTDataFactory.insertProjectStage(1,null,null,false) ; 
      insert lProjectsStages ; 
      
      //Set related objects Id
      mapFieldsValues.put('ProjectStage__c',lProjectsStages[0].Id) ; 

      //Set opportunity fields
      mapFieldsValues.put('AssignedUser__c',UserInfo.getUserId()) ; 
      mapFieldsValues.put('DailyCostPrice__c',200) ;
      mapFieldsValues.put('StartDate__c',Date.Today()) ;       

      return mapFieldsValues ; 
    }    

 public static List<Project_Stage__c> insertProjectStage(integer numAccount,String recordTypeDeveloperName,Map<String,object> mapFieldsValues,
                                              Boolean insertAndReturn)
    {
      if(mapFieldsValues==null){
          mapFieldsValues=TESTDataFactory.getProjectStageDefaultMapFields(); 
      } 
      if(!mapFieldsValues.containsKey('ProjectName__c')){
          List<Projet__c> lProjects = TESTDataFactory.insertProject(1,null,null,true) ; 
          mapFieldsValues.put('ProjectName__c',lProjects[0].Id) ;             
      }
      if(!mapFieldsValues.containsKey('Name')){
           mapFieldsValues.put('Name','TESTPROJECTSTAGE') ;            
      }

      return insertSobject(numAccount,'Project_Stage__c',recordTypeDeveloperName,mapFieldsValues,insertAndReturn)  ;         
            
    }
      //Return map of accounts fiels set for "Locataire" recordtype
    public static Map<String,Object> getProjectStageDefaultMapFields(){
      Map<String,Object> mapFieldsValues=new Map<String,Object>() ;  
      //Initialise Opportunity fields
      //Create Locataire account
      List<Projet__c> lProjects = TESTDataFactory.insertProject(1,null,null,false) ; 
      insert lProjects ; 
      
      //Set related objects Id
      mapFieldsValues.put('ProjectName__c',lProjects[0].Id) ; 

      //Set opportunity fields
      mapFieldsValues.put('Name','TESTPROJECTSTAGE') ;
      mapFieldsValues.put('Statut__c','In Progress') ;       

      return mapFieldsValues ; 
    }        

    public static List<Projet__c> insertProject(integer numAccount,String recordTypeDeveloperName,Map<String,object> mapFieldsValues,
                                              Boolean insertAndReturn)
    {
      if(mapFieldsValues==null){
          mapFieldsValues=TESTDataFactory.getProjectDefaultMapFields(); 
      } 
      if(!mapFieldsValues.containsKey('Opportunite__c')){
          List<Opportunity> lOpportunities = TESTDataFactory.insertOpportunity(1,null,null,true) ; 
          mapFieldsValues.put('Opportunite__c',lOpportunities[0].Id) ;             
      }
      if(!mapFieldsValues.containsKey('Name')){
           mapFieldsValues.put('Name','TESTOPPORTUNITY') ;            
      }

      return insertSobject(numAccount,'Projet__c',recordTypeDeveloperName,mapFieldsValues,insertAndReturn)  ;         
            
    }
      //Return map of accounts fiels set for "Locataire" recordtype
    public static Map<String,Object> getProjectDefaultMapFields(){
      Map<String,Object> mapFieldsValues=new Map<String,Object>() ;  
      //Initialise Opportunity fields
      //Create Locataire account
      List<Opportunity> lOpportunities = TESTDataFactory.insertOpportunity(1,null,null,false) ; 
      insert lOpportunities ; 
      
      //Set related objects Id
      mapFieldsValues.put('Opportunite__c',lOpportunities[0].Id) ; 

      //Set opportunity fields
      mapFieldsValues.put('ModeFacturation__c','FixedTerms') ; 
      mapFieldsValues.put('Name',lOpportunities[0].Name) ;
      mapFieldsValues.put('Statut__c','In Progress') ;       

      return mapFieldsValues ; 
    }    

    public static List<Opportunity> insertOpportunity(integer numAccount,String recordTypeDeveloperName,Map<String,object> mapFieldsValues,
                                              Boolean insertAndReturn)
    {
      if(mapFieldsValues==null){
          mapFieldsValues=TESTDataFactory.getOpportunityDefaultMapFields(); 
      }
      if(!mapFieldsValues.containsKey('AccountId')){
          List<Account> lAccounts = TESTDataFactory.insertAccount(1,null,null,true) ; 
          mapFieldsValues.put('AccountId',lAccounts[0].Id) ;             
      }
      if(!mapFieldsValues.containsKey('Name')){
           mapFieldsValues.put('Name','TESTOPPORTUNITY') ;            
      }

      return insertSobject(numAccount,'Opportunity',recordTypeDeveloperName,mapFieldsValues,insertAndReturn)  ;         
            
    }
      //Return map of accounts fiels set for "Locataire" recordtype
    public static Map<String,Object> getOpportunityDefaultMapFields(){
      Map<String,Object> mapFieldsValues=new Map<String,Object>() ;  
      //Initialise Opportunity fields
      //Create Locataire account
      List<Account> lAccounts = TESTDataFactory.insertAccount(1,null,null,false) ; 
      insert lAccounts ; 
      
      //Set related objects Id
      mapFieldsValues.put('AccountId',lAccounts[0].Id) ; 

      //Set opportunity fields
      mapFieldsValues.put('closeDate',Date.Today()) ; 
      mapFieldsValues.put('Name',lAccounts[0].Name) ;
      mapFieldsValues.put('StageName','Qualification') ;       

      return mapFieldsValues ; 
    }

    public static List<Account> insertAccount (integer numAccount,String recordTypeDeveloperName,Map<String,object> mapFieldsValues,
                                                Boolean insertAndReturn)
      {
          if(mapFieldsValues==null){
              mapFieldsValues=TESTDataFactory.getAccountDefaultMapFields(); 
          }
          
          return insertSobject(numAccount,'Account',null,mapFieldsValues,insertAndReturn)  ;         
    }

    //Return map of accounts fiels set for "Locataire" recordtype
    public static Map<String,Object> getAccountDefaultMapFields(){
        Map<String,Object> mapFieldsValues=new Map<String,Object>() ;  
        //Initialise Account variables
        mapFieldsValues.put('Name','Moon & Cie') ; 
        mapFieldsValues.put('Type','Prospect') ; 
        return mapFieldsValues ; 
    }

    public static List<Sobject> insertSobject(Integer iCount,String sObjectName,String sRecordTypeDeveloperName,Map<String,object> mapFieldsValues,Boolean isInsertEnabled)
    {        
        
        List<sObject> lSobjectToInsert=new List<Sobject>() ;
        Set<String> uniqueFields = new Set<String>{'NAME','FIRSTNAME', 'LASTNAME', 'USERNAME', 'SURNAME', 'COMMUNITYNICKNAME'};
        

        //Set recordtype Id from RecordType Name
        if(sRecordTypeDeveloperName!=null){
            mapFieldsValues.put('RecordTypeId',
                Schema.getGlobalDescribe().get(sObjectName).getDescribe().getRecordTypeInfosByDeveloperName().get(sRecordTypeDeveloperName).getRecordTypeId());                  
        }

        for(Integer i=0;i<iCount;i++){
            //Id recordtypId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('recordType').getRecordTypeId();
            sObject dynObject= Schema.getGlobalDescribe().get(sObjectName).newSObject() ;
            if(mapFieldsValues!=null)
                for(String key : mapFieldsValues.keySet()){
                    if(uniqueFields.contains(key.toUpperCase())){  
                        String sSuffix=(i==0)?'':''+i ;                        
                        dynObject.put(key,mapFieldsValues.get(key)+sSuffix) ;
                        continue ;
                    }
                    dynObject.put(key,mapFieldsValues.get(key)) ;
                }
            lSobjectToInsert.add(dynObject) ;
        }

        if(isInsertEnabled)
            //try {
                insert lSobjectToInsert;
            //} catch (DmlException d) {
               // d.getMessage();
            //}
        return lSobjectToInsert ; 
    }
}