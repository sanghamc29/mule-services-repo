%dw 2.0
output application/json skipNullOn = "everywhere"
---
{
	"query": [{ "CaseID": vars.quoteId default "10038605"}]  // default value will be removed
}