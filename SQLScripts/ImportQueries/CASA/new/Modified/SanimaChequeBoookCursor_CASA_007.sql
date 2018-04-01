

SELECT	 MainCode
		,BranchCode
		,ChequeNo
		,case when ci.CheqStatus = 'I' then 'P'
		when ci.CheqStatus = 'Z' then 'I'
		when ci.CheqStatus = 'S' then 'S'
		when ci.CheqStatus = 'D' then 'D'
		when ci.CheqStatus = 'R' then 'D'
		when ci.CheqStatus = 'C' then 'D'
		when ci.CheqStatus = 'V' then 'U'
		end  as CheqStatus
		,ROW_NUMBER() OVER (PARTITION BY ci.MainCode, ci.BranchCode ORDER BY ci.MainCode, ci.BranchCode, ci.ChequeNo ) RowNum
INTO #NewChequeNum
FROM ChequeInven ci
join Master M on M.MainCode=ci.MainCode and M.BranchCode=ci.BranchCode
WHERE LEN(ChequeNo) = 10
AND LEN(MainCode) >= 8

-- SELECT MainCode, BranchCode, MIN(RowNum) MinRow, MAX(RowNum) MaxRow
-- INTO #MinMaxChequeNum
-- FROM #NewChequeNum
-- GROUP BY MainCode, BranchCode

--SELECT * FROM #MinMaxChequeNum WHERE MaxRow  > 200
--drop table #ChequePartition
SELECT MainCode, BranchCode, COUNT(ChequeNo) as ChqCount,(COUNT(ChequeNo)/100)+1 as [Partition], ROW_NUMBER () OVER(Order by MainCode, BranchCode) as RNo
INTO  #ChequePartition
FROM #NewChequeNum
--WHERE MainCode = '0010001044501'
GROUP BY MainCode, BranchCode

--SELECT * FROM #ChequePartition
--order by MainCode, BranchCode, RNo

CREATE TABLE #ChqPartition1
(MainCode VARCHAR(20),BranchCode VARCHAR(4),ChequeNo VARCHAR(10),CheqStatus CHAR, RowNum INT, PartitionNo INT )

CREATE TABLE #ChqPartition2
(MainCode NVARCHAR(MAX),BranchCode NVARCHAR(MAX),BundleNum int,MinChqNo VARCHAR(10), CheqStatus VARCHAR(100))

DECLARE @MainCode VARCHAR(20), @BranchCode VARCHAR(4), @Count INT, @PartitionNo INT, @ChequeNo VARCHAR(10);
DECLARE @Start INT = 1, @End INT = 100;

SELECT @Count = COUNT(*) FROM #ChequePartition

--DECLARE @ChequePartition AS TABLE (MainCode VARCHAR(20),BranchCode VARCHAR(4),ChequeNo VARCHAR(10),CheqStatus CHAR, RowNum INT, PartitionNo INT) 

--DECLARE ChqPartition CURSOR FOR
--SELECT TOP 5 MainCode, BranchCode, ChqCount
--FROM #ChequePartition

--SELECT * FROM #ChequePartition

DECLARE @i INT = 1;
TRUNCATE TABLE #ChqPartition2
WHILE @i <= @Count
	BEGIN
		SELECT @MainCode = MainCode, @BranchCode = BranchCode,@PartitionNo = [Partition]
		FROM #ChequePartition
		WHERE RNo = @i;
	
		DECLARE @j INT =1
		WHILE @j <= @PartitionNo
		BEGIN
			Print convert(varchar, @Start)  + ' :' + convert(varchar,@End)
			TRUNCATE TABLE #ChqPartition1

			INSERT INTO #ChqPartition1
			SELECT MainCode, BranchCode, ChequeNo,	CheqStatus,	RowNum, @j
			FROM #NewChequeNum
			WHERE MainCode = @MainCode
			AND BranchCode = @BranchCode
			--AND RowNum BETWEEN @Start AND @End
			AND RowNum >= @Start
			AND RowNum <= @End

			SELECT @ChequeNo = MIN(ChequeNo) FROM #ChqPartition1 

			--SELECT * FROM #ChqPartition1
			
			INSERT INTO #ChqPartition2
			SELECT distinct p1.MainCode,p1.BranchCode,@j AS BundleNum,@ChequeNo AS MinChqNo,
			stuff( (SELECT CheqStatus
               FROM #ChqPartition1 p2
               WHERE p2.MainCode = p1.MainCode
			   and p2.BranchCode=p1.BranchCode
			   --and p2.rownum >= 1 and p2.rownum <=100
               ORDER BY RowNum
               FOR XML PATH(''), TYPE).value('.', 'varchar(max)')
            ,1,0,'')
      AS CheqStatus
      FROM #ChqPartition1 p1

			SET @Start = @Start + 100;
			SET @End = @End + 100
			SET @j = @j + 1;
		END
		SET @i = @i+1;
	END
	SELECT * FROM #ChqPartition2



