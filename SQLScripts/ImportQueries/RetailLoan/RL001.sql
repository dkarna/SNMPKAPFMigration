-- Query for RL001
DECLARE @CToday DATE;
SELECT  @CToday = Today FROM ControlTable;
SELECT
'' AS foracid  -- will be obtained from NNTM setup
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS cust_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS cust_dr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS id_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS id_dr_pref_pcnt
,'V' AS repricing_plan   -- as per developer's understanding
,RIGHT(SPACE(4)+CAST('0' AS VARCHAR(4)),4) AS peg_frequency_in_months
,RIGHT(SPACE(3)+CAST('0' AS VARCHAR(3)),3) AS peg_frequency_in_days
,'O' AS int_route_flg   -- as per developer's understanding
,curt.CyDesc AS acct_crncy_code
,m.BranchCode AS sol_id
,'GLSHC' AS gl_sub_head_code  -- will be replaced by subhead code given
,m.AcType AS schm_code   -- need to be confirmed
,m.ClientCode AS cif_id
,CONVERT(VARCHAR(10),tmaster.mindate,105) AS acct_opn_date
,RIGHT(SPACE(17)+CAST(m.Limit AS VARCHAR(17)),17) AS sanct_lim
,'' AS ledg_num
,'DSECT' AS sector_code   -- need to be confirmed. default value as per developer's understanding. may be obtained after RRCDM
,'DSECT' AS sub_sector_code -- need to be confirmed. default value as per developer's understanding. may be obtained after RRCDM
,'DSECT' AS purpose_of_advn -- need to be confirmed. default value as per developer's understanding. may be obtained after RRCDM
,'DSECT' AS nature_of_advn -- need to be confirmed. default value as per developer's understanding. may be obtained after RRCDM
,'DSECT' AS free_code_3 -- need to be confirmed. default value as per developer's understanding. may be obtained after RRCDM
,'' AS sanct_ref_num
,CONVERT(VARCHAR(10),tmaster.mindate,105) AS lim_sanct_date
,CASE WHEN m.BranchCode = '001' THEN 'HO'
 ELSE 'BR'
 END AS sanct_levl_code
,CASE WHEN m.LimitExpiryDate IS NOT NULL         -- else value given on the developer's understanding
 THEN CONVERT(VARCHAR(10),m.LimitExpiryDate,105) 
 ELSE '01-01-9999'
 END AS lim_exp_date
,'RRCDM' AS sanct_auth_code  -- CEO value need to be confirmed. Will obtain value after RRCDM
,CONVERT(VARCHAR(10),tmaster.mindate,105) AS loan_paper_date
,lm.Nominee AS op_acid
,curt.CyDesc AS op_crncy_code
,m.BranchCode AS op_sol_id
,'E' AS dmd_satisfy_mthd
,'Y' AS lien_on_oper_acct_flg
,'' AS ds_rate_code
,'TBD' AS int_tbl_code    -- need to be confirmed
,'Y' AS int_on_p_flg
,'Y' AS pi_on_pdmd_ovdu_flg
,'N' AS pdmd_ovdu_eom_flg
,'Y' AS int_on_idmd_flg
,'Y' AS pi_on_idmd_ovdu_flg
,'N' AS idmd_ovdu_eom_flg
,CONVERT(VARCHAR(10),@CToday,105) AS xfer_eff_date
,'' AS cum_norm_int_amt
,'' AS cum_pen_int_amt
,'' AS cum_addnl_int_amt
,RIGHT(SPACE(17)+CAST(m.Balance AS VARCHAR(17)),17) AS liab_as_on_xfer_eff_date
,RIGHT(SPACE(17)+CAST(lm.TotDisburse AS VARCHAR(17)),17) AS rephasement_principal
,CONVERT(VARCHAR(10),DATEADD(D,-1,@CToday),105) AS interest_calc_upto_date_dr
,CONVERT(VARCHAR(10),lm.RepayStartDate,105) AS rep_shdl_date
,RIGHT(SPACE(3)+CAST(lm.NoOfPeriods AS VARCHAR(3)),3) AS rep_perd_mths
,'' AS rep_perd_days
,CASE WHEN npdl.ReferenceNo IS NULL THEN 'F'
 ELSE 'T'
 END AS pd_flg
,CASE WHEN npdl.ReferenceNo IS NULL THEN ''
 ELSE CONVERT(VARCHAR(10),npdl.pduedate,105)
 END AS pd_xfer_date
