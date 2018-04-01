-- Query for RL006

SELECT
CAST(pdl.ReferenceNo AS VARCHAR(16)) AS foracid
,CONVERT(VARCHAR(10),pdl.DueDate,105) AS dmd_date
,CONVERT(VARCHAR(10),pdl.DueDate,105) AS dmd_eff_date
,CASE WHEN pdl.IsBalnDue = 'T' THEN
	CAST('PRDEM' AS VARCHAR(5))
 ELSE 
	CAST('INDEM' AS VARCHAR(5))
 END AS dmd_flow_id
,CASE WHEN pdl.IsBalnDue = 'T' THEN
	RIGHT(SPACE(17)+CAST(pdl.GoodBaln AS VARCHAR(17)),17)
 ELSE
	RIGHT(SPACE(17)+CAST(pdl.NormalInt AS VARCHAR(17)),17)
 END AS dmd_amt
,'N' AS rl006_006
,RIGHT(SPACE(17)+CAST('' AS VARCHAR(17)),17) AS rl006_007
,RIGHT(SPACE(10)+CAST('' AS VARCHAR(10)),10) AS rl006_008
,RIGHT(SPACE(1)+CAST('' AS VARCHAR(1)),1) AS latefee_status_flg
,RIGHT(SPACE(3)+CAST('' AS VARCHAR(3)),3) AS rl006_010
,LEFT(SPACE(10)+CAST('' AS VARCHAR(10)),10) AS dmd_ovdu_date
,RIGHT(SPACE(17)+CAST('' AS VARCHAR(17)),17) AS rl006_012
,LEFT(SPACE(34)+CAST('' AS VARCHAR(34)),34) AS iban_number
FROM PastDuedList pdl
LEFT JOIN Master m on pdl.ReferenceNo = m.MainCode AND pdl.BranchCode = m.BranchCode
WHERE m.AcType IN('30','31','32','33','36','37','38','39','3A','3B','3E','3F','3K','3L','3M','3N','3O','3P','3Q','3R','3S','3T','3U','3X','40','42','43','46','4A','4B','4F','4G','4I','4J','4K','4M','4O','4P','4Q','4S','3V','3Y','3Z','47','48','4C','4D','4E')
AND m.Balance <> 0 
AND m.Limit <> 0
AND LEN(m.ClientCode) >= 8
AND m.IsBlocked NOT IN ('C','o')
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = m.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
) 

UNION

SELECT
CAST(pdl.ReferenceNo AS VARCHAR(16)) AS foracid
,CONVERT(VARCHAR(10),pdl.DueDate,105) AS dmd_date
,CONVERT(VARCHAR(10),pdl.DueDate,105) AS dmd_eff_date
,CASE WHEN pdl.IsBalnDue = 'T' THEN
	CAST('PRDEM' AS VARCHAR(5))
 ELSE 
	CAST('INDEM' AS VARCHAR(5))
 END AS dmd_flow_id
,CASE WHEN pdl.IsBalnDue = 'T' THEN
	RIGHT(SPACE(17)+CAST(pdl.GoodBaln AS VARCHAR(17)),17)
 ELSE
	RIGHT(SPACE(17)+CAST(pdl.NormalInt AS VARCHAR(17)),17)
 END AS dmd_amt
,'N' AS rl006_006
,RIGHT(SPACE(17)+CAST('' AS VARCHAR(17)),17) AS rl006_007
,RIGHT(SPACE(10)+CAST('' AS VARCHAR(10)),10) AS rl006_008
,RIGHT(SPACE(1)+CAST('' AS VARCHAR(1)),1) AS latefee_status_flg
,RIGHT(SPACE(3)+CAST('' AS VARCHAR(3)),3) AS rl006_010
,LEFT(SPACE(10)+CAST('' AS VARCHAR(10)),10) AS dmd_ovdu_date
,RIGHT(SPACE(17)+CAST('' AS VARCHAR(17)),17) AS rl006_012
,LEFT(SPACE(34)+CAST('' AS VARCHAR(34)),34) AS iban_number
FROM PastDuedList pdl
LEFT JOIN Master m on pdl.ReferenceNo = m.MainCode AND pdl.BranchCode = m.BranchCode
WHERE m.AcType IN('30','31','32','33','36','37','38','39','3A','3B','3E','3F','3K','3L','3M','3N','3O','3P','3Q','3R','3S','3T','3U','3X','40','42','43','46','4A','4B','4F','4G','4I','4J','4K','4M','4O','4P','4Q','4S','3V','3Y','3Z','47','48','4C','4D','4E')
AND m.Balance <> 0 
AND m.Limit <> 0
AND LEN(m.ClientCode) >= 8
AND m.IsBlocked NOT IN ('C','o')
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = m.MainCode and CustTypeCode = 'Z' and CustType NOT IN ('11','12')
) 

UNION