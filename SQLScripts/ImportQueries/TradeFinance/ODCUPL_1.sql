-- SQLCODE for ODCUPL

SELECT
'S' 																AS Func_Code
,lm.BranchCode 														AS Sol_Id
,lm.ReferenceNo 													AS DC_Num
,lm.BaseAmount 														AS Event_Amount
,CONVERT(VARCHAR(10),lm.IssueDate,105) 								AS Event_Date
,'' 																AS DC_Type  -- Need to confirm as it's value depend on BPD data
,ctable.CyDesc 														AS DC_Currency_Cif_Id
,ct.ClientCode 														AS DC_Cif_Id
,lm1.Applicant1 													AS DC_Party_Name
,lm1.Applicant2 													AS DC_Party_Address_1
,lm1.Applicant3 													AS DC_Party_Address_2
,'' 																AS DC_Party_Address_3
,'' 																AS DC_Party_City
,'' 																AS DC_Party_State
,'' 																AS DC_Party_Country
,'' 																AS Postal_Code
,lm.ReferenceNo 													AS DC_Account_Id
,lm.ReferenceNo 													AS Applicant_Refernce_Num
,'' 																AS Tolerance_Limit  -- Need to be confirmed as default value is given
,'' 																AS Negative_Tolerance_pcnt  -- Need to be confirmed as default value is given
,'MID' 																AS DC_Rate_Code
,RIGHT(SPACE(17)+CAST(lm.CyRate AS VARCHAR(17)),17) 				AS DC_Rate
,'' 																AS DC_Advance_Amount
,'' 																AS DC_Interest_pcnt
,'' 																AS DC_Additional_Amt
,'' 																AS DC_Interest_Remarks
,'' 																AS DC_Max_Credit_
,'' 																AS DC_Purchase_Order_No
,'' 																AS DC_Pord_Date
,'' 																AS DC_Purchase_Order_Last_Amend_Date
,'' 																AS DC_Total_Num_of_Amendments
,'' 																AS Pre_Advice_Flag
,'' 																AS Pre_Advice_Date
,'' 																AS Pre_Advice_Ref_Num
,'' 																AS Other_Bank_Ref_Num
,'SWIFT' 															AS DC_Paysys_Id
,'' 																AS DC_Beneficiary_Cif_Id
,lm1.Beneficiary1 													AS DC_Beneficiary_Name
,lm1.Beneficiary2 													AS DC_Beneficiary_Address1
,lm1.Beneficiary3 													AS DC_Beneficiary_Address2
,'' 																AS DC_Beneficiary_Address3
,'' 																AS DC_Beneficiary_City
,'' 																AS DC_Beneficiary_State
,'' 																AS DC_Beneficiary_Country
,'' 																AS DC_Beneficiary_PinCode
,lm.BranchCode 														AS DC_Applicant_Branch
,'' 																AS DC_Applicant_Bank
,'' 																AS DC_Applicant_Bank_Name
,'' 																AS DC_Applicant_Bank_Address1
,'' 																AS DC_Applicant_Bank_Address2
,'' 																AS DC_Applicant_Bank_Address3
,'' 																AS DC_Applicant_Bank_City
,'' 																AS DC_Applicant_Bank_State
,'' 																AS DC_Applicant_Bank_Country
,'' 																AS DC_Applicant_Bank_PinCode
,'' 																AS DC_Applicant_Bic_Code
,'SNMANPKA' 														AS DC_Party_Identifier
,'' 																AS DC_Applicant_Bank_Address_Type
,lm.BranchCode														AS DC_Issuing_Branch
,'' 																AS DC_Issuing_Bank
,'' 																AS DC_Issuing_Name
,'' 																AS DC_Issuing_Address_1
,'' 																AS DC_Issuing_Address_2
,'' 																AS DC_Issuing_Address_3
,'' 																AS DC_Issuing_City
,'' 																AS DC_Issuing_State
,'' 																AS DC_Issuing_Country
,'' 																AS DC_Issuing_Pin_Code
,'' 																AS DC_Issue_Bic_Code
,'' 																AS DC_Issue_Party_ID
,lm.ReferenceNo 													AS DC_Issue_Ref_No
,'' 																AS DC_Issue_Address_Type
,'' 																AS DC_Advising_Branch_Code
,'' 																AS DC_Advising_Bank_Code
,'' 																AS DC_Advising_Name
,'' 																AS DC_Advising_Address_1
,'' 																AS DC_Advising_Address_2
,'' 																AS DC_Advising_Address_3
,'' 																AS DC_Advising_City
,'' 																AS DC_Advising_State
,'' 																AS DC_Advising_Country
,'' 																AS DC_Advising_Pin_Code
,'' 																AS DC_Advising_Bic_Code
,'' 																AS DC_Advising_Party_Id
,'' 																AS DC_Advising_Address_Type
,'' 																AS DC_Drawee_Branch
,'' 																AS DC_Drawee_Bank
,'' 																AS DC_Drawee_Name
,'' 																AS DC_Drawee_Address_1
,'' 																AS DC_Drawee_Address_2
,'' 																AS DC_Drawee_Address_3
,'' 																AS DC_Drawee_City
,'' 																AS DC_Drawee_State
,'' 																AS DC_Drawee_Country
,'' 																AS DC_Drawee_Pin_Code
,'' 																AS DC_Drawee_BIC_Code
,'' 																AS DC_Drawee_Party_Id
,'' 																AS DC_Drawee_Address_Type
,'' 																AS DC_Available_with_Branch
,'' 																AS DC_Available_with_Bank
,'' 																AS DC_Available_with_Name
,'' 																AS DC_Available_with_Address_1
,'' 																AS DC_Available_with_Address_2
,'' 																AS DC_Available_with_Address_3
,'' 																AS DC_Available_with_City
,'' 																AS DC_Available_with_State
,'' 																AS DC_Available_with_Country
,'' 																AS DC_Available_with_Pin_Code
,'' 																AS DC_Available_with_BIC_Code
,'' 																AS DC_Available_with_Party_Id
,'' 																AS DC_Available_by
,'' 																AS DC_Available_with_Address_Type
,'' 																AS DC_Reimbursing_Branch
,'' 																AS DC_Reimbursing_Bank
,'' 																AS DC_Reimbursing_Name
,'' 																AS DC_Reimbursing_Address_1
,'' 																AS DC_Reimbursing_Address_2
,'' 																AS DC_Reimbursing_Address_3
,'' 																AS DC_Reimbursing_City
,'' 																AS DC_Reimbursing_State
,'' 																AS DC_Reimbursing_Country
,'' 																AS DC_Reimbursing_Pin_Code
,'' 																AS DC_Reimbursing_BIC_Code
,'' 																AS DC_Reimbursing_Party_Id
,'' 																AS DC_Reimbursing_Address_Type
,'' 																AS DC_Advise_through_Branch
,'' 																AS DC_Advise_through_Bank
,'' 																AS DC_Advise_through_Name
,'' 																AS DC_Advise_through_Address_1
,'' 																AS DC_Advise_through_Address_2
,'' 																AS DC_Advise_through_Address_3
,'' 																AS DC_Advise_through_City
,'' 																AS DC_Advise_through_State
,'' 																AS DC_Advise_through_Country
,'' 																AS DC_Advise_through_Pin_Code
,'' 																AS DC_Advise_through_BIC_Code
,'' 																AS DC_Advise_through_Party_Id
,'' 																AS DC_Advise_through_Location
,'' 																AS DC_Advise_through_Address_Type
,CASE WHEN lm.PartialShipment = 'ALLOWED' THEN 'Y'                     
   ELSE 'N'                                                            
 END 																AS partial_shipment_flag                                                     
