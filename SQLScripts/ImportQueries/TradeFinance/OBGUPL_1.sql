-- Query for OBGUPL

SELECT DISTINCT
'A' AS Func_Code
,gm.BranchCode AS Sol_id    -- Need to confirm whether BranchCode or MainCode
,gm.ReferenceNo AS bg_num
,RIGHT(SPACE(17)+CAST(gm.BaseAmount AS VARCHAR(17)),17) AS event_amt
,'' AS bg_exp_mth
,DATEPART(DAY,gm.ExpiryDate) AS bg_exp_dd
,CONVERT(VARCHAR(10),gm.ExpiryDate,105) AS bg_exp_dt
,'' AS bg_clm_exp_mth
,'' AS bg_clm_exp_dd
,CONVERT(VARCHAR(10),gm.ExpiryDate,105) AS bg_clm_exp_dt
,'A' AS bg_chrg_borde_by
,CASE WHEN m.AcType IN ('92','9B') THEN 'BBG'
	WHEN m.AcType IN ('93','9C') THEN 'PB'
	WHEN m.AcType IN ('94','9D') THEN 'APG'
	WHEN m.AcType = '95' THEN 'OTHER'
 END AS bg_type
,gm.CyCodeGt AS bg_cur
,m.ClientCode AS cif_id
,CONVERT(VARCHAR(10),gm.IssueDate,105)  AS event_dt
,LEFT(gm.Purpose1,39) AS Guarantee_desc
,CASE WHEN m.AcType IN ('92','9B') THEN 'BBG'
	WHEN m.AcType IN ('93','9C') THEN 'PB'
	WHEN m.AcType IN ('94','9D') THEN 'APG'
	WHEN m.AcType = '95' THEN 'OTHER'
 END AS bg_class
,CONVERT(VARCHAR(10),gm.IssueDate,105) AS bg_eff_dt
,'NONE' AS f_rule
,'NONE' AS app_sub_rule
,'' AS bg_fructified_amt   -- Need to confirm as highlighted in red in mapping sheet
,'' AS orig__bg_rec_flg
,gm.Remarks AS bg_remarks
,gm.ContraAc AS counter_bg_num
,'' AS import_lic_num
,'' AS lic_exp_dt
,'' AS cap_adq_code
,'' AS bg_prov_amt
,'' AS free_code1
,'' AS free_code2
,'' AS free_code3
,gm.Nominee AS bg_oper_acc_id
,ct.Name AS applicant_name
,ct.Address1 AS applicant_addr1
,ct.Address2 AS applicant_addr2
,ct.Address3 AS applicant_addr3
,ct.City AS applicant_city   -- Size is more than required (actual 25 needed 5)
,'' AS applicant_state
,ct.CountryCode AS applicant_country  -- Need to be confirmed
,'' AS applicant_pin_code
,'' AS applicant_ref_num
,CASE WHEN td.CyCode <> '001' THEN gm.CyCodeGt
	ELSE ''
 END AS bg_rate_code
