%dw 2.0
output application/json
var euMessage = read(vars.originalPayload.data.payload.EU_Message__c,"application/json")
--- 
if(euMessage.'Application Type' == "Private Individual") p('verify-aml.sapi.aml-check.person.path') else p('verify-aml.sapi.aml-check.company.path')