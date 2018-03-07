IF OBJECT_ID('tempdb.dbo.#tempwtx_flg', 'U') IS NOT NULL
 DROP TABLE #tempwtx_flg;
select m.MainCode
--,count(*) as duplicacy
,case when m.AcType in ('01','03','04','05','06') then 'N'
     when m.AcType < '48' and m.TaxPercentOnInt='0' and m.IntPostFrqCr <> '9' and m.TaxPostFrq <> '9' then 'N'
	 when m.AcType < '48' and m.TaxPercentOnInt<> '0' and (m.IntPostFrqCr <> '9' or m.TaxPostFrq <> '9') and m.IntCrRate='0' then 'N'
     else 'W'
end as wtax_flg,
case when m.AcType in ('01','03','04','05','06') then 'A'
     when m.AcType < '48' and m.TaxPercentOnInt='0' and m.IntPostFrqCr <> '9' and m.TaxPostFrq <> '9' then 'N'
	 when m.AcType < '48' and m.TaxPercentOnInt<> '0' and (m.IntPostFrqCr <> '9' or m.TaxPostFrq <> '9') and m.IntCrRate='0' then 'N'
     else 'S'
end as wtax_level
into #tempwtx_flg
from Master m
where left(m.ClientCode,1)<>'_'
and AcType in ('01','02','03','04','05','07','08','09',
'0A','0B','0C','0D','0E','0F','0G','0H','0I','0J','0K','0L','0M','0N','0O','0P','0Q','0R','0S','0T','0U','0W','0Y','
0Z','10','11','12','3A','3B','3E','3F','3K','3L','3N','3O','3P','3Q','3R','3S','3T','3U','3V','3X','3Y','3Z','4A',
'4B','4C','4D','4E','4F','4G','4J','4K','4M','4N','4O','4P','4Q','4R','4S','9A','9B','9C','9D','9F','9X');

--and AcType in ('05','07','08','09','10','11','12','0A','0B','0C','0D','0E','0F','0G','0H',
--'0I','0J','0K','0L','0M','0N','0O','0P','0Q','0R','0S','0T','0U','0W','0Y','0Z',
--'3A','3B','3E','3F','3K','3L','3N','3O','3P','3Q','3R','3S','3T','3U','3V','3X','3Y','3Z','4A',
--'4B','4C','4D','4E','4F','4G','4J','4K','4M','4N','4O','4P','4Q','4R','4S','9A','9B','9C','9D','9F','9X') --, NOT equal to 0X

IF OBJECT_ID('tempdb.dbo.#FinalMaster', 'U') IS NOT NULL
  DROP TABLE #FinalMaster;
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
		,ROW_NUMBER() OVER( PARTITION BY ClientCode ORDER BY AcOpenDate,MainCode) AS SerialNumber
		FROM Master WITH (NOLOCK)
		WHERE IsBlocked NOT IN ('C','o')
	) AS t 
WHERE t.SerialNumber = 1 ORDER BY 1;

IF OBJECT_ID('tempdb.dbo.#ClientName', 'U') IS NOT NULL
  DROP TABLE #ClientName;
IF OBJECT_ID('tempdb.dbo.#ClientName', 'U') IS NOT NULL
  DROP TABLE #ClientName;
  
SELECT ClientCode, CASE WHEN CHARINDEX('/',Name)  > 0 THEN SUBSTRING(Name,0,CHARINDEX('/',Name)) 
ELSE Name
END as Name,Name AS Orig_Name
INTO #ClientName
FROM ClientTable

select top 10
t1.MainCode AS foracid
,wtemp.wtax_flg AS wtax_flg
,case when wtemp.wtax_flg ='N' then ''
 else 'P' end AS wtax_amount_scope_flg
