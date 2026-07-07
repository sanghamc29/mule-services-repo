%dw 2.0
output application/json
---
{
	"host": Mule::p('common-sf.sapi.host'),
	"port": Mule::p('common-sf.sapi.port'),
	"method": Mule::p('common-sf.sapi.updateDocument.method'),
	"path": Mule::p('common-sf.sapi.updateDocument.path'),
	"timeout": Mule::p('common-sf.sapi.response.timeout'),
	"headers" :{
		"x-client-id" : Mule::p('common-sf.sapi.client-id'),
		"x-client-secret" : Mule::p('secure::common-sf.sapi.client-secret'),
		"x-correlation-id": vars.correlationId,
		"x-country-code": vars.countryCode,
		"request-event-type": vars.originalPayload.data.payload.EU_EventType__c
	}
}

