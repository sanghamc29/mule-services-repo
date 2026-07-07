%dw 2.0
output application/json
import * from dw::util::Values
---
vars.fraudCheckData map (item) -> do {
	var recordDCLIid = (vars.getDocumentResponse filter $.applicantId == item.customerNumber)[0].documentCheckListItemId
    var response = (vars.docUploadResponse filter $.documentCheckListItemId == recordDCLIid)[0]
    ---
    if((not isEmpty(response)) and lower(response.status) == "failed") 
    item update {
        case .isSuccessful -> false
        case .errorCode! -> item.customerNumber ++ ":" ++ response.httpStatus
        case .errorMessage! -> item.customerNumber ++ ":" ++ response.message
    }
    else item
}