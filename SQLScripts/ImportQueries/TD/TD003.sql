-- Query for TD003
SELECT
'' AS foracid
,RIGHT(SPACE(3)+CAST('1' AS VARCHAR(3)),3) AS print_count
,'S' AS print_system_flg
,'' AS print_remarks
,CONVERT(VARCHAR(10),t1.DealOpenDate,105) AS printed_date
,'' AS last_printed_user_id
,'A' AS receipt_status
,'' AS receipt_alpha
,t1.ReferenceNo AS receipt_number
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS denomination_amt
,'' AS closed_value_date
,'Y' AS end_indicator 	-- field not available in finacle field list
,'' AS dummy			-- field not available in finacle field list
FROM DealTable t1,ControlTable ct
WHERE AcType >= '13' AND AcType <= '21' 
AND MaturityDate > ct.Today ORDER BY MainCode;