,case when t1.TaxPostFrq=9 then RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17)
 when t1.IntPostFrqCr=9 then RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17)
 when t1.AcType in  ('01','02','03','04','28','0X') then RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17)
 else RIGHT(SPACE(17)+CAST(t1.TaxPercentOnInt AS VARCHAR(17)),17)
 end AS wtax_pcnt
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS wtax_floor_limit
,'R0'+t1.ClientCode AS CIF_id
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS cust_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS cust_dr_pref_pcnt
,RIGHT(SPACE(10)+CAST(isnull((pt.IntCrRateDef-t1.IntCrRate),0) AS VARCHAR(10)),10) AS id_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS id_dr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS chnl_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS chnl_dr_pref_pcnt
,'N' AS Pegged_flg
,'' AS peg_frequency_in_months
,'' AS peg_frequency_in_days
--,case when m.IntPostFrqCr = 4 then 'M' 
 --when m.IntPostFrqCr in (5,6) then 'Q'
 --when m.IntPostFrqCr = '7' then 'R'
 --else 'D'
 --end AS int_freq_type_cr
,'D' AS int_freq_type_cr
,'' AS int_freq_week_num_cr
,'' AS int_freq_week_day_cr
,'' AS int_freq_start_dd_cr
,'P' AS int_freq_hldy_stat_cr
,convert(varchar,GETDATE()+1, 105) AS next_int_run_date_cr
,CASE WHEN t1.AcType In ('01','02','03','04','28','29') THEN 'M' ELSE '' END AS int_freq_type_dr
,'' AS int_freq_week_num_dr
,'' AS int_freq_week_day_dr
,'' AS int_freq_start_dd_dr
,'' AS int_freq_hldy_stat_dr
,CASE WHEN t1.AcType In ('01','02','03','04','28','29') THEN convert(varchar,GETDATE()+1, 105) ELSE '' END AS next_int_run_date_dr
,'' AS ledg_num
,LEFT(SPACE(10)+CAST(fet.EmpId AS VARCHAR(10)),10) AS emp_id
,convert(varchar(10),tmaster.mindate,105) AS acct_opn_date
,'999' AS Mode_of_oper_code
,case when fst.PumoriAcType='01' and fst.PumoriCyCode='01' and t1.Limit < 0 then '25055'
 when fst.PumoriAcType='01' and fst.PumoriCyCode='01' and t1.Limit >= 0 then '25005'
 else fst.FinacleSubGL
 end AS Gl_sub_head_code
,fst.FinacleSchCode AS Schm_code
,case when t1.AcType in ('02','03','04','05','07','0X','0Z','28') then 'N' 
 else 'Y'  end AS Chq_alwd_flg
,'S' AS Pb_ps_code
,case when t1.IsBlocked in('B','T','L','D') then 'T' when t1.IsBlocked ='-' then 'C' when t1.IsBlocked ='+' then 'D' end AS Frez_code
,case when t1.IsBlocked in('B','T','L','D') then '00003' when t1.IsBlocked ='-' then '00003' when t1.IsBlocked ='+' then '00003' end  AS Frez_reason_code
,t1.MainCode AS free_text
, case when t1.IsDormant = 'T' then 'D' 
  Else 'A' end AS acct_Status
,'' AS free_code_1
,'' AS free_code_2
,'MIGR' AS free_code_3
,'' AS free_code_4
,'' AS free_code_5
,'' AS free_code_6
,'' AS free_code_7
,'' AS free_code_8
,'' AS free_code_9
,'' AS free_code_10
,'' AS int_tbl_code
,'' AS acct_loc_code
,CASE WHEN cur.CyDesc = 'IRS' THEN 'INR' ELSE cur.CyDesc END AS acct_crncy_code
,t1.BranchCode AS sol_id
,'UBSADMIN' AS acct_mgr_user_id
,t1.Name AS acct_name
,'N' AS swift_allowed_flg
,convert(varchar(10),t1.LastTranDate,105) AS last_tran_date
,'' AS last_any_tran_date
,'' AS xclude_for_comb_stmt 
,'' AS stmt_cust_id
,'' AS chrg_level_code
,'' AS pbf_download_flg
,wtemp.wtax_level AS wtax_level_flg
,case when t1.AcType='01' then RIGHT(SPACE(17)+CAST(t1.Limit AS VARCHAR(17)),17) 
 else RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) end AS sanct_lim
