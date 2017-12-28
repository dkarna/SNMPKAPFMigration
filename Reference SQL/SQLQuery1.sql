
SELECT
CAST(ReferenceNo AS VARCHAR(16)) AS foracid
,CONVERT(VARCHAR(10),DueDate,105) AS dmd_date
,CONVERT(VARCHAR(10),DueDate,105) AS dmd_eff_date
,CASE WHEN IsBalnDue = 'T' THEN
	CAST('PRDEM' AS VARCHAR(5))
 ELSE 
	CAST('INDEM' AS VARCHAR(5))
 END AS dmd_flow_id
,CASE WHEN IsBalnDue = 'T' THEN
	RIGHT(SPACE(17)+CAST(GoodBaln AS VARCHAR(17)),17)
 ELSE
	RIGHT(SPACE(17)+CAST(NormalInt AS VARCHAR(17)),17)
 END AS dmd_amt
,'N' AS rl006_006
,RIGHT(SPACE(17)+CAST('' AS VARCHAR(17)),17) AS rl006_007
,RIGHT(SPACE(10)+CAST('' AS VARCHAR(10)),10) AS rl006_008
,RIGHT(SPACE(1)+CAST('' AS VARCHAR(1)),1) AS latefee_status_flg
,RIGHT(SPACE(3)+CAST('' AS VARCHAR(3)),3) AS rl006_010
,LEFT(SPACE(10)+CAST('' AS VARCHAR(10)),10) AS dmd_ovdu_date
,RIGHT(SPACE(17)+CAST('' AS VARCHAR(17)),17) AS rl006_012
,LEFT(SPACE(34)+CAST('' AS VARCHAR(34)),34) AS iban_number
FROM PastDuedList

select * from LoanMaster lm left join Master m on lm.MainCode = m.MainCode and lm.BranchCode = m.BranchCode
left join PastDuedList pdl on lm.MainCode = pdl.ReferenceNo and lm.BranchCode = pdl.BranchCode



select top 1 AutoGenInt from LoanMaster;
select distinct CalcNature from IntTranDetail;

select top 1 * from PastDuedList;

select * from PastDuedList pdl left join Master m on pdl.ReferenceNo = m.MainCode and pdl.BranchCode = m.BranchCode

select * from PastDuedList pdl left join LoanMaster  lm on pdl.ReferenceNo = lm.MainCode and pdl.BranchCode = lm.BranchCode

select count(*) from PastDuedList

select * from PastDuedList where ReferenceNo not in (Select MainCode from Master where 
AcType
IN('30','31','32','33','36','37','38','39','3A','3B','3E','3F','3K','3L','3M','3N','3O','3P','3Q','3R','3S','3T','3U','3X','40','42','43','46','4A','4B','4F','4G','4I','4J','4K','4M','4O','4P','4Q','4S','3V','3Y','3Z','47','48','4C','4D','4E')
and Balance <> 0 and Limit <> 0
--and act.CustTypeCode = ''
and IsBlocked NOT IN ('C','o'))

select * from Master m where  
m.AcType
IN('30','31','32','33','36','37','38','39','3A','3B','3E','3F','3K','3L','3M','3N','3O','3P','3Q','3R','3S','3T','3U','3X','40','42','43','46','4A','4B','4F','4G','4I','4J','4K','4M','4O','4P','4Q','4S','3V','3Y','3Z','47','48','4C','4D','4E')
and Balance <> 0 and Limit <> 0
--and act.CustTypeCode = ''
and IsBlocked NOT IN ('C','o')
and m.MainCode not in(select MainCode from LoanMaster)

-- Query for RL005
DECLARE @MIGRATION_DATE AS DATE = GETDATE()
SELECT
'T' AS tran_type
,'BI' AS tran_sub_type
,pdl.ReferenceNo AS foracid
,ct.CyDesc AS tran_crncy_code
,pdl.BranchCode AS sol_id
,pdl.NormalInt AS flow_amt  -- Need to confirm
,'D' AS part_tran_type
,'' AS type_of_dmds
,CONVERT(VARCHAR(10),DueDate,105) AS value_date
,'PIDEM' AS flow_id -- Need to confirm about Penal Due
,CONVERT(VARCHAR(10),DueDate,105) AS dmd_date
,'N' AS last_tran_flg
,'N' AS rl005_013
,'N' AS advance_payment_flg
,'' AS prepayment_type
,'' AS int_coll_on_prepayment_flg
,m.Remarks AS tran_rmks
,@MIGRATION_DATE AS tran_particular
FROM PastDuedList pdl
left join Master m on pdl.ReferenceNo = m.MainCode and pdl.BranchCode = m.BranchCode
left join CurrencyTable ct on m.CyCode = ct.CyCode
where m.AcType IN('30','31','32','33','36','37','38','39','3A','3B','3E','3F','3K','3L','3M','3N','3O','3P','3Q','3R','3S','3T','3U','3X','40','42','43','46','4A','4B','4F','4G','4I','4J','4K','4M','4O','4P','4Q','4S','3V','3Y','3Z','47','48','4C','4D','4E')
and m.Balance <> 0 and m.Limit <> 0
--and act.CustTypeCode = ''
and m.IsBlocked NOT IN ('C','o')

select distinct ReferenceNo from PastDuedList where ReferenceNo not in (Select MainCode from LoanMaster)

select top 1 * from LoanRepaySched

select count(*) from LoanRepaySched where MainCode not in(Select MainCode from LoanMaster)

select * from LoanMaster where MainCode='0010000000134'
select * from LoanRepaySched where MainCode='0010000000134'

SELECT MainCode,BranchCode,MAX(DueDate) AS DUEDATE FROM LoanRepaySched,ControlTable WHERE DueDate > Today GROUP BY MainCode,BranchCode order by 1,2

select top 100 * from LoanRepaySched where DueDate > getdate()

select top 1 IntPost from Master;