,'BPD' AS prv_to_pd_gl_sub_head_code     -- Need to confirm. will obtain code from BPD
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS int_suspense_amt   -- sepearate table will be provided
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS penal_int_suspense_amt  -- need to confirm
,'N' AS chrge_off_flg
,NULL AS chrge_off_date   -- Need to be confirmed
,'0' AS chrge_off_principal  -- Need to confirm
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS pending_interest
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS principal_recovery
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS interest_recovery
,'' AS source_deal_code
,'' AS disburse_deal_code
,'N' AS apply_late_fee_flg
,'' AS late_fee_grace_perd_mnths
,'' AS late_fee_grace_perd_days
,'' AS upfront_instl_coll
,'' AS num_advance_instlmnt
,'' AS upfront_instl_amt
,'' AS dpd_cntr
,RIGHT(SPACE(17)+CAST(mlrs.DuePrincipal AS VARCHAR(17)),17) AS sum_principal_dmd_amt
,'N' AS payoff_flg
,'N' AS xclude_for_comb_stmt
,'' AS stmt_cif_id
,'0' AS xfer_cycle_str
,'' AS bank_irr_rate
,'' AS value_of_asset
,'MIGR' AS acct_occp_code
,'' AS borrower_category_code  -- Need to be confirmed as mapping is seen in the sheet
,'' AS mode_of_advn
,'' AS type_of_advn
,'' AS guar_cover_code
,'' AS industry_type
,'Q' AS free_code_1
,'D' AS free_code_2
,'d' AS free_code_4
,'M' AS free_code_5
,'G' AS free_code_6
,'U' AS free_code_7
,'e' AS free_code_8
,'' AS free_code_9
,'' AS free_code_10
,'' AS acct_locn_code
,'' AS crfile_ref_id
,'' AS dicgc_fee_pcnt
,'' AS last_compound_date
,'' AS daily_comp_int_flg
,'Y' AS calc_ovdu_int_flg   -- Need to confirm
,CASE WHEN lm.HasRepaySched = 'T' THEN 
	CONVERT(VARCHAR(10),mlrs.mduedate,105)
 ELSE 
	CONVERT(VARCHAR(10),tmaster.mindate,105) 
 END AS ei_perd_start_date
,CASE WHEN lm.HasRepaySched = 'T' THEN 
	CONVERT(VARCHAR(10),mlrs.maxduedate,105)
 ELSE 
	CONVERT(VARCHAR(10),m.LimitExpiryDate,105) 
 END AS ei_perd_end_date
,'' AS irr_rate
,'' AS adv_int_amount
,'' AS amortized_amount
,'' AS booked_upto_date_dr
,'' AS adv_int_coll_upto_date
,'' AS accrual_rate
,'' AS int_rate_based_on_sanct_lim
,'D' AS int_rest_freq
,'' AS int_rest_basis
,'O' AS chrg_route_flg
,'' AS final_disb_flg
,'N' AS auto_reshdl_after_hldy_perd
,'' AS tot_num_defmnts
,'' AS num_defmnt_curr_shdl
,'' AS peg_review_date
,'O' AS pi_based_on_outstanding
,'' AS charge_off_type
,'' AS def_appl_int_rate_flg
,'' AS def_appl_int_rate
,'' AS deferred_int_amt
,'Y' AS auto_reshdl_not_allowed
,'' AS reshdl_overdue_prin
,'' AS reshdl_overdue_int
,'N' AS loan_type
,'' AS payoff_reason_code
,dep.MainCode AS rel_deposit_acid
,'' AS last_aod_aos_date
,'' AS refin_sanct_date
,'' AS refin_amt
,'' AS sbsdy_acid
,'' AS sbsdy_agency
,'' AS prin_sbsdy_claimed_date
,'' AS subs_act_code
,'' AS aod_aos_type
,'' AS refin_sanct_num
,'' AS refin_ref_num
,'' AS refin_avld_date
,'' AS prin_sbsdy_amt
,'' AS prin_sbsdy_rcvd_date
,'' AS pre_process_fee
,'' AS act_code
,'' AS probation_prd_mths
,'' AS probation_prd_days
,'' AS comp_date_flg
,'' AS disc_rate_flg
,'Y' AS int_coll_flg
,'N' AS ps_despatch_mode
,'' AS acct_mgr_user_id
,'SNGLE' AS mode_of_oper_code
,'' AS ps_freq_type
,'' AS ps_freq_week_num
,'' AS ps_freq_week_day
,'' AS ps_freq_start_dd
,'' AS ps_freq_hldy_stat
,'N' AS pb_ps_code
,'' AS ps_next_due_date
,'' AS fixedterm_mnths
,'' AS fixedterm_years
,'' AS min_int_pcnt_dr
,'' AS max_int_pcnt_dr
,'' AS install_income_ratio
,'' AS product_group
,lm.Remarks AS free_text
,'' AS linked_acct_id
,'' AS delinq_reshdl_mthd_flg
,'' AS total_num_of_switchover
,'' AS non_starter_flg
,'' AS float_int_tbl_code
,'' AS float_repricing_freq_mnths
,'' AS float_repricing_freq_days
,'' AS singleemi_tenordiff_flg
,'' AS iban_number
,'' AS ias_code
,'' AS topup_acid
,'' AS topup_type
,'' AS negotiated_rate_dr
,'F' AS penal_prod_mthd_flg
,'D' AS penal_rate_mthd_flg
,'Y' AS full_penal_mthd_flg
,'' AS hldy_prd_frm_first_disb_flg
,CASE WHEN lm.HasRepaySched = 'T' THEN 'Y' 
 ELSE NULL 
 END AS ei_schm_flg
