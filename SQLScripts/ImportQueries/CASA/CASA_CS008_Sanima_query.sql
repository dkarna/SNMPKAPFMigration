select 
c.MainCode foracid				,
c.ChequeNo begin_chq_num         ,
case when s.MainCode is not null then s.ChequeDate
else c.CreateOn end acpt_date             ,
c.CreateOn chq_date              ,
'' chq_amt               ,
'' payee_name            ,
'1' num_of_lvs            ,
'' chq_alpha             ,
NULL sp_reason_code        ,
'' acct_bal              ,
cm.CyDesc acct_crncy_code 
from ChequeInven c
left join StopCheque s on c.MainCode = s.MainCode and c.BranchCode = s.BranchCode and c.ChequeNo = s.ChequeNo
left join (select MainCode , BranchCode, IsBlocked,CyDesc from Master M , CurrencyTable C where M.CyCode = C.CyCode) cm on cm.MainCode =  c.MainCode and cm.BranchCode = c.BranchCode
where IsBlocked NOT IN ('C','o')
and c.CheqStatus = 'S'

