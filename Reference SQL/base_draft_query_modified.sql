SELECT DISTINCT 
'CO' + t1.ClientCode AS CORP_KEY
,'CUSTOMER' AS ENTITY_TYPE
,t1.Name CORPORATENAME_NATIVE
,tmaster.mindate AS RELATIONSHIP_STARTDATE
,CASE WHEN  t2.ClientStatus='D' THEN 'DECEASED' 
WHEN t2.ClientStatus='b' THEN 'BLACKLISTED' 
when t2.ClientStatus='w' THEN 'WANTED' 
WHEN t2.ClientStatus='L' THEN 'LUNATIC' 
WHEN t2.ClientStatus='Z' THEN 'STOPPED' 
WHEN t2.ClientStatus='s' THEN 'SUSPECTIVE' 
WHEN t2.ClientStatus='u' THEN 'UNRELIABLE'
ELSE 'NORMAL' END AS STATUS
,'CORPORATE' AS LEGALENTITY_TYPE
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
FROM Master t1  JOIN ClientTable t2 ON t1.ClientCode = t2.ClientCode
JOIN AcCustType t4 ON t1.MainCode = t4.MainCode 
JOIN 
(							-- Filters the clientcode with minimum account open date
	SELECT t.ClientCode,MIN(t.AcOpenDate) AS mindate FROM Master t GROUP BY t.ClientCode 
) AS tmaster ON t1.ClientCode = tmaster.ClientCode AND tmaster.mindate = t1.AcOpenDate
WHERE t2.IsBlocked NOT IN ('C','o')  -- Filters the closed or invalid or unapproved accounts
AND 
EXISTS
 (     -- Filters only the corporate client
	 SELECT 1 FROM AcCustType WHERE MainCode = t1.MainCode  and CustTypeCode = 'Z' and CustType NOT IN ('11','12')
 )
 ORDER BY CORP_KEY
 
 
 ----- Query for name split
 
 select case when charindex('/',t.Name) = 0 then 
		(left( t.Name, CHARINDEX(' ', t.Name))) 
     else 
	     t.Name
	end as fname,
	CASE WHEN charindex('/',t.Name) = 0 then 
		''
	else
		t.Name
	end as mname,
	case when charindex('/',t.Name) = 0 then 
		(right( t.Name, CHARINDEX(' ', reverse(t.Name)))) 
     else 
	     t.Name
	end as lname,
	t.Name
from ClientExtraDetail t

---------------------------------------------
-- Test query for creating temporary table type
DECLARE @Heroes TABLE (
    [HeroName]      VARCHAR(20)
)

INSERT INTO @Heroes ( [HeroName] )
VALUES ( 'Superman A' ), ( NULL ), ('Ironman I'), ('Wolverine W')

-- select * from @Heroes;



-- A query to segregate firstname, middlename and lastname
DECLARE @name varchar(100)='Ram Sharma'

SELECT FName, REPLACE(REPLACE(@name,FName,' '),LName,' ') as MName,LName  -- separating middlename by replacing firstname and middlename by ' '
FROM
    (
        SELECT substring(@name,1,charindex(' ',@name)) as FName,     -- Separating firstname and lastname
        Reverse(substring(Reverse(@name),1,charindex(' ',Reverse(@name)))) as LName
    ) a


	-- select top 10 * from ClientTable
	-- Test query to check the date difference
	DECLARE @date varchar(20) =  '09/25/2000'
	select DATEDIFF(YEAR,GETDATE(),'2000-09-25') as newdate 
	--select datediff(CONVERT(varchar,@date,102),GETDATE(),MONTH) as newdate

	-- select distinct Key_Risk_Grade from ClientTable

	-- select MainCode,count(MainCode) as maincode from ImageTable group by MainCode order by 2 desc;

	-- Stuffing example query
	SELECT STUFF((SELECT '|' + 
	case when [HeroName] is not null then
	substring([HeroName],1,charindex(' ',[HeroName]))
	else ''
	end 
			  FROM @Heroes
			  -- ORDER BY [HeroName]
			  FOR XML PATH('')), 1, 1, '') AS [FName]

	select * from ImageTable where MainCode='00100419SS'
	
	--check the length of merged names from image table for CC001
	select len(STUFF((select '|' + Name FROM ImageTable where MainCode = '00100419SS' FOR XML PATH('')), 1, 1, '')) 
	-- probable storage in STR12

	-- select Telephone2 from ClientTable;

	-- select distinct Remarks from ClientTable;

	select ISDATE('12/25/2017')  -- mm/dd/yyyy check whether the date is valid or not. valid date returns 1 else 0
	
	-------------------
	-- Query to check multiple values in Sector and Subsector
	select t.ClientCode, count(*) as counts--, t.Sector,t.SubSector
from
(
select DISTINCT M.ClientCode,
'Sector'=(select A.CustType from AcCustType A where A.MainCode=M.MainCode and A.CustTypeCode='B'),
'SubSector'=(select A.CustType from AcCustType A where A.MainCode=M.MainCode and A.CustTypeCode='Z'),
M.TaxPercentOnInt
from Master M where M.AcType<'50'
and M.IsBlocked not in ('C','o')
--order by 1
)
as t
where t.Sector IS NOT NULL and t.SubSector IS NOT NULL and t.SubSector NOT in('11','12') and t.TaxPercentOnInt != 5
GROUP by t.ClientCode
having count(*) > 1
order by 2 desc

-----------------------------------
-- Logic for generation of Sector and Subsector
select

DISTINCT M.ClientCode,

'Sector'=(select A.CustType from AcCustType A where A.MainCode=M.MainCode and A.CustTypeCode='B') ,

'SubSector'=(select A.CustType from AcCustType A where A.MainCode=M.MainCode and A.CustTypeCode='Z'),
case when M.TaxPercentOnInt = 5 then 'Individual'
Else 'Institutional'
END as taxrateseparator

from Master M where M.AcType<'50'

and M.IsBlocked not in ('C','o')

order by 1