,CASE WHEN lm.HasRepaySched = 'T' THEN 'R' 
 ELSE NULL 
 END AS ei_method
,CASE WHEN lm.HasRepaySched = 'T' THEN 'P' 
 ELSE NULL 
 END AS ei_formula_flg
,'' AS nrml_hldy_perd_mnths
,'' AS hldy_perd_int_flg
,'' AS hldy_perd_int_amt
,'' AS rshdl_tenor_ei_flg
,'' AS rshdl_disbt_flg
,'B' AS rshdl_rate_chng_flg   -- Need to discuss with loan team
,'Y' AS rshdl_prepay_flg	-- Need to discuss with loan team
,'O' AS rshdl_amt_flg
,'N' AS rephase_capitalize_int
,CASE WHEN lm.HasRepaySched = 'T' THEN NULL 
 ELSE 'A'
 END AS rephase_carry_ovdu_dmds
,'I' AS type_of_instlmnt_comb
,CASE WHEN lm.HasRepaySched = 'T' THEN 'Y' 
 ELSE NULL 
 END AS cap_emi_flg                        -- Still need to be discussed due to confusion posted
,'' AS emicap_deferred_int
,'' AS start_dfmnt_mnth
,'' AS num_mnths_deferred
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS chnl_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS chnl_dr_pref_pcnt
,'' AS channel_id
,'' AS channel_level_code
,'' AS instlmnt_grace_perd_term_flg
,'' AS instlmnt_grace_perd_mnths
,'Y' AS shift_instlmnt_flg
,'Y' AS include_matu_date_flg      -- Confusion, refer to mapping sheet
,'' AS rule_code
,'' AS cum_capitalize_fees
,'' AS upfront_instl_int_amt
,'N' AS recall_flg
,'' AS recall_date
,'' AS ps_diff_freq_rel_party_flg
,'' AS swift_diff_freq_rel_party_flg
,'' AS penal_int_tbl_code   -- customization required
,'' AS penal_pref_pcnt
,'' AS resp_acct_ref_no
,'' AS int_version
,'' AS add_type
,'' AS phone_type
,'' AS email_type
,'' AS accrued_penal_int_recovery
,'' AS penal_int_recovery
,'' AS coll_int_recovery
,'' AS coll_penal_int_recovery
,'' AS markup_int_rate_appl_flg
,'' AS preferred_cal_base
,'' AS purchase_ref
,CASE WHEN m.IsBlocked IN ('B','T','L','D') THEN 'T'
 WHEN m.IsBlocked = '-' THEN 'C'
 WHEN m.IsBlocked = '+' THEN 'D'
 END  AS frez_code
,CASE WHEN m.IsBlocked <> '' THEN 'OTHER'
 END AS frez_reason_code