,CASE WHEN lm.TransShipment = 'ALLOWED' THEN 'Y'                       
   ELSE 'N'                                                            
 END 																AS trans_shipment_flag                                                     
,CONVERT(VARCHAR(10),lm.ShipmentDate,105) 							AS Last_Shipment_Date                
,'' 																AS DC_Negotiation_Period                                                      
,lm.ModeOfTransport													AS Shipment_Mode                                      
,'' 																AS Shipment_Term                                                      
,lm.PortOfShipment 													AS Despatch_origin_port_code                                       
,lm.PortOfDestination 												AS Despatch_destination_port_code                                    
,lm.PortOfShipment 													AS Port_of_Origin                                       
,lm.PortOfDestination 												AS Port_of_Destination                                    
,'N'																AS House_Air_Bill_Flag                                                     
,'' 																AS Shipment_Desc                                                      
,'' 																AS Agent_code                                                      
,'' 																AS Origin_of_Goods                                                      
,'' 																AS Commodity_code                                                      
,'' 																AS License_Code                                                      
,'110' 																AS Insurance_Pcnt                                                   
,'' 																AS Insured_Amount                                                      
,'' 																AS Insured_By                                                      
,'' 																AS Policy_Num                                                      
,'' 																AS Policy_Date                                                      
,'' 																AS Insured_Company                                                      
,'' 																AS Payable_At                                                      
,'' 																AS Premium_Amt                                                      
,'' 																AS DC_Reimbursement_Msg_Flag                                                      
,'' 																AS DC_Reimbursemnet_Applicable_Rules                                                      
,'' 																AS Nostro_Acct_Num                                                      
,lm.ChargesOn 														AS DC_Charges_Borne_By                                            
,CASE WHEN lm.Confirmation IS NULL THEN 'N'                            
  ELSE 'Y'                                                             
 END 																AS DC_Confirmation_Instructions                                                     
