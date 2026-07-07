%dw 2.0
output application/json
import fraudCheckIndividual from dataweaves::buildC5IndividualRequest
import fraudCheckNonIndividuals from dataweaves::buildC5NonIndividualRequest
import cleanPhoneNumber from dataweaves::buildC5IndividualRequest
import cleanPayload from dataweaves::payloadCleanup
import getTranslatedValueFromLabelToAPIValue from dataweaves::euLocalizationModule
var houseNumberTranslated = getTranslatedValueFromLabelToAPIValue(vars.enums,p('translation.houseNumber.originalValue'),p('translation.houseNumber.nodeName'),p('translation.houseNumber.serviceName'))
---
if (payload.customerInfo.customerType == "Individual")
  cleanPayload(fraudCheckIndividual(payload.customerInfo,[p('translation.houseNumber.originalValue'),houseNumberTranslated],vars.enums,p('translation.C5.incomeDocumentType.nodeName'),p('translation.C5.incomeDocumentType.serviceName')))
else 
  cleanPayload(fraudCheckNonIndividuals(payload.customerInfo))
