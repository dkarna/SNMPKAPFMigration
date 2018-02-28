select 
m.MainCode foracid							,		
c.CyDesc acct_crncy_code                   ,
m.BranchCode sol_id                            ,
'1' nom_srl_num                       ,
case when m1.Name is not null then m1.Name
else C.Beneficiary end nom_name					,--If Beneficiary field contains name then Name. Else if Beneficiary field contains MainCode, then Name of the Master table corresponding to that MainCode.Rest NULL.
case when C.Address1 is null or C.Address1='' then 'MIGR'
else C.Address1 end nom_addr1                         ,	--need to discuss
case when C.Address2 is null or C.Address2='' then 'MIGR'
else C.Address2 end nom_addr2                         ,	--need to discuss
case when C.Address3 is null or C.Address3='' then 'MIGR'
else C.Address3 end nom_addr3                         ,	--need to discuss
'MIG' nom_reltn_code                    ,
'1' nom_reg_num                       ,
'MIGR' nom_city_code                     ,
'MIGR' nom_State_Code                        ,
case when ctbl.ISOCode='GB' then 'UK'
else ctbl.ISOCode 
end nom_Country_Code                      , -- from CountryTable, ISOCode
'44600' nom_PinZIP_Code                      ,  -- 44600
'F' minor_guard_code                  ,  -- From RC001
NULL nom_date_of_birth                 ,  -- Need to confirm
tminor.CUSTOMERMINOR minor_flg                         , -- From RC001
'100' nom_pcnt                       ,    -- 100
'N' last_nominee_flg                  ,  -- 'N'
'' pref_lang_code                    ,
'' pref_lang_nom_name                ,
'' Dummy                             , 
case when m1.MainCode in 
(select MainCode from AcCustType where CustTypeCode='Z' and CustType in ('11','12')) then 'R0'+ m1.ClientCode
when m1.MainCode in 
(select MainCode from AcCustType where CustTypeCode='Z' and CustType not in ('11','12')) then 'C0'+ m1.ClientCode 
else 'N0'+m1.ClientCode end CIF_id 		-- -- R0+MainCode
from ClientTable C left join Master m on C.ClientCode = m.ClientCode
left join Master m1 on C.Beneficiary = m1.MainCode
LEFT JOIN
(
	SELECT t1.ClientCode,
	CASE WHEN ((UPPER(t1.Name) LIKE UPPER('%MINOR%')) OR (t2.Gender='m') OR (t1.ClientCode IN (SELECT ClientCode FROM Master WHERE AcType IN('OM','OH','OI'))) OR t2.MaritalStatus='N') THEN 'Y' 
	ELSE 'N'
	END AS CUSTOMERMINOR
	FROM Master t1 LEFT JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode
) AS tminor ON m1.ClientCode = tminor.ClientCode
left join CurrencyTable c on c.CyCode = m.CyCode 
left join CountryTable ctbl on ctbl.CountryCode = C.CountryCode
where left(C.ClientCode,1)<>'_'
and C.Beneficiary is not null
and C.Beneficiary<>''