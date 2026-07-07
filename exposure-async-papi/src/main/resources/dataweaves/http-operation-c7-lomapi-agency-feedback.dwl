%dw 2.0
output application/json
---
{
	"host": Mule::p('local-market-sapi.host'),
	"port": Mule::p('local-market-sapi.port'),
	"method": Mule::p('local-market-sapi.agencyfeedback.method'),
	"path": Mule::p('local-market-sapi.agencyfeedback.path'),
	"timeout": Mule::p('local-market-sapi.response.timeout'),
	"headers": {
		"x-client-id": Mule::p('local-market-sapi.client-id'),
		"x-client-secret": Mule::p('secure::local-market-sapi.client-secret'),
		"x-correlation-id": vars.correlationId,
		"x-country-code": vars.countryCode
	}
}
