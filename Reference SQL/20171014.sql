-- Normal loan
select m.Balance,m.Limit, m.MainCode,m.BranchCode,lm.HasRepaySched,lm.DisburseFreq,act.CustTypeCode,lrs.* 
from Master m
left join LoanMaster lm on m.MainCode = lm.MainCode and m.BranchCode = lm.BranchCode
left join LoanRepaySched lrs on lm.MainCode = lrs.MainCode and lm.BranchCode = lrs.BranchCode
left join AcCustType act on m.MainCode = act.MainCode and m.BranchCode = act.BranchCode
where AcType
IN('30','31','32','33','36','37','38','39','3A','3B','3E','3F','3K','3L','3M','3N','3O','3P','3Q','3R','3S','3T','3U','3X','40','42','43','46','4A','4B','4F','4G','4I','4J','4K','4M','4O','4P','4Q','4S')
and Balance <> 0 and Limit <> 0
--and act.CustTypeCode = ''
and m.IsBlocked NOT IN ('C','o')
--and lm.HasRepaySched = 'T'-- and lm.HasDisburseSched = 'T'
--and lm.DisburseFreq <> 9
order by m.MainCode,m.BranchCode
--having CustTypeCode = ''
-- Deal Type loan
select m.MainCode,m.BranchCode,m.AcType,dt.ReferenceNo,dt.MaturityDate, det.Reference,act.CustTypeCode,pdl.* 
from Master m
left join DealTable dt on m.MainCode = dt.MainCode and m.BranchCode = dt.BranchCode
left join DependancyTable det on m.MainCode = det.MainCode and m.BranchCode = det.BranchCode
left join PastDuedList pdl on m.MainCode = pdl.ReferenceNo
left join AcCustType act on m.MainCode = act.MainCode and m.BranchCode = act.BranchCode
where  1 = 1
and m.AcType IN('3V','3Y','3Z','47','48','4C','4D','4E')
and dt.MaturityDate > GETDATE()
order by m.MainCode,m.BranchCode

select CASE WHEN IsBalnDue = 'T' THEN
	RIGHT(SPACE(17)+CAST(GoodBaln AS VARCHAR(17)),17)
 ELSE
	RIGHT(SPACE(17)+CAST(NormalInt AS VARCHAR(17)),17)
 END AS dmd_amt from PastDuedList pdl
left join Master m on pdl.ReferenceNo = m.MainCode and pdl.BranchCode = m.BranchCode
--left join DealTable dt on m.MainCode = dt.MainCode and m.BranchCode = dt.BranchCode

select * from DealTable dt left join PastDuedList pdl on dt.MainCode = pdl.ReferenceNo and dt.BranchCode = pdl.BranchCode

select * from ClientTable where ClientCode = '00242571'
select * from ClientTable where Name like '%Deepak%'
select * from Master where MainCode = '0010009471412'

-- 
select top 1 * from DependancyTable where MainCode = '001000000892F'
select distinct CustTypeCode from AcCustType
select top 1 RepayFreq from LoanMaster;
select top 1 * from LoanRepaySched
select top 1 * from Master;
select top 1 * from LoanMaster;
select * from CurrencyTable;
select top 100 * from PastDuedList where ReferenceNo='001000000023S';
select top 100 * from LoanRepaySched where MainCode='001000000023S';


select top 100 RepayStartDate from LoanMaster where HasRepaySched = 'T' and HasDisburseSched = 'T'

select AutoGenInt from LoanMaster;

select top 10 * from LoanMaster lm join Master m on lm.MainCode = m.MainCode and lm.BranchCode = m.BranchCode order by 1,2
select top 100 * from LoanRepaySched,ControlTable where MainCode='001000000014F' and DueDate > ControlTable.Today
select * from ControlTable

select top 100 lm.MainCode,lm.BranchCode,lm.HasRepaySched,m.IntCalcTypeDr,lrp.DueDate,lrp.DueInterest,lrp.DueIntOnInt,lrp.DuePenal,lrp.DuePrincipal,lrp.OutStdAmt,lrp.TotPayment
 from LoanMaster lm join Master m on lm.MainCode = m.MainCode and lm.BranchCode = m.BranchCode 
left join LoanRepaySched lrp on lm.MainCode = lrp.MainCode and lm.BranchCode = lrp.BranchCode and lm.HasRepaySched = 'T'
order by lm.MainCode,lm.BranchCode


select m.Balance,m.Limit, m.MainCode,m.BranchCode,lm.HasRepaySched,lm.DisburseFreq
from Master m
left join LoanMaster lm on m.MainCode = lm.MainCode and m.BranchCode = lm.BranchCode
where AcType
IN('30','31','32','33','36','37','38','39','3A','3B','3E','3F','3K','3L','3M','3N','3O','3P','3Q','3R','3S','3T','3U','3X','40','42','43','46','4A','4B','4F','4G','4I','4J','4K','4M','4O','4P','4Q','4S')
and m.Balance <> 0 and m.Limit <> 0
and m.IsBlocked NOT IN ('C','o')
order by m.MainCode,m.BranchCode

select cast(lm.MainCode as varchar(16)) from LoanMaster lm

declare @migrationdate as date = GETDATE()
--select top 1 @migrationdate,dateadd(day,-1,@migrationdate) newacopendate from Master;
SELECT CAST(REPLACE(CONVERT(VARCHAR,DATEADD(DAY,-1,@migrationdate),102),'.','') AS VARCHAR(8))

select replace(getdate(),'-','/')
select convert(varchar(10),getdate(),105)

select 
CAST(ReferenceNo AS VARCHAR(16)) AS foracid
,CONVERT(VARCHAR(10),DueDate,105) AS dmd_date
FROM PastDuedList

select top 1 * from Master m join CurrencyTable ct on m.CyCode = ct.CyCode;
select max(len(CyDesc)) from CurrencyTable;

select top 100 CONVERT(VARCHAR(10),DueDate,105) from PastDuedList where IsIntDue = 'F' order by ReferenceNo

select top 1 * from LoanMaster;