IF OBJECT_ID('tempdb.dbo.#tempAcCustType', 'U') IS NOT NULL
 DROP TABLE #tempAcCustType;

SELECT DISTINCT fn.MainCode,fn.BranchCode,
 a.CustType AS Bval,
  pc.CustType AS Zval,
  ln.CustType AS Cval,
  an.CustType AS Xval,
  ad.CustType AS Pval
INTO #tempAcCustType
FROM AcCustType fn
LEFT JOIN AcCustType a
  ON fn.MainCode = a.MainCode
  AND fn.BranchCode = a.BranchCode
  AND a.CustTypeCode = 'B'
LEFT JOIN AcCustType pc
  ON fn.MainCode = pc.MainCode
  AND fn.BranchCode = pc.BranchCode
  AND pc.CustTypeCode = 'Z'
LEFT JOIN AcCustType ln
  ON fn.MainCode = ln.MainCode
  AND fn.BranchCode = ln.BranchCode
  AND ln.CustTypeCode = 'C'
LEFT JOIN AcCustType an
  ON fn.MainCode = an.MainCode
  AND fn.BranchCode = an.BranchCode
  AND an.CustTypeCode = 'X'
LEFT JOIN AcCustType ad
  ON fn.MainCode = ad.MainCode
  AND fn.BranchCode = ad.BranchCode
  AND ad.CustTypeCode = 'P'
WHERE fn.CustTypeCode IN ('C','X','B','P','Z') ORDER by 1,2


SELECT DISTINCT 
 '' AS foracid
,CASE WHEN M.AcType = '0V' THEN 'W' ELSE 'N' END AS wtax_flg
,CASE WHEN M.AcType = '0V' THEN 'P' ELSE ' ' END AS wtax_amount_scope_flg	
,CASE WHEN TaxPostFrq = 9 OR IntPostFrqCr = 9 OR M.AcType IN ('01','02','03','04','28','0X') THEN RIGHT(SPACE(8)+CAST('0' AS VARCHAR(8)),8)
 ELSE	RIGHT(SPACE(8)+CAST('5' AS VARCHAR(8)),8) END AS wtax_pcnt	
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS wtax_floor_limit
,CASE WHEN ACT.CustType in ('11','12')		THEN 'R0'+ M.ClientCode
      ELSE 'C'+ M.ClientCode 
 END CIF_id 
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) cust_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) cust_dr_pref_pcnt
,isnull((RIGHT(SPACE(10)+CAST(P.IntCrRateDef-M.IntCrRate AS VARCHAR(10)),10)),RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10)) as id_cr_pref_pcnt
,isnull((RIGHT(SPACE(10)+CAST(P.IntDrRateDef-M.IntDrRate AS VARCHAR(10)),10)),RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10)) as id_dr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) chnl_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) chnl_dr_pref_pcnt
,'N' Pegged_flg
,RIGHT(SPACE(4)+CAST('0' AS VARCHAR(4)),4) peg_frequency_in_months
,RIGHT(SPACE(3)+CAST('0' AS VARCHAR(3)),3) peg_frequency_in_days
,M.IntPostFrqCr AS int_freq_type_cr
,' ' int_freq_week_num_cr
,RIGHT(SPACE(1)+CAST('0' AS VARCHAR(1)),1) int_freq_week_day_cr
,RIGHT(SPACE(2)+CAST('0' AS VARCHAR(2)),2) int_freq_start_dd_cr
,' ' int_freq_hldy_stat_cr
, CONVERT(VARCHAR(10),CT.Today, 105) AS  next_int_run_date_cr
,'D' int_freq_type_dr
,' ' int_freq_week_num_dr
,RIGHT(SPACE(1)+CAST('0' AS VARCHAR(1)),1) int_freq_week_day_dr
,RIGHT(SPACE(2)+CAST('0' AS VARCHAR(2)),2) int_freq_start_dd_dr
,' ' int_freq_hldy_stat_dr
,' ' next_int_run_date_dr
,' ' ledg_num
,FET.EmpId AS emp_id
,CONVERT(VARCHAR,tmaster.mindate,105) acct_opn_date
,'999' Mode_of_oper_code
,case when fst.PumoriAcType='01' and fst.PumoriCyCode='01' and M.Limit < 0 then '25055'
 when fst.PumoriAcType='01' and fst.PumoriCyCode='01' and M.Limit >= 0 then '25005'
 else fst.FinacleSubGL END as GL_Sub_Head_code
