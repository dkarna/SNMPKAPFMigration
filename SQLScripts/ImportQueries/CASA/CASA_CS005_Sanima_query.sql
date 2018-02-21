select 
'BAL' indicator					,
MainCode foracid                  ,
GoodBaln tran_amt                 ,
NULL tran_date                , --MigrationDate(Finacle Appliation/BOD Date)
c.CyDesc tran_crncy_code          ,
BranchCode sol_id                   ,
'' dummy
from Master m left join CurrencyTable c on m.CyCode = c.CyCode
where left(ClientCode,1)<>'_'                   
