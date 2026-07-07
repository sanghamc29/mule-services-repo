%dw 2.0
output application/json skipNullOn = "everywhere"

var applicationVehicle = payload.applicationVehicle
---
{
	vehicleModel: applicationVehicle.vehicleModel,
	vehicleYear: applicationVehicle.vehicleYear,
	odometerMileage: applicationVehicle.odometerMileage,
	vin: applicationVehicle.vin,
	dealerNumber: payload.dealerNumberNA,
	applicationId: payload.applicationID
}