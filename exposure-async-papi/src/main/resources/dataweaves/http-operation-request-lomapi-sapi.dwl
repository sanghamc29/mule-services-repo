%dw 2.0
output application/json
var isCompany = (payload.eu_Type != "Individual")
---
{
	"host": Mule::p('local-market-sapi.host'),
	"port": Mule::p('local-market-sapi.port'),
	"method": if(isCompany) Mule::p('local-market-sapi.companyAffordability.method')
			  else Mule::p('local-market-sapi.personAffordability.method'),
	"path": if(isCompany) Mule::p('local-market-sapi.companyAffordability.path')
			else Mule::p('local-market-sapi.personAffordability.path'),
	"timeout": Mule::p('local-market-sapi.response.timeout'),
	"headers" :{
		"x-client-id" : Mule::p('local-market-sapi.client-id'),
		"x-client-secret" : Mule::p('secure::local-market-sapi.client-secret'),
		"x-correlation-id": vars.correlationId,
		"x-country-code": vars.countryCode
	},
	("queryParams":{
		externalID1: payload.externalID1,
		applicationNumber: payload.applicationNumber,
		includeBalancesheet: if(payload.role == "MainApplicant") "true" else "false",
		applicationFormProductID : payload.applicationFormProductID
	}) if(isCompany)
}
