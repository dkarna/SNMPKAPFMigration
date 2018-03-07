-- Query for CC001
SELECT DISTINCT 
'CO' + t1.ClientCode AS CORP_KEY
,'CUSTOMER' AS ENTITY_TYPE
,t1.Name CORPORATENAME_NATIVE
,tmaster.mindate AS RELATIONSHIP_STARTDATE
,case when  ClientStatus='D' then 'DECEASED' 
WHEN ClientStatus='b' then 'BLACKLISTED' 
when ClientStatus='w' then 'WANTED' 
WHEN ClientStatus='L' then 'LUNATIC' 
WHEN ClientStatus='Z' then 'STOPPED' 
WHEN ClientStatus='s' then 'SUSPECTIVE' 
WHEN ClientStatus='u' then 'UNRELIABLE'
else 'NORMAL' end AS STATUS
,'CORPORATE' AS LEGALENTITY_TYPE
,CASE WHEN t2.Key_Risk_Grade LIKE 'L%' THEN 'LOW'
WHEN t2.Key_Risk_Grade IS NULL THEN 'LOW'
WHEN t2.Key_Risk_Grade LIKE 'M%' THEN 'MEDIUM'
WHEN t2.Key_Risk_Grade LIKE 'H%' THEN 'HIGH'
ELSE t2.Key_Risk_Grade
END AS SEGMENT
,CASE WHEN t2.Key_Risk_Grade like 'L%' THEN 'LOW'
WHEN t2.Key_Risk_Grade IS NULL THEN 'LOW'
WHEN t2.Key_Risk_Grade LIKE 'M%' THEN 'MEDIUM'
WHEN t2.Key_Risk_Grade LIKE 'H%' THEN 'HIGH'
END AS SUBSEGMENT
,t2.WebAddress AS WEBSITE_ADDRESS
,t3.Name AS KEYCONTACT_PERSONNAME
,'' AS PHONENO
,LEFT(t2.Phone,15) AS PHONECITYCODE
,SUBSTRING(t2.Phone,16,15) AS PHONELOCALCODE  -- to be asked
,'977' AS PHONECOUNTRYCODE
,'Remarks:' +Remarks ' /Telephone2:'+t2.MobileNo AS NOTES
,'NEPAL' AS PRINCIPLE_PLACEOPERATION
,'DEF_BUS_GROUP' AS BUSINESS_GROUP
,'' AS PRIMARYRM_ID
,'01-01-1900' AS DATE_OF_INCORPORATION
,'' AS DATE_OF_COMMENCEMENT
,tmaster.mindate AS PRIMARY_SERVICE_CENTER
,'DEF_USER' AS RELATIONSHIP_CREATEDBY
,'DEF_SECTOR' AS SECTOR
,'001' AS SUBSECTOR
,'PAN:'+isnull(CONVERT(VARCHAR, PANNumber, 120),0) AS TAXID
,'DEF_CLASS' AS ENTITYCLASS
,000 AS AVERAGE_ANNUALINCOME
,'BUSINESS' AS SOURCE_OF_FUNDS
,'' AS GROUP_ID
,'' AS GROUP_ID_CODE
,'' AS PARENT_CIF
,t2.Key_Risk_Grade AS CUSTOMER_RATING
,'' AS HEALTH_CODE
,'' AS RECORD_STATUS
,'' AS EFFECTIVE_DATE
,'' AS LINE_OF_ACTIVITY_DESC
,'' AS CUST_MGR_OPIN
,'' AS CUST_TYPE_DESC
,'' AS CUST_STAT_CHG_DATE
,'' AS TDS_TBL_DESC
,'' AS CUST_SWIFT_CODE -- need to ask
,'N' AS IS_SWIFT_CODE_OF_BANK -- need to ask
,'' AS CUSTDEPOSITSINOTHERBANKS
,'' AS TOTALFUNDBASE
,'' AS TOTALNONFUNDBASE
,'' AS ADVANCEASONDATE
,'' AS CUST_CONST
,'' AS DOCUMENT_RECEIVED_FLAG
,'NPR' AS CRNCY_CODE_CORPORATE
,'Y' AS TRADE_SERVICES_AVAILED
,t1.BranchCode AS PRIMARYSOLID
,'' AS CHRG_DR_FORACID
,'' AS CHRG_DR_SOL_ID
,'Y' AS CUST_CHRG_HISTORY_FLG
,999 AS TOT_TOD_ALWD_TIMES
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
,0 AS NUMBER1
,0 AS NUMBER2
,0 AS NUMBER3
,0 AS NUMBER4
,0 AS NUMBER5
,0 AS NUMBER6
,0 AS NUMBER7
,0 AS NUMBER8
,0 AS NUMBER9
,0 AS NUMBER10
,0 AS DECIMAL1
,0 AS DECIMAL2
,0 AS DECIMAL3
,0 AS DECIMAL4
,0 AS DECIMAL5
,0 AS DECIMAL6
,0 AS DECIMAL7
,0 AS DECIMAL9
,0 AS DECIMAL10
,0 AS DECIMAL8
,'' AS CORE_CUST_ID
,'' AS CIFID
,'' AS CREATEDBYSYSTEMID
,t2.Name AS CORPORATENAME_NATIVE1
,t2.Name AS SHORT_NAME_NATIVE1
,'' AS OWNERAGENT
,'DEF_PLOGIN_ID' AS PRIMARYRMLOGIN_ID
,'' AS SECONDARYRMLOGIN_ID
,'' AS TERTIARYRMLOGIN_ID
,'' AS ACCESSOWNERGROUP
,'' AS ACCESSOWNERSEGMENT
,'' AS ACCESSOWNERBC
,'' AS ACCESSOWNERAGENT
,'' AS ACCESSASSIGNEEAGENT
,'' AS PRIMARYPARENTCOMPANY
,'' AS COUNTRYOFPRINCIPALOPERATION
,'' AS PARENTCIF_ID
,'' AS CHARGELEVELCODE
,'NEPAL' AS COUNTRYOFORIGIN
,'NEPAL' AS COUNTRYOFINCORPORATION
,'' AS INTUSERFIELD1
,'' AS INTUSERFIELD2
,'' AS INTUSERFIELD3
,'' AS INTUSERFIELD4
,'' AS INTUSERFIELD5
,'M/S' AS STRUSERFIELD1
,'' AS STRUSERFIELD2
,'Y' AS STRUSERFIELD3
,'0016' AS STRUSERFIELD4
,'' AS STRUSERFIELD5 -- to be asked
,'Y' AS STRUSERFIELD6
,'' AS STRUSERFIELD7
,'' AS STRUSERFIELD8
,'' AS STRUSERFIELD9
,'' AS STRUSERFIELD10
,'' AS STRUSERFIELD11
,'' AS STRUSERFIELD12
,'' AS STRUSERFIELD13
,'N' AS STRUSERFIELD14
,'' AS STRUSERFIELD15 -- to be asked
,'NEPAL' AS STRUSERFIELD16
,'' AS STRUSERFIELD17
,'' AS STRUSERFIELD18
,'' AS STRUSERFIELD19
,'' AS STRUSERFIELD20
,'' AS STRUSERFIELD21
,'' AS STRUSERFIELD22
,'' AS STRUSERFIELD23
,'' AS STRUSERFIELD24
,'' AS STRUSERFIELD25
,'' AS STRUSERFIELD26  -- to be asked
,'NEPAL' AS STRUSERFIELD27
,'' AS STRUSERFIELD28
,'NPR' AS STRUSERFIELD29
,'' AS STRUSERFIELD30
,'' AS DATEUSERFIELD1
,'' AS DATEUSERFIELD2
,'' AS DATEUSERFIELD3
,'' AS DATEUSERFIELD4
,'' AS DATEUSERFIELD5
,'' AS NATIVELANGCODE
,'DEF_HEALTH_CODE' AS CUST_HLTH
,'' AS LASTSUBMITTEDDATE
,'' AS RISK_PROFILE_SCORE
,t2.Review_Date AS RISK_PROFILE_EXPIRY_DATE
,'' AS OUTSTANDING_MORTAGE
,t2.Name AS CORPORATE_NAME
,LEFT(t2.Name,10) AS SHORT_NAME
,t2.Name AS SHORT_NAME_NATIVE
,t2.ClientId AS REGISTRATION_NUMBER
,'' AS CHANNELSACCESSED
,'' AS ZIP
,'' AS BACKENDID
,'' AS DELINQUENCY_FLAG
,t2.ClientStatus AS SUSPEND_FLAG
,'' AS SUSPEND_NOTES
,'' AS SUSPEND_REASON
,t2.ClientStatus AS BLACKLIST_FLAG
,'' AS BLACKLIST_NOTES
,'' AS BLACKLIST_REASON
,'' AS NEGATIVE_FLAG
,'' AS NEGATIVE_NOTES
,'' AS NEGATIVE_REASON
,'' AS DSAID
,'DEF_ASSET_TYPE' AS CUSTASSET_CLASSIFICATION
,'' AS CLASSIFIED_ON
,'U' AS CUST_CREATION_MODE
,'' AS INCREMENTALDATEUPDATE
,'DEF_LANG_CODE' AS LANG_CODE
,'' AS TDS_CUST_ID
,'' AS OTHERLIMITS
,'' AS CORE_INTROD_CUST_ID
,t2.IntroducedBy AS INTROD_NAME
,'' AS INTROD_STAT_CODE
,'' AS ENTITY_STAGE
,'' AS ENTITY_STEP_STATUS
,t2.eMail AS EMAIL2
,'' AS CUST_GRP
,'' AS CUST_CONST_CODE
,'' AS CUSTASSET_CLSFTION_CODE
,'' AS LEGALENTITY_TYPE_CODE
,'' AS REGION_CODE
,'DEF_PRIORITY_CODE' AS PRIORITY_CODE
,'DEF_BUSTYPE_CODE' AS BUSINESS_TYPE_CODE
,'DEF_RELTYPE_CODE' AS RELATIONSHIP_TYPE_CODE
,'NPR' AS CRNCY_CODE
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
,'000' AS AMOUNT1
,'' AS AMOUNT2
,'' AS AMOUNT3
,'' AS AMOUNT4
,'' AS AMOUNT5
,'' AS INT1
,'' AS INT2
,'' AS INT3
,'' AS INT4
,'' AS INT5
,'' AS FLAG1
,'' AS FLAG2
,'' AS FLAG3
,'' AS FLAG4
,'' AS FLAG5
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
,'' AS UNIQUEGROUPFLAG
,'SNMANPKA' AS BANK_ID
,'' AS ZAKAT_DEDUCTION
,'' AS ASSET_CLASSIFICATION
,'' AS CUSTOMER_LEVEL_PROVISIONING
,'' AS ISLAMIC_BANKING_CUSTOMER
,'' AS PREFERREDCALENDAR
,t1.ClientCode AS IDTYPEC1
,'' AS IDTYPEC2
,'' AS IDTYPEC3
,'' AS IDTYPEC4
,'' AS IDTYPEC5
,'' AS IDTYPEC6
,'' AS IDTYPEC7
,'' AS IDTYPEC8
,'' AS IDTYPEC9
,'' AS IDTYPEC10
,'' AS CORPORATE_NAME_ALT1
,'' AS SHORT_NAME_ALT1
,'' AS KEYCONTACT_PERSONNAME_ALT1
,'' AS PARENT_CIF_ALT1
,'' AS BOCREATEDBYLOGINID
,'' AS SUBMITFORKYC
,'' AS KYC_REVIEWDATE
,'' AS KYC_DATE
,'' AS RISKRATING
,'' AS FOREIGNACCTAXREPORTINGREQ
,'' AS FOREIGNTAXREPORTINGCOUNTRY
,'' AS FOREIGNTAXREPORTINGSTATUS
,'' AS LASTFOREIGNTAXREVIEWDATE
,'' AS NEXTFOREIGNTAXREVIEWDATE
,'' AS FATCAREMARKS
,'' AS MLUSERFIELD11
,'' AS MLUSERFIELD12
,'' AS MLUSERFIELD13
,'' AS MLUSERFIELD14
,'' AS MLUSERFIELD15
,'' AS MLUSERFIELD16
,'' AS MLUSERFIELD17
,'' AS MLUSERFIELD18
,'' AS MLUSERFIELD19
,'' AS INT6
,'' AS INT7
,'' AS DATE6
,'' AS DATE7
,'' AS DATE8
,'' AS DATE9
,'' AS DATE10
FROM Master t1 JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode
LEFT JOIN 
(	-- Take the unique name on the basis of max sequence number
	select MainCode,Name from ImageTable where SeqNo  in(
	select max(SeqNo) as seq from ImageTable group by MainCode)
) as t3 ON t1.MainCode = t3.MainCode  -- need to be checked with bank data putting inner join
JOIN AcCustType t4 ON t1.BranchCode = t4.BranchCode and t1.MainCode = t4.MainCode -- need to be checked with bank data putting inner join
JOIN 
(							-- Filters the clientcode with minimum account open date
	SELECT t.ClientCode,MIN(t.AcOpenDate) AS mindate FROM Master t GROUP BY t.ClientCode 
) AS tmaster ON t1.ClientCode = tmaster.ClientCode AND tmaster.mindate = t1.AcOpenDate
WHERE IsBlocked NOT IN ('C','o')  -- Filters the closed or invalid or unapproved accounts
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = t1.MainCode and CustTypeCode = 'Z' and CustType NOT IN ('11','12')
)
ORDER BY CORP_KEY

 

