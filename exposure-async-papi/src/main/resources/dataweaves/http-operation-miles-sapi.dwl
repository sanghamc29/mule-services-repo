%dw 2.0
output application/json
---
{
	"host": Mule::p('miles-sapi.host'),
	"port": Mule::p('miles-sapi.port'),
	"method": Mule::p('miles-sapi.customerExposure.method'),
	"path": Mule::p('miles-sapi.customerExposure.path'),
	"timeout": Mule::p('miles-sapi.response.timeout'),
	"headers" :{
		"x-client-id" : Mule::p('miles-sapi.client-id'),
		"x-client-secret" : Mule::p('secure::miles-sapi.client-secret'),
		"x-correlation-id": vars.correlationId,
		"x-country-code": vars.countryCode
	},
	"uriParams": {
		customerId: payload.customerId
	}
}
