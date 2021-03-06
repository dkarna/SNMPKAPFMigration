-- Query for RC008

SELECT DISTINCT
'RO' + t1.ClientCode AS ORGKEY
,CASE WHEN MaritalStatus='N' THEN 'SNGLE' 
 WHEN MaritalStatus='S' THEN 'SNGLE' 
 WHEN MaritalStatus='D' THEN 'DVORC'  
 WHEN MaritalStatus='W' THEN 'WIDOW' 
 WHEN MaritalStatus='M' THEN 'MARRD' 
 ELSE 'DEFST' END AS MARITAL_STATUS_CODE
,CASE WHEN (ClientTag2 is null or ClientTag2=' ') THEN 'STAFF' 
 ELSE 'NON_STAFF' end AS EMPLOYMENT_STATUS
,'000' AS ANNUAL_SALARY_INCOME
,'' AS TDSEXCEMPTENDDATE
,'' AS TDSEXCEMPTSUBMITDATE
,'' AS TDSEXCEMPTREFNUM
,'' AS TDSEXCEMPTREMARKS
,'' AS CUSTCASTE
,'' AS CUSTBUSINESSASSETS
,'' AS CUSTPROPERTYASSETS
,'' AS CUSTINVESTMENTS
,'' AS CUSTNETWORTH
,'' AS CUSTDEPOSITSINOTHERBANKS
,'' AS ADVANCEASONDATE
,'' AS TOTALFUNDBASE
,'' AS TOTALNONFUNDBASE
,'' AS CUSTFINYEARENDMONTH
,CASE WHEN t2.CountryCode='01' THEN 'NPR' 
 WHEN t2.CountryCode='11' THEN 'INR' 
 WHEN t2.CountryCode='21' THEN 'USD' 
 WHEN t2.CountryCode='23' THEN 'AUD' 
 WHEN t2.CountryCode='32' THEN 'AUSTR' 
 else 'OTHER' END AS NATIONALITY_CODE
,'NPR' AS RESIDENCECOUNTRY_CODE
,'' AS NRERELATIVENAME
,'' AS NRECOUNTRYTYPE
,'' AS DEMOGRAPHICTYPE
,'NA' AS PHONE_HOME
,'NA' AS PHONE_WORK
,'NA' AS EXTENSION
,'NA' AS PHONE_CELL
,'NA' AS FAX_WORK
,'NA' AS EMAIL_HOME
,'NA' AS EMAIL_WORK
,'NA' AS EMAIL_PALM
,'NA' AS URL
,'' AS CUSTOMER_SEGMENT
,'' AS CUSTOMER_TYPE
,'' AS NATIONALITY
,'Nepal' AS RESIDENCE_COUNTRY
,'' AS RESIDENCE_SINCE
,CASE WHEN t2.MaritalStatus='N' THEN 'SINGLE' 
 WHEN t2.MaritalStatus='S' THEN 'SINGLE' 
 WHEN t2.MaritalStatus='D' THEN 'DIVORCED'  
 WHEN t2.MaritalStatus='W' THEN 'WIDOW' 
 WHEN t2.MaritalStatus='M' THEN 'MARRIED' 
 ELSE 'DEF_MARITAL_STATUS' END AS MARITAL_STATUS
