%dw 2.0
import divideBy from dw::core::Arrays
output application/json
var groupedDocs = vars.applicantDocuments groupBy $.documentType
---
// Batch HTMLs (up to 20 per batch) and PDFs (up to 2 per batch)
{
	htmlBatches: (groupedDocs.html default []) divideBy(Mule::p('documentTypes.html.batchSize')),
	pdfBatches:  (groupedDocs.pdf  default []) divideBy(Mule::p('documentTypes.pdf.batchSize'))
}
