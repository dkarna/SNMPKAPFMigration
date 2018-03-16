select * from ChequeInven where MainCode='0010000000101' order by 2,3

select MainCode,Min(ChequeNo) as mincheque from ChequeInven group by MainCode
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
 from ChequeInven ci order by ci.MainCode,ci.BranchCode

 select * from #newchequeinven --order by MainCode,BranchCode

 select * from ChequeInven where MainCode = '001000000210L'
 select top 1 * from #newchequeinven
 select count(*) from #newchequeinven where MainCode = '001000000210L'
 select t.MainCode,len(t.Cheques) as cheqlen from
 (
 SELECT p1.MainCode,min(p1.ChequeNo) as minchequeno,max(p1.ChequeNo) as maxchequeno,
       stuff( (SELECT chq_lvs_stat 
               FROM #newchequeinven p2
               WHERE p2.MainCode = p1.MainCode
			   and p2.rownum >= 1 and p2.rownum <=100
               ORDER BY chq_lvs_stat
               FOR XML PATH(''), TYPE).value('.', 'varchar(max)')
            ,1,1,'')
       AS Cheques
      FROM #newchequeinven p1
	  where 1=1
	  --and p1.rownum >= 1 and p1.rownum <=100
	  and MainCode='001000000210L'
      GROUP BY MainCode 
	  ) as t

	  select * into #tempchqlvstat from (
	  select ci.MainCode,ci.chq_lvs_stat, ROW_NUMBER() over (partition by MainCode order by ci.MainCode) as rn from #newchequeinven ci
	  ) T1

	  select * from #tempchqlvstat order by 1,3 offset 100 rows
	  select MainCode,max(rn) as maxrn from #tempchqlvstat group by MainCode order by MainCode
	  --drop table #chqpartitions
	  select MainCode,BranchCode,count(*) as lvscount,(count(*)/100)+1 as partitions into #chqpartitions from #newchequeinven
	  where len(ChequeNo)=10 and len(MainCode)>=8
	   group by MainCode,BranchCode order by count(*) desc

	  select * from #chqpartitions order by 3 desc
	  



	  select MainCode,count(*) from ChequeInven
	  --where rn%2=0

	select MainCode,BranchCode,max(partitions) as tpartitions into #morechqpartitions from #chqpartitions where partitions >1 group by MainCode,BranchCode order by 2 
	select MainCode,BranchCode,max(partitions) as tpartitions into #lesschqpartitions from #chqpartitions where partitions=1 group by MainCode,BranchCode order by 2
	
	select top 1 * from #morechqpartitions
	select top 1 * from #newchequeinven
	select top 1 * from #lesschqpartitions

	--select * from #newchequeinven where MainCode='003000029760J' and BranchCode='003'
	declare @tempchequeinven as table
	(
		MainCode varchar(20),
		BranchCode varchar(3),
		chq_lvs_stat char(1),
		rownum int
	)

	declare @lesspartitionstuff as table
	(
		MainCode varchar(20),
		BranchCode varchar(3),
		chqstat varchar(100)
	)

	Declare @partition_cursor as cursor;
	set @partition_cursor = cursor for
	select distinct top 1000  MainCode,BranchCode from #lesschqpartitions;
	declare @MainCode varchar(20),@BranchCode varchar(3);

	open @partition_cursor;
	fetch next from @partition_cursor into @MainCode,@BranchCode;

	while @@FETCH_STATUS=0
	Begin
		print 'MainCode: ' + convert(varchar,@MainCode) + ' BranchCode: ' + convert(varchar,@BranchCode)

		insert into @tempchequeinven(MainCode,BranchCode,chq_lvs_stat,rownum)
		select distinct top 1000 MainCode,BranchCode,chq_lvs_stat,rownum from #newchequeinven where MainCode=@MainCode and BranchCode=@BranchCode 
		order by MainCode,BranchCode,rownum
		

		------------logic for stuffing
		insert into @lesspartitionstuff(MainCode,BranchCode,chqstat)
		 SELECT p1.MainCode,p1.BranchCode,
       stuff( (SELECT chq_lvs_stat 
               FROM @tempchequeinven p2
               WHERE p2.MainCode = p1.MainCode
			   and p2.BranchCode=p1.BranchCode
			   --and p2.rownum >= 1 and p2.rownum <=100
               ORDER BY chq_lvs_stat
               FOR XML PATH(''), TYPE).value('.', 'varchar(max)')
            ,1,1,'')
       AS Chequesstuffed
      FROM @tempchequeinven p1;

		--------------------------------------
		delete from @tempchequeinven;
		fetch next from @partition_cursor into @MainCode,@BranchCode;
		
	end

	close @partition_cursor;
	deallocate @partition_cursor;

	select distinct * from @lesspartitionstuff order by MainCode,BranchCode;

	declare @ttable table (id int identity(1,1),minval int,maxval int)
	declare @minvalue int
	declare @maxvalue int
	declare @n int
	set @minvalue = 1
	set @maxvalue = 100
	set @n=1000
	
	while @n > 0
	begin
		--print 'values: ' + convert(varchar,@minvalue) + ',' + convert(varchar,@maxvalue)
		insert into @ttable(minval,maxval) values(@minvalue,@maxvalue)
		set @minvalue = @minvalue + 100
		set @maxvalue=@maxvalue + 100
		set @n = @n-1
	end; 
	print 'Done with the loop'
	select * from @ttable



	with cte(MainCode,BranchCode)
	as
	(
		select MainCode,BranchCode from ChequeInven where len(ChequeNo)<>10 and len(MainCode) < 8--rownum from #newchequeinven where len(MainCode) >= 8
	)
	select MainCode,BranchCode,count(*) as totcount from cte group by MainCode,BranchCode order by totcount desc
	

	select count(*) as totcount from ChequeInven where len(ChequeNo) = 10 and len(MainCode) >= 8
	select count(*) as totcount from ChequeInven where len(ChequeNo) <> 10 and len(MainCode) < 8