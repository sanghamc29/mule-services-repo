%dw 2.0
import substringBefore, substringAfter from dw::core::Strings
import some from dw::core::Arrays

fun extractHouseNumber(address: String | Null, labels: Array<String>) =
    if(address != null and (labels some ((label) -> address contains label)))
        trim(substringBefore(substringAfter(address, ":"), ","))
    else null
    
fun extractStreet(address: String | Null, labels: Array<String>) =
    if(address != null and (labels some ((label) -> address contains label)))
        trim(substringAfter(address, ","))
    else
        address



fun formatAddress(houseNumber: String | Null, street: String | Null,translatedHouseNumber) =
    do {
        var hasHouseNumber = houseNumber != null and !isEmpty(houseNumber)
        var hasStreet = street != null and !isEmpty(street)
        ---
        if (hasHouseNumber and hasStreet)
            translatedHouseNumber ++ ": " ++ trim(houseNumber) ++ ", " ++ trim(street)
        else if (hasHouseNumber)
            translatedHouseNumber ++ ": " ++ trim(houseNumber)
        else if (hasStreet)
            trim(street)
        else null
    }
