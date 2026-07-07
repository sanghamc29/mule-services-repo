%dw 2.0
output application/json
---
(payload..payload) map (item) -> (item ++ 
	{
		isSuccessful: true,
		customerType: (vars.fraudCheckData filter $.customerNumber == item.customerNumber)[0].customerType
	}
)