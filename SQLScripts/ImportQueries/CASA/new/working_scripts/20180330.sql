--select count(*) from CheqBundleStat
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

	select * from #tempChequeInven where MainCode='001000000014H' order by MainCode,BranchCode,ChequeNo

	-- 0000166984

--0001497121

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
select * from #nNewChequeNum where MainCode='0010001053607' order by ChequeNo

--select * from #dnNewChequeNum where MainCode='0010001053607' order by BundleNum
--,RowNum,nRowNum
--drop table #dnNewChequeNum
select MainCode,BranchCode,ChequeNo,BundleNum 
into #dnNewChequeNum
from #nNewChequeNum 
where  1 = 1
--and MainCode='0010001053607' 
and nRowNum=1 order by MainCode,BranchCode,BundleNum,RowNum,nRowNum 

select count(*) from #dnNewChequeNum  -- 180628

-- store the existing data from ChequeBundleStat into first temp table

select * into #tCheqBundleStat1 from CheqBundleStat   -- 175595

select * from #tCheqBundleStat1 where MainCode='0010001053607' order by BundleNo
select * from #dnNewChequeNum where MainCode='0010001053607' order by ChequeNo

--select * 
update tcbs1 set BeginCheqNo=dncn.ChequeNo
from CheqBundleStat tcbs1
join #dnNewChequeNum dncn on dncn.MainCode=tcbs1.MainCode and dncn.BranchCode=tcbs1.BranchCode and dncn.BundleNum=tcbs1.BundleNo

select * from CheqBundleStat where MainCode='001000000014H' 
order by BundleNo

select * from #tCheqBundleStat2 where MainCode='001000000014H' 
order by BundleNo

-- store the existing data from ChequeBundleStat into second temp table

select * into #tCheqBundleStat2 from CheqBundleStat 


--select * from #NewChequeNum order by MainCode,BranchCode,RowNum


-- 
 select * from #NewChequeNum where MainCode='0010001053607' order by BundleNum
 select * from CheqBundleStat where MainCode='0010001053607' order by BundleNo

 select distinct MainCode,BranchCode,min(ChequeNo) as mincheckno,BundleNum from #NewChequeNum ncm where ncm.MainCode='0010001053607'
 group by MainCode,BranchCode,ChequeNo,BundleNum order by MainCode,BranchCode,BundleNum

--SELECT	 ci.MainCode
--		,ci.BranchCode
--		,ci.ChequeNo
--		,ci.CheqStatus
--		,ROW_NUMBER() OVER (PARTITION BY ci.MainCode, ci.BranchCode ORDER BY ci.MainCode, ci.BranchCode ) RowNum
--INTO #NewChequeNum
--FROM ChequeInven ci
--join Master M on M.MainCode=ci.MainCode and M.BranchCode=ci.BranchCode
--WHERE LEN(ci.ChequeNo) = 10
--AND LEN(ci.MainCode) >= 8
--order by ci.MainCode,ci.BranchCode,ci.ChequeNo

--select * from #NewChequeNum where MainCode='001000000014H' and BranchCode='001' order by ChequeNo

--drop table #ChequePartition
SELECT MainCode, BranchCode, COUNT(ChequeNo) as ChqCount,
case when count(ChequeNo)%100 = 0 then (count(ChequeNo)/100)
else (COUNT(ChequeNo)/100)+1 end as [Partition], 
ROW_NUMBER () OVER(Order by MainCode, BranchCode) as RNo
INTO  #ChequePartition
FROM #NewChequeNum
--WHERE MainCode = '0010001044501'
GROUP BY MainCode, BranchCode

--select * from #ChequePartition where Partition > 1 order by [Partition]
--select * from #ChequePartition where ChqCount = 1400

--update #ChequePartition set [Partition] = ChqCount / 100
----select *,ChqCount / 100 as [part] from #ChequePartition
--where ChqCount % 100 = 0 

--update #ChequePartition set [Partition]=1 where ChqCount=100

select top 1 * from #NewChequeNum

select distinct MainCode,BranchCode from ChequeInven
where len(MainCode) >= 8
and len(ChequeNo) = 10