# 附錄 - MM5 副程式對照表

這個頁面記載的內容主要是標明 MM5 中各個副程式的功能，由於網路上似乎沒看到類似的東西，所以就把先前整理的筆記也放上來。同樣的，這個表格**不保證其正確性**。

其實這些副程式的命名都很直觀，而且大多在最前面都會註明其功用，只要稍微看一下大概就可以知道它在做什麼了
（所有與物理參數化法有關的副程式都在MM5/physics底下）

|    名稱    |                 位置                |                簡述                |   從屬   |
|------------|-------------------------------------|------------------------------------|----------|
| COUPLE     | MM5/domain/util/couple.F            | Couple 兩變數用                    | rdinit.F |
| DCPL3D     | MM5/domain/util/dcpl3dwnd.F         | Decouple 三維變數用                | solve.F  |
| DCPL3DWND  | MM5/domain/util/dcpl3d.F            | Decouple 三維風場用                | solve.F  |
| DOTS       | MM5/domain/util/dots.F              | 將 C.-Point 的值內插至 D.-Point 上 |   不定   |
| EQUATE     | MM5/domain/util/equate.F            | 讓 A 陣列等於 B 陣列               |   不定   |
| EQUATO     | MM5/domain/util/equate.F            | 同上                               | outtap.F |
| PARAM      | MM5/domain/initial/param.F          | 常數之定義                         | mm5.F    |
| PARAMR     | MM5/domain/initial/paramr.F         | 雲微物理參數化法常數之定義         | param.F  |
| OUTTAP     | MM5/domain/io/outtap.F              | 輸出模擬資料                       |   不定   |
| OUTPRT     | MM5/domain/io/outprt.F              | 印出部份模擬資料供快速檢驗用       |   不定   |
| HADV       | MM5/physics/advection/simple/hadv.F | 計算水平通量輻散                   | solve.F  |
| VADV       | MM5/physics/advection/simple/vadv.F | 計算垂直通量輻散                   | solve.F  |
| SOLVE      | MM5/dynamics/nonhydro/solve.F       | MM5 的主要計算核心                 | mm5.F    |
