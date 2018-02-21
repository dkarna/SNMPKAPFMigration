select top 5
m.MainCode foracid													,											
case 
when TaxPercentOnInt = 0 or TaxPercentOnInt is null or TaxPostFrq=9 
or IntPostFrqCr=9 or AcType in ('01','02','03','04','28','0X') then 'N'
else 'W' end wtax_flg                    ,
'P' wtax_amount_scope_flg                                      ,
case when TaxPostFrq=9 or IntPostFrqCr=9 or 
AcType in ('01','02','03','04','28','0X') then 	RIGHT(SPACE(8)+CAST('0' AS VARCHAR(8)),8)
else RIGHT(SPACE(8)+CAST(TaxPercentOnInt AS VARCHAR(8)),8) end wtax_pcnt                     ,
RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) wtax_floor_limit                                           ,
case when m.MainCode in 
(select m.MainCode from AcCustType where CustTypeCode='Z' and CustType in ('11','12')) then 'R0'+ m.ClientCode
when m.MainCode in 
(select m.MainCode from AcCustType where CustTypeCode='Z' and CustType not in ('11','12')) then 'C0'+m.ClientCode 
else 'N0'+m.ClientCode end CIF_id                      ,		--need to check whether the query returns correctly.  
RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS cust_cr_pref_pcnt                                          ,
RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS cust_dr_pref_pcnt                                          ,
(select isnull((RIGHT(SPACE(10)+CAST(P.IntCrRateDef-M.IntCrRate AS VARCHAR(10)),10)),RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10)) from Master M, ParaTable P 
where M.BranchCode=P.BranchCode and M.AcType=P.AcType and M.CyCode=P.CyCode
and M.MainCode = m.MainCode) id_cr_pref_pcnt              ,
RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS id_dr_pref_pcnt                                            ,
RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS chnl_cr_pref_pcnt                                          ,
RIGHT(SPACE(10)+CAST('0' AS VARCHAR(10)),10) AS chnl_dr_pref_pcnt                                          ,
'N' Pegged_flg                                                 ,
' ' peg_frequency_in_months                                    ,
' ' peg_frequency_in_days                                      ,
case when IntPostFrqCr = 4 then 'M'
when IntPostFrqCr in (5,6) then 'Q'
when IntPostFrqCr = 7 then 'Y' end int_freq_type_cr          ,  --no mapping for 8 and 9
' ' int_freq_week_num_cr                                       ,
' ' int_freq_week_day_cr                                       ,
' ' int_freq_start_dd_cr                                       ,
'S' int_freq_hldy_stat_cr                                      ,	
' ' next_int_run_date_cr               ,			--BOD DATE
' ' int_freq_type_dr                                           ,
' ' int_freq_week_num_dr                                       ,
' ' int_freq_week_day_dr                                       ,
' ' int_freq_start_dd_dr                                       ,
' ' int_freq_hldy_stat_dr                                      ,
' ' next_int_run_date_dr                                       ,
' ' ledg_num                                                   ,
fe.EmpId emp_id                                                     ,
CONVERT(VARCHAR,AcOpenDate,105)  acct_opn_date                                 ,
' ' Mode_of_oper_code                                          ,
fs.FinacleSubGL Gl_sub_head_code                                           ,
fs.FinacleSchCode Schm_code                                                  ,
case when AcType in ('02','03','04','05','07','0X','0Z','28') then 'N' else 'Y' end Chq_alwd_flg                                               ,	--need to check condition
'S' Pb_ps_code                                                 ,
case when IsBlocked in ('B' ,'T','L','D') then 'T' 																																																																																																																																																																																																																																																																																																																																																																												
when IsBlocked ='-' then 'C' 
when IsBlocked ='+' then 'D' 
else ' ' end Frez_code                                        ,		
case when IsBlocked in ('B' ,'T', 'L','D','-','+') then 'OTH' else ' ' end Frez_reason_code    ,		-- after bpd for now only this query
m.MainCode free_text                                                  ,
case when IsDormant = 'T' then 'D' else 'A' end  acct_Status                                                ,
' ' free_code_1                                                ,
' ' free_code_2                                                ,
' ' free_code_3                                      ,		
' ' free_code_4                                                ,
' ' free_code_5                                                ,
' ' free_code_6                                                ,
' ' free_code_7                                                ,
' ' free_code_8                                                ,
' ' free_code_9                                                ,
' ' free_code_10                                               ,
' ' int_tbl_code                                               ,
' ' acct_loc_code                                              ,
c.CyDesc acct_crncy_code              , 	
BranchCode sol_id                                                     ,
'UBSADMIN' acct_mgr_user_id                                           ,
m.Name acct_name                                                  ,
'N' swift_allowed_flg                                          ,
isnull(CONVERT(VARCHAR,LastTranDate,105) ,CONVERT(VARCHAR,AcOpenDate,105) ) last_tran_date                                             ,
isnull((select MAX(CONVERT(VARCHAR,T.TranDate,105)) from TransDetail T where T.MainCode=m.MainCode), CONVERT(VARCHAR,AcOpenDate,105)) last_any_tran_date     , 
'Y' xclude_for_comb_stmt                                       ,
' ' stmt_cust_id                                               ,
' ' chrg_level_code                                            ,
'N' pbf_download_flg                                           ,
'A' wtax_level_flg                                             ,
RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) sanct_lim        , 
RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) Drwng_power     , 
RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) dacc_lim_abs    , 
RIGHT(SPACE(8)+CAST('0' AS VARCHAR(8)),8) dacc_lim_pcnt                                              ,
RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) max_alwd_advn_lim    , 
' ' health_code                                                ,
' ' sanct_levl_code                                            ,
' ' sanct_ref_num                                              ,
' ' lim_sanct_date                                             ,
' ' lim_exp_date                                               ,
' ' lim_review_date                                            ,
' ' loan_paper_date                                            ,
' ' sanct_auth_code                                            ,
' ' Compound_date                                              ,
'N' daily_comp_int_flg                                         ,
' ' COMP_Date_flg                                              ,
'N' disc_rate_flg                                              ,
' ' dummy                                                      ,
case when IsDormant='T'  THEN   convert(varchar,dateadd (MM,6,isnull (LastTranDate,AcOpenDate)),105) else '01-01-1900' end  acct_status_date                                           ,
' ' iban_number                                                ,
' ' ias_code                                                   ,
' ' channel_id                                                 ,
' ' channel_level_code                                         ,
RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) int_suspense_amt                                           ,
RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) Penal_int_Suspense_amt                                     ,
' ' Chrge_off_flg                                              ,
case when AcType='01'  and Limit<>'0' then 'Y' else 'N' end pd_flg                                                     ,
' ' pd_xfer_Date                                               ,
' ' Chrge_off_date                                             ,
RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS Chrge_off_principal                                        ,
RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS  Pending_interest                                           ,
RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS Principal_recovery                                         ,
RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS  interest_recovery                                          ,
' ' Charge_off_type                                            ,
' ' master_acct_num                                            ,
' ' ps_diff_freq_rel_party_flg                                 ,
' ' swift_diff_freq_rel_party_flg                              ,
' ' add_type                                                   ,
' ' Phone_type                                                 ,
' ' Email_type                                                 ,
' ' Alternate_Acct_Name                                        ,
' ' Interest_Rate_Period_Months                                ,
' ' Interest_Rate_Period_Days                                  ,
' ' Interpolation_Method                                       ,
' ' Is_Acct_hedged_Flg                                         ,
' ' Used_for_netting_off_flg                                   ,
' ' Security_Indicator                                         ,
' ' Debt_Security                                              ,
' ' Security_Code                                              ,
' ' Debit_Interest_Method                                      ,
' ' serv_chrg_coll_flg                                         ,
' ' Last_purge_date                                            ,
' ' Total_profit_amt                                           ,
' ' Minimum_age_not_met_amt                                    ,
' ' Broken_period_profit_paid_flg                              ,
RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS Broken_period_profit_amt                                   ,
RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) AS Profit_to_be_recovered                                     ,
' ' Profit_distributed_upto_date                               ,
' ' Next_profit_distributed_date                               ,
' ' Accrued_amt_till_interest_calc_date_cr                     ,           
' ' Unclaim_status                
from Master m 
left join CurrencyTable c on m.CyCode = c.CyCode
left join FinacleEmployeeTable fe on fe.ClientCode = m.ClientCode and fe.MainCode = m.MainCode
left join FinacleSchemeTable fs on fs.PumoriAcType = m.AcType and fs.PumoriCyCode = m.CyCode
where left(m.ClientCode,1)<>'_'
and AcType in ('05','07','08','09','0A','0B','0C','0D','0E','0F','0G','0H','0I','0J','0K','0L','0M','0N','0O','0P','0Q','0R','0S','0T','0U','0V','0W','0Y','0Z','10','11','12')



