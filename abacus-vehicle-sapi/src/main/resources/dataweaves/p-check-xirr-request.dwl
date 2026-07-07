%dw 2.0
import * from dw::util::Values
import * from dw::core::Objects
output application/json

var origPayload = vars.origPayload


--- 
{
    "effectiveDate": now(),
    "financedAmount": {
        "amountInclusive": origPayload.data.fundedItems[0].financeSummary.totalFinancedAmountWithHiddenDiscounts.amountInclusive

    },
    "assetConditionCode": origPayload.data.fundedItems[0].asset.conditionCode,
    "purchasePrice": {
        "amountExclusive": origPayload.data.fundedItems[0].vehiclePurchasePrice.totalPurchasePrice.amountExclusive
    },
    "calculatedXirr1": origPayload.data.fundedItems[0].financeParameters.xirr1,
    "calculatedXirr2": origPayload.data.fundedItems[0].financeParameters.xirr2,
    "campaignId":  origPayload.data.fundedItems[0].productNodeId,
    ("variableInterestRate": origPayload.data.fundedItems[0].financeParameters.variableInterestRatePct) if(vars.interestRateType == p('interestType.euribor'))

}


