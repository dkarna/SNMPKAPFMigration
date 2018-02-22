-- SQL for TD008

IF OBJECT_ID('tempdb.dbo.#tempdealtable', 'U') IS NOT NULL
  DROP TABLE #tempdealtable;									-- Drop temporary tempdealtable table if it exists

-- Creation of temporary DealTable as #tempdealtable
SELECT * INTO #tempdealtable FROM DealTable 
WHERE MaturityDate > GETDATE() 
AND (AcType >= '13' AND AcType <= '21') 
ORDER BY MainCode,ReferenceNo;

IF OBJECT_ID('tempdb.dbo.#tempdealmaster', 'U') IS NOT NULL
  DROP TABLE #tempdealmaster;    -- Drop temporary tempdealmaster table if it exists
  
-- creation of temporary Master AS #tempdealmaster
SELECT * INTO #tempdealmaster FROM Master 
WHERE MainCode IN
(
	SELECT DISTINCT MainCode FROM #tempdealtable
) 
ORDER BY MainCode;

IF OBJECT_ID('tempdb.dbo.#tempinttrandetail', 'U') IS NOT NULL
  DROP TABLE #tempinttrandetail;    -- Drop temporary tempinttrandetail table if it exists
  
-- creation of temporary IntTranDetail AS #tempinttrandetail
SELECT tdt.* INTO #tempinttrandetail FROM IntTranDetail tdt 
JOIN
(
	SELECT DISTINCT MainCode,ReferenceNo,MAX(CalcDate) AS CalcDate FROM IntTranDetail itd 
	WHERE AcType >= '13' AND AcType <= '21' 
	GROUP BY MainCode,ReferenceNo 
) AS tempinttrandetail
ON tdt.MainCode = tempinttrandetail.MainCode 
AND tdt.ReferenceNo = tempinttrandetail.ReferenceNo 
AND tdt.CalcDate = tempinttrandetail.CalcDate 
ORDER by tdt.MainCode,tdt.ReferenceNo

-- Main Query

SELECT
'INT' AS Indicator    -- INT: Interest
,'' AS foracid   -- values will be given after NNTM setup by Finacle Implementation team
,ct.CyDesc AS crncy_code -- need to confirm whether this will be cycode from DealTable
,t2.BranchCode AS sol_id   -- need to confirm whether this will be branch code from DealTable
,RIGHT(SPACE(17)+CAST(t2.IntAccrued AS VARCHAR(17)),17) AS nrml_accrued_amount_cr    
,CONVERT(VARCHAR(10),t3.CalcDate,105) AS interest_calc_upto_date_cr
,'' AS accrued_upto_date_cr
,'' AS booked_upto_date_cr
,'' AS nrml_accrued_amount_dr
,'' AS interest_calc_upto_date_dr
,'' AS accrued_upto_date_dr
,'' AS booked_upto_date_dr
,'' AS Dummy
,'' AS migr_cumbal_for_avgcalc_cr 
,'' AS migr_cumbal_date 
FROM #tempdealmaster t1 JOIN #tempdealtable t2 ON t1.MainCode = t2.MainCode
JOIN #tempinttrandetail t3 ON t2.MainCode = t3.MainCode and t2.ReferenceNo = t3.ReferenceNo
JOIN CurrencyTable ct ON t1.CyCode = ct.CyCode