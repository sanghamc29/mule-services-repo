%dw 2.0
import * from dw::util::Values
import * from dw::core::Binaries
import purchasePrice from dataweaves::modules::purchasePriceResponse

output application/json indent=false

var vehiclePurchasePrice = purchasePrice(payload.data.fundedItems[0].vehiclePurchasePrice)
---
  {
   		"quoteNumber": payload.data.quoteNumber,
   		"quoteDate": payload.data.quoteDate,
   		"version": payload.data.version,
   		"dealership": payload.data.dealership,
   		"showroom": payload.data.showroom,
   		"fundedItems":  payload.data.fundedItems update {
 	     case [0].vehiclePurchasePrice -> vehiclePurchasePrice
         },
   		"status": payload.data.status,
   		"exchangeRates": payload.data.exchangeRates,
   		"externalQuote": payload.data.externalQuote,
   		"mergedPaymentSchedule": payload.data.mergedPaymentSchedule,
   		"fundingType": payload.data.fundingType,
   		"indirectTaxPct": payload.data.indirectTaxPct,
   		"vehicleIndirectTaxPct": payload.data.vehicleIndirectTaxPct,
   		"bundleIndirectTaxPct": payload.data.bundleIndirectTaxPct,
   		"euribor": payload.data.euribor,
   		"mergedFinanceSummary": payload.data.mergedFinanceSummary,
   		"financeCode": payload.data.financeCode
 } 
 