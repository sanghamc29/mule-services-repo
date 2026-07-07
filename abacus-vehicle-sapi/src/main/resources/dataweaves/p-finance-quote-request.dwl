%dw 2.0
output application/json
fun nullCheck(data)= data != "" and data !=null

---
{
    "quoteNumber":  vars.origPayload.quoteNumber,
    "quoteDate": vars.origPayload.quoteDate,
    "financeCode": vars.origPayload.financialCode,
    "includeExternalQuote": vars.origPayload.isExternalQuote,
    "expectedContractStartDate": vars.origPayload.expectedContractStartDate,
    "source": {
        "salesChannel": lower(vars.origPayload.salesChannel),
         "dealerRegionCode": vars.origPayload.dealerRegionCode,
        "resolveBusinessPartnerIdCriteria":{
            "gsCode": vars.origPayload.gsCode
        },
        "userRoleOverrides": [
             {
                "roleCode": vars.origPayload.roleCode
            }
        ],
        "marketCode": vars.origPayload.marketCode,
        "currencyCode": vars.origPayload.currencyCode,
        "vatSegmentId" : vars.origPayload.vatSegmentId,
    },
    "fundedItems": vars.origPayload.fundedItems map (item,index) ->{
            "zipCode": item.zipCode,
            "productNodeId": item.campaignId as Number,
            "financeParameters": {
                "period": item.financeParameters.period,
                (dealershipDiscount: {
                    "amountExclusive": item.financeParameters.dealershipDiscount.amountExclusive default null,
                    "pct": item.financeParameters.dealershipDiscount.pct default null,
                    "pegOnAmount": if (nullCheck(item.financeParameters.dealershipDiscount.amountExclusive)) true else false
                }) if (! isEmpty(item.financeParameters.dealershipDiscount)),
                "interestRatePct": item.financeParameters.interestRatePct,
                "useVariableInterestRate": item.financeParameters.useVariableInterestRate,
                (downPayment: {
                    "amountInclusive": item.financeParameters.downPayment.amountInclusive default null,
                    "amountExclusive": item.financeParameters.downPayment.amountExclusive default null,
                    "pct": item.financeParameters.downPayment.pct default null,
                    "pegOnAmount": if (nullCheck(item.financeParameters.downPayment.amountInclusive) or nullCheck(item.financeParameters.downPayment.amountExclusive)) true else false
                }) if (! isEmpty(item.financeParameters.downPayment)),
                "paymentDay": item.financeParameters.paymentDay,
                ("governmentGrants": {
                    "amountExclusive": item.financeParameters.governmentGrants.amountExclusive default null
                }) if (! isEmpty(item.financeParameters.governmentGrants))
            },
          bundles: item.bundles map (bundle, index) ->{  
          "bundleTypeCode": bundle.bundleCode,
          "isFunded": bundle.isFunded,
                 "selectedWaiveOption": bundle.selectedWaiveOption,
                  "additionalAttributes": bundle.additionalAttributes map (addAttributes,index) -> {                
                        "code": addAttributes.code,
                        "value": addAttributes.value
                    },
           (bundleSubtotal:{
                    	overrideAmount: {
                            "amountInclusive": bundle.subTotal.amountInclusive,
                            "amountExclusive": bundle.subTotal.amountExclusive
                       }
                    }) if ((!isEmpty(bundle.subTotal.amountInclusive) or !isEmpty (bundle.subTotal.amountExclusive)))
          
        },
            "classifications": item.classifications map(classification,index)->{
                "id": classification.id,
                "classificationType": classification."type"
            },
            "vehicle": {
                "startingMileage": item.vehicle.mileage,
                "provinceOfRegistrationCode": item.vehicle.provinceOfRegistration,
                "usageCode": item.vehicle.usageCode,
                "firstRegistrationDate": item.vehicle.firstRegistrationDate,
                "conditionCode": item.vehicle.conditionCode,
                "options": item.vehicle.options,
                "vehicleVin": item.vehicle.vin,
                "transportingType": item.vehicle.transportingType,
                "vehicleLicensePlate": item.vehicle.licensePlate,
                "vehicleCharges": {
        			"standardDeliveryCosts" : item.vehicle.vehicleCharges.standardDeliveryCosts,
        	 		"ecv": item.vehicle.vehicleCharges.ecv,
            		"isv": item.vehicle.vehicleCharges.isv,
            		("registrationTaxable": item.vehicle.vehicleCharges.registrationTaxableAmount) if (! isEmpty(item.vehicle.vehicleCharges.registrationTaxableAmount)),
            		("registrationExemption": item.vehicle.vehicleCharges.registrationExemptAmount)	if (! isEmpty(item.vehicle.vehicleCharges.registrationExemptAmount))
        		},
                  "resolveAssetIdCriteria": {
                    "variantCode": item.vehicle.modelCode,
                    // This flag is to make sure, exact match with the variant code to happen in Abacus. 
                    "onlySelectOne": p('abacus.isExactVariantCodeMatch')
                  },
                "endValue": {
                    (value: {
                    "amountInclusive": item.vehicle.endValue.value.amountInclusive default null,
                    "amountExclusive": item.vehicle.endValue.value.amountExclusive default null,
                    "pct": item.vehicle.endValue.value.pct default null,
                    "pegOnAmount": if (nullCheck(item.vehicle.endValue.value.amountInclusive) or nullCheck(item.vehicle.endValue.value.amountExclusive)) true else false
                }) if (! isEmpty(item.vehicle.endValue.value)),
                
                "mileagePerYear": item.vehicle.endValue.mileagePerYear
                },
                "expectedRegistrationDate": item.vehicle.expectedRegistrationDate,
                "price": item.vehicle.price,
                "priceInfo": item.vehicle.priceInfo,
                //Body Builder Options are added in request mapping
                "bodyBuilderOptions": item.vehicle.bodyBuilderOptions map{ 
                	uniqueId: $.uniqueId,              	
                	code: $.code,
                	price:{
                	amountExclusive: $.price.amountExclusive
                	
                	} 	
                }
            },
            "quantity": item.quantity,
            "commission": {
                "commissionLevelCode": item.commissionLevelCode
            }
        
    },
    "useFinalSubmission" : vars.origPayload.useFinalSubmission
}