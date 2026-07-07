%dw 2.0
output application/json indent=false

var assetClass= payload.data.assetClass
var assetBrand= payload.data.assetBrand
var assetType= payload.data.assetType
---
payload.data.assetModel map (item,index) ->{
  "model": {
    id: item.id,
    externalModelId : item.externalModelId,
    code : item.code,
    name : item.description,
    localDescription : item.localDescription,
    isActive: item.isActive,
    isSample: item.isSample,
    variantCode: item.variantCode,
    externalDescription: item.externalDescription,
    mpName: item.mpName,
    baumusterNumber: item.baumusterNumber,
    weight: item.weight,
    capacity: item.capacity,
    engineCc: item.engineCc,
    engineType: item.engineType.description,
    updatedOn: item.updatedOn,
    createdOn: item.createdOn,
    updatedBy: item.updatedBy,
    createdBy: item.createdBy,
    modelClass: (assetClass filter ($.id == item.assetClassId) map(class,index)->{
      externalCode: class.externalCode,
      description: class.description,
      isActive: class.isActive,
      externalDescription: class.externalDescription,
      updatedOn: class.updatedOn,
      createdOn: class.createdOn,
      updatedBy: class.updatedBy,
      createdBy: class.createdBy,
      modelBrand: (assetBrand filter($.id == class.brandId) map(brand,index) ->{
        externalCode: brand.externalCode,
        description: brand.description,
        localDescription: brand.localDescription,
        isActive: brand.isActive,
        createdOn: brand.createdOn,
        createdBy: brand.createdBy,
        modelType: (assetType filter($.id == brand.assetTypeId) map(assetType,index) ->{
          externalCode: assetType.externalCode,
          description: assetType.description,
          isActive: assetType.isActive
        }) reduce ($) 
      }) reduce ($) 
    }) reduce ($),
    horsepower: item.horsepower,
    indemnities: item.indemnities,
    bodyType: item.bodyType,
    modelType: item.modelType,
    range: item.range,
    modelYear: item.modelYear,
    nstCode: item.nstCode,
    vxModels: item.vxModels,
    modelYearCode: item.modelYearCode,
    changeYearCode: item.changeYearCode,
    baumusterGroupId: item.baumusterGroupId,
    technicalInformation: item.technicalInformation,
    "modelSource": item.source,
    bodyBuilders: item.bodyBuilderOptions map(bb,index) ->{
    	code: bb.code,
    	externalCode: bb.externalCode,
    	description: bb.description,
    	isActive: bb.isActive
    },
    

"modelOptions" : item.modelOptions map (options, index) ->
        
        {

            "code": options.code,
 "retailOptionPrices": options.retailOptionPrices map
        {
           ("price":{
            "amountExclusive": $.price
           }) if (!isEmpty($.price))
       }

       
    },
    ("basePrice":{
    	"price":{
            "amountExclusive": item.modelYears[0].assetPrices[0].basePrice
           }
    }) if (!isEmpty(item.modelYears[0].assetPrices[0].basePrice)),
    
    "lineCode": item.lineCode
  },
  "vehicles": item.associatedVins map (vin,index)->{
		"vin": vin.vinNumber,
		"basePrice": {
			"price":{
				"amountExclusive": vin.basePrice
			}
		},
		"retailOptionPrices": [{
			"price":{
				"amountExclusive": vin.dlOptionPrice
			}
		}]
	}
}