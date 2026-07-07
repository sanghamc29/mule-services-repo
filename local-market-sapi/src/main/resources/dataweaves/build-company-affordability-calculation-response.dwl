%dw 2.0
output application/json skipNullOn="everywhere"
---
(payload - "BalanceSheet") ++  
BalanceSheet:{
    assets: {
        balanceSheetDate: payload.BalanceSheet.balanceSheetDate,
        NonCurrentAssets: payload.BalanceSheet.NonCurrentAssets,
        CurrentAssets: payload.BalanceSheet.CurrentAssets,
        OwnersEquity: payload.BalanceSheet.OwnersEquity,
    },
    liabilities:{
        NonCurrentLiabilities: payload.BalanceSheet.NonCurrentLiabilities,
        CurrentLiabilities: payload.BalanceSheet.CurrentLiabilities,
    },
    profitAndLoss: payload.BalanceSheet.ProfitAndLoss
}