%dw 2.0
output application/json skipNullOn = "everywhere"
---
{
	"programID": if(payload.country == "MX") (payload.applicationProduct.programID as Number default null) else (vars.programCodeApplicationDetails.programId as Number default null),
	"programCode": vars.programCodeApplicationDetails.programCode default "",
	"lineOfBusiness": payload.applicationProduct.financeType,
	"term": payload.applicationProductOffer.term,
	"vehicles": [{
		"modelYear": payload.applicationVehicle.vehicleYear as Number,
		"make": payload.applicationVehicle.vehicleMake,
		"model": payload.applicationVehicle.vehicleModel,
		"mileage": payload.applicationVehicle.odometerMileage,
		"msrp": payload.applicationProductOffer.msrp
	}],
	"vehicleCondition": upper(payload.applicationVehicle.vehicleCondition),
	"dealerNumber": payload.dealerNumberNA as String default null,
	"contractDate": now() as String {format: "u-MM-dd"},
	"countryCode": payload.country
}