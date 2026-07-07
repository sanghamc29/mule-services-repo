%dw 2.0
import p from Mule
import * from dw::core::Binaries
output application/json
---
{
  "allOrNone" : true,
  "compositeRequest": 
    
    [{
        "method": "GET",
        "url": "/services/data/" ++ p('sf.restApiVersion') ++ "/query/?q=SELECT ContentDocumentId,ContentDocument.Title, ContentDocument.ContentModifiedDate, ContentDocument.FileType, ContentDocument.LatestPublishedVersion.Id, ContentDocument.LatestPublishedVersion.EU_FileContentType__c FROM ContentDocumentLink WHERE LinkedEntityId = '" ++ vars.quoteId ++ "' and ContentDocument.LatestPublishedVersion.EU_FileContentType__c = '" ++ p('fileName') ++ "'",
        "referenceId": "refContentVersionDocumentId"
  
    }
    
  ]
}