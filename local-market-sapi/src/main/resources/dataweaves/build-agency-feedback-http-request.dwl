%dw 2.0
output application/json
---
{
	"method": "POST",
	"path": Mule::p('lomapi.agencyFeedback.path'),
	"headers": {
		"x-correlation-id": vars.correlationId
	},
	"queryParams": {
	},
	"uriParams": {
	countryCode: vars.countryCode
}
}
