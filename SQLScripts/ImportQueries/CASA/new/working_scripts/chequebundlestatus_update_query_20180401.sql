-- Cheque pre-processing

--drop table #tempChequeInven

select ci.MainCode
			,ci.BranchCode
			,ci.ChequeNo
	into #tempChequeInven
	from ChequeInven ci 
	join Master M on M.MainCode=ci.MainCode and M.BranchCode=ci.BranchCode
	WHERE LEN(ci.ChequeNo) = 10
	AND LEN(ci.MainCode) >= 8
	order by ci.MainCode,ci.BranchCode,ci.ChequeNo

--select * from #tempChequeInven where MainCode='001000000014H'
--drop table #NewChequeNum
select nci.MainCode
,nci.BranchCode
,nci.ChequeNo 
,0 as BundleNum
,ROW_NUMBER() OVER (PARTITION BY nci.MainCode, nci.BranchCode ORDER BY nci.MainCode, nci.BranchCode,nci.ChequeNo ) RowNum
INTO #NewChequeNum
from
#tempChequeInven nci order by nci.MainCode,nci.BranchCode,nci.ChequeNo

--select * from #NewChequeNum  where MainCode='0010001053607' order by ChequeNo

update #NewChequeNum set BundleNum = (case when ncm.RowNum % 100 = 0 then (ncm.RowNum / 100) else ((ncm.RowNum / 100)+1) end)
from #NewChequeNum ncm

--drop table #nNewChequeNum
select ncm.MainCode,ncm.BranchCode,ncm.ChequeNo,ncm.BundleNum,ncm.RowNum,
ROW_NUMBER() over (partition by ncm.MainCode,ncm.BranchCode,ncm.BundleNum order by ncm.MainCode,ncm.BranchCode,ncm.BundleNum) as nRowNum
into #nNewChequeNum
from #NewChequeNum ncm order by ncm.MainCode,ncm.BranchCode,ncm.ChequeNo
--

--select * from #nNewChequeNum where MainCode='0010001053607' order by ChequeNo

select MainCode,BranchCode,ChequeNo,BundleNum 
into #dnNewChequeNum
from #nNewChequeNum 
where  1 = 1
--and MainCode='0010001053607' 
and nRowNum=1 order by MainCode,BranchCode,BundleNum,RowNum,nRowNum

update tcbs1 set BeginCheqNo=dncn.ChequeNo
from CheqBundleStat tcbs1
join #dnNewChequeNum dncn on dncn.MainCode=tcbs1.MainCode and dncn.BranchCode=tcbs1.BranchCode and dncn.BundleNum=tcbs1.Dummy