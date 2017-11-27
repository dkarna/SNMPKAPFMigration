-- Query for RC006Email

SELECT DISTINCT
'RO' + t1.ClientCode AS ORGKEY
,'EMAIL' AS PHONEEMAILTYPE
,'EMAIL' AS PHONEOREMAIL
,'' AS PHONENO    -- though mandatory
,'' AS PHONENOLOCALCODE
,'' AS PHONENOCITYCODE
,'977' AS PHONENOCOUNTRYCODE
,'' AS WORKEXTENSION
,t2.eMail AS EMAIL
,'' AS EMAILPALM
,'' AS URL
,'EMAIL' AS PREFERREDFLAG  -- Modified by Deepak from blank to EMAIL
,'' AS START_DATE
,'' AS END_DATE
,'Mobile No- '+MobileNo+'/'+'Phone No- '+Phone+'/'+'Email - '+eMail+'/'+'Fax No- '+FaxNo AS USERFIELD1
,'NA' AS USERFIELD2
,'NA' AS USERFIELD3
,'NA' AS DATE1
,'NA' AS DATE2
,'NA' AS DATE3
,'SNMANPKA' AS BANK_ID
FROM Master t1 JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode
WHERE t1.IsBlocked NOT IN ('C','o')  -- Filters the closed or invalid or unapproved accounts
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = t1.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
)
ORDER BY ORGKEY