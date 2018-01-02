-- SQL code for RL004
DECLARE @MIGRATION_DATE AS DATE = GETDATE()
SELECT
'T' AS tran_type
,'BI' AS tran_sub_type
,lm.MainCode AS foracid
,ct.CyDesc AS tran_crncy_code
,lm.BranchCode AS sol_id
,m.Balance AS flow_amt
,'D' AS part_tran_type
,'A' AS type_of_dmds
,CONVERT(VARCHAR(10),@MIGRATION_DATE,105) AS value_date
,'DISB' AS flow_id
,CONVERT(VARCHAR(10),@MIGRATION_DATE,105) AS dmd_date
,'N' AS last_tran_flg
,'N' AS rl004_013
,'N' AS advance_payment_flg
,'' AS prepayment_type
,'' AS int_coll_on_prepayment_flg
,m.Remarks AS tran_rmks  -- Need to confirm
,'' AS tran_particular
FROM Master m
LEFT JOIN LoanMaster lm ON m.MainCode = lm.MainCode AND m.BranchCode = lm.BranchCode
LEFT JOIN CurrencyTable ct on m.CyCode = ct.CyCode
WHERE AcType
IN('30','31','32','33','36','37','38','39','3A','3B','3E','3F','3K','3L','3M','3N','3O','3P','3Q','3R','3S','3T','3U','3X','40','42','43','46','4A','4B','4F','4G','4I','4J','4K','4M','4O','4P','4Q','4S','3V','3Y','3Z','47','48','4C','4D','4E')
AND m.Balance <> 0 AND m.Limit <> 0
AND m.IsBlocked NOT IN ('C','o')
ORDER BY m.MainCode,m.BranchCode