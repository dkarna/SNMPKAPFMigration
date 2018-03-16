-- CS003

IF OBJECT_ID('tempdb.dbo.#FinalMaster', 'U') IS NOT NULL
  DROP TABLE #FinalMaster;
SELECT *
INTO #FinalMaster
FROM
	(
		SELECT DISTINCT
		 [Name]
		,ClientCode
		,AcType
		,BranchCode
		,Obligor
		,AcOpenDate
		,MainCode
		,CyCode
		,Limit
		,TaxPostFrq
		,TaxPercentOnInt
		,IntCrRate
		,IntPostFrqCr
		,IsDormant
		,IsBlocked
		,LastTranDate
		,Balance
		,ROW_NUMBER() OVER( PARTITION BY ClientCode ORDER BY AcOpenDate,MainCode) AS SerialNumber
		FROM Master WITH (NOLOCK)
		WHERE IsBlocked NOT IN ('C','o')
	) AS t 
WHERE t.SerialNumber = 1 ORDER BY 1;


IF OBJECT_ID('tempdb.dbo.#ClientName', 'U') IS NOT NULL
  DROP TABLE #ClientName;
  
SELECT ClientCode, CASE WHEN CHARINDEX('/',Name)  > 0 THEN SUBSTRING(Name,0,CHARINDEX('/',Name)) 
ELSE Name
END as Name,Name AS Orig_Name
INTO #ClientName
FROM ClientTable

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
FROM #FinalMaster M
--Master M
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
AND M.AcType In ('01','05','06','07','08','09','0A','0B','0C','0D','0E','0F','0G','0H','0I','0J','0K','0L',
 '0M','0N','0O','0P','0Q','0R','0S','0T','0U','0V','0W','0X','0Y','0Z','10','11','28','29','3C','3D','3G','3H','3I','3J','0V','3W','4H','4L')
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = M.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
) 

union

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
FROM #FinalMaster M
--Master M
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
AND C.ClientStatus <> 'Z'
AND LEN(M.ClientCode) >= 8
AND M.AcType In ('01','05','06','07','08','09','0A','0B','0C','0D','0E','0F','0G','0H','0I','0J','0K','0L',
 '0M','0N','0O','0P','0Q','0R','0S','0T','0U','0V','0W','0X','0Y','0Z','10','11','28','29','3C','3D','3G','3H','3I','3J','0V','3W','4H','4L')
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = M.MainCode and CustTypeCode = 'Z' and CustType NOT IN ('11','12')
)