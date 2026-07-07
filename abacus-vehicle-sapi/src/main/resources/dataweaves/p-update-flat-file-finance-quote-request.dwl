%dw 2.0
import * from dw::util::Values
import * from dw::core::Objects
output application/json

var origPayload = vars.origPayload

var updateDownPayment = 

downPayment: origPayload.data.request.fundedItems[0].financeParameters.downPayment mergeWith (
    
    
    if (origPayload.data.request.fundedItems[0].financeParameters.downPayment == null 
    	or isEmpty(origPayload.data.request.fundedItems[0].financeParameters.downPayment)
    )
	  {  
	    "amountInclusive": origPayload.data.fundedItems[0].financeParameters.downPayment.amountInclusive,
	    ("pegOnAmount": true) if (isEmpty(origPayload.data.request.fundedItems[0].financeParameters.downPayment.pegOnAmount))
	  }	
  	
  	else 
  {
  	 ("amountInclusive": origPayload.data.fundedItems[0].financeParameters.downPayment.amountInclusive) 
    	if (origPayload.data.request.fundedItems[0].financeParameters.downPayment.amountInclusive != null),
    
    (pct: origPayload.data.fundedItems[0].financeParameters.downPayment.pct) if (origPayload.data.request.fundedItems[0].financeParameters.downPayment.pct != null
    or !isEmpty(origPayload.data.request.fundedItems[0].financeParameters.downPayment.pct)
    )
    
  }	
  	
)


var updateEndValue = 

origPayload.data.request.fundedItems[0].vehicle.endValue.value mergeWith (


	if( origPayload.data.request.fundedItems[0].vehicle.endValue.value == null
		or isEmpty(origPayload.data.request.fundedItems[0].vehicle.endValue.value)
	)
	{
		"amountInclusive": origPayload.data.fundedItems[0].asset.endValue.value.amountInclusive,
		("pegOnAmount": true)  if (isEmpty(origPayload.data.request.fundedItems[0].vehicle.endValue.value.pegOnAmount))
 			
	}

	else
	{
    ("amountInclusive": origPayload.data.fundedItems[0].asset.endValue.value.amountInclusive) 
    	if (origPayload.data.request.fundedItems[0].vehicle.endValue.value.amountInclusive != null) ,
    ("pct": origPayload.data.fundedItems[0].asset.endValue.value.pct default null) if (origPayload.data.request.fundedItems[0].vehicle.endValue.value.pct != null
    	or !isEmpty(origPayload.data.request.fundedItems[0].vehicle.endValue.value.pct)
    )
}


)

var latestEndValue = 

endValue: 

if(isEmpty(origPayload.data.request.fundedItems[0].vehicle.endValue)) 

{ value : updateEndValue }

else 

origPayload.data.request.fundedItems[0].vehicle.endValue update "value" with updateEndValue


var interestRatePct =

 interestRatePct: origPayload.data.fundedItems[0].financeParameters.interestRate 


var updatedFinanceParameters = {
	
	financeParameters:(origPayload.data.request.fundedItems[0].financeParameters - "interestRatePct" - "downPayment") ++ updateDownPayment  ++ interestRatePct}

var updatedVehicle =  {
	
	vehicle: (origPayload.data.request.fundedItems[0].vehicle - "endValue" ) ++ latestEndValue }

var updateFundedItems = 
	fundedItems: origPayload.data.request.fundedItems map {(
		($ - "financeParameters" - "vehicle") ++ updatedFinanceParameters ++ updatedVehicle
    )}
--- 

(origPayload.data.request - 'fundedItems') ++ updateFundedItems


