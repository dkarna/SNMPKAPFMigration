select
S.BranchCode SOL_ID                                                           ,
case when ShowFreq = 1 then 'D'
when ShowFreq = 2 then 'W'
when ShowFreq = 3 then 'F'
when ShowFreq = 4 then 'M'
when ShowFreq = 5 then 'Q'
when ShowFreq = 6 then 'H'
when ShowFreq = 7 then 'Y'
end SI_Freq_Type                                                     ,
' ' SI_Freq_Week_Num                                                 ,
' ' SI_Freq_Week_Day                                                 ,
' ' SI_Freq_Start_DD                                                 ,
'P' SI_Freq_Hldy_Stat                                                ,
case when ProcessWhen = 'E' then 'A' else 'B' end SI_exec_code      , 
isnull(convert(varchar,ExpiryDate,105),'12-31-2099') SI_end_date                   , --need to discuss
convert(varchar,dateadd(day , 30 , ShowDate),105) Next_exec_date      ,	--need to discuss
DestAccount tgt_Acct                                                   ,
'E' Balance_Ind                                                ,
'E' Excess_Short_Ind                                                 ,
RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) Tgt_balance                                                      ,
'Y' Auto_pstd_flg                                                    ,
'Y' Carry_for_alwd_flg                                               ,
'N' Validate_Crncy_Hldy                                 ,
'N' Del_tran_if_not_pstd                                             ,	--need to discuss
'3' Carry_forward_limit                                              ,
'C' SI_Class                                                         ,	--need to discuss
case when M.MainCode in 
(select MainCode from AcCustType where CustTypeCode='Z' and CustType in ('11','12')) 
then 'R0'+ M.ClientCode when M.MainCode in 
(select MainCode from AcCustType where CustTypeCode='Z' and CustType not in ('11','12')) 
then 'C0'+M.ClientCode else 'N0'+M.ClientCode end CIF_ID                ,		--need to check the correctness of result
Description+'/'+RequestBy Remarks                                                          ,
' ' Closure_remarks                                                  ,
' ' Exec_chrg_code                                            ,
' ' Failure_chrg_code                                              ,
' ' Chrg_rate_code                                                 ,
' ' Chrg_dr_acid                                      ,
case when AmountXfrValue='A' then 'F' else 'V' end Amount_Ind                                           ,
'N' Create_Memo_Pad_Entry                                            ,
c.CyDesc Crncy_Code                                                    ,
RIGHT(SPACE(17)+CAST(Amount AS VARCHAR(17)),17) Fixed_Amount                   ,		--need to put case
'D' Part_Tran_Type                                                   ,
'E' Balance_Ind                                                ,
'E' Excess_Short_Indicator                                           ,
S.MainCode No_of_Account   , 
RIGHT(SPACE(17)+CAST(M.GoodBaln AS VARCHAR(17)),17) Acct_Bal                                                  ,	--need to check case if necessary as co-mandatory
RIGHT(SPACE(8)+CAST('0' AS VARCHAR(8)),8) Percentage                                                       ,	--need to discuss
RIGHT(SPACE(17)+CAST('1' AS VARCHAR(17)),17) Amount_multiple                                                  ,
S.MainCode ADM_Account_No_Dr				,
' ' Round_off_Type                                                  ,
RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) Round_off_Value                                                  ,
'N' Collect_Chrg                                                  ,
' ' Report_Code                                                      ,
' ' Reference_No_cr                                                ,
' ' Tran_particular_cr                                                 ,
' ' Tran_remarks_cr                                                     ,
' ' Intent_Code_cr                                                      ,
' ' DD_payable_bank_code                                             ,
' ' DD_payable_branch_code                                           ,
' ' Payee_name                                                       ,
' ' Purchase_Acct_No                                          ,
' ' Purchase_Name                                                    ,
' ' cr_adv_pymnt_flg                                                 ,
'F' Amount_Indicator                                                 ,
'N' Create_Memo_Pad_Entry                                            ,
DestAccount ADM_Account_No_Cr                                                  ,
' ' Round_off_Type                                                   ,
RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) Round_off_Value                                                  ,
'N' Collect_Charges                                                  ,
' ' Report_Code                                                      ,
' ' Reference_No_dr                                                 ,
' ' Tran_particular_dr                                                  ,
' ' Tran_remarks_dr                                                     ,
' ' Intent_Code_dr                                                     ,
' ' SI_priority                                                      ,
' ' si_freq_cal_base                                                 ,	--need to discuss
RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) cr_ceiling_amt                                                   ,
RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) cr_cumulative_amt                                                ,
RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) dr_ceiling_amt                                                   ,
RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) dr_cumulative_amt                                                ,
' ' siFreqNdays                                                      ,
' ' Script_File_Name
from StandingIns S,Master M left join CurrencyTable c on c.CyCode = M.CyCode
,Master D 
where S.MainCode = M.MainCode
and S.BranchCode = M.BranchCode
and S.DestAccount = D.MainCode
and S.ShowFreq<>'9'
and M.IsBlocked not in ('C','o')
and D.IsBlocked not in ('C','o')
and S.BranchCode  = D.BranchCode 

