%dw 2.0
output application/json
---
(payload filter ((item, index) -> ((vars.loMapiResponse.applicationNumber default []) contains item.applicantId)))