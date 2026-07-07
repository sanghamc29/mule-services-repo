%dw 2.0
output application/json indent=false
---
{
    "data": {
   		"quoteNumber": payload.data.quoteNumber,
   		"quoteDate": payload.data.quoteDate,
   		"version": payload.data.version,
   		"dealership": payload.data.dealership,
   		"showroom": payload.data.showroom,
   		"fundedItems": payload.data.fundedItems,
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
   		"financeCode": payload.data.financeCode,
   		"quoteDates": {
   			"expectedContractStartDate" : payload.data.request.expectedContractStartDate,
   			"expectedRegistrationDate" : payload.data.request.fundedItems[0].vehicle.expectedRegistrationDate,
   			"firstRegistrationDate" : payload.data.request.fundedItems[0].vehicle.firstRegistrationDate,
   			"manufactureDate" : payload.data.request.fundedItems[0].vehicle.manufactureDate
   		}
    }  
 }