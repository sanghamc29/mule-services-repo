%dw 2.0
output application/json skipNullOn="everywhere"
import modules::common
import first from dw::core::Strings

var payloads = payload pluck (value) -> value.payload
---
common::cleanPayload ({
    applicationParties: if(payload[1] is Array)(payloads[1] map((item, index) -> {onSanctionWatchList: item.result,
    	applicationPartyRole: item.applicationPartyRole
    } )) else null,
    applicationVehicle: {
        msrpMmrBase: payloads[2].msrpBase,
        msrpMmr: payloads[2].msrp,
        msrpMmrRequestDate: payloads[2].msrpRequestDate,
        carfaxGrade: payloads[2].carfaxGrade,
        mileageAdjustment: payloads[2].adjustments.mileage,
        locationAdjustment: payloads[2].adjustments.location,
        conditionAdjustment: payloads[2].adjustments.condition,
        carfaxAdjustment: payloads[2].adjustments.carfax,
        optionsAdjustment: payloads[2].adjustments.options
    },
	applicationProduct: {
        programID: payloads[0].programId,
        programCode: payloads[0].programCode,
        programName: payloads[0].programName,
        rateUnit: payloads[0].rateUnit,
        rates: {
            S: payloads[0].tierSRate,
            "1": payloads[0].tier1Rate,
            "2": payloads[0].tier2Rate,
            "3": payloads[0].tier3Rate,
            "4": payloads[0].tier4Rate
        },
        residuals: {
            "10000": payloads[0].residual10K,
            "12000": payloads[0].residual12K,
            "15000": payloads[0].residual15K,
            "18000": payloads[0].residual18K,
            "20000": payloads[0].residual20K
        }
	}
})