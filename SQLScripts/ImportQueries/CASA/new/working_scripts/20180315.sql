--drop table #newchequeinven
select ci.MainCode,ci.BranchCode,ci.ChequeNo,
case when ci.CheqStatus = 'I' then 'P'
when ci.CheqStatus = 'Z' then 'I'
when ci.CheqStatus = 'S' then 'S'
when ci.CheqStatus = 'D' then 'D'
when ci.CheqStatus = 'R' then 'D'
when ci.CheqStatus = 'C' then 'D'
when ci.CheqStatus = 'V' then 'U'
end chq_lvs_stat  
,ROW_NUMBER() over(partition by ci.MainCode,ci.BranchCode order by ci.MainCode,ci.BranchCode) as rownum
into #newchequeinven
 from ChequeInven ci 
 join Master M on M.MainCode=ci.MainCode and M.BranchCode=ci.BranchCode
 where len(ci.ChequeNo)=10 and len(ci.MainCode) >= 8 
 order by ci.MainCode,ci.BranchCode  -- step 1 to generate a temp table with proper cheque status and rownum

-- select * from #newchequeinven --order by MainCode,BranchCode

-- query script to stuff the column values to a single column
 --select t.MainCode,len(t.Cheques) as cheqlen from
 --(
 
	--  where 1=1
	  --and p1.rownum >= 1 and p1.rownum <=100
	  --and MainCode='001000000210L'
      --GROUP BY MainCode 
	  --) as t

	  select * into #tempchqlvstat from (
	  select ci.MainCode,ci.chq_lvs_stat, ROW_NUMBER() over (partition by MainCode order by ci.MainCode) as rn from #newchequeinven ci
	  ) T1

	  --drop table #chqpartitions
	  select MainCode,BranchCode,count(*) as lvscount,(count(*)/100)+1 as partitions into #chqpartitions from #newchequeinven
	  where len(ChequeNo)=10 and len(MainCode)>=8
	   group by MainCode,BranchCode order by count(*) desc

	  select * from #chqpartitions order by 3 desc
	  
	select MainCode,BranchCode,max(partitions) as tpartitions into #morechqpartitions from #chqpartitions where partitions >1 group by MainCode,BranchCode order by 2 
	--select top 1 * from #morechqpartitions
	--select top 1 * from #newchequeinven
	--select top 1 * from #lesschqpartitions

	--select MainCode,BranchCode,count(*) from #lesschqpartitions lcp group by lcp.MainCode,lcp.BranchCode order by count(*) desc
	-- drop table #lesschqpartitions
	--drop table #finalstuffedoutput
	create table #finalstuffedoutput
	(
		MainCode varchar(20),
		BranchCode varchar(3),
		lvstatstf varchar(105)
	);

	Create table #tempchqwithlvsstat
	(
		MainCode varchar(20),
		BranchCode varchar(3),
		cheqlvstat char(1)
	);

	Create table #lesschqpartitions
	(
		RowID int identity(1,1),
		MainCode varchar(20),
		BranchCode varchar(3),
		partitions int
	);

	truncate table #finalstuffedoutput
	Declare @NumberRecords int, @RowCount int
	Declare @MainCode varchar(20), @BranchCode varchar(3),@partitions int
	truncate table #lesschqpartitions
	--select * from #lesschqpartitions
	
	insert into #lesschqpartitions
	select top 20 MainCode,BranchCode,max(partitions) as tpartitions from #chqpartitions where partitions=1 group by MainCode,BranchCode order by 2;
	
	set @NumberRecords=@@ROWCOUNT	
	--print @NumberRecords
	set @RowCount=1
	
	while @RowCount <= @NumberRecords
	begin
		truncate table #tempchqwithlvsstat -- truncate the temporary table to store new batch of data
		select @MainCode=MainCode,@BranchCode=BranchCode from #lesschqpartitions where RowID=@RowCount
		--print 'MainCode: ' + @MainCode + ' BranchCode: ' +@BranchCode
		--select * from #tempchqwithlvsstat
		insert into #tempchqwithlvsstat
		select MainCode,BranchCode,chq_lvs_stat from #newchequeinven where MainCode=@MainCode and BranchCode=@BranchCode
		print @MainCode + ':' + @BranchCode
		--select * from #newchequeinven
		-- logic to stuff and insert into new temp table
			insert into #finalstuffedoutput
			SELECT distinct p1.MainCode,BranchCode,
			stuff( (SELECT cheqlvstat 
               FROM #tempchqwithlvsstat p2
               WHERE p2.MainCode = p1.MainCode
			   and p2.BranchCode=p1.BranchCode
			   --and p2.rownum >= 1 and p2.rownum <=100
               ORDER BY cheqlvstat
               FOR XML PATH(''), TYPE).value('.', 'varchar(max)')
            ,1,0,'')
       AS lvstatstf
      FROM #tempchqwithlvsstat p1

		set @RowCount=@RowCount+1
	end


	

	select * from #finalstuffedoutput --where MainCode='001000000014L' and BranchCode='001'  -- max(len(lvstatstf))

	--select max(len(lvstatstf)) from #finalstuffedoutput where MainCode='001000000014L' and BranchCode='001'

	--select * from #newchequeinven where MainCode='001000000030V' and BranchCode='001'

	--select * from #newchequeinven where MainCode='001000000014L' and BranchCode='001'