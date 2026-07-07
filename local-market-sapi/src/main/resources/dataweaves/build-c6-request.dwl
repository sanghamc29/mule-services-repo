%dw 2.0
import * from dw::core::Strings
import cleanPayload from dataweaves::payloadCleanup
import extractStreet,extractHouseNumber from dataweaves::houseNumberAndStreetAddress
fun isBusiness(customerType) = (customerType == Mule::p('lomapi.agencyData.businessCustomerType'))
import getTranslatedValueFromLabelToAPIValue from dataweaves::euLocalizationModule
var houseNumberTranslated = getTranslatedValueFromLabelToAPIValue(vars.enums,p('translation.houseNumber.originalValue'),p('translation.houseNumber.nodeName'),p('translation.houseNumber.serviceName'))
output application/json skipNullOn = "everywhere"
---
cleanPayload({
	"applicationdata": payload map {
		"dataType": if ( isBusiness($.customerType) ) Mule::p('lomapi.agencyData.dataType.company')
			else Mule::p('lomapi.agencyData.dataType.person'),
		("applicationNumber": $."applicationNumber")if($."role" == p('lomapi.agencyData.applicantType.mainApplicant')),
		"role": $."role",
		"externalID1": $."marketUniqueId",
		"externalID2": $."name",
		"applicantID": $."applicantId",
		"applicationFormID": $."applicationId",
		"customerCategory": $."customerType",
		("newlyAddedFlag": $."applicantStatusNew")if(payload."requestType"[0]== p('lomapi.agencyData.requestTypes.revision')),
		("person": {
			"objectType": Mule::p('lomapi.agencyData.dataType.person'),
			"roleOfPerson": $."roleFromBusinessType",
			"addresses": ($."addresses" default []) map ((item, index) -> {
				"addressType": item."addressType",
				"city": item."city",
				"countyID": item."country",
				"houseNumber": extractHouseNumber(item."address",[p('translation.houseNumber.originalValue'),houseNumberTranslated]),
				"street": extractStreet(item."address",[p('translation.houseNumber.originalValue'),houseNumberTranslated]),
				"zipcode": item."postalCode"
			}),
			"bankAccount": {
				"iban": $.bankAccounts.accountNumber[0]
			},
			"contactDetails": $."phoneNumbers" map ((item, index) -> {
				"homePhone": {"phoneNumber": item."number" replace " " with ''}
			}),
			"dateOfBirth": $."individualPerson"."birthDate",
			"provinceCodeOfBirth": ($."addresses")[0]."provinceCode",
			"firstName": $."individualPerson"."firstName",
			"gender": $."individualPerson"."gender",
			"lastName": $."individualPerson"."lastName",
			"placeOfBirth": $."individualPerson"."placeOfBirth",
			"activityCode": if (!isEmpty($."individualPerson"."jobTitle") and ($."individualPerson"."jobTitle" < 10)) ("0" ++ $."individualPerson"."jobTitle") else $."individualPerson"."jobTitle",
			"socialInsuranceId": $."individualPerson"."socialSecurityNumber",
			"taxId": $."individualPerson"."taxId",
			"vatId": $."vatNumber",
			"professionSince": $."individualPerson"."professionSince"
		}) if (!isBusiness($.customerType)),
		("company": {
			"objectType": Mule::p('lomapi.agencyData.dataType.company'),
			"addresses": ($."addresses" default []) map ((item, index) -> {
				"addressType": item."addressType",
				"city": item."city",
				"countyID": item."country",
				"houseNumber": extractHouseNumber(item."address",[p('translation.houseNumber.originalValue'),houseNumberTranslated]),
				"street": extractStreet(item."address",[p('translation.houseNumber.originalValue'),houseNumberTranslated]),
				"zipcode": item."postalCode"
			}),
			("bankAccount": {
				"iban": $.bankAccounts.accountNumber[0]
			})if($."role" == p('lomapi.agencyData.applicantType.mainApplicant')),
			("contactDetails": "homePhone": "phoneNumber": ($."phoneNumbers"."number"[0]) replace " " with ''),
			"companyActivity": if (!isEmpty($."companyInformation"."companyActivity") and ($."companyInformation"."companyActivity" < 10)) ("0" ++ $."companyInformation"."companyActivity") else $."companyInformation"."companyActivity",
			"subgroupOfEconomicActivity": $."companyInformation"."subgroupOfEconomicActivity",
			"numberOfEmployees": ($."companyInformation"."numberOfEmployees" as Number) default null,
			"companyFoundingDate": $."companyInformation"."companyFoundingDate",
			"companyRegistrationNumber": $."companyInformation"."companyRegistrationNumber",
			"name": $."companyInformation"."companyName",
			"taxId": $."individualPerson"."taxId",
			"vatNumber": $."vatNumber",
			"legalForm": $."companyInformation"."companyEntityType",
		}) if (isBusiness($.customerType)),
		"personMainApplicant": (payload filter ((item, index) -> item."role" == "MainApplicant") map ((item, index) -> {
			"addresses": [{
				"countyID": item."addresses"."country"[0]
			}],
			"dateOfBirth": item."individualPerson"."birthDate",
			"provinceCodeOfBirth": ($."addresses")[0]."provinceCode",
			"companyName": item."companyInformation"."companyName",
			"firstName": item."individualPerson"."firstName",
			"gender": $."individualPerson"."gender",
			"lastName": item."individualPerson"."lastName",
			"placeOfBirth": item."individualPerson"."placeOfBirth",
			"socialInsuranceId": item."individualPerson"."socialSecurityNumber",
			"taxId": item."individualPerson"."taxId",
			"vatId": item."vatNumber"
		}))[0],
		"financialInformation": {
			"annualRevenue": ($."customerFinanceInfo"."annualRevenue" as Number) default null,
			"dateProofOfIncome": if ( !isEmpty($."customerFinanceInfo"."incomeDocumentYear") ) ("01-" ++ ($."customerFinanceInfo"."incomeDocumentMonth" default "01") ++ "-" ++ ($."customerFinanceInfo"."incomeDocumentYear" default ""))
        else
          null,
			"totalIncome": ($."customerFinanceInfo"."annualRevenue" as Number) default null,
			"doctype": $."customerFinanceInfo"."incomeDocumentType"
		},
		("creditInformation": {
			"dealerProvinceCode": ($."addresses")[0]."region",
			"installments": ($."customerFinanceInfo"."installments" as Number) default null,
			"installmentAmount":  ($."customerFinanceInfo"."monthlyPayment" as Number) default null,
			"financedAmount": ($."customerFinanceInfo"."financedAmount" as Number) default null,
			"financingType": $."customerFinanceInfo"."financingType",
			"assetCondition": $."customerFinanceInfo"."assetCondition",
			"residualValue": (($."customerFinanceInfo"."residualAmountExclusiveVAT" default $."customerFinanceInfo"."residualAmountInclusiveVAT") as Number) default null,
			"downPayment": (($."customerFinanceInfo"."downPaymentExclusiveVAT" default $."customerFinanceInfo"."downPaymentInclusiveVAT") as Number) default null,
			"totalAmountApplication": (($."customerFinanceInfo"."totalAmountOfCreditExclusiveVAT" default $."customerFinanceInfo"."totalAmountOfCreditInclusiveVAT") as Number) default null
		})if($."role" == p('lomapi.agencyData.applicantType.mainApplicant')),
		"identificationInformation": {
			"documentType": $."individualPerson"."personIdentifications"."identificationType"[0],
			"documentID": $."individualPerson"."personIdentifications"."identificationNumber"[0],
			"issueDate": $."individualPerson"."personIdentifications"."issuingDate"[0],
			"expiryDate": $."individualPerson"."personIdentifications"."expiryDate"[0]
		}
	},
	"requestType": payload."requestType"[0],
	"requestDateTime": payload."timestamp"[0],
	"callingLegalEntity": payload."legalEntity"[0],
	"callbackURL": Mule::p('lomapi.agencyData.callbackURL.'  ++ lower(vars.countryCode) )
})
