select 
'CBS' indicator				,
C.MainCode foracid                ,
c.CyDesc acct_crncy_code        ,    
ChequeNo begin_chq_num          ,
'1' chq_num_of_lvs         ,
CreateOn chq_issu_date          ,     --there is no field provided in mapping sheet
case when CheqStatus = 'I' then 'P'
when CheqStatus = 'Z' then 'I'
when CheqStatus = 'S' then 'S'
when CheqStatus = 'D' then 'D'
when CheqStatus = 'R' then 'D'
when CheqStatus = 'C' then 'D'
when CheqStatus = 'V' then 'U'
end chq_lvs_stat           ,
' ' begin_chq_alpha        ,
' ' dummy
from ChequeInven C left join Master M on C.MainCode = M.MainCode
left join CurrencyTable c on c.CyCode = M.CyCode
where left(ClientCode,1)<>'_'		-- need to filter or not
and IsBlocked NOT IN ('C','o')



