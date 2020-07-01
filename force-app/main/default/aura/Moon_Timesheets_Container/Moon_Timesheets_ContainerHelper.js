({
  refreshComponent : function(component, event, helper) {
    
    let action = component.get("c.getTimeSheetsDetailsWrapper");
    action.setCallback(this, function(response) {
      let state = response.getState();
      if (state === "SUCCESS") {
        var retValue = response.getReturnValue();
        console.log('timesheetWrapper') ; 
        console.dir(retValue) ; 
        component.set("v.timesheetWrapper",retValue) ; 
        component.set("v.sCurrentWeek",retValue.dCurrentTSDate) ; 
        component.set("v.sWeekNumber",retValue.sCurrentWeekNumber) ; 
        component.set("v.sWeekLabel",retValue.sWeekLabel) ; 
        component.set("v.sCurrentYear",retValue.sCurrentYear) ; 

        var sCurrentWeek = component.get("v.sCurrentWeek") ; 
        var oNewDate = new Date(sCurrentWeek) ; 
        component.set("v.sCurrentYear",$A.localizationService.formatDate(oNewDate, "YYYY")) ; 
        helper.refreshDaysDate(component, event, helper) ; 
      }else{
        console.error(response.getError());
      }
    }); 
    $A.enqueueAction(action);    

  },  refreshDaysDate : function(component, event, helper) {
    
    var arrDaysDates = {};
    var sCurrentWeek = component.get("v.sCurrentWeek") ; 
    var oNewDate = new Date(sCurrentWeek) ;
    arrDaysDates["MondayDate"] = $A.localizationService.formatDate(oNewDate, "dd/MM") ; 
    oNewDate.setDate(oNewDate.getDate() + 1) ; 
    arrDaysDates["TuesdayDate"] = $A.localizationService.formatDate(oNewDate, "dd/MM") ; 
    oNewDate.setDate(oNewDate.getDate() + 1) ; 
    arrDaysDates["WednesdayDate"] = $A.localizationService.formatDate(oNewDate, "dd/MM") ; 
    oNewDate.setDate(oNewDate.getDate() + 1) ; 
    arrDaysDates["ThursdayDate"] = $A.localizationService.formatDate(oNewDate, "dd/MM") ; 
    oNewDate.setDate(oNewDate.getDate() + 1) ; 
    arrDaysDates["FridayDate"] = $A.localizationService.formatDate(oNewDate, "dd/MM") ; 
    console.dir(arrDaysDates) ; 
    console.log("Bernard") ; 
    component.set("v.arrDaysDates",arrDaysDates);
  }
})