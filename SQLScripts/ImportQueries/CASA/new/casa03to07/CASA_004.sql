
SELECT
 M.MainCode AS foracid
,Cur.CyDesc AS acct_crncy_code
,M.BranchCode AS sol_id
,1 AS nom_srl_num
,ISNULL(M.Beneficiary,'MIGR') AS nom_name
,C.Address1 AS nom_addr1
,C.Address2 AS nom_addr2
,C.Address3 AS nom_addr3
,'MIGR' AS nom_reltn_code
,'1' AS nom_reg_num
,'MIGR' AS nom_city_code
,'MIGR' AS State_Code
,ISNULL(Cnt.ISOCode,'NP') AS Country_Code
,'44600' AS ZIP_Code
,'F' AS minor_guard_code
,CASE WHEN C.DateOfBirth > GETDATE() 
	THEN dbo.f_GetRomanDate(DATEPART(day,C.DateOfBirth),DATEPART(month, C.DateOfBirth), DATEPART(year,C.DateOfBirth))
 WHEN C.DateOfBirth IS NOT NULL THEN CONVERT(VARCHAR(10), C.DateOfBirth, 105) 
 else '01-01-1985'
 END  AS nom_date_of_birth
,'' AS minor_flg
,'100' AS nom_pcnt
,'N' AS last_nominee_flg
,'' AS pref_lang_code
,C.Beneficiary AS pref_lang_nom_name
,'' AS Dummy
,M.ClientCode AS CIF_ID
FROM Master M
LEFT JOIN CurrencyTable Cur ON Cur.CyCode = M.CyCode
LEFT JOIN ClientTable C ON M.ClientCode =  C.ClientCode
LEFT JOIN CountryTable Cnt ON C.CountryCode = Cnt.CountryCode
LEFT JOIN AcCustType ACT ON ACT.MainCode = M.MainCode AND ACT.BranchCode = M.BranchCode
WHERE LEFT(C.ClientCode , 1) <>'_'
AND IsBlocked NOT IN ('C','o')
AND ACT.CustTypeCode = 'Z'
AND C.ClientStatus <> 'Z'
