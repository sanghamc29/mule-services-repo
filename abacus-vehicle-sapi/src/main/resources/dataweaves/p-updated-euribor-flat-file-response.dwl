%dw 2.0
import * from dw::util::Values
output application/json
---
vars.origPayload update {
     case .data.fundedItems[0].financeParameters.euriborPct ->  vars.xirrSpreadResponse.data.euribor
     case .data.fundedItems[0].financeParameters.spread ->  vars.xirrSpreadResponse.data.spread
}
	