,case when t1.AcType='01' then RIGHT(SPACE(17)+CAST(t1.Limit AS VARCHAR(17)),17) 
 else RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) end AS Drwng_power
, case when t1.AcType='01' then RIGHT(SPACE(17)+CAST(t1.Limit AS VARCHAR(17)),17) 
 else RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) end AS dacc_lim_abs
,RIGHT(SPACE(8)+CAST('0' AS VARCHAR(8)),8) AS dacc_lim_pcnt
,case when t1.AcType='01' then RIGHT(SPACE(17)+CAST(t1.Limit AS VARCHAR(17)),17) 
 else RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) end AS max_alwd_advn_lim
,'' AS health_code
,'' AS sanct_levl_code
,'' AS sanct_ref_num
,'' AS lim_sanct_date
,'' AS lim_exp_date
,'' AS lim_review_date
,'' AS loan_paper_date
,'' AS sanct_auth_code
,'' AS Compound_date
,'' AS daily_comp_int_flg
,'' AS COMP_Date_flg
,'' AS disc_rate_flg 
,'' AS dummy
,--CASE WHEN t1.IsDormant='T' THEN convert(VARCHAR,dateadd(MM,6,isnull(t1.LastTranDate,case when AcOpenDate > getdate() then dbo.f_GetRomanDate(datepart(day,AcOpenDate),datepart(month,AcOpenDate),datepart(year,AcOpenDate)) else AcOpenDate end)),105) ELSE '01-01-2018' END AS acct_status_date
'01-01-2018' AS acct_status_date
,'' AS iban_number
,'' AS ias_code
,'' AS channel_id
,'' AS channel_level_code
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS int_suspense_amt
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS Penal_int_Suspense_amt
,'' AS Chrge_off_flg
,case when t1.AcType = '01' and t1.Limit <> '0' then 'Y' end AS pd_flg
,'' AS pd_xfer_Date
,'' AS Chrge_off_date
,'' AS Chrge_off_principal
,'' AS Pending_interest
,'' AS Principal_recovery
,'' AS interest_recovery
,'' AS Charge_off_type
,'' AS master_acct_num
,'' AS ps_diff_freq_rel_party_flg
,'' AS swift_diff_freq_rel_party_flg
,'' AS add_type
,'' AS Phone_type
,'' AS Email_type
,' ' AS Alternate_Acct_Name                                        
,' ' AS Interest_Rate_Period_Months                                
,' ' AS Interest_Rate_Period_Days                                  
,' ' AS Interpolation_Method                                       
,' ' AS Is_Acct_hedged_Flg                                         
,' ' AS Used_for_netting_off_flg                                   
,' ' AS Security_Indicator                                         
,' ' AS Debt_Security                                              
,' ' AS Security_Code                                              
,' ' AS Debit_Interest_Method                                      
,''  AS serv_chrg_coll_flg
,' ' AS Last_purge_date                                            
,' ' AS Total_profit_amt                                           
,' ' AS Minimum_age_not_met_amt                                    
,' ' AS Broken_period_profit_paid_flg                              
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS Broken_period_profit_amt                                   
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS Profit_to_be_recovered 
,' ' AS Profit_distributed_upto_date                               
,' ' AS Next_profit_distributed_date                               
,' ' AS Accrued_amt_till_interest_calc_date_cr                                
,' ' AS Unclaim_status  
FROM #FinalMaster t1
left join #tempwtx_flg wtemp on wtemp.MainCode =t1.MainCode
JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode
LEFT JOIN FinacleEmployeeTable fet on fet.ClientCode = t2.ClientCode
join FinacleSchemeTable fst on fst.PumoriAcType=t1.AcType and fst.PumoriCyCode=t1.CyCode
LEFT JOIN
(
	select MainCode,CustType,BranchCode from AcCustType where CustTypeCode = 'Z'
) as accust on accust.MainCode = t1.MainCode and accust.BranchCode = t1.BranchCode
left join ParaTable pt on pt.BranchCode=t1.BranchCode and pt.AcType = t1.AcType and pt.CyCode = t1.CyCode
left join CurrencyTable cur on cur.CyCode=t1.CyCode
JOIN 
(							-- Filters the clientcode with minimum account open date
	SELECT t.ClientCode,MIN(t.AcOpenDate) AS mindate FROM Master t GROUP BY t.ClientCode
) AS tmaster ON tmaster.ClientCode = t1.ClientCode AND tmaster.mindate = t1.AcOpenDate
,ControlTable ctrlt
WHERE LEFT(t2.ClientCode,1) <> '_'
and t1.Limit <= 0
and len(t1.ClientCode) >= 8
and t1.AcType in ('01','02','03','04','05','07','08','09','0A','0B','0C','0D','0E','0F','0G','0H','0I','0J','0K','0L','0M','0N','0O','0P','0Q','0R','0S','0T','0U','0W','0Y','0Z','10','11','12','3A','3B','3E','3F','3K','3L','3N','3O','3P','3Q','3R','3S','3T','3U','3V','3X','3Y','3Z','4A','4B','4C','4D','4E','4F','4G','4J','4K','4M','4N','4O','4P','4Q','4R','4S','9A','9B','9C','9D','9F','9X')
and t1.ClientCode <> '00408728'
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = t1.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
) 
--ORDER BY 1

