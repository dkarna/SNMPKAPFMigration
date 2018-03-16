select
S.BranchCode SOL_ID
,case when ShowFreq = 1 then 'D'
when ShowFreq = 2 then 'W'
when ShowFreq = 3 then 'F'
when ShowFreq = 4 then 'M'
when ShowFreq = 5 then 'Q'
when ShowFreq = 6 then 'H'
when ShowFreq = 7 then 'Y'
end SI_Freq_Type
,'1' SI_Freq_Week_Num
,CASE WHEN ShowFreq = 2 then '6' else ' ' end as SI_Freq_Week_Day
,CASE WHEN S.ShowDate is not null then DATEPART(day, S.ShowDate) ELSE DATEPART(day,getdate()) end as SI_Freq_Start_DD -- need to discuss
,'S' SI_Freq_Hldy_Stat	
,case when ProcessWhen = 'E' then 'A' else 'B' end SI_exec_code
,isnull(convert(varchar,ExpiryDate,105),'12-31-2099') SI_end_date
,convert(varchar(10),CT.Today+1,105) Next_exec_date -- need to conform with bank
--,convert(varchar,dateadd(day , 30 , ShowDate),105) Next_exec_date
,DestAccount tgt_Acct
,'E' Balance_Ind
,'S' Excess_Short_Ind -- need to confirm (E/S)
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) Tgt_balance
,'Y' Auto_pstd_flg
,'Y' Carry_for_alwd_flg
,'N' Validate_Crncy_Hldy
,'Y' Del_tran_if_not_pstd
,RIGHT(SPACE(5)+CAST('3' AS VARCHAR(5)),5) Carry_forward_limit
,'B' SI_Class
,'R0'+ M.ClientCode as CIF_ID
,Description+'/'+RequestBy Remarks
,' ' Closure_remarks
,' ' Exec_chrg_code
,' ' Failure_chrg_code
,' ' Chrg_rate_code
,' ' Chrg_dr_acid
,case when AmountXfrValue='A' then 'F' else 'V' end Amount_Ind
,'N' Create_Memo_Pad_Entry
,c.CyDesc Crncy_Code
,RIGHT(SPACE(17)+CAST(Amount AS VARCHAR(17)),17) Fixed_Amount
,'D' Part_Tran_Type
,'E' Balance_Ind
,'E' Excess_Short_Indicator
,S.MainCode No_of_Account
,RIGHT(SPACE(17)+CAST(M.GoodBaln AS VARCHAR(17)),17) Acct_Bal -- need to check
,CAse when  AmountXfrValue = 'A' then RIGHT(SPACE(8)+CAST('100' AS VARCHAR(8)),8) else  RIGHT(SPACE(8)+CAST('0' AS VARCHAR(8)),8) end as Percentage
,CAse when  AmountXfrValue = 'A' then RIGHT(SPACE(17)+CAST('0.01' AS VARCHAR(17)),17) else  RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) end as Amount_multiple
,S.MainCode ADM_Account_No_Dr
,case when AmountXfrValue <>'A' then 'N' else ' 'end as  Round_off_Type
,CAse when  AmountXfrValue = 'A' then RIGHT(SPACE(17)+CAST('0.01' AS VARCHAR(17)),17) else  RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) end Round_off_Value
,'N' Collect_Chrg
,' ' Report_Code
,' ' Reference_No_cr
,' ' Tran_particular_cr
,' ' Tran_remarks_cr
,' ' Intent_Code_cr
,' ' DD_payable_bank_code
,' ' DD_payable_branch_code
,' ' Payee_name
,' ' Purchase_Acct_No
,' ' Purchase_Name
,' ' cr_adv_pymnt_flg
,'F' Amount_Indicator -- need to confirm
,'N' Create_Memo_Pad_Entry
,DestAccount ADM_Account_No_Cr
,' ' Round_off_Type
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) Round_off_Value
,'N' Collect_Charges
,' ' Report_Code
,S.ReferenceNo Reference_No_dr
,' ' Tran_particular_dr
,' ' Tran_remarks_dr
,' ' Intent_Code_dr
,' ' SI_priority
,' ' si_freq_cal_base
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) cr_ceiling_amt
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) cr_cumulative_amt
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) dr_ceiling_amt
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) dr_cumulative_amt
,' ' siFreqNdays
,' ' Script_File_Name
from StandingIns S
JOIN Master M ON M.MainCode = S.MainCode AND M.BranchCode = S.BranchCode --and S.DestAccount = M.MainCode
left join CurrencyTable c on c.CyCode = M.CyCode
 , ControlTable CT
where S.ShowFreq<>'9'
and M.IsBlocked not in ('C','o')
and len(M.MainCode) >= 8
and LEFT(M.ClientCode , 1) <>'_'
AND M.AcType In ('01','05','06','07','08','09','0A','0B','0C','0D','0E','0F','0G','0H','0I','0J','0K','0L',
 '0M','0N','0O','0P','0Q','0R','0S','0T','0U','0V','0W','0X','0Y','0Z','10','11','28','29','3C','3D','3G','3H','3I','3J','0V','3W','4H','4L')
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = M.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
) 

union

