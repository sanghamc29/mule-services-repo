%dw 2.0
import * from dw::core::Binaries
output application/json
---
{
  "allOrNone": true,
  "compositeRequest": if ( isEmpty(vars.queryResponse.compositeResponse[0].body.records) ) ([{
    "method": "POST",
    "url": "/services/data/" ++ p('sf.restApiVersion') ++ "/sobjects/ContentVersion",
    referenceId: "refContentversionUpsert",
    body: {
      "Title": p('fileName') ++ "_" ++ (now() as Date as String {
        format: "yyyy-MM-dd"
      }) ++ "_" ++ vars.quoteId,
      PathOnClient: p('fileName') ++ "_" ++ (now() as Date as String {
        format: "yyyy-MM-dd"
      }) ++ "_'" ++ vars.quoteId ++ "'.json",
      VersionData: toBase64(write(payload,'application/json',{
        "indent": false
      }) as Binary),
      EU_FileContentType__c: p('fileName'),
      IsMajorVersion: false,
      SharingPrivacy: "N"
    }
  }] ++ [{
    "method": "GET",
    "url": "/services/data/" ++ p('sf.restApiVersion') ++ "/query/?q=SELECT+ContentDocumentId+from+ContentVersion+WHERE+Id+=+'@{refContentversionUpsert.id}'",
    "referenceId": "refContentVersionDocumentId"
  }] ++
    
    [{
    "method": "POST",
    "url": "/services/data/" ++ p('sf.restApiVersion') ++ "/sobjects/ContentDocumentLink",
    "referenceId": "refCreateDocument",
    "body": {
      "ContentDocumentId": '@{refContentVersionDocumentId.records[0].ContentDocumentId}',
      LinkedEntityId: vars.quoteId
    }
  }] ++
  [{
    "method": "PATCH",
    "url": "/services/data/" ++ p('sf.restApiVersion') ++ "/sobjects/ApplicationForm/" ++ vars.quoteId ++ "/",
    "referenceId": "refApplicationFormUpsert",
    "body": {
      "EU_FQFlatFileLastModifiedTime__c" : now()
    }
  }]
  )

else (
[{
    "method": "PATCH",
    "url": "/services/data/" ++ p('sf.restApiVersion') ++ "/sobjects/ContentVersion/Id/" ++ (vars.queryResponse.compositeResponse[0].body.records[0].ContentDocument.LatestPublishedVersion.Id default 'null'),
    referenceId: "refContentversionUpsert",
    body: {
      "Title": p('fileName') ++ "_" ++ (now() as Date as String {
        format: "yyyy-MM-dd"
      }) ++ "_" ++ vars.quoteId,
      VersionData: toBase64(write(payload,'application/json',{
        "indent": false
      }) as Binary)
    }
  }] ++
  [{
    "method": "PATCH",
    "url": "/services/data/" ++ p('sf.restApiVersion') ++ "/sobjects/ApplicationForm/" ++ vars.quoteId ++ "/",
    "referenceId": "refApplicationFormUpsert",
    "body": {
      "EU_FQFlatFileLastModifiedTime__c" : now()
    }
  }]
)
}
