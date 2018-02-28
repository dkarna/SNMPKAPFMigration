select 
'BAL' indicator					,
m.MainCode foracid                  ,
RIGHT(SPACE(17)+CAST(m.GoodBaln AS VARCHAR(17)),17) tran_amt                 ,
convert(varchar(10),ct.Today,105) tran_date                , --MigrationDate(Finacle Appliation/BOD Date)
c.CyDesc tran_crncy_code          ,
m.BranchCode sol_id                   ,
'' dummy
from Master m left join CurrencyTable c on m.CyCode = c.CyCode,
ControlTable ct
where left(ClientCode,1)<>'_' 