UNION
 
SELECT DISTINCT top 10
t1.MainCode AS foracid
,wtemp.wtax_flg AS wtax_flg
,case when wtemp.wtax_flg ='N' then ''
 else 'P' end AS wtax_amount_scope_flg
,case when t1.TaxPostFrq=9 then RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17)
 when t1.IntPostFrqCr=9 then RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17)
 when t1.AcType in  ('01','02','03','04','28','0X') then RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17)
 else RIGHT(SPACE(17)+CAST(t1.TaxPercentOnInt AS VARCHAR(17)),17)
 end AS wtax_pcnt
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS wtax_floor_limit
,'C' + t1.ClientCode AS CIF_id
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS cust_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS cust_dr_pref_pcnt
,RIGHT(SPACE(10)+CAST(isnull((pt.IntCrRateDef-t1.IntCrRate),0) AS VARCHAR(10)),10) AS id_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS id_dr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS chnl_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS chnl_dr_pref_pcnt
,'N' AS Pegged_flg
,'' AS peg_frequency_in_months
,'' AS peg_frequency_in_days
--,case when m.IntPostFrqCr = 4 then 'M' 
 --when m.IntPostFrqCr in (5,6) then 'Q'
 --when m.IntPostFrqCr = '7' then 'R'
 --else 'D'
 --end AS int_freq_type_cr
,'D' AS int_freq_type_cr
,'' AS int_freq_week_num_cr
,'' AS int_freq_week_day_cr
,'' AS int_freq_start_dd_cr
,'P' AS int_freq_hldy_stat_cr
,convert(varchar,GETDATE()+1, 105) AS next_int_run_date_cr
,CASE WHEN t1.AcType In ('01','02','03','04','28','29') THEN 'M' ELSE '' END  AS int_freq_type_dr
,'' AS int_freq_week_num_dr
,'' AS int_freq_week_day_dr
,'' AS int_freq_start_dd_dr
,'' AS int_freq_hldy_stat_dr
,CASE WHEN t1.AcType In ('01','02','03','04','28','29') THEN convert(varchar,GETDATE()+1, 105) ELSE '' END  AS next_int_run_date_dr
,'' AS ledg_num
,LEFT(SPACE(10)+CAST(fet.EmpId AS VARCHAR(10)),10)AS emp_id
,convert(varchar(10),tmaster.mindate,105) AS acct_opn_date
,'999' AS Mode_of_oper_code
,case when fst.PumoriAcType='01' and fst.PumoriCyCode='01' and t1.Limit < 0 then '25055'
 when fst.PumoriAcType='01' and fst.PumoriCyCode='01' and t1.Limit >= 0 then '25005'
 else fst.FinacleSubGL
 end AS Gl_sub_head_code
