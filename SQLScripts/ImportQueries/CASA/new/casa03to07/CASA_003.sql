select 
 M.MainCode foracid
,Cur.CyDesc acct_crncy_code
,M.BranchCode sol_id
,'M' acct_poa_as_rec_type
,CASE	WHEN C.ClientCode IS NULL THEN LEFT(M.Name, CHARINDEX('/', M.Name))
		ELSE ' '
 END acct_poa_as_name
,' ' acct_poa_as_desig
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) acct_poa_as_amt_alwd
,convert(varchar,TMaster.MinAcOpenDate,105) start_date
,'31-12-2099' end_date
,C.ClientCode cust_id
,'20' cust_reltn_code
,'Y' pass_sheet_flg
,'Y' si_flg
,'Y' td_matrty_flg
,'Y' loan_ovrdue_flg
,C.Address1 address1
,C.Address2 address2
,C.Address3 address3
,'MIGR' city_code
,' ' state_code
,' ' pin_code
,' ' cntry_code
,C.Phone phone_num1
,' ' fax_num1
,' ' tlx_num
,C.eMail email_id
,'Y' xclude_for_comb_stmt
,'Y' stmt_cust_id
,CASE	WHEN LOWER(Gender) = 'f' OR Salutation  = 'MRS' THEN 'MS'
		WHEN LOWER(Gender) = 'm' OR Salutation  = 'MR'  THEN 'MR' 
		WHEN LOWER(Gender) NOT IN ('f','m') AND CustType IN ('11','12') THEN 'MIG.'
		ELSE 'M/S'
 END cust_title_code
,' ' intcert_print_flg
,' ' int_adv_flg
,' ' guarantor_liab_pcnt
,' ' guarantor_liab_seq
,'D' ps_freq_type
,' ' ps_freq_week_num
,' ' ps_freq_week_day
,' ' ps_freq_start_dd
,' ' ps_freq_hldy_stat
,' ' swift_stmt_srl_num
,'N' mode_of_despatch
,' ' swift_freq_type
,' ' swift_freq_week_num
,' ' swift_freq_week_day
,' ' swift_freq_start_dd
,' ' swift_freq_hldy_stat
,' ' swft_msg_type
,' ' paysys_id
,' ' nma_key_type
,' ' cust_phone_type
,' ' cust_email_type
,' ' CS003_051                                              
FROM Master M
LEFT JOIN 
(
	SELECT  MainCode,BranchCode, MIN(AcOpenDate) MinAcOpenDate
	FROM Master
	GROUP BY MainCode, BranchCode
)TMaster ON M.MainCode = TMaster.MainCode AND M.BranchCode = TMaster.BranchCode
LEFT JOIN CurrencyTable Cur on Cur.CyCode = M.CyCode
LEFT JOIN ClientTable C on M.ClientCode = C.ClientCode
LEFT JOIN AcCustType ACT ON ACT.MainCode = M.MainCode AND ACT.BranchCode = M.BranchCode
WHERE LEFT(C.ClientCode , 1) <>'_'
AND IsBlocked NOT IN ('C','o')
AND ACT.CustTypeCode = 'Z'
AND C.ClientStatus <> 'Z'


 