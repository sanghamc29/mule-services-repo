%dw 2.0
output application/json
var euMessage = read(vars.originalPayload.data.payload.EU_Message__c,"application/json")
---
{
	applicationType : if (euMessage.'Application Type' == "Private Individual") "individual"
						else if(euMessage.'Application Type' == "Retail Small Business") "business"
						else if (euMessage.'Application Type' == "Corporate") "corporate"
						else "" ,
	applicants : (euMessage.'Representatives IDs' replace "[" with "" ) replace "]" with ""
}