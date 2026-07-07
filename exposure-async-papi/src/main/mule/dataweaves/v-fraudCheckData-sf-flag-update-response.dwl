%dw 2.0
output application/json
import * from dw::util::Values
---
vars.fraudCheckData map (item) -> do {
    var res = (payload filter $.applicantId == item.customerNumber)[0]
    ---
    if((not isEmpty(res)) and lower(res.status) == "failure") 
    item update {
        case .isSuccessful -> false
        case .errorCode! -> (item.errorCode ++ ";") default "" ++ (item.customerNumber ++ ":FLAG_UPDATE_FAILED")
        case .errorMessage! -> (item.errorMessage ++ ";") default "" ++ (item.customerNumber ++ ":" ++ res.message default "")
    }
    else item
}