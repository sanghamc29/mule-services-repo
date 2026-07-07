%dw 2.0
output application/json
import update from dw::util::Values

var appParties = payload.applicationParties map ((item) -> 
{
    ((item) ++ (((vars.appDetails.applicationParties filter ((eventAppParty) -> eventAppParty.applicationPartyId == item.applicationPartyId)) map {
    "newBureauRequiredFlag": $.newBureauRequiredFlag,
    "agencyname":$.agencyname
})[0]  default {}))
})

---
payload update "applicationParties" with appParties