,fst.FinacleSchCode AS Schm_code
,case when t1.AcType in ('02','03','04','05','07','0X','0Z','28') then 'N' 
 else 'Y'  end AS Chq_alwd_flg
,'S' AS Pb_ps_code
,case when t1.IsBlocked in('B','T','L','D') then 'T' when t1.IsBlocked ='-' then 'C' when t1.IsBlocked ='+' then 'D' end AS Frez_code
,case when t1.IsBlocked in('B','T','L','D') then '00003' when t1.IsBlocked ='-' then '00003' when t1.IsBlocked ='+' then '00003' end  AS Frez_reason_code
,t1.MainCode AS free_text
, case when t1.IsDormant = 'T' then 'D' 
  Else 'A' end AS acct_Status
,'' AS free_code_1
,'' AS free_code_2
,'MIGR' AS free_code_3
,'' AS free_code_4
,'' AS free_code_5
,'' AS free_code_6
,'' AS free_code_7
,'' AS free_code_8
,'' AS free_code_9
,'' AS free_code_10
,'' AS int_tbl_code
,'' AS acct_loc_code
,CASE WHEN cur.CyDesc = 'IRS' THEN 'INR' ELSE cur.CyDesc END AS acct_crncy_code
,t1.BranchCode AS sol_id
,'UBSADMIN' AS acct_mgr_user_id
,t1.Name AS acct_name
,'N' AS swift_allowed_flg
,convert(varchar(10),t1.LastTranDate,105) AS last_tran_date
,'' AS last_any_tran_date
,'' AS xclude_for_comb_stmt 
,'' AS stmt_cust_id
,'' AS chrg_level_code
,'' AS pbf_download_flg
,wtemp.wtax_level AS wtax_level_flg
,case when t1.AcType='01' then RIGHT(SPACE(17)+CAST(t1.Limit AS VARCHAR(17)),17) 
 else RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) end AS sanct_lim
,case when t1.AcType='01' then RIGHT(SPACE(17)+CAST(t1.Limit AS VARCHAR(17)),17) 
 else RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) end AS Drwng_power
, case when t1.AcType='01' then RIGHT(SPACE(17)+CAST(t1.Limit AS VARCHAR(17)),17) 
 else RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) end AS dacc_lim_abs
,RIGHT(SPACE(8)+CAST('0' AS VARCHAR(8)),8) AS dacc_lim_pcnt
,case when t1.AcType='01' then RIGHT(SPACE(17)+CAST(t1.Limit AS VARCHAR(17)),17) 
 else RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) end AS max_alwd_advn_lim
