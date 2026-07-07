%dw 2.0
output application/json
---
{
  "action"				: "affordabilityCalculation",
  "externalID1"			: attributes.queryParams.externalID1,
  "includeBalancesheet"	: attributes.queryParams.includeBalancesheet as Boolean,
  "applicationNumber"	: attributes.queryParams.applicationNumber,
  "applicationFormProductID" :  attributes.queryParams.applicationFormProductID
}