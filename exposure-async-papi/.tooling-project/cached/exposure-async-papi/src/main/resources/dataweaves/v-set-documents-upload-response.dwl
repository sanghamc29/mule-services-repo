%dw 2.0
output application/json
import * from dw::util::Values
---
flatten(payload..payload)