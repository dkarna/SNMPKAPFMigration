
SELECT DISTINCT
'CO' + t1.ClientCode AS CORP_KEY
,'FAX' AS PHONEEMAILTYPE
,'PHONE' AS PHONEOREMAIL
,t2.FaxNo AS PHONENO
,'' AS PHONENOLOCALCODE
,'' AS PHONENOCITYCODE
,'977' AS PHONENOCOUNTRYCODE
,'' AS WORKEXTENSION
,'' AS EMAIL
,'' AS EMAILPALM
,'' AS URL
,'' AS PREFERREDFLAG
,'' AS START_DATE
,'' AS END_DATE
,'Mobile No- '+ISNULL(t2.MobileNo,'')+'/'+'Phon No- '+ISNULL(t2.Phone,'')+'/'+'Fax No- '+ISNULL(t2.FaxNo,'') AS USERFIELD1
,'Email- '+ISNULL(t2.eMail,'')+'/'+'PAGER- '+ISNULL(t2.PagerNo,'') AS USERFIELD2
,'' AS USERFIELD3
,'' AS DATE1
,'' AS DATE2
,'' AS DATE3
,'SNMANPKA' AS BANK_ID
FROM Master t1 JOIN ClientTable t2 ON t1.ClientCode=t2.ClientCode
WHERE t1.IsBlocked NOT IN ('C','o')  -- Filters the closed or invalid or unapproved accounts 
AND t1.MainCode IN
(
	SELECT MainCode FROM AcCustType WHERE CustTypeCode = 'Z' AND CustType NOT IN ('11','12')
)
ORDER BY CORP_KEY