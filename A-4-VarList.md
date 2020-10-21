# 附錄 - MM5 變數表

以下這些變數是當初為了論文而陸續從 MM5 (Version 3.5) 原始程式碼裡整理出來的，有鑑於當初一直找不到類似的變數表所以把當初的筆記放上來，不過要注意：** 由於同一個變數名稱在不同位置裡可能會用來存放不同的資料，而且也可能隨著版本不同有差異，所以這個表格不保證其正確性，使用時請配合 MM5 手冊**

常數大多可以在 MM5/domain/initial/param.F 裡面找到，各欄位補充說明如下：
* 參考 - 該行程式碼的行號。
* 位置 - C 表示交錯網格上的 Cross Point，D 則為交錯網格上的 Dot Point
* 變數 XXXA 指變數 XXX 在當前 TimeStep 的值，而 XXXB 則是變數 XXX 在前一個 TimeStep 的值
* 此處的手冊指 MM5 Source Code Documentation

|    變數    | 維度 | 位置 | 耦合 |      單位      |                      內容                      |               參考                |
|------------|------|------|------|----------------|------------------------------------------------|-----------------------------------|
| DX         | 常數 |  -   |  -   | m              | 網格間距                                       | PARAM.583                         |
| DX2/4/8/16 | 常數 |  -   |  -   | m              | 2/4/8/16倍網格間距                             | PARAM.1823                        |
| IL         | 常數 |  -   |  -   | 無單位         | 模式南北向點數                                 |                                   |
| JL         | 常數 |  -   |  -   | 無單位         | 模式東西向點數                                 |                                   |
| ILX        | 常數 |  -   |  -   | 無單位         | 模式南北向點數-1                               | INITTS.68                         |
| JLX        | 常數 |  -   |  -   | 無單位         | 模式東西向點數-1                               |                                   |
| MIX        | 常數 |  -   |  -   | 無單位         | 模式最大南北向點數                             | configure.user                    |
| MJX        | 常數 |  -   |  -   | 無單位         | 模式最大東西向點數                             | configure.user                    |
| MKX        | 常數 |  -   |  -   | 無單位         | Half-σ層之層數                                 | configure.user                    |
| PTOP       | 常數 |  -   |  -   | kPa            | 模式層頂氣壓值                                 | 手冊/24SEP99.37                   |
| PT         | 常數 |  -   |  -   | Pa             | 模式層頂氣壓值                                 | SOLVE.241                         |
| A          |  1   |  -   |  否  | 無單位         | Half-σ層                                       | 手冊                              |
| SIGMA      |  1   |  -   |  否  | 無單位         | Full-σ層                                       | PARAM.566                         |
| DSIGMA     |  1   |  -   |  否  | 無單位         | 兩σ層的差異量                                  | 手冊 / PARAM.567                  |
| F          |  2   |  D   |  否  | 1/s            | 柯氏力                                         | 手冊 / OUTTAP.951                 |
| MSFD       |  2   |  D   |  否  | 無單位         | 地圖比例的倒數                                 | 手冊 / INITNEST.963               |
| MSFX       |  2   |  C   |  否  | 無單位         | 地圖比例的倒數                                 | 手冊 / INITNEST.971               |
| PBL        |  2   |  C   |  否  | m              | 邊界層高度                                     | 手冊 / OUTTAP.1005                |
| PDOTA      |  2   |  D   |  否  | kPa            | Dot Point上的P\*，來自PSA                      | INITNEST.940                      |
| PDOTB      |  2   |  D   |  否  | kPa            | 同上，但為t-dt之結果                           | INITNEST.952                      |
| PS0        |  2   |  C   |  否  | Pa             | 參考地面氣壓（註1）                            | 手冊 / RDINIT.426                 |
| PSA        |  2   |  C   |  否  | kPa            | P\*                                            | OUTTAP.838                        |
| RAINC      |  2   |  C   |  否  | cm             | 積雲性累積降水量                               | 手冊 / OUTTAP.866                 |
| RAINNC     |  2   |  C   |  否  | cm             | 非積雲性累積降水量                             | 手冊 / OUTTAP.866                 |
| RPSA       |  2   |  C   |  否  | 1/kPa          | 1/P\*                                          | INIT.164                          |
| RPSB       |  2   |  C   |  否  | 1/kPa          | 同上，但為t-dt之結果                           | INIT.165                          |
| RPDOTA     |  2   |  D   |  否  | 1/kPa          | 1/P\*                                          | INIT.173                          |
| RPDOTB     |  2   |  D   |  否  | 1/kPa          | 同上，但為t-dt之結果                           | INIT.174                          |
| SATBRT     |  2   |  C   |  否  | 無單位         | 地表分類                                       | 手冊 / OUTTAP.979                 |
| SNOWC      |  2   |  C   |  否  | 無單位（或mm） | 是否有積雪（或雪的等量水量）                   | 手冊 / 05DEC01.277（05DEC01.280） |
| TGA        |  2   |  C   |  否  | K              | 地面溫度                                       | 手冊 / OUTTAP.853                 |
| TSS        |  2   |  C   |  否  | K              | 海表面溫度                                     | 24SEP99.165                       |
| XLAT       |  2   |  C   |  否  | 度             | 緯度                                           | 手冊 / OUTTAP.965                 |
| XLON       |  2   |  C   |  否  | 度             | 經度                                           | 手冊 / OUTTAP.972                 |
| PPA        |  3   |  C   |  是  | kPa\*Pa        | 耦合擾動壓力場（P\*P'）                        | 手冊 / OUTTAP.825                 |
| PPB        |  3   |  C   |  是  | kPa\*Pa        | 同上，但為t-dt之結果                           | 手冊                              |
| PP3D       |  3   |  C   |  否  | Pa             | 擾動壓力場（P'）                               | SOLVE.204                         |
| PR0        |  3   |  C   |  否  | Pa             | 參考壓力場（P0）                               | RDINIT.430                        |
| PR1        |  3   |  C   |  否  | Pa             | 完整壓力場 P                                   | SOLVE.253                         |
| QV3D       |  3   |  C   |  否  | kg/kg          | 水汽混合比，DCPL3D (QVB,PSB)                   | SOLVE.602                         |
| QV3DTEN    |  3   |  C   |  是  | kPa\*kg/kg/dt  | 耦合水汽混合比變化趨勢項                       | SOLVE.1722                        |
| QVA        |  3   |  C   |  是  | kPa\*kg/kg     | 耦合水汽混合比（P\*qv）                        | 手冊 / OUTTAP.700                 |
| QVB        |  3   |  C   |  是  | kPa\*kg/kg     | 同上，但為t-dt之結果                           | 手冊                              |
| QC3D       |  3   |  C   |  否  | kg/kg          | 雲水混合比，DCPL3D (QCB,PSB)                   | SOLVE.604                         |
| QC3DTEN    |  3   |  C   |  是  | kPa\*kg/kg/dt  | 耦合雲水混合比變化趨勢項                       | SOLVE.1794                        |
| QCA        |  3   |  C   |  是  | kPa\*kg/kg     | 耦合雲水混合比(P\*qc)                          | 手冊 / OUTTAP.710                 |
| QR3D       |  3   |  C   |  否  | kg/kg          | 雲水混合比(qc)                                 | SOLVE.218                         |
| QR3DTEN    |  3   |  C   |  是  | kPa\*kg/kg/dt  | 耦合雨水混合比變化趨勢項                       | SOLVE.1795                        |
| QRA        |  3   |  C   |  是  | kPa\*kg/kg     | 耦合雨水混合比(P\*qr)                          | 手冊 / OUTTAP.718                 |
| QI3D       |  3   |  C   |  否  | kg/kg          | 雲冰混合比(qi)                                 | SOLVE.224                         |
| QI3DTEN    |  3   |  C   |  是  | kPa\*kg/kg/dt  | 耦合雲冰混合比變化趨勢項                       | SOLVE.1813                        |
| QIA        |  3   |  C   |  是  | kPa\*kg/kg     | 耦合雲冰混合比(P\*qi)                          | 手冊 / OUTTAP.728                 |
| QG3D       |  3   |  C   |  否  | kg/kg          | 軟雹混合比(qg)                                 | SOLVE.231                         |
| QG3DTEN    |  3   |  C   |  是  | kPa\*kg/kg/dt  | 耦合軟雹混合比變化趨勢項                       | SOLVE.1832                        |
| QGA        |  3   |  C   |  是  | kPa\*kg/kg     | 耦合軟雹混合比(P\*qg)                          | 手冊 / OUTTAP.747                 |
| QNI3D      |  3   |  C   |  否  | kg/kg          | 雪片混合比(qs)                                 | SOLVE.225                         |
| QNI3DTEN   |  3   |  C   |  是  | kPa\*kg/kg/dt  | 耦合雪片混合比變化趨勢項                       | SOLVE.1814                        |
| QNIA       |  3   |  C   |  是  | kPa\*kg/kg     | 耦合雪片混合比(P\*qs)                          | 手冊 / OUTTAP.736                 |
| QNC3D      |  3   |  C   |  否  | #/kg           | 雲冰粒子濃度                                   | SOLVE.232                         |
| QNCA       |  3   |  C   |  是  | kPa\*#/kg      | 耦合雲冰粒子濃度                               | 手冊 / OUTTAP.755                 |
| RTTEN      |  3   |  C   |  否  | K/s            | 大氣輻射趨勢                                   | OUTTAP.805                        |
| T3D        |  3   |  C   |  否  | K              | 溫度場(T)                                      | SOLVE.203                         |
| TA         |  3   |  C   |  是  | kPa\*K         | 耦合溫度場                                     | OUTTAP.681                        |
| TB         |  3   |  C   |  是  | kPa\*K         | 同上，但為t-dt之結果                           | SOLVE.598                         |
| Tv         |  3   |  C   |  否  | K              | 虛溫，所用公式為 Tv=T3D\*(1+0.608\*qv\*XMOIST) | SOLVE.432                         |
| T3DTEN     |  3   |  C   |  是  | kPa\*K         | 溫度趨勢項                                     | SOLVE.873                         |
| U3D        |  3   |  D   |  否  | m/s            | U 風場                                         | SOLVE.186                         |
| UA         |  3   |  D   |  是  | kPa\*m/s       | 耦合 U 風場 (P\*V)（隨後該變數會乘上地圖比例） | 手冊 (SOLVE.158)                  |
| UB         |  3   |  D   |  是  | kPa\*m/s       | 同上，但為t-dt之結果                           | SOLVE.596                         |
| UCC        |  3   |  C   |  否  | m/s            | 位在 CrossPoint 上的 U 風場                    | SOLVE.272                         |
| V3D        |  3   |  D   |  否  | m/s            | V 風場                                         | SOLVE.186                         |
| VA         |  3   |  D   |  是  | kPa\*m/s       | 耦合 V 風場 (P\*V)（隨後該變數會乘上地圖比例） | 手冊 (SOLVE.158)                  |
| VB         |  3   |  D   |  是  | kPa\*m/s       | 同上，但為t-dt之結果                           | SOLVE.597                         |
| VCC        |  3   |  C   |  否  | m/s            | 位在 CrossPoint 上的 V 風場                    | SOLVE.274                         |
| W3D        |  3   |  C   |  否  | m/s            | W 風場                                         | SOLVE.205                         |
| WA         |  3   |  C   |  是  | kPa\*m/s       | 耦合 W 風場 (P\*W)	                            | OUTTAP.817                        |
| WB         |  3   |  C   |  是  | kPa\*m/s       | 同上，但為t-dt之結果                           | SOLVE.599                         |

註1：手冊中指明此變數為 Reference Surface Pressure，但在Code中 PS0=PSA（單位為 Pa），透過 PR0 的方程式（RDINIT.430）也可知 PS0 不單純是 Ps，而是 Ps-Pt（也就是 P\*）
