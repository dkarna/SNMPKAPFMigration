-- SQL for TD004

SELECT 
'T' AS tran_type  -- T: Transfer   C: Cash
,'BI' AS tran_sub_type -- need to confirm with CAS/BBSSL
,'' AS foracid -- the values will be obtained after NNTM setup from Finacle Implementation team
,t1.CyCode AS tran_crncy_code  
,t1.DealAmt AS tran_amt
,'C' AS part_tran_type  -- D: Debit   C: Credit
,t1.DealOpenDate AS value_date   -- value will be changed to migration date
,'' AS agent_emp_ind
,'' AS agent_code
,'PI' AS flow_code -- PI: Principle Inflow
,'N' AS transaction_end_indicator -- Y: Yes  N: No
FROM DealTable t1
WHERE AcType >= '13' AND AcType <= '21' 
AND MaturityDate > GETDATE() ORDER BY MainCode;