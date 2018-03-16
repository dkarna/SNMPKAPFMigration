-- CS002 Query 

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
and AcType in ('06','3C','3D','3G','3H','3I','3J','0V','3W','4H','4L');

IF OBJECT_ID('tempdb.dbo.#tempAcCustType', 'U') IS NOT NULL
 DROP TABLE #tempAcCustType;
 SELECT DISTINCT fn.MainCode,fn.BranchCode,
 ab.CustType AS Bval,
  az.CustType AS Zval,
  ac.CustType AS Cval,
  ax.CustType AS Xval,
  ap.CustType AS Pval,
  af.CustType AS Fval,
  au.CustType AS Uval,
  aq.CustType AS Qval,
  ar.CustType AS Rval,
  ae.CustType AS eval,
  ad.CustType AS Dval
INTO #tempAcCustType
FROM AcCustType fn
LEFT JOIN AcCustType ab
  ON fn.MainCode = ab.MainCode
  AND fn.BranchCode = ab.BranchCode
  AND ab.CustTypeCode = 'B'
LEFT JOIN AcCustType az
  ON fn.MainCode = az.MainCode
  AND fn.BranchCode = az.BranchCode
  AND az.CustTypeCode = 'Z'
LEFT JOIN AcCustType ac
  ON fn.MainCode = ac.MainCode
  AND fn.BranchCode = ac.BranchCode
  AND ac.CustTypeCode = 'C'
LEFT JOIN AcCustType ax
  ON fn.MainCode = ax.MainCode
  AND fn.BranchCode = ax.BranchCode
  AND ax.CustTypeCode = 'X'
LEFT JOIN AcCustType ap
  ON fn.MainCode = ap.MainCode
  AND fn.BranchCode = ap.BranchCode
  AND ap.CustTypeCode = 'P'
  LEFT JOIN AcCustType af
  ON fn.MainCode = af.MainCode
  AND fn.BranchCode = af.BranchCode
  AND af.CustTypeCode = 'F'
  LEFT JOIN AcCustType au
  ON fn.MainCode = au.MainCode
  AND fn.BranchCode = au.BranchCode
  AND au.CustTypeCode = 'U'
  LEFT JOIN AcCustType aq
  ON fn.MainCode = aq.MainCode
  AND fn.BranchCode = aq.BranchCode
  AND aq.CustTypeCode = 'Q'
  LEFT JOIN AcCustType ar
  ON fn.MainCode = ar.MainCode
  AND fn.BranchCode = ar.BranchCode
  AND ar.CustTypeCode = 'R'
  LEFT JOIN AcCustType ae
  ON fn.MainCode = ae.MainCode
  AND fn.BranchCode = ae.BranchCode
  AND ae.CustTypeCode = 'e'
  LEFT JOIN AcCustType ad
  ON fn.MainCode = ad.MainCode
  AND fn.BranchCode = ad.BranchCode
  AND ad.CustTypeCode = 'D'
WHERE fn.CustTypeCode IN ('C','X','B','P','Z','F','U','Q','R','e','D') ORDER by 1,2

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
		,IntDrRate
		,IntPostFrqCr
		,IsDormant
		,IsBlocked
		,LastTranDate
		,LimitExpiryDate
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

IF OBJECT_ID('tempdb.dbo.#FinSchTbl', 'U') IS NOT NULL
  DROP TABLE #FinSchTbl;
  Select * INTO #FinSchTbl FROM 
  (
	select SCHM_CODE, IntTableCode from 
	FinacleCASAIntTableCode WHERE SCHM_CODE in
	(select FinacleSchCode from FinacleLoanTable where FinacleSchemeType like 'ODA')
  )AS fts;

