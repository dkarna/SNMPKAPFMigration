-- SQLCODE for ODCUPL

SELECT DISTINCT
'S' AS ODCUPL_001
,lm.BranchCode AS ODCUPL_002
,lm.ReferenceNo AS ODCUPL_003
,lm.BaseAmount AS ODCUPL_004
,CONVERT(VARCHAR(10),lm.IssueDate,105) AS ODCUPL_005
,'' AS ODCUPL_006  -- Need to confirm as it's value depend on BPD data
,ctable.CyDesc AS ODCUPL_007
,ct.ClientCode AS ODCUPL_008
,lm1.Applicant1 AS ODCUPL_009
,lm1.Applicant2 AS ODCUPL_010
,lm1.Applicant3 AS ODCUPL_011
,'' AS ODCUPL_012
,'' AS ODCUPL_013
,'' AS ODCUPL_014
,'' AS ODCUPL_015
,'' AS ODCUPL_016
,lm.ReferenceNo AS ODCUPL_017
,lm.ReferenceNo AS ODCUPL_018
,'' AS ODCUPL_019  -- Need to be confirmed as default value is given
,'' AS ODCUPL_020  -- Need to be confirmed as default value is given
,'MID' AS ODCUPL_021
,RIGHT(SPACE(17)+CAST(lm.CyRate AS VARCHAR(17)),17) AS ODCUPL_022
,'' AS ODCUPL_023
,'' AS ODCUPL_024
,'' AS ODCUPL_025
,'' AS ODCUPL_026
,'' AS ODCUPL_027
,'' AS ODCUPL_028
,'' AS ODCUPL_029
,'' AS ODCUPL_030
,'' AS ODCUPL_031
,'' AS ODCUPL_032
,'' AS ODCUPL_033
,'' AS ODCUPL_034
,'' AS ODCUPL_035
,'SWIFT' AS ODCUPL_036
,'' AS ODCUPL_037
,lm1.Beneficiary1 AS ODCUPL_038
,lm1.Beneficiary2 AS ODCUPL_039
,lm1.Beneficiary3 AS ODCUPL_040
,'' AS ODCUPL_041
,'' AS ODCUPL_042
,'' AS ODCUPL_043
,'' AS ODCUPL_044
,'' AS ODCUPL_045
,lm.BranchCode AS ODCUPL_046
,'' AS ODCUPL_047
,'' AS ODCUPL_048
,'' AS ODCUPL_049
,'' AS ODCUPL_050
,'' AS ODCUPL_051
,'' AS ODCUPL_052
,'' AS ODCUPL_053
,'' AS ODCUPL_054
,'' AS ODCUPL_055
,'' AS ODCUPL_056
,'SNMANPKA' AS ODCUPL_057
,'' AS ODCUPL_058
,lm.BranchCode AS ODCUPL_059
,'' AS ODCUPL_060
,'' AS ODCUPL_061
,'' AS ODCUPL_062
,'' AS ODCUPL_063
,'' AS ODCUPL_064
,'' AS ODCUPL_065
,'' AS ODCUPL_066
,'' AS ODCUPL_067
,'' AS ODCUPL_068
,'' AS ODCUPL_069
,'' AS ODCUPL_070
,lm.ReferenceNo AS ODCUPL_071
,'' AS ODCUPL_072
,'' AS ODCUPL_073
,'' AS ODCUPL_074
,'' AS ODCUPL_075
,'' AS ODCUPL_076
,'' AS ODCUPL_077
,'' AS ODCUPL_078
,'' AS ODCUPL_079
,'' AS ODCUPL_080
,'' AS ODCUPL_081
,'' AS ODCUPL_082
,'' AS ODCUPL_083
,'' AS ODCUPL_084
,'' AS ODCUPL_085
,'' AS ODCUPL_086
,'' AS ODCUPL_087
,'' AS ODCUPL_088
,'' AS ODCUPL_089
,'' AS ODCUPL_090
,'' AS ODCUPL_091
,'' AS ODCUPL_092
,'' AS ODCUPL_093
,'' AS ODCUPL_094
,'' AS ODCUPL_095
,'' AS ODCUPL_096
,'' AS ODCUPL_097
,'' AS ODCUPL_098
,'' AS ODCUPL_099
,'' AS ODCUPL_100
,'' AS ODCUPL_101
,'' AS ODCUPL_102
,'' AS ODCUPL_103
,'' AS ODCUPL_104
,'' AS ODCUPL_105
,'' AS ODCUPL_106
,'' AS ODCUPL_107
,'' AS ODCUPL_108
,'' AS ODCUPL_109
,'' AS ODCUPL_110
,'' AS ODCUPL_111
,'' AS ODCUPL_112
,'' AS ODCUPL_113
,'' AS ODCUPL_114
,'' AS ODCUPL_115
,'' AS ODCUPL_116
,'' AS ODCUPL_117
,'' AS ODCUPL_118
,'' AS ODCUPL_119
,'' AS ODCUPL_120
,'' AS ODCUPL_121
,'' AS ODCUPL_122
,'' AS ODCUPL_123
,'' AS ODCUPL_124
,'' AS ODCUPL_125
,'' AS ODCUPL_126
,'' AS ODCUPL_127
,'' AS ODCUPL_128
,'' AS ODCUPL_129
,'' AS ODCUPL_130
,'' AS ODCUPL_131
,'' AS ODCUPL_132
,'' AS ODCUPL_133
,'' AS ODCUPL_134
,'' AS ODCUPL_135
,'' AS ODCUPL_136
,'' AS ODCUPL_137
,'' AS ODCUPL_138
,'' AS ODCUPL_139
,CASE WHEN lm.PartialShipment = 'ALLOWED' THEN 'Y'
   ELSE 'N'
 END AS ODCUPL_140