,CASE WHEN lm.Confirmation IS NULL THEN 'N'                            
  ELSE 'Y'                                                             
 END 																AS DC_Confirmation_Required_By                                                     
,''  																AS DC_Agent_Commision_pcnt                                                      
,''  																AS Capital_adequecy_code   -- Need to confirmed as mentioned "needs discussion
,'2' 																AS Revocable_Flag                                                     
,'Y' 																AS DC_Irrevocable_Flag                                                     
,'N' 																AS DC_Transferrable_Flag                                                     
,'N' 																AS DC_stanby_mode_flag                                                     
,'N' 																AS DC_Revolving_Flag                                                     
,'N' 																AS DC_Back_to_Back_Flag                                                     
,'' 																AS Defferred_DC_flag    -- Need to be confirmed as mentioned in the mappin
,'' 																AS Red_Clause_DC_flag                                                      
,'' 																AS Reinstatement_Type                                                      
,'' 																AS DC_Reinstatement_Day                                                      
,'' 																AS Max_Reinstatements                                                      
,'' 																AS Reinstatement_Remarks                                                      
,'' 																AS DC_Back_to_Back_Ref_Num                                                      
,'UCP LATEST VERSION' 												AS DC_Applicable_Rule                                    
,'' 																AS DC_Applicable_Sub_Rule                                                      
,CASE WHEN m.AcType = '90' THEN 'S'                                    
	WHEN m.AcType = '9F' THEN 'U'                                      
 END AS DC_Tenor                                                     
