%dw 2.0
output application/java
---
" for EventType - " ++ (payload.data.payload.EU_EventType__c default "")  ++ " | ApplicationFormId - " ++ (payload.data.payload.EU_ApplicationFormId__c default "") ++ " | UniqueId - " ++ (payload.data.payload.EU_UniqueId__c default "")