,CASE WHEN lm.TransShipment = 'ALLOWED' THEN 'Y'
   ELSE 'N'
 END AS ODCUPL_141
,CONVERT(VARCHAR(10),lm.ShipmentDate,105) AS ODCUPL_142
,'' AS ODCUPL_143
,lm.ModeOfTransport AS ODCUPL_144
,'' AS ODCUPL_145
,lm.PortOfShipment AS ODCUPL_146
,lm.PortOfDestination AS ODCUPL_147
,lm.PortOfShipment AS ODCUPL_148
,lm.PortOfDestination AS ODCUPL_149
,'N' AS ODCUPL_150
,'' AS ODCUPL_151
,'' AS ODCUPL_152
,'' AS ODCUPL_153
,'' AS ODCUPL_154
,'' AS ODCUPL_155
,'110' AS ODCUPL_156
,'' AS ODCUPL_157
,'' AS ODCUPL_158
,'' AS ODCUPL_159
,'' AS ODCUPL_160
,'' AS ODCUPL_161
,'' AS ODCUPL_162
,'' AS ODCUPL_163
,'' AS ODCUPL_164
,'' AS ODCUPL_165
,'' AS ODCUPL_166
,lm.ChargesOn AS ODCUPL_167
,CASE WHEN lm.Confirmation IS NULL THEN 'N'
  ELSE 'Y'
 END AS ODCUPL_168
,CASE WHEN lm.Confirmation IS NULL THEN 'N'
  ELSE 'Y'
 END AS ODCUPL_169
,'' AS ODCUPL_170
,'' AS ODCUPL_171   -- Need to confirmed as mentioned "needs discussion"
,'2' AS ODCUPL_172
,'Y' AS ODCUPL_173
,'N' AS ODCUPL_174
,'N' AS ODCUPL_175
,'N' AS ODCUPL_176
,'N' AS ODCUPL_177
,'' AS ODCUPL_178    -- Need to be confirmed as mentioned in the mapping sheet
,'' AS ODCUPL_179
,'' AS ODCUPL_180
,'' AS ODCUPL_181
,'' AS ODCUPL_182
,'' AS ODCUPL_183
,'' AS ODCUPL_184
,'UCP LATEST VERSION' AS ODCUPL_185
,'' AS ODCUPL_186
,CASE WHEN m.AcType = '90' THEN 'S' 
	WHEN m.AcType = '9F' THEN 'U' 
 END AS ODCUPL_187
