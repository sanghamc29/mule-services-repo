%dw 2.0
output application/json
---
error: {
	errorCode: if(vars.errorCode != null) vars.errorCode else error.errorType.identifier,
	errorDateTime: now() as String { format: "yyyy-MM-dd'T'HH:mm:ss" },
	errorMessage: if(vars.errorMessage != null) vars.errorMessage else 'This is handled error! No further business context available!',
	errorDescription: if(!isEmpty(error.errorMessage.payload.errors)) error.errorMessage.payload.errors else ( if(vars.errorDescription != null) vars.errorDescription else (error.description default "No desc provided."))
}