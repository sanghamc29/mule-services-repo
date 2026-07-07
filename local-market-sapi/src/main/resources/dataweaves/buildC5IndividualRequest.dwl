%dw 2.0
import extractStreet,extractHouseNumber from dataweaves::houseNumberAndStreetAddress
import getTranslatedValueFromLabelToAPIValue from dataweaves::euLocalizationModule
fun fraudCheckIndividual(customerInfo, houseNumberLabels ,enums,incomeDocumentTypeNodeName,incomeDocumentTypeServiceName) =
{
  applicationNumber: customerInfo.applicationNumber,
  callingLegalEntity: customerInfo.legalEntity,
  role: customerInfo.role,
    ExternalID1: customerInfo.individualPerson.customerNumber,
    CustomerCategory:customerInfo.customerType,
    FinancialProductCode : customerInfo.customerFinanceInfo.financingType,


Companydetails: {
  	(roleOfPerson: customerInfo.roleFromBusinessType)if(customerInfo.role == "Other"),
    firstName: customerInfo.individualPerson.firstName,
    lastName: customerInfo.individualPerson.lastName,
    gender: customerInfo.individualPerson.gender,
    dateOfBirth: customerInfo.individualPerson.birthDate,
    placeOfBirth: customerInfo.individualPerson.placeOfBirth,
    provinceCodeOfBirth: customerInfo.individualPerson.countryOfBirth,
    professionSince: if(customerInfo.customerType == "Individual")customerInfo.startOfBusinessDate else  customerInfo.establishmentDate ,
    activityCode: customerInfo.affiliatedCompany.industryClassification,
	taxId: customerInfo.marketUniqueId,
    socialInsuranceId: customerInfo.individualPerson.personIdentifications[0].identificationNumber,
	legalEntity: customerInfo.legalEntity ,
    contactDetails: [
      {
        homePhone: {
          (phoneNumber:  cleanPhoneNumber(customerInfo.phoneNumbers[0].number)) if(customerInfo.phoneNumbers[0].number != null)
        }
      }
    ],
    (bankAccount : {
    	iban: customerInfo.bankAccounts[0].bankAccountId
    })if(customerInfo.role == "MainApplicant"),
    
    addresses: customerInfo.addresses default [] map (addr) -> {
       
      street: extractStreet(addr.address,houseNumberLabels),
      houseNumber: extractHouseNumber(addr.address,houseNumberLabels) ,
      city: addr.city,
      zipcode: addr.postalCode,
      provinceCodeOfBirth: addr.country,
      CountyID: addr.country
    }
  },

  (personMainApplicant: { 
    firstName: customerInfo.relatedToMainApplicant.firstName,
    lastName: customerInfo.relatedToMainApplicant.lastName,
    gender: customerInfo.relatedToMainApplicant.gender,
    dateOfBirth: customerInfo.relatedToMainApplicant.birthDate,
    placeOfBirth: customerInfo.relatedToMainApplicant.placeOfBirth,
    provinceCodeOfBirth: customerInfo.relatedToMainApplicant.countryOfBirth,
    taxId: customerInfo.affiliatedCompany.companyId,
    (vatId: customerInfo.relatedToMainApplicant.companyInfo.vatNumber)if(customerInfo.relatedToMainApplicant.customerCategory != "Individual"),
    companyName: customerInfo.relatedToMainApplicant.companyInfo.companyName,
    CustomerCategory :customerInfo.relatedToMainApplicant.customerCategory,
    iban : customerInfo.relatedToMainApplicant.bankAccounts[0].bankAccountId,
    addresses : [    {
        CountyID: customerInfo.relatedToMainApplicant.country
      }]
  })if(customerInfo.role != "MainApplicant"),

  financialInformation: {
    annualRevenue: customerInfo.customerFinanceInfo.annualRevenue,
    (dateProofOfIncome: "01-" ++ customerInfo.customerFinanceInfo.incomeDocumetMonth ++ "-" ++ customerInfo.customerFinanceInfo.incomeDocumetYear)if(customerInfo.customerFinanceInfo.incomeDocumetMonth != null and customerInfo.customerFinanceInfo.incomeDocumetYear != null) ,
    totalIncome: customerInfo.customerFinanceInfo.annualIncome,
    (doctype: getTranslatedValueFromLabelToAPIValue(enums,customerInfo.customerFinanceInfo.incomeDocumetType,incomeDocumentTypeNodeName,incomeDocumentTypeServiceName))if(customerInfo.customerFinanceInfo.incomeDocumetType != null)
  },

  creditInformation: {
    installments: customerInfo.customerFinanceInfo.installments,
    financingType: customerInfo.customerFinanceInfo.financingType, //remove this and test
    assetCondition: customerInfo.customerFinanceInfo.assetCondition,
    totalAmountApplication: customerInfo.customerFinanceInfo.totalAmountOfCreditInclusiveVAT  
                            default customerInfo.customerFinanceInfo.totalAmountOfCreditExclusiveVAT,
    residualValue: customerInfo.customerFinanceInfo.residualValueInclusiveVAT 
                   default customerInfo.customerFinanceInfo.residualValueExclusiveVAT,
    downPayment: customerInfo.customerFinanceInfo.downPaymentInclusiveVAT 
                 default customerInfo.customerFinanceInfo.downPaymentExclusiveVAT,
    financedAmount: customerInfo.customerFinanceInfo.financedAmountInclusiveVAT 
                    default customerInfo.customerFinanceInfo.financedAmountExclusiveVAT
  },

  identificationInformation: {
    documentType: customerInfo.documents[0].docTypeName,
    documentID: customerInfo.documents[0].referenceNo,
    issueDate: customerInfo.documents[0].creationDate, 
    expiryDate: customerInfo.documents[0].expiryDate 
  }
}

fun cleanPhoneNumber(phone: String) = (phone default "") replace /(\+\d{1,3})/ with "" replace " " with ""
