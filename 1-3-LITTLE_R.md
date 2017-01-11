# 前置資料處理 - LITTLE_R（客觀分析）

LITTLE_R 為客觀分析用的程式,有要合併觀測資料時才要用（此程式較 RAWINS 新，但兩者做的事情是一樣的，故若要進行客觀分析則建議使用這個程式）。它採用 Cressman 逐步修正法,用地面和探空觀測資料對 REGRID 產生的初始猜測場進行逐步修正，產生客觀分析場。

MM5 模式允許跳過客觀分析，直接用初始猜測場進行預報。

## LITTLE_R 進行客觀分析

1. **解壓縮**：`tar –zxvf LITTLE_R.tar.gz`
2. **編譯**：`make`
3. **修改 namelist.input**： 
   修改開始以及結束時間,還有 obs_filename 中回應的時間參數，以及其他參數。
4. **執行程式**：`./little_r`： 
   成功執行 LITTLE_R 後，會生成檔案 "LITTLE_R_DOMAIN1"
