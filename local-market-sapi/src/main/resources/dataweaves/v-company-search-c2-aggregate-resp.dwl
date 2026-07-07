%dw 2.0
output application/json
import getTranslatedValueFromLabelToAPIValue from dataweaves::euLocalizationModule
var houseNumberTranslated = getTranslatedValueFromLabelToAPIValue(vars.enums,p('translation.houseNumber.originalValue'),p('translation.houseNumber.nodeName'),p('translation.houseNumber.serviceName'))
import formatAddress from dataweaves::houseNumberAndStreetAddress
fun addFormattedAddress(addresses) =
    if (addresses is Array)
        addresses map (addr) ->
            addr ++ {
                formattedAddress: formatAddress(addr.houseNumber,addr.street,houseNumberTranslated)

            }
    else
        addresses
---
vars.responseArray ++
( [payload] map (item) ->
    item update {
        case .company.addresses ->
            addFormattedAddress(item.company.addresses)
        case .company.businessContactPersons ->
            item.company.businessContactPersons map (person) ->
                person update {
                    case .addresses ->
                        addFormattedAddress(person.addresses)
                }
    })