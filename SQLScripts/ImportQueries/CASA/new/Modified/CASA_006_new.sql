-- CS006

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
AND C.ClientStatus <> 'Z'
AND LEN(M.ClientCode) >= 8
AND M.AcType In ('01','05','06','07','08','09','0A','0B','0C','0D','0E','0F','0G','0H','0I','0J','0K','0L',
 '0M','0N','0O','0P','0Q','0R','0S','0T','0U','0V','0W','0X','0Y','0Z','10','11','28','29','3C','3D','3G','3H','3I','3J','0V','3W','4H','4L')
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = M.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
) 

UNION

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
AND C.ClientStatus <> 'Z'
AND LEN(M.ClientCode) >= 8
AND M.AcType In ('01','05','06','07','08','09','0A','0B','0C','0D','0E','0F','0G','0H','0I','0J','0K','0L',
 '0M','0N','0O','0P','0Q','0R','0S','0T','0U','0V','0W','0X','0Y','0Z','10','11','28','29','3C','3D','3G','3H','3I','3J','0V','3W','4H','4L')
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = M.MainCode and CustTypeCode = 'Z' and CustType NOT IN ('11','12')
) 