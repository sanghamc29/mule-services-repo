%dw 2.0
output application/json
---
if ( attributes.StatusCode == 204 ) "Applicant Documents upload Status is updated successfullly" else "Applicant Documents upload Status update is failed"