%dw 2.0
output application/json
---
{
	"host": Mule::p('sf-accounts-sapi.host'),
	"port": Mule::p('sf-accounts-sapi.port'),
	"method": Mule::p('sf-accounts-sapi.applicantsDetails.method'),
	"path": Mule::p('sf-accounts-sapi.applicantsDetails.path'),
	"timeout": Mule::p('sf-accounts-sapi.response.timeout'),
	"headers" :{
		"x-client-id" : Mule::p('sf-accounts-sapi.client-id'),
		"x-client-secret" : Mule::p('secure::sf-accounts-sapi.client-secret'),
		"x-correlation-id": vars.correlationId,
		"x-country-code": vars.countryCode,
		"request-event-type": vars.originalPayload.data.payload.EU_EventType__c
	},
	"queryParams": {
		"applicationFormId": vars.applicationFormId,
		("applicantIds": vars.applicantIds) if not (isEmpty(vars.applicantIds))
	}
}