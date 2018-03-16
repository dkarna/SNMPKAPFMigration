SELECT 
  Chq.MainCode AS foracid
, MinChq.BeginChq AS begin_chq_num
, Chq.CreateOn AS acpt_date
, Chq.CreateOn AS chq_date
, '' AS chq_amt
, '' AS payee_name
, SChq.StoppedChq AS num_of_lvs
, '' AS chq_alpha
, '' AS sp_reason_code
, '' AS acct_bal
, Cur.CyDesc AS acct_crncy_code
FROM ChequeInven Chq
LEFT JOIN Master M ON Chq.MainCode = M.MainCode AND Chq.BranchCode = M.BranchCode
LEFT JOIN CurrencyTable Cur ON Cur.CyCode = M.CyCode
LEFT JOIN (SELECT MainCode, BranchCode, MIN(ChequeNo) AS BeginChq FROM  ChequeInven GROUP BY MainCode, BranchCode) MinChq ON Chq.MainCode = MinChq.MainCode AND Chq.BranchCode = MinChq.BranchCode
LEFT JOIN (
			SELECT MainCode, BranchCode, Count(*) StoppedChq
			FROM ChequeInven
			WHERE CheqStatus = 'S'
			GROUP BY MainCode, BranchCode
		) SChq
	ON SChq.MainCode = Chq.MainCode