,CONVERT(VARCHAR(10),lm.ExpiryDate,105) AS ODCUPL_188
,lm1.LcCountry AS ODCUPL_189
,'' AS ODCUPL_190
,'' AS ODCUPL_191
,'' AS ODCUPL_192
,'' AS ODCUPL_193
,'' AS ODCUPL_194
,'' AS ODCUPL_195
,'' AS ODCUPL_196
,'' AS ODCUPL_197
,'' AS ODCUPL_198
,'' AS ODCUPL_199
,'' AS ODCUPL_200
,'' AS ODCUPL_201
,'' AS ODCUPL_202
,'' AS ODCUPL_203
,'' AS ODCUPL_204
,'' AS ODCUPL_205
,'' AS ODCUPL_206
,'' AS ODCUPL_207
,'' AS ODCUPL_208
,'' AS ODCUPL_209
,'' AS ODCUPL_210
,'' AS ODCUPL_211
,'' AS ODCUPL_212
,'' AS ODCUPL_213
,'' AS ODCUPL_214
,'' AS ODCUPL_215
,'' AS ODCUPL_216
,'' AS ODCUPL_217
,'' AS ODCUPL_218
,'' AS ODCUPL_219
,'' AS ODCUPL_220
,'' AS ODCUPL_221
,'' AS ODCUPL_222
,'' AS ODCUPL_223
,'' AS ODCUPL_224
,'' AS mudarabalnvstAcct
,'' AS ODCUPL_225
,'' AS ODCUPL_226
,'' AS ODCUPL_227
,'' AS ODCUPL_228
,'' AS ODCUPL_229
,'' AS ODCUPL_230
,'' AS ODCUPL_231
,'' AS ODCUPL_232
,'' AS ODCUPL_233
,'' AS ODCUPL_234
,'' AS ODCUPL_235
,'' AS ODCUPL_236
,'' AS ODCUPL_237
,'' AS ODCUPL_238
,'' AS ODCUPL_239
,'' AS ODCUPL_240
,'' AS ODCUPL_241
,'' AS ODCUPL_242
,'' AS ODCUPL_243
,'' AS ODCUPL_244
,'' AS ODCUPL_245
,'' AS ODCUPL_246
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

-- SQLCODE for ODCUPL