,CONVERT(VARCHAR(10),lm.ExpiryDate,105) AS DC_Place_of_Expiry                   
,lm1.LcCountry AS DC_Place_of_Expiry														                                           
,'' AS LimitPrefix                                              
,'' AS Limit_Suffix                                              
,'' AS Limit_Margin_Pcnt                                              
,'' AS Internal_Limits                                              
,'' AS Amendment_Indicator                                              
,'' AS Amendment_Status                                              
,'' AS Amendment_Remarks                                              
,'' AS Usance_Period                                              
,'' AS Amend_Tenor_Details                                              
,'' AS Remittance_Sent_By                                              
,'' AS Remittance_Id                                              
,'' AS Advance_Amount                                              
,'' AS Payment_Date                                              
,'' AS Advance_Remarks                                              
,'' AS Purchase_Order_Sol_Id_1                                              
,'' AS Purchase_Order_Number_1                                              
,'' AS Purchase_Order_Sol_Id_2                                              
,'' AS Purchase_Order_Number_2                                              
,'' AS Purchase_Order_Sol_Id_3                                              
,'' AS Purchase_Order_Number_3                                              
,'' AS Purchase_Order_Sol_Id_4                                              
,'' AS Purchase_Order_Number_4                                              
,'' AS Purchase_Order_Sol_Id_5                                              
,'' AS Purchase_Order_Number_5                                              
,'' AS Beneficiary_Account_Id                                              
,'' AS Insurance_Address_Line_1                                              
,'' AS Insurance_Address_Line_2                                              
,'' AS Insurance_Address_Line_3                                              
,'' AS Insurance_City                                              
,'' AS Insurance_State                                              
,'' AS Insurance_Country                                              
,'' AS Insurance_Pin_Code                                              
,'' AS Insurance_Expiry_Date                                              
,'' AS Mudarabah_Type                                              
,'' AS Bank_Invest_Amt_Transfered_to_Cust_Acct                                              
,'' AS mudarabaInvstAcct_                                              
,'' AS Customer_Investment_Percentage                                              
,'' AS Customer_Investment_Amount                                              
,'' AS Bank_Investment_Percentage                                              
,'' AS Bank_Investment_Amount                                              
,'' AS Bank_Profit_Share_Percent                                              
,'' AS Bank_Loss_Share_Percent                                              
,'' AS Customer_Profit_Share_Percent                                              
,'' AS Customer_Loss_Share_Percent                                              
,'' AS Goods_Purchased_For_Third_Party                                              
,'' AS Third_Party_Cif_Id                                              
,'' AS Third_Party_Name                                              
,'' AS Thrid_Party_Address_1                                              
,'' AS Thrid_Party_Address_2
,'' AS Third_Party_Address_3
,'' AS Thirf_Party_City
,'' AS Third_Party_State
,'' AS Third_Party_Country
,'' AS Third_Party_Postal_Code
,'' AS Third_Party_Account_Id
,'' AS intendToExport_
,'' AS inwardDcRefNum_
,'' AS capitalGoodsTran
FROM LcMaster lm
JOIN Master m ON lm.MainCode = m.MainCode AND lm.BranchCode = m.BranchCode
JOIN ClientTable ct ON m.ClientCode = ct.ClientCode
LEFT JOIN LcMaster1 lm1 ON lm.ReferenceNo = lm1.ReferenceNo AND lm.BranchCode = lm1.BranchCode 
JOIN CurrencyTable ctable ON lm.CyCodeLc = ctable.CyCode
where m.IsBlocked NOT IN ('C','o')
and left(m.ClientCode,1) <> '_'
and len(m.MainCode) >= 8
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = m.MainCode and CustTypeCode = 'Z' and CustType IN ('11','12')
)

UNION

