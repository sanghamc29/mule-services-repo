%dw 2.0
output application/json
var errRes = error.errorMessage.payload
---
vars.fraudCheckData map (item,index) -> 
	if(not isEmpty(errRes.results["$(index)"]))
		(errRes.results["$(index)"].payload update 
		{
			case .isSuccessful! -> true
			case .customerType! -> item.customerType
		})
		
	else 
		(do {
            var errDetail = errRes.failures["$(index)"].errorMessage.payload.error
            ---
            errDetail update {
	            case .isSuccessful! -> false
	            case .customerNumber! -> item.customerNumber
	            case .customerType! -> item.customerType
	            case .errorCode -> item.customerNumber ++ ":" ++ errDetail.errorCode
	            case .errorMessage -> item.customerNumber ++ ":" ++ errDetail.errorMessage
        		}
        	}
        )