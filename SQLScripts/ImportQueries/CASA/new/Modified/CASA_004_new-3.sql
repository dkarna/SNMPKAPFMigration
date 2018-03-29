-- CS004 Query

IF OBJECT_ID('tempdb.dbo.#tempwtx_flg', 'U') IS NOT NULL
 DROP TABLE #tempwtx_flg;
select m.MainCode
--,count(*) as duplicacy
,case when m.AcType in ('01','03','04','05','06') then 'N'
     when m.AcType < '48' and m.TaxPercentOnInt='0' and m.IntPostFrqCr <> '9' and m.TaxPostFrq <> '9' then 'N'
	 when m.AcType < '48' and m.TaxPercentOnInt<> '0' and (m.IntPostFrqCr <> '9' or m.TaxPostFrq <> '9') and m.IntCrRate='0' then 'N'
     else 'W'
end as wtax_flg,
case when m.AcType in ('01','03','04','05','06') then 'A'
     when m.AcType < '48' and m.TaxPercentOnInt='0' and m.IntPostFrqCr <> '9' and m.TaxPostFrq <> '9' then 'N'
	 when m.AcType < '48' and m.TaxPercentOnInt<> '0' and (m.IntPostFrqCr <> '9' or m.TaxPostFrq <> '9') and m.IntCrRate='0' then 'N'
     else 'S'
end as wtax_level
into #tempwtx_flg
from Master m
where left(m.ClientCode,1)<>'_'
and AcType in ('06','3C','3D','3G','3H','3I','3J','0V','3W','4H','4L',
'01','05','07','08','09','0A','0B','0C','0D','0E','0F','0G','0H','0I','0J','0K','0L',
 '0M','0N','0O','0P','0Q','0R','0S','0T','0U','0V','0W','0X','0Y','0Z','10','11','28','29','12');

IF OBJECT_ID('tempdb.dbo.#tempAcCustType', 'U') IS NOT NULL
 DROP TABLE #tempAcCustType;
 SELECT DISTINCT fn.MainCode,fn.BranchCode,
 ab.CustType AS Bval,
  az.CustType AS Zval,
  ac.CustType AS Cval,
  ax.CustType AS Xval,
  ap.CustType AS Pval,
  af.CustType AS Fval,
  au.CustType AS Uval,
  aq.CustType AS Qval,
  ar.CustType AS Rval,
  ae.CustType AS eval,
  ad.CustType AS Dval
INTO #tempAcCustType
FROM AcCustType fn
LEFT JOIN AcCustType ab
  ON fn.MainCode = ab.MainCode
  AND fn.BranchCode = ab.BranchCode
  AND ab.CustTypeCode = 'B'
LEFT JOIN AcCustType az
  ON fn.MainCode = az.MainCode
  AND fn.BranchCode = az.BranchCode
  AND az.CustTypeCode = 'Z'
LEFT JOIN AcCustType ac
  ON fn.MainCode = ac.MainCode
  AND fn.BranchCode = ac.BranchCode
  AND ac.CustTypeCode = 'C'
LEFT JOIN AcCustType ax
  ON fn.MainCode = ax.MainCode
  AND fn.BranchCode = ax.BranchCode
  AND ax.CustTypeCode = 'X'
LEFT JOIN AcCustType ap
  ON fn.MainCode = ap.MainCode
  AND fn.BranchCode = ap.BranchCode
  AND ap.CustTypeCode = 'P'
  LEFT JOIN AcCustType af
  ON fn.MainCode = af.MainCode
  AND fn.BranchCode = af.BranchCode
  AND af.CustTypeCode = 'F'
  LEFT JOIN AcCustType au
  ON fn.MainCode = au.MainCode
  AND fn.BranchCode = au.BranchCode
  AND au.CustTypeCode = 'U'
  LEFT JOIN AcCustType aq
  ON fn.MainCode = aq.MainCode
  AND fn.BranchCode = aq.BranchCode
  AND aq.CustTypeCode = 'Q'
  LEFT JOIN AcCustType ar
  ON fn.MainCode = ar.MainCode
  AND fn.BranchCode = ar.BranchCode
  AND ar.CustTypeCode = 'R'
  LEFT JOIN AcCustType ae
  ON fn.MainCode = ae.MainCode
  AND fn.BranchCode = ae.BranchCode
  AND ae.CustTypeCode = 'e'
  LEFT JOIN AcCustType ad
  ON fn.MainCode = ad.MainCode
  AND fn.BranchCode = ad.BranchCode
  AND ad.CustTypeCode = 'D'
