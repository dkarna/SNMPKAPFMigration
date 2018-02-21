-- SQL for TD002

IF OBJECT_ID('tempdb.dbo.#tempdealtable', 'U') IS NOT NULL
  DROP TABLE #tempdealtable;									-- Drop temporary tempdealtable table if it exists

-- Creation of temporary DealTable as #tempdealtable
SELECT * INTO #tempdealtable FROM DealTable 
WHERE MaturityDate > GETDATE() 
AND (AcType >= '13' AND AcType <= '21') 
ORDER BY MainCode,ReferenceNo;

IF OBJECT_ID('tempdb.dbo.#tempdealmaster', 'U') IS NOT NULL
  DROP TABLE #tempdealmaster;    -- Drop temporary tempdealmaster table if it exists
  
-- creation of temporary Master AS #tempdealmaster
SELECT * INTO #tempdealmaster FROM Master 
WHERE MainCode IN
(
	SELECT DISTINCT MainCode FROM #tempdealtable
) 
ORDER BY MainCode;

IF OBJECT_ID('tempdb.dbo.#tempinttrandetail', 'U') IS NOT NULL
  DROP TABLE #tempinttrandetail;    -- Drop temporary tempinttrandetail table if it exists
  
-- creation of temporary IntTranDetail AS #tempinttrandetail
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

-- Main Query

SELECT
'' AS emp_id
,'' AS cust_cr_pref_pcnt
,'' AS cust_dr_pref_pcnt
,'0' AS id_cr_pref_pcnt
,'0' AS id_dr_pref_pcnt
,'0' AS chnl_cr_pref_pcnt
,'0' AS chnl_dr_pref_pcnt
,'Y' AS pegged_flg
,'' AS peg_frequency_in_months
,'' AS peg_frequency_in_days
,'' AS sulabh_flg
,'Y' AS int_accrual_flg
,'R' AS pb_ps_code
,'P' AS wtax_amount_scope_flg
,'W' AS wtax_flg
,'N' AS safe_custody_flg
,'' AS cash_excp_amt_lim
,'' AS clg_excp_amt_lim
,'' AS xfer_excp_amt_lim
,'' AS cash_cr_excp_amt_lim
,'' AS clg_cr_excp_amt_lim
,'' AS xfer_cr_excp_amt_lim
,'' AS foracid					-- will be provided after BPD
,t2.CyCode AS acct_crncy_code   -- ct.CyDesc to be used to replace CyCode
,t2.BranchCode AS sol_id
,'' AS gl_sub_head_code			-- will be provided after BPD
,'' AS schm_code				-- will be provided after BPD
,t1.ClientCode AS cif_id					
,t2.DealAmt AS deposit_amount
,'' AS deposit_period_mths
,'' AS deposit_period_days
,'' AS int_tbl_code				-- will be provided after BPD
,'' AS mode_of_oper_code		-- available in RRCDM so need to be provided (bank will provide)
,'' AS acct_locn_code
,'N' AS auto_renewal_flg
,'' AS perd_mths_for_auto_renew
,'' AS perd_days_for_auto_renew
,t2.DealOpenDate AS acct_opn_date
,t2.DealOpenDate AS open_effective_date
,'N' AS nominee_print_flg
,'Y' AS printing_flg
,'' AS ledg_num
,t3.CalcDate AS interest_calc_upto_date_cr
,t3.CalcDate AS last_interest_run_date_cr
,t2.IntCalcFrom AS last_int_provision_date
,t2.DealOpenDate AS printed_date
,t2.IntPaid AS cumulative_int_paid
,t2.IntPaid AS cumulative_int_credited
,t2.DealAmt AS cumulative_instl_paid
,t2.DealAmt AS maturity_amount
,t2.NomAcInterest AS int_cr_acid
,t1.CyCode AS op_acct_crncy_code
,LEFT(t2.NomAcInterest,3) AS op_acct_sol_id
,'' AS notice_period_mnths
,'' AS notice_period_days
,'' AS notice_date
,'' AS Stamp_Duty_Borne_By_Cust
,'' AS Stamp_Duty_Amount
,'' AS stamp_duty_amount_crncy_code
,'' AS original_deposit_amount
,t2.IntRate AS abs_rate_of_int
,'' AS xclude_for_comb_stmt
,'' AS stmt_cust_id
,t2.MaturityDate AS maturity_date
,'' AS treasury_rate_pcnt
,'' AS renewal_option
,'' AS renewal_amount
,'' AS renewal_addnl_amt
,'' AS renewal_addnl_amt_crncy
,'' AS renewal_crncy
,'' AS renewal_master_acct_id
,'' AS Additional_Src_acct_Crncy_Code
,'' AS Additional_acct_Sol_Id    
,'' AS renewal_addnl_amt_rate_code
,'' AS renewal_rate_code
,'' AS additional_rate
,'' AS renewal_rate
,t2.NomAcInterest AS link_oper_account
,'' AS outflow_multiple_amt
,'A' AS wtax_level_flg    -- need to confirm from CAS
,t2.TaxPercentOnDeal AS wtax_pcnt
,'' AS wtax_floor_limit
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
,'' AS fixed_installment_amt
,'' AS nrml_installment_pcnt
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
FROM #tempdealmaster t1 JOIN #tempdealtable t2 ON t1.MainCode = t2.MainCode
JOIN #tempinttrandetail t3 ON t2.MainCode = t3.MainCode and t2.ReferenceNo = t3.ReferenceNo
-- JOIN CurrencyTable ct ON t1.CyCode = ct.CyCode