,'' AS RL001_232
,'' AS RL001_233
,'' AS RL001_234
,'' AS RL001_235
,'' AS RL001_236
,'' AS RL001_237
,'' AS RL001_238
,'' AS RL001_239
,'' AS RL001_240
,'' AS RL001_241
,'' AS RL001_242
,'' AS RL001_243
,'' AS RL001_244
,'' AS RL001_245
,'' AS RL001_246
,'' AS RL001_247
,'' AS RL001_248
,'' AS RL001_249
,'' AS RL001_250
,'' AS RL001_251
,'' AS RL001_252
,'' AS RL001_253
,'' AS RL001_254
,'' AS RL001_255
,'' AS RL001_256
,'' AS RL001_257
,'' AS RL001_258
,'' AS RL001_259
,'' AS RL001_260
,'' AS RL001_261
,'' AS RL001_262
,'' AS RL001_263
,'' AS RL001_264
,'' AS RL001_265
,'' AS RL001_266
,'' AS RL001_267
,'' AS RL001_268
,'' AS RL001_269
,'' AS RL001_270
,'' AS RL001_271
,'' AS RL001_272
,'' AS RL001_273
,'' AS RL001_274
,'' AS RL001_275
,'' AS RL001_276
,'' AS RL001_277
,'' AS RL001_278
,'' AS RL001_279
,'' AS RL001_280
,'' AS RL001_281
,'' AS RL001_282
,'' AS RL001_283
,'' AS RL001_284
,'' AS RL001_285
,'' AS RL001_286
,'' AS RL001_287
,'' AS RL001_288
,'' AS RL001_289
,'' AS RL001_290
,'' AS RL001_291
,'' AS RL001_292
,'' AS RL001_293
,'' AS RL001_294
,'' AS RL001_295
,'' AS RL001_296
,'' AS RL001_297
,'' AS RL001_298
,'' AS RL001_299
,'' AS RL001_300
,'' AS RL001_301
,'' AS RL001_302
,'' AS RL001_303
,'' AS RL001_304
,'' AS RL001_305
,'' AS RL001_306
,'' AS RL001_307
,'' AS RL001_308
,'' AS RL001_309
,'' AS RL001_310
,'' AS RL001_311
,'' AS RL001_312
,'' AS RL001_313
,'' AS RL001_314
,'' AS RL001_315
,'' AS RL001_316
,'' AS RL001_317
,'' AS RL001_318
,'' AS RL001_319
,'' AS RL001_320
,'' AS RL001_321
,'' AS RL001_322
,'' AS RL001_323
,'' AS RL001_324
,'' AS RL001_325
,'' AS RL001_326
,'' AS RL001_327
,'' AS RL001_328
,'' AS RL001_329
,'' AS RL001_330
,'' AS RL001_331
,'' AS RL001_332
,'' AS RL001_333
,'' AS RL001_334
,'' AS RL001_335
,'' AS RL001_336
,'' AS RL001_337
,'' AS RL001_338
,'' AS RL001_339
,'' AS RL001_340
,'' AS RL001_341
,'' AS RL001_342
,'' AS RL001_343
,'' AS RL001_344
,'' AS RL001_345
,'' AS RL001_346
,'' AS RL001_347
,'' AS RL001_348
FROM Master m
LEFT JOIN LoanMaster lm on m.MainCode = lm.MainCode and m.BranchCode = lm.BranchCode
LEFT JOIN DealTable dt on dt.MainCode = m.MainCode and dt.BranchCode = m.BranchCode and dt.MaturityDate > @CToday
LEFT JOIN DependancyTable dep on dt.MainCode = dep.MainCode and dt.BranchCode = dep.BranchCode
LEFT JOIN 
(
	SELECT ReferenceNo,BranchCode,MIN(DueDate) AS pduedate FROM PastDuedList GROUP BY ReferenceNo,BranchCode
) as npdl ON m.MainCode = npdl.ReferenceNo AND m.BranchCode = npdl.BranchCode
LEFT JOIN 
(
	SELECT MainCode,BranchCode,MIN(DueDate) AS mduedate,SUM(DuePrincipal) AS DuePrincipal,MAX(DueDate) AS maxduedate FROM LoanRepaySched lrs1,ControlTable ct WHERE lrs1.DueDate > ct.Today GROUP BY MainCode,BranchCode
) AS mlrs ON m.MainCode = mlrs.MainCode and m.BranchCode = mlrs.BranchCode
LEFT JOIN 
(							-- Filters the clientcode with minimum account open date
	SELECT t.ClientCode,MIN(t.AcOpenDate) AS mindate FROM Master t GROUP BY t.ClientCode 
) AS tmaster ON m.ClientCode = tmaster.ClientCode
LEFT JOIN CurrencyTable curt ON m.CyCode = curt.CyCode
WHERE 1=1 
and m.AcType IN('30','31','32','33','36','37','38','39','3A','3B','3E','3F','3K','3L','3M','3N','3O','3P','3Q','3R','3S','3T','3U','3X','40','42','43','46','4A','4B','4F','4G','4I','4J','4K','4M','4O','4P','4Q','4S','3V','3Y','3Z','47','48','4C','4D','4E')
AND m.Balance <> 0 AND m.Limit <> 0
AND m.IsBlocked NOT IN ('C','o')
AND EXISTS (SELECT 1 FROM AcCustType where MainCode = m.MainCode and CustTypeCode = 'Z')
--and dt.MaturityDate > Getdate()
ORDER BY m.MainCode,m.BranchCode 