WHERE fn.CustTypeCode IN ('C','X','B','P','Z','F','U','Q','R','e','D') ORDER by 1,2

IF OBJECT_ID('tempdb.dbo.#FinalMaster', 'U') IS NOT NULL
  DROP TABLE #FinalMaster;
IF OBJECT_ID('tempdb.dbo.#FinalMaster', 'U') IS NOT NULL
  DROP TABLE #FinalMaster;
SELECT *
INTO #FinalMaster
FROM
	(
		SELECT DISTINCT
		 [Name]
		,ClientCode
		,AcType
		,BranchCode
		,Obligor
		,AcOpenDate
		,MainCode
		,CyCode
		,Limit
		,TaxPostFrq
		,TaxPercentOnInt
		,IntCrRate
		,IntDrRate
		,IntPostFrqCr
		,IsDormant
		,IsBlocked
		,LastTranDate
		,LimitExpiryDate
		,Beneficiary
		,ROW_NUMBER() OVER( PARTITION BY ClientCode ORDER BY AcOpenDate,MainCode) AS SerialNumber
		FROM Master WITH (NOLOCK)
		WHERE IsBlocked NOT IN ('C','o')
	) AS t 
WHERE t.SerialNumber = 1 ORDER BY 1;

IF OBJECT_ID('tempdb.dbo.#ClientName', 'U') IS NOT NULL
  DROP TABLE #ClientName;
IF OBJECT_ID('tempdb.dbo.#ClientName', 'U') IS NOT NULL
  DROP TABLE #ClientName;
  
SELECT ClientCode, CASE WHEN CHARINDEX('/',Name)  > 0 THEN SUBSTRING(Name,0,CHARINDEX('/',Name)) 
ELSE Name
END as Name,Name AS Orig_Name
INTO #ClientName
FROM ClientTable

IF OBJECT_ID('tempdb.dbo.#FinSchTbl', 'U') IS NOT NULL
  DROP TABLE #FinSchTbl;
  Select * INTO #FinSchTbl FROM 
  (
	select SCHM_CODE, IntTableCode from 
	FinacleCASAIntTableCode WHERE SCHM_CODE in
	(select FinacleSchCode from FinacleLoanTable where FinacleSchemeType like 'ODA')
  )AS fts;