SELECT * FROM
(
select --top 10
t1.MainCode AS foracid
,CASE WHEN t1.AcType = '0V' THEN 'W' ELSE 'N' END AS wtax_flg
,CASE WHEN t1.AcType = '0V' THEN 'P' ELSE '' END AS wtax_amount_scope_flg	
,CASE WHEN TaxPostFrq = 9 OR IntPostFrqCr = 9 OR t1.AcType IN ('01','02','03','04','28','0X') THEN RIGHT(SPACE(8)+CAST('0' AS VARCHAR(8)),8)
 ELSE	RIGHT(SPACE(8)+CAST('5' AS VARCHAR(8)),8) END AS wtax_pcnt
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17)AS wtax_floor_limit	
,'R0'+t1.ClientCode AS CIF_id
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) cust_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) cust_dr_pref_pcnt
,isnull((RIGHT(SPACE(10)+CAST(pt.IntCrRateDef-t1.IntCrRate AS VARCHAR(10)),10)),RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10)) as id_cr_pref_pcnt
,isnull((RIGHT(SPACE(10)+CAST(pt.IntDrRateDef-t1.IntDrRate AS VARCHAR(10)),10)),RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10)) as id_dr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) chnl_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) chnl_dr_pref_pcnt
,'N' Pegged_flg
,RIGHT(SPACE(4)+CAST('0' AS VARCHAR(4)),4) peg_frequency_in_months
,RIGHT(SPACE(3)+CAST('0' AS VARCHAR(3)),3) peg_frequency_in_days
,--t1.IntPostFrqCr AS int_freq_type_cr
' ' AS int_freq_type_cr
,' ' int_freq_week_num_cr
,--RIGHT(SPACE(1)+CAST('0' AS VARCHAR(1)),1) int_freq_week_day_cr
' ' AS int_freq_week_day_cr
,RIGHT(SPACE(2)+CAST('0' AS VARCHAR(2)),2) int_freq_start_dd_cr
,' ' int_freq_hldy_stat_cr
,--CONVERT(VARCHAR(10),GETDATE()+1, 105) AS  next_int_run_date_cr
' ' AS  next_int_run_date_cr
,'Q' int_freq_type_dr
,' ' int_freq_week_num_dr
,--RIGHT(SPACE(1)+CAST('0' AS VARCHAR(1)),1) int_freq_week_day_dr
'' AS int_freq_week_day_dr
,RIGHT(SPACE(2)+CAST('31' AS VARCHAR(2)),2) int_freq_start_dd_dr
,'P' int_freq_hldy_stat_dr
,convert(varchar,GETDATE()+90, 105) next_int_run_date_dr
,' ' ledg_num
,RIGHT(SPACE(10)+CAST(fet.EmpId AS VARCHAR(10)),10) AS emp_id
,CONVERT(VARCHAR,tmaster.mindate,105) as acct_opn_date
,'999' as Mode_of_oper_code
--,case when fst.PumoriAcType='01' and fst.PumoriCyCode='01' and t1.Limit < 0 then '25055'
 --when fst.PumoriAcType='01' and fst.PumoriCyCode='01' and t1.Limit >= 0 then '25005'
 --else fst.FinacleSubGL END 
 ,case when t1.AcType='0V' then '0'+flt.FinacleSubGL else '0'+flt.FinacleSubGL end AS GL_Sub_Head_code
