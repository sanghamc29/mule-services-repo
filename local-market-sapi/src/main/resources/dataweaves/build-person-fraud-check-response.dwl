%dw 2.0
output application/json skipNullOn="everywhere"
---
{
  "applicationNumber": payload.applicationNumber,
  "finalFraudAlert": payload.FRAUD_ANALYTICS_2,
  "fraudIndicator": payload.FRAUD_ANALYTICS_1,
  "semaforoScipafi": payload.SEMAFORO_SCIPAFI,
  "document": payload.document,
  "customerNumber": payload.externalID1
}
