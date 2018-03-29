-- SQL for TD004

SELECT 
'T' AS tran_type  -- T: Transfer   C: Cash
,'BI' AS tran_sub_type -- need to confirm with CAS/BBSSL
,'' AS foracid -- the values will be obtained after NNTM setup from Finacle Implementation team
,ct.CyDesc AS tran_crncy_code  
,RIGHT(SPACE(17)+CAST(dt.DealAmt AS VARCHAR(17)),17) AS tran_amt
,'C' AS part_tran_type  -- D: Debit   C: Credit
,CONVERT(VARCHAR(10),dt.DealOpenDate,105) AS value_date -- possible value: ctb.Today  -- value will be changed to migration date
,'' AS agent_emp_ind
,'' AS agent_code
,'PI' AS flow_code -- PI: Principle Inflow
,'N' AS transaction_end_indicator -- Y: Yes  N: No
FROM DealTable dt
JOIN CurrencyTable ct ON dt.CyCode = ct.CyCode
JOIN Master M ON M.MainCode = dt.MainCode AND M.BranchCode = dt.BranchCode
 ,ControlTable ctb
where (dt.AcType >= '13' AND dt.AcType <= '21') --and dt.CyCode in ('01','21')
and len(M.ClientCode) >= 8
and left(M.ClientCode,1)<>'_'
and M.IsBlocked NOT IN ('C','o')
and dt.MaturityDate > ctb.Today
and EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = M.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
)

UNION


SELECT 
'T' AS tran_type  -- T: Transfer   C: Cash
,'BI' AS tran_sub_type -- need to confirm with CAS/BBSSL
,'' AS foracid -- the values will be obtained after NNTM setup from Finacle Implementation team
,ct.CyDesc AS tran_crncy_code  
,RIGHT(SPACE(17)+CAST(dt.DealAmt AS VARCHAR(17)),17) AS tran_amt
,'C' AS part_tran_type  -- D: Debit   C: Credit
,CONVERT(VARCHAR(10),dt.DealOpenDate,105) AS value_date -- possible value: ctb.Today  -- value will be changed to migration date
,'' AS agent_emp_ind
,'' AS agent_code
,'PI' AS flow_code -- PI: Principle Inflow
,'N' AS transaction_end_indicator -- Y: Yes  N: No
FROM DealTable dt
 JOIN CurrencyTable ct ON dt.CyCode = ct.CyCode
 JOIN Master M ON M.MainCode = dt.MainCode AND M.BranchCode = dt.BranchCode
 ,ControlTable ctb
WHERE (dt.AcType >= '13' AND dt.AcType <= '21') --and dt.CyCode in ('01','21')
AND len(M.ClientCode) >= 8
AND left(M.ClientCode,1)<>'_'
AND M.IsBlocked NOT IN ('C','o')
AND dt.MaturityDate > ctb.Today
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = M.MainCode and CustTypeCode = 'Z' and CustType NOT IN ('11','12')
)