%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "compositeResponse": [
    {
      "body": {
        "id": "06876000001xX4GAAU",
        "success": true,
        "errors": [],
        "created": false
      },
      "httpHeaders": {
        "Location": "/services/data/v60.0/sobjects/ContentVersion/06876000001xX4GAAU"
      },
      "httpStatusCode": 200,
      "referenceId": "refContentversionUpsert"
    }
  ]
})