public with sharing class ITL_SupplementController {
    
    
	@AuraEnabled
    public static void saveQuoteApp(Quote_Approval__c quoteApp, String quoteId, String recordTypeId, boolean isSaveSubmitClick){
          Quote_Approval__c qa = new Quote_Approval__c(
        	Comment__c = quoteApp.Comment__c,
            Discounting__c = quoteApp.Discounting__c,
            Only_Pricing_Changes_Made__c = quoteApp.Only_Pricing_Changes_Made__c,
            Discounting_Instruction__c = quoteApp.Discounting_Instruction__c,
            Quote__c = quoteId,
            RecordTypeId = Schema.SObjectType.Quote_Approval__c.getRecordTypeInfosByName().get(recordTypeId).getRecordTypeId()
        );
        insert qa;
        
        if(isSaveSubmitClick == true){
            submitForApprovalRequest(qa.id);
        }   
        
    } 
    
    @AuraEnabled
    public static Id saveChunk(Quote_Approval__c quoteApp, String quoteId, String recordTypeId, boolean isSaveSubmitClick, String fileName, String base64Data, String contentType) 
    {   
       /* Quote_Approval__c qa = new Quote_Approval__c(
        	Comment__c = quoteApp.Comment__c,
            Discounting__c = quoteApp.Discounting__c,
            Only_Pricing_Changes_Made__c = quoteApp.Only_Pricing_Changes_Made__c,
            Discounting_Instruction__c = quoteApp.Discounting_Instruction__c,
            Quote__c = quoteId,
            RecordTypeId = Schema.SObjectType.Quote_Approval__c.getRecordTypeInfosByName().get(recordTypeId).getRecordTypeId()
        );
        insert qa;
	*/
     
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = quoteId; 
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType; 
        insert oAttachment;
        return oAttachment.id;
    }
    
    private static void submitForApprovalRequest(id quoteAppId){
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
		req1.setObjectId(quoteAppId);
		Approval.ProcessResult result = Approval.process(req1);
	}
    
    
    @AuraEnabled  
    public static List<ContentDocument> getFiles(string recordId){ 
        // TO avoid following exception 
        // System.QueryException: Implementation restriction: ContentDocumentLink requires
        // a filter by a single Id on ContentDocumentId or LinkedEntityId using the equals operator or 
        // multiple Id's using the IN operator.
        // We have to add sigle record id into set or list to make SOQL query call
        Set<Id> recordIds=new Set<Id>{recordId};
        system.debug('Outside Id ::' + recordIds);
        system.debug('Size ::' + recordIds.size());
        Set<Id> documentIds = new Set<Id>(); 
        List<ContentDocumentLink> cdl= new List<ContentDocumentLink>();
        if(recordIds.size()>0 && recordIds != null){
            
             cdl= [SELECT id,LinkedEntityId,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN:recordIds]; 
        }
        for(ContentDocumentLink cdLink:cdl){  
            documentIds.add(cdLink.ContentDocumentId);  
        }      
        return [SELECT Id,Title,FileType FROM ContentDocument WHERE id IN: documentIds];  
    } 
    
    @AuraEnabled  
    public static void deleteFiles(string sdocumentId){ 
        delete [SELECT Id,Title,FileType from ContentDocument WHERE id=:sdocumentId];       
    }  
    
   /*  @AuraEnabled
   public static Quote getQuote(String QuoteId) {
      return [SELECT Id, Name FROM Quote where id=:QuoteId LIMIT 1];
   } */
    @AuraEnabled
    public static Id saveQuoteApp1(Quote_Approval__c quoteApp, String quoteId, String recordTypeId, boolean isSaveSubmitClick){
          Quote_Approval__c qa = new Quote_Approval__c(
        	Comment__c = quoteApp.Comment__c,
            Discounting__c = quoteApp.Discounting__c,
            Only_Pricing_Changes_Made__c = quoteApp.Only_Pricing_Changes_Made__c,
            Discounting_Instruction__c = quoteApp.Discounting_Instruction__c,
            Quote__c = quoteId,
            RecordTypeId = Schema.SObjectType.Quote_Approval__c.getRecordTypeInfosByName().get(recordTypeId).getRecordTypeId()
        );
        insert qa;
        
        if(isSaveSubmitClick == true){
            submitForApprovalRequest(qa.id);
        }   
      return qa.id;  
    }
}