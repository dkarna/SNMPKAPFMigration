select
'CO' + t1.ClientCode AS CORP_KEY
,'CO' + t1.ClientCode AS CORP_REP_KEY
,'' AS BEN_OWN_KEY
,'' AS DOCDUEDATE
,tmaster.mindate AS DOCRECEIVEDDATE
,'30-12-2099' AS DOCEXPIRYDATE
,'' AS DOCDELFLG
,'' AS DOCREMARKS
,'' AS SCANNED
,'DOCCODE'= 
CASE WHEN  IdType LIKE 'CREG%' THEN 'COMREG'
WHEN  IdType LIKE 'GOVT%' THEN 'GOVT'
ELSE 'DEF_DOC_TYPE' END 
,'' AS DOCDESCR
,'Id: '+CONVERT(VARCHAR,(ISNULL(ClientId,'')))+' PanNo: '+CONVERT(VARCHAR,(ISNULL(PANNumber,''))) AS REFERENCENUMBER
,'' AS ISMANDATORY
,'' AS SCANREQUIRED
,'' AS ROLE
,'DOCTYPECODE'= 
CASE WHEN  IdType LIKE 'CREG%' THEN 'COMPANY_REG_ID'
WHEN  IdType LIKE 'GOVT%' THEN 'GOVT'
ELSE 'DEF_DOC_TYPE' END
,'' AS DOCTYPEDESCR
,'' AS MINDOCSREQD
,'' AS WAIVEDORDEFEREDDATE
,'NEPAL' AS COUNTRYOFISSUE
,'DEF_PLACE' AS PLACEOFISSUE
,'01-JAN-1900' AS DOCISSUEDATE
,'' AS IDENTIFICATIONTYPE
,'' AS CORE_CUST_ID
,'' AS IS_DOCUMENT_VERIFIED
,'SNMANPKA' AS BANK_ID
FROM Master t1 JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode
JOIN 
(		-- Filters the clientcode with minimum account open date
	SELECT t.ClientCode,MIN(t.AcOpenDate) AS mindate FROM Master t GROUP BY t.ClientCode 
) AS tmaster ON t1.ClientCode = tmaster.ClientCode AND tmaster.mindate = t1.AcOpenDate
WHERE t1.IsBlocked NOT IN ('C','o')  -- Filters the closed or invalid or unapproved accounts
AND t1.MainCode in
(
	SELECT MainCode FROM AcCustType WHERE CustTypeCode = 'Z' and CustType NOT IN ('11','12')
)
ORDER BY CORP_KEY