,gm.CyRate AS bg_rate
,LEFT(td.Desc1,16) AS oth_bank_ref_num
,'' AS paysys_id
,'' AS bene_cif_id
,gm.Beneficiary1 AS bene_name
,LEFT(gm.Beneficiary2,40) AS bene_addr1
,LEFT(gm.Beneficiary3,40) AS bene_addr2
,'' AS bene_addr3
,'' AS bene_city
,'' AS bene_state
,'' AS bene_cnty
,'' AS bene_pin_code
,'' AS bene_type
,'' AS bg_coresp_bank
,'' AS bg_coresp_branch
,'' AS bg_coresp_name
,'' AS bg_coresp_addr1
,'' AS bg_coresp_addr2
,'' AS bg_coresp_addr3
,'' AS bg_coresp_city
,'' AS bg_coresp_state
,'' AS bg_coresp_cnty
,'' AS bg_coresp_pincode
,'' AS bic_code
,'' AS party_identifier
,'' AS coresp_addr_type
,ctbl.CyDesc AS bg_cur_cd
,'' AS dc_ref_num
,'' AS sg_bill_equiv_cur_cd
,'' AS sg_bill_equiv_amt
,'' AS bg_dc_rate_cd
,'' AS bg_dc_rate
,'' AS sg_containg_cur_cd
,'' AS sg_containg_amt
,'' AS retain_min_containg_amt
,'' AS containg_rev_event
,'' AS margin_reverse_code
,'' AS trust_receipt_num
,'' AS no_of_units
,'' AS unit_value
,'' AS commod_det_desc
,'' AS commo_remarks
,'' AS bill_ladding_num
,'' AS carrier_id
,'' AS carrier_name
,'' AS carrier_addr1
,'' AS carrier_addr2
,'' AS carrier_addr3
,'' AS carrier_city
,'' AS carrier_state
,'' AS carrier_cnty
,'' AS carrier_pincode
,'' AS order_of_consignee
,'' AS port_of_dest
,'' AS act_shipment_date
,'' AS limit_prefix
,'' AS limit_suffix
,'' AS limit_margin_pcnt
,'' AS Internal_Limits
,'' AS Amendment_Indicator
,'' AS Amendment_Remarks
,'' AS amendStatus 
,'' AS amendInitiatedBy 
,'' AS autoRenewApplicableFlg  
,'' AS finalExpiryDate 
,'' AS autoRenewNextCycle 
,'' AS autoRenewFreqtype 
,'' AS autoRenewFreqDate 
,'' AS autoRenewFreqWeekNum 
,'' AS autoRenewFreqDay 
,'' AS isFreqDayOnHoliday 
,'' AS bgCounterGuaranteeRateCode_Code 
,'' AS counterRate 
,'' AS advanceAmtPaid 
,'' AS solIDOrder1 
,'' AS orderNoDtls1 
,'' AS solIDOrder2 
,'' AS orderNoDtls2 
,'' AS solIDOrder3 
,'' AS orderNoDtls3 
,'' AS solIDOrder4 
,'' AS orderNoDtls4 
,'' AS solIDOrder5 
,'' AS orderNoDtls5 
,'' AS purchaseForacid 
,'' AS sgDoPayableForacid 
,'' AS execAdvNo1 
,'' AS execAdvNo2 
,'' AS execAdvNo3 
,'' AS execAdvNo4 
,'' AS execAdvNo5 
,'' AS promiseToPurchaseRecv 
,'' AS promiseToPurchaseDate 
,'' AS promiseToPurchaseRefNo  
,'' AS purchaseAccptAdvice 
,'' AS financingForacid 
,'' AS debitFinancingForacid 
,'' AS prefixFinancingLimitID  
,'' AS suffixFinancingLimitID  
,'' AS islamicRateCode 
,'' AS islamicRate 
,'' AS sectorCode 
,'' AS expCifId 
,'' AS expName 
,'' AS expAddr1 
,'' AS expAddr2 
,'' AS expAddr3 
,'' AS expCity 
,'' AS expState 
,'' AS expCntry 
,'' AS expPinCode 
,'' AS bgCollBankCode 
,'' AS bgCollBranchCode 
,'' AS bgCollBankName 
,'' AS bgCollBankAddr1 
,'' AS bgCollBankAddr2 
,'' AS bgCollBankAddr3 
,'' AS bgCollBankCity 
,'' AS bgCollBankState 
,'' AS bgCollBankCntry 
,'' AS bgCollBankPinCode 
,'' AS bgCollBicCode 
,'' AS bgCollPartyId 
,'' AS bgCollAddrType 
,'' AS intendToExport 
,'' AS inwardDcRefNum 
FROM GtMaster gm
JOIN Master m ON gm.MainCode = m.MainCode AND gm.BranchCode = m.BranchCode
JOIN ClientTable ct ON m.ClientCode = ct.ClientCode
JOIN TransDetail td ON gm.MainCode = td.MainCode AND gm.BranchCode = td.BranchCode
JOIN CurrencyTable ctbl ON gm.CyCodeGt = ctbl.CyCode
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = m.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
)

