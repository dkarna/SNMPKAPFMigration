-- SQL query for RC005

SELECT DISTINCT
'RO'+t1.ClientCode AS ORGKEY
,'' AS DOCDUEDATE
,'' AS DOCRECEIVEDDATE
,'' AS DOCEXPIRYDATE
,'' AS DOCDELFLG
,'' AS DOCREMARKS
,'' AS SCANNED
,CASE WHEN  (t2.IdType LIKE 'C%' AND t2.IdType NOT IN ('COMME','CREG','CREG#','CIT') ) THEN 'D001'
 WHEN ( (t2.IdType IN ('PASS','PASSP') OR (t2.IdType LIKE ('%PP%')))) THEN 'D002'
WHEN  t2.IdType LIKE 'PAN%' THEN 'D003'
WHEN t2.IdType LIKE 'VOT%' THEN 'D004'
WHEN t2.IdType LIKE 'REG%' THEN 'D005'
WHEN  t2.IdType LIKE 'REF%' THEN 'D006'
WHEN  t2.IdType LIKE 'EMBAS%' THEN 'D007'
WHEN  t2.IdType LIKE 'GOVT%' THEN 'D008'
WHEN ((t2.IdType LIKE 'CREG%') AND t2.ClientCode NOT IN (SELECT ClientCode FROM Master WHERE MainCode IN (SELECT MainCode FROM AcCustType WHERE CustTypeCode='B' AND CustType='NA') AND IsBlocked<>'C') 
 ) THEN 'D009'
ELSE 'DEF_CODE' END AS DOCCODE
,CASE WHEN  (t2.IdType LIKE 'C%' AND t2.IdType NOT IN ('COMME','CREG','CREG#','CIT') ) THEN 'CITIZENSHIP'
 WHEN ( (t2.IdType IN ('PASS','PASSP') OR (t2.IdType LIKE ('%PP%')))) THEN 'PASSPORT'
WHEN  t2.IdType LIKE 'PAN%' THEN 'PAN'
WHEN t2.IdType LIKE 'VOT%' THEN 'VOTER_ID'
WHEN t2.IdType LIKE 'REG%' THEN 'REG_NO'
WHEN  t2.IdType LIKE 'REF%' THEN 'REFUGEE_ID'
WHEN  t2.IdType LIKE 'EMBAS%' THEN 'EMBASSY'
WHEN  t2.IdType LIKE 'GOVT%' THEN 'GOVT'
WHEN ((t2.IdType LIKE 'CREG%') AND t2.ClientCode NOT IN (SELECT ClientCode FROM Master WHERE MainCode IN (SELECT MainCode FROM AcCustType WHERE CustTypeCode='B' AND CustType='NA') AND IsBlocked<>'C') 
 ) THEN 'COMPANY_REG_ID'
ELSE 'DEF_CODE_DESC' END AS DOCDESCR
,CASE WHEN ( (t2.IdType IN ('PASS','PASSP') OR (t2.IdType LIKE ('%PP%')))) THEN t2.PassportNo
 ELSE t2.CitizenshipNo
 END AS REFERENCENUMBER
,CASE WHEN  (t2.IdType LIKE 'C%' AND t2.IdType NOT IN ('COMME','CREG','CREG#','CIT') ) THEN 'CITIZENSHIP'
 WHEN ( (t2.IdType IN ('PASS','PASSP') OR (t2.IdType LIKE ('%PP%')))) THEN 'PASSPORT'
WHEN  t2.IdType LIKE 'PAN%' THEN 'PAN'
WHEN t2.IdType LIKE 'VOT%' THEN 'VOTER_ID'
WHEN t2.IdType LIKE 'REG%' THEN 'REG_NO'
WHEN  t2.IdType LIKE 'REF%' THEN 'REFUGEE_ID'
WHEN  t2.IdType LIKE 'EMBAS%' THEN 'EMBASSY'
WHEN  t2.IdType LIKE 'GOVT%' THEN 'GOVT'
WHEN ((t2.IdType LIKE 'CREG%') AND t2.ClientCode NOT IN (SELECT ClientCode FROM Master WHERE MainCode IN (SELECT MainCode FROM AcCustType WHERE CustTypeCode='B' AND CustType='NA') AND IsBlocked<>'C') 
 ) THEN 'COMPANY_REG_ID'
ELSE 'DEF_TYPE' END  AS TYPE
,'' AS ISMANDATORY
,'N' AS SCANREQUIRED
,'NA' AS ROLE
,CASE WHEN  (t2.IdType LIKE 'C%' AND t2.IdType NOT IN ('COMME','CREG','CREG#','CIT') ) THEN 'D001'
 WHEN ( (t2.IdType IN ('PASS','PASSP') OR (t2.IdType LIKE ('%PP%')))) THEN 'D002'
WHEN  t2.IdType LIKE 'PAN%' THEN 'D003'
WHEN t2.IdType LIKE 'VOT%' THEN 'D004'
WHEN t2.IdType LIKE 'REG%' THEN 'D005'
WHEN  t2.IdType LIKE 'REF%' THEN 'D006'
WHEN  t2.IdType LIKE 'EMBAS%' THEN 'D007'
WHEN  t2.IdType LIKE 'GOVT%' THEN 'D008'
WHEN ((t2.IdType LIKE 'CREG%') AND t2.ClientCode NOT IN (SELECT ClientCode FROM Master WHERE MainCode IN (SELECT MainCode FROM AcCustType WHERE CustTypeCode='B' AND CustType='NA') AND IsBlocked<>'C') 
 ) THEN 'D009'
ELSE 'DEF_CODE' END AS DOCTYPECODE
,'' AS DOCTYPEDESCR
,'' AS MINDOCSREQD
,'' AS WAIVEDORDEFEREDDATE
,'' AS COUNTRYOFISSUE
,'DEF_ID_PLACE' AS PLACEOFISSUE
,'' AS DOCISSUEDATE
,'' AS IDENTIFICATIONTYPE
,'' AS CORE_CUST_ID
,'' AS IS_DOCUMENT_VERIFIED
,'' AS BEN_OWN_KEY
,'' AS BANK_ID
,'NA' AS DOCTYPEDESCR_ALT1
,'NA' AS DOCDESCR_ALT1
,'' AS STATUS
FROM Master t1 JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode
WHERE t1.IsBlocked NOT IN ('C','o')  -- Filters the closed or invalid or unapproved accounts
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = t1.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
)