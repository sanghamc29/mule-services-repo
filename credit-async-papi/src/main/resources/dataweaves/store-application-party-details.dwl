%dw 2.0
output application/json skipNullOn = "everywhere"
---
payload.applicationParties map ((item, index) -> {
    applicationPartyRole: item.applicationPartyRole,
    name: if(item.applicationPartyType == "I") item.firstName ++ " " ++ item.lastName else if(item.applicationPartyType == "B") item.businessName else null,
    country: payload.country,
    currentCity: item.currentCity,
    entityType: if(item.applicationPartyType == "I") "03" else if(item.applicationPartyType == "B") "08" else null,
    dateOfBirth: item.dateOfBirth,
    businessTaxId: item.businessTaxID,
    individualTaxId: item.individualTaxID
})