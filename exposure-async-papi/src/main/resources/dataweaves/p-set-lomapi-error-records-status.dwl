%dw 2.0
output application/json
---
{
	"status": "Failed",
	"errorMessage": vars.applicantId ++ ":" ++ vars.applicantOriginalDocuments.message

}