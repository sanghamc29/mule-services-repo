%dw 2.0
output application/json skipNullOn = "everywhere"
---
{
	"mbCustomerId": payload.mbCustomerId,
	"customerIdType": payload.customerIdType,
	"businessPartnerType": payload.businessPartnerType,
	"company": payload.company
}