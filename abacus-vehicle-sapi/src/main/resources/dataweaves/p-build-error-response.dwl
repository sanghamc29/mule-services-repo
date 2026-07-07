%dw 2.0
output application/json
var isGatewayError = (p('abacus.systemErrorCodes') splitBy ",")contains (vars.errorObject.errorMessage.attributes.statusCode as String) default false
var errorCode = if (isGatewayError == false) vars.errorObject.errorMessage.payload.errors[0].errorCode else null
---
error: {errorCode:  if(errorCode != null) p('abacus.errorCode') else (vars.errorCode default error.errorType.identifier),
	errorDateTime: now() as String { format: "yyyy-MM-dd'T'HH:mm:ss" },
	errorMessage: if(vars.errorMessage != null) vars.errorMessage else 'This is handled error! No further business context available!',
	errorDescription: if(vars.errorDescription != null) vars.errorDescription else (error.description default "No desc provided.")
}