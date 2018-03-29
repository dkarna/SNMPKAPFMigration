-- SQL Code for CS019

select count(*) from HoldTable  -- 2964  total count
select top 1 * from HoldTable
select distinct MainCode,AffectHeldAmt,Used from HoldTable

 select  distinct BranchCode from HoldTable where MainCode IN ('9710202', '9710103' ) and AffectHeldAmt = 'T' and Used='F'

 --select * from Master where MainCode IN ('9710202', '9710103' )

 select 
 ht.BranchCode AS issu_br_code
,ht.SeqNo AS dd_num
,convert(varchar(10),ht.CreatedOn,105) AS issue_date
,'4501' AS issu_bank_code
,'NPR' AS dd_crncy_code
,'' AS schm_code    -- Need BPD value
,'' AS issu_extn_cntr_code
,'U' AS dd_status
,convert(varchar(10),ht.CreatedOn,105) AS dd_status_date
,RIGHT(SPACE(17)+CAST(ht.Amount AS VARCHAR(17)),17) AS dd_amt
,ht.BranchCode AS payee_br_code
,'4501' AS payee_bank_code
,RIGHT(SPACE(16)+CAST(ht.ReferenceNo AS VARCHAR(16)),16) AS instrmnt_num
,'' AS dd_reval_date
,'' AS prnt_advc_flg
,'' AS prnt_rmks
,'' AS payee_br_code
,'' AS paying_bank_code
,'' AS routing_br_code
,'' AS routing_bank_code
,'' AS instrmnt_type
,'' AS instrmnt_alpha
,ht.Details AS pur_name
,ht.Details AS payee_name
,'' AS prnt_optn
,'' AS prnt_flg
,'' AS prnt_cnt
,'' AS dup_iss_cnt
,'' AS dup_iss_date
,'' AS rectifed_cnt
,'' AS cautioned_stat
,'' AS cautioned_reason
,'' AS paid_advc_flg
,'' AS invt_srl_num
,'' AS paid_ex_advc
,'' AS advc_rcv_date
 from HoldTable ht
 where ht.MainCode IN ('9710202', '9710103' ) and ht.AffectHeldAmt = 'T' and ht.Used='F'