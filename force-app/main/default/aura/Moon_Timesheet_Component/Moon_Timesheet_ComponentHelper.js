({
    refreshAssignements : function(component, event, helper) {
    
      var mapAssignements= {} ; 
      var isExternal = component.get("v.isExternal") ; 
      if( isExternal ){
        mapAssignements = component.get("v.timesheetWrapper.mapProjectAssignement") ; 
      }else {
        mapAssignements = component.get("v.timesheetWrapper.mapInternalAssignement") ; 
      }
      console.log("refreshAssignements ") ;
      console.log(JSON.stringify(mapAssignements)) ; 
      var lAssignement = []
      for(var key in mapAssignements){
          var oAssignement = { "projectName" : key, 
            "stages" : mapAssignements[key]
           } ;
           lAssignement.push(oAssignement) ; 
      }

      console.log("lAssignements > "+JSON.stringify(lAssignement)) ; 
      component.set("v.lAssignements",lAssignement) ; 
    },toggleAddRow : function(component, event, helper) {
      var sState = component.get("v.state") ; 
      console.log("sState > "+sState) ; 
      var sStateResult = "VIEW"; 

      console.log("check sState > "+(sState == "VIEW")) ; 
      if(sState == "VIEW"){
        sStateResult="ADDROW" ; 
      }
      component.set("v.state",sStateResult) ; 
    },refreshTimesheetLines: function(component, event, helper){

      var sCurrentTSDate = component.get("v.sCurrentWeek")  ; 
      var mapWeekTSEntries = component.get("v.timesheetWrapper.mapWeekTSEntries")  ;  
      if( "undefined" === typeof(mapWeekTSEntries[sCurrentTSDate])){
          // The property DOESN'T exists
          //Make controller call to retrieve more data
          var lEmptyTS = [] ; 
          component.set("v.lTSEntries",lEmptyTS)  ; 
      }else{
          // The property exist
        console.log("****** sCurrentTSDate > "+sCurrentTSDate) ;
        console.dir(mapWeekTSEntries) ; 
        var sCurrentTSEntries = mapWeekTSEntries[sCurrentTSDate] ; 
        component.set("v.lTSEntries",sCurrentTSEntries)  ; 
        console.dir(JSON.stringify(component.get("v.lTSEntries"))) ; 
      }

        helper.refreshTotalController(component, event, helper) ; 

    }
    ,fireAddRowEvent : function(sProjectName,idAssignement) {


      //Fire event
      var appEvent = $A.get("e.c:Moon_Timesheet_AddRowEvent");
      appEvent.setParams({ "sProjectName" : sProjectName,
                          "idAssignement" : idAssignement });
      appEvent.fire();
    },
    refreshTotalController : function(component,event,helper) {
      var lTSEntries = component.get("v.lTSEntries")  ;       
      var oTSController = helper.getEmptyFieldsTSEntry(component,event,helper)  ; 
      if(oTSController==null) oTSController = {} ; 

      for(var field of helper.getTimesheetFields()){  
        var isFirst = true ; 
        for(var oEntry of lTSEntries ){

          if("undefined" === typeof(oTSController[field])){
            oTSController[field] = oEntry[field] ; 
          }else {
            oTSController[field] = (isFirst)? 0 : oTSController[field]  ; 
            oTSController[field] = oTSController[field] + oEntry[field] ; 
          }
          isFirst =false ;
        }

      }
      component.set("v.oTSController",oTSController)  ; 
      console.log("******* refreshTotalController *******") ; 
      console.dir(JSON.stringify(component.get("v.oTSController"))) ; 
    },
    getTimesheetFields : function() {
      return ["MondayAM__c","MondayPM__c","ThursdayAM__c","ThursdayPM__c","WednesdayAM__c",
              "WednesdayPM__c","TuesdayAM__c","TuesdayPM__c","FridayAM__c","FridayPM__c"] ; 

  },
    getEmptyFieldsTSEntry : function(component,event,helper) {
      var emptyFieldTSEntry = {} ; 
      var lTSEntries = component.get("v.lTSEntries") ;
      for(var field of helper.getTimesheetFields()){  
        emptyFieldTSEntry[field] =  0 ;         
      }

      
      return emptyFieldTSEntry; 

  },    
  initTotalController : function(component,event,helper) {
    var oTSController = {} ;
    for(var field of helper.getTimesheetFields()){  
      oTSController[field] = 0  ; 
    }
      component.set("v.oTSController",oTSController)  ; 

  },    
    addRowTSEntry  : function(idAssignement,oProject,component,event,helper) {

      console.log('addRowTSEntry') ; 


      var sCurrentTSDate = component.get("v.sCurrentWeek")  ; 

      var isFound = false ; 
      for(var oTSEntry of  component.get("v.lTSEntries") ){
        if(oTSEntry.Assignment__c == idAssignement){
        console.log('TROUVE ! ') ; 
          isFound = true ; 
          break ;
        }
      } 

      var lTSEntries = component.get("v.lTSEntries") ;
      if(!isFound){
        console.log('A AJOUTER ASSIGNEMENT') ; 
        var newTSEntry = helper.getEmptyFieldsTSEntry(component,event,helper) ; 
        
        var sWeekId = component.get("v.sCurrentWeek")  ; 
        sWeekId = sWeekId.split("-").join("");
        console.log("sWeekId > "+sWeekId) ;

        var userId = $A.get("$SObjectType.CurrentUser.Id");
        console.log('userId >'+userId);
        var externalId = sWeekId+'-'+userId+'-'+idAssignement ; 
        console.log('ExternalId > '+externalId) ; 
        newTSEntry["ExternalId__c"] = externalId ;

        newTSEntry["MondayDate__c"] = sCurrentTSDate ; 
        newTSEntry["Assignment__c"] = idAssignement ;
        newTSEntry["Assignee__c"] = userId ;
        newTSEntry["Assignment__r"] = {"ProjectStage__r" : {"Name" : oProject}  } ;
        newTSEntry["Assignment__r"] = {"ProjectStage__r" : {"Name" : oProject}  } ;
        newTSEntry["Timesheet__r"] = {"ExternalId__c" :  sWeekId+'-'+userId } ;

        console.log(lTSEntries) ; 
        console.dir(lTSEntries) ; 
        lTSEntries.push(newTSEntry) ;
        component.set("v.lTSEntries",lTSEntries)  ;  
      }

  }, copyFromPrevious : function(sPreviousWeek,component,event,helper) {
      console.log('copyFromPrevious >>') ; 
      var mapWeekTSEntries = component.get("v.timesheetWrapper.mapWeekTSEntries")  ; 
      var lTSEntries =  component.get("v.lTSEntries") ;
      var sCurrentTSDate = component.get("v.sCurrentWeek")  ; 
      console.log('sCurrentTSDate > '+sCurrentTSDate) ; 
      if("undefined" === typeof(mapWeekTSEntries[sPreviousWeek])){  
        return  ; 
      }    

      for(var oTSEntry of mapWeekTSEntries[sPreviousWeek]){
        var oNewTS = {} ;         
        oNewTS["MondayDate__c"] = sCurrentTSDate ; 
        oNewTS["Assignment__c"] = oTSEntry["Assignment__c"] ;
        oNewTS["Assignment__r"] = {"ProjectStage__r" : {"Name" : oTSEntry.Assignment__r.ProjectStage__r.Name }  } ;
        oNewTS["Timesheet__r"] = {"Timesheet__r" : {"ExternalId__c" : oTSEntry.Timesheet__r.ExternalId__c }  } ;
        

        //Set Id 
        {
          var sWeekId = component.get("v.sCurrentWeek")  ; 
          sWeekId = sWeekId.split("-").join("");
          var userId = $A.get("$SObjectType.CurrentUser.Id");
          var externalId = sWeekId+'-'+userId+'-'+oNewTS["Assignment__c"]  ; 
          console.log('ExternalId > '+externalId) ; 

          oNewTS["Timesheet__r"] = {"ExternalId__c" :  sWeekId+'-'+userId } ;
          oNewTS["Assignee__c"] = userId ;
          oNewTS["ExternalId__c"] = externalId ;
        }


        for(var field of helper.getTimesheetFields(component,event,helper)){
          oNewTS[field] = oTSEntry[field] ; 
        }
        lTSEntries.push(oNewTS) ; 
      }

      component.set("v.lTSEntries",lTSEntries)  ;  
      helper.refreshTotalController(component, event, helper) ; 
  }
  , saveTimesheets : function(component,event,helper,runApproval) {
      console.log(' >>> saveTimesheets <<< ') ; 
      var sCurrentTSDate = component.get("v.sCurrentWeek")  ; 
      let action = component.get("c.saveTimesheetsEntries"); 
      action.setParams({  "sTSEntries" : JSON.stringify(component.get("v.lTSEntries")),
                          "lTSToDelete" : component.get("v.lDeletedAssignementsIds"),
                          "runApproval" : runApproval   });
      //lTSToDelete
      action.setCallback(this, function(response) {
      let state = response.getState();
      if (state === "SUCCESS") {
        var retValue = response.getReturnValue();
        console.log('retValue saveTimesheets ') ; 
        console.dir(retValue) ; 
        retValue = retValue ;
        console.log('retValue.isSuccess > '+retValue["isSuccess"]) ; 
        if(retValue.isSuccess){
          var oTSWrapper = component.get("v.timesheetWrapper") ; 
          component.set("v.lTSEntries",retValue.lTSEntries)  ;  
          component.set("v.lDeletedAssignementsIds",[]) ; 
          oTSWrapper.mapWeekTSEntries[sCurrentTSDate] = component.get("v.lTSEntries") ; 
          component.set("v.timesheetWrapper",oTSWrapper);
          helper.showToast("Saved successfully","success") ; 
        }else {

          helper.showToast(retValue.message,"error") ; 
        }
      }else{
        console.error(response.getError());
      }
      component.set("v.onGoing",false) ;
      }); 
      if(helper.validateTimesheets(component,event,helper,runApproval) ){
        $A.enqueueAction(action);  
      }else {
        component.set("v.onGoing",false) ;
      }
      
  }, showToast : function(message, type) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "message": message,
        "type": type
    });
    toastEvent.fire();
}
  , removeAssignement : function(idTimesheet,component,event,helper) {
    console.log(' >>> removeAssignement <<< ') ; 
    var sCurrentTSDate = component.get("v.sCurrentWeek")  ; 
    var lDeletedAssignementsIds = component.get("v.lDeletedAssignementsIds")  ; 
    var lTSEntries =  component.get("v.lTSEntries") ;
    console.log('idTimesheet > '+idTimesheet) ;
    var oDeletedTS=null  ; 
    var lNewTSEntries = [] ; 
    for(var oTSEntry of lTSEntries){
      if(oTSEntry["ExternalId__c"]== idTimesheet){
        oDeletedTS = oTSEntry ; 
        console.log("Found TS ! ") ; 
        console.log("TS ! "+JSON.stringify(oTSEntry)) ; 
        continue ; 
      }
      lNewTSEntries.push(oTSEntry) ; 
    }
    if(oDeletedTS!=null){ 
      if( "undefined" === typeof(oDeletedTS["Id"])){
      }else {
        lDeletedAssignementsIds.push(oDeletedTS["Id"]) ; 
        component.set("v.lDeletedAssignementsIds",lDeletedAssignementsIds)  ; 
        console.log('lDeletedAssignementsIds >>'+JSON.stringify(lDeletedAssignementsIds)) ; 
      }
    }
    component.set("v.lTSEntries",lNewTSEntries)  ; 
    helper.refreshTotalController(component, event, helper) ;  
  }, validateTimesheets : function(component,event,helper,runApproval) {
    var isValid = true ; 
    var errorMessage ; 
    var oTSController = component.get("v.oTSController") ; 
    var dweekSum = 0 ; 
    for(var field of helper.getTimesheetFields()){
      dweekSum+= oTSController[field] ;
    }
    if(dweekSum>5 || (runApproval && dweekSum!=5 )){
      isValid =false ; 
      errorMessage = "Your weekly timesheet should have a total of 5 days." ; 
     }

    if(!isValid){
      helper.showToast(errorMessage,"error") ;
    }
    return isValid ; 
  }
})