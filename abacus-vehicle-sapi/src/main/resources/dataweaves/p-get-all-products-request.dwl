%dw 2.0
output application/json
---
{
	 quoteDate: payload.quoteDate,
	 (id: payload.campaignId) if (!isEmpty(payload.campaignId)),
      "asset": {
      	"conditionCode": payload.conditionCode,
		"ResolveAssetIdCriteria": {
			"VariantCode": payload.'modelCode',
			// This flag is to make sure, exact match with the variant code to happen in Abacus.
			"onlySelectOne": p('abacus.isExactVariantCodeMatch')
		}
	},
	
	("levelCode": payload.hierarchy) if (!isEmpty(payload.hierarchy)),
	("statuses": payload.statusCodes) if (!isEmpty(payload.statusCodes)),
	
	"productNodeSections": payload.sections,
	
	("ResolveBusinessPartnerIdCriteria": {
		"GsCode": payload.dealerOutletCode
	}) if(!isEmpty(payload.dealerOutletCode)),
	
	"classifications": (payload.classifications map {
		classificationType: $.'type',
		id: $.id
	}),
	"isBodyBuilderApplicable": payload.isBodyBuilder,
	"isInternalUser" : payload.isInternalUser
}