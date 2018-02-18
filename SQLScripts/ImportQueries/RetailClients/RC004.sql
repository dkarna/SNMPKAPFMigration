-- Query for RC004

 

IF OBJECT_ID('tempdb.dbo.#FinalMaster', 'U') IS NOT NULL
  DROP TABLE #FinalMaster;                                                        -- Drop temporary table if it exists

SELECT * INTO #FinalMaster FROM
(
       SELECT DISTINCT
        Name 
       ,ClientCode
       ,AcType
       ,BranchCode
       ,Obligor
       ,AcOpenDate
       ,MainCode
       ,CyCode
       ,IsBlocked
       ,ROW_NUMBER() OVER( PARTITION BY ClientCode ORDER BY AcOpenDate,MainCode) AS SerialNumber
       --INTO #FinalMaster
       FROM Master WITH (NOLOCK)
       WHERE IsBlocked NOT IN ('C','o')  -- Filters the closed or invalid or unapproved accounts
       --ORDER BY ClientCode
) AS t
WHERE t.SerialNumber = 1 ORDER BY 1;    

IF OBJECT_ID('tempdb.dbo.#ClientName', 'U') IS NOT NULL
  DROP TABLE #ClientName;
SELECT ClientCode, CASE WHEN CHARINDEX('/',Name)  > 0 THEN SUBSTRING(Name,0,CHARINDEX('/',Name)) 
ELSE Name
END as Name,Name AS Orig_Name,
Gender,Salutation
INTO #ClientName
FROM ClientTable

 
SELECT DISTINCT
'R0' + t1.ClientCode AS ORGKEY
,CASE WHEN tminor.CUSTOMERMINOR <> '' THEN 'Customer'
	ELSE '' 
 END AS CHILDENTITY
,tminor.CUSTOMERMINOR AS CHILDENTITYID
,CASE WHEN tminor.CUSTOMERMINOR <> '' THEN 'Father'
   ELSE ''
 END AS RELATIONSHIP
,CASE WHEN tminor.CUSTOMERMINOR <> '' THEN t2.Salutation
   ELSE ''
 END AS TITLE
,'' AS FIRSTNAME
,'' AS MIDDLENAME
,CASE WHEN isnull(reverse(SUBSTRING(reverse(ltrim(rtrim(t2.Name))),0,charindex(' ',reverse(ltrim(rtrim(t2.Name)))))),'.') = '' THEN '.'
 ELSE isnull(reverse(SUBSTRING(reverse(ltrim(rtrim(t2.Name))),0,charindex(' ',reverse(ltrim(rtrim(t2.Name)))))),'.')
 END AS LASTNAME
,'' AS DOB
,CASE WHEN t2.Gender = 'M' OR t2.Gender = 'm' THEN 'MALE'
   WHEN t2.Gender = 'F' THEN 'FEMALE'
 END AS GENDER
,'' AS ISDEPENDANT
,CASE WHEN tminor.CUSTOMERMINOR <> '' THEN 'F'
 ELSE '' 
 END AS GAURDIANTYPE
,'' AS ISPRIMARY
,'' AS HOUSE_NO
,'' AS PREMISE_NAME
,'' AS BUILDING_LEVEL
,'' AS STREET_NO
,'' AS STREET_NAME
,'' AS SUBURB
,'' AS LOCALITY_NAME
,'' AS TOWN
,'' AS DOMICILE
,'' AS CITY_CODE
,'' AS STATE_CODE
,'' AS ZIP
,'' AS COUNTRY_CODE
,'' AS STATUS_CODE
,'' AS NEWCONTACTSKEY
,CASE WHEN tminor.CUSTOMERMINOR <> '' THEN 'R0' + t1.ClientCode
 ELSE '' 
 END AS CIFID
,'' AS START_DATE
,'' AS PERCENTAGEBENEFITED
,'' AS PHONENO1LOCALCODE
,'' AS PHONENO1CITYCODE
,'' AS PHONENO1COUNTRYCODE
,'' AS WORKEXTENSION
,'' AS PHONENO2LOCALCODE
,'' AS PHONENO2CITYCODE
,'' AS PHONENO2COUNTRYCODE
,'' AS TELEXLOCALCODE
,'' AS TELEXCITYCODE
,'' AS TELEXCOUNTRYCODE
,'' AS FAXNOLOCALCODE
,'' AS FAXNOCITYCODE
,'' AS FAXNOCOUNTRYCODE
,'' AS PAGERNOLOCALCODE
,'' AS PAGERNOCITYCODE
,'' AS PAGERNOCOUNTRYCODE
,'' AS EMAIL
,CASE WHEN tminor.CUSTOMERMINOR <> '' THEN 'RETAIL'
 ELSE '' 
 END AS CHILDENTITYTYPE
,'' AS BEN_OWN_KEY
,'01' AS BANK_ID
,'' AS RELATIONSHIP_ALT1
,CASE WHEN tminor.CUSTOMERMINOR <> '' THEN 'Banking'
 ELSE '' 
 END AS RELATIONSHIP_CATEGORY
FROM #FinalMaster t1
--JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode
JOIN #ClientName t2 ON t1.ClientCode = t2.ClientCode
JOIN
(
       SELECT t1.ClientCode,
       CASE WHEN ((UPPER(t1.Name) LIKE UPPER('%MINOR%')) OR (t2.Gender='m') OR (t1.ClientCode IN (SELECT ClientCode FROM Master WHERE AcType IN('OM','OH','OI'))) OR t2.MaritalStatus='N') THEN 'R0'+t1.ClientCode
        ELSE ''
       END AS CUSTOMERMINOR
       FROM #FinalMaster t1 JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode
) AS tminor ON t1.ClientCode = tminor.ClientCode   -- logic added for minor account in join to pass to multiple column conditions
WHERE tminor.CUSTOMERMINOR <> '' 
AND EXISTS
(
       SELECT 1 FROM AcCustType WHERE MainCode = t1.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
)
ORDER BY 1