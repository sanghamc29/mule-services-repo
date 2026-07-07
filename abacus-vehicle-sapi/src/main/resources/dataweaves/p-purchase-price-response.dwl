%dw 2.0
import * from dw::core::Binaries
import purchasePrice from dataweaves::modules::purchasePriceResponse
output application/json indent=false
var res = payload.data
---
purchasePrice(res)