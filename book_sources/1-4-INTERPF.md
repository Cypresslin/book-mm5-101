# 前置資料處理 - INTERPF（垂直插值）

INTERPF 程式主要目的為垂直插值，將氣象要素場（風場、質量場等等）由等壓面內插到 MM5 座標系統的等 σ 面上，生成完整的模式初始場。

## INTERPF 進行垂直插值

1. **解壓縮**：`tar –zxvf INTERPF.tar.gz`
2. **編譯**：`make`
3. **修改 namelist.input**：   
   * &record0 的部份請指定 input file
   * &record1 的部份為起始時間與結束時間
   * &record2 的部份為 σ - Level 的設定，以楊明仁教授的 [Precipitation Structure and Processes of Typhoon Nari (2001): A Modeling Propsective](http://rain.as.ntu.edu.tw/2003radarconf_mingjen.pdf) 裡面的設定為例則是 32 層：
   ```
   1.00, 0.997, 0.995, 0.992, 0.99, 0.985,0.98,0.975,0.97, 0.965, 0.96,
   0.95, 0.93, 0.90, 0.85, 0.80, 0.75, 0.70, 0.65, 0.60, 0.55, 0.50, 0.45,
   0.40, 0.35, 0.30, 0.25, 0.20, 0.15, 0.10, 0.05, 0.00
   ```
   * &record3 的部份為模式基本物理參數設定
   （後面還有一些其他的設定）
   input file 會需要 REGRID_DOMAIN# 或是 LITTLE_R_DOMAIN# 或者是 RAWINS_DOAMIN# 三者之一的檔案位置（這裡的#為槽狀網格之編號）,端看前一步是採用哪支程式去產生初始場資料。(最後一定要加 /,inputfile= ‘../REGRID_DOMAIN1’ / )
4. **執行程式**： `./interpf`  
   程式執行後，INTERPF 的輸出檔（MMINPUT_DOMAIN#、BDYOUT_DOMAIN#、LOWBDY_DOMAIN#）即為 MM5 進行模擬時所需輸入的資料。

到此前置資料的處理即告一段落！接下來就要準備進行模擬了。
