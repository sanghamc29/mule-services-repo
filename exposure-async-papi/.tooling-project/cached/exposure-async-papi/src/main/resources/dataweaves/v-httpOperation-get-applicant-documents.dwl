%dw 2.0
import encodeURIComponent from dw::core::URL
output application/json
---
{
	"host": Mule::p('common-sf.sapi.host'),
	"port": Mule::p('common-sf.sapi.port'),
	"method": Mule::p('common-sf.sapi.getDocument.method'),
	"path": Mule::p('common-sf.sapi.getDocument.path'),
	"timeout": Mule::p('common-sf.sapi.response.timeout'),
	"headers" :{
		"x-client-id" : Mule::p('common-sf.sapi.client-id'),
		"x-client-secret" : Mule::p('secure::common-sf.sapi.client-secret'),
		"x-correlation-id": vars.correlationId,
		"x-country-code": vars.countryCode,
		"request-event-type": vars.requestEventType
	},
	"queryParams":{
		"applicantIds": vars.applicantId,
		"documentName": ((Mule::p('c6.documentName.identifier'))++"%")
		
	}
}

