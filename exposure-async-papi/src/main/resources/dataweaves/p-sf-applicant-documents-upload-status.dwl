%dw 2.0
import * from dw::core::Arrays
import * from dw::core::Strings
output application/json
var arr = flatten(vars.agencyReportsUploadResponse default[])

//check for SF documents upload status
var allOk    = arr every (upper($.status)) == "SUCCESS"
var allFail  = arr every (upper($.status)) == upper(Mule::p('c6.documentUploadStatus.failed'))

//check lomapi error records 
var lomapiErrors = vars.lomapiErrorDocuments map {
	"status": Mule::p('c6.documentUploadStatus.failed'),
	"httpStatus": $.agencyStatusCode,
	"message": $.agencyStatusText,
	"documentCheckListItemId": (vars.getApplicantDocuments filter ((getdocs) -> getdocs.documentName == ((Mule::p('c6.documentName.identifier'))++ " " ++ $.documentName)))[0].documentCheckListItemId default ((Mule::p('c6.documentName.identifier'))++ " " ++ $.documentName)
}
//check lomapi documents with no DCI
var docswithoutdci = vars.docswithNodci map{
	"status": Mule::p('c6.documentUploadStatus.failed'),
	"httpStatus": 500,
	"message": Mule::p('c6.documentUploadStatus.dciNotFound'),
	"documentCheckListItemId": $.documentName
}
//List all the failed records to send error message to SF 
var failed = if ( !isEmpty(lomapiErrors) ) flatten(lomapiErrors ++ (arr filter (item) -> upper(item.status default "") == upper(Mule::p('c6.documentUploadStatus.failed'))))  else (arr filter (item) -> upper(item.status default "") == upper(Mule::p('c6.documentUploadStatus.failed')))
var failedDocs = if ( !isEmpty(docswithoutdci) ) flatten(failed ++ docswithoutdci) else failed
---
{
	status: if (isEmpty(arr) and allOk )  Mule::p('c6.documentUploadStatus.failed')
	        else if (!isEmpty(arr) and allOk and isEmpty(docswithoutdci)) Mule::p('c6.documentUploadStatus.success')
            else if (!isEmpty(arr)and allFail ) Mule::p('c6.documentUploadStatus.failed')
            else Mule::p('c6.documentUploadStatus.partialSuccess'),
	errorMessage: if ( allOk and isEmpty(lomapiErrors) and isEmpty(docswithoutdci) ) "" else (failedDocs map (item) -> (if ( !isEmpty(item.documentCheckListItemId) ) item.documentCheckListItemId else vars.applicantId) ++ (if ( !isEmpty(item.message) ) ":" else "") ++ (item.message default "")) joinBy " , "
}