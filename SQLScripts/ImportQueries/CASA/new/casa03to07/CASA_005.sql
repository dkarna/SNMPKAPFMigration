SELECT
 'BAL' AS indicator
,M.MainCode AS foracid
,RIGHT(SPACE(17)+CAST(ISNULL(M.GoodBaln,0) AS VARCHAR(17)),17) AS tran_amt
,CONVERT(VARCHAR(10),CT.Today,105)  AS tran_date
,Cur.CyDesc AS tran_crncy_code
,M.BranchCode AS sol_id
,M.ClientCode AS dummy
FROM Master M
LEFT JOIN CurrencyTable Cur ON M.CyCode = Cur.CyCode
LEFT JOIN ClientTable C ON M.ClientCode =  C.ClientCode
LEFT JOIN AcCustType ACT ON ACT.MainCode = M.MainCode AND ACT.BranchCode = M.BranchCode , ControlTable CT
WHERE LEFT(C.ClientCode , 1) <>'_'
AND IsBlocked NOT IN ('C','o')
AND ACT.CustTypeCode = 'Z'
AND C.ClientStatus <> 'Z'