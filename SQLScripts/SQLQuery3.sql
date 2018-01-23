select top 1 * from [dbo].[FinacleTDTable]

select * from FinacleTDTable;

select top 10 * from DealTable where ltrim(rtrim(AcType)) in (select PumoriAcType from FinacleTDTable)

select distinct AcType from DealTable;
select * from FinacleTDTable
select * from FinacleSchemeTable
select * from FinacleSubGL

select * From FinacleLoanTable order by 3;

select * from AcCustType where CustTypeCode = 'X';
select * from CustTypeTable;

select left(PumoriAcType,2) from FinacleTDTable;