UNION

SELECT DISTINCT
'A' AS Func_Code
,gm.BranchCode AS Sol_id    -- Need to confirm whether BranchCode or MainCode
,gm.ReferenceNo AS bg_num
,RIGHT(SPACE(17)+CAST(gm.BaseAmount AS VARCHAR(17)),17) AS event_amt
,'' AS bg_exp_mth
,DATEPART(DAY,gm.ExpiryDate) AS bg_exp_dd
,CONVERT(VARCHAR(10),gm.ExpiryDate,105) AS bg_exp_dt
,'' AS bg_clm_exp_mth
,'' AS bg_clm_exp_dd
,CONVERT(VARCHAR(10),gm.ExpiryDate,105) AS bg_clm_exp_dt
,'A' AS bg_chrg_borde_by
,CASE WHEN m.AcType IN ('92','9B') THEN 'BBG'
	WHEN m.AcType IN ('93','9C') THEN 'PB'
	WHEN m.AcType IN ('94','9D') THEN 'APG'
	WHEN m.AcType = '95' THEN 'OTHER'
 END AS bg_type
,gm.CyCodeGt AS bg_cur
,m.ClientCode AS cif_id
,CONVERT(VARCHAR(10),gm.IssueDate,105)  AS event_dt
,LEFT(gm.Purpose1,39) AS Guarantee_desc
,CASE WHEN m.AcType IN ('92','9B') THEN 'BBG'
	WHEN m.AcType IN ('93','9C') THEN 'PB'
	WHEN m.AcType IN ('94','9D') THEN 'APG'
	WHEN m.AcType = '95' THEN 'OTHER'
 END AS bg_class
,CONVERT(VARCHAR(10),gm.IssueDate,105) AS bg_eff_dt
,'NONE' AS f_rule
,'NONE' AS app_sub_rule
,'' AS bg_fructified_amt   -- Need to confirm as highlighted in red in mapping sheet
,'' AS orig__bg_rec_flg
,gm.Remarks AS bg_remarks
,gm.ContraAc AS counter_bg_num
,'' AS import_lic_num
,'' AS lic_exp_dt
,'' AS cap_adq_code
,'' AS bg_prov_amt
,'' AS free_code1
,'' AS free_code2
,'' AS free_code3
,gm.Nominee AS bg_oper_acc_id
,ct.Name AS applicant_name
,ct.Address1 AS applicant_addr1
,ct.Address2 AS applicant_addr2
,ct.Address3 AS applicant_addr3
,ct.City AS applicant_city   -- Size is more than required (actual 25 needed 5)
,'' AS applicant_state
,ct.CountryCode AS applicant_country  -- Need to be confirmed
,'' AS applicant_pin_code
,'' AS applicant_ref_num
,CASE WHEN td.CyCode <> '001' THEN gm.CyCodeGt
	ELSE ''
 END AS bg_rate_code
