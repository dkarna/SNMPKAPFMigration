select
MainCode foracid					,
HeldAmt lien_amt                   ,		--need to discuss
case when CyCode = 01 then 'NPR'
when CyCode = 11 then 'INR'
when CyCode = 21 then 'USD'
when CyCode = 22 then 'GBP'
when CyCode = 23 then 'AUD'
when CyCode = 24 then 'CAD'
when CyCode = 25 then 'CHF'
when CyCode = 28 then 'SGD'
when CyCode = 30 then 'JPY'
when CyCode = 31 then 'SEK'
when CyCode = 35 then 'DKK'
when CyCode = 36 then 'HKD'
when CyCode = 37 then 'SAR'
when CyCode = 50 then 'AED'
when CyCode = 51 then 'PKR'
when CyCode = 52 then 'BDT'
when CyCode = 53 then 'LKR'
when CyCode = 54 then 'MVR'
when CyCode = 55 then 'BTN'
when CyCode = 56 then 'NOK'
when CyCode = 57 then 'KPW'
when CyCode = 58 then 'KRW'
when CyCode = 59 then 'RUB'
when CyCode = 60 then 'CNY'
when CyCode = 61 then 'ILS'
when CyCode = 62 then 'MYR'
when CyCode = 63 then 'THB' 
when CyCode = 64 then 'MMK'
when CyCode in ('26','27','29','32','33','34','38') then 'EUR'
else 'NPR'  end  alt_crncy_code             ,
'MIGRA' lien_reason_code           ,
AcOpenDate lien_start_date            ,
'31-12-2099' lien_expiry_date           ,
'ULIEN' b2k_type                   ,
'' b2k_id                     ,
'' si_cert_num                ,
'' limit_prefix               ,
'' limit_sufix                ,
'' dc_ref_num                 ,
'' bg_srl_num                 ,
BranchCode sol_id             ,
'' lien_remarks               ,
'' IPO_institution_name       ,
'' IPO_application_name
from Master
where left(ClientCode , 1)<>'_'
and IsBlocked NOT IN ('C','o')
and HeldAmt<>0 and left(HeldAmt,1)<>'-'




