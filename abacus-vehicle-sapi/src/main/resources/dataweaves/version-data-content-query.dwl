%dw 2.0
output application/java
---
"Select Id,VersionData from ContentVersion where Id ='" ++ payload.compositeResponse.body.records[0][0].Id ++ "'"