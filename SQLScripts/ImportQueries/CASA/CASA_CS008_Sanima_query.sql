select 
c.MainCode foracid				,
c.ChequeNo begin_chq_num         ,
case when s.MainCode is not null then convert(varchar(10),s.ChequeDate,105)
else convert(varchar(10),c.CreateOn,105) end acpt_date             ,
convert(varchar(10),c.CreateOn,105) chq_date              ,
RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) chq_amt               ,
'' payee_name            ,
RIGHT(SPACE(3)+CAST('1' AS VARCHAR(3)),3) num_of_lvs            ,
'' chq_alpha             ,
NULL sp_reason_code        ,
RIGHT(SPACE(17)+CAST('0' AS VARCHAR(17)),17) acct_bal              ,
cm.CyDesc acct_crncy_code 
from ChequeInven c
left join StopCheque s on c.MainCode = s.MainCode and c.BranchCode = s.BranchCode and c.ChequeNo = s.ChequeNo
left join (select MainCode , BranchCode, IsBlocked,CyDesc from Master M , CurrencyTable C where M.CyCode = C.CyCode) cm on cm.MainCode =  c.MainCode and cm.BranchCode = c.BranchCode
where IsBlocked NOT IN ('C','o')
and c.CheqStatus = 'S'
order by 1