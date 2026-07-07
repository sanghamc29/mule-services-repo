%dw 2.0
output application/json
---
{
    "status":  Mule::p('c6.documentUploadStatus.failed'),
    "httpStatus": 500,
    "message": error.errorMessage.payload.error.errorDescription,
    "documentCheckListItemId": vars.applicantId
}