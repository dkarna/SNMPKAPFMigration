select 
MainCode foracid			,
c.CyDesc acct_crncy_code                 ,	
BranchCode sol_id                                                 ,
'M' acct_poa_as_rec_type                                   , 
case when C.ClientCode is null then LEFT(M.Name, CHARINDEX('/', M.Name)) 
else ' ' end acct_poa_as_name                                       ,
' ' acct_poa_as_desig                                      ,
RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) acct_poa_as_amt_alwd                                   ,
convert(varchar,AcOpenDate,105) start_date                                             ,
'31-12-2099' end_date                                               ,
C.ClientCode cust_id                                                ,
case when M.AcOfficer is null or ltrim(rtrim(M.AcOfficer)) = '' then 'MIGR' else left(M.AcOfficer,5) end cust_reltn_code                                        ,
'Y' pass_sheet_flg                                         ,	
'Y' si_flg                                                 ,	
'Y' td_matrty_flg                                          ,	
'Y' loan_ovrdue_flg                                        ,
Address1 address1                                               ,
Address2 address2                                               ,
Address3 address3                                               ,
DistrictCode city_code                  ,		--after BPD
' ' state_code                                             ,
' ' pin_code                                               ,
' ' cntry_code                                             ,
Phone phone_num1                                             ,
' ' fax_num1                                               ,
' ' tlx_num                                                ,
eMail email_id                                               ,
'Y' xclude_for_comb_stmt                                   ,
' ' stmt_cust_id                                           ,
case when lower(Gender) = 'f' or Salutation  = 'MRS' then 'MS'
when lower(Gender) = 'm' or Salutation = 'MR' then 'MR' 
when lower(Gender) not in ('f','m') and M.MainCode in 
((select MainCode from AcCustType WHERE MainCode = M.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')))
then 'MGR'
else 'M/S'end cust_title_code                                        , 	--need to check 
' ' intcert_print_flg                                      ,
' ' int_adv_flg                                            ,
' ' guarantor_liab_pcnt                                    ,
' ' guarantor_liab_seq                                     ,
'D' ps_freq_type                                           ,
' ' ps_freq_week_num                                       ,
' ' ps_freq_week_day                                       ,
' ' ps_freq_start_dd                                       ,
' ' ps_freq_hldy_stat                                      ,
' ' swift_stmt_srl_num                                     ,
'N' mode_of_despatch                                       ,
' ' swift_freq_type                                        ,
' ' swift_freq_week_num                                    ,
' ' swift_freq_week_day                                    ,
' ' swift_freq_start_dd                                    ,
' ' swift_freq_hldy_stat                                   ,
' ' swft_msg_type                                          ,
' ' paysys_id                                              ,
' ' nma_key_type                                           ,
' ' cust_phone_type                                        ,
' ' cust_email_type                                        ,
' ' CS003_051                                              
from Master M 
left join CurrencyTable c on c.CyCode = M.CyCode
left join ClientTable C on M.ClientCode = C.ClientCode
where left(C.ClientCode , 1)<>'_'
and IsBlocked NOT IN ('C','o')
--AcType in ('07','08','09','10','11','13','14','16','17','18','1A','1B','1D','1E','1F','1H','1I','1J','1K','1L','1M','1N','1O','1P','1R')