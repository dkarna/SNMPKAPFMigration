-- Query for RL025 (Customization)
DECLARE @MIGRATION_DATE AS DATE = GETDATE()
SELECT 
'INT' AS rl025_001
,CAST(lm.MainCode AS VARCHAR(16)) AS foracid
,CAST(m.CyCode AS VARCHAR(3)) AS crncy_code
,CAST(lm.BranchCode AS VARCHAR(8)) AS sol_id
,RIGHT(SPACE(17)+CAST('' AS VARCHAR(17)),17) AS nrml_accrued_amount_cr
,RIGHT(SPACE(17)+CAST('' AS VARCHAR(17)),17) AS nrml_booked_amount_cr
,RIGHT(SPACE(8)+CAST('' AS VARCHAR(8)),8) AS rl025_007
,RIGHT(SPACE(8)+CAST('' AS VARCHAR(8)),8) AS rl025_008
,RIGHT(SPACE(8)+CAST('' AS VARCHAR(8)),8) AS rl025_009
,RIGHT(SPACE(17)+CAST(m.IntDrAmt AS VARCHAR(17)),17) AS rl025_010
,RIGHT(SPACE(17)+CAST(m.IntDrAmt AS VARCHAR(17)),17) AS rl025_011
,CAST(REPLACE(CONVERT(VARCHAR,@MIGRATION_DATE,102),'.','') AS VARCHAR(8)) AS rl025_012
,CAST(REPLACE(CONVERT(VARCHAR,DATEADD(DAY,-1,@MIGRATION_DATE),102),'.','') AS VARCHAR(8)) AS rl025_013
,CAST(REPLACE(CONVERT(VARCHAR,DATEADD(DAY,-1,@MIGRATION_DATE),102),'.','') AS VARCHAR(8)) AS rl025_014
,CAST('' AS VARCHAR(8)) AS rl025_015
FROM Master m
LEFT JOIN LoanMaster lm ON m.MainCode = lm.MainCode AND m.BranchCode = lm.BranchCode
WHERE AcType
IN('30','31','32','33','36','37','38','39','3A','3B','3E','3F','3K','3L','3M','3N','3O','3P','3Q','3R','3S','3T','3U','3X','40','42','43','46','4A','4B','4F','4G','4I','4J','4K','4M','4O','4P','4Q','4S','3V','3Y','3Z','47','48','4C','4D','4E')
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
'INT' AS rl025_001
,CAST(lm.MainCode AS VARCHAR(16)) AS foracid
,CAST(m.CyCode AS VARCHAR(3)) AS crncy_code
,CAST(lm.BranchCode AS VARCHAR(8)) AS sol_id
,RIGHT(SPACE(17)+CAST('' AS VARCHAR(17)),17) AS nrml_accrued_amount_cr
,RIGHT(SPACE(17)+CAST('' AS VARCHAR(17)),17) AS nrml_booked_amount_cr
,RIGHT(SPACE(8)+CAST('' AS VARCHAR(8)),8) AS rl025_007
,RIGHT(SPACE(8)+CAST('' AS VARCHAR(8)),8) AS rl025_008
,RIGHT(SPACE(8)+CAST('' AS VARCHAR(8)),8) AS rl025_009
,RIGHT(SPACE(17)+CAST(m.IntDrAmt AS VARCHAR(17)),17) AS rl025_010
,RIGHT(SPACE(17)+CAST(m.IntDrAmt AS VARCHAR(17)),17) AS rl025_011
,CAST(REPLACE(CONVERT(VARCHAR,@MIGRATION_DATE,102),'.','') AS VARCHAR(8)) AS rl025_012
,CAST(REPLACE(CONVERT(VARCHAR,DATEADD(DAY,-1,@MIGRATION_DATE),102),'.','') AS VARCHAR(8)) AS rl025_013
,CAST(REPLACE(CONVERT(VARCHAR,DATEADD(DAY,-1,@MIGRATION_DATE),102),'.','') AS VARCHAR(8)) AS rl025_014
,CAST('' AS VARCHAR(8)) AS rl025_015
FROM Master m
LEFT JOIN LoanMaster lm ON m.MainCode = lm.MainCode AND m.BranchCode = lm.BranchCode
WHERE AcType
IN('30','31','32','33','36','37','38','39','3A','3B','3E','3F','3K','3L','3M','3N','3O','3P','3Q','3R','3S','3T','3U','3X','40','42','43','46','4A','4B','4F','4G','4I','4J','4K','4M','4O','4P','4Q','4S','3V','3Y','3Z','47','48','4C','4D','4E')
AND m.Balance <> 0 
AND m.Limit <> 0
AND LEN(m.ClientCode) >= 8
AND m.IsBlocked NOT IN ('C','o')
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = m.MainCode and CustTypeCode = 'Z' and CustType NOT IN ('11','12')
) 