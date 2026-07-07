%dw 2.0
output application/json
---
(flatten((vars.applicantOriginalDocuments.pdfDocuments default[]) ++ (vars.applicantOriginalDocuments.richtextDocuments default[])))  filter($.agencyStatusCode ==413)