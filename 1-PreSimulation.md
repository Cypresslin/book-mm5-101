# MM5 模式的前資料處理程序

在這個章節中會以開始一個新的模擬為基準，依序說明各階段的操作步驟。

## TERRAIN 建立地形資料
1.  **解壓縮 TERRAIN.tar.gz：** ```tar –zxvf TERRAIN.tar.gz```
2.  **載入必要之地形、地表資料**
地形高度以及地表分類資料是需要另外下載的，請至 [ftp://ftp.ucar.edu/mesouser/MM5V3/TERRAIN_DATA/](ftp://ftp.ucar.edu/mesouser/MM5V3/TERRAIN_DATA/) 下載需要的資料，在這個 FTP 站裡你會看到 <br>
*由於這些資料檔案不小，若您為工作站管理者可以考慮讓大家共用同一份資料以減少空間的浪費*
3.  **編譯 TERRAIN：**```make > LOG```
4. **生成 terrain.deck**：```make terrain.deck```
5. **修改 terrain.deck**
6. **製作地形資料** [./terrain.deck]

### 常見問題
　　若在製作 30s 的地形時遇上問題，其中一個可能原因就是有缺檔或 30 秒的檔案有問題所造成的，最可能會出現的錯誤訊息是：

*RECORD =     7411,   ERROR OCCURED ON UNIT:   31*

####解決方法：
1. 檢查 ftp30s.out 看看有沒有缺檔的相關訊息，可能會缺 E100N40.DEM 這類檔案。
如果是的話，到 [ftp://edcftp.cr.usgs.gov/data/gtopo30/global/](ftp://edcftp.cr.usgs.gov/data/gtopo30/global/) 抓你要的地形檔，
這裡的地形檔是以區域劃分，不同區域的資料分開放，只要抓 ftp30s.out 裡面抱怨有缺的檔案即可，也可以參考上面的 tiles.gif 來抓檔案。
2. 如果步驟 1 沒辦法解決問題，請清空 TERRAIN/Data30s/資料夾、TERRAIN/Data/ 下的 30sec 資料檔，以及兩個 new_30sec* 檔試試看。
3. 連到 ftp://ftp.ucar.edu/mesouser/MM5V3/TERRAIN_DATA/ ，將所有（或是會用到的）30 秒資料檔抓下來後上傳放到 TERRAIN/DATA/下然後解壓縮（請記得以二進位資料傳輸，不知道怎麼做的話可以直接用瀏覽器開，然後用 FTP 軟體丟上伺服器）。
4. 到 terrain.deck 裡 ftpdata 設為 true，Where30sTer 設為 ftp（電腦會自動搜尋 Data、Data30s 資料夾，裡面有資料就不會抓）。
5. 再次執行 terrain.deck 即可

參考 http://www.mmm.ucar.edu/mm5/faqTerrain.html

## REGRID 處理初始資料