SELECT * FROM
(
select --top 10
 t1.MainCode AS foracid
,cur.CyDesc AS acct_crncy_code
,t1.BranchCode AS sol_id
,'1' AS nom_srl_num
,ISNULL(t1.Beneficiary,'MIGR') AS nom_name
,case WHEN t2.Address1 IS NULL OR t2.Address1 ='' THEN 'MIGR' 
else ltrim(replace(t2.Address1,'''','')) end AS  nom_addr1
,case WHEN t2.Address2 IS NULL OR t2.Address2 ='' THEN 'MIGR' 
else ltrim(replace(t2.Address2,'"','')) end AS  nom_addr2
,case WHEN t2.Address3 IS NULL OR t2.Address3 ='' THEN 'MIGR' 
else ltrim(t2.Address3) end AS nom_addr3
,CASE WHEN tmaster.CUSTOMERMINOR = 'Y' THEN '08' 
ELSE '20' END AS nom_reltn_code
,'1' AS nom_reg_num
,'MIGR' AS nom_city_code
,'MIGR' AS State_Code
,ISNULL(Cnt.ISOCode,'NP') AS Country_Code
,'44600' AS ZIP_Code
,CASE WHEN tmaster.CUSTOMERMINOR = 'Y' THEN 'F' 
ELSE '' END AS minor_guard_code
--,CASE WHEN tmaster.CUSTOMERMINOR = 'Y' THEN CASE WHEN t2.DateOfBirth > GETDATE() 
--THEN convert(varchar(10),dbo.f_GetRomanDate(DATEPART(day,t2.DateOfBirth),DATEPART(month, t2.DateOfBirth), DATEPART(year,t2.DateOfBirth)),105)
-- WHEN t2.DateOfBirth IS NOT NULL THEN CONVERT(VARCHAR(10), t2.DateOfBirth, 105)  
-- else '01-01-1985' END ELSE '' END AS nom_date_of_birth
,CASE WHEN tmaster.CUSTOMERMINOR = 'Y' THEN CASE WHEN ctrlt.Today <= t2.DateOfBirth AND t1.AcType='0B' THEN REPLACE(REPLACE(CONVERT(VARCHAR,dbo.f_GetRomanDate(DatePart(Day,t2.DateOfBirth),DatePart(MONTH,t2.DateOfBirth),DatePart(YEAR,t2.DateOfBirth)),105), ' ','-'), ',','')
      WHEN t2.DateOfBirth > ctrlt.Today THEN REPLACE(REPLACE(CONVERT(VARCHAR,dbo.f_GetRomanDate(DatePart(Day,t2.DateOfBirth),DatePart(MONTH,t2.DateOfBirth),DatePart(YEAR,t2.DateOfBirth)),105), ' ','-'), ',','')
     WHEN t2.DateOfBirth IS NULL OR t2.DateOfBirth = '' THEN '01-01-1985'
	--WHEN C.DateOfBirth >= ctrlt.Today THEN REPLACE(REPLACE(CONVERT(VARCHAR,'01-Jan-1985',106), ' ','-'), ',','')
     ELSE REPLACE(REPLACE(CONVERT(VARCHAR,t2.DateOfBirth,105), ' ','-'), ',','') END 
	ELSE '' END AS nom_date_of_birth
,CASE WHEN tmaster.CUSTOMERMINOR = 'Y' THEN 'Y' 
ELSE 'N' END AS minor_flg
,'100' AS nom_pcnt
,'Y' AS last_nominee_flg
,'' AS pref_lang_code
,t1.Beneficiary AS pref_lang_nom_name
,'' AS Dummy
,'R0' + t1.ClientCode AS CIF_ID
FROM #FinalMaster t1
--Master t1
left join #tempwtx_flg wtemp on wtemp.MainCode =t1.MainCode
JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode
left join #tempAcCustType tACT on tACT.MainCode = t1.MainCode and tACT.BranchCode = t1.BranchCode
LEFT JOIN FinacleEmployeeTable fet on fet.ClientCode = t2.ClientCode
join FinacleSchemeTable fst on fst.PumoriAcType=t1.AcType and fst.PumoriCyCode=t1.CyCode
left join FinacleLoanTable flt on flt.PumoriMainCode=t1.MainCode and flt.PumoriAcType=t1.AcType and flt.PumoriCyCode=t1.CyCode
LEFT JOIN FinacleCASAIntTableCode FIT ON FIT.SCHM_CODE = fst.FinacleSchCode 
left join #FinSchTbl fts ON fts.SCHM_CODE = flt.FinacleSchCode
LEFT JOIN
(
	select MainCode,CustType,BranchCode from AcCustType where CustTypeCode = 'Z'
) as accust on accust.MainCode = t1.MainCode and accust.BranchCode = t1.BranchCode
LEFT JOIN
(
	SELECT ReferenceNo as MainCode, BranchCode, MIN(DueDate) as DueDate
	FROM PastDuedList
	GROUP BY ReferenceNo, BranchCode
) PDL ON PDL.MainCode = t1.MainCode  AND PDL.BranchCode=t1.BranchCode
left join ParaTable pt on pt.BranchCode=t1.BranchCode and pt.AcType = t1.AcType and pt.CyCode = t1.CyCode
left join CurrencyTable cur on cur.CyCode=t1.CyCode
LEFT JOIN CountryTable Cnt ON t2.CountryCode = Cnt.CountryCode
JOIN 
(							-- Filters the clientcode with minimum account open date
	SELECT t1.ClientCode,MIN(t1.AcOpenDate) AS mindate, 
	CASE WHEN ((UPPER(t1.Name) LIKE UPPER('%MINOR%')) OR (t2.Gender='m') OR (t1.ClientCode IN (SELECT ClientCode FROM Master WHERE AcType IN('OM','OH','OI'))) OR t2.MaritalStatus='N') THEN 'Y' 
	ELSE 'N'
	END AS CUSTOMERMINOR
	FROM Master t1 LEFT JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode GROUP BY t1.ClientCode, t1.Name, t2.Gender, t2.MaritalStatus
) AS tmaster ON tmaster.ClientCode = t1.ClientCode AND tmaster.mindate = t1.AcOpenDate
LEFT JOIN SanimaDueList SDL ON SDL.MainCode = t1.MainCode AND SDL.BranchCode = t1.BranchCode
,ControlTable ctrlt
WHERE LEFT(t2.ClientCode,1) <> '_'
and len(t1.ClientCode) >= 8
and t1.AcType in ('06','3C','3D','3G','3H','3I','3J','0V','3W','4H','4L')
AND t1.Limit > 0
and t1.IsBlocked not in ('C','o') 
and t1.ClientCode not in ('00330078','00315338','00312554','00000436', '00010136', '00000440', '00283013')
and t1.BranchCode between '001' and  '040'
--and t1.GoodBaln <> 0
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = t1.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
) 
--ORDER BY 1

UNION
 
SELECT DISTINCT --top 10
 t1.MainCode AS foracid
,cur.CyDesc AS acct_crncy_code
,t1.BranchCode AS sol_id
,'1' AS nom_srl_num
,ISNULL(t1.Beneficiary,'MIGR') AS nom_name
,case WHEN t2.Address1 IS NULL OR t2.Address1 ='' THEN 'MIGR' 
else ltrim(replace(t2.Address1,'''','')) end AS  nom_addr1
,case WHEN t2.Address2 IS NULL OR t2.Address2 ='' THEN 'MIGR' 
else ltrim(replace(t2.Address2,'"','')) end AS  nom_addr2
,case WHEN t2.Address3 IS NULL OR t2.Address3 ='' THEN 'MIGR' 
else ltrim(t2.Address3) end AS nom_addr3
,CASE WHEN tmaster.CUSTOMERMINOR = 'Y' THEN '08' 
ELSE '20' END  AS nom_reltn_code
,'1' AS nom_reg_num
,'MIGR' AS nom_city_code
,'MIGR' AS State_Code
,ISNULL(Cnt.ISOCode,'NP') AS Country_Code
,'44600' AS ZIP_Code
----,CASE WHEN tmaster.CUSTOMERMINOR = 'Y' THEN 'F' 
----ELSE '' END AS minor_guard_code
----, CASE WHEN ctrlt.Today <= t2.DateOfBirth AND t1.AcType='0B' THEN REPLACE(REPLACE(CONVERT(VARCHAR,dbo.f_GetRomanDate(DatePart(Day,t2.DateOfBirth),DatePart(MONTH,t2.DateOfBirth),DatePart(YEAR,t2.DateOfBirth)),105), ' ','-'), ',','')
----      WHEN t2.DateOfBirth > ctrlt.Today THEN REPLACE(REPLACE(CONVERT(VARCHAR,dbo.f_GetRomanDate(DatePart(Day,t2.DateOfBirth),DatePart(MONTH,t2.DateOfBirth),DatePart(YEAR,t2.DateOfBirth)),105), ' ','-'), ',','')
----     WHEN t2.DateOfBirth IS NULL OR t2.DateOfBirth = '' THEN REPLACE(REPLACE(CONVERT(VARCHAR,'01-01-1985',105), ' ','-'), ',','')
----	--WHEN C.DateOfBirth >= ctrlt.Today THEN REPLACE(REPLACE(CONVERT(VARCHAR,'01-Jan-1985',106), ' ','-'), ',','')
----     ELSE REPLACE(REPLACE(CONVERT(VARCHAR,t2.DateOfBirth,105), ' ','-'), ',','') END AS nom_date_of_birth
,'' AS minor_guard_code
,'' AS nom_date_of_birth
,'N' AS minor_flg
,'100' AS nom_pcnt
,'Y' AS last_nominee_flg
,'' AS pref_lang_code
,t1.Beneficiary AS pref_lang_nom_name
,'' AS Dummy
,'C' + t1.ClientCode AS CIF_ID
FROM #FinalMaster t1
left JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode
left join #tempAcCustType tACT on tACT.MainCode = t1.MainCode and tACT.BranchCode = t1.BranchCode
LEFT JOIN FinacleEmployeeTable fet on fet.ClientCode = t2.ClientCode
left join FinacleSchemeTable fst on fst.PumoriAcType=t1.AcType and fst.PumoriCyCode=t1.CyCode
left join FinacleLoanTable flt on flt.PumoriMainCode=t1.MainCode and flt.PumoriAcType=t1.AcType and flt.PumoriCyCode=t1.CyCode
LEFT JOIN FinacleCASAIntTableCode FIT ON FIT.SCHM_CODE = fst.FinacleSchCode 
left join #FinSchTbl fts ON fts.SCHM_CODE = flt.FinacleSchCode
LEFT JOIN
(
	select MainCode,CustType,BranchCode from AcCustType where CustTypeCode = 'Z'
) as accust on accust.MainCode = t1.MainCode and accust.BranchCode = t1.BranchCode
LEFT JOIN
(
	SELECT ReferenceNo as MainCode, BranchCode, MIN(DueDate) as DueDate
	FROM PastDuedList
	GROUP BY ReferenceNo, BranchCode
) PDL ON PDL.MainCode = t1.MainCode  AND PDL.BranchCode=t1.BranchCode
left join ParaTable pt on pt.BranchCode=t1.BranchCode and pt.AcType = t1.AcType and pt.CyCode = t1.CyCode
left join CurrencyTable cur on cur.CyCode=t1.CyCode
LEFT JOIN CountryTable Cnt ON t2.CountryCode = Cnt.CountryCode
JOIN 
(							-- Filters the clientcode with minimum account open date
	SELECT t1.ClientCode,MIN(t1.AcOpenDate) AS mindate, 
	CASE WHEN ((UPPER(t1.Name) LIKE UPPER('%MINOR%')) OR (t2.Gender='m') OR (t1.ClientCode IN (SELECT ClientCode FROM Master WHERE AcType IN('OM','OH','OI'))) OR t2.MaritalStatus='N') THEN 'Y' 
	ELSE 'N'
	END AS CUSTOMERMINOR
	FROM Master t1 LEFT JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode GROUP BY t1.ClientCode, t1.Name, t2.Gender,t2.MaritalStatus
) AS tmaster ON tmaster.ClientCode = t1.ClientCode AND tmaster.mindate = t1.AcOpenDate
LEFT JOIN SanimaDueList SDL ON SDL.MainCode = t1.MainCode AND SDL.BranchCode = t1.BranchCode
,ControlTable ctrlt
WHERE LEFT(t2.ClientCode,1) <> '_'
and len(t1.ClientCode) >= 8
and t1.AcType in ('06','3C','3D','3G','3H','3I','3J','0V','3W','4H','4L')
AND t1.Limit > 0
and t1.IsBlocked not in ('C','o') 
and t1.ClientCode not in ('00330078','00315338','00312554','00000436', '00010136', '00000440', '00283013')
and t1.BranchCode between '001' and  '040'
--and t1.GoodBaln <> 0
and EXISTS 
(
	SELECT 1 FROM AcCustType WHERE MainCode = t1.MainCode and CustTypeCode = 'Z' and CustType NOT IN ('11','12')
)
) as t --where t.GL_Sub_Head_code is not null order by 1

UNION 

select --top 2
 t1.MainCode AS foracid
,cur.CyDesc AS acct_crncy_code
,t1.BranchCode AS sol_id
,'1' AS nom_srl_num
,ISNULL(t1.Beneficiary,'MIGR') AS nom_name
,case WHEN t2.Address1 IS NULL OR t2.Address1 ='' THEN 'MIGR' 
else ltrim(replace(t2.Address1,'''','')) end AS  nom_addr1
,case WHEN t2.Address2 IS NULL OR t2.Address2 ='' THEN 'MIGR' 
else ltrim(replace(t2.Address2,'"','')) end AS  nom_addr2
,case WHEN t2.Address3 IS NULL OR t2.Address3 ='' THEN 'MIGR' 
else ltrim(t2.Address3) end AS nom_addr3
,CASE WHEN tmaster.CUSTOMERMINOR = 'Y' THEN '08' 
ELSE '20' END  AS nom_reltn_code
,'1' AS nom_reg_num
,'MIGR' AS nom_city_code
,'MIGR' AS State_Code
,ISNULL(Cnt.ISOCode,'NP') AS Country_Code
,'44600' AS ZIP_Code
,CASE WHEN tmaster.CUSTOMERMINOR = 'Y' THEN 'F' 
ELSE '' END AS minor_guard_code
--,CASE WHEN tmaster.CUSTOMERMINOR = 'Y' THEN CASE WHEN t2.DateOfBirth > GETDATE() 
--THEN convert(varchar(10),dbo.f_GetRomanDate(DATEPART(day,t2.DateOfBirth),DATEPART(month, t2.DateOfBirth), DATEPART(year,t2.DateOfBirth)),105)
-- WHEN t2.DateOfBirth IS NOT NULL THEN CONVERT(VARCHAR(10), t2.DateOfBirth, 105)  
-- else '01-01-1985' END ELSE '' END AS nom_date_of_birth
,CASE WHEN tmaster.CUSTOMERMINOR = 'Y' THEN CASE WHEN ctrlt.Today <= t2.DateOfBirth AND t1.AcType='0B' THEN REPLACE(REPLACE(CONVERT(VARCHAR,dbo.f_GetRomanDate(DatePart(Day,t2.DateOfBirth),DatePart(MONTH,t2.DateOfBirth),DatePart(YEAR,t2.DateOfBirth)),105), ' ','-'), ',','')
      WHEN t2.DateOfBirth > ctrlt.Today THEN REPLACE(REPLACE(CONVERT(VARCHAR,dbo.f_GetRomanDate(DatePart(Day,t2.DateOfBirth),DatePart(MONTH,t2.DateOfBirth),DatePart(YEAR,t2.DateOfBirth)),105), ' ','-'), ',','')
     WHEN t2.DateOfBirth IS NULL OR t2.DateOfBirth = '' THEN '01-01-1985'
	--WHEN C.DateOfBirth >= ctrlt.Today THEN REPLACE(REPLACE(CONVERT(VARCHAR,'01-Jan-1985',106), ' ','-'), ',','')
     ELSE REPLACE(REPLACE(CONVERT(VARCHAR,t2.DateOfBirth,105), ' ','-'), ',','') END 
	 ELSE '' END AS nom_date_of_birth
,CASE WHEN tmaster.CUSTOMERMINOR = 'Y' THEN 'Y' 
ELSE 'N' END AS minor_flg
,'100' AS nom_pcnt
,'Y' AS last_nominee_flg
,'' AS pref_lang_code
,t1.Beneficiary AS pref_lang_nom_name
,'' AS Dummy
,'R0' + t1.ClientCode AS CIF_ID
FROM #FinalMaster t1
left join #tempwtx_flg wtemp on wtemp.MainCode =t1.MainCode
left JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode
left JOIN FinacleEmployeeTable fet on fet.ClientCode = t2.ClientCode
join FinacleSchemeTable fst on fst.PumoriAcType=t1.AcType and fst.PumoriCyCode=t1.CyCode
LEFT JOIN
(
	select MainCode,CustType,BranchCode from AcCustType where CustTypeCode = 'Z'
) as accust on accust.MainCode = t1.MainCode and accust.BranchCode = t1.BranchCode
left join ParaTable pt on pt.BranchCode=t1.BranchCode and pt.AcType = t1.AcType and pt.CyCode = t1.CyCode
left join CurrencyTable cur on cur.CyCode=t1.CyCode
LEFT JOIN CountryTable Cnt ON t2.CountryCode = Cnt.CountryCode
JOIN 
(							-- Filters the clientcode with minimum account open date
	SELECT t1.ClientCode,MIN(t1.AcOpenDate) AS mindate, 
	CASE WHEN ((UPPER(t1.Name) LIKE UPPER('%MINOR%')) OR (t2.Gender='m') OR (t1.ClientCode IN (SELECT ClientCode FROM Master WHERE AcType IN('OM','OH','OI'))) OR t2.MaritalStatus='N') THEN 'Y' 
	ELSE 'N'
	END AS CUSTOMERMINOR
	FROM Master t1 LEFT JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode GROUP BY t1.ClientCode, t1.Name, t2.Gender,t2.MaritalStatus
) AS tmaster ON tmaster.ClientCode = t1.ClientCode AND tmaster.mindate = t1.AcOpenDate
,ControlTable ctrlt
WHERE LEFT(t2.ClientCode,1) <> '_'
--and fst.FinacleSchCode like 'SBSTF'
and t1.Limit <= 0
and len(t1.ClientCode) >= 8
and t1.AcType In ('01','05','07','08','09','0A','0B','0C','0D','0E','0F','0G','0H','0I','0J','0K','0L',
 '0M','0N','0O','0P','0Q','0R','0S','0T','0U','0V','0W','0X','0Y','0Z','10','11','28','29','12')
and t2.ClientCode not in ('00283013','00330078','00315338','00312554','00000440','00010136','00000436')
and t1.BranchCode between '001' and '040'
--and t1.GoodBaln <> 0
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = t1.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
) 
--ORDER BY 1

UNION
 
SELECT DISTINCT --top 2
 t1.MainCode AS foracid
,cur.CyDesc AS acct_crncy_code
,t1.BranchCode AS sol_id
,'1' AS nom_srl_num
,ISNULL(t1.Beneficiary,'MIGR') AS nom_name
,case WHEN t2.Address1 IS NULL OR t2.Address1 ='' THEN 'MIGR' 
else ltrim(replace(t2.Address1,'''','')) end AS  nom_addr1
,case WHEN t2.Address2 IS NULL OR t2.Address2 ='' THEN 'MIGR' 
else ltrim(replace(t2.Address2,'"','')) end AS  nom_addr2
,case WHEN t2.Address3 IS NULL OR t2.Address3 ='' THEN 'MIGR' 
else ltrim(t2.Address3) end AS nom_addr3
,CASE WHEN tmaster.CUSTOMERMINOR = 'Y' THEN '08' 
ELSE '20' END AS nom_reltn_code
,'1' AS nom_reg_num
,'MIGR' AS nom_city_code
,'MIGR' AS State_Code
,ISNULL(Cnt.ISOCode,'NP') AS Country_Code
,'44600' AS ZIP_Code
--,CASE WHEN tmaster.CUSTOMERMINOR = 'Y' THEN 'F' 
--ELSE '' END AS minor_guard_code
--, CASE WHEN ctrlt.Today <= t2.DateOfBirth AND t1.AcType='0B' THEN REPLACE(REPLACE(CONVERT(VARCHAR,dbo.f_GetRomanDate(DatePart(Day,t2.DateOfBirth),DatePart(MONTH,t2.DateOfBirth),DatePart(YEAR,t2.DateOfBirth)),105), ' ','-'), ',','')
--      WHEN t2.DateOfBirth > ctrlt.Today THEN REPLACE(REPLACE(CONVERT(VARCHAR,dbo.f_GetRomanDate(DatePart(Day,t2.DateOfBirth),DatePart(MONTH,t2.DateOfBirth),DatePart(YEAR,t2.DateOfBirth)),105), ' ','-'), ',','')
--     WHEN t2.DateOfBirth IS NULL OR t2.DateOfBirth = '' THEN REPLACE(REPLACE(CONVERT(VARCHAR,'01-01-1985',105), ' ','-'), ',','')
--	--WHEN C.DateOfBirth >= ctrlt.Today THEN REPLACE(REPLACE(CONVERT(VARCHAR,'01-Jan-1985',106), ' ','-'), ',','')
--     ELSE REPLACE(REPLACE(CONVERT(VARCHAR,t2.DateOfBirth,105), ' ','-'), ',','') END AS nom_date_of_birth
,'' AS minor_guard_code
,'' AS nom_date_of_birth
,'N' AS minor_flg
,'100' AS nom_pcnt
,'Y' AS last_nominee_flg
,'' AS pref_lang_code
,t1.Beneficiary AS pref_lang_nom_name
,'' AS Dummy
,'C' + t1.ClientCode AS CIF_ID
FROM #FinalMaster t1
left join #tempwtx_flg wtemp on wtemp.MainCode =t1.MainCode
left JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode
left JOIN FinacleEmployeeTable fet on fet.ClientCode = t2.ClientCode
join FinacleSchemeTable fst on fst.PumoriAcType=t1.AcType and fst.PumoriCyCode=t1.CyCode
LEFT JOIN
(
	select MainCode,CustType,BranchCode from AcCustType where CustTypeCode = 'Z'
) as accust on accust.MainCode = t1.MainCode and accust.BranchCode = t1.BranchCode
left join ParaTable pt on pt.BranchCode=t1.BranchCode and pt.AcType = t1.AcType and pt.CyCode = t1.CyCode
LEFT JOIN CurrencyTable cur ON t1.CyCode = cur.CyCode
LEFT JOIN 
(	-- Take the unique name on the basis of max sequence number
	select MainCode,Name from ImageTable where SeqNo  in(
	select max(SeqNo) as seq from ImageTable group by MainCode)
) as t3 ON t1.MainCode = t3.MainCode  -- need to be checked with bank data putting inner join
LEFT JOIN CountryTable Cnt ON t2.CountryCode = Cnt.CountryCode
JOIN 
(							-- Filters the clientcode with minimum account open date
	SELECT t1.ClientCode,MIN(t1.AcOpenDate) AS mindate, 
	CASE WHEN ((UPPER(t1.Name) LIKE UPPER('%MINOR%')) OR (t2.Gender='m') OR (t1.ClientCode IN (SELECT ClientCode FROM Master WHERE AcType IN('OM','OH','OI'))) OR t2.MaritalStatus='N') THEN 'Y' 
	ELSE 'N'
	END AS CUSTOMERMINOR
	FROM Master t1 LEFT JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode GROUP BY t1.ClientCode, t1.Name, t2.Gender,t2.MaritalStatus
) AS tmaster ON tmaster.ClientCode = t1.ClientCode AND tmaster.mindate = t1.AcOpenDate
,ControlTable ctrlt
WHERE 
t1.AcType In  ('01','05','07','08','09','0A','0B','0C','0D','0E','0F','0G','0H','0I','0J','0K','0L',
 '0M','0N','0O','0P','0Q','0R','0S','0T','0U','0V','0W','0X','0Y','0Z','10','11','28','29','12')
and t2.ClientCode not in ('00283013','00330078','00315338','00312554','00000440','00010136','00000436')
and t1.BranchCode between '001' and '040'
--and t1.GoodBaln <> 0
and t1.Limit !> 0
and EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = t1.MainCode and CustTypeCode = 'Z' and CustType NOT IN ('11','12')
)
ORDER BY 1
--ORDER BY fet.EmpId