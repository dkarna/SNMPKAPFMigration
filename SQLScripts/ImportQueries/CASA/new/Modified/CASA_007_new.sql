-- Query for CS007

SELECT * FROM
(
SELECT --DISTINCT
 'CBS' AS indicator
,M.MainCode			AS foracid
,Cur.CyDesc			AS acct_crncy_code
,cbs.BeginCheqNo	AS begin_chq_num    -- actual value will come from recently made checkstatus table
,'100'		AS chq_num_of_lvs
,cbs.CheqStat AS chq_lvs_stat 
,'' AS begin_chq_alpha
,cbs.BundleNo AS dummy
FROM Master M
JOIN ChequeInven ci on ci.MainCode=M.MainCode and ci.BranchCode=M.BranchCode
JOIN CheqBundleStat cbs on ci.MainCode=cbs.MainCode and ci.BranchCode=cbs.BranchCode
LEFT JOIN CurrencyTable Cur ON M.CyCode = Cur.CyCode
LEFT JOIN ClientTable C ON M.ClientCode = C.ClientCode and M.BranchCode = M.BranchCode
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


SELECT --DISTINCT
 'CBS' AS indicator
,M.MainCode			AS foracid
,Cur.CyDesc			AS acct_crncy_code
,cbs.BeginCheqNo	AS begin_chq_num    -- actual value will come from recently made checkstatus table
,'100'		AS chq_num_of_lvs
,cbs.CheqStat AS chq_lvs_stat 
,'' AS begin_chq_alpha
,cbs.BundleNo AS dummy
FROM Master M
JOIN ChequeInven ci on ci.MainCode=M.MainCode and ci.BranchCode=M.BranchCode
JOIN CheqBundleStat cbs on ci.MainCode=cbs.MainCode and ci.BranchCode=cbs.BranchCode
LEFT JOIN CurrencyTable Cur ON M.CyCode = Cur.CyCode
LEFT JOIN ClientTable C ON M.ClientCode = C.ClientCode and M.BranchCode = M.BranchCode
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
) as t 
order by t.foracid,t.dummy,t.acct_crncy_code