SELECT DISTINCT
'S' AS ODCUPL_001
,lm.BranchCode AS ODCUPL_002
,lm.ReferenceNo AS ODCUPL_003
,lm.BaseAmount AS ODCUPL_004
,CONVERT(VARCHAR(10),lm.IssueDate,105) AS ODCUPL_005
,'' AS ODCUPL_006  -- Need to confirm as it's value depend on BPD data
,ctable.CyDesc AS ODCUPL_007
,ct.ClientCode AS ODCUPL_008
,lm1.Applicant1 AS ODCUPL_009
,lm1.Applicant2 AS ODCUPL_010
,lm1.Applicant3 AS ODCUPL_011
,'' AS ODCUPL_012
,'' AS ODCUPL_013
,'' AS ODCUPL_014
,'' AS ODCUPL_015
,'' AS ODCUPL_016
,lm.ReferenceNo AS ODCUPL_017
,lm.ReferenceNo AS ODCUPL_018
,'' AS ODCUPL_019  -- Need to be confirmed as default value is given
,'' AS ODCUPL_020  -- Need to be confirmed as default value is given
,'MID' AS ODCUPL_021
,RIGHT(SPACE(17)+CAST(lm.CyRate AS VARCHAR(17)),17) AS ODCUPL_022
,'' AS ODCUPL_023
,'' AS ODCUPL_024
,'' AS ODCUPL_025
,'' AS ODCUPL_026
,'' AS ODCUPL_027
,'' AS ODCUPL_028
,'' AS ODCUPL_029
,'' AS ODCUPL_030
,'' AS ODCUPL_031
,'' AS ODCUPL_032
,'' AS ODCUPL_033
,'' AS ODCUPL_034
,'' AS ODCUPL_035
,'SWIFT' AS ODCUPL_036
,'' AS ODCUPL_037
,lm1.Beneficiary1 AS ODCUPL_038
,lm1.Beneficiary2 AS ODCUPL_039
,lm1.Beneficiary3 AS ODCUPL_040
,'' AS ODCUPL_041
,'' AS ODCUPL_042
,'' AS ODCUPL_043
,'' AS ODCUPL_044
,'' AS ODCUPL_045
,lm.BranchCode AS ODCUPL_046
,'' AS ODCUPL_047
,'' AS ODCUPL_048
,'' AS ODCUPL_049
,'' AS ODCUPL_050
,'' AS ODCUPL_051
,'' AS ODCUPL_052
,'' AS ODCUPL_053
,'' AS ODCUPL_054
,'' AS ODCUPL_055
,'' AS ODCUPL_056
,'SNMANPKA' AS ODCUPL_057
,'' AS ODCUPL_058
,lm.BranchCode AS ODCUPL_059
,'' AS ODCUPL_060
,'' AS ODCUPL_061
,'' AS ODCUPL_062
,'' AS ODCUPL_063
,'' AS ODCUPL_064
,'' AS ODCUPL_065
,'' AS ODCUPL_066
,'' AS ODCUPL_067
,'' AS ODCUPL_068
,'' AS ODCUPL_069
,'' AS ODCUPL_070
,lm.ReferenceNo AS ODCUPL_071
,'' AS ODCUPL_072
,'' AS ODCUPL_073
,'' AS ODCUPL_074
,'' AS ODCUPL_075
,'' AS ODCUPL_076
,'' AS ODCUPL_077
,'' AS ODCUPL_078
,'' AS ODCUPL_079
,'' AS ODCUPL_080
,'' AS ODCUPL_081
,'' AS ODCUPL_082
,'' AS ODCUPL_083
,'' AS ODCUPL_084
,'' AS ODCUPL_085
,'' AS ODCUPL_086
,'' AS ODCUPL_087
,'' AS ODCUPL_088
,'' AS ODCUPL_089
,'' AS ODCUPL_090
,'' AS ODCUPL_091
,'' AS ODCUPL_092
,'' AS ODCUPL_093
,'' AS ODCUPL_094
,'' AS ODCUPL_095
,'' AS ODCUPL_096
,'' AS ODCUPL_097
,'' AS ODCUPL_098
,'' AS ODCUPL_099
,'' AS ODCUPL_100
,'' AS ODCUPL_101
,'' AS ODCUPL_102
,'' AS ODCUPL_103
,'' AS ODCUPL_104
,'' AS ODCUPL_105
,'' AS ODCUPL_106
,'' AS ODCUPL_107
,'' AS ODCUPL_108
,'' AS ODCUPL_109
,'' AS ODCUPL_110
,'' AS ODCUPL_111
,'' AS ODCUPL_112
,'' AS ODCUPL_113
,'' AS ODCUPL_114
,'' AS ODCUPL_115
,'' AS ODCUPL_116
,'' AS ODCUPL_117
,'' AS ODCUPL_118
,'' AS ODCUPL_119
,'' AS ODCUPL_120
,'' AS ODCUPL_121
,'' AS ODCUPL_122
,'' AS ODCUPL_123
,'' AS ODCUPL_124
,'' AS ODCUPL_125
,'' AS ODCUPL_126
,'' AS ODCUPL_127
,'' AS ODCUPL_128
,'' AS ODCUPL_129
,'' AS ODCUPL_130
,'' AS ODCUPL_131
,'' AS ODCUPL_132
,'' AS ODCUPL_133
,'' AS ODCUPL_134
,'' AS ODCUPL_135
,'' AS ODCUPL_136
,'' AS ODCUPL_137
,'' AS ODCUPL_138
,'' AS ODCUPL_139
,CASE WHEN lm.PartialShipment = 'ALLOWED' THEN 'Y'
   ELSE 'N'
 END AS ODCUPL_140
,CASE WHEN lm.TransShipment = 'ALLOWED' THEN 'Y'
   ELSE 'N'
 END AS ODCUPL_141
