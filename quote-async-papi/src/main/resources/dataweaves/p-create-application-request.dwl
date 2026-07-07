%dw 2.0
import * from dw::core::Objects
output application/json skipNullOn = "everywhere"

---
vars.milesCreditQuoteApplicationDetails default {} ++ 
{
	"documents": vars.recursiveResponse.results map  
    {
		"objID": $.objID,
		"segment": $.segment,
		"country": $.country,
		"legalEntity": $.legalEntity,
		"contractID": $.contractID,
		"contractType": $.contractType,
		"status": $.status,
		"statusDate": (($.statusDate as Date {format:"yyyy-MM-dd"}) as String {format: "yyyy-MM-dd'T'00:00:00'Z'"}),
		"docTypeNumber": $.docTypeNumber as String,
		"docTypeName": $.docTypeName,
		"archiveDate": (($.archiveDate as Date {format:"yyyy-MM-dd"}) as String {format: "yyyy-MM-dd'T'00:00:00'Z'"}),
		"docName": $.docName,
		"fileMimeType": $.fileMimeType,
		"creationDate": ($.creationDate as DateTime) as String {format: "yyyy-MM-dd'T'HH:mm:ss'Z'"},
		"modifiedBy": $.modifiedBy,
		"modifiedDate": ($.modifiedDate as DateTime) as String {format: "yyyy-MM-dd'T'HH:mm:ss'Z'"}
	}
}
