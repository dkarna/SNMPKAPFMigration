select top 10 * from ClientTable where (Phone = '' or Phone is null) and MobileNo is null;

select count(*) from ClientTable where (Phone = '' or Phone is null) and MobileNo is null;

select ClientCode,
case when Phone <> '' or Phone is not null then 'P'
when MobileNo is not null then 'M'
when eMail is not null then 'E'
else 'NA'
END as PHONEOREMAIL
 from ClientTable;

 select 'Mobile No- '+MobileNo+'/'+'Phone No- '+Phone+'/'+'Email - '+eMail+'/'+'Fax No- '+FaxNo
 from ClientTable

 select 
 CASE WHEN MaritalStatus='N' THEN 'SINGLE' 
 WHEN MaritalStatus='S' THEN 'SINGLE' 
 WHEN MaritalStatus='D' THEN 'DIVORCED'  
 WHEN MaritalStatus='W' THEN 'WIDOW' 
 WHEN MaritalStatus='M' THEN 'MARRIED' 
 ELSE 'DEF_MARITAL_STATUS' END AS MARITAL_STATUS FROM ClientTable

 select case when MaritalStatus='N' then 'SINGLE' 
 WHEN MaritalStatus='S' then 'SINGLE' 
 when MaritalStatus='D' then 'DIVORCED'  
 when MaritalStatus='W' then 'WIDOW' 
 when MaritalStatus='M' then 'MARRIED' 
 else 'DEF_MARITAL_STATUS' end 
 from ClientTable

 select distinct MaritalStatus from ClientTable;

 SELECT 
 CASE WHEN (ClientTag2 is null or ClientTag2=' ') THEN 'STAFF' 
 ELSE 'NON_STAFF' end AS EMPLOYMENT_STATUS
 FROM ClientTable

 select ClientCode,
 CASE WHEN CountryCode='01' THEN 'NEPALESE' 
 WHEN CountryCode='11' THEN 'INDIAN' 
 WHEN CountryCode='21' THEN 'AMERICAN' 
 WHEN CountryCode='23' THEN 'AUSTRALIAN' 
 WHEN CountryCode='32' THEN 'AUSTRIAN' 
 else 'OTHERS' END AS NATIONALITY
 FROM ClientTable



  select 
  'FirstName'=
  (LEFT(Name, CHARINDEX(' ', Name))) 
  from ClientTable where ClientCode in 
  (select ClientCode from Master where MainCode in (select MainCode from AcCustType where CustTypeCode='Z' and CustType in ('11','12')))