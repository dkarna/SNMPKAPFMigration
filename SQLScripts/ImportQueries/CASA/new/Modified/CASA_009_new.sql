-- CS009

IF OBJECT_ID('tempdb.dbo.#LienMaster', 'U') IS NOT NULL
  DROP TABLE #LienMaster;
select *  into #LienMaster from
(select BranchCode, MainCode, CyCode, HeldAmt as LienAmt 
from Master M  
Where M.HeldAmt > 0 
and ( M.AcType <= '12' OR M.AcType IN ('3C','3D','3G','3H','3I','3J','3W', '4H', '4L')) 
and M.AcType NOT IN ('0X', '0H') 
and IsBlocked NOT IN ('C','o') 
UNION ALL 
select BranchCode, MainCode,CyCode, HeldAmt-5000 as LienAmt  
from Master M  
Where M.HeldAmt > 0 
and M.AcType = '0H'  
and CyCode = '01' 
and IsBlocked NOT IN ('C','o') 
--Order by 3 
) as t where t.LienAmt >= 0
--[If negative than remove]

IF OBJECT_ID('tempdb.dbo.#tempasbatable', 'U') IS NOT NULL
  DROP TABLE #tempasbatable;
select MainCode,BranchCode, SUM(Amount) as Asbamt,min(CreatedOn) as mincreateddate 
into #tempasbatable
from ASBAHoldTable 
where AffectHeldAmt = 'T' and Used = 'F'
Group By MainCode,BranchCode 

-- Main Code
select LM.MainCode as foracid
,RIGHT(SPACE(17)+CAST(LM.LienAmt AS VARCHAR(17)),17) as lien_amt
,ct.CyDesc as alt_crncy_code
,case when TAT.MainCode is not null then 'ASBA' else 'MIGR' end lien_reason_code
,convert(varchar(10),M1.minacopendate,105) as lien_start_date 
,'31-12-2099' as lien_expiry_date
,'ULIEN' as b2k_type
,'' as b2k_id
,'' as si_cert_num
,'' as limit_prefix
,'' as limit_sufix
,'' as dc_ref_num
,'' as bg_srl_num
,M.BranchCode as sol_id
,'' as lien_remarks
,'' as ipo_institution_name
,'' as ipo_application_name
from Master M
join #LienMaster LM on LM.MainCode = M.MainCode and LM.BranchCode=M.BranchCode
left join #tempasbatable TAT on TAT.MainCode=M.MainCode and TAT.BranchCode=M.BranchCode
join CurrencyTable ct on ct.CyCode=M.CyCode
left join 
(
	select MainCode,MIN(AcOpenDate) as minacopendate from Master group by MainCode
) as M1 on M1.MainCode = M.MainCode
where len(M.MainCode) >= 8
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = M.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
) 

UNION

select LM.MainCode as foracid
,RIGHT(SPACE(17)+CAST(LM.LienAmt AS VARCHAR(17)),17) as lien_amt
,ct.CyDesc as alt_crncy_code
,case when TAT.MainCode is not null then 'ASBA' else 'MIGR' end lien_reason_code
,convert(varchar(10),M1.minacopendate,105) as lien_start_date 
,'31-12-2099' as lien_expiry_date
,'ULIEN' as b2k_type
,'' as b2k_id
,'' as si_cert_num
,'' as limit_prefix
,'' as limit_sufix
,'' as dc_ref_num
,'' as bg_srl_num
,M.BranchCode as sol_id
,'' as lien_remarks
,'' as ipo_institution_name
,'' as ipo_application_name
from Master M
join #LienMaster LM on LM.MainCode = M.MainCode and LM.BranchCode=M.BranchCode
left join #tempasbatable TAT on TAT.MainCode=M.MainCode and TAT.BranchCode=M.BranchCode
join CurrencyTable ct on ct.CyCode=M.CyCode
left join 
(
	select MainCode,MIN(AcOpenDate) as minacopendate from Master group by MainCode
) as M1 on M1.MainCode = M.MainCode
where len(M.MainCode) >= 8
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = M.MainCode and CustTypeCode = 'Z' and CustType NOT IN ('11','12')
) 
