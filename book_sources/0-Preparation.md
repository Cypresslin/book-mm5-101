# 使用 MM5 的事前準備

首先就是到：[http://www.mmm.ucar.edu/mm5/](http://www.mmm.ucar.edu/mm5/) 下載 MM5 主程式的壓縮檔啦，看是要在工作站上用 `wget` 指令抓，或者是要在自己的電腦下載好後用 FTP 傳上自己的資料夾都可以。在下載頁面你可能會看到一大堆的壓縮檔，依據不同的情況可能會用上不同的工具，它們的用途大致如下：

| 檔名 | 簡述 | 使用場合 |
| --- | --- | --- |
| INTERPB.tar.gz | 將 σ 座標下的氣象資料內插回 P 座標 | A, B |
| INTERPF.tar.gz | 將 P 座標下的氣象資料內插到模擬用的σ 座標 | A\*, B |
| LITTLE\_R.tar.gz | 利用地面、探空觀測資料進行客觀分析,生成初始客觀分析場（其為 RAWINS 的替代程式） | A, B |
| MM5.tar.gz | 主程式 | A\*, B\* |
| MM5toGrADS.tar.gz | 將輸出檔轉成轉換為 GrADS 繪圖格式之程式 | - |
| MPP.tar.gz | 平行化套件 | A, B |
| NESTDOWN.tar.gz | 將較粗網格的 σ 座標下的氣象資料內插至較細的網格 | A, B |
| RAWINS.tar.gz | 讀入經 REGRID 處理後的資料以及觀測資料，並利用客觀分析將其結合在一起後輸出 P 座標下的氣象資料 | A, B |
| REGRID.tar.gz | 讀取在 P 座標上的氣象分析資料後將其內插至模擬所需之網格點上 | A\*, B |
| RIP4.tar.gz | RIPv4 繪圖程式 | - |
| TERRAIN.tar.gz | 製作模擬所需之地形、地表資料 | A\*, B |

_使用場合 A 表示開始一個全新的模擬時可能會用上的工具。  
使用場合 B 表示接續前人研究時可能會用上的工具。  
星號（\*）表示為必要。_

假設我今天要接續學長姐的模擬，但想看看採用不同數值參數化法會造成什麼樣的結果，那麼基本上只要用 MM5.tar.gz 主程式即可。倘若今天是要將前人的研究資料進一步用更細的網格來模擬，那就可能需要 TERRAIN、INTERPF、INTERPB、REGRID 或是 TERRAIN、NESTDOWN 了。

這張來自 [MM5 Tutorial Class Note](http://www2.mmm.ucar.edu/mm5/documents/MM5_tut_Web_notes/tutorialTOC.htm) 的模擬流程圖可以讓你更了解自己到底需要用上什麼程式：  
![流程圖](images/flow.gif)

