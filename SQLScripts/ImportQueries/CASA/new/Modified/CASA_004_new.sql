-- CS004

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
	THEN convert(varchar(10),dbo.f_GetRomanDate(DATEPART(day,C.DateOfBirth),DATEPART(month, C.DateOfBirth), DATEPART(year,C.DateOfBirth)),105)
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
AND C.ClientStatus <> 'Z'
AND LEN(M.ClientCode) >= 8
AND M.AcType In ('01','05','06','07','08','09','0A','0B','0C','0D','0E','0F','0G','0H','0I','0J','0K','0L',
 '0M','0N','0O','0P','0Q','0R','0S','0T','0U','0V','0W','0X','0Y','0Z','10','11','28','29','3C','3D','3G','3H','3I','3J','0V','3W','4H','4L')
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = M.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
) 

UNION

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
	THEN convert(varchar(10),dbo.f_GetRomanDate(DATEPART(day,C.DateOfBirth),DATEPART(month, C.DateOfBirth), DATEPART(year,C.DateOfBirth)),105)
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
AND C.ClientStatus <> 'Z'
AND LEN(M.ClientCode) >= 8
AND M.AcType In ('01','05','06','07','08','09','0A','0B','0C','0D','0E','0F','0G','0H','0I','0J','0K','0L',
 '0M','0N','0O','0P','0Q','0R','0S','0T','0U','0V','0W','0X','0Y','0Z','10','11','28','29','3C','3D','3G','3H','3I','3J','0V','3W','4H','4L')
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = M.MainCode and CustTypeCode = 'Z' and CustType NOT IN ('11','12')
)