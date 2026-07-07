%dw 2.0
fun fraudCheckNonIndividuals(customerInfo) =
{
  "applicationNumber": customerInfo.applicationNumber,
  "role": customerInfo.role,
  "ExternalID1": customerInfo.individualPerson.customerNumber,
  "CustomerCategory": customerInfo.customerType,
  "callingLegalEntity": customerInfo.legalEntity,
 "companyDetails":{  
"taxId": customerInfo.marketUniqueId
}
}