,'' AS health_code
,'' AS sanct_levl_code
,'' AS sanct_ref_num
,'' AS lim_sanct_date
,'' AS lim_exp_date
,'' AS lim_review_date
,'' AS loan_paper_date
,'' AS sanct_auth_code
,'' AS Compound_date
,'' AS daily_comp_int_flg
,'' AS COMP_Date_flg
,'' AS disc_rate_flg 
,'' AS dummy
,--CASE WHEN t1.IsDormant='T' THEN convert(VARCHAR,dateadd(MM,6,isnull(t1.LastTranDate,case when AcOpenDate > getdate() then dbo.f_GetRomanDate(datepart(day,AcOpenDate),datepart(month,AcOpenDate),datepart(year,AcOpenDate)) else AcOpenDate end)),105) ELSE '01-01-2018' END AS acct_status_date
'01-01-2018' AS acct_status_date
,'' AS iban_number
,'' AS ias_code
,'' AS channel_id
,'' AS channel_level_code
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS int_suspense_amt
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS Penal_int_Suspense_amt
,'' AS Chrge_off_flg
,case when t1.AcType = '01' and t1.Limit <> '0' then 'Y' end AS pd_flg
,'' AS pd_xfer_Date
,'' AS Chrge_off_date
,'' AS Chrge_off_principal
,'' AS Pending_interest
,'' AS Principal_recovery
,'' AS interest_recovery
,'' AS Charge_off_type
,'' AS master_acct_num
,'' AS ps_diff_freq_rel_party_flg
,'' AS swift_diff_freq_rel_party_flg
,'' AS add_type
,'' AS Phone_type
,'' AS Email_type
,' ' AS Alternate_Acct_Name                                        
,' ' AS Interest_Rate_Period_Months                                
,' ' AS Interest_Rate_Period_Days                                  
,' ' AS Interpolation_Method                                       
,' ' AS Is_Acct_hedged_Flg                                         
,' ' AS Used_for_netting_off_flg                                   
,' ' AS Security_Indicator                                         
,' ' AS Debt_Security                                              
,' ' AS Security_Code                                              
,' ' AS Debit_Interest_Method                                      
,''  AS serv_chrg_coll_flg
,' ' AS Last_purge_date                                            
,' ' AS Total_profit_amt                                           
,' ' AS Minimum_age_not_met_amt                                    
,' ' AS Broken_period_profit_paid_flg                              
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS Broken_period_profit_amt                                   
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS Profit_to_be_recovered 
,' ' AS Profit_distributed_upto_date                               
,' ' AS Next_profit_distributed_date                               
,' ' AS Accrued_amt_till_interest_calc_date_cr                                
,' ' AS Unclaim_status  
FROM #FinalMaster t1
left join #tempwtx_flg wtemp on wtemp.MainCode =t1.MainCode
JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode
LEFT JOIN FinacleEmployeeTable fet on fet.ClientCode = t2.ClientCode
join FinacleSchemeTable fst on fst.PumoriAcType=t1.AcType and fst.PumoriCyCode=t1.CyCode
LEFT JOIN
(
	select MainCode,CustType,BranchCode from AcCustType where CustTypeCode = 'Z'
) as accust on accust.MainCode = t1.MainCode and accust.BranchCode = t1.BranchCode
left join ParaTable pt on pt.BranchCode=t1.BranchCode and pt.AcType = t1.AcType and pt.CyCode = t1.CyCode
LEFT JOIN CurrencyTable cur ON t1.CyCode = cur.CyCode
LEFT JOIN 
(	-- Take the unique name on the basis of max sequence number
	select MainCode,Name from ImageTable where SeqNo  in(
	select max(SeqNo) as seq from ImageTable group by MainCode)
) as t3 ON t1.MainCode = t3.MainCode  -- need to be checked with bank data putting inner join
JOIN 
(							-- Filters the clientcode with minimum account open date
	SELECT t.ClientCode,MIN(t.AcOpenDate) AS mindate FROM Master t GROUP BY t.ClientCode
) AS tmaster ON tmaster.ClientCode = t1.ClientCode AND tmaster.mindate = t1.AcOpenDate
,ControlTable ctrlt
WHERE t1.AcType in ('01','02','03','04','05','07','08','09','0A','0B','0C','0D','0E','0F','0G','0H','0I','0J','0K','0L','0M','0N','0O','0P','0Q','0R','0S','0T','0U','0W','0Y','0Z','10','11','12','3A','3B','3E','3F','3K','3L','3N','3O','3P','3Q','3R','3S','3T','3U','3V','3X','3Y','3Z','4A','4B','4C','4D','4E','4F','4G','4J','4K','4M','4N','4O','4P','4Q','4R','4S','9A','9B','9C','9D','9F','9X') 
--t1.AcType in ('05','07','08','09','10','11','12','0A','0B','0C','0D','0E','0F','0G','0H',
--'0I','0J','0K','0L','0M','0N','0O','0P','0Q','0R','0S','0T','0U','0W','0Y','0Z',
--'3A','3B','3E','3F','3K','3L','3N','3O','3P','3Q','3R','3S','3T','3U','3V','3X','3Y','3Z','4A',
--'4B','4C','4D','4E','4F','4G','4J','4K','4M','4N','4O','4P','4Q','4R','4S','9A','9B','9C','9D','9F','9X')
and EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = t1.MainCode and CustTypeCode = 'Z' and CustType NOT IN ('11','12')
)
 --ORDER BY 1