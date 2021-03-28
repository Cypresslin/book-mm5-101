# 後處理 - INTERPB（垂直插值）

不知道你是否有注意到這支程式跟先前[前置資料處理 - 垂直插值](1-4-INTERPF.md)章節中提到的程式名字 INTERPF 只差一個字母，我個人是將這裡的 B 解釋為 Backward，F 則是 Forward。因為這支程式是要將 MM5 座標系統垂直方向 σ 座標下的氣象資料內插回 P 座標，製作出來的資料可以供 REGRIDDER、LITTLE_R、INTERPF 等程式使用。

## INTERPB 進行垂直插值

1. **解壓縮**：`tar –zxvf INTERPB.tar.gz`
2. **編譯**：`make`
3. **修改 namelist.input**：
   * &record0 的部份請指定 input file
   * &record1 的部份為起始時間與結束時間
   * &record2 的部份為等壓層的設定
4. **執行程式**： `./interpb`  
   程式執行後將會生成 FILE_MMOUTP: ###### 的中繼格式檔 (intermediate format)。
   假如我要利用 Domain03 的模擬結果來當作 Domain04 的初始場以及邊界資料，那麼就可以經由 INTERPB 這支程式來完成（應該也是可以用 NESTDOWN 來做）。首先就是將 D03 的模擬結果當作這裡的 input file，然後執行完 interpb 後，在 regridder 中把 &record3 的部份指向剛剛 interpb 輸出的結果來產生新的 REGRID_DOMAIN#，再照正常程序繼續製作 MM5 所需之輸入資料即可。
