%dw 2.0
output application/json skipNullOn = "everywhere"
---
{
 "result": if(attributes.statusCode == 200) payload.isSanctioned else null,
 "status": if(attributes.statusCode == 200) "Success" else "Failed",
 "applicationPartyRole": vars.applicationPartyRole
}