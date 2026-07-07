%dw 2.0
import p from Mule
output application/json indent=false

//Capture payload in a local variable
var data = payload.data default []

// List down default sections that doesn't need master lookup
var defaultSections = p('campaign.sections') splitBy ","


// Function to return section data as is - for default sections
fun commonSection(sections) = sections


// Function to combine bundle groups and types
fun BundleTypeGroupSection(sections, productNodes) = {
	
     
	bundleGroups: sections.bundleTypeGroupIds map (
		
		do{
			var bundleId = $
			var bundles = productNodes.bundleTypeGroups filter ($.id == bundleId)
			---
		
		{
			bundleGroupCode: bundles[0].externalCode,
			bundleGroupName: bundles[0].name,
			bundleTypes: flatten(bundles[0].bundleTypeCodes map (
				do {
					var bundleTypeCode = $
					---
					(productNodes.bundleTypes filter ($.code == bundleTypeCode))
					}
				
			))
		
		}
		
	}	
  )
}

// Function to combine business types
fun BusinessTypeSection(sections, productNodes) = {
	
	businessTypes: flatten(sections.businessTypeCodes map (
		
		do{
			var businessTypeCode = $
			---
		
		(productNodes.businessTypes filter ($.externalCode == businessTypeCode))
		
	}	
  ))
}

// Function to combine asset conditions
fun AssetConditionSection(sections, productNodes) = {
	
	assetConditions: flatten(sections.assetConditionCodes map (
		
		do{
			var assetConditionCode = $
			---
		
		(productNodes.assetConditions filter ($.externalCode == assetConditionCode))
		
	}	
  ))
}

// Function to combine asset types
fun AssetTypeSection(sections, productNodes) = {
	
	assetTypes: flatten(sections.assetTypeCodes map (
		
		do{
			var assetTypeCode = $
			---
		
		(productNodes.assetTypes filter ($.externalCode == assetTypeCode))
		
	}	
  ))
}

// Function to combine package types

fun PackageTypeSection(sections, productNodes) = {
	
	packageTypes: flatten(sections.packageTypeCodes map (
		
		do{
			var packageTypeCode = $
			---
		
		(productNodes.packageTypes filter ($.externalCode == packageTypeCode))
		
	}	
  ))
}

// Function to combine retention types
fun RetentionTypeSection(sections, productNodes) = {
	
	retentionTypes: flatten(sections.retentionTypeCodes map (
		
		do{
			var retentionTypeCode = $
			---
		
		(productNodes.retentionTypes filter ($.externalCode == retentionTypeCode))
		
	}	
  ))
}

// Function to combine commission Rails

fun CommissionSection(sections, productNodes) = {
	
	
		
		(productNodes.commissionRails filter ($.commissionRailId == sections.commissionRailId ))
		
	
}


---

