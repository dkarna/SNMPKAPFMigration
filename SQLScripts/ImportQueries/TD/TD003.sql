-- Query for TD003
SELECT
'' AS foracid
,'1' AS print_count
,'S' AS print_system_flg
,'' AS print_remarks
,t1.DealOpenDate AS printed_date
,'' AS last_printed_user_id
,'A' AS receipt_status
,'' AS receipt_alpha
,t1.ReferenceNo AS receipt_number
,'' AS denomination_amt
,'' AS closed_value_date
,'Y' AS end_indicator 	-- field not available in finacle field list
,'' AS dummy			-- field not available in finacle field list
FROM DealTable t1
WHERE AcType >= '13' AND AcType <= '21' 
AND MaturityDate > GETDATE() ORDER BY MainCode;