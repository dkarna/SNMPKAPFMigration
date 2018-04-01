-- SQL Query for RL003

SELECT
lrs.MainCode AS foracid
,CASE WHEN lrs.DueInterest > 0 THEN 'EIDEM'
 ELSE 'EIDEM'
 END AS flow_id  -- Need to be confirmed
,CONVERT(VARCHAR(10),mlrs.DUEDATE,105) AS flow_start_date   -- Need to be confirmed
,CASE WHEN lm.RepayFreq = '1' THEN 'D'
	WHEN lm.RepayFreq = '2' THEN 'W'
	WHEN lm.RepayFreq = '4' THEN 'M'
	WHEN lm.RepayFreq = '5' THEN 'Q'
	WHEN lm.RepayFreq = '6' THEN 'H'
	WHEN lm.RepayFreq = '7' THEN 'Y'
ELSE 'M'
END  AS lr_freq_type  
,'' AS lr_freq_week_num
,'' AS lr_freq_week_day
,DATEPART(DAY,lrs.DueDate) AS lr_freq_start_dd  -- Need to be confirmed
,'' AS lr_freq_months
,'' AS lr_freq_days
,'N' AS lr_freq_hldy_stat
,RIGHT(SPACE(3)+CAST(clrs.FLOWNO AS VARCHAR(3)),3) AS num_of_flows
,RIGHT(SPACE(17)+CAST(lrs.TotPayment AS VARCHAR(17)),17) AS flow_amt  -- Need to be confirmed (For now, its fine, but in some case this may not work)
,'' AS instlmnt_pcnt
,RIGHT(SPACE(3)+CAST('0' AS VARCHAR(3)),3) AS num_of_dmds
,'' AS next_dmd_date   
,CONVERT(VARCHAR(10),mlrs.DUEDATE,105) AS next_int_dmd_date  -- Same as Flow Start date, need to be confirmed
,CASE WHEN lm.AutoGenInt = 'F' THEN 
	m.IntPostFrqDr
 ELSE 
	lm.RepayFreq
 END AS lr_int_freq_type
,'' AS lr_int_freq_week_num
,'' AS lr_int_freq_week_day
,CASE WHEN lm.AutoGenInt = 'F' THEN 
	m.IntPostFrqDr
 ELSE 
	DATEPART(DAY,DueDate)
 END AS lr_int_freq_start_dd
,'' AS lr_int_freq_months
,'' AS lr_int_freq_days
,'N' AS lr_int_freq_hldy_stat
,'' AS instlmnt_ind
FROM LoanRepaySched lrs
LEFT JOIN Master m ON lrs.MainCode = m.MainCode and lrs.BranchCode = m.BranchCode
LEFT JOIN LoanMaster lm ON lrs.MainCode = lm.MainCode AND lrs.BranchCode = lm.BranchCode
JOIN     -- to get single record
(
	SELECT MainCode,BranchCode,MIN(DueDate) AS DUEDATE FROM LoanRepaySched lrs1,ControlTable ct WHERE lrs1.DueDate > ct.Today GROUP BY MainCode,BranchCode
) AS mlrs ON lrs.MainCode = mlrs.MainCode and lrs.BranchCode = mlrs.BranchCode 
AND lrs.DueDate = mlrs.DUEDATE
LEFT JOIN
(
	SELECT MainCode,BranchCode,COUNT(*) AS FLOWNO FROM LoanRepaySched lrs2,ControlTable ct WHERE lrs2.DueDate > ct.Today GROUP BY MainCode,BranchCode
) AS clrs ON m.MainCode = clrs.MainCode and m.BranchCode = clrs.BranchCode
,ControlTable ct1
WHERE m.AcType
IN('30','31','32','33','36','37','38','39','3A','3B','3E','3F','3K','3L','3M','3N','3O','3P','3Q','3R','3S','3T','3U','3X','40','42','43','46','4A','4B','4F','4G','4I','4J','4K','4M','4O','4P','4Q','4S','3V','3Y','3Z','47','48','4C','4D','4E')
AND m.Balance <> 0 
AND m.Limit <> 0
AND m.IsBlocked NOT IN ('C','o')
AND LEN(m.ClientCode) >= 8
and lrs.DueDate > ct1.Today
--ORDER BY m.MainCode,m.BranchCode
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = m.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
) 

