SELECT
 M.MainCode AS foracid
,Cur.CyDesc AS crncy_code
,M.BranchCode AS sol_id
,RIGHT(SPACE(14)+CAST(ISNULL(M.IntCrAmt,0) AS VARCHAR(14)),14) AS nrml_accrued_amount_cr
,'' AS interest_calc_upto_date_cr
,CONVERT(VARCHAR(10),CT.Today-1,105)  AS accrued_upto_date_cr
,CONVERT(VARCHAR(10),CT.Today-1,105)  AS booked_upto_date_cr
,RIGHT(SPACE(17)+CAST(ISNULL(M.IntDrAmt,0)AS VARCHAR(17)),17) AS nrml_accrued_amount_dr
,'' AS interest_calc_upto_date_dr
,CONVERT(VARCHAR(10),CT.Today-1,105) AS accrued_upto_date_dr
,CONVERT(VARCHAR(10),CT.Today-1,105) AS booked_upto_date_dr
,C.ClientCode AS dummy
,'' AS CumulativeBal
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17)  AS DateOfCumulativeBal
FROM Master M
LEFT JOIN CurrencyTable Cur ON Cur.CyCode = M.CyCode
LEFT JOIN AcCustType ACT ON ACT.MainCode = M.MainCode AND ACT.BranchCode = M.BranchCode
LEFT JOIN ClientTable C ON M.ClientCode = C.ClientCode AND M.BranchCode = M.BranchCode, ControlTable CT
WHERE LEFT(C.ClientCode , 1) <>'_'
AND IsBlocked NOT IN ('C','o')
AND ACT.CustTypeCode = 'Z'
AND C.ClientStatus <> 'Z'