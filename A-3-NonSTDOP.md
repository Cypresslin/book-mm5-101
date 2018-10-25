# 附錄-進階修改 - 非標準資料之輸出

**以下的修改皆需要動到 MM5 內的 Fortran 程式碼，請三思而後行，此外修改後記得要重新編譯來讓變更生效。**

由於有時候會需要一些非標準輸出的值（如邊界層參數化造成的風場變化趨勢、雲微物理造成的溫度變化趨勢等等）此時就需要修改 MM5 主程式，讓它能夠在運算的過程中就把這些數值給丟出來。

## 進行修改：

在 MM5 中負責主要計算的程式為 MM5/dynamics/nonhydro/solve.F 這支程式會依據你所選擇的各種物理過程呼叫不同的副程式，而這些相關的副程式大多位於 MM5/physics 底下。一般來說如果只是想要得到經過某項物理過程之後的結果，那麼修改 solve.F 就夠了。

在 solve.F 中，XTIME 為目前時間，單位是分鐘。
mix/mjx 分別為 i、j 方向上 Cross Point 的格點數。
ILX/JLX 分別為 i,j 方向上 Dot Point 的格點數 (ILX=mix-1, JLX=mjx-1)
就看需要什麼變數再來修改吧,總之記得修改完要重新編譯。

## 範例 - 取得邊界層參數化對水平風場造成之摩擦力影響

假設我們需要取得邊界層參數化中水平風場所受到的摩擦力，那就可以從攔截經過邊界層參數化運算後的值來下手。以下為 solve.F 中呼叫 MRF 邊界層參數化副程式的程式碼：

c$omp&private(j)                                                                 SOLVE.1026
Ccsd$ parallel do private(j) schedule(static,1)                                  23DEC04.775
        DO J=1,JLX                                                               07NOV00.1038
          PARJSUM(ITQEVA_SUM,J)=0.0                                              SOLVE.1028
          CALL MRFPBL(IYY,JXX,J,INEST,U3D,V3D,T3D,QV3D,PP3D,QC3D,QI3D,           SOLVE.1029
     +         QNC3D,UCD,VCD,QC3DTEN,T3DTEN,QV3DTEN,QI3DTEN,QNC3DTEN,            07NOV00.1039
     +         TGA,TGB,PSB,RPSB,XLV,                                             07NOV00.1040
     +         TA2,QA2,UA10,VA10,                                                07NOV00.1041
     +         SVP1,SVP2,SVP3,SVPT0,EP1,EP2,ZNT,XLAND,UST,                       07NOV00.1042
     +         MAVAIL,                                                           07NOV00.1043
     +         REGIME,HOL,PBL,ZOL,MOL,QFX,HFX,RV,TSLA,TSLB,T0,PPB,               07NOV00.1044
     +         HFXSI,QFXSI,TGSI,SEAICE,                                          23DEC04.776
     +         EMISS,GLW,GSW,TMN,CAPG,SNOWC,XLAT,XLONG,                          07NOV00.1045
     +         RAINP,RAINC,RAINNC,                                               07NOV00.1046
     +         PRW,ALB,SHC,THC,SATBRT,                                           07NOV00.1047
     +         XMOIST,ISICE,                                                     23DEC04.777
     +         INTERIOR_MASK,                                                    07NOV00.1049
     +         1,ILX)                                                            07NOV00.1050
        ENDDO                                                                    SOLVE.1031
Ccsd$ end parallel do                                                            23DEC04.778

在這邊的 UCD 以及 VCD 即為 U V 風場兩個方向的摩擦力項，只要在這段程式碼後面把它們取出來即可。在此例中 UCD 與 VCD 一開始為零，直到經過 MRFPBL 運算後才有值，所以沒有必要做運算前與運算後的相減。在處理不同參數時可能有不同的狀況，記得要適時的把值取出來檢查看看。
