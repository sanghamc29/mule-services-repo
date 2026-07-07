%dw 2.0
import * from dw::core::Arrays
output application/json
var originaldocuments = (flatten((vars.applicantOriginalDocuments.pdfDocuments default[]) ++ (vars.applicantOriginalDocuments.richtextDocuments default[]))) filter($.agencyStatusCode >= 200 and $.agencyStatusCode <300)
var documents = originaldocuments map ((orgdocs) ->
{
	"documentName": (Mule::p('c6.documentName.identifier'))++ " " ++ orgdocs.documentName,
	"documentType": orgdocs.documentType,
	"documentContent": orgdocs.documentContent,
	"contentDocumentId": (vars.getApplicantDocuments filter ((getdocs) -> getdocs.documentName == ((Mule::p('c6.documentName.identifier'))++ " " ++ orgdocs.documentName )))[0].contentDocumentId,
	"documentCheckListItemId": (vars.getApplicantDocuments filter ((getdocs) -> getdocs.documentName == ((Mule::p('c6.documentName.identifier'))++ " " ++ orgdocs.documentName)))[0].documentCheckListItemId
})
---
documents filter $.documentCheckListItemId != null