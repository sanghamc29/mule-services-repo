%dw 2.0
output application/json
fun getContentDocument(obj) = (vars.fraudCheckData filter (item) -> item.customerNumber == obj.applicantId)[0]
---
vars.getDocumentResponse map (item) -> {
    "documentName": Mule::p('common-sf.sapi.updateDocument.document.name'),
    "documentType": Mule::p('common-sf.sapi.updateDocument.document.extension'),
    "documentContent": getContentDocument(item).document,
    "contentDocumentId": item.contentDocumentId,
    "documentCheckListItemId": item.documentCheckListItemId

  }