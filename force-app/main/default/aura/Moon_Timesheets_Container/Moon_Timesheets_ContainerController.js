({
  doInit : function(component, event, helper) {

    helper.refreshComponent(component, event, helper)  ; 

  }, 
  nextWeek : function(component, event, helper) {
    var sCurrentWeek = component.get("v.sCurrentWeek") ; 
    var oNewDate = new Date(sCurrentWeek) ; 
    oNewDate.setDate(oNewDate.getDate() + 7) ; 
    var oNewEndWeekDate = new Date(sCurrentWeek) ;
    oNewEndWeekDate.setDate(oNewEndWeekDate.getDate() + 11) ;  
    console.log(')))))) nextWeek > '+oNewDate) ; 
    component.set("v.sCurrentWeek",$A.localizationService.formatDate(oNewDate, "YYYY-MM-dd")) ; 
    component.set("v.sCurrentYear",$A.localizationService.formatDate(oNewDate, "YYYY")) ; 
    component.set("v.sWeekNumber",$A.localizationService.formatDate(oNewDate, "ww")) ; 
    component.set("v.sWeekLabel",$A.localizationService.formatDate(oNewDate, "dd MMM")+". to "+$A.localizationService.formatDate(oNewEndWeekDate, "dd MMM")+".") ; 
    helper.refreshDaysDate(component, event, helper) ; 
  }, 
  previousWeek : function(component, event, helper) {
    var sCurrentWeek = component.get("v.sCurrentWeek") ; 
    var oNewDate = new Date(sCurrentWeek) ; 
    oNewDate.setDate(oNewDate.getDate() - 7) ; 
    var oNewEndWeekDate = new Date(sCurrentWeek) ;
    oNewEndWeekDate.setDate(oNewEndWeekDate.getDate() - 3) ;  
    component.set("v.sCurrentWeek",$A.localizationService.formatDate(oNewDate, "YYYY-MM-dd")) ;     
    component.set("v.sCurrentYear",$A.localizationService.formatDate(oNewDate, "YYYY")) ; 
    component.set("v.sWeekNumber",$A.localizationService.formatDate(oNewDate, "ww")) ; 
    component.set("v.sWeekLabel",$A.localizationService.formatDate(oNewDate, "dd MMM")+". to "+$A.localizationService.formatDate(oNewEndWeekDate, "dd MMM")+".") ; 
    helper.refreshDaysDate(component, event, helper) ; 
  }
})