--,--fst.FinacleSchCode as  Schm_code
,case when t1.AcType='0V' then flt.FinacleSchCode else flt.FinacleSchCode end as  Schm_code
,'Y' Chq_alwd_flg
,'S' Pb_ps_code
,CASE WHEN IsBlocked IN ('B','T','D') THEN 'T' WHEN IsBlocked ='-' THEN 'C' when IsBlocked ='+' then 'D' else ' ' end  Frez_code		
,CASE WHEN IsBlocked IN ('B' ,'T', 'D','-','+') THEN '00003' ELSE ' ' end Frez_reason_code
,t1.MainCode as free_text
,case when t1.IsDormant ='T' then 'D' else 'A' end acct_Status
,ISNULL(tACT.Fval,' ') AS free_code_1
,ISNULL(tACT.Uval,' ') AS free_code_2
,ISNULL(tACT.Qval,' ') AS free_code_3
,ISNULL(tACT.Rval,' ') AS free_code_4
,ISNULL(tACT.eval,' ') AS free_code_5
,' ' free_code_6
,ISNULL(tACT.Dval,' ') AS free_code_7
,' ' free_code_8
,' ' free_code_9
,' ' free_code_10
,fts.IntTableCode as int_tbl_code
,'' as  acct_loc_code
,CASE WHEN cur.CyDesc ='IRS' THEN 'INR' ELSE cur.CyDesc END acct_crncy_code	
,t1.BranchCode sol_id
,'UBSADMIN' acct_mgr_user_id
,t1.Name acct_name
,'Y'  swift_allowed_flg
,convert(VARCHAR,LastTranDate,105) last_tran_date
,' ' last_any_tran_date
,'N' xclude_for_comb_stmt
,' ' stmt_cust_id    
,' ' chrg_level_code 
,' ' pbf_download_flg
,'A' wtax_level_flg  
,ISNULL(tACT.Bval,' ') AS  sector_code     
,ISNULL(tACT.Zval,' ') AS  sub_sector_code 
,ISNULL(tACT.Cval,' ') AS  purpose_of_advn 
,ISNULL(tACT.Xval,' ') AS  nature_of_advn  
--'00001' AS nature_of_advn
,--ISNULL(tACT.Pval,' ') AS  industry_type   
'999' AS  industry_type
,' ' int_dr_acct_flg 
,' ' int_dr_acid     
,RIGHT(SPACE(17)+CAST(t1.Limit AS VARCHAR(17)),17)	AS sanct_lim
,RIGHT(SPACE(17)+CAST(t1.Limit AS VARCHAR(17)),17)	AS Drwng_power
,RIGHT(SPACE(17)+CAST(t1.Limit AS VARCHAR(17)),17)	AS dacc_lim_abs
,RIGHT(SPACE(8)+CAST('0'  AS VARCHAR(8)),8	)	AS dacc_lim_pcnt
,RIGHT(SPACE(17)+CAST(t1.Limit AS VARCHAR(17)),17)	AS max_alwd_advn_lim
,CASE WHEN DATEDIFF(DAY,SDL.DueDate,getDate()) <= 30 THEN '00001'
WHEN (DATEDIFF(DAY,SDL.DueDate,getDate()) > 30) and (DATEDIFF(DAY,PDL.DueDate,getDate()) <= 90) THEN '00002'
WHEN (DATEDIFF(DAY,SDL.DueDate,getDate()) > 90) and (DATEDIFF(DAY,PDL.DueDate,getDate()) <= 180) THEN '00003'
WHEN (DATEDIFF(DAY,SDL.DueDate,getDate()) > 180) and (DATEDIFF(DAY,PDL.DueDate,getDate()) <= 365) THEN '00004'
WHEN DATEDIFF(DAY,SDL.DueDate,getDate()) > 365 THEN '00005'
ELSE '00001' END AS health_code
,CASE WHEN t1.BranchCode = 'OO1' THEN 'HO' ELSE 'BR' END AS sanct_levl_code
,'TOBEUPDATEDASPERCM' sanct_ref_num
,convert(VARCHAR,tmaster.mindate,105)		AS lim_sanct_date
,convert(VARCHAR,t1.LimitExpiryDate,105)	AS lim_exp_date
,convert(VARCHAR,dateadd(dd,-30,t1.LimitExpiryDate),105) AS lim_review_date
--convert(VARCHAR,t1.AcOpenDate,105) AS lim_review_date
,--convert(VARCHAR,dateadd(dd,-30,t1.LimitExpiryDate),105)  AS loan_paper_date
convert(VARCHAR,t1.AcOpenDate,105) AS loan_paper_date
,'CEO' sanct_auth_code
,'' ecgc_appl_flg
,'' ecgc_dr_acid
,convert(VARCHAR,t1.LimitExpiryDate,105) as  due_date
,'' rpc_acct_flg
,'' disb_ind
,'' Compound_date
,'' daily_comp_int_flg
,'' COMP_Date_flg
,'N' disc_rate_flg
,'' dummy
,CASE WHEN IsDormant='T' THEN convert(VARCHAR,dateadd(MM,6,isnull(LastTranDate,AcOpenDate)),105) ELSE convert(VARCHAR,t1.AcOpenDate,105) END acct_status_date
--'01-01-2018' AS acct_status_date
,'' iban_number
,'' ias_code
,'' channel_id
,'' channel_level_code
,RIGHT(SPACE(17)+CAST(SDL.PastDueInt AS VARCHAR(17)),17) int_suspense_amt
,RIGHT(SPACE(17)+CAST((SDL.PenalInt+SDL.IntOnInt) AS VARCHAR(17)),17) Penal_int_Suspense_amt
,'N' Chrge_off_flg
,CASE WHEN SDL.MainCode IS NOT NULL or SDL.MainCode <> '' THEN 'Y' ELSE 'N' END pd_flg
,convert(varchar,SDL.DueDate, 105) AS pd_xfer_Date
,'' Chrge_off_date
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS Chrge_off_principal
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS Pending_interest
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS Principal_recovery
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS interest_recovery
,'' Charge_off_type
,'' master_acct_num
,'D' penal_prod_mthd_flg
,'D' penal_rate_mthd_flg
,' ' waive_min_coll_int
,' ' rule_code
,' ' ps_diff_freq_rel_party_flg
,' ' swift_diff_freq_rel_party_flg
,' ' add_type
,' ' Phone_type
,' ' Email_type
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS accrued_penal_int_recovery
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS penal_int_recovery
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS coll_int_recovery
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS coll_penal_int_recovery
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS pending_penal_interest
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS pending_penal_booked_interest
,RIGHT(SPACE(4)+CAST(' ' AS VARCHAR(4)),4) AS int_rate_prd_in_months
,RIGHT(SPACE(3)+CAST(' ' AS VARCHAR(3)),3) AS int_rate_prd_in_days
,' ' AS penal_int_tbl_code
,RIGHT(SPACE(9)+CAST('0' AS VARCHAR(9)),9) AS penal_pref_pcnt
,' ' interpolation_method        
,' ' hedged_acct_flg             
,' ' used_for_net_off_flg        
,' ' alt1_acct_name              
,' ' security_indicator          
,' ' debt_seniority              
,' ' security_code        
,'E' Debit_Interest_Method
,' ' Service_chrge_collection_flg
,--convert(VARCHAR,dateadd(dd, -1 , AcOpenDate),105) Last_purge_date
' ' AS Last_purge_date
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS total_project_cost
,' ' loss_carry_fwd
,' ' unadj_profit_carry_fwd
,' ' collect_excess_profit
,' ' adj_order_for_carry_fwd
,RIGHT(SPACE(9)+CAST(' ' AS VARCHAR(9)),9) AS bank_profit_share_pcnt
,RIGHT(SPACE(9)+CAST(' ' AS VARCHAR(9)),9) AS bank_loss_share_pcnt
,' ' profit_adj_freq_type
,' ' profit_adj_freq_week_num
,RIGHT(SPACE(1)+CAST(' ' AS VARCHAR(1)),1) AS profit_adj_freq_week_day
,RIGHT(SPACE(2)+CAST(' ' AS VARCHAR(2)),2) AS profit_adj_freq_start_dd
,' ' profit_adj_freq_hldy_stat
,' ' next_profit_adj_due_date
,RIGHT(SPACE(9)+CAST(' ' AS VARCHAR(9)),9) AS  tot_bank_captl_share_pcnt
,RIGHT(SPACE(4)+CAST(' ' AS VARCHAR(4)),4) profit_adj_grace_prd_mths
,RIGHT(SPACE(3)+CAST(' ' AS VARCHAR(3)),3) profit_adj_grace_prd_days
,' ' adj_cycle_end_date
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS unadj_profit_carry_fwd_amt
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS unadj_profit_settle_amt   
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS unadj_profit_charge_off_amt
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS loss_carry_fwd_amt        
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS loss_settle_amt           
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS loss_charge_off_amt       
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS profit_adj_amt            
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS loss_adj_amt              
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS tot_expected_profit_amt   
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS bank_profit_share_amt     
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS bank_loss_share_amt       
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS actual_profit_amt         
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS actual_loss_amt           
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS collected_amt           
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS excess_profit_collected_amt
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS broken_prd_prft_in_legacy 
,' ' unclaim_status       
,' ' unclaim_status_date  
,' ' orig_gl_sub_head_code
,' ' pais_applicable_flg  
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17)as pais_bank_amt   
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17)as pais_cust_amt   
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17)as pais_debited_amt
,' ' pais_effective_date                                    
,' ' pais_coverage_end_date                                 
,' ' primary_crop_code                                      
,' ' primary_crop_state_code                                
,' ' primary_no_of_crop_in_year 
FROM --#FinalMaster 
Master t1
--left join #tempwtx_flg wtemp on wtemp.MainCode =t1.MainCode
JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode
left join #tempAcCustType tACT on tACT.MainCode = t1.MainCode and tACT.BranchCode = t1.BranchCode
LEFT JOIN FinacleEmployeeTable fet on fet.ClientCode = t2.ClientCode
join FinacleSchemeTable fst on fst.PumoriAcType=t1.AcType and fst.PumoriCyCode=t1.CyCode
left join FinacleLoanTable flt on flt.PumoriMainCode=t1.MainCode and flt.PumoriAcType=t1.AcType and flt.PumoriCyCode=t1.CyCode
LEFT JOIN FinacleCASAIntTableCode FIT ON FIT.SCHM_CODE = fst.FinacleSchCode 
left join #FinSchTbl fts ON fts.SCHM_CODE = flt.FinacleSchCode
LEFT JOIN
(
	select MainCode,CustType,BranchCode from AcCustType where CustTypeCode = 'Z'
) as accust on accust.MainCode = t1.MainCode and accust.BranchCode = t1.BranchCode
LEFT JOIN
(
	SELECT ReferenceNo as MainCode, BranchCode, MIN(DueDate) as DueDate
	FROM PastDuedList
	GROUP BY ReferenceNo, BranchCode
) PDL ON PDL.MainCode = t1.MainCode  AND PDL.BranchCode=t1.BranchCode
left join ParaTable pt on pt.BranchCode=t1.BranchCode and pt.AcType = t1.AcType and pt.CyCode = t1.CyCode
left join CurrencyTable cur on cur.CyCode=t1.CyCode
JOIN 
(							-- Filters the clientcode with minimum account open date
	SELECT t.ClientCode,MIN(t.AcOpenDate) AS mindate FROM Master t GROUP BY t.ClientCode
) AS tmaster ON tmaster.ClientCode = t1.ClientCode AND tmaster.mindate = t1.AcOpenDate
LEFT JOIN SanimaDueList SDL ON SDL.MainCode = t1.MainCode AND SDL.BranchCode = t1.BranchCode
,ControlTable ctrlt
WHERE LEFT(t2.ClientCode,1) <> '_'
and len(t1.ClientCode) >= 8
--and t1.AcType in ('06','3C','3D','3G','3H','3I','3J','0V','3W','4H','4L')
AND t1.Limit > 0
and t1.IsBlocked not in ('C','o') 
and t1.ClientCode not in ('00283013','00330078','00315338','00312554')
--and t2.ClientStatus <> 'Z'
--and fst.FinacleSchCode not in ('SBAUD','SBCAD','SBEUR','SBGBP','SBUSD','CLFCY','TCARD')
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = t1.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
) 
--ORDER BY 1