,fst.FinacleSchCode as  Schm_code
,'Y' Chq_alwd_flg
,'S' Pb_ps_code
,CASE WHEN IsBlocked IN ('B','T','D') THEN 'T' WHEN IsBlocked ='-' THEN 'C' when IsBlocked ='+' then 'D' else ' ' end  Frez_code		
,CASE WHEN IsBlocked IN ('B' ,'T', 'D','-','+') THEN 'OTHER' ELSE ' ' end Frez_reason_code
,M.MainCode as free_text
,case when M.IsDormant ='T' then 'D' else 'A' end acct_Status
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
,FIT.IntTableCode as int_tbl_code
,LEFT(ct.Address1,5) as  acct_loc_cod
,C.CyDesc acct_crncy_code	
,M.BranchCode sol_id
,'UBSADMIN' acct_mgr_user_id
,M.Name acct_name
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
,ISNULL(tACT.Pval,' ') AS  industry_type   
,' ' int_dr_acct_flg 
,' ' int_dr_acid     
,RIGHT(SPACE(17)+CAST(M.Limit AS VARCHAR(17)),17)	AS sanct_lim
,RIGHT(SPACE(17)+CAST(M.Limit AS VARCHAR(17)),17)	AS Drwng_power
,RIGHT(SPACE(17)+CAST(M.Limit AS VARCHAR(17)),17)	AS dacc_lim_abs
,RIGHT(SPACE(8)+CAST('0'  AS VARCHAR(8)),8	)	AS dacc_lim_pcnt
,RIGHT(SPACE(17)+CAST(M.Limit AS VARCHAR(17)),17)	AS max_alwd_advn_lim
,PDL.DueDate AS health_code
,CASE WHEN M.BranchCode = 'OO1' THEN 'HO' ELSE 'BR' END AS sanct_levl_code
,'TOBEUPDATEDASPERCM' sanct_ref_num
,convert(VARCHAR,tmaster.mindate,105)		AS lim_sanct_date
,convert(VARCHAR,LimitExpiryDate,105)	AS lim_exp_date
,convert(VARCHAR,dateadd(dd,-30,LimitExpiryDate),105) AS lim_review_date
,convert(VARCHAR,dateadd(dd,-30,LimitExpiryDate),105) AS loan_paper_date
,'CEO' sanct_auth_code
,' ' ecgc_appl_flg
,' ' ecgc_dr_acid
,convert(VARCHAR,LimitExpiryDate,105) as  due_date
,' ' rpc_acct_flg
,' ' disb_ind
,' ' Compound_date
,' ' daily_comp_int_flg
,' ' COMP_Date_flg
,'Y' disc_rate_flg
,' ' dummy
, CASE WHEN IsDormant='T' THEN convert(VARCHAR,dateadd(MM,6,isnull(LastTranDate,AcOpenDate)),105) ELSE ' ' END acct_status_date
,' ' iban_number
,' ' ias_code
,' ' channel_id
,' ' channel_level_code
,RIGHT(SPACE(17)+CAST(SDL.PastDueInt AS VARCHAR(17)),17) int_suspense_amt
,RIGHT(SPACE(17)+CAST((SDL.PenalInt+SDL.IntOnInt) AS VARCHAR(17)),17) Penal_int_Suspense_amt
,'Y' Chrge_off_flg
,'Y' pd_flg
,SDL.DueDate pd_xfer_Date
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
,RIGHT(SPACE(3)+CAST('0' AS VARCHAR(3)),3) int_rate_prd_in_months
,RIGHT(SPACE(3)+CAST('0' AS VARCHAR(3)),3) int_rate_prd_in_days
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
,convert(VARCHAR,dateadd(dd, -1 , AcOpenDate),105) Last_purge_date
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS total_project_cost
,' ' loss_carry_fwd
,' ' unadj_profit_carry_fwd
,' ' collect_excess_profit
,' ' adj_order_for_carry_fwd
,RIGHT(SPACE(9)+CAST('0' AS VARCHAR(9)),9) AS bank_profit_share_pcnt
,RIGHT(SPACE(9)+CAST('0' AS VARCHAR(9)),9) AS bank_loss_share_pcnt
,' ' profit_adj_freq_type
,' ' profit_adj_freq_week_num
,RIGHT(SPACE(1)+CAST('0' AS VARCHAR(1)),1) AS profit_adj_freq_week_day
,RIGHT(SPACE(2)+CAST('0' AS VARCHAR(2)),2) AS profit_adj_freq_start_dd
,' ' profit_adj_freq_hldy_stat
,' ' next_profit_adj_due_date
,RIGHT(SPACE(9)+CAST('0' AS VARCHAR(9)),9) AS  tot_bank_captl_share_pcnt
,RIGHT(SPACE(4)+CAST('0' AS VARCHAR(4)),4) profit_adj_grace_prd_mths
,RIGHT(SPACE(3)+CAST('0' AS VARCHAR(3)),3) profit_adj_grace_prd_days
,' ' adj_cycle_end_date
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS unadj_profit_carry_fwd_amt
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS unadj_profit_settle_amt   
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS unadj_profit_charge_off_am
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS loss_carry_fwd_amt        
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS loss_settle_amt           
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS loss_charge_off_amt       
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS profit_adj_amt            
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS loss_adj_amt              
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS tot_expected_profit_amt   
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS bank_profit_share_amt     
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS bank_loss_share_amt       
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS actual_profit_amt         
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS actual_loss_amt           
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS collected_amt             
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS excess_profit_collected_am
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS broken_prd_prft_in_legacy 
,' ' unclaim_status       
,' ' unclaim_status_date  
,' ' orig_gl_sub_head_code
,' ' pais_applicable_flg  
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17)as pais_bank_amt   
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17)as pais_cust_amt   
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17)as pais_debited_amt
,' ' pais_effective_date                                    
,' ' pais_coverage_end_date                                 
,' ' primary_crop_code                                      
,' ' primary_crop_state_code                                
,' ' primary_no_of_crop_in_year 
FROM Master M 
left join ClientTable ct on ct.ClientCode = M.ClientCode
left join #tempAcCustType tACT on tACT.MainCode = M.MainCode and tACT.BranchCode = M.BranchCode
LEFT JOIN ParaTable P ON P.BranchCode = M.BranchCode AND P.AcType = M.AcType AND P.CyCode = M.CyCode
LEFT JOIN CurrencyTable C on M.CyCode = C.CyCode
LEFT JOIN AcCustType ACT ON M.MainCode = ACT.MainCode
LEFT JOIN FinacleEmployeeTable FET ON FET.ClientCode =  M.ClientCode AND FET.MainCode = M.MainCode
JOIN 
(	-- Filters the clientcode with minimum account open date
	SELECT t.ClientCode,MIN(t.AcOpenDate) AS mindate FROM Master t GROUP BY t.ClientCode
) AS tmaster ON tmaster.ClientCode = M.ClientCode AND tmaster.mindate = M.AcOpenDate
LEFT JOIN
(
	SELECT ReferenceNo as MainCode, BranchCode, MIN(DueDate) as DueDate
	FROM PastDuedList
	GROUP BY ReferenceNo, BranchCode
) PDL ON M.MainCode = PDL.MainCode  AND M.BranchCode = PDL.BranchCode
left join FinacleSchemeTable fst on fst.PumoriAcType=M.AcType and fst.PumoriCyCode=M.CyCode 
LEFT JOIN FinacleCASAIntTableCode FIT ON FIT.SCHM_CODE = fst.FinacleSchCode
LEFT JOIN SanimaDueList SDL ON SDL.MainCode = M.MainCode AND SDL.BranchCode = M.BranchCode , ControlTable CT
WHERE LEFT(M.ClientCode,1) <>'_' 
AND ACT.CustTypeCode = 'Z'
AND M.AcType IN ('06','3C','3D','3G','3H','3I','3J','0V','3W','4H','4L')
AND M.Limit > 0
and len(M.ClientCode) >= 8
and M.IsBlocked not in ('C','o')