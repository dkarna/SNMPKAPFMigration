-- Query for RC004

SELECT DISTINCT
'RO' + t1.ClientCode AS ORGKEY
,'Customer' AS CHILDENTITY
--,CASE WHEN ((UPPER(t1.Name) LIKE UPPER('%MINOR%')) OR (t1.GENDER='m') OR (t1.ClientCode IN (SELECT ClientCode FROM Master WHERE AcType IN('OM','OH','OI'))) OR t1.MaritalStatus='N') THEN 'Y' 
--ELSE 'N'
--END AS  CHILDENTITYID
,tminor.CUSTOMERMINOR AS CHILDENTITYID
,CASE WHEN tminor.CUSTOMERMINOR <> '' THEN 'DEF_GUARDIAN'
ELSE '' 
END AS RELATIONSHIP
,'' AS TITLE
,'' AS FIRSTNAME
,'' AS MIDDLENAME
,'' AS LASTNAME
,'' AS DOB
,'' AS GENDER
,'' AS ISDEPENDANT
,'' AS GAURDIANTYPE
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
,'' AS CIFID
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
,'RETAIL' AS CHILDENTITYTYPE
,'' AS BEN_OWN_KEY
,'SNMANPKA' AS BANK_ID
,'' AS RELATIONSHIP_ALT1
,'' AS RELATIONSHIP_CATEGORY
FROM Master t1 JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode
LEFT JOIN
(
	SELECT t1.ClientCode,
	CASE WHEN ((UPPER(t1.Name) LIKE UPPER('%MINOR%')) OR (t2.Gender='m') OR (t1.ClientCode IN (SELECT ClientCode FROM Master WHERE AcType IN('OM','OH','OI'))) OR t2.MaritalStatus='N') THEN 'RO'+t1.ClientCode 
	ELSE ''
	END AS CUSTOMERMINOR
	FROM Master t1 LEFT JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode
) AS tminor ON t1.ClientCode = tminor.ClientCode   -- logic added for minor account in join to pass to multiple column conditions
WHERE t1.IsBlocked NOT IN ('C','o')  -- Filters the closed or invalid or unapproved accounts
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = t1.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
)