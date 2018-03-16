SELECT 
 'CBS' AS indicator
,M.MainCode			AS foracid
,Cur.CyDesc			AS acct_crncy_code
,Chq.MinChequeNo	AS begin_chq_num
,Chq.NoOfCheque		AS chq_num_of_lvs
,case when CheqStatus = 'I' then 'P'
when CheqStatus = 'Z' then 'I'
when CheqStatus = 'S' then 'S'
when CheqStatus = 'D' then 'D'
when CheqStatus = 'R' then 'D'
when CheqStatus = 'C' then 'D'
when CheqStatus = 'V' then 'U'
end chq_lvs_stat 
,'' AS begin_chq_alpha
,'' AS dummy
FROM Master M
LEFT JOIN CurrencyTable Cur ON M.CyCode = Cur.CyCode
LEFT JOIN ClientTable C ON M.ClientCode = C.ClientCode and M.BranchCode = M.BranchCode
LEFT JOIN AcCustType ACT ON ACT.MainCode = M.MainCode AND ACT.BranchCode = M.BranchCode
LEFT JOIN
(
	SELECT MainCode, BranchCode, MIN(ChequeNo) MinChequeNo, COUNT(ChequeNo) NoOfCheque,CheqStatus
	FROM ChequeInven
	GROUP BY MainCode, BranchCode,CheqStatus
) Chq ON Chq.MainCode = M.MainCode AND Chq.BranchCode = M.BranchCode
WHERE LEFT(C.ClientCode , 1) <>'_'
AND IsBlocked NOT IN ('C','o')
AND ACT.CustTypeCode = 'Z'
AND C.ClientStatus <> 'Z'