,gm.CyRate AS bg_rate
,LEFT(td.Desc1,16) AS oth_bank_ref_num
,'' AS paysys_id
,'' AS bene_cif_id
,gm.Beneficiary1 AS bene_name
,LEFT(gm.Beneficiary2,40) AS bene_addr1
,LEFT(gm.Beneficiary3,40) AS bene_addr2
,'' AS bene_addr3
,'' AS bene_city
,'' AS bene_state
,'' AS bene_cnty
,'' AS bene_pin_code
,'' AS bene_type
,'' AS bg_coresp_bank
,'' AS bg_coresp_branch
,'' AS bg_coresp_name
,'' AS bg_coresp_addr1
,'' AS bg_coresp_addr2
,'' AS bg_coresp_addr3
,'' AS bg_coresp_city
,'' AS bg_coresp_state
,'' AS bg_coresp_cnty
,'' AS bg_coresp_pincode
,'' AS bic_code
,'' AS party_identifier
,'' AS coresp_addr_type
,ctbl.CyDesc AS bg_cur_cd
,'' AS dc_ref_num
,'' AS sg_bill_equiv_cur_cd
,'' AS sg_bill_equiv_amt
,'' AS bg_dc_rate_cd
,'' AS bg_dc_rate
,'' AS sg_containg_cur_cd
,'' AS sg_containg_amt
,'' AS retain_min_containg_amt
,'' AS containg_rev_event
,'' AS margin_reverse_code
,'' AS trust_receipt_num
,'' AS no_of_units
,'' AS unit_value
,'' AS commod_det_desc
,'' AS commo_remarks
,'' AS bill_ladding_num
,'' AS carrier_id
,'' AS carrier_name
,'' AS carrier_addr1
,'' AS carrier_addr2
,'' AS carrier_addr3
,'' AS carrier_city
,'' AS carrier_state
,'' AS carrier_cnty
,'' AS carrier_pincode
,'' AS order_of_consignee
,'' AS port_of_dest
,'' AS act_shipment_date
,'' AS limit_prefix
,'' AS limit_suffix
,'' AS limit_margin_pcnt
,'' AS Internal_Limits
,'' AS Amendment_Indicator
,'' AS Amendment_Remarks
,'' AS amendStatus 
,'' AS amendInitiatedBy 
,'' AS autoRenewApplicableFlg  
,'' AS finalExpiryDate 
,'' AS autoRenewNextCycle 
,'' AS autoRenewFreqtype 
,'' AS autoRenewFreqDate 
,'' AS autoRenewFreqWeekNum 
,'' AS autoRenewFreqDay 
,'' AS isFreqDayOnHoliday 
,'' AS bgCounterGuaranteeRateCode_Code 
,'' AS counterRate 
,'' AS advanceAmtPaid 
,'' AS solIDOrder1 
,'' AS orderNoDtls1 
,'' AS solIDOrder2 
,'' AS orderNoDtls2 
,'' AS solIDOrder3 
,'' AS orderNoDtls3 
,'' AS solIDOrder4 
,'' AS orderNoDtls4 
,'' AS solIDOrder5 
,'' AS orderNoDtls5 
,'' AS purchaseForacid 
,'' AS sgDoPayableForacid 
,'' AS execAdvNo1 
,'' AS execAdvNo2 
,'' AS execAdvNo3 
,'' AS execAdvNo4 
,'' AS execAdvNo5 
,'' AS promiseToPurchaseRecv 
,'' AS promiseToPurchaseDate 
,'' AS promiseToPurchaseRefNo  
,'' AS purchaseAccptAdvice 
,'' AS financingForacid 
,'' AS debitFinancingForacid 
,'' AS prefixFinancingLimitID  
,'' AS suffixFinancingLimitID  
,'' AS islamicRateCode 
,'' AS islamicRate 
,'' AS sectorCode 
,'' AS expCifId 
,'' AS expName 
,'' AS expAddr1 
,'' AS expAddr2 
,'' AS expAddr3 
,'' AS expCity 
,'' AS expState 
,'' AS expCntry 
,'' AS expPinCode 
,'' AS bgCollBankCode 
,'' AS bgCollBranchCode 
,'' AS bgCollBankName 
,'' AS bgCollBankAddr1 
,'' AS bgCollBankAddr2 
,'' AS bgCollBankAddr3 
,'' AS bgCollBankCity 
,'' AS bgCollBankState 
,'' AS bgCollBankCntry 
,'' AS bgCollBankPinCode 
,'' AS bgCollBicCode 
,'' AS bgCollPartyId 
,'' AS bgCollAddrType 
,'' AS intendToExport 
,'' AS inwardDcRefNum 
FROM GtMaster gm
JOIN Master m ON gm.MainCode = m.MainCode AND gm.BranchCode = m.BranchCode
JOIN ClientTable ct ON m.ClientCode = ct.ClientCode
JOIN TransDetail td ON gm.MainCode = td.MainCode AND gm.BranchCode = td.BranchCode
JOIN CurrencyTable ctbl ON gm.CyCodeGt = ctbl.CyCode
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = m.MainCode and CustTypeCode = 'Z' and CustType NOT IN ('11','12')
)