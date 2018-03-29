IF OBJECT_ID('tempdb.dbo.#tempinttrandetail', 'U') IS NOT NULL
  DROP TABLE #tempinttrandetail;    -- Drop temporary tempinttrandetail table if it exists

SELECT tdt.* INTO #tempinttrandetail FROM IntTranDetail tdt 
JOIN
(
	SELECT DISTINCT MainCode,ReferenceNo,MAX(CalcDate) AS CalcDate FROM IntTranDetail itd 
	WHERE AcType >= '13' AND AcType <= '21' 
	GROUP BY MainCode,ReferenceNo 
) AS tempinttrandetail
ON tdt.MainCode = tempinttrandetail.MainCode 
AND tdt.ReferenceNo = tempinttrandetail.ReferenceNo 
AND tdt.CalcDate = tempinttrandetail.CalcDate 
ORDER by tdt.MainCode,tdt.ReferenceNo

-- Retail TD

SELECT
isnull(fet.EmpId,'') AS emp_id
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS cust_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS cust_dr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS id_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS id_dr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS chnl_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS chnl_dr_pref_pcnt
,'Y' AS pegged_flg
,'' AS peg_frequency_in_months
,'' AS peg_frequency_in_days
,'' AS sulabh_flg
,'Y' AS int_accrual_flg
,'R' AS pb_ps_code
,'P' AS wtax_amount_scope_flg
,'W' AS wtax_flg
,'N' AS safe_custody_flg
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS cash_excp_amt_lim
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS clg_excp_amt_lim
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS xfer_excp_amt_lim
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS cash_cr_excp_amt_lim
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS clg_cr_excp_amt_lim
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS xfer_cr_excp_amt_lim
,'R0'+m.MainCode AS foracid					-- will be provided after BPD
,ctd.CyDesc AS acct_crncy_code   
,dt.BranchCode AS sol_id
,ftdt.FinacleSubGL AS gl_sub_head_code			-- updated from lookup FinacleTDTable
,ftdt.FinacleSchCode AS schm_code				-- updated from lookup FinacleTDTable
,m.ClientCode AS cif_id					
,RIGHT(SPACE(17)+CAST(dt.DealAmt AS VARCHAR(17)),17) AS deposit_amount
,'' AS deposit_period_mths
,'' AS deposit_period_days
,'' AS int_tbl_code				-- will be provided after BPD
,'' AS mode_of_oper_code		-- available in RRCDM so need to be provided (bank will provide)
,'' AS acct_locn_code
,'N' AS auto_renewal_flg
,'' AS perd_mths_for_auto_renew
,'' AS perd_days_for_auto_renew
,CONVERT(VARCHAR(10),dt.DealOpenDate,105) AS acct_opn_date  -- CONVERT(VARCHAR(10),lm.IssueDate,105)
,CONVERT(VARCHAR(10),dt.DealOpenDate,105) AS open_effective_date
,'N' AS nominee_print_flg
,'Y' AS printing_flg
,'' AS ledg_num
,CONVERT(VARCHAR(10),titd.CalcDate,105) AS interest_calc_upto_date_cr
,CONVERT(VARCHAR(10),titd.CalcDate,105) AS last_interest_run_date_cr
,CONVERT(VARCHAR(10),dt.IntCalcFrom,105) AS last_int_provision_date
,CONVERT(VARCHAR(10),dt.DealOpenDate,105) AS printed_date
,RIGHT(SPACE(17)+CAST(dt.IntPaid AS VARCHAR(17)),17) AS cumulative_int_paid
,RIGHT(SPACE(17)+CAST(dt.IntPaid AS VARCHAR(17)),17) AS cumulative_int_credited
,RIGHT(SPACE(17)+CAST(dt.DealAmt AS VARCHAR(17)),17) AS cumulative_instl_paid
,RIGHT(SPACE(17)+CAST(dt.DealAmt AS VARCHAR(17)),17) AS maturity_amount
,dt.NomAcInterest AS int_cr_acid
,ctd.CyDesc AS op_acct_crncy_code
,LEFT(dt.NomAcInterest,3) AS op_acct_sol_id
,'' AS notice_period_mnths
,'' AS notice_period_days
,'' AS notice_date
,'' AS Stamp_Duty_Borne_By_Cust
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS Stamp_Duty_Amount
,'' AS stamp_duty_amount_crncy_code
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS original_deposit_amount
,dt.IntRate AS abs_rate_of_int
,'' AS xclude_for_comb_stmt
,'' AS stmt_cust_id
,CONVERT(VARCHAR(10),dt.MaturityDate,105) AS maturity_date
,'' AS treasury_rate_pcnt
,'' AS renewal_option
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS renewal_amount
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS renewal_addnl_amt
,'' AS renewal_addnl_amt_crncy
,'' AS renewal_crncy
,'' AS renewal_master_acct_id
,'' AS Additional_Src_acct_Crncy_Code
,'' AS Additional_acct_Sol_Id    
,'' AS renewal_addnl_amt_rate_code
,'' AS renewal_rate_code
,'' AS additional_rate
,'' AS renewal_rate
,dt.NomAcInterest AS link_oper_account
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS outflow_multiple_amt
,'A' AS wtax_level_flg    -- need to confirm from CAS
,RIGHT(SPACE(8)+CAST(dt.TaxPercentOnDeal AS VARCHAR(8)),8) AS wtax_pcnt
,dt.TaxPercentOnDeal AS wtax_floor_limit
,'' AS iban_number
,'' AS ias_code
,'' AS channel_id
,'' AS channel_level_code
,'' AS master_b2k_id
,'A' AS acct_status
,'' AS acct_status_date
,'' AS dummy
,'' AS ps_diff_freq_rel_party_flg
,'' AS swift_diff_freq_rel_party_flg
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS fixed_installment_amt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS nrml_installment_pcnt
,'' AS installment_basis
,'' AS max_miss_contrib_allow
,'' AS auto_closure_of_irregular_acct
,'' AS total_no_of_miss_contrib
,'' AS acct_irregular_status
,'' AS acct_irregular_status_date
,'' AS cumulative_nrml_instl_paid
,'' AS cumulative_initial_dep_paid
,'' AS cumulative_top_up_paid
,'' AS auto_closure_of_zero_bal_mnths
,'' AS auto_closure_of_zero_bal_days
,'' AS last_bonus_run_date
,'' AS last_calc_bonus_amount
,'' AS bonus_upto_date
,'' AS next_bonus_run_date
,'' AS nrml_int_paid_til_lst_bonus
,'' AS bonus_cycle
,'' AS last_calc_bonus_pcnt
,'' AS penalty_amount
,'' AS penalty_charge_event_id
,'' AS cust_phone_type
,'' AS cust_email_type
,'' AS loc_deposit_period_mths
,'' AS loc_deposit_period_days
,'' AS hedged_acct_flg
,'' AS used_for_net_off_flg
,'' AS Maximum_Auto_Renewal_Allowed 
,'' AS Close_on_Maturity_Flag
,'' AS Last_Purge_Date 
,'' AS Pay_Preclose_Profit
,'' AS Pay_Maturity_Profit
,'' AS Murabaha_Deposit_Amount
,'' AS Customer_Purchase_ID 
,'' AS Total_Profit_Amount
,'' AS Minimum_Age_not_met_amount 
,'' AS Broken_Period_Profit_paid_Flag
,'' AS Broken_Period_Profit_amount
,'' AS Profit_to_be_recovered
,'' AS Ind_Profit_distributed_upto_Date
,'' AS Ind_next_Profit_distributed_Date
,'' AS Transfer_In_Indicator
,'' AS Repayment_account_ID
,'' AS rebate_amount 
,'' AS branch_office 
,'' AS deferment_period_mnths 
,'' AS continuation_ind 
,'' AS unclaim_status 
,'' AS unclaim_status_date 
,'' AS orig_gl_sub_head_code
from DealTable dt 
left join Master m on dt.MainCode = m.MainCode and dt.BranchCode=m.BranchCode
left join FinacleTDTable ftdt on m.AcType = ftdt.PumoriAcType and m.CyCode=ftdt.PumoriCyCode and m.IntPostFrqCr=ftdt.PumoriIntPostFrqCr
left join FinacleEmployeeTable fet on fet.MainCode=m.MainCode and fet.ClientCode=m.ClientCode
left join #tempinttrandetail titd on dt.MainCode=titd.MainCode and dt.ReferenceNo = titd.ReferenceNo
left join CurrencyTable ctd on m.CyCode = ctd.CyCode,
ControlTable ct
where (dt.AcType >= '13' AND dt.AcType <= '21') --and dt.CyCode in ('01','21')
and len(m.ClientCode) >= 8
and left(m.ClientCode,1)<>'_'
and m.IsBlocked NOT IN ('C','o')
and dt.MaturityDate > ct.Today
and EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = m.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
)

