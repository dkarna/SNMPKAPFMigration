--SQL Code for CS001

IF OBJECT_ID('tempdb.dbo.#tempwtx_flg', 'U') IS NOT NULL
 DROP TABLE #tempwtx_flg;
select m.MainCode
--,count(*) as duplicacy
,case when m.AcType in ('01','03','04','05','06') then 'N'
     when m.AcType < '48' and m.TaxPercentOnInt='0' and m.IntPostFrqCr <> '9' and m.TaxPostFrq <> '9' then 'N'
	 when m.AcType < '48' and m.TaxPercentOnInt<> '0' and (m.IntPostFrqCr <> '9' or m.TaxPostFrq <> '9') and m.IntCrRate='0' then 'N'
     else 'W'
end as wtax_flg
into #tempwtx_flg
from Master m
where left(m.ClientCode,1)<>'_'
and AcType in ('01','02','03','04','05','07','08','09','0A','0B','0C','0D','0E','0F','0G','0H','0I','0J','0K','0L','0M','0N','0O','0P','0Q','0R','0S','0T','0U','0W','0Y','0Z','10','11','12','3A','3B','3E','3F','3K','3L','3N','3O','3P','3Q','3R','3S','3T','3U','3V','3X','3Y','3Z','4A','4B','4C','4D','4E','4F','4G','4J','4K','4M','4N','4O','4P','4Q','4R','4S','9A','9B','9C','9D','9F','9X');


SELECT
'' AS foracid
,wtemp.wtax_flg AS wtax_flg
,case when wtemp.wtax_flg ='N' then ''
 else 'P' end AS wtax_amount_scope_flg
,case when m.TaxPostFrq=9 then RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17)
 when m.IntPostFrqCr=9 then RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17)
 when m.AcType in  ('01','02','03','04','28','0X') then RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17)
 else RIGHT(SPACE(17)+CAST(m.TaxPercentOnInt AS VARCHAR(17)),17)
 end AS wtax_pcnt
,NULL AS wtax_floor_limit
,case when accust.CustType not in ('11','12') then 'R0'+m.ClientCode
 else 'C' + m.ClientCode
 end AS CIF_id
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS cust_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS cust_dr_pref_pcnt
,RIGHT(SPACE(10)+CAST(isnull((pt.IntCrRateDef-m.IntCrRate),0) AS VARCHAR(10)),10) AS id_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS id_dr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS chnl_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS chnl_dr_pref_pcnt
,'N' AS Pegged_flg
,'' AS peg_frequency_in_months
,'' AS peg_frequency_in_days
,case when m.IntPostFrqCr = 4 then 'M' 
 when m.IntPostFrqCr in (5,6) then 'Q'
 when m.IntPostFrqCr = '7' then 'Y'
 else 'D'
 end AS int_freq_type_cr
,'' AS int_freq_week_num_cr
,'' AS int_freq_week_day_cr
,'' AS int_freq_start_dd_cr
,'S' AS int_freq_hldy_stat_cr
,'' AS next_int_run_date_cr
,'' AS int_freq_type_dr
,'' AS int_freq_week_num_dr
,'' AS int_freq_week_day_dr
,'' AS int_freq_start_dd_dr
,'' AS int_freq_hldy_stat_dr
,convert(varchar(10),ctrlt.Today,105) AS next_int_run_date_dr
,'' AS ledg_num
,fet.EmpId AS emp_id
,convert(varchar(10),tmaster.mindate,105) AS acct_opn_date
,'999' AS Mode_of_oper_code
,case when fst.PumoriAcType='01' and fst.PumoriCyCode='01' and m.Limit < 0 then '25055'
 when fst.PumoriAcType='01' and fst.PumoriCyCode='01' and m.Limit >= 0 then '25005'
 else fst.FinacleSubGL
 end AS Gl_sub_head_code
,fst.FinacleSchCode AS Schm_code
,case when m.AcType in ('02','03','04','05','07','0X','0Z','28') then 'N' 
 else 'Y'  end AS Chq_alwd_flg
,'S' AS Pb_ps_code
,case when m.IsBlocked in('B','T','L','D') then 'T' when m.IsBlocked ='-' then 'C' when m.IsBlocked ='+' then 'D' end AS Frez_code
,'OTHER' AS Frez_reason_code
,m.MainCode AS free_text
, case when m.IsDormant = 'T' then 'D' 
  Else 'A' end AS acct_Status