UNION

SELECT
lrs.MainCode AS foracid
,CASE WHEN lrs.DueInterest > 0 THEN 'EIDEM'
 ELSE 'EIDEM'
 END AS flow_id  -- Need to be confirmed
,CONVERT(VARCHAR(10),mlrs.DUEDATE,105) AS flow_start_date   -- Need to be confirmed
,CASE WHEN lm.RepayFreq = '1' THEN 'D'
	WHEN lm.RepayFreq = '2' THEN 'W'
	WHEN lm.RepayFreq = '4' THEN 'M'
	WHEN lm.RepayFreq = '5' THEN 'Q'
	WHEN lm.RepayFreq = '6' THEN 'H'
	WHEN lm.RepayFreq = '7' THEN 'Y'
ELSE 'M'
END  AS lr_freq_type  
,'' AS lr_freq_week_num
,'' AS lr_freq_week_day
,DATEPART(DAY,lrs.DueDate) AS lr_freq_start_dd  -- Need to be confirmed
,'' AS lr_freq_months
,'' AS lr_freq_days
,'N' AS lr_freq_hldy_stat
,RIGHT(SPACE(3)+CAST(clrs.FLOWNO AS VARCHAR(3)),3) AS num_of_flows
,RIGHT(SPACE(17)+CAST(lrs.TotPayment AS VARCHAR(17)),17) AS flow_amt  -- Need to be confirmed (For now, its fine, but in some case this may not work)
,'' AS instlmnt_pcnt
,RIGHT(SPACE(3)+CAST('0' AS VARCHAR(3)),3) AS num_of_dmds
,'' AS next_dmd_date   
,CONVERT(VARCHAR(10),mlrs.DUEDATE,105) AS next_int_dmd_date  -- Same as Flow Start date, need to be confirmed
,CASE WHEN lm.AutoGenInt = 'F' THEN 
	m.IntPostFrqDr
 ELSE 
	lm.RepayFreq
 END AS lr_int_freq_type
,'' AS lr_int_freq_week_num
,'' AS lr_int_freq_week_day
,CASE WHEN lm.AutoGenInt = 'F' THEN 
	m.IntPostFrqDr
 ELSE 
	DATEPART(DAY,DueDate)
 END AS lr_int_freq_start_dd
,'' AS lr_int_freq_months
,'' AS lr_int_freq_days
,'N' AS lr_int_freq_hldy_stat
,'' AS instlmnt_ind
FROM LoanRepaySched lrs
LEFT JOIN Master m ON lrs.MainCode = m.MainCode and lrs.BranchCode = m.BranchCode
LEFT JOIN LoanMaster lm ON lrs.MainCode = lm.MainCode AND lrs.BranchCode = lm.BranchCode
JOIN     -- to get single record
(
	SELECT MainCode,BranchCode,MIN(DueDate) AS DUEDATE FROM LoanRepaySched lrs1,ControlTable ct WHERE lrs1.DueDate > ct.Today GROUP BY MainCode,BranchCode
) AS mlrs ON lrs.MainCode = mlrs.MainCode and lrs.BranchCode = mlrs.BranchCode 
AND lrs.DueDate = mlrs.DUEDATE
LEFT JOIN
(
	SELECT MainCode,BranchCode,COUNT(*) AS FLOWNO FROM LoanRepaySched lrs2,ControlTable ct WHERE lrs2.DueDate > ct.Today GROUP BY MainCode,BranchCode
) AS clrs ON m.MainCode = clrs.MainCode and m.BranchCode = clrs.BranchCode
,ControlTable ct1
WHERE m.AcType
IN('30','31','32','33','36','37','38','39','3A','3B','3E','3F','3K','3L','3M','3N','3O','3P','3Q','3R','3S','3T','3U','3X','40','42','43','46','4A','4B','4F','4G','4I','4J','4K','4M','4O','4P','4Q','4S','3V','3Y','3Z','47','48','4C','4D','4E')
AND m.Balance <> 0 
AND m.Limit <> 0
AND m.IsBlocked NOT IN ('C','o')
AND LEN(m.ClientCode) >= 8
and lrs.DueDate > ct1.Today
--ORDER BY m.MainCode,m.BranchCode
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = m.MainCode and CustTypeCode = 'Z' and CustType NOT IN ('11','12')
) 