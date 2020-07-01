({
    toggleAddRow : function(component, event, helper) {
      helper.toggleAddRow(component,event,helper) ; 
    }, 
    doInit : function(component, event, helper) {
      console.log('doInit Component') ; 
      console.dir(component.get("v.timesheetWrapper")) ; 

        helper.initTotalController(component, event, helper) ; 
      if(  component.get("v.timesheetWrapper") !=null ){
        helper.refreshAssignements(component, event, helper) ; 
        helper.refreshTimesheetLines(component, event, helper) ;  
        console.log("$$$$$$$$$$$ "); 
        console.log(JSON.stringify(component.get("v.lTSEntries") )) ;
      }else{
      }      // action.setCallback(this, function(response) {
      //   let state = response.getState();
      //   if (state === "SUCCESS") {
      //     var retValue = response.getReturnValue();
      //     console.log('timesheetWrapper') ; 
      //     console.dir(retValue) ; 
      //     component.set("v.timesheetWrapper",retValue) ; 
      //   }else{
      //     console.error(response.getError());
      //   }
      // }); 
      // $A.enqueueAction(action);    

  }, refreshTimesheetLines : function(component, event, helper) {
     helper.refreshTimesheetLines(component, event, helper) ; 
  }, 

  setExternal : function(component, event, helper) {
    if(component.get("v.isExternal")){
        component.set("v.isExternal",true) ; 
        component.set("v.isInternal",false) ; 
        helper.refreshAssignements(component, event, helper) ;        
    }  
  }, 
  setInternal : function(component, event, helper) {
    if(component.get("v.isInternal")){
      component.set("v.isExternal",false) ; 
      component.set("v.isInternal",true) ; 
      helper.refreshAssignements(component, event, helper) ;       
    }  
  }, 
  addRow : function(component, event, helper) {
    var selectedItem = event.currentTarget;
    var oAssignement = selectedItem.dataset.assignement;
    var oProject = selectedItem.dataset.project;
    console.log('idAssignement > '+oAssignement) ; 
    console.log('oProject > '+oProject) ;  
    helper.addRowTSEntry(oAssignement,oProject,component,event,helper) ; 
    helper.fireAddRowEvent(oProject,oAssignement) ; 
    helper.toggleAddRow(component,event,helper) ; 
  }, 
  toggleCell : function(component, event, helper) {
    var bOnGoing = component.get("v.onGoing") ; 


    if(!bOnGoing){

      component.set("v.onGoing",true) ;
      var selectedItem = event.currentTarget;
      var idAssignement = selectedItem.dataset.assignement;
      var oField = selectedItem.dataset.field;
      console.log('idAssignement > '+idAssignement) ; 
      console.log('oField > '+oField) ;  

      var lAssignements = component.get("v.lTSEntries") ;


      var oTSController = component.get("v.oTSController")  ; 

      
        for(var oAssignement of  lAssignements){
          console.dir(JSON.stringify(oAssignement)) ; 
            console.log("Found oAssignement "+idAssignement) ; 
          if(oAssignement.ExternalId__c == idAssignement){
            if(oAssignement["Status__c"]=='Accepted'){
              helper.showToast("This timesheet is already approved and can't be updated.",'error') ; 
            }else{
              console.log("Found it ") ; 
              if(oAssignement[oField]  > 0){
                oAssignement[oField] = 0 ;
              }else if(oTSController[oField]==0){       //Si la ligne est encore disponible ou bien si la case était cochée
                oAssignement[oField] = 0.5 ;
              }               
            }
          }      
        }

        console.dir(JSON.stringify(lAssignements)) ; 
        component.set("v.lTSEntries",lAssignements) ; 
        helper.refreshTotalController(component, event, helper) ; 
        component.set("v.onGoing",false) ;
      
    }
  },
  fillEmptyRow : function(component,event,helper){

    var bOnGoing = component.get("v.onGoing") ; 


    if(!bOnGoing){

      component.set("v.onGoing",true) ;
      var selectedItem = event.currentTarget;
      var newValue = (selectedItem.checked) ? 0.5 : 0 ; 

      var idAssignement = selectedItem.dataset.assignement;

      console.log('idAssignement > '+idAssignement) ; 
      console.log('selectedItem.checked > '+selectedItem.checked) ; 
      var lTSEntries = component.get("v.lTSEntries") ;
      var oTSController = component.get("v.oTSController") ;
      var i = 0 ; 
      for(var oTSEntry of  lTSEntries){
        console.log("**** I ***** "+i);
        i = i+1 ;
        if(oTSEntry.ExternalId__c == idAssignement){
          console.log("Found it ! ") ; 
          for(var field of helper.getTimesheetFields()){  
            if(newValue > 0 &&  oTSController[field]<=0){
              oTSEntry[field] =newValue ;
            } else if(newValue==0){
              oTSEntry[field] =newValue ;              
            }
          }
          break ; 
        }
      

        }     

      component.set("v.lTSEntries",lTSEntries) ; 
      helper.refreshTotalController(component, event, helper) ;  
    }
    component.set("v.onGoing",false) ;
  },
  onWeekChange : function(component,event,helper){

    var bOnGoing = component.get("v.onGoing") ; 


    if(!bOnGoing){

      component.set("v.onGoing",true) ;
      var sCurrentWeek = component.get("v.sCurrentWeek") ;
      console.log("sCurrentWeek > "+sCurrentWeek) ; 
      helper.refreshTimesheetLines(component, event, helper) ; 

    }
    component.set("v.onGoing",false) ;
  },
  copyFromPrevious : function(component,event,helper){

    var bOnGoing = component.get("v.onGoing") ; 

    if(!bOnGoing){
      component.set("v.onGoing",true) ;
      var sCurrentWeek = component.get("v.sCurrentWeek") ;
      console.log("sCurrentWeek > "+sCurrentWeek) ;     
      var oNewDate = new Date(sCurrentWeek) ; 
      oNewDate.setDate(oNewDate.getDate() - 7) ; 
      var sPreviousWeek = $A.localizationService.formatDate(oNewDate, "YYYY-MM-dd")  ; 
      helper.copyFromPrevious(sPreviousWeek,component, event, helper) ; 

    }
    component.set("v.onGoing",false) ;
  }, saveTimesheets : function(component,event,helper) {
    var bOnGoing = component.get("v.onGoing") ; 

    if(!bOnGoing){
      component.set("v.onGoing",true) ;
      helper.saveTimesheets(component, event, helper,false) ;       
    }
    
  }, saveAndRunApprovalTimesheets : function(component,event,helper) {
    var bOnGoing = component.get("v.onGoing") ; 

    if(!bOnGoing){
      component.set("v.onGoing",true) ;
      helper.saveTimesheets(component, event, helper,true) ;       
    }
    
  }
  , removeAssignement : function(component,event,helper) {
    var bOnGoing = component.get("v.onGoing") ; 

    if(!bOnGoing){
      component.set("v.onGoing",true) ;
      console.log('event > ') ;
      console.dir(event) ; 
      var selectedItem = event.currentTarget;
      console.log('selectedItem > '+selectedItem) ; 
      var idAssignement = selectedItem.dataset.assignement;
      console.log('idAssignement > '+idAssignement) ; 
      helper.removeAssignement(idAssignement,component, event, helper) ;       
    }
    
    component.set("v.onGoing",false) ;
    

  }

})