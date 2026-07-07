%dw 2.0
output application/json
import * from dw::util::Values
---
if(vars.interestRateType == p('interestType.euribor'))
{
	"financeSummary": [{
		"euribor": vars.xirrSpreadResponse.data.euribor,
		"spread": vars.xirrSpreadResponse.data.spread
	}	
]}
else
{
	"financeSummary": []
}
