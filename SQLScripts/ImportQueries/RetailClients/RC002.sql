-- Query for RC002

SELECT DISTINCT
'RO' + t1.ClientCode AS ORGKEY
,'Home' AS ADDRESSCATEGORY
,REPLACE(REPLACE(CONVERT(VARCHAR,tmaster.mindate,106), ' ','-'), ',','') AS START_DATE
,'NA' AS PHONENO1LOCALCODE
,'NA' AS PHONENO1CITYCODE
,'NA' AS PHONENO1COUNTRYCODE
,'NA' AS PHONENO2LOCALCODE
,'NA' AS PHONENO2CITYCODE
,'NA' AS PHONENO2COUNTRYCODE
,'NA' AS WORKEXTENSION
,'NA' AS FAXNOLOCALCODE
,'NA' AS FAXNOCITYCODE
,'NA' AS FAXNOCOUNTRYCODE
,'NA' AS EMAIL
,'NA' AS PAGERNOLOCALCODE
,'NA' AS PAGERNOCITYCODE
,'NA' AS PAGERNOCOUNTRYCODE
,'NA' AS TELEXLOCALCODE
,'NA' AS TELEXCITYCODE
,'NA' AS TELEXCOUNTRYCODE
,'' AS HOUSE_NO
,'' AS PREMISE_NAME
,'' AS BUILDING_LEVEL
,'' AS STREET_NO
,'' AS STREET_NAME
,'' AS SUBURB
,'' AS LOCALITY_NAME
,'' AS TOWN
,'' AS DOMICILE
,'DEF_CITY' AS CITY_CODE
,'DEF_STATE' AS STATE_CODE
,t2.City AS ZIP      -- as per the given condition
,CASE WHEN t2.CountryCode = '11' THEN 'INDIA'
WHEN t2.CountryCode = '21' THEN 'USA'
WHEN t2.CountryCode = '23' THEN 'AUSTRALIA'
WHEN t2.CountryCode = '32' THEN 'AUSTRIA'
ELSE 'NEPAL'
 END AS COUNTRY_CODE
,t2.Address1 AS ADDRESS_LINE1
,t2.Address2 AS ADDRESS_LINE2
,t2.Address3 AS ADDRESS_LINE3
,'30-12-2099' AS END_DATE
,'NA' AS SMALL_STR1
,'NA' AS SMALL_STR2
,'NA' AS SMALL_STR3
,'NA' AS SMALL_STR4
,'NA' AS SMALL_STR5
,'NA' AS SMALL_STR6
,'NA' AS SMALL_STR7
,'NA' AS SMALL_STR8
,'NA' AS SMALL_STR9
,'NA' AS SMALL_STR10
,'NA' AS MED_STR1
,'NA' AS MED_STR2
,'NA' AS MED_STR3
,'NA' AS MED_STR4
,'NA' AS MED_STR5
,'NA' AS MED_STR6
,'NA' AS MED_STR7
,'NA' AS MED_STR8
,'NA' AS MED_STR9
,'NA' AS MED_STR10
,'NA' AS LARGE_STR1
,'NA' AS LARGE_STR2
,'NA' AS LARGE_STR3
,'NA' AS LARGE_STR4
,'NA' AS LARGE_STR5
,'NA' AS DATE1
,'NA' AS DATE2
,'NA' AS DATE3
,'NA' AS DATE4
,'NA' AS DATE5
,'NA' AS DATE6
,'NA' AS DATE7
,'NA' AS DATE8
,'NA' AS DATE9
,'NA' AS DATE10
,'NA' AS NUMBER1
,'NA' AS NUMBER2
,'NA' AS NUMBER3
,'NA' AS NUMBER4
,'NA' AS NUMBER5
,'NA' AS NUMBER6
,'NA' AS NUMBER7
,'NA' AS NUMBER8
,'NA' AS NUMBER9
,'NA' AS NUMBER10
,'NA' AS DECIMAL1
,'NA' AS DECIMAL2
,'NA' AS DECIMAL3
,'NA' AS DECIMAL4
,'NA' AS DECIMAL5
,'NA' AS DECIMAL6
,'NA' AS DECIMAL7
,'NA' AS DECIMAL8
,'NA' AS DECIMAL9
,'NA' AS DECIMAL10
,t2.ClientCode AS CIFID
,'Mailing' AS PREFERREDADDRESS -- To be confirmed
,'' AS HOLDMAILINITIATEDBY
,'' AS HOLDMAILFLAG
,'' AS BUSINESSCENTER
,'' AS HOLDMAILREASON
,'Free Text' AS PREFERREDFORMAT
,'FREE_TEXT_FORMAT' AS PREFERREDFORMAT
,'Address1: '+isnull(t2.Address1,'')
	+'/'+'Address2: '+isnull(t2.Address2,'')
	+'/'+'Address3: '+isnull(t2.Address3,'')
	+'/'+'ContactAdd1: '+isnull(t2.ContactAdd1,'')
	+'/'+'ContactAdd2: '+isnull(t2.ContactAdd2,'')
	+'/'+'ContactAdd3: '+isnull(t2.ContactAdd3,'')
	+'/'+'City: '+isnull(t2.City,'')
	+'/'+'PhoneNo: '+isnull(t2.Phone,'')
	+'/'+'MobileNo: '+isnull(t2.MobileNo,'')
	+'/'+'Fax2: '+isnull(Fax2,'')
	+'/'+'FaxNo: '+isnull(t2.FaxNo,'')   
	+'/'+'PagerNo: '+isnull(t2.PagerNo,'') 
	+'/'+'AlternateAdd1: '+isnull(AlternateAdd1,'')
	+'/'+'AlternateAdd2 '+isnull(AlternateAdd2,'') 
	+'/'+'AlternateAdd3: '+isnull(AlternateAdd3,'')
	AS FREETEXTADDRESS
,'FULL_ADDRESS_PUMORI' AS FREETEXTLABEL
,'' AS IS_ADDRESS_PROOF_RCVD
,'' AS LASTUPDATE_DATE
,'SNMANPKA' AS BANK_ID       -- Given by Deepak
,'' AS ISADDRESSVERIFIED
FROM Master t1 JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode
JOIN 
(							-- Filters the clientcode with minimum account open date
	SELECT t.ClientCode,MIN(t.AcOpenDate) AS mindate FROM Master t GROUP BY t.ClientCode 
) AS tmaster ON t1.ClientCode = tmaster.ClientCode AND tmaster.mindate = t1.AcOpenDate
WHERE t1.IsBlocked NOT IN ('C','o')  -- Filters the closed or invalid or unapproved accounts
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = t1.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
)