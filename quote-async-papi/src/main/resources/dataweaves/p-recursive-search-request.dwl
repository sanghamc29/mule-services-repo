%dw 2.0
output application/json skipNullOn="everywhere"
---
{
      quoteDate: vars.fqSummaryResponse.data.quoteDate,
      modelCode: vars.fqSummaryResponse.data.fundedItems[0].asset.variantCode,
      classifications: vars.fqSummaryResponse.data.fundedItems[0].classifications,
      campaignId: vars.fqSummaryResponse.data.fundedItems[0].productNodeId,
      dealerOutletCode: vars.applnPayload.dealer.outletId,
      sections:Mule::p('campaign.sections') splitBy","
}