// Product Type mapping
data.productNodes filter ($.levelCode == "PT") map 
(
    
   do
    {
        var productType = $
        
        ---	
        {
    	productTypeCode: productType.basicInformation.externalCode,
    	status: productType.status as String,
    	assetModelCode: vars.modelCode,
    	productTypeId: productType.id,
    	basicInfo: {
    		name: productType.basicInformation.name,
    		description: productType.basicInformation.description,
    		effectiveDate: productType.basicInformation.effectiveDate,
    		expiryDate: productType.basicInformation.expiryDate,
            businessRulesId: productType.basicInformation.businessRulesId,
            status: productType.basicInformation.status as String,
            fundingTypeId: productType.basicInformation.fundingTypeId,
            dateComparison: productType.basicInformation.dateComparison,
            finalSubmissionDate: productType.basicInformation.finalSubmissionDate,
            externalCode: productType.basicInformation.externalCode,
            translations: productType.basicInformation.translations,
            createdOn: productType.basicInformation.createdOn,
            createdBy: productType.basicInformation.createdBy,
            updatedOn: productType.basicInformation.updatedOn,
            updatedBy: productType.basicInformation.updatedBy
    	},
    	// Products Mapping
    	products: data.productNodes filter ($.parentId == productType.id and $.levelCode == "P") map 
		    		
		(
			do
		     {
		        var product = $
		        
		        ---	
		        {
		    	productCode: product.basicInformation.externalCode,
		    	status: product.status as String,
		    	assetModelCode: vars.modelCode,
		    	productId:product.id,
		    	productTypeName: productType.basicInformation.name,
		    	basicInfo: {
		    		name: product.basicInformation.name,
		    		description: product.basicInformation.description,
		    		effectiveDate: product.basicInformation.effectiveDate,
		    		expiryDate: product.basicInformation.expiryDate,
		            businessRulesId: product.basicInformation.businessRulesId,
		            status: product.basicInformation.status as String,
		            fundingTypeId: product.basicInformation.fundingTypeId,
		            dateComparison: product.basicInformation.dateComparison,
		            finalSubmissionDate: product.basicInformation.finalSubmissionDate,
		            externalCode: product.basicInformation.externalCode,
		            subExternalCode: product.basicInformation.subExternalCode,
		            translations: product.basicInformation.translations,
		            createdOn: product.basicInformation.createdOn,
		            createdBy: product.basicInformation.createdBy,
		            updatedOn: product.basicInformation.updatedOn,
		            updatedBy: product.basicInformation.updatedBy
		    	},
		    	
		    	// Start of Campaign Mapping
		    	
		    	campaigns: data.productNodes filter ($.parentId == product.id and $.levelCode == "C") map 
		    	
		    	(
		    		do{
		    			var campaign = $
		    			---
		    			{
		    				campaignCode: campaign.basicInformation.externalCode,
					    	status: campaign.status as String,
					    	assetModelCode: vars.modelCode,
					    	campaignId: campaign.id,
					    	productName: product.basicInformation.name,
					    	basicInfo: {
					    		name: campaign.basicInformation.name,
					    		description: campaign.basicInformation.description,
					    		effectiveDate: campaign.basicInformation.effectiveDate,
					    		expiryDate: campaign.basicInformation.expiryDate,
					            businessRulesId: campaign.basicInformation.businessRulesId,
					            status: campaign.basicInformation.status as String,
					            fundingTypeId: campaign.basicInformation.fundingTypeId,
					            dateComparison: campaign.basicInformation.dateComparison,
					            finalSubmissionDate: campaign.basicInformation.finalSubmissionDate,
					            externalCode: campaign.basicInformation.externalCode,
					            subExternalCode: campaign.basicInformation.subExternalCode,
					            translations: campaign.basicInformation.translations,
					            createdOn: campaign.basicInformation.createdOn,
					            createdBy: campaign.basicInformation.createdBy,
					            updatedOn: campaign.basicInformation.updatedOn,
					            updatedBy: campaign.basicInformation.updatedBy
                            },
                            
                            // Sections Mapping
					            sections: campaign.sections map (
                                    do{
                                        var section = $.componentSection
                                        ---
                                        
                                        if(defaultSections contains section)
										commonSection($)
                                           
                                            else if(section == "BundleTypeGroupSection")
                                            ($ - "bundleTypeGroupIds" - "bundleTypeGroupCodes") ++  BundleTypeGroupSection($,data)
                                            
                                            else if(section == "BusinessTypeSection")
                                            ($ - "businessTypeIds" - "businessTypeCodes") ++ BusinessTypeSection($,data)
                                            
                                            else if(section == "AssetConditionSection")
                                            ($ - "assetConditions" - "assetConditionCodes") ++ AssetConditionSection($,data)
                                            
                                            else if(section == "AssetTypeSection")
                                            ($ - "assetTypes" - "assetTypeCodes") ++ AssetTypeSection($,data)
                                            
                                            else if(section == "PackageTypeSection")
                                            ($ - "packageTypeIds" - "packageTypeCodes") ++ PackageTypeSection($,data)
                                            
                                            else if(section == "RetentionTypeSection")
                                            ($ - "retentionTypeIds" - "retentionTypeCodes") ++ RetentionTypeSection($,data)
                                            
                                            else if(section == "CommissionSection")
                                              ($ - "commissionRailId") ++ CommissionSection($,data)
                                            
                                            else
                                            {}
                                            
                                        
                                        }
                                        )
		    				
		    			}	// End of Campaign
		    		} // Campaign Do End
		    	)
		    		
		    		
		    	} // End of Product
    	}) // End of Product Do Block
	} // End of Product Type
 }) // End of Product Type Do block
