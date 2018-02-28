SELECT DISTINCT
  'G' Func_Code
, CASE WHEN m.AcType ='90' THEN 'S'
	WHEN m.AcType = '9F' THEN 'U' END AS Bill_Param_Type
, ct.ClientCode CIF_ID
, lm.CyCodeLc CCY
, 'Y' underDC
, lcd.BranchCode solId
, lcd.ParentReferenceNo billId
, '' discAmt
, '' otherDeduction
, RIGHT(SPACE(17)+CAST(lcd.BaseAmount AS VARCHAR(17)),17) billAmt
, '' billTenor
, CONVERT(VARCHAR(10),lcd.EnteredOn,105) lodgeDate
, 'NP' billCountry
--,lcd.NegoRefNo otherBanksRefNo
, CASE WHEN lcd.NegoRefNo=lcd.NegoRefNo THEN lcd.NegoRefNo 
 ELSE 'MIGRATION_DATA' END otherBanksRefNo
, m.Name partyName
, ct.Address1 address1
, ct.Address2 address2
, '' invoiceAmt
, '' invoiceCrncy
, '' CBbank
, '' CBbranch
, 'SRBLNPKAXXX' BCbicId
, 'L' dueDateInd
, CONVERT(VARCHAR(10),lcd.DocNegoDate,105) billDate
, CONVERT(VARCHAR(10),lcd.DueOn,105) dueDate
, CONVERT(VARCHAR(10),lcd.DocShipDate,105) onBoardDate
, '' DCno
, lm.NomAc foracid
, lm.NomAc  oppChrgAccId
, lm.NomAc custLiabAcctId
, '' advAmtPaid
, '' refDate
, '' paysysId
, '' partyCIF_ID
, '' Daddress3
, '' Dcity
, '' Dstate
, '' Dcntry
, '' Dpostalcode
, '' DBbank
, '' DBbranch
, '' DBName
, '' DBaddress1
, '' DBaddress2
, '' DBaddress3
, '' DBcity
, '' DBstate
, '' DBcntry
, '' DBpostalcode
, '' DBbicId
, '' DBpartyId
, '' DBaddrType
, '' CBName
, '' CBaddress1
, '' CBaddress2
, '' CBaddress3
, '' CBcity
, '' CBstate
, '' CBcntry
, '' CBpostalcode
, '' CBbicId
, '' CBpartyId
, '' CBaddrType
, '' COBbank
, '' COBbranch
, '' COBName
, '' COBaddress1
, '' COBaddress2
, '' COBaddress3
, '' COBcity
, '' COBstate
, '' COBcntry
, '' COBpostalcode
, '' COBbicId
, '' COBpartyId
, '' COBaddrType
, '' RBbank
, '' RBbranch
, '' RBName
, '' RBaddress1
, '' RBaddress2
, '' RBaddress3
, '' RBcity
, '' RBstate
, '' RBcntry
, '' RBpostalcode
, '' RBbicId
, '' RBpartyId
, '' RBaddrType
, '' CABbank
, '' CABbranch
, '' CABName
, '' CABaddress1
, '' CABaddress2
, '' CABaddress3
, '' CABcity
, '' CABstate
, '' CABcntry
, '' CABpostalcode
, '' CABbicId
, '' CABpartyId
, '' CABaddrType
, '' draftNo
, '' fixedTransitPeriod
, '' gracePeriod
, '' docsRcvdOn
, '' acceptDate
, '' tenorMonth
, '' tenorDay
, '' dcUtilAmt
, '' shpGrntOrdNo1 
, '' shpGrntOrdNo2 
, '' shpGrntOrdNo3 
, '' shpGrntOrdNo4 
, '' shpGrntOrdNo5 
, '' othrBankPrftAmt 
, '' carrierCode 
, '' originOfGoods 
, '' portOfDest 
, '' consigneeCntry 
, '' shpmtTerms 
, '' commCode 
, '' docRcvdFlg 
, '' docStatus 
, '' solId1 
, '' ordNo1 
, '' solId2 
, '' ordNo2 
, '' solId3 
, '' ordNo3 
, '' solId4 
, '' ordNo4 
, '' solId5 
, '' ordNo5 
, '' expOrdNo 
, '' licenseDate 
, '' insurPcnt 
, '' insurAmt 
, '' insuredBy 
, '' policyNo 
, '' policyDate 
, '' insurCompName 
, '' payableAt 
, '' premiumCcy 
, '' premiumAmt 
, '' insurConvRateCode 
, '' insurConvRate 
, '' insurAddrLine1 
, '' insurAddrLine2 
, '' insurAddrLine3 
, '' insurCity 
, '' insurState 
, '' insurCntry 
, '' insurPostalCode 
, '' insurExpDate 
, '' invoiceNo 
, '' invoiceDate 
, '' underReserve 
, '' intermTrade 
, '' purposeBill 
, '' regApprovalNo 
, '' ourCommAmt 
, '' ourPTAmt 
, '' purchaseAcctId 
, '' lcndaAcctId 
, '' goodsInTranAcctId 
, '' purchaseAmt 
, '' payableAcctId 
, '' prfxMurabhaLmtId 
, '' sfxMurabhaLmtId 
, '' prftTableCode 
, '' promPurRcvd 
, '' promPurDate 
, '' promPurRefNo 
, '' purAcceptAdvice 
, '' exeAdvNo1 
, '' exeAdvNo2 
, '' exeAdvNo3 
, '' exeAdvNo4 
, '' exeAdvNo5 
, '' invAcctId
, '' goodsPurThirdParty
, '' islamicRateCode
, '' islamicRate 
, '' capitalTran
, '' intendToExport 
, '' inwardDcRefNum
FROM LcDocArrived lcd
LEFT JOIN LcMaster lm ON lm.ReferenceNo = lcd.ParentReferenceNo AND lm.BranchCode = lcd.BranchCode
LEFT JOIN Master m ON m.MainCode = lcd.MainCode AND m.BranchCode = lcd.BranchCode
LEFT JOIN ClientTable ct ON m.ClientCode = ct.ClientCode



--select AcType from Master;

--select * from dbo.DRAWINGS

--select * from LcDc;

--select NegoRefNo from LcDocArrived WHERE NegoRefNo IS NOT NULL

--select * from LcMaster