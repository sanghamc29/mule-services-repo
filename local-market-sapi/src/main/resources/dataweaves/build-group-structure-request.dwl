%dw 2.0
output application/json
---
{
	businessPartners: payload.companyId map ((item, index) -> {
		"addresses": [{
			"countryCode": payload.countryCode
		}],
		"companyDisclosure": {
			"companyId": item,
			"vatId": payload.nifId[index]
		}
	})
}