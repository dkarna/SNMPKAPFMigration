select 
MainCode foracid							,
c.CyDesc crncy_code                         ,
BranchCode sol_id                             ,
IntCrAmt nrml_accrued_amount_cr             ,
NULL interest_calc_upto_date_cr         ,  	--need to discuss
'' accrued_upto_date_cr               , --Finacle Application/BOD Date-1 day
'' booked_upto_date_cr                , --Finacle Application/BOD Date-1 day
IntDrAmt nrml_accrued_amount_dr             ,
NULL interest_calc_upto_date_dr         , 	--need to discuss
'' accrued_upto_date_dr               , --Finacle Application/BOD Date-1 day
'' booked_upto_date_dr                , --Finacle Application/BOD Date-1 day
'' dummy                              ,
NULL CS006_013                          ,
NULL CS006_014
from Master m left join CurrencyTable c on c.CyCode = m.CyCode
where left(ClientCode , 1)<>'_'