%dw 2.0
import * from dw::core::Strings
import cleanPayload from dataweaves::payloadCleanup
import extractStreet,extractHouseNumber from dataweaves::houseNumberAndStreetAddress
fun isBusiness(customerType) = (customerType == Mule::p('lomapi.agencyFeedback.businessCustomerType'))
import getTranslatedValueFromLabelToAPIValue from dataweaves::euLocalizationModule
var houseNumberTranslated = getTranslatedValueFromLabelToAPIValue(vars.enums,p('translation.houseNumber.originalValue'),p('translation.houseNumber.nodeName'),p('translation.houseNumber.serviceName'))
output application/json skipNullOn = "everywhere"
---
cleanPayload({
	"applicationdata": payload map {
		"dataType": if ( isBusiness($.customerType) ) Mule::p('lomapi.agencyFeedback.dataType.company')
			else Mule::p('lomapi.agencyFeedback.dataType.person'),
		"applicationNumber": $."applicationNumber",
		"role": $."role",
		"externalID1": $."marketUniqueId",
		"externalID2": $."name",
		"applicantID": $."applicantId",
		"applicationFormID": $."applicationId",
		"customerCategory": $."customerType",
		("person": {
			"objectType": Mule::p('lomapi.agencyFeedback.dataType.person'),
			"addresses": ($."addresses" default []) map ((item, index) -> {
				"addressType": item."addressType",
				"city": item."city",
				"countyID": item."country",
				"houseNumber": extractHouseNumber(item."address",[p('translation.houseNumber.originalValue'),houseNumberTranslated]),
				"street": extractStreet(item."address",[p('translation.houseNumber.originalValue'),houseNumberTranslated]),
				"zipcode": item."postalCode"
			}),
			"phoneNumber": $."phoneNumbers"."number"[0],
			"dateOfBirth": $."individualPerson"."birthDate",
			"countryCodeOfBirth": $."individualPerson"."countryOfBirth",
			"firstName": $."individualPerson"."firstName",
			"gender": $."individualPerson"."gender",
			"lastName": $."individualPerson"."lastName",
			"placeOfBirth": $."individualPerson"."placeOfBirth",
			"taxId": $."individualPerson"."taxId"
		}) if (!isBusiness($.customerType)),
		("company": {
			"objectType": Mule::p('lomapi.agencyFeedback.dataType.company'),
			"addresses": ($."addresses" default []) map ((item, index) -> {
				"addressType": item."addressType",
				"city": item."city",
				"countyID": item."country",
				"houseNumber": extractHouseNumber(item."address",[p('translation.houseNumber.originalValue'),houseNumberTranslated]),
				"street": extractStreet(item."address",[p('translation.houseNumber.originalValue'),houseNumberTranslated]),
				"zipcode": item."postalCode"
			}),
			"companyFoundingDate": $."companyInformation"."companyFoundingDate",
			"name": $."companyInformation"."companyName",
			"taxId": $."individualPerson"."taxId"
		}) if (isBusiness($.customerType)),
	},
	"requestType": payload."requestType"[0],
	"requestDateTime": payload."timestamp"[0],
	"callingLegalEntity": payload."legalEntity"[0],
	"finalDecision":  payload."cancellationReason"[0],
	"finalDecisionDate": now()
})