select
S.BranchCode SOL_ID
,case when ShowFreq = 1 then 'D'
when ShowFreq = 2 then 'W'
when ShowFreq = 3 then 'F'
when ShowFreq = 4 then 'M'
when ShowFreq = 5 then 'Q'
when ShowFreq = 6 then 'H'
when ShowFreq = 7 then 'Y'
end SI_Freq_Type
,'1' SI_Freq_Week_Num
,CASE WHEN ShowFreq = 2 then '6' else ' ' end as SI_Freq_Week_Day
,CASE WHEN S.ShowDate is not null then DATEPART(day, S.ShowDate) ELSE DATEPART(day,getdate()) end as SI_Freq_Start_DD -- need to discuss
,'S' SI_Freq_Hldy_Stat	
,case when ProcessWhen = 'E' then 'A' else 'B' end SI_exec_code
,isnull(convert(varchar,ExpiryDate,105),'12-31-2099') SI_end_date
,convert(varchar(10),CT.Today+1,105) Next_exec_date -- need to conform with bank
--,convert(varchar,dateadd(day , 30 , ShowDate),105) Next_exec_date
,DestAccount tgt_Acct
,'E' Balance_Ind
,'S' Excess_Short_Ind -- need to confirm (E/S)
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) Tgt_balance
,'Y' Auto_pstd_flg
,'Y' Carry_for_alwd_flg
,'N' Validate_Crncy_Hldy
,'Y' Del_tran_if_not_pstd
,RIGHT(SPACE(5)+CAST('3' AS VARCHAR(5)),5) Carry_forward_limit
,'B' SI_Class
,'C0'+M.ClientCode  as CIF_ID
,Description+'/'+RequestBy Remarks
,' ' Closure_remarks
,' ' Exec_chrg_code
,' ' Failure_chrg_code
,' ' Chrg_rate_code
,' ' Chrg_dr_acid
,case when AmountXfrValue='A' then 'F' else 'V' end Amount_Ind
,'N' Create_Memo_Pad_Entry
,c.CyDesc Crncy_Code
,RIGHT(SPACE(17)+CAST(Amount AS VARCHAR(17)),17) Fixed_Amount
,'D' Part_Tran_Type
,'E' Balance_Ind
,'E' Excess_Short_Indicator
,S.MainCode No_of_Account
,RIGHT(SPACE(17)+CAST(M.GoodBaln AS VARCHAR(17)),17) Acct_Bal -- need to check
,CAse when  AmountXfrValue = 'A' then RIGHT(SPACE(8)+CAST('100' AS VARCHAR(8)),8) else  RIGHT(SPACE(8)+CAST('0' AS VARCHAR(8)),8) end as Percentage
,CAse when  AmountXfrValue = 'A' then RIGHT(SPACE(17)+CAST('0.01' AS VARCHAR(17)),17) else  RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) end as Amount_multiple
,S.MainCode ADM_Account_No_Dr
,case when AmountXfrValue <>'A' then 'N' else ' 'end as  Round_off_Type
,CAse when  AmountXfrValue = 'A' then RIGHT(SPACE(17)+CAST('0.01' AS VARCHAR(17)),17) else  RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) end Round_off_Value
,'N' Collect_Chrg
,' ' Report_Code
,' ' Reference_No_cr
,' ' Tran_particular_cr
,' ' Tran_remarks_cr
,' ' Intent_Code_cr
,' ' DD_payable_bank_code
,' ' DD_payable_branch_code
,' ' Payee_name
,' ' Purchase_Acct_No
,' ' Purchase_Name
,' ' cr_adv_pymnt_flg
,'F' Amount_Indicator -- need to confirm
,'N' Create_Memo_Pad_Entry
,DestAccount ADM_Account_No_Cr
,' ' Round_off_Type
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) Round_off_Value
,'N' Collect_Charges
,' ' Report_Code
,S.ReferenceNo Reference_No_dr
,' ' Tran_particular_dr
,' ' Tran_remarks_dr
,' ' Intent_Code_dr
,' ' SI_priority
,' ' si_freq_cal_base
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) cr_ceiling_amt
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) cr_cumulative_amt
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) dr_ceiling_amt
,RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) dr_cumulative_amt
,' ' siFreqNdays
,' ' Script_File_Name
from StandingIns S
JOIN Master M ON M.MainCode = S.MainCode AND M.BranchCode = S.BranchCode --and S.DestAccount = M.MainCode
left join CurrencyTable c on c.CyCode = M.CyCode
 , ControlTable CT
where S.ShowFreq<>'9'
and M.IsBlocked not in ('C','o')
and len(M.MainCode) >= 8
and LEFT(M.ClientCode , 1) <>'_'
AND M.AcType In ('01','05','06','07','08','09','0A','0B','0C','0D','0E','0F','0G','0H','0I','0J','0K','0L',
 '0M','0N','0O','0P','0Q','0R','0S','0T','0U','0V','0W','0X','0Y','0Z','10','11','28','29','3C','3D','3G','3H','3I','3J','0V','3W','4H','4L')
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = M.MainCode and CustTypeCode = 'Z' and CustType NOT IN ('11','12')
) 
