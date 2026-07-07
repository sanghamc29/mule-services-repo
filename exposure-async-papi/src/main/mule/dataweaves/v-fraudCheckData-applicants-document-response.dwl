%dw 2.0
output application/json
import * from dw::util::Values
---
vars.fraudCheckData map (item) -> do {
    var gotResponse = not (vars.getDocumentResponse.applicantId contains item.customerNumber)
    ---
    if(gotResponse and item.isSuccessful and not (isEmpty(item.document))) 
    item update {
        case .isSuccessful -> false
        case .errorCode! -> item.customerNumber ++ ":Record Not Found"
        case .errorMessage! -> item.customerNumber ++  ":Document Check List Item Record not Found"
        case .errorDescription! -> item.customerNumber ++ ":Document Check List Item Record not Found"
    }
    else item
}