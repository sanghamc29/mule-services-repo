%dw 2.0
output application/json skipNullOn = "everywhere"
---
{
	"rateUnit": payload.rateUnit,
	"programId": payload.programID as String default null,
	"programCode": payload.programCode,
	"programName": payload.programName,
	"tierSRate": payload.rates."S",
	"tier1Rate": payload.rates."1",
	"tier2Rate": payload.rates."2",
	"tier3Rate": payload.rates."3",
	"tier4Rate": payload.rates."4",
	"residual10K": payload.residuals."10000",
	"residual12K": payload.residuals."12000",
	"residual15K": payload.residuals."15000",
	"residual18K": payload.residuals."18000",
	"residual20K": payload.residuals."20000"
}