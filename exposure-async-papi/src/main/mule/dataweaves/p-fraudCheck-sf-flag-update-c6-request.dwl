%dw 2.0
import * from dw::core::Arrays
import * from dw::core::Strings
output application/json
var arr = flatten(vars.agencyReportsUploadResponse)
var allOk    = arr every (upper($.status)) == "SUCCESS"
var allFail  = arr every (upper($.status)) == "FAILED"
---
{
	status: if ( allOk ) "success"
            else if ( allFail ) "failed"
            else "partial success",
	
	errorMessage: if (allOk) "No Errors" else write(vars.agencyReportsUploadResponse, "application/json")
}