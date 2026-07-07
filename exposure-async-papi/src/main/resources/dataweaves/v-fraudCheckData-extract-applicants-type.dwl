%dw 2.0
output application/json
---
payload map (item) -> {
	isSuccessful: false,
    customerNumber: item.customerInfo.individualPerson.customerNumber,
    customerType: item.customerInfo.customerType default ''
}