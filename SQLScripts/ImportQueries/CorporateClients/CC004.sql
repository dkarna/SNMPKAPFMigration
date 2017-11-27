
SELECT DISTINCT
 'CO' + t3.ClientCode AS CORP_KEY  
,'DEF_SAL' AS SALUTATION
,REPLACE(CONVERT(NVARCHAR, t2.DateOfBirth, 106), ' ', '-') AS DOB
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
,t3.ClientCode AS CIFID
,'' AS ENTITYKEY
,'' AS CIFTYPE
,'0.00' AS PERCENTAGEBENEFITED
,t2.Name AS CORPORATE_NAME
,case when charindex('/',t.Name) = 0 then 
		(left( t.Name, CHARINDEX(' ', t.Name))) 
     else 
	     t.Name
	end as FirstName,
	CASE WHEN charindex('/',t.Name) = 0 then 
		''
	else
		t.Name
	end as MiddleName,
	case when charindex('/',t.Name) = 0 then 
		(right( t.Name, CHARINDEX(' ', reverse(t.Name)))) 
     else 
	     t.Name
	end as LastName
,t2.Alias AS BENEFICIALOWNERKEY
,'' AS ENTITY_TYPE
,'' AS STR1
,'' AS STR2
,'' AS STR3
,'' AS STR4
,'' AS STR5
,'' AS STR6
,'' AS STR7
,'' AS STR8
,'' AS STR9
,'' AS STR10
,'' AS STR11
,'' AS STR12
,'' AS STR13
,'' AS STR14
,'' AS STR15
,'' AS AMOUNT1
,'' AS AMOUNT2
,'' AS AMOUNT3
,'' AS AMOUNT4
,'' AS AMOUNT5
,'' AS FLAG1
,'' AS FLAG2
,'' AS FLAG3
,'' AS FLAG4
,'' AS FLAG5
,'' AS INT1
,'' AS INT2
,'' AS INT3
,'' AS INT4
,'' AS INT5
,'' AS MLUSERFIELD1
,'' AS MLUSERFIELD2
,'' AS MLUSERFIELD3
,'' AS MLUSERFIELD4
,'' AS MLUSERFIELD5
,'SNMANPKA' AS BANK_ID
,'' AS LAST_NAME_ALT1
,'' AS MIDDLE_NAME_ALT1
,'' AS FIRST_NAME_ALT1
FROM Master t1 JOIN ClientTable t3 ON t1.ClientCode = t3.ClientCode
LEFT JOIN ClientExtraDetail t2 ON t1.ClientCode = t2.ClientCode
WHERE t1.IsBlocked NOT IN ('C','o')  -- Filters the closed or invalid or unapproved accounts
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = t1.MainCode and CustTypeCode = 'Z' and CustType NOT IN ('11','12')
)