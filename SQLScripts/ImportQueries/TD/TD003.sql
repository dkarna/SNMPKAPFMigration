-- Query for TD003

select * from
(
	-- Retail
	SELECT
	'R0'+ m.MainCode AS foracid
	,RIGHT(SPACE(3)+CAST('1' AS VARCHAR(3)),3) AS print_count
	,'S' AS print_system_flg
	,'' AS print_remarks
	,CONVERT(VARCHAR(10),dt.DealOpenDate,105) AS printed_date
	,'' AS last_printed_user_id
	,'A' AS receipt_status
	,'' AS receipt_alpha
	,dt.ReferenceNo AS receipt_number
	,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS denomination_amt
	,'' AS closed_value_date
	,'Y' AS end_indicator 	-- field not available in finacle field list
	,'' AS dummy			-- field not available in finacle field list
	FROM DealTable dt
	left join Master m on dt.MainCode = m.MainCode and dt.BranchCode=m.BranchCode
	,ControlTable ct
	WHERE dt.AcType >= '13' AND dt.AcType <= '21' 
	and len(m.ClientCode) >= 8
	and left(m.ClientCode,1)<>'_'
	and m.IsBlocked NOT IN ('C','o')
	AND dt.MaturityDate > ct.Today
	and EXISTS
	(
		SELECT 1 FROM AcCustType WHERE MainCode = m.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
	)

	UNION
	-- Corporate
	SELECT
	'C'+ m.MainCode AS foracid
	,RIGHT(SPACE(3)+CAST('1' AS VARCHAR(3)),3) AS print_count
	,'S' AS print_system_flg
	,'' AS print_remarks
	,CONVERT(VARCHAR(10),dt.DealOpenDate,105) AS printed_date
	,'' AS last_printed_user_id
	,'A' AS receipt_status
	,'' AS receipt_alpha
	,dt.ReferenceNo AS receipt_number
	,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS denomination_amt
	,'' AS closed_value_date
	,'Y' AS end_indicator 	-- field not available in finacle field list
	,'' AS dummy			-- field not available in finacle field list
	FROM DealTable dt
	left join Master m on dt.MainCode = m.MainCode and dt.BranchCode=m.BranchCode
	,ControlTable ct
	WHERE dt.AcType >= '13' AND dt.AcType <= '21' 
	and len(m.ClientCode) >= 8
	and left(m.ClientCode,1)<>'_'
	and m.IsBlocked NOT IN ('C','o')
	AND dt.MaturityDate > ct.Today 
	and EXISTS
	(
		SELECT 1 FROM AcCustType WHERE MainCode = m.MainCode and CustTypeCode = 'Z' and CustType NOT IN ('11','12')
	)
) as t
order by t.foracid