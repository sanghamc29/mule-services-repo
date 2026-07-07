%dw 2.0
import * from dw::core::Binaries
output application/json
---
if(not isEmpty(payload))
read(fromBase64(payload.ContentDocument.LatestPublishedVersion.VersionData[0] as String), "application/json")
else []