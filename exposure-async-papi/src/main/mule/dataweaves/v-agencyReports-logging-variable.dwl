%dw 2.0
output application/java
---
" for EventType - " ++ (payload.eventType default "")  ++ " | ApplicationFormId - " ++ (payload.entities.applicationFormId joinBy"" default "") ++ " | UniqueId - " ++ (payload.entities.uniqueId joinBy"" default "")