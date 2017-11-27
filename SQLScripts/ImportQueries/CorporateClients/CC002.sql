SELECT DISTINCT 
'CO' + t1.ClientCode AS CORP_KEY
,'CO' + t1.ClientCode AS CIFID
,'' AS CORP_REP_KEY
,'Mailing' AS ADDRESSCATEGORY
,'01-01-1900' AS START_DATE
,'' AS PHONENO1LOCALCODE
,'' AS PHONENO1CITYCODE
,'' AS PHONENO1COUNTRYCODE
,'' AS PHONENO2LOCALCODE
,'' AS PHONENO2CITYCODE
,'' AS PHONENO2COUNTRYCODE
,'' AS FAXNOLOCALCODE
,'' AS FAXNOCITYCODE
,'' AS FAXNOCOUNTRYCODE
,t2.eMail AS EMAIL
,'' AS PAGERNOLOCALCODE
,'' AS PAGERNOCITYCODE
,'' AS PAGERNOCOUNTRYCODE
,'' AS TELEXLOCALCODE
,'' AS TELEXCITYCODE
,'' AS TELEXCOUNTRYCODE
,'' AS HOUSE_NO
,'' AS PREMISE_NAME
,'' AS BUILDING_LEVEL
,'' AS STREET_NO
,'' AS STREET_NAME
,'' AS SUBURB
,'' AS LOCALITY_NAME
,'' AS TOWN
,'' AS DOMICILE
,'DEF_CITY_CODE' AS CITY_CODE
,'DEF_STATE_CODE' AS STATE_CODE
,'DEF_ZIP_CODE' AS ZIP
,'NEPAL' AS COUNTRY_CODE
,'' AS SMALL_STR1
,'' AS SMALL_STR2
,'' AS SMALL_STR3
,'' AS SMALL_STR4
,'' AS SMALL_STR5
,'' AS SMALL_STR6
,'' AS SMALL_STR7
,'' AS SMALL_STR8
,'' AS SMALL_STR9
,'' AS SMALL_STR10
,'' AS MED_STR1
,'' AS MED_STR2
,'' AS MED_STR3
,'' AS MED_STR4
,'' AS MED_STR5
,'' AS MED_STR6
,'' AS MED_STR7
,'' AS MED_STR8
,'' AS MED_STR9
,'' AS MED_STR10
,'' AS LARGE_STR1
,'' AS LARGE_STR2
,'' AS LARGE_STR3
,'' AS LARGE_STR4
,'' AS LARGE_STR5
,'' AS DATE1
,'' AS DATE2
,'' AS DATE3
,'' AS DATE4
,'' AS DATE5
,'' AS DATE6
,'' AS DATE7
,'' AS DATE8
,'' AS DATE9
,'' AS DATE10
,'' AS NUMBER1
,'' AS NUMBER2
,'' AS NUMBER3
,'' AS NUMBER4
,'' AS NUMBER5
,'' AS NUMBER6
,'' AS NUMBER7
,'' AS NUMBER8
,'' AS NUMBER9
,'' AS NUMBER10
,'' AS DECIMAL1
,'' AS DECIMAL2
,'' AS DECIMAL3
,'' AS DECIMAL4
,'' AS DECIMAL5
,'' AS DECIMAL6
,'' AS DECIMAL7
,'' AS DECIMAL8
,'' AS DECIMAL9
,'' AS DECIMAL10
,'Y' AS PREFERREDADDRESS
,'' AS HOLDMAILINITIATEDBY
,'' AS HOLDMAILFLAG
,'DEF_BUS_CENTER' AS BUSINESSCENTER
,'' AS HOLDMAILREASON
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
  AS FREETEXTADDRESS
,'FULL_ADDRESS_PUMORI' AS FREETEXTLABEL
,'' AS IS_ADDRESS_PROOF_RCVD
,'' AS LASTUPDATE_DATE
,t2.Address1 AS ADDRESS_LINE1
,t2.Address2 AS ADDRESS_LINE2
,t2.Address3 AS ADDRESS_LINE3
,'SNMANPKA' AS BANK_ID
,'' AS ISADDRESSVERIFIED
FROM Master t1 JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode
WHERE IsBlocked NOT IN ('C','o')  -- Filters the closed or invalid or unapproved accounts
AND t1.MainCode in
(
	SELECT MainCode FROM AcCustType WHERE CustTypeCode = 'Z' AND CustType NOT IN ('11','12')
)