SELECT
'S' 																AS Func_Code
,lm.BranchCode 														AS Sol_Id
,lm.ReferenceNo 													AS DC_Num
,lm.BaseAmount 														AS Event_Amount
,CONVERT(VARCHAR(10),lm.IssueDate,105) 								AS Event_Date
,'' 																AS DC_Type  -- Need to confirm as it's value depend on BPD data
,ctable.CyDesc 														AS DC_Currency_Cif_Id
,ct.ClientCode 														AS DC_Cif_Id
,lm1.Applicant1 													AS DC_Party_Name
,lm1.Applicant2 													AS DC_Party_Address_1
,lm1.Applicant3 													AS DC_Party_Address_2
,'' 																AS DC_Party_Address_3
,'' 																AS DC_Party_City
,'' 																AS DC_Party_State
,'' 																AS DC_Party_Country
,'' 																AS Postal_Code
,lm.ReferenceNo 													AS DC_Account_Id
,lm.ReferenceNo 													AS Applicant_Refernce_Num
,'' 																AS Tolerance_Limit  -- Need to be confirmed as default value is given
,'' 																AS Negative_Tolerance_pcnt  -- Need to be confirmed as default value is given
,'MID' 																AS DC_Rate_Code
,RIGHT(SPACE(17)+CAST(lm.CyRate AS VARCHAR(17)),17) 				AS DC_Rate
,'' 																AS DC_Advance_Amount
,'' 																AS DC_Interest_pcnt
,'' 																AS DC_Additional_Amt
,'' 																AS DC_Interest_Remarks
,'' 																AS DC_Max_Credit_
,'' 																AS DC_Purchase_Order_No
,'' 																AS DC_Pord_Date
,'' 																AS DC_Purchase_Order_Last_Amend_Date
,'' 																AS DC_Total_Num_of_Amendments
,'' 																AS Pre_Advice_Flag
,'' 																AS Pre_Advice_Date
,'' 																AS Pre_Advice_Ref_Num
,'' 																AS Other_Bank_Ref_Num
,'SWIFT' 															AS DC_Paysys_Id
,'' 																AS DC_Beneficiary_Cif_Id
,lm1.Beneficiary1 													AS DC_Beneficiary_Name
,lm1.Beneficiary2 													AS DC_Beneficiary_Address1
,lm1.Beneficiary3 													AS DC_Beneficiary_Address2
,'' 																AS DC_Beneficiary_Address3
,'' 																AS DC_Beneficiary_City
,'' 																AS DC_Beneficiary_State
,'' 																AS DC_Beneficiary_Country
,'' 																AS DC_Beneficiary_PinCode
,lm.BranchCode 														AS DC_Applicant_Branch
,'' 																AS DC_Applicant_Bank
,'' 																AS DC_Applicant_Bank_Name
,'' 																AS DC_Applicant_Bank_Address1
,'' 																AS DC_Applicant_Bank_Address2
,'' 																AS DC_Applicant_Bank_Address3
,'' 																AS DC_Applicant_Bank_City
,'' 																AS DC_Applicant_Bank_State
,'' 																AS DC_Applicant_Bank_Country
,'' 																AS DC_Applicant_Bank_PinCode
,'' 																AS DC_Applicant_Bic_Code
,'SNMANPKA' 														AS DC_Party_Identifier
,'' 																AS DC_Applicant_Bank_Address_Type
,lm.BranchCode														AS DC_Issuing_Branch
,'' 																AS DC_Issuing_Bank
,'' 																AS DC_Issuing_Name
,'' 																AS DC_Issuing_Address_1
,'' 																AS DC_Issuing_Address_2
,'' 																AS DC_Issuing_Address_3
,'' 																AS DC_Issuing_City
,'' 																AS DC_Issuing_State
,'' 																AS DC_Issuing_Country
,'' 																AS DC_Issuing_Pin_Code
,'' 																AS DC_Issue_Bic_Code
,'' 																AS DC_Issue_Party_ID
,lm.ReferenceNo 													AS DC_Issue_Ref_No
,'' 																AS DC_Issue_Address_Type
,'' 																AS DC_Advising_Branch_Code
,'' 																AS DC_Advising_Bank_Code
,'' 																AS DC_Advising_Name
,'' 																AS DC_Advising_Address_1
,'' 																AS DC_Advising_Address_2
,'' 																AS DC_Advising_Address_3
,'' 																AS DC_Advising_City
,'' 																AS DC_Advising_State
,'' 																AS DC_Advising_Country
,'' 																AS DC_Advising_Pin_Code
,'' 																AS DC_Advising_Bic_Code
,'' 																AS DC_Advising_Party_Id
,'' 																AS DC_Advising_Address_Type
,'' 																AS DC_Drawee_Branch
,'' 																AS DC_Drawee_Bank
,'' 																AS DC_Drawee_Name
,'' 																AS DC_Drawee_Address_1
,'' 																AS DC_Drawee_Address_2
,'' 																AS DC_Drawee_Address_3
,'' 																AS DC_Drawee_City
,'' 																AS DC_Drawee_State
,'' 																AS DC_Drawee_Country
,'' 																AS DC_Drawee_Pin_Code
,'' 																AS DC_Drawee_BIC_Code
,'' 																AS DC_Drawee_Party_Id
,'' 																AS DC_Drawee_Address_Type
,'' 																AS DC_Available_with_Branch
,'' 																AS DC_Available_with_Bank
,'' 																AS DC_Available_with_Name
,'' 																AS DC_Available_with_Address_1
,'' 																AS DC_Available_with_Address_2
,'' 																AS DC_Available_with_Address_3
,'' 																AS DC_Available_with_City
,'' 																AS DC_Available_with_State
,'' 																AS DC_Available_with_Country
,'' 																AS DC_Available_with_Pin_Code
,'' 																AS DC_Available_with_BIC_Code
,'' 																AS DC_Available_with_Party_Id
,'' 																AS DC_Available_by
,'' 																AS DC_Available_with_Address_Type
,'' 																AS DC_Reimbursing_Branch
,'' 																AS DC_Reimbursing_Bank
,'' 																AS DC_Reimbursing_Name
,'' 																AS DC_Reimbursing_Address_1
,'' 																AS DC_Reimbursing_Address_2
,'' 																AS DC_Reimbursing_Address_3
,'' 																AS DC_Reimbursing_City
,'' 																AS DC_Reimbursing_State
,'' 																AS DC_Reimbursing_Country
,'' 																AS DC_Reimbursing_Pin_Code
,'' 																AS DC_Reimbursing_BIC_Code
,'' 																AS DC_Reimbursing_Party_Id
,'' 																AS DC_Reimbursing_Address_Type
,'' 																AS DC_Advise_through_Branch
,'' 																AS DC_Advise_through_Bank
,'' 																AS DC_Advise_through_Name
,'' 																AS DC_Advise_through_Address_1
,'' 																AS DC_Advise_through_Address_2
,'' 																AS DC_Advise_through_Address_3
,'' 																AS DC_Advise_through_City
,'' 																AS DC_Advise_through_State
,'' 																AS DC_Advise_through_Country
,'' 																AS DC_Advise_through_Pin_Code
,'' 																AS DC_Advise_through_BIC_Code
,'' 																AS DC_Advise_through_Party_Id
,'' 																AS DC_Advise_through_Location
,'' 																AS DC_Advise_through_Address_Type
,CASE WHEN lm.PartialShipment = 'ALLOWED' THEN 'Y'                     
   ELSE 'N'                                                            
 END 																AS partial_shipment_flag                                                     