,'' AS free_code_1
,'' AS free_code_2
,'MIGRA' AS free_code_3
,'' AS free_code_4
,'' AS free_code_5
,'' AS free_code_6
,'' AS free_code_7
,'' AS free_code_8
,'' AS free_code_9
,'' AS free_code_10
,'' AS int_tbl_code
,left(ct.Address1,5) AS acct_loc_code
,cur.CyDesc AS acct_crncy_code
,m.BranchCode AS sol_id
,'UBSADMIN' AS acct_mgr_user_id
,m.Name AS acct_name
,'N' AS swift_allowed_flg
,convert(varchar(10),m.LastTranDate,105) AS last_tran_date
,'' AS last_any_tran_date
,'' AS xclude_for_comb_stmt 
,'' AS stmt_cust_id
,'' AS chrg_level_code
,'' AS pbf_download_flg
,'' AS wtax_level_flg
,case when m.AcType='01' then RIGHT(SPACE(17)+CAST(m.Limit AS VARCHAR(17)),17) 
 else RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) end AS sanct_lim
,case when m.AcType='01' then RIGHT(SPACE(17)+CAST(m.Limit AS VARCHAR(17)),17) 
 else RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) end AS Drwng_power
, case when m.AcType='01' then RIGHT(SPACE(17)+CAST(m.Limit AS VARCHAR(17)),17) 
 else RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) end AS dacc_lim_abs
,RIGHT(SPACE(8)+CAST('0' AS VARCHAR(8)),8) AS dacc_lim_pcnt
,case when m.AcType='01' then RIGHT(SPACE(17)+CAST(m.Limit AS VARCHAR(17)),17) 
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
,CASE WHEN IsDormant='T' THEN convert(VARCHAR,dateadd(MM,6,isnull(LastTranDate,case when AcOpenDate > getdate() then dbo.f_GetRomanDate(datepart(day,AcOpenDate),datepart(month,AcOpenDate),datepart(year,AcOpenDate)) else AcOpenDate end)),105) ELSE '01-01-2018' END AS acct_status_date
,'' AS iban_number
,'' AS ias_code
,'' AS channel_id
,'' AS channel_level_code
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS int_suspense_amt
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS Penal_int_Suspense_amt
,'' AS Chrge_off_flg
,case when m.AcType = '01' and m.Limit <> '0' then 'Y' end AS pd_flg
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
,'' AS CS001_104
,'' AS CS001_105
,'' AS CS001_106
,'' AS CS001_107
,'' AS CS001_108
,'' AS CS001_109
,'' AS CS001_110
,'' AS CS001_111
,'' AS CS001_112
,'' AS CS001_113
,'' AS serv_chrg_coll_flg
,'' AS CS001_115
,'' AS CS001_116
,'' AS CS001_117
,'' AS CS001_118
,'' AS CS001_119
,'' AS CS001_120
,'' AS CS001_121
,'' AS CS001_122
,'' AS CS001_123
,'' AS CS001_124
,'' AS CS001_125
,'' AS CS001_126
FROM Master m
left join #tempwtx_flg wtemp on wtemp.MainCode =m.MainCode
left join ClientTable ct on ct.ClientCode = m.ClientCode
LEFT JOIN
(
	select MainCode,CustType,BranchCode from AcCustType where CustTypeCode = 'Z'
) as accust on accust.MainCode = m.MainCode and accust.BranchCode = m.BranchCode
 JOIN 
(							-- Filters the clientcode with minimum account open date
	SELECT t.ClientCode,MIN(t.AcOpenDate) AS mindate FROM Master t GROUP BY t.ClientCode
) AS tmaster ON tmaster.ClientCode = m.ClientCode AND tmaster.mindate = m.AcOpenDate
left join FinacleSchemeTable fst on fst.PumoriAcType=m.AcType and fst.PumoriCyCode=m.CyCode
left join CurrencyTable cur on cur.CyCode=m.CyCode
left join FinacleEmployeeTable fet on fet.ClientCode=m.ClientCode and fet.MainCode=m.MainCode
left join ParaTable pt on pt.BranchCode=m.BranchCode and pt.AcType = m.AcType and pt.CyCode = m.CyCode,ControlTable ctrlt
where m.AcType in ('01','02','03','04','05','07','08','09','0A','0B','0C','0D','0E','0F','0G','0H','0I','0J','0K','0L','0M','0N','0O','0P','0Q','0R','0S','0T','0U','0W','0Y','0Z','10','11','12','3A','3B','3E','3F','3K','3L','3N','3O','3P','3Q','3R','3S','3T','3U','3V','3X','3Y','3Z','4A','4B','4C','4D','4E','4F','4G','4J','4K','4M','4N','4O','4P','4Q','4R','4S','9A','9B','9C','9D','9F','9X')
and m.Limit <= 0
and left(m.ClientCode,1)<>'_' 
and len(m.ClientCode) >= 8
and m.IsBlocked not in ('C','o')
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = m.MainCode and CustTypeCode = 'Z' 
)



