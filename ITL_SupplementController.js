({
    doInit : function(component, event, helper){
       //flow call  
      // alert('call do inti');
       // var action = component.get("c.getQuote");
      //  alert('Action ::' + action);
      //  action.setParams({"QuoteId": component.get("v.recordId")});
      //  alert('recordId' + component.get("v.recordId"));
      // Add callback behavior for when response is received
     /* action.setCallback(this, function(response) {
         var state = response.getState();
           alert(state);*/

   /* if (state === "SUCCESS") {
            // Pass the account data into the component's account attribute 
            component.set("v.quote", response.getReturnValue());
          var item =JSON.stringify(actionResult.getReturnValue()); */
            // alert('Quote Data'+item);
           //var item1 = itemsToPass[i];

           // flow.startFlow("Create_Quote_Approval_Flow");
       /*  }
         else {
            console.log("Failed to get Quote date.");
         }
      });

      // Send action to be executed
      $A.enqueueAction(action); */
   
                
    // upload  end
    // helper.getuploadedFiles(component);
        var recordType = component.get("v.recordTypeId");
        
        if(recordType == 'International ADC/VBM Supplement' || recordType == 'NAA Budgetary Quote' || recordType == 'NAA Supplement Quote')
        {
            component.set("v.isDealDeskDiscountingRequested", true); 
            component.set("v.isPricingChangesMade", true);             
        }
       // alert('Call my upload Function');
       //
        
    },
    
   /* handleFilesChange: function(component, event, helper) {
       
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
       
        component.set("v.fileName", fileName);
        console.log('File Name ',fileName);
       
    },*/
    
    handleFilesChange: function(component, event, helper) {
        var fileName = "No File Selected..";
        var fileCount=component.find("fileId").get("v.files").length;
        var files='';
        if (fileCount > 0) {
            for (var i = 0; i < fileCount; i++) 
            {
                fileName = component.find("fileId").get("v.files")[i]["name"];
                files=files+','+fileName;
            }
        }
        else
        {
            files=fileName;
        }
        component.set("v.fileName", files);
    },
   
    handleRadioChange : function(component, event, helper) {
    	var radioGrpValue = component.get("v.radioValue");
        var setTrue = true;
    	if(radioGrpValue == "option1"){
            component.set("v.isSaveSelected",setTrue);
            component.set("v.isSaveSubmitSelected",false);
        } else if(radioGrpValue == "option2"){
            component.set("v.isSaveSubmitSelected",setTrue);
            component.set("v.isSaveSelected",false);
        }
	},
    
    handleNext : function(component, event, helper){
        component.set("v.showLoading", true);
        helper.saveQuote(component, event,helper,component.find("fileId").get("v.files"))
        /* if (component.find("fileId").get("v.files") != null && component.find("fileId").get("v.files").length > 0) {
            console.log('inside if');
            helper.uploadHelper(component, event);
        } else {
            console.log('inside else');
            helper.saveQuote(component, event);
        }*/
    },
    
    handlePrevious : function(component, event, helper){
        alert('Click Previous button');
        var quoteId = component.get("v.quoteId");
        var url = window.location.origin + '/flow/Create_Quote_Approval_Updated?QuoterecordId='+quoteId+'&retURL='+quoteId;
        console.log('url-->'+url);
        window.open(url,'_top');
    },
	
	handleFinish : function(component, event, helper){
        var quoteId = component.get("v.quoteId");
	    var url = window.location.origin + '/lightning/r/Quote/'+quoteId+'/view';
        window.open(url,'_top');

        //helper.navigateSobject(component);
	}
  
})