,CASE WHEN lm.TransShipment = 'ALLOWED' THEN 'Y'                       
   ELSE 'N'                                                            
 END 																AS trans_shipment_flag                                                     
,CONVERT(VARCHAR(10),lm.ShipmentDate,105) 							AS Last_Shipment_Date                
,'' 																AS DC_Negotiation_Period                                                      
,lm.ModeOfTransport													AS Shipment_Mode                                      
,'' 																AS Shipment_Term                                                      
,lm.PortOfShipment 													AS Despatch_origin_port_code                                       
,lm.PortOfDestination 												AS Despatch_destination_port_code                                    
,lm.PortOfShipment 													AS Port_of_Origin                                       
,lm.PortOfDestination 												AS Port_of_Destination                                    
,'N'																AS House_Air_Bill_Flag                                                     
,'' 																AS Shipment_Desc                                                      
,'' 																AS Agent_code                                                      
,'' 																AS Origin_of_Goods                                                      
,'' 																AS Commodity_code                                                      
,'' 																AS License_Code                                                      
,'110' 																AS Insurance_Pcnt                                                   
,'' 																AS Insured_Amount                                                      
,'' 																AS Insured_By                                                      
,'' 																AS Policy_Num                                                      
,'' 																AS Policy_Date                                                      
,'' 																AS Insured_Company                                                      
,'' 																AS Payable_At                                                      
,'' 																AS Premium_Amt                                                      
,'' 																AS DC_Reimbursement_Msg_Flag                                                      
,'' 																AS DC_Reimbursemnet_Applicable_Rules                                                      
,'' 																AS Nostro_Acct_Num                                                      
,lm.ChargesOn 														AS DC_Charges_Borne_By                                            
,CASE WHEN lm.Confirmation IS NULL THEN 'N'                            
  ELSE 'Y'                                                             
 END 																AS DC_Confirmation_Instructions                                                     
,CASE WHEN lm.Confirmation IS NULL THEN 'N'                            
  ELSE 'Y'                                                             
 END 																AS DC_Confirmation_Required_By                                                     
,''  																AS DC_Agent_Commision_pcnt                                                      
,''  																AS Capital_adequecy_code   -- Need to confirmed as mentioned "needs discussion
,'2' 																AS Revocable_Flag                                                     
,'Y' 																AS DC_Irrevocable_Flag                                                     
,'N' 																AS DC_Transferrable_Flag                                                     
,'N' 																AS DC_stanby_mode_flag                                                     
,'N' 																AS DC_Revolving_Flag                                                     
,'N' 																AS DC_Back_to_Back_Flag                                                     
,'' 																AS Defferred_DC_flag    -- Need to be confirmed as mentioned in the mappin
,'' 																AS Red_Clause_DC_flag                                                      
,'' 																AS Reinstatement_Type                                                      
,'' 																AS DC_Reinstatement_Day                                                      
,'' 																AS Max_Reinstatements                                                      
,'' 																AS Reinstatement_Remarks                                                      
,'' 																AS DC_Back_to_Back_Ref_Num                                                      
,'UCP LATEST VERSION' 												AS DC_Applicable_Rule                                    
,'' 																AS DC_Applicable_Sub_Rule                                                      
,CASE WHEN m.AcType = '90' THEN 'S'                                    
	WHEN m.AcType = '9F' THEN 'U'                                      
 END AS DC_Tenor                                                     
