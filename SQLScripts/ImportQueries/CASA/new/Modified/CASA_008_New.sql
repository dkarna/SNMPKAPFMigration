-- CS008

IF OBJECT_ID('tempdb.dbo.#newchequeinven', 'U') IS NOT NULL
  DROP TABLE #newchequeinven;
SELECT MainCode, BranchCode, MIN(ChequeNo) AS BeginChq,MIN(CreateOn) as CreateOn,Count(*) StoppedChq 
into #newchequeinven
FROM  ChequeInven 
WHERE CheqStatus = 'S'
and len(MainCode) >= 8
and len(ChequeNo) = 10
GROUP BY MainCode, BranchCode

SELECT distinct
  Chq.MainCode AS foracid
, SChq.BeginChq AS begin_chq_num
, convert(varchar(10),SChq.CreateOn,105) AS acpt_date
,case when SChq.StoppedChq > 1 then NULL else convert(varchar(10),SChq.CreateOn,105) end as chq_date
, RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS chq_amt
, '' AS payee_name
, RIGHT(SPACE(3)+CAST(SChq.StoppedChq AS VARCHAR(3)),3) AS num_of_lvs
, '' AS chq_alpha
, '' AS sp_reason_code
, RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS acct_bal
, Cur.CyDesc AS acct_crncy_code
FROM ChequeInven Chq
LEFT JOIN Master M ON Chq.MainCode = M.MainCode AND Chq.BranchCode = M.BranchCode
LEFT JOIN CurrencyTable Cur ON Cur.CyCode = M.CyCode
JOIN #newchequeinven SChq
	ON SChq.MainCode = Chq.MainCode
where len(Chq.MainCode) >= 8
and len(Chq.ChequeNo) = 10
AND M.AcType In ('01','05','06','07','08','09','0A','0B','0C','0D','0E','0F','0G','0H','0I','0J','0K','0L',
 '0M','0N','0O','0P','0Q','0R','0S','0T','0U','0V','0W','0X','0Y','0Z','10','11','28','29','3C','3D','3G','3H','3I','3J','0V','3W','4H','4L')
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = M.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
) 

UNION

SELECT distinct
  Chq.MainCode AS foracid
, SChq.BeginChq AS begin_chq_num
, convert(varchar(10),SChq.CreateOn,105) AS acpt_date
,case when SChq.StoppedChq > 1 then NULL else convert(varchar(10),SChq.CreateOn,105) end as chq_date
, RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS chq_amt
, '' AS payee_name
, RIGHT(SPACE(3)+CAST(SChq.StoppedChq AS VARCHAR(3)),3) AS num_of_lvs
, '' AS chq_alpha
, '' AS sp_reason_code
, RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS acct_bal
, Cur.CyDesc AS acct_crncy_code
FROM ChequeInven Chq
LEFT JOIN Master M ON Chq.MainCode = M.MainCode AND Chq.BranchCode = M.BranchCode
LEFT JOIN CurrencyTable Cur ON Cur.CyCode = M.CyCode
JOIN #newchequeinven SChq
	ON SChq.MainCode = Chq.MainCode
where len(Chq.MainCode) >= 8
and len(Chq.ChequeNo) = 10
AND M.AcType In ('01','05','06','07','08','09','0A','0B','0C','0D','0E','0F','0G','0H','0I','0J','0K','0L',
 '0M','0N','0O','0P','0Q','0R','0S','0T','0U','0V','0W','0X','0Y','0Z','10','11','28','29','3C','3D','3G','3H','3I','3J','0V','3W','4H','4L')
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = M.MainCode and CustTypeCode = 'Z' and CustType NOT IN ('11','12')
) 
