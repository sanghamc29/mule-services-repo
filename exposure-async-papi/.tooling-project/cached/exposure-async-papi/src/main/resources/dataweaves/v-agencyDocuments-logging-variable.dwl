%dw 2.0
output application/java
---
" for EventType - " ++ (payload.eventType default "")  ++ " | ApplicationFormId - " ++ (payload.applicationNumber default "") ++ " | UniqueId - " ++ (payload.uniqueId default "")