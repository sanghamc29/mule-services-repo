%dw 2.0
import * from dw::core::Objects
output application/json skipNullOn="everywhere"
var bundles = (vars.recursiveResponse[0].products[0].campaigns[0].sections filter ($."componentSection" == "BundleTypeGroupSection"))
var allBundleTypes = flatten(bundles[0].bundleGroups.bundleTypes)
---
{
	customer: vars.applnPayload.customer,
	product: vars.recursiveResponse[0] update {
	
 case .products[0].campaigns[0].sections -> $ filter ($.componentSection != "BundleTypeGroupSection")
},
	financeInfo: 
	
	vars.fqSummaryResponse update {
	
 case .data -> ($ - 'dealership' - 'showroom' - 'mergedFinanceSummary') update {
     case .fundedItems[0] -> ($ - 'paymentSchedule' - 'quantityPaymentSchedule' - 'bundles' - 'quantityFinanceSummary')
 }
},
	bundles: vars.fqSummaryResponse.data.fundedItems[0].bundles map 
	do{
		var bundle = $
		var totalBundle = (allBundleTypes filter $.id == bundle.bundleTypeId)[0]
		---
		{
			  "bundleTypeCode": bundle.bundleTypeCode,
		      "bundleTypeExternalCode": bundle.bundleTypeExternalCode,
		      "isFunded": bundle.isFunded,
		      "name": totalBundle.name,
		      "localName": totalBundle.localName,
		      "subtotal": bundle.subtotal,
		      "paymentOption": totalBundle.paymentOption,
      		  "waiveOptions": totalBundle.waiveOptions,
      		  dynamicValues: bundle.dynamicValues map {
      		  	label: $.value,
				value: $.key
      		  },
      		  additionalAttributes: bundle.additionalAttributes map
      		  
      		  do{
      		  	var attribute = $
      		  	var totalAddAttributes = (totalBundle.additionalAttributes filter $.code == attribute.code)[0]
      		  
	      		  ---
	      		  
	      		  {
	      		  	  "code": $.code,
	      		  	  value: $.value,
			          "displayName": totalAddAttributes.displayName,
			          "attributeType": totalAddAttributes.attributeType
	      		  }
      		  },
      		  bundleTypeCategories: bundle.bundleTypeCategories,
      		  bundlePeriods: bundle.bundlePeriods
		      
			
		}
	}
}