,'' AS ANNIVERSARY_DATE
,'' AS INCOME_NATURE
,'' AS PAYMENT_MODE
,'' AS ANNUAL_RENTAL_INCOME
,'' AS ANNUAL_STOCK_BOND_INCOME
,'' AS ANNUAL_OTHERS_INCOME
,'' AS ANNUAL_TOTAL_INCOME
,'' AS REFERENCE_CURRENCY_INCOME
,'' AS BASE_CURRENCY_INCOME
,'' AS ANNUAL_OPERATING_EXP
,'' AS ANNUAL_LOAN_INSTAL
,'' AS ANNUAL_INTPROD_EXP
,'' AS ANNUAL_EXTPROD_EXP
,'' AS ANNUAL_COMMIT_EXP
,'' AS ANNUAL_OTHER_EXP
,'' AS REFERENCE_CURRENCY_EXP
,'' AS BASE_CURRENCY_EXP
,'' AS ANNUAL_TOTAL_EXP
,'NA' AS HOMEPHONENOCOUNTRYCODE
,'NA' AS HOMEPHONENOCITYCODE
,'NA' AS HOMEPHONENOLOCALCODE
,'NA' AS WORKPHONENOCOUNTRYCODE
,'NA' AS WORKPHONENOCITYCODE
,'NA' AS WORKPHONENOLOCALCODE
,'NA' AS CELLPHONENOCOUNTRYCODE
,'NA' AS CELLPHONENOCITYCODE
,'NA' AS CELLPHONENOLOCALCODE
,'NA' AS FAXNOCOUNTRYCODE
,'NA' AS FAXNOCITYCODE
,'NA' AS FAXNOLOCALCODE
,'NA' AS PAGERNO
,'NA' AS PAGERNOCOUNTRYCODE
,'NA' AS PAGERNOAREACODE
,'NA' AS PAGERNOLOCALCODE
,'' AS SALALLOWANCES
,'' AS SALPRORATAMONTHLYINCENTIVE
,'' AS SALINTERESTSUBSIDY
,'' AS SALOTHERINCOME2
,'' AS SALOTHERINCOME3
,'' AS TOTALESTACCOUNTVALUE
,'' AS TOTALINVESTMENT
,'' AS TOTALMONTHLYDEBTSERVICEAMT
,'' AS SELFEMPTAXRETURNFIELD
,'' AS SELFEMPGROSSRECIPTCURRENTYR
,'' AS SELFEMPGROSSRECEIPTPRIORYEAR
,'' AS SELFEMPNETPROFITCURRENTYR
,'' AS SELFEMPNETPROFITPRIORYR
,'' AS SELFEMPDEPRECIATIONCURRENTYEAR
,'' AS SELFEMPDEPRECIATIONPRIORYEAR
,'' AS SELFEMPAVERAGEANNUALTURNOVER
,'' AS TOTALHOUSEHOLDINCM
,'' AS DONOTMAILFLAG
,'' AS DONOTCALLFLAG
,'' AS HOLDMAILFLAG
,'' AS HOLDMAILDESCRIPTION
,'' AS DONOTSENDEMAILFLG
,'' AS HOLDMAILSTARTDATE
,'' AS HOLDMAILENDDATE
,'' AS PREFCONTTIME
,'' AS PREFDAYTIMECONTNO
,'' AS PREFDAYTIMECONTNOLOCAL
,'' AS PREFDAYTIMECONTNOAREA
,'' AS PREFDAYTIMECONTNOCOUNTRY
,'' AS PHONEOTHER
,'' AS PHONEOTHERLOCAL
,'' AS PHONEOTHERAREA
,'' AS PHONEOTHERCOUNTRY
,'' AS CU_ANNUAL_SALARY_INCOME
,'' AS CU_ANNUAL_RENTAL_INCOME
,'' AS CU_ANNUAL_STOCK_BOND_INCOME
,'' AS CU_ANNUAL_OTHERS_INCOME
,'' AS CU_ANNUAL_TOTAL_INCOME
,'' AS CU_ANNUAL_OPERATING_EXP
,'' AS CU_ANNUAL_LOAN_INSTAL
,'' AS CU_ANNUAL_INTPROD_EXP
,'' AS CU_ANNUAL_EXTPROD_EXP
,'' AS CU_ANNUAL_COMMIT_EXP
,'' AS CU_ANNUAL_OTHER_EXP
,'' AS CU_ANNUAL_TOTAL_EXP
,'' AS CU_SALALLOWANCES
,'' AS CU_SALPRORATAMONTHLYINCENTIVE
,'' AS CU_SALINTERESTSUBSIDY
,'' AS CU_SALOTHERINCOME2
,'' AS CU_SALOTHERINCOME3
,'' AS CU_TOTALESTACCOUNTVALUE
,'' AS CU_TOTALINVESTMENT
,'' AS CU_TOTALMONTHLYDEBTSERVICEAMT
,'' AS CU_SELFEMPTAXRETURNFIELD
,'' AS CU_SELFEMPGROSSRECIPTCURRENTYR
,'' AS CU_SELFEMPGROSSRECEIPTPRIORYR
,'' AS CU_SELFEMPNETPROFITCURRENTYR
,'' AS CU_SELFEMPNETPROFITPRIORYR
,'' AS CU_SELFEMPDEPRCURRYR
,'' AS CU_SELFEMPDEPRPRIORYR
,'' AS CU_SELFEMPAVGANNUALTURNOVER
,'' AS CU_TOTALHOUSEHOLDINCM
,'' AS CU_INVESTMENTSHARESANDUNITS
,'NA' AS USERFIELD1
,'NA' AS USERFIELD2
,'NA' AS USERFIELD3
,'NA' AS USERFLAG1
,'NA' AS USERFLAG2
,'NA' AS ALERT1
,'NA' AS ALERT2
,'NA' AS ALERT3
,'NA' AS ALERT4
,'NA' AS ALERT5
,'NA' AS BANK_DEFINED_DEMO_VAR1
,'NA' AS BANK_DEFINED_DEMO_VAR2
,'NA' AS BANK_DEFINED_DEMO_VAR3
,'NA' AS BANK_DEFINED_DEMO_VAR4
,'NA' AS BANK_DEFINED_DEMO_VAR5
,'NA' AS BANK_DEFINED_DEMO_VAR6
,'NA' AS BANK_DEFINED_DEMO_VAR7
,'NA' AS BANK_DEFINED_DEMO_VAR8
,'NA' AS BANK_DEFINED_DEMO_VAR9
,'NA' AS BANK_DEFINED_DEMO_DATE1
,'NA' AS BANK_DEFINED_DEMO_DATE2
,'NA' AS BANK_DEFINED_DEMO_DATE3
,'NA' AS BANK_DEFINED_DEMO_DATE4
,'NA' AS BANK_DEFINED_DEMO_DATE5
,'NA' AS BANK_DEFINED_DEMO_DATE6
,'NA' AS BANK_DEFINED_DEMO_DATE7
,'NA' AS USERFIELD4
,'NA' AS USERFIELD5
,'NA' AS USERFIELD6
,'' AS USERFIELD7        -- Need to be confirmed as marked in red color
,'NA' AS USERFIELD8
,'NA' AS USERFIELD9
,'NA' AS USERFIELD10
,'NA' AS AMOUNT1
,'NA' AS AMOUNT2
,'NA' AS AMOUNT3
,'NA' AS AMOUNT4
,'NA' AS AMOUNT5
,'NA' AS AMOUNT6
,'NA' AS AMOUNT7
,'NA' AS INTFIELD1
,'NA' AS INTFIELD2
,'NA' AS INTFIELD3
,'NA' AS INTFIELD4
,'NA' AS INTFIELD5
,'' AS TOTAL_DEDUCTIONS
,'' AS CU_TOTAL_DEDUCTIONS
,'' AS NET_SAVINGS
,'' AS CU_NET_SAVINGS
,'' AS NET_HOUSEHOLD_INCOME
,'' AS CU_NETHOUSEHOLDINCOME
,'' AS SHAREHOLDERTYPE
,'' AS SHAREHOLDEREFFECTIVEDATE
,'' AS TOTALSHARESVALUE
,'' AS CU_TOTALSHARESVALUE
,'' AS NUMBEROFSHARES
,'' AS CUSTOTHERBANKCODE
,'' AS CU_CUSTDEPOSITSINOTHERBANKS
,'' AS CU_CUSTBUSINESSASSETS
,'' AS CU_CUSTPROPERTYASSETS
,'' AS CU_CUSTINVESTMENTS
,'' AS CU_CUSTNETWORTH
,'NA' AS CUSTASSETSASONDATE
,'' AS CU_CUSTASSETSASONDATE
,'DEF_EMPLOYER' AS EMPLOYERSNAME    -- Need to be confirmed as marked in red
,'' AS SOURCEOFINCOME
,'' AS CU_TOTALFUNDBASE
,'' AS CU_TOTALNONFUNDBASE
,'' AS OTHERLIMITS
,'' AS CU_OTHERLIMITS
,'' AS TDSTABLECODE
,'' AS TDSTABLE
,'' AS TDSCUSTID
,'' AS EMPLOYERID
,'' AS NRERELATIVECODE
,'' AS NRERELATIVE
,'NA' AS EMPLOYERID_CODE
,'' AS CHANNELSACCESSED
,'' AS OUTSTANDING_MORTAGE
,'' AS CU_OUTSTANDING_MORTGAGE
,'SNMANPKA' AS BANK_ID
,'NA' AS EMPLOYERSNAME_ALT1
,'NA' AS NRERELATIVENAME_ALT1
,'' AS TAX_EXMPT_START_DATE
,'' AS TAX_RATE_TABLE_CODE
,'' AS NO_TAX_RECAL_BEYOND_DATE
FROM Master t1 JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode
WHERE t1.IsBlocked NOT IN ('C','o')  -- Filters the closed or invalid or unapproved accounts
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = t1.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
)
ORDER BY ORGKEY