%dw 2.0

import p from Mule

fun purchasePrice(purchasePrice) = (if(!isEmpty(purchasePriceMapping(purchasePrice))) purchasePriceMapping(purchasePrice) else {})  ++ (if(!isEmpty(purchasePrice.quantityPurchasePriceSummary)) ("aggregatePriceSummary": purchasePriceMapping(purchasePrice.quantityPurchasePriceSummary)) else {})

fun purchasePriceMapping(purchasePrice) = {
    "basePrice": purchasePrice.basePrice,
    "manufacturerOptions": purchasePrice.manufacturerOptions,
    "dealerOptions": purchasePrice.dealerOptions,
    "totalPurchasePrice": purchasePrice.totalPurchasePrice,
    "usedTotalPurchasePrice": purchasePrice.usedTotalPurchasePrice,
    "purchasePriceWithoutBpm": purchasePrice.purchasePriceWithoutBpm,
    "vehicleCharges": {
	    "registrationTax": purchasePrice.vehicleCharges.ipt,
	    "registrationTaxable": purchasePrice.vehicleCharges.registrationTaxable,
	    "registrationExempt": purchasePrice.vehicleCharges.registrationExemption
	},
    "totalListPrice": purchasePrice.listPriceInclManufacturerOptionsAndIsvAndEco,
    "totalBodybuilderOptionsPrice": purchasePrice.totalBodybuilderOptionsPrice,
    "bodybuilderOptions": purchasePrice.bodybuilderOptions map $ ,
    "totalRegistrationTaxAmount": purchasePrice.totalRegistrationTaxAmount,
    "dealershipDiscount": purchasePrice.dealershipDiscount,
    "totalVehiclePurchasePrice": purchasePrice.totalPurchasePriceExcludingBodyBuilderOptions
}