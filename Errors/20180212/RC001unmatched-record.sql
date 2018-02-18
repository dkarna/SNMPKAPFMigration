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
		,ROW_NUMBER() OVER( PARTITION BY ClientCode ORDER BY AcOpenDate,MainCode) AS SerialNumber
		--INTO #FinalMaster
		FROM Master WITH (NOLOCK)
		WHERE IsBlocked NOT IN ('C','o')
		--ORDER BY ClientCode
	) AS t 
WHERE t.SerialNumber = 1 ORDER BY 1;	

SELECT DISTINCT
'R0' + t1.ClientCode AS ORGKEY
,'R0' + t1.ClientCode AS CIFID
,'CUSTOMER' AS ENTITYTYPE
,'RETA' AS CUST_TYPE_CODE
,CASE WHEN lower(t2.Gender) = 'f' OR lower(Salutation) = 'mrs' THEN 'MS.'
 WHEN lower(t2.Gender) = 'm' OR lower(Salutation) = 'mr' THEN 'MR.' 
 ELSE 'M/S.' end SALUTATION_CODE
,
CASE WHEN isnull(SUBSTRING(t2.Name,1,CHARINDEX(' ',LTRIM(RTRIM(t2.Name)))),'.') = '' THEN '.'
 ELSE isnull(SUBSTRING(ltrim(rtrim(t2.Name)),1,charindex(' ',ltrim(rtrim(t2.Name)))),'.')
 END AS CUST_FIRST_NAME

,replace(replace (ltrim(rtrim(t2.Name)), SUBSTRING(ltrim(rtrim(t2.Name)),0,charindex(' ',ltrim(rtrim(t2.Name)))) , ''),reverse(SUBSTRING(reverse(ltrim(rtrim(t2.Name))),0,charindex(' ',reverse(ltrim(rtrim(t2.Name)))))),'') CUST_MIDDLE_NAME
,CASE WHEN isnull(reverse(SUBSTRING(reverse(ltrim(rtrim(t2.Name))),0,charindex(' ',reverse(ltrim(rtrim(t2.Name)))))),'.') = '' THEN '.'
 ELSE isnull(reverse(SUBSTRING(reverse(ltrim(rtrim(t2.Name))),0,charindex(' ',reverse(ltrim(rtrim(t2.Name)))))),'.')
 END as CUST_LAST_NAME

,CASE WHEN isnull(SUBSTRING(t2.Name,1,CHARINDEX(' ',LTRIM(RTRIM(t2.Name)))),'.') = '' THEN '.'
 ELSE isnull(SUBSTRING(ltrim(rtrim(t2.Name)),1,charindex(' ',ltrim(rtrim(t2.Name)))),'.')
 END AS PREFERREDNAME