UNION
 
SELECT DISTINCT --top 10
t1.MainCode AS foracid
,CASE WHEN t1.AcType = '0V' THEN 'W' ELSE 'N' END AS wtax_flg
,CASE WHEN t1.AcType = '0V' THEN 'P' ELSE ' ' END AS wtax_amount_scope_flg	
,CASE WHEN TaxPostFrq = 9 OR IntPostFrqCr = 9 OR t1.AcType IN ('01','02','03','04','28','0X') THEN RIGHT(SPACE(8)+CAST('0' AS VARCHAR(8)),8)
 ELSE	RIGHT(SPACE(8)+CAST('5' AS VARCHAR(8)),8) END AS wtax_pcnt
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17)AS wtax_floor_limit	
,'C'+t1.ClientCode AS CIF_id 
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) cust_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) cust_dr_pref_pcnt
,isnull((RIGHT(SPACE(10)+CAST(pt.IntCrRateDef-t1.IntCrRate AS VARCHAR(10)),10)),RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10)) as id_cr_pref_pcnt
,isnull((RIGHT(SPACE(10)+CAST(pt.IntDrRateDef-t1.IntDrRate AS VARCHAR(10)),10)),RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10)) as id_dr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) chnl_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) chnl_dr_pref_pcnt
,'N' Pegged_flg
,RIGHT(SPACE(4)+CAST('0' AS VARCHAR(4)),4) peg_frequency_in_months
,RIGHT(SPACE(3)+CAST('0' AS VARCHAR(3)),3) peg_frequency_in_days
,--t1.IntPostFrqCr AS int_freq_type_cr
' ' AS int_freq_type_cr
,' ' int_freq_week_num_cr
,--RIGHT(SPACE(1)+CAST('0' AS VARCHAR(1)),1) int_freq_week_day_cr
' ' AS int_freq_week_day_cr
,RIGHT(SPACE(2)+CAST('0' AS VARCHAR(2)),2) int_freq_start_dd_cr
,' ' int_freq_hldy_stat_cr
, --CONVERT(VARCHAR(10),ctrlt.Today, 105) AS  next_int_run_date_cr
'' as next_int_run_date_cr
,'Q' int_freq_type_dr
,' ' int_freq_week_num_dr
,--RIGHT(SPACE(1)+CAST('0' AS VARCHAR(1)),1) int_freq_week_day_dr
'' AS int_freq_week_day_dr
,RIGHT(SPACE(2)+CAST('31' AS VARCHAR(2)),2) int_freq_start_dd_dr
,'P' int_freq_hldy_stat_dr
,convert(varchar,GETDATE()+90, 105) next_int_run_date_dr
,' ' ledg_num
,RIGHT(SPACE(10)+CAST(fet.EmpId AS VARCHAR(10)),10) AS emp_id
,CONVERT(VARCHAR,tmaster.mindate,105) acct_opn_date
,'999' Mode_of_oper_code
--,case when fst.PumoriAcType='01' and fst.PumoriCyCode='01' and t1.Limit < 0 then '25055'
 --when fst.PumoriAcType='01' and fst.PumoriCyCode='01' and t1.Limit >= 0 then '25005'
 --else fst.FinacleSubGL END 
 ,case when t1.AcType='0V' then '0'+flt.FinacleSubGL else '0'+flt.FinacleSubGL end AS GL_Sub_Head_code