,CONVERT(VARCHAR(10),lm.ExpiryDate,105) AS DC_Place_of_Expiry                   
,lm1.LcCountry AS DC_Place_of_Expiry														                                           
,'' AS LimitPrefix                                              
,'' AS Limit_Suffix                                              
,'' AS Limit_Margin_Pcnt                                              
,'' AS Internal_Limits                                              
,'' AS Amendment_Indicator                                              
,'' AS Amendment_Status                                              
,'' AS Amendment_Remarks                                              
,'' AS Usance_Period                                              
,'' AS Amend_Tenor_Details                                              
,'' AS Remittance_Sent_By                                              
,'' AS Remittance_Id                                              
,'' AS Advance_Amount                                              
,'' AS Payment_Date                                              
,'' AS Advance_Remarks                                              
,'' AS Purchase_Order_Sol_Id_1                                              
,'' AS Purchase_Order_Number_1                                              
,'' AS Purchase_Order_Sol_Id_2                                              
,'' AS Purchase_Order_Number_2                                              
,'' AS Purchase_Order_Sol_Id_3                                              
,'' AS Purchase_Order_Number_3                                              
,'' AS Purchase_Order_Sol_Id_4                                              
,'' AS Purchase_Order_Number_4                                              
,'' AS Purchase_Order_Sol_Id_5                                              
,'' AS Purchase_Order_Number_5                                              
,'' AS Beneficiary_Account_Id                                              
,'' AS Insurance_Address_Line_1                                              
,'' AS Insurance_Address_Line_2                                              
,'' AS Insurance_Address_Line_3                                              
,'' AS Insurance_City                                              
,'' AS Insurance_State                                              
,'' AS Insurance_Country                                              
,'' AS Insurance_Pin_Code                                              
,'' AS Insurance_Expiry_Date                                              
,'' AS Mudarabah_Type                                              
,'' AS Bank_Invest_Amt_Transfered_to_Cust_Acct                                              
,'' AS mudarabaInvstAcct_                                              
,'' AS Customer_Investment_Percentage                                              
,'' AS Customer_Investment_Amount                                              
,'' AS Bank_Investment_Percentage                                              
,'' AS Bank_Investment_Amount                                              
,'' AS Bank_Profit_Share_Percent                                              
,'' AS Bank_Loss_Share_Percent                                              
,'' AS Customer_Profit_Share_Percent                                              
,'' AS Customer_Loss_Share_Percent                                              
,'' AS Goods_Purchased_For_Third_Party                                              
,'' AS Third_Party_Cif_Id                                              
,'' AS Third_Party_Name                                              
,'' AS Thrid_Party_Address_1                                              
,'' AS Thrid_Party_Address_2
,'' AS Third_Party_Address_3
,'' AS Thirf_Party_City
,'' AS Third_Party_State
,'' AS Third_Party_Country
,'' AS Third_Party_Postal_Code
,'' AS Third_Party_Account_Id
,'' AS intendToExport_
,'' AS inwardDcRefNum_
,'' AS capitalGoodsTran
FROM LcMaster lm
JOIN Master m ON lm.MainCode = m.MainCode AND lm.BranchCode = m.BranchCode
JOIN ClientTable ct ON m.ClientCode = ct.ClientCode
LEFT JOIN LcMaster1 lm1 ON lm.ReferenceNo = lm1.ReferenceNo AND lm.BranchCode = lm1.BranchCode 
JOIN CurrencyTable ctable ON lm.CyCodeLc = ctable.CyCode
where m.IsBlocked NOT IN ('C','o')
and left(m.ClientCode,1) <> '_'
and len(m.MainCode) >= 8
AND EXISTS
(
	SELECT 1 FROM AcCustType WHERE MainCode = m.MainCode and CustTypeCode = 'Z' and CustType NOT IN ('11','12')
)