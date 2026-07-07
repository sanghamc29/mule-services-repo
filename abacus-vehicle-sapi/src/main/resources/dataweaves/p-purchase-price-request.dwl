%dw 2.0
output application/json
fun nullCheck(data) = data != "" and data != null and !(isEmpty(data))
---
{
    "vatSegmentId": vars.origPayload.vatSegmentId,
    "expectedRegistrationDate": vars.origPayload.expectedRegistrationDate,
    "currencyCode": vars.origPayload.currencyCode,
    "productTypeName": vars.origPayload.productTypeName,
    "productTypeCode": vars.origPayload.productTypeCode,
    "dealerRegionCode": vars.origPayload.dealerRegionCode,
    "vehicle": {   
        "conditionCode": vars.origPayload.conditionCode,
        "provinceOfRegistrationCode": vars.origPayload.provinceOfRegistration,
        "usageCode": vars.origPayload.usageCode,
        "startingMileage": vars.origPayload.mileage,
        "firstRegistrationDate": vars.origPayload.firstRegistrationDate,
        "vehicleVin": vars.origPayload.vin,
        "transportingType": vars.origPayload.transportingType,
	("price":vars.origPayload.price) if nullCheck(vars.origPayload.price),
        ("priceInfo":vars.origpayload.priceInfo) if nullCheck(vars.origpayload.priceInfo),
        ("bodybuilderOptions": vars.origPayload.bodyBuilderOptions map (item,index) ->{
        	"uniqueId": item.uniqueId,
        	"code": item.code,
            "price": {
              "amountExclusive": item.price.amountExclusive
            }
        }) if nullCheck(vars.origPayload.bodyBuilderOptions),
        "resolveAssetIdCriteria": {
           "variantCode": vars.origPayload.modelCode,
           // This flag is to make sure, exact match with the variant code to happen in Abacus.
           "onlySelectOne": p('abacus.isExactVariantCodeMatch')
        }, 
        "options": vars.origPayload.options,
        "vehicleCharges": {
        	"standardDeliveryCosts" : vars.origPayload.vehicleCharges.standardDeliveryCosts,
        	 "ecv": vars.origPayload.vehicleCharges.ecv,
            "isv": vars.origPayload.vehicleCharges.isv,
            ("registrationTaxable": vars.origPayload.vehicleCharges.registrationTaxable) if (!isEmpty(vars.origPayload.vehicleCharges.registrationTaxable)),
            ("registrationExemption": vars.origPayload.vehicleCharges.registrationExempt) if (!isEmpty(vars.origPayload.vehicleCharges.registrationExempt))
        }
    },
    ("dealershipDiscount": vars.origPayload.dealershipDiscount) if (! isEmpty(vars.origPayload.dealershipDiscount)),
    "classifications": vars.origPayload.classifications map (item,index) ->{
    	"id": item.id,
    	"classificationType": item.'type'
    },
    ("quantity": vars.origPayload.quantity) if(!isEmpty(vars.origPayload.quantity))
}
