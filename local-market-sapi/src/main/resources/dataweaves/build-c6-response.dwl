%dw 2.0
output application/json
---
{
	"applicationNumber": vars.orgPayload."applicationNumber"[0] default "",
	"status": payload."message"
}