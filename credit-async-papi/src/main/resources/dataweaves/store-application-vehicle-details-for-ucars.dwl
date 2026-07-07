%dw 2.0
output application/json skipNullOn = "everywhere"
import first from dw::core::Strings

var validZip = vars.dealerZip replace /[^a-z0-9A-Z]/ with "" replace " " with "" replace /[^0-9]/ with "" first 5

var applicationVehicle = payload.applicationVehicle
---
{
	vin: applicationVehicle.vin,
	odometerMilage: applicationVehicle.odometerMileage,
	condition: applicationVehicle.vehicleCondition,
	dealerNumber: payload.dealerNumberNA,
	dealerZip: validZip
}