,CASE WHEN t2.Name = '' OR t2.Name is NULL THEN 'MIGR' ELSE LEFT(t2.Name,10) END AS SHORT_NAME
,CASE WHEN t2.DateOfBirth IS NULL OR t2.DateOfBirth >= GETDATE() THEN REPLACE(REPLACE(CONVERT(VARCHAR,'01-Jan-1985',106), ' ','-'), ',','') 
ELSE
REPLACE(REPLACE(CONVERT(VARCHAR,t2.DateOfBirth,106), ' ','-'), ',','') 
END AS CUST_DOB
,CASE WHEN t2.Gender = 'M' THEN 'M'
WHEN t2.Gender = 'F' THEN 'F'
ELSE 'O'
END AS GENDER
,'' AS OCCUPATION_CODE
,CASE WHEN ct.ISOCode = '' OR ct.ISOCode = NULL THEN 'NP' ELSE ct.ISOCode END AS NATIONALITY		
,'' AS NATIVELANGTITLE
,'' AS NATIVELANGNAME
,'Y' AS DOCUMENT_RECIEVED
,CASE WHEN t2.ClientCode = fe.ClientCode  THEN 'Y'
ELSE 'N'
END AS STAFFFLAG
,CASE WHEN t2.ClientCode = fe.ClientCode THEN convert(varchar,EmpId)
ELSE ''
END AS STAFFEMPLOYEEID		--need to be changed after BPD as Pumori employee_id need to be matched in Finacle
,'FIVUSR' AS MANAGER  -- Default value added as per understanding with bank
,CASE WHEN t4.CustType IN('CB','NB','XB','UB','AF','DB','MB','OB','RB','VB','WC') THEN 'Y'
ELSE 'N'
END AS CUSTOMERNREFLAG
,CASE WHEN t4.CustType IN('CB','NB','XB','UB','AF','DB','MB','OB','RB','VB','WC') THEN REPLACE(REPLACE(CONVERT(VARCHAR,t1.AcOpenDate,106), ' ','-'), ',','') ELSE '' END AS DATEOFBECOMINGNRE
,ISNULL(REPLACE(tminor.CUSTOMERMINOR,'','N'),'N') AS CUSTOMERMINOR  -- changed
,CASE WHEN tminor.CUSTOMERMINOR = 'Y' THEN 'CIFMINOR' 
ELSE '' 
END AS MINORGAURDIANID --changed
,CASE WHEN tminor.CUSTOMERMINOR = 'Y' THEN 'F' 
ELSE '' 
END AS MINOR_GUARD_CODE  
,CASE WHEN tminor.CUSTOMERMINOR = 'Y' THEN 'Default Value' 
ELSE '' 
END AS MINOR_GUARD_NAME		--need value for Default Value 
,'MIGR' AS REGION			--need to be changed as per BPD
,RIGHT(SPACE(5)+CAST(t1.BranchCode AS VARCHAR(5)),5) AS PRIMARY_SERVICE_CENTRE
,REPLACE(REPLACE(CONVERT(VARCHAR,t1.AcOpenDate,106), ' ','-'), ',','') AS RELATIONSHIPOPENINGDATE
,CASE WHEN t2.ClientStatus = 'D' THEN 'DCSED'
WHEN t2.ClientStatus = 'L' THEN 'LUNAT'
WHEN t2.ClientStatus = 'u' THEN 'UNRE'
WHEN t2.ClientStatus = 'w' THEN 'WANT'
WHEN t2.ClientStatus = 's' THEN 'SUSP'
WHEN t2.ClientStatus = 'Z' THEN 'STOP'
WHEN t2.ClientStatus = 'N' THEN 'NORM'
WHEN t2.ClientStatus =  NULL THEN 'ACTVE'
WHEN t2.ClientStatus = '1' THEN 'ACTVE'
WHEN t2.ClientStatus = ' ' THEN 'ACTVE'
WHEN t2.ClientStatus = 'b' THEN 'ACTVE'
ELSE 'ACTVE' END AS STATUS_CODE		
,'' AS CUSTSTATUSCHGDATE
,'' AS HOUSEHOLDID
,'' AS HOUSEHOLDNAME
,'NPR' AS CRNCY_CODE_RETAIL
,CASE WHEN lower(t2.Key_Risk_Grade ) like 'l%' THEN 'LOW'
WHEN lower(t2.Key_Risk_Grade ) LIKE 'm%' THEN 'MEDUM'
WHEN lower(t2.Key_Risk_Grade) LIKE 'h%' THEN 'HIGH'
else 'MIGR'  end as RATING_CODE
,'' AS RATINGDATE
,'' AS CUST_PREF_TILL_DATE
,'A' AS TDS_TBL_CODE
,'' AS INTRODUCERID
,'' AS INTRODUCERSALUTATION
,'INTRODUCER1' AS INTRODUCERNAME  -- Default value as per the understanding from bank
,'' AS INTRODUCERSTATUSCODE
,'' AS OFFLINE_CUM_DEBIT_LIMIT
,'' AS CUST_TOT_TOD_ALWD_TIMES
,'' AS CUST_COMMU_CODE
,'' AS CARD_HOLDER
,'NRML' AS CUST_HLTH
,'' AS CUST_HLTH_CODE
,case when t1.AcType>='90' then 'Y' else 'N' end  AS TFPARTYFLAG	--need to map with the mapping sheet condition and value should be either Y or N
,t1.BranchCode AS PRIMARY_SOL_ID
,'' AS CONSTITUTION_REF_CODE
,'' AS CUST_OTHR_BANK_CODE
,'' AS CUST_FIRST_ACCT_DATE
,'' AS CHRG_LEVEL_CODE
,'' AS CHRG_DR_FORACID
,'' AS CHRG_DR_SOL_ID
,'N' AS CUST_CHRG_HISTORY_FLG
,'N' AS COMBINED_STMT_REQD
,'' AS LOANS_STMT_TYPE
,'' AS TD_STMT_TYPE
,'' AS COMB_STMT_CHRG_CODE
,'' AS DESPATCH_MODE
,'' AS CS_LAST_PRINTED_DATE
,'' AS CS_NEXT_DUE_DATE
,'N' AS ALLOW_SWEEPS
,'' AS PS_FREQ_TYPE
,'' AS PS_FREQ_WEEK_NUM
,'' AS PS_FREQ_WEEK_DAY
,'' AS PS_FREQ_START_DD
,'' AS PS_FREQ_HLDY_STAT
,'CUSTOMER' AS ENTITY_TYPE
,'' AS LINKEDRETAILCIF
,'N' AS HSHLDUFLAG
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
,'' AS NUMBER6
,'' AS NUMBER5
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
,'' AS CORE_CUST_ID  -- Need to be confirmed
,'' AS PERSONTYPE
,'INFENG' AS CUST_LANGUAGE
,'' AS CUST_STAFF_STATUS
,'' AS PHONE
,'' AS EXTENSION
,'' AS FAX
,'' AS FAX_HOME
,'' AS PHONE_HOME
,'' AS PHONE_HOME2
,'' AS PHONE_CELL
,'' AS EMAIL_HOME
,'' AS EMAIL_PALM
,'' AS EMAIL
,'' AS CITY
,'' AS PREFERREDCHANNELID
,'' AS CUSTOMERRELATIONSHIPNO
,'' AS RELATIONSHIPVALUE
,'' AS CATEGORY
,'' AS NUMBEROFPRODUCTS
,'' AS RELATIONSHIPMGRID
,'' AS RELATIONSHIPCREATEDBYID
,t2.WebAddress AS URL
,t2.ClientStatus AS STATUS
,'' AS INDUSTRY
,'' AS PARENTORG
,'' AS COMPETITOR
,'' AS SICCODE
,'' AS CIN
,'' AS DESIGNATION
,'' AS ASSISTANT
,'' AS INTERNALSCORE
,'' AS CREDITBUREAUSCOREVALIDITY
,'' AS CREDITBUREAUSCORE
,'' AS CREDITBUREAUREQUESTDATE
,'' AS CREDITBUREAUDESCRIPTION
,'' AS MAIDENNAMEOFMOTHER
,'' AS ANNUALREVENUE
,'' AS REVENUEUNITS
,'' AS TICKERSYMBOL
,'N' AS AUTOAPPROVAL
,'N' AS FREEZEPRODUCTSALE
,'' AS RELATIONSHIPFIELD1
,'' AS RELATIONSHIPFIELD2
,'' AS RELATIONSHIPFIELD3
,'' AS DELINQUENCYFLG
,'' AS CUSTOMERNREFLG
,'' AS COMBINEDSTATEMENTFLG
,'' AS CUSTOMERTRADE
,'' AS PLACEOFBIRTH
,'' AS COUNTRYOFBIRTH
,'' AS PROOFOFAGEFLAG
,'' AS PROOFOFAGEDOCUMENT
,'' AS NAMESUFFIX
,'' AS MAIDENNAME
,'' AS CUSTOMERPROFITABILITY
,'' AS CURRENTCREXPOSURE
,'' AS TOTALCREXPOSURE
,'' AS POTENTIALCRLINE
,'' AS AVAILABLECRLIMIT
,'' AS CREDITSCOREREQUESTEDFLAG
,'' AS CREDITHISTORYREQUESTEDFLAG
,'' AS GROUPID
,'' AS FLG1
,'' AS FLG2
,'' AS FLG3
,'' AS ALERT1
,'' AS ALERT2
,'' AS ALERT3
,'' AS RELATIONSHIPOFFER1
,'' AS RELATIONSHIPOFFER2
,'' AS DTDATE1
,'' AS DTDATE2
,'' AS DTDATE3
,'' AS DTDATE4
,'' AS DTDATE5
,'' AS DTDATE6
,'' AS DTDATE7
,'' AS DTDATE8
,'' AS DTDATE9
,RIGHT(SPACE(20)+CAST('100' AS VARCHAR(20)),20) AS AMOUNT1  -- Default value will be given by the bank
,'' AS AMOUNT2
,'' AS AMOUNT3
,'' AS AMOUNT4
,'' AS AMOUNT5
,'' AS STRFIELD1
,'' AS STRFIELD2
,'' AS STRFIELD3
,'' AS STRFIELD4
,'' AS STRFIELD5
,'' AS STRFIELD6
,'' AS STRFIELD7
,'' AS STRFIELD8
,'' AS STRFIELD9
,'' AS STRFIELD10
,'' AS STRFIELD11
,'' AS STRFIELD12
,'N' AS STRFIELD13  -- As per agreement with Finacle team
,'' AS STRFIELD14  -- dependent on STRFIELD13
,'' AS STRFIELD15
,'' AS USERFLAG1
,'' AS USERFLAG2
,'' AS USERFLAG3
,'' AS USERFLAG4
,'' AS MLUSERFIELD1
,'' AS MLUSERFIELD2
,'' AS MLUSERFIELD3
,'' AS MLUSERFIELD4
,'' AS MLUSERFIELD5
,'' AS MLUSERFIELD6
,'' AS MLUSERFIELD7
,'' AS MLUSERFIELD8
,'' AS MLUSERFIELD9
,'' AS MLUSERFIELD10
,'' AS MLUSERFIELD11
,'' AS NOTES
,'' AS PRIORITYCODE
,'' AS CREATED_FROM
,'' AS CONSTITUTION_CODE
,'N' AS STRFIELD16  --default value 'N'
,'' AS STRFIELD17
,'' AS STRFIELD18
,'' AS STRFIELD19
,'' AS STRFIELD20
,'' AS STRFIELD21
,'' AS STRFIELD22
,'' AS AMOUNT6
,'' AS AMOUNT7
,'' AS AMOUNT8
,'' AS AMOUNT9
,'' AS AMOUNT10
,'' AS AMOUNT11
,'' AS AMOUNT12
,'' AS INTFIELD1
,'' AS INTFIELD2
,'' AS INTFIELD3
,'' AS INTFIELD4
,'' AS INTFIELD5
,'' AS NICK_NAME
,'' AS MOTHER_NAME
,'' AS FATHER_HUSBAND_NAME
,'' AS PREVIOUS_NAME
,'' AS LEAD_SOURCE
,'' AS RELATIONSHIP_TYPE
,'' AS RM_GROUP_ID
,'' AS RELATIONSHIP_LEVEL
,'' AS DSA_ID
,'' AS PHOTOGRAPH_ID
,'' AS SECURE_ID
,'' AS DELIQUENCYPERIOD
,'' AS ADDNAME1
,'' AS ADDNAME2
,'' AS ADDNAME3
,'' AS ADDNAME4
,'' AS ADDNAME5
,'' AS OLDENTITYCREATEDON
,'' AS OLDENTITYTYPE
,'' AS OLDENTITYID
,'' AS DOCUMENT_RECEIVED
,'' AS SUSPEND_NOTES
,'' AS SUSPEND_REASON
,'' AS BLACKLIST_NOTES
,'' AS BLACKLIST_REASON
,'' AS NEGATED_NOTES
,'' AS NEGATED_REASON
,'MIGR' AS SEGMENTATION_CLASS		-- Default value for BPD
,'' AS NAME
,'' AS MANAGEROPINION
,'' AS INTROD_STATUS
,'INFENG' AS NATIVELANGCODE
,'' AS MINORATTAINMAJORDATE
,'' AS NREBECOMINGORDDATE
,'' AS STARTDATE
,'' AS ADD1_FIRST_NAME
,'' AS ADD1_MIDDLE_NAME
,'' AS ADD1_LAST_NAME
,'' AS ADD2_FIRST_NAME
,'' AS ADD2_MIDDLE_NAME
,'' AS ADD2_LAST_NAME
,'' AS ADD3_FIRST_NAME
,'' AS ADD3_MIDDLE_NAME
,'' AS ADD3_LAST_NAME
,'' AS ADD4_FIRST_NAME
,'' AS ADD4_MIDDLE_NAME
,'' AS ADD4_LAST_NAME
,'' AS ADD5_FIRST_NAME
,'' AS ADD5_MIDDLE_NAME
,'' AS ADD5_LAST_NAME
,'' AS DUAL_FIRST_NAME
,'' AS DUAL_MIDDLE_NAME
,'' AS DUAL_LAST_NAME
,'' AS CUST_COMMUNITY
,'' AS CORE_INTROD_CUST_ID
,'' AS INTROD_SALUTATION_CODE
,'' AS TDS_CUST_ID
,t2.CitizenshipNo AS NAT_ID_CARD_NUM
,'' AS PSPRT_ISSUE_DATE
,t2.PassportCountry AS PSPRT_DET
,t2.PassportExpiryDate AS PSPRT_EXP_DATE
,'NPR' AS CRNCY_CODE
,'' AS PREF_CODE
,'' AS INTROD_STATUS_CODE
,'' AS NATIVELANGTITLE_CODE
,'' AS GROUPID_CODE
,(select top 1 sector from (select case when CustType in ('CA','UA','XB','NB') then 'FORRE'
when CustType in ('UB','CB') then 'FORNR'
when CustType in ('NA','XA') then 'NEPRE'
else 'MIGR' end sector from AcCustType where CustTypeCode = 'B')x) AS SECTOR		
,'' AS SUBSECTOR
,'' AS CUSTCREATIONMODE
,'' AS FIRST_PRODUCT_PROCESSOR
,'' AS INTERFACE_REFERENCE_ID
,--case when p.ReferenceNo not in (select t1.MainCode #FinalMaster) then 'NRML'
--when day((getdate()-p.DueDate))<=30 then 'PASS' 
--when (day((getdate()-p.DueDate))>30 and  day((getdate()-p.DueDate))<=90 )then 'WATCH'
--when (day((getdate()-p.DueDate))>90 and  day((getdate()-p.DueDate))<=180 )then 'SUBS'
--when (day((getdate()-p.DueDate))>180 and  day((getdate()-p.DueDate))<=365 )then 'DOUBT' 
--when day((getdate()-p.DueDate))>365 then 'LOSS' end 
'NRML' AS CUST_HEALTH_REF_CODE
,'' AS TDS_CIFID
,'' AS PREF_CODE_RCODE
,'' AS CUST_SWIFT_CODE_DESC
,'' AS IS_SWIFT_CODE_OF_BANK
,'' AS NATIVELANGCODE_CODE
,'' AS CREATEDBYSYSTEMID
,'COMMEML' AS PREFERREDEMAILTYPE
,'MOBILE' AS PREFERREDPHONE
,'' AS FIRST_NAME_NATIVE
,'' AS MIDDLE_NAME_NATIVE
,'' AS LAST_NAME_NATIVE
,'' AS SHORT_NAME_NATIVE
,'' AS FIRST_NAME_NATIVE1
,'' AS MIDDLE_NAME_NATIVE1
,'' AS LAST_NAME_NATIVE1
,'' AS SHORT_NAME_NATIVE1
,'' AS SECONDARYRM_ID
,'' AS TERTIARYRM_ID
,'MIGR' AS SUBSEGMENT			-- need to change as per BPD
,'' AS ACCESSOWNERGROUP
,'' AS ACCESSOWNERSEGMENT
,'' AS ACCESSOWNERBC
,'' AS ACCESSOWNERAGENT
,'' AS ACCESSASSIGNEEAGENT
,'' AS CHARGELEVELCODE
,'' AS INTUSERFIELD1
,'' AS INTUSERFIELD2
,'' AS INTUSERFIELD3
,'' AS INTUSERFIELD4
,'' AS INTUSERFIELD5
,'' AS STRUSERFIELD1
,'' AS STRUSERFIELD2
,'Y' AS STRUSERFIELD3
,'' AS STRUSERFIELD4
,'' AS STRUSERFIELD5
,'' AS STRUSERFIELD6
,'' AS STRUSERFIELD7
,'' AS STRUSERFIELD8
,'' AS STRUSERFIELD9
,'' AS STRUSERFIELD10
,'' AS STRUSERFIELD11
,'' AS STRUSERFIELD12
,'' AS STRUSERFIELD13
,'' AS STRUSERFIELD14
,'' AS STRUSERFIELD15
,'' AS STRUSERFIELD16
,'' AS STRUSERFIELD17
,'' AS STRUSERFIELD18
,'' AS STRUSERFIELD19
,'' AS STRUSERFIELD20
,'' AS STRUSERFIELD21
,'' AS STRUSERFIELD22
,'' AS STRUSERFIELD23
,'' AS STRUSERFIELD24
,t2.Remarks AS STRUSERFIELD25
,'' AS STRUSERFIELD26
,'' AS STRUSERFIELD27
,'' AS STRUSERFIELD28
,'' AS STRUSERFIELD29
,'' AS STRUSERFIELD30
,'' AS DATEUSERFIELD1
,'' AS DATEUSERFIELD2
,'' AS DATEUSERFIELD3
,'' AS DATEUSERFIELD4
,'' AS DATEUSERFIELD5
,'' AS BACKENDID
,'' AS RISK_PROFILE_SCORE
,'' AS RISK_PROFILE_EXPIRY_DATE
,'RESE' AS PREFERREDPHONETYPE
,t2.eMail AS PREFERREDEMAIL
,'' AS NOOFCREDITCARDS
,'' AS REASONFORMOVINGOUT
,'' AS COMPETITORPRODUCTID
,'' AS OCCUPATIONTYPE
,'01' AS BANK_ID
,'' AS ZAKAT_DEDUCTION
,'' AS ASSET_CLASSIFICATION
,'' AS CUSTOMER_LEVEL_PROVISIONING
,'' AS ISLAMIC_BANKING_CUSTOMER
,'GREGORIAN' AS PREFERREDCALENDAR
,'' AS IDTYPER1
,'' AS IDTYPER2
,'' AS IDTYPER3
,'' AS IDTYPER4
,'' AS IDTYPER5
,'' AS CUST_LAST_NAME_ALT1
,'' AS CUST_FIRST_NAME_ALT1
,'' AS CUST_MIDDLE_NAME_ALT1
,'' AS STRFIELD6_ALT1
,'' AS NAME_ALT1
,'' AS SHORT_NAME_ALT1
,CASE WHEN t1.ClientCode = tempcust.ClientCode THEN 'Y'
ELSE 'N' 
END AS ISEBANKINGENABLED
,'N' AS PURGEFLAG
,CASE WHEN t2.ClientStatus = 'Z' THEN 'Y'
ELSE 'N'
END AS SUSPENDED
,CASE WHEN t2.ClientStatus = 'b' THEN 'Y'
ELSE 'N'
END AS BLACKLISTED
,'' AS NEGATED
,'' AS ACCOUNTID
,t2.Address1 AS ADDRESS_LINE1
,t2.Address2 AS ADDRESS_LINE2
,t2.Address3 AS ADDRESS_LINE3
,'' AS STATE
,CASE WHEN ct.ISOCode = 'GB' THEN 'UK' ELSE ct.ISOCode END AS COUNTRY
,'' AS ZIP
,'' AS BOCREATEDBYLOGINID
,'' AS SUBMITFORKYC
,replace(replace(convert(varchar,t2.Review_Date,106),' ','-'),',','') AS KYC_REVIEWDATE
,'' AS KYC_DATE
,CASE WHEN lower(t2.Key_Risk_Grade ) like 'l%' THEN 'LOW'
WHEN lower(t2.Key_Risk_Grade ) LIKE 'm%' THEN 'MODERATE'
WHEN lower(t2.Key_Risk_Grade) LIKE 'h%' THEN 'HIGH'
ELSE 'MIGR' END AS RISKRATING
,CASE WHEN t1.AcType = '0B' THEN 'Y'
--WHEN DATEDIFF(year,t2.DateOfBirth,GETDATE()) < 60 THEN 'Y'
ELSE 'N'
END AS SENIORCITIZEN
,'' AS SENCITIZENAPPLICABLEDATE
,'' AS SENCITIZENCONVERSIONFLAG
,'' AS FOREIGNACCTAXREPORTINGREQ
,'' AS FOREIGNTAXREPORTINGCOUNTRY
,'' AS FOREIGNTAXREPORTINGSTATUS
,'' AS LASTFOREIGNTAXREVIEWDATE
,'' AS NEXTFOREIGNTAXREVIEWDATE
,'' AS FATCAREMARKS
,'' AS DATEOFDEATH
,'' AS DATEOFNOTIFICATION
,'' AS PHYSICAL_STATE
,'' AS UNIQUEIDNUMBER
FROM #FinalMaster t1
JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode
LEFT JOIN CountryTable ct on ct.CyCode = t1.CyCode
LEFT JOIN FinacleEmployeeTable fe on fe.ClientCode = t2.ClientCode
LEFT JOIN PastDuedList p on p.ReferenceNo = t1.MainCode
LEFT JOIN AcCustType t4 ON t1.BranchCode = t4.BranchCode and t1.MainCode = t4.MainCode AND t4.CustType = 'B' -- need to be checked with bank data putting inner join
LEFT JOIN 
(
	SELECT ClientCode FROM Master t1 JOIN CustomerTable t2 ON t1.MainCode = t2.MainCode0
) AS tempcust ON t1.ClientCode = tempcust.ClientCode  -- Logic for connection between CustomerTable and Master as defined in logic to reduce complexity
LEFT JOIN
(
	SELECT t1.ClientCode,
	CASE WHEN ((UPPER(t1.Name) LIKE UPPER('%MINOR%')) OR (t2.Gender='m') OR (t1.ClientCode IN (SELECT ClientCode FROM #FinalMaster WHERE AcType IN('OM','OH','OI'))) OR t2.MaritalStatus='N') THEN 'Y' 
	ELSE 'N'
	END AS CUSTOMERMINOR
	FROM #FinalMaster t1 LEFT JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode
) AS tminor ON t1.ClientCode = tminor.ClientCode   -- logic added for minor account in join to pass to multiple column conditions
WHERE LEFT(t2.ClientCode,1) <> '_'
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = t1.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
) 
AND t1.ClientCode IN ( 
, '00000192'  --suspended -->Y 
,'00000277'
,'00002056'
,'00002795'
,'00003097'
,'00004561' --suspended -->Y 
,'00004584'
,'00004615'
,'00005219'
,'00005667'
,'00005919'
,'00007261'
,'00007520'
,'00008222'
,'00009166'
,'00009532'
,'00009757'
,'00099955'
,'00100686'
,'00101700'
,'00102591'
,'00103975'
,'00104188'
,'00105684'
,'00106497'
,'00106667'
,'00106728'
,'00109351'
,'00110153'
,'00110594'
,'00111399'
,'00112894'
,'00112913'
,'00114807'
,'00115985'
,'00116315'
,'00116328'
,'00116380'
,'00116435'
,'00116634'
,'00116773'
,'00118050'
,'00118335'
,'00121138'
,'00121200'
,'00125508'
,'00126081'
,'00126274'
,'00126382'
,'00126927'
,'00127350'
,'00128654'
,'00128726'
,'00129224'
,'00129633'
,'00130327'
,'00131048'
,'00131061'
,'00131065'
,'00131162'
,'00131174'
,'00131177'
,'00131190'
,'00131236'
,'00131452'
,'00132709'
,'00133766'
,'00133783'   --suspended -->Y
,'00134035'
,'00134373'
,'00134495'
,'00134759'
,'00135940'
,'00136084'  --suspended -->Y
,'00136191'  --suspended -->Y
,'00139237'
,'00139252'
,'00140013'
,'00140596'
,'00141597'
,'00141924'
,'00142536'
,'00142684'
,'00143892' --suspended -->Y
,'00145220'
,'00145587'
,'00146136'
,'00146159'
,'00147593'
,'00147810'
,'00148480'
,'00149523'
,'00151517'
,'00151548'
,'00151722'
,'00151770'
,'00152168'
,'00152560'
,'00152602'
,'00152695'
,'00152852'
,'00153853'
,'00154106'
,'00155335'
,'00155823'
,'00155870'
,'00156380'
,'00156391'
,'00157560'
,'00157666'
,'00157704'
,'00157716'
,'00158451'
,'00158816'
,'00160188'
,'00160831'
,'00161244'
,'00161417'
,'00161636'
,'00162377'
,'00162643'
,'00163358'
,'00163521'
,'00163737'
,'00166942'
,'00167495'
,'00169264'
,'00169544'
,'00171158'
,'00172122'
,'00172800'
,'00173526'
,'00174597'
,'00174606'
,'00176645'
,'00177960'
,'00178101' --suspended -->Y
,'00180426'
,'00180694'
,'00181063' --Blacklisted -->Y
,'00181101'
,'00181641'
,'00181751'
,'00181871'
,'00181925'
,'00182004' --suspended -->Y
,'00182490'
,'00182573'
,'00182651'
,'00183119'
,'00183398'
,'00184387'
,'00184873'
,'00185544'
,'00185553'
,'00185674'
,'00185739'
,'00186351'
,'00186647'
,'00186709'
,'00186751'
,'00187592'  --Blacklisted --> Y
,'00187649'
,'00187780'
,'00189101'
,'00189385'
,'00190145'
,'00190954'
,'00191430'
,'00192159'
,'00192326'
,'00192989'
,'00193578'
,'00193589'
,'00193599'
,'00193636'
,'00193760'
,'00193987'
,'00194025'
,'00194301'
,'00194409'
,'00194672'
,'00194760'
,'00195006'
,'00195024'
,'00196217'
,'00196422'
,'00197078'
,'00197319'
,'00197556'
,'00197886'
,'00197940'
,'00198168'
,'00198359'
,'00198490'
,'00199172'
,'00199314'
,'00199410'
,'00199684'
,'00199823'
,'00200426'
,'00200487'
,'00200924'
,'00201206'
,'00201305'
,'00202010'
,'00203508'
,'00204307'
,'00204472'
,'00204674'
,'00205074'
,'00205410'
,'00205565'
,'00205936'
,'00206448'
,'00207235'
,'00207406'
,'00207438'
,'00207476'
,'00207645'
,'00208190'
,'00208616'
,'00208781'
,'00208850'
,'00208928'
,'00209281'
,'00209301'
,'00209722'
,'00210484'
,'00210768'
,'00211022'
,'00211365'
,'00211418'
,'00211458'
,'00211541'
,'00212144'
,'00212472'
,'00213113'
,'00213428'
,'00213481'
,'00213571'
,'00213599'
,'00213669'
,'00213779'
,'00213958'
,'00214053'
,'00214157'
,'00214305'
,'00214393'
,'00214765'
,'00214866'
,'00215070'
,'00215364'
,'00215396'
,'00215518'
,'00215636'
,'00216395'
,'00216705'
,'00216832'
,'00217180'
,'00217409'
,'00217828'
,'00217879'
,'00217908'
,'00218237'
,'00218272'
,'00218639'
,'00218649'
,'00218682'
,'00218695'
,'00219280'
,'00219338'
,'00219548'
,'00219822'
,'00219979'
,'00220062'
,'00220132'
,'00220301'
,'00220476'
,'00220774'
,'00220847'
,'00220863'
,'00220943'
,'00221008'
,'00221025'
,'00221204'
,'00221380'
,'00221560'
,'00221575'
,'00222069'
,'00222155'
,'00222866'
,'00222930'
,'00223130'
,'00223663'
,'00223681'
,'00223763'
,'00224118'
,'00224238'
,'00224441'
,'00224468'
,'00224504'
,'00224680'
,'00224873'
,'00224891'
,'00225207'
,'00225213'
,'00225222'
,'00225237'
,'00225338'
,'00225518'
,'00225706'
,'00225710'
,'00225783'
,'00225852'
,'00225912'
,'00226310'
,'00226326'
,'00226330'
,'00226346'
,'00226405'
,'00226558'
,'00226632'
,'00226732'
,'00226805'
,'00226858'
,'00227242'
,'00227259'
,'00227416'
,'00227419'
,'00228252'
,'00228565'
,'00228732'
,'00229050'
,'00229075'
,'00229209'
,'00229362'
,'00229518'
,'00229650'
,'00229799'
,'00229818'
,'00229974'
,'00230047'
,'00230217'
,'00230246'
,'00230387'
,'00230466'
,'00230750'
,'00230821'
,'00230862'
,'00230890'
,'00231173'
,'00231276'
,'00231630'
,'00231894'
,'00231913'
,'00232279'
,'00232387'
,'00232407'
,'00232641'
,'00232789'
,'00232915'
,'00233110'
,'00233137'
,'00233264'
,'00233314'
,'00233538'
,'00233632'
,'00233752'
,'00233815'
,'00233823'
,'00233829'
,'00233893'
,'00233929'
,'00233976'
,'00234253'
,'00234428'
,'00234740'
,'00234744'
,'00234820'
,'00235335'
,'00235361'
,'00235472'
,'00235477'
,'00235659'
,'00235743'
,'00235812'
,'00235839'
,'00235892'
,'00236047'
,'00236133'
,'00236146'
,'00236461'
,'00236462'
,'00236561'
,'00236628'
,'00236747'
,'00236765'
,'00236891'
,'00236936'
,'00237127'
,'00237149'
,'00237177'
,'00237505'
,'00237586'
,'00237712'
,'00237939'
,'00238164'
,'00238714'
,'00238961'
,'00239208'
,'00239408'
,'00239664'
,'00239906'
,'00239909'
,'00240424'
,'00240797'
,'00240988'
,'00241015'
,'00241182'
,'00241195'
,'00241305'
,'00241339'
,'00241908'
,'00242060'
,'00242334'
,'00242532'
,'00242542'
,'00242584'
,'00242704'
,'00242778'
,'00242802'
,'00242851'
,'00242870'
,'00242947'
,'00242968'
,'00242974'
,'00242977'
,'00242996'
,'00243146'
,'00243235'
,'00243236'
,'00243338'
,'00243356'
,'00243393'
,'00243421'
,'00243497'
,'00243498'
,'00243554'
,'00243556'
,'00243633'
,'00243690'
,'00243696'
,'00243718'
,'00243728'
,'00243746'
,'00243816'
,'00243900'
,'00243941'
,'00243978'
,'00244019'
,'00244020'
,'00244025'
,'00244054'
,'00244098'
,'00244206'
,'00244350'
,'00244380'
,'00244452'
,'00244496'
,'00244516'
,'00244599'
,'00244607'
,'00244722'
,'00244867'
,'00244876'
,'00244888'
,'00245096'
,'00245110'
,'00245128'
,'00245163'
,'00245307'
,'00245381'
,'00245427'
,'00245585'
,'00245712'
,'00245733'
,'00245785'
,'00245829'
,'00246454'
,'00246564'
,'00246835'
,'00247140'
,'00247259'
,'00247268'
,'00247283'
,'00247345'
,'00247808'
,'00247842'
,'00247956'
,'00247972'
,'00247988'
,'00248003'
,'00248053'
,'00248102'
,'00248166'
,'00248186'
,'00248329'
,'00248336'
,'00248342'
,'00248402'
,'00248764'
,'00248768'
,'00248793'
,'00248984'
,'00249037'
,'00249052'
,'00249082'
,'00249125'
,'00249132'
,'00249210'
,'00249227'
,'00249247'
,'00249353'
,'00249370'
,'00249515'
,'00249520'
,'00249586'
,'00249591'
,'00249600'
,'00249666'
,'00249729'
,'00249744'
,'00249815'
,'00249955'
,'00250040'
,'00250047'
,'00250175'
,'00250207'
,'00250255'
,'00250293'
,'00250297'
,'00250334'
,'00250347'
,'00250414'
,'00250429'
,'00250646'
,'00250651'
,'00250690'
,'00250701'
,'00250721'
,'00250770'
,'00251036'
,'00251111'
,'00251236'
,'00251317'
,'00251347'
,'00251462'
,'00251561'
,'00251672'
,'00251709'
,'00251748'
,'00251811'
,'00251864'
,'00251980'
,'00252053'
,'00252080'
,'00252114'
,'00252152'
,'00252465'
,'00252483'
,'00252537'
,'00252567'
,'00252619'
,'00252649'
,'00252700'
,'00252750'
,'00252768'
,'00252823'
,'00252889'
,'00252983'
,'00252986'
,'00252987'
,'00253005'
,'00253126'
,'00253134'
,'00253146'
,'00253185'
,'00253208'
,'00253258'
,'00253290'
,'00253325'
,'00253329'
,'00253419'
,'00253519'
,'00253587'
,'00253626'
,'00253661'
,'00253676'
,'00253739'
,'00253742'
,'00253762'
,'00253769'
,'00253771'
,'00253827'
,'00253860'
,'00254020'
,'00254032'
,'00254232'
,'00254250'
,'00254342'
,'00254412'
,'00254438'
,'00254628'
,'00254670'
,'00254701'
,'00254716'
,'00254750'
,'00254923'
,'00254953'
,'00255016'
,'00255060'
,'00255104'
,'00255185'
,'00255186'
,'00255212'
,'00255376'
,'00255519'
,'00255623'
,'00255633'
,'00255703'
,'00255781'
,'00255824'
,'00255911'
,'00256051'
,'00256102'
,'00256122'
,'00256183'
,'00256210'
,'00256356'
,'00256373'
,'00256430'
,'00256520'
,'00256593'
,'00256622'
,'00257122'
,'00257276'
,'00257325'
,'00257509'
,'00257522'
,'00257620'
,'00257675'
,'00257683'
,'00257721'
,'00257724'
,'00257827'
,'00257963'
,'00257991'
,'00258019'
,'00258026'
,'00258047'
,'00258105'
,'00258144'
,'00258147'
,'00258198'
,'00258228'
,'00258265'
,'00258276'
,'00258316'
,'00258319'
,'00258542'
,'00258546'
,'00258655'
,'00258905'
,'00258963'
,'00259004'
,'00259011'
,'00259054'
,'00259079'
,'00259081'
,'00259154'
,'00259194'
,'00259235'
,'00259250'
,'00259283'
,'00259288'
,'00259301'
,'00259331'
,'00259395'
,'00259399'
,'00259453'
,'00259615'
,'00259679'
,'00259878'
,'00259896'
,'00259898'
,'00260029'
,'00260030'
,'00260038'
,'00260123'
,'00260130'
,'00260190'
,'00260317'
,'00260346'
,'00260492'
,'00260496'
,'00260511'
,'00260541'
,'00260638'
,'00260652'
,'00260751'
,'00260782'
,'00260790'
,'00260794'
,'00260818'
,'00260874'
,'00260923'
,'00260944'
,'00260992'
,'00261243'
,'00261460'
,'00261564'
,'00261979'
,'00262201'
,'00262392'
,'00262638'
,'00262810'
,'00262837'
,'00263097'
,'00263155'
,'00263202'
,'00263310'
,'00263604'
,'00263673'
,'00263707'
,'00263724'
,'00263748'
,'00264091'
,'00264409'
,'00264941'
,'00265115'
,'00265126'
,'00265829'
,'00266007'
,'00266128'
,'00266419'
,'00266616'
,'00266628'
,'00267026'
,'00267051'
,'00267324'
,'00267359'
,'00267452'
,'00267562'
,'00267655'
,'00267766'
,'00268111'
,'00268134'
,'00268219'
,'00268314'
,'00268606'
,'00268625'
,'00268920'
,'00268990'
,'00269120'
,'00269125'
,'00269212'
,'00269221'
,'00269358'
,'00269367'
,'00269553'
,'00269783'
,'00269811'
,'00269968'
,'00270263'
,'00270843'
,'00270868'
,'00270871'
,'00270898'
,'00270982'
,'00271005'
,'00271290'
,'00271352'
,'00271480'
,'00271692'
,'00271781'
,'00271851'
,'00271881'
,'00271971'
,'00272173'
,'00272175'
,'00272190'
,'00272206'
,'00272721'
,'00272766'
,'00272813'
,'00273173'
,'00273181'
,'00273223'
,'00273293'
,'00273479'
,'00273592'
,'00274050'
,'00274063'
,'00274214'
,'00274308'
,'00274321'
,'00274328'
,'00274414'
,'00274416'
,'00274841'
,'00275019'
,'00275024'
,'00275158'
,'00275229'
,'00275428'
,'00275538'
,'00275590'
,'00275593'
,'00275774'
,'00275820'
,'00275944'
,'00275954'
,'00276028'
,'00276063'
,'00276239'
,'00276289'
,'00276411'
,'00276446'
,'00276459'
,'00276505'
,'00276535'
,'00276552'
,'00276618'
,'00276697'
,'00276700'
,'00276756'
,'00276784'
,'00276916'
,'00276949'
,'00276983'
,'00277022'
,'00277083'
,'00277096'
,'00277122'
,'00277219'
,'00277225'
,'00277619'
,'00277804'
,'00277835'
,'00277886'
,'00277935'
,'00278140'
,'00278299'
,'00278308'
,'00278434'
,'00278451'
,'00278500'
,'00278594'
,'00278595'
,'00278639'
,'00278666'
,'00278713'
,'00278802'
,'00278830'
,'00278875'
,'00278902'
,'00279152'
,'00279243'
,'00279245'
,'00279531'
,'00279572'
,'00279690'
,'00279820'
,'00279840'
,'00279891'
,'00279954'
,'00280006'
,'00280039'
,'00280059'
,'00280246'
,'00280277'
,'00280380'
,'00280615'
,'00280709'
,'00280780'
,'00280895'
,'00281105'
,'00281266'
,'00281269'
,'00281294'
,'00281447'
,'00281479'
,'00281480'
,'00281513'
,'00281540'
,'00281571'
,'00281672'
,'00281687'
,'00281703'
,'00281755'
,'00281979'
,'00282083'
,'00282108'
,'00282232'
,'00282277'
,'00282331'
,'00282438'
,'00282624'
,'00282652'
,'00282668'
,'00282828'
,'00282904'
,'00282959'
,'00283018'
,'00283085'
,'00283114'
,'00283263'
,'00283427'
,'00283454'
,'00283737'
,'00283792'
,'00283862'
,'00283956'
,'00283976'
,'00284107'
,'00284195'
,'00284217'
,'00284369'
,'00284580'
,'00284634'
,'00284755'
,'00284783'
,'00284877'
,'00285035'
,'00285334'
,'00285418'
,'00285546'
,'00285584'
,'00285671'
,'00286249'
,'00286299'
,'00286358'
,'00286666'
,'00287165'
,'00287797'
,'00289309'
,'00289606'
,'00289631'
,'00289752'
,'00289941'
,'00290011'
,'00290298'
,'00290430'
,'00290454'
,'00290700'
,'00290726'
,'00290767'
,'00290773'
,'00290786'
,'00291101'
,'00291202'
,'00291206'
,'00291350'
,'00291351'
,'00291524'
,'00293396'
,'00294331'
,'00294571'
,'00294607'
,'00294815'
,'00294954'
,'00295032'
,'00295060'
,'00295213'
,'00295380'
,'00295466'
,'00295549'
,'00295624'
,'00295823'
,'00295842'
,'00296159'
,'00296568'
,'00296626'
,'00296876'
,'00297274'
,'00297299'
,'00297539'
,'00297794'
,'00297867'
,'00298094'
,'00298782'
,'00299792'
,'00300190'
,'00300448'
,'00300503'
,'00300521'
,'00300542'
,'00300911'
,'00301047'
,'00301186'
,'00301609'
,'00301689'
,'00303717'
,'00303835'
,'00303871'
,'00303894'
,'00304410'
,'00305122'
,'00305636'
,'00305644'
,'00306365'
,'00306507'
,'00306512'
,'00307173'
,'00307211'
,'00307293'
,'00307374'
,'00308528'
,'00308631'
,'00308653'
,'00308691'
,'00308715'
,'00308834'
,'00308878'
,'00308970'
,'00309144'
,'00309478'
,'00309609'
,'00309691'
,'00309692'
,'00309893'
,'00309925'
,'00310011'
,'00310180'
,'00310189'
,'00310262'
,'00310317'
,'00310542'
,'00311061'
,'00311239'
,'00311275'
,'00311291'
,'00311688'
,'00311925'
,'00311945'
,'00311948'
,'00311953'
,'00312181'
,'00312217'
,'00312296'
,'00312400'
,'00312431'
,'00312464'
,'00312605'
,'00312636'
,'00312876'
,'00313130'
,'00313140'
,'00313212'
,'00313224'
,'00313456'
,'00313508'
,'00313798'
,'00313820'
,'00313965'
,'00314101'
,'00314106'
,'00314267'
,'00314387'
,'00314474'
,'00314514'
,'00314573'
,'00314581'
,'00314703'
,'00314813'
,'00314926'
,'00314963'
,'00314997'
,'00314998'
,'00315016'
,'00315054'
,'00315120'
,'00315132'
,'00315185'
,'00315259'
,'00315288'
,'00315343'
,'00315399'
,'00315415'
,'00315522'
,'00315536'
,'00315560'
,'00315571'
,'00315631'
,'00315712'
,'00315742'
,'00315781'
,'00315836'
,'00315873'
,'00315938'
,'00316198'
,'00316290'
,'00316462'
,'00316491'
,'00316549'
,'00316557'
,'00316566'
,'00316613'
,'00316726'
,'00316746'
,'00316800'
,'00316806'
,'00316825'
,'00316944'
,'00317181'
,'00317195'
,'00317207'
,'00317252'
,'00317256'
,'00317503'
,'00317536'
,'00317668'
,'00317683'
,'00317814'
,'00317827'
,'00317952'
,'00318078'
,'00318127'
,'00318251'
,'00318351'
,'00318360'
,'00318466'
,'00318666'
,'00318669'
,'00318670'
,'00318714'
,'00318743'
,'00318767'
,'00318782'
,'00318830'
,'00318996'
,'00319072'
,'00319207'
,'00319482'
,'00319542'
,'00319772'
,'00319809'
,'00319977'
,'00320031'
,'00320147'
,'00320200'
,'00320352'
,'00320400'
,'00320438'
,'00320570'
,'00320658'
,'00320731'
,'00320830'
,'00321063'
,'00321106'
,'00321120'
,'00321127'
,'00321613'
,'00321804'
,'00321992'
,'00322375'
,'00322436'
,'00322523'
,'00322811'
,'00322917'
,'00322964'
,'00323396'
,'00323623'
,'00323871'
,'00323915'
,'00324000'
,'00324012'
,'00324129'
,'00324180'
,'00324216'
,'00324241'
,'00324383'
,'00324459'
,'00324463'
,'00324516'
,'00324544'
,'00324558'
,'00324628'
,'00324810'
,'00324872'
,'00325144'
,'00325146'
,'00325174'
,'00325240'
,'00325310'
,'00325366'
,'00325512'
,'00325528'
,'00325752'
,'00325754'
,'00325986'
,'00326099'
,'00326172'
,'00326173'
,'00326277'
,'00326433'
,'00326439'
,'00326591'
,'00326630'
,'00327116'
,'00327415'
,'00327490'
,'00327558'
,'00328073'
,'00328136'
,'00328175'
,'00328183'
,'00328280'
,'00328356'
,'00328359'
,'00328360'
,'00328595'
,'00328640'
,'00328675'
,'00328710'
,'00328711'
,'00328816'
,'00328859'
,'00328903'
,'00328904'
,'00328975'
,'00328990'
,'00329165'
,'00329187'
,'00329210'
,'00329285'
,'00329296'
,'00329297'
,'00329429'
,'00329468'
,'00329617'
,'00329628'
,'00329736'
,'00330003'
,'00330069'
,'00330231'
,'00330275'
,'00330336'
,'00330670'
,'00330692'
,'00330695'
,'00330699'
,'00330716'
,'00330997'
,'00331065'
,'00331211'
,'00331276'
,'00331337'
,'00331346'
,'00331353'
,'00331363'
,'00331418'
,'00331515'
,'00331715'
,'00331815'
,'00331904'
,'00331921'
,'00331922'
,'00332171'
,'00332453'
,'00332477'
,'00332478'
,'00332501'
,'00332544'
,'00332587'
,'00332666'
,'00332726'
,'00332799'
,'00332866'
,'00332887'
,'00333085'
,'00333208'
,'00333249'
,'00333300'
,'00333345'
,'00333410'
,'00333446'
,'00333562'
,'00333625'
,'00333909'
,'00334404'
,'00334428'
,'00334985'
,'00335173'
,'00335318'
,'00335825'
,'00335866'
,'00335974'
,'00336002'
,'00337026'
,'00338014'
,'00346276'
,'00347401'
,'00348018'
,'00349316'
,'00349776'
,'00349777'
,'00349930'
,'00350041'
,'00350042'
,'00350237'
,'00350526'
,'00350536'
,'00350587'
,'00350722'
,'00350926'
,'00351010'
,'00351070'
,'00351105'
,'00351219'
,'00351222'
,'00351235'
,'00351476'
,'00351633'
,'00351805'
,'00351943'
,'00351966'
,'00352008'
,'00352279'
,'00352512'
,'00352519'
,'00352865'
,'00352892'
,'00353231'
,'00353468'
,'00353502'
,'00353504'
,'00353581'
,'00353700'
,'00353777'
,'00353813'
,'00353947'
,'00353971'
,'00354099'
,'00354211'
,'00354243'
,'00354363'
,'00354573'
,'00354798'
,'00354977'
,'00355170'
,'00355184'
,'00355426'
,'00355478'
,'00355538'
,'00355548'
,'00355666'
,'00355769'
,'00355904'
,'00355912'
,'00355944'
,'00355982'
,'00356123'
,'00356301'
,'00356425'
,'00356756'
,'00356759'
,'00356928'
,'00357266'
,'00357312'
,'00357522'
,'00357829'
,'00357856'
,'00358049'
,'00358294'
,'00358357'
,'00358449'
,'00358490'
,'00358543'
,'00358826'
,'00359021'
,'00359151'
,'00359309'
,'00359402'
,'00359443'
,'00359763'
,'00359812'
,'00359883'
,'00360023'
,'00360902'
,'00361584'
,'00361679'
,'00361684'
,'00361695'
,'00362027'
,'00362142'
,'00362339'
,'00362924'
,'00362994'
,'00363049'
,'00363358'
,'00363508'
,'00363960'
,'00363979'
,'00364044'
,'00364365'
,'00364485'
,'00364488'
,'00364635'
,'00364809'
,'00365374'
,'00365570'
,'00365790'
,'00366319'
,'00366353'
,'00366397'
,'00366446'
,'00366542'
,'00366781'
,'00366835'
,'00367032'
,'00367166'
,'00367187'
,'00367596'
,'00367795'
,'00367841'
,'00367874'
,'00368335'
,'00368530'
,'00368985'
,'00369149'
,'00369445'
,'00369506'
,'00369578'
,'00369664'
,'00369743'
,'00369833'
,'00370005'
,'00370401'
,'00370856'
,'00371031'
,'00371136'
,'00371329'
,'00371424'
,'00371491'
,'00372056'
,'00372152'
,'00372315'
,'00372401'
,'00372532'
,'00372810'
,'00372983'
,'00373179'
,'00373212'
,'00373709'
,'00373805'
,'00373831'
,'00374217'
,'00374281'
,'00374360'
,'00374367'
,'00374721'
,'00374752'
,'00374858'
,'00374948'
,'00375022'
,'00375026'
,'00375034'
,'00375074'
,'00375165'
,'00375532'
,'00375769'
,'00375934'
,'00376155'
,'00376196'
,'00376490'
,'00376666'
,'00376747'
,'00376867'
,'00376898'
,'00377118'
,'00377421'
,'00377783'
,'00377896'
,'00378026'
,'00378402'
,'00378443'
,'00378518'
,'00378646'
,'00378649'
,'00378806'
,'00378896'
,'00379211'
,'00379304'
,'00380016'
,'00380475'
,'00380651'
,'00381500'
,'00381516'
,'00381771'
,'00382136'
,'00382174'
,'00382468'
,'00382525'
,'00382962'
,'00382986'
,'00383089'
,'00383231'
,'00383260'
,'00383281'
,'00383626'
,'00383779'
,'00384223'
,'00384247'
,'00384491'
,'00384834'
,'00384861'
,'00385289'
,'00385446'
,'00385447'
,'00385549'
,'00385647'
,'00386108'
,'00386323'
,'00386545'
,'00386597'
,'00386868'
,'00386875'
,'00387042'
,'00387254'
,'00387300'
,'00387395'
,'00387628'
,'00387689'
,'00387786'
,'00388447'
,'00388528'
,'00388533'
,'00388684'
,'00388813'
,'00388860'
,'00388899'
,'00389104'
,'00389327'
,'00389333'
,'00389364'
,'00389395'
,'00390328'
,'00390735'
,'00390836'
,'00391370'
,'00391503'
,'00392258'
,'00392568'
,'00392595'
,'00392946'
,'00393843'
,'00393861'
,'00394193'
,'00394329'
,'00394469'
,'00394499'
,'00394903'
,'00395182'
,'00395347'
,'00395449'
,'00395670'
,'00395746'
,'00395748'
,'00396067'
,'00396152'
,'00396431'
,'00396496'
,'00396509'
,'00396541'
,'00396826'
,'00396838'
,'00397007'
,'00397146'
,'00397364'
,'00397460'
,'00397482'
,'00397622'
,'00397862'
,'00398326'
,'00398437'
,'00398481'
,'00399225'
,'00399770'
,'00400553'
,'00400582'
,'00400958'
,'00400996'
,'00401147'
,'00401340'
,'00401700'
,'00401938'
,'00402435'
,'00402573'
,'00402874'
,'00402910'
,'00402926'
,'00403115'
,'00403154'
,'00403349'
,'00403716'
,'00403749'
,'00403839'
,'00404100'
,'00405024'
,'00405325'
,'00405449'
,'00405463'
,'00405909'
,'00406000'
,'00406037'
,'00406456'
,'00406922'
,'00407472'
,'00407631'
,'00407781'
,'00407912'
,'00408010'
,'00408251'
,'00408254'
,'00408307'
,'00409050'
,'00409585'
,'00410180'
,'00410990'
,'00411168'
,'00411907'
,'00411986'
,'00412303'
,'00412726'
,'00413056'
,'00413186'
,'00413579'
,'00414711')
ORDER BY 1