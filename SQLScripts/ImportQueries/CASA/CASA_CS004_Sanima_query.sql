select 
m.MainCode foracid							,		
c.CyDesc acct_crncy_code                   ,
m.BranchCode sol_id                            ,
'1' nom_srl_num                       ,
case when m1.Name is not null then m1.Name
else C.Beneficiary end nom_name					,--If Beneficiary field contains name then Name. Else if Beneficiary field contains MainCode, then Name of the Master table corresponding to that MainCode.Rest NULL.
'' nom_addr1                         ,	--need to discuss
'' nom_addr2                         ,	--need to discuss
'' nom_addr3                         ,	--need to discuss
'MIG' nom_reltn_code                    ,
'1' nom_reg_num                       ,
NULL nom_city_code                     ,
NULL nom_State_Code                        ,
NULL nom_Country_Code                      ,
NULL nom_PinZIP_Code                      ,
NULL minor_guard_code                  ,
NULL nom_date_of_birth                 ,
NULL minor_flg                         ,
NULL nom_pcnt                       ,   
NULL last_nominee_flg                  ,
'' pref_lang_code                    ,
'' pref_lang_nom_name                ,
'' Dummy                             ,
'' CIF_ID
from ClientTable C left join Master m on C.ClientCode = m.ClientCode
left join Master m1 on C.Beneficiary = m1.MainCode
left join CurrencyTable c on c.CyCode = m.CyCode 
where left(C.ClientCode,1)<>'_'
and C.Beneficiary is not null
and C.Beneficiary<>''