--,--fst.FinacleSchCode as  Schm_code
,case when t1.AcType='0V' then flt.FinacleSchCode else flt.FinacleSchCode end as  Schm_code
,'Y' Chq_alwd_flg
,'S' Pb_ps_code
,CASE WHEN IsBlocked IN ('B','T','D') THEN 'T' WHEN IsBlocked ='-' THEN 'C' when IsBlocked ='+' then 'D' else ' ' end  Frez_code		
,CASE WHEN IsBlocked IN ('B' ,'T', 'D','-','+') THEN '00003' ELSE ' ' end Frez_reason_code
,t1.MainCode as free_text
,case when t1.IsDormant ='T' then 'D' else 'A' end acct_Status
,' ' free_code_1
,' ' free_code_2
,' ' free_code_3
,' ' free_code_4
,' ' free_code_5
,' ' free_code_6
,' ' free_code_7
,' ' free_code_8
,' ' free_code_9
,' ' free_code_10
,--FIT.IntTableCode as int_tbl_code
fts.IntTableCode as int_tbl_code
,'' as  acct_loc_code
,CASE WHEN cur.CyDesc='IRS' THEN 'INR' ELSE cur.CyDesc END acct_crncy_code	
,t1.BranchCode sol_id
,'UBSADMIN' acct_mgr_user_id
,t1.Name acct_name
,'Y'  swift_allowed_flg
,convert(VARCHAR,LastTranDate,105) last_tran_date
,' ' last_any_tran_date
,'N' xclude_for_comb_stmt
,' ' stmt_cust_id    
,' ' chrg_level_code 
,' ' pbf_download_flg
,'A' wtax_level_flg  
,ISNULL(tACT.Bval,' ') AS  sector_code     
,ISNULL(tACT.Zval,' ') AS  sub_sector_code 
,ISNULL(tACT.Cval,' ') AS  purpose_of_advn 
,ISNULL(tACT.Xval,' ') AS  nature_of_advn  
--'00001' AS nature_of_advn
,--ISNULL(tACT.Pval,' ') AS  industry_type   
'999' AS  industry_type 
,' ' int_dr_acct_flg 
,' ' int_dr_acid     
,RIGHT(SPACE(17)+CAST(t1.Limit AS VARCHAR(17)),17)	AS sanct_lim
,RIGHT(SPACE(17)+CAST(t1.Limit AS VARCHAR(17)),17)	AS Drwng_power
,RIGHT(SPACE(17)+CAST(t1.Limit AS VARCHAR(17)),17)	AS dacc_lim_abs
,RIGHT(SPACE(8)+CAST('0'  AS VARCHAR(8)),8	)	AS dacc_lim_pcnt
,RIGHT(SPACE(17)+CAST(t1.Limit AS VARCHAR(17)),17)	AS max_alwd_advn_lim
,CASE WHEN DATEDIFF(DAY,SDL.DueDate,getDate()) <= 30 THEN '00001'
WHEN (DATEDIFF(DAY,SDL.DueDate,getDate()) > 30) and (DATEDIFF(DAY,PDL.DueDate,getDate()) <= 90) THEN '00002'
WHEN (DATEDIFF(DAY,SDL.DueDate,getDate()) > 90) and (DATEDIFF(DAY,PDL.DueDate,getDate()) <= 180) THEN '00003'
WHEN (DATEDIFF(DAY,SDL.DueDate,getDate()) > 180) and (DATEDIFF(DAY,PDL.DueDate,getDate()) <= 365) THEN '00004'
WHEN DATEDIFF(DAY,SDL.DueDate,getDate()) > 365 THEN '00005' ELSE '00001'
END AS health_code
,CASE WHEN t1.BranchCode = 'OO1' THEN 'HO' ELSE 'BR' END AS sanct_levl_code
,'TOBEUPDATEDASPERCM' sanct_ref_num
,convert(VARCHAR,tmaster.mindate,105)		AS lim_sanct_date
,convert(VARCHAR,t1.LimitExpiryDate,105)	AS lim_exp_date
,convert(VARCHAR,dateadd(dd,-30,t1.LimitExpiryDate),105) AS lim_review_date
--convert(VARCHAR,AcOpenDate,105) AS lim_review_date
,--convert(VARCHAR,dateadd(dd,-30,t1.AcOpenDate),105)  AS loan_paper_date
convert(VARCHAR,AcOpenDate,105) AS loan_paper_date
,'CEO' sanct_auth_code
,' ' ecgc_appl_flg
,' ' ecgc_dr_acid
,convert(VARCHAR,t1.LimitExpiryDate,105) as  due_date
,' ' rpc_acct_flg
,' ' disb_ind
,' ' Compound_date
,' ' daily_comp_int_flg
,' ' COMP_Date_flg
,'N' disc_rate_flg
,' ' dummy
, CASE WHEN IsDormant='T' THEN convert(VARCHAR,dateadd(MM,6,isnull(LastTranDate,AcOpenDate)),105) ELSE convert(VARCHAR,t1.AcOpenDate,105) END acct_status_date
,' ' iban_number
,' ' ias_code
,' ' channel_id
,' ' channel_level_code
,RIGHT(SPACE(17)+CAST(SDL.PastDueInt AS VARCHAR(17)),17) int_suspense_amt
,RIGHT(SPACE(17)+CAST((SDL.PenalInt+SDL.IntOnInt) AS VARCHAR(17)),17) Penal_int_Suspense_amt
,'N' Chrge_off_flg
,CASE WHEN SDL.MainCode IS NOT NULL or SDL.MainCode <> '' THEN 'Y' ELSE 'N' END pd_flg
,convert(varchar,SDL.DueDate, 105) AS pd_xfer_Date
,' ' Chrge_off_date
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS Chrge_off_principal
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS Pending_interest
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS Principal_recovery
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS interest_recovery
,' ' Charge_off_type
,' ' master_acct_num
,'D' penal_prod_mthd_flg
,'D' penal_rate_mthd_flg
,' ' waive_min_coll_int
,' ' rule_code
,' ' ps_diff_freq_rel_party_flg
,' ' swift_diff_freq_rel_party_flg
,' ' add_type
,' ' Phone_type
,' ' Email_type
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS accrued_penal_int_recovery
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS penal_int_recovery
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS coll_int_recovery
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS coll_penal_int_recovery
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS pending_penal_interest
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS pending_penal_booked_interest
,RIGHT(SPACE(4)+CAST(' ' AS VARCHAR(4)),4) AS int_rate_prd_in_months
,RIGHT(SPACE(3)+CAST(' ' AS VARCHAR(3)),3) AS int_rate_prd_in_days
,' ' penal_int_tbl_code
,RIGHT(SPACE(9)+CAST('0' AS VARCHAR(9)),9) AS penal_pref_pcnt
,' ' interpolation_method        
,' ' hedged_acct_flg             
,' ' used_for_net_off_flg        
,' ' alt1_acct_name              
,' ' security_indicator          
,' ' debt_seniority              
,' ' security_code        
,'E' Debit_Interest_Method
,' ' Service_chrge_collection_flg
,--convert(VARCHAR,dateadd(dd, -1 , AcOpenDate),105) Last_purge_date
' ' AS Last_purge_date
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS total_project_cost
,' ' loss_carry_fwd
,' ' unadj_profit_carry_fwd
,' ' collect_excess_profit
,' ' adj_order_for_carry_fwd
,RIGHT(SPACE(9)+CAST(' ' AS VARCHAR(9)),9) AS bank_profit_share_pcnt
,RIGHT(SPACE(9)+CAST(' ' AS VARCHAR(9)),9) AS bank_loss_share_pcnt
,' ' profit_adj_freq_type
,' ' profit_adj_freq_week_num
,RIGHT(SPACE(1)+CAST(' ' AS VARCHAR(1)),1) AS profit_adj_freq_week_day
,RIGHT(SPACE(2)+CAST(' ' AS VARCHAR(2)),2) AS profit_adj_freq_start_dd
,' ' profit_adj_freq_hldy_stat
,' ' next_profit_adj_due_date
,RIGHT(SPACE(9)+CAST(' ' AS VARCHAR(9)),9) AS  tot_bank_captl_share_pcnt
,RIGHT(SPACE(4)+CAST(' ' AS VARCHAR(4)),4) profit_adj_grace_prd_mths
,RIGHT(SPACE(3)+CAST(' ' AS VARCHAR(3)),3) profit_adj_grace_prd_days
,' ' adj_cycle_end_date
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS unadj_profit_carry_fwd_amt
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS unadj_profit_settle_amt   
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS unadj_profit_charge_off_amt
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS loss_carry_fwd_amt        
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS loss_settle_amt           
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS loss_charge_off_amt       
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS profit_adj_amt            
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS loss_adj_amt              
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS tot_expected_profit_amt   
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS bank_profit_share_amt     
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS bank_loss_share_amt       
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS actual_profit_amt         
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS actual_loss_amt           
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS collected_amt             
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS excess_profit_collected_amt
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17) AS broken_prd_prft_in_legacy 
,' ' unclaim_status       
,' ' unclaim_status_date  
,' ' orig_gl_sub_head_code
,' ' pais_applicable_flg  
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17)as pais_bank_amt   
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17)as pais_cust_amt   
,RIGHT(SPACE(17)+CAST(' ' AS VARCHAR(17)),17)as pais_debited_amt
,' ' pais_effective_date                                    
,' ' pais_coverage_end_date                                 
,' ' primary_crop_code                                      
,' ' primary_crop_state_code                                
,' ' primary_no_of_crop_in_year 
FROM Master t1
left JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode
left join #tempAcCustType tACT on tACT.MainCode = t1.MainCode and tACT.BranchCode = t1.BranchCode
LEFT JOIN FinacleEmployeeTable fet on fet.ClientCode = t2.ClientCode
left join FinacleSchemeTable fst on fst.PumoriAcType=t1.AcType and fst.PumoriCyCode=t1.CyCode
left join FinacleLoanTable flt on flt.PumoriMainCode=t1.MainCode and flt.PumoriAcType=t1.AcType and flt.PumoriCyCode=t1.CyCode
LEFT JOIN FinacleCASAIntTableCode FIT ON FIT.SCHM_CODE = fst.FinacleSchCode 
left join #FinSchTbl fts ON fts.SCHM_CODE = flt.FinacleSchCode
LEFT JOIN
(
	select MainCode,CustType,BranchCode from AcCustType where CustTypeCode = 'Z'
) as accust on accust.MainCode = t1.MainCode and accust.BranchCode = t1.BranchCode
LEFT JOIN
(
	SELECT ReferenceNo as MainCode, BranchCode, MIN(DueDate) as DueDate
	FROM PastDuedList
	GROUP BY ReferenceNo, BranchCode
) PDL ON PDL.MainCode = t1.MainCode  AND PDL.BranchCode=t1.BranchCode
left join ParaTable pt on pt.BranchCode=t1.BranchCode and pt.AcType = t1.AcType and pt.CyCode = t1.CyCode
left join CurrencyTable cur on cur.CyCode=t1.CyCode
JOIN 
(							-- Filters the clientcode with minimum account open date
	SELECT t.ClientCode,MIN(t.AcOpenDate) AS mindate FROM Master t GROUP BY t.ClientCode
) AS tmaster ON tmaster.ClientCode = t1.ClientCode AND tmaster.mindate = t1.AcOpenDate
LEFT JOIN SanimaDueList SDL ON SDL.MainCode = t1.MainCode AND SDL.BranchCode = t1.BranchCode
,ControlTable ctrlt
WHERE LEFT(t2.ClientCode,1) <> '_'
and len(t1.ClientCode) >= 8
and t1.AcType in ('06','3C','3D','3G','3H','3I','3J','0V','3W','4H','4L')
AND t1.Limit > 0
and t1.IsBlocked not in ('C','o') 
and t1.ClientCode not in ('00283013','00330078','00315338','00312554')
--and t2.ClientStatus <> 'Z'
--and fst.FinacleSchCode not in ('SBAUD','SBCAD','SBEUR','SBGBP','SBUSD','CLFCY','TCARD')
and EXISTS 
(
	SELECT 1 FROM AcCustType WHERE MainCode = t1.MainCode and CustTypeCode = 'Z' and CustType NOT IN ('11','12')
)
) as t where t.GL_Sub_Head_code is not null order by 1