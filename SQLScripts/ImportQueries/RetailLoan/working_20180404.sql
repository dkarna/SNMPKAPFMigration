select top 1 * from FinacleLoanTable
select top 1 * from #tempFinacleLoanTable
select distinct FinacleSchemeType from FinacleLoanTable

select t.* into #tempFinacleLoanTable from 
(
	
-- LAA

	-- Without AcType 36

	select flt.* from FinacleLoanTable flt
	join Master m on m.MainCode=flt.PumoriMainCode and m.AcType=flt.PumoriAcType and m.CyCode=flt.PumoriCyCode
	where flt.FinacleSchemeType='LAA'
	and (m.Balance < 0 and m.Limit > 0)
	and m.AcType IN('30','31','32','33','37','38','39','3A','3B','3E','3F','3K','3L','3M','3N','3O','3P','3Q','3R','3S','3T','3U','3X','40','42','43','46','4A','4B','4F','4G','4I','4J','4K','4M','4O','4P','4Q','4S','3V','3Y','3Z','47','48','4C','4D','4E')

	-- AcType 36 only
	UNION
	select flt.* from FinacleLoanTable flt
	join Master m on m.MainCode=flt.PumoriMainCode and m.AcType=flt.PumoriAcType and m.CyCode=flt.PumoriCyCode
	where flt.FinacleSchemeType='LAA'
	and (m.Balance < 0)
	and m.AcType IN('36')

	--select * from FinacleLoanTable where FinacleSchemeType='LAA' 

	--select top 1 * from Master where AcType='36'



-- ODA
	
	UNION

	select flt.* from FinacleLoanTable flt
	join Master m on m.MainCode=flt.PumoriMainCode and m.AcType=flt.PumoriAcType and m.CyCode=flt.PumoriCyCode
	where flt.FinacleSchemeType='ODA'
	and m.IsBlocked not in ('C','o')
	and m.AcType IN('30','31','32','33','37','38','39','3A','3B','3E','3F','3K','3L','3M','3N','3O','3P','3Q','3R','3S','3T','3U','3X','40','42','43','46','4A','4B','4F','4G','4I','4J','4K','4M','4O','4P','4Q','4S','3V','3Y','3Z','47','48','4C','4D','4E')


-- PCA
	--select top 1 * from DealTable
	UNION
	select flt.* from FinacleLoanTable flt
	join Master m on m.MainCode=flt.PumoriMainCode and m.AcType=flt.PumoriAcType and m.CyCode=flt.PumoriCyCode
	join DealTable dt on flt.PumoriReferenceNo=dt.ReferenceNo
	where flt.FinacleSchemeType='PCA'
	and dt.DealAmt > 0
	--and (m.Balance < 0 and m.Limit > 0)
	and m.AcType IN('30','31','32','33','37','38','39','3A','3B','3E','3F','3K','3L','3M','3N','3O','3P','3Q','3R','3S','3T','3U','3X','40','42','43','46','4A','4B','4F','4G','4I','4J','4K','4M','4O','4P','4Q','4S','3V','3Y','3Z','47','48','4C','4D','4E')
) as t