UNION

-- Corporate TD

SELECT
isnull(fet.EmpId,'') AS emp_id
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS cust_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS cust_dr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS id_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS id_dr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS chnl_cr_pref_pcnt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS chnl_dr_pref_pcnt
,'Y' AS pegged_flg
,'' AS peg_frequency_in_months
,'' AS peg_frequency_in_days
,'' AS sulabh_flg
,'Y' AS int_accrual_flg
,'R' AS pb_ps_code
,'P' AS wtax_amount_scope_flg
,'W' AS wtax_flg
,'N' AS safe_custody_flg
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS cash_excp_amt_lim
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS clg_excp_amt_lim
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS xfer_excp_amt_lim
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS cash_cr_excp_amt_lim
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS clg_cr_excp_amt_lim
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS xfer_cr_excp_amt_lim
,'C'+m.MainCode AS foracid					-- will be provided after BPD
,ctd.CyDesc AS acct_crncy_code   
,dt.BranchCode AS sol_id
,ftdt.FinacleSubGL AS gl_sub_head_code			-- updated from lookup FinacleTDTable
,ftdt.FinacleSchCode AS schm_code				-- updated from lookup FinacleTDTable
,m.ClientCode AS cif_id					
,RIGHT(SPACE(17)+CAST(dt.DealAmt AS VARCHAR(17)),17) AS deposit_amount
,'' AS deposit_period_mths
,'' AS deposit_period_days
,'' AS int_tbl_code				-- will be provided after BPD
,'' AS mode_of_oper_code		-- available in RRCDM so need to be provided (bank will provide)
,'' AS acct_locn_code
,'N' AS auto_renewal_flg
,'' AS perd_mths_for_auto_renew
,'' AS perd_days_for_auto_renew
,CONVERT(VARCHAR(10),dt.DealOpenDate,105) AS acct_opn_date  -- CONVERT(VARCHAR(10),lm.IssueDate,105)
,CONVERT(VARCHAR(10),dt.DealOpenDate,105) AS open_effective_date
,'N' AS nominee_print_flg
,'Y' AS printing_flg
,'' AS ledg_num
,CONVERT(VARCHAR(10),titd.CalcDate,105) AS interest_calc_upto_date_cr
,CONVERT(VARCHAR(10),titd.CalcDate,105) AS last_interest_run_date_cr
,CONVERT(VARCHAR(10),dt.IntCalcFrom,105) AS last_int_provision_date
,CONVERT(VARCHAR(10),dt.DealOpenDate,105) AS printed_date
,RIGHT(SPACE(17)+CAST(dt.IntPaid AS VARCHAR(17)),17) AS cumulative_int_paid
,RIGHT(SPACE(17)+CAST(dt.IntPaid AS VARCHAR(17)),17) AS cumulative_int_credited
,RIGHT(SPACE(17)+CAST(dt.DealAmt AS VARCHAR(17)),17) AS cumulative_instl_paid
,RIGHT(SPACE(17)+CAST(dt.DealAmt AS VARCHAR(17)),17) AS maturity_amount
,dt.NomAcInterest AS int_cr_acid
,ctd.CyDesc AS op_acct_crncy_code
,LEFT(dt.NomAcInterest,3) AS op_acct_sol_id
,'' AS notice_period_mnths
,'' AS notice_period_days
,'' AS notice_date
,'' AS Stamp_Duty_Borne_By_Cust
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS Stamp_Duty_Amount
,'' AS stamp_duty_amount_crncy_code
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS original_deposit_amount
,dt.IntRate AS abs_rate_of_int
,'' AS xclude_for_comb_stmt
,'' AS stmt_cust_id
,CONVERT(VARCHAR(10),dt.MaturityDate,105) AS maturity_date
,'' AS treasury_rate_pcnt
,'' AS renewal_option
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS renewal_amount
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS renewal_addnl_amt
,'' AS renewal_addnl_amt_crncy
,'' AS renewal_crncy
,'' AS renewal_master_acct_id
,'' AS Additional_Src_acct_Crncy_Code
,'' AS Additional_acct_Sol_Id    
,'' AS renewal_addnl_amt_rate_code
,'' AS renewal_rate_code
,'' AS additional_rate
,'' AS renewal_rate
,dt.NomAcInterest AS link_oper_account
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS outflow_multiple_amt
,'A' AS wtax_level_flg    -- need to confirm from CAS
,RIGHT(SPACE(8)+CAST(dt.TaxPercentOnDeal AS VARCHAR(8)),8) AS wtax_pcnt
,dt.TaxPercentOnDeal AS wtax_floor_limit
,'' AS iban_number
,'' AS ias_code
,'' AS channel_id
,'' AS channel_level_code
,'' AS master_b2k_id
,'A' AS acct_status
,'' AS acct_status_date
,'' AS dummy
,'' AS ps_diff_freq_rel_party_flg
,'' AS swift_diff_freq_rel_party_flg
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS fixed_installment_amt
,RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS nrml_installment_pcnt
,'' AS installment_basis
,'' AS max_miss_contrib_allow
,'' AS auto_closure_of_irregular_acct
,'' AS total_no_of_miss_contrib
,'' AS acct_irregular_status
,'' AS acct_irregular_status_date
,'' AS cumulative_nrml_instl_paid
,'' AS cumulative_initial_dep_paid
,'' AS cumulative_top_up_paid
,'' AS auto_closure_of_zero_bal_mnths
,'' AS auto_closure_of_zero_bal_days
,'' AS last_bonus_run_date
,'' AS last_calc_bonus_amount
,'' AS bonus_upto_date
,'' AS next_bonus_run_date
,'' AS nrml_int_paid_til_lst_bonus
,'' AS bonus_cycle
,'' AS last_calc_bonus_pcnt
,'' AS penalty_amount
,'' AS penalty_charge_event_id
,'' AS cust_phone_type
,'' AS cust_email_type
,'' AS loc_deposit_period_mths
,'' AS loc_deposit_period_days
,'' AS hedged_acct_flg
,'' AS used_for_net_off_flg
,'' AS Maximum_Auto_Renewal_Allowed 
,'' AS Close_on_Maturity_Flag
,'' AS Last_Purge_Date 
,'' AS Pay_Preclose_Profit
,'' AS Pay_Maturity_Profit
,'' AS Murabaha_Deposit_Amount
,'' AS Customer_Purchase_ID 
,'' AS Total_Profit_Amount
,'' AS Minimum_Age_not_met_amount 
,'' AS Broken_Period_Profit_paid_Flag
,'' AS Broken_Period_Profit_amount
,'' AS Profit_to_be_recovered
,'' AS Ind_Profit_distributed_upto_Date
,'' AS Ind_next_Profit_distributed_Date
,'' AS Transfer_In_Indicator
,'' AS Repayment_account_ID
,'' AS rebate_amount 
,'' AS branch_office 
,'' AS deferment_period_mnths 
,'' AS continuation_ind 
,'' AS unclaim_status 
,'' AS unclaim_status_date 
,'' AS orig_gl_sub_head_code
from DealTable dt 
left join Master m on dt.MainCode = m.MainCode and dt.BranchCode=m.BranchCode
left join FinacleTDTable ftdt on m.AcType = ftdt.PumoriAcType and m.CyCode=ftdt.PumoriCyCode and m.IntPostFrqCr=ftdt.PumoriIntPostFrqCr
left join FinacleEmployeeTable fet on fet.MainCode=m.MainCode and fet.ClientCode=m.ClientCode
left join #tempinttrandetail titd on dt.MainCode=titd.MainCode and dt.ReferenceNo = titd.ReferenceNo
left join CurrencyTable ctd on m.CyCode = ctd.CyCode,
ControlTable ct
where (dt.AcType >= '13' AND dt.AcType <= '21') --and dt.CyCode in ('01','21')
and len(m.ClientCode) >= 8
and left(m.ClientCode,1)<>'_'
and m.IsBlocked NOT IN ('C','o')
and dt.MaturityDate > ct.Today
and EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = m.MainCode and CustTypeCode = 'Z' and CustType NOT IN ('11','12')
)