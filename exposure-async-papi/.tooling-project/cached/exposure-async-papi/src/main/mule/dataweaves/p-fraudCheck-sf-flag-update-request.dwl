%dw 2.0
output application/json
var fraudCheckFailed = vars.fraudCheckFailed default false
var redeliveryExhausted = vars.redeliveryExhausted default false
---
(vars.fraudCheckData filter 
	($.customerType == Mule::p('fraudCheck.individual')) 
	and (not (fraudCheckFailed and isEmpty($.fraudIndicator)))
    and (not (fraudCheckFailed and $.isSuccessful))
) map (item) -> {
	
 	"applicantId": item.customerNumber,
	"fraudCheckStatus": if (item.isSuccessful and not redeliveryExhausted) item.fraudIndicator as String else Mule::p('fraudCheck.default.fraudCheckStatus'),
	"finalFraudCheckRate": if (item.isSuccessful and not redeliveryExhausted) item.finalFraudAlert as String else Mule::p('fraudCheck.default.finalFraudCheckRate'),
	"semaphoreFlagStatus": if (item.isSuccessful and not redeliveryExhausted) item.semaforoScipafi as String else Mule::p('fraudCheck.default.semaphoreFlagStatus'),
	("scipafiFraudCode": Mule::p('fraudCheck.default.scipafiFraudCode'))if(item.errorMessage contains Mule::p('fraudCheck.errorCode'))
  
} 
