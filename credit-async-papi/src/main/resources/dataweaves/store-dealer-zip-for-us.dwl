%dw 2.0
output application/json skipNullOn = "everywhere"
import first from dw::core::Strings
---
payload.dealerZip replace /[^0-9]/ with "" first 5	