,CONVERT(VARCHAR(10),lm.ShipmentDate,105) AS ODCUPL_142
,'' AS ODCUPL_143
,lm.ModeOfTransport AS ODCUPL_144
,'' AS ODCUPL_145
,lm.PortOfShipment AS ODCUPL_146
,lm.PortOfDestination AS ODCUPL_147
,lm.PortOfShipment AS ODCUPL_148
,lm.PortOfDestination AS ODCUPL_149
,'N' AS ODCUPL_150
,'' AS ODCUPL_151
,'' AS ODCUPL_152
,'' AS ODCUPL_153
,'' AS ODCUPL_154
,'' AS ODCUPL_155
,'110' AS ODCUPL_156
,'' AS ODCUPL_157
,'' AS ODCUPL_158
,'' AS ODCUPL_159
,'' AS ODCUPL_160
,'' AS ODCUPL_161
,'' AS ODCUPL_162
,'' AS ODCUPL_163
,'' AS ODCUPL_164
,'' AS ODCUPL_165
,'' AS ODCUPL_166
,lm.ChargesOn AS ODCUPL_167
,CASE WHEN lm.Confirmation IS NULL THEN 'N'
  ELSE 'Y'
 END AS ODCUPL_168
,CASE WHEN lm.Confirmation IS NULL THEN 'N'
  ELSE 'Y'
 END AS ODCUPL_169
,'' AS ODCUPL_170
,'' AS ODCUPL_171   -- Need to confirmed as mentioned "needs discussion"
,'2' AS ODCUPL_172
,'Y' AS ODCUPL_173
,'N' AS ODCUPL_174
,'N' AS ODCUPL_175
,'N' AS ODCUPL_176
,'N' AS ODCUPL_177
,'' AS ODCUPL_178    -- Need to be confirmed as mentioned in the mapping sheet
,'' AS ODCUPL_179
,'' AS ODCUPL_180
,'' AS ODCUPL_181
,'' AS ODCUPL_182
,'' AS ODCUPL_183
,'' AS ODCUPL_184
,'UCP LATEST VERSION' AS ODCUPL_185
,'' AS ODCUPL_186
,CASE WHEN m.AcType = '90' THEN 'S' 
	WHEN m.AcType = '9F' THEN 'U' 
 END AS ODCUPL_187
,CONVERT(VARCHAR(10),lm.ExpiryDate,105) AS ODCUPL_188
,lm1.LcCountry AS ODCUPL_189
,'' AS ODCUPL_190
,'' AS ODCUPL_191
,'' AS ODCUPL_192
,'' AS ODCUPL_193
,'' AS ODCUPL_194
,'' AS ODCUPL_195
,'' AS ODCUPL_196
,'' AS ODCUPL_197
,'' AS ODCUPL_198
,'' AS ODCUPL_199
,'' AS ODCUPL_200
,'' AS ODCUPL_201
,'' AS ODCUPL_202
,'' AS ODCUPL_203
,'' AS ODCUPL_204
,'' AS ODCUPL_205
,'' AS ODCUPL_206
,'' AS ODCUPL_207
,'' AS ODCUPL_208
,'' AS ODCUPL_209
,'' AS ODCUPL_210
,'' AS ODCUPL_211
,'' AS ODCUPL_212
,'' AS ODCUPL_213
,'' AS ODCUPL_214
,'' AS ODCUPL_215
,'' AS ODCUPL_216
,'' AS ODCUPL_217
,'' AS ODCUPL_218
,'' AS ODCUPL_219
,'' AS ODCUPL_220
,'' AS ODCUPL_221
,'' AS ODCUPL_222
,'' AS ODCUPL_223
,'' AS ODCUPL_224
,'' AS mudarabalnvstAcct
,'' AS ODCUPL_225
,'' AS ODCUPL_226
,'' AS ODCUPL_227
,'' AS ODCUPL_228
,'' AS ODCUPL_229
,'' AS ODCUPL_230
,'' AS ODCUPL_231
,'' AS ODCUPL_232
,'' AS ODCUPL_233
,'' AS ODCUPL_234
,'' AS ODCUPL_235
,'' AS ODCUPL_236
,'' AS ODCUPL_237
,'' AS ODCUPL_238
,'' AS ODCUPL_239
,'' AS ODCUPL_240
,'' AS ODCUPL_241
,'' AS ODCUPL_242
,'' AS ODCUPL_243
,'' AS ODCUPL_244
,'' AS ODCUPL_245
,'' AS ODCUPL_246
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