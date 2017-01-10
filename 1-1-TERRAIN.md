# 前置資料處理 - TERRAIN（地形地貌）

在這個章節中基本上會以開始一個新的模擬為基準，依序說明各階段的操作步驟。

## TERRAIN 建立地形地貌資料
若先前有建立過地形地貌資料，而在重新進行模擬時模式預報範圍的中心格點位置、格點數、網格間距不變的話就不必再次執行TERRAIN。

1.  **解壓縮 TERRAIN.tar.gz：** ```tar –zxvf TERRAIN.tar.gz```
2.  **載入必要之地形、地表資料**
這些資料是需要另外下載的：
地表分類資料等 - [ftp://ftp.ucar.edu/mesouser/MM5V3/TERRAIN_DATA/](ftp://ftp.ucar.edu/mesouser/MM5V3/TERRAIN_DATA/)
地形高度（Digital Elevation Model; DEM）資料 - [https://dds.cr.usgs.gov/srtm/](https://dds.cr.usgs.gov/srtm/)
這裡的地形資料檔是以區域劃分儲存為不同檔案，以我們最常用的東亞來說，採用的是 e100n40.dem.zip 這個檔案，它指的是東經 100~140 度，北緯 -10~40 度這塊區域的地形檔，詳細的區域劃分可以看網站中的 [srtm30_documentation.pdf](https://dds.cr.usgs.gov/srtm/version2_1/SRTM30/srtm30_documentation.pdf)，裡面有詳細的說明。或者是下載對應的 e100n40.gif.zip 壓縮檔來看繪製出來的 gif 圖，相信這會讓你對所需區域更有概念：
[E100N40](images/E100N40.gif)

*由於這些資料檔案不小，若您為工作站管理者可以考慮讓大家採用 ```ln -sf``` 連結的方式共用同一份資料以減少空間的浪費*

3. **編譯 TERRAIN：**```make &> LOG```
4. **生成 terrain.deck**：```make terrain.deck```
5. **修改 terrain.deck**：
		檔案中開頭有”#”或是”;”的都會被忽略
# --------------------------------------------------------------
#          1. Set up parameter statements
# --------------------------------------------------------------
cat > src/parame.incl.tmp << EOF
C      IIMX,JJMX為模式最大格點數, NSIZE = IIMX*JJMX
       PARAMETER (IIMX = 200, JJMX = 200, NSIZE = IIMX*JJMX)
EOF
cat > src/paramed.incl.tmp << EOF
C      ITRH,JTRH為地形資料的最大格點數
C      NOBT = ITRH*JTRH, here assuming
C      ITRH= 270 ( 45 deg. in north-south direction, 10 min. resolution)
C      JTRH= 450 ( 75 deg. in north-south direction, 10 min. resolution)

（以上面這個為例，若採用每10分一筆地理資料，範圍共45度，所以ITRH=45*6。若如果你用的是30秒的資料，那麼就要把這個參數設大一點。）
（不過也不用擔心輸入的值太小，若遇到這種狀況他會提醒你
THE DIMENSIONS OF DATA IN I AND J ARE        876       888
THE DECLARED DIMENSIONS ITRH,JTRH IN DECK ARE        500       500
INCR	EASE THESE DIMENSIONS AND RERUN
	　此時再把ITRH跟JTRH設定成他要的大小就好）
	
	   PARAMETER (ITRH =  500, JTRH =  500, NOBT = ITRH*JTRH)
    C   PARAMETER (ITRH = 1500, JTRH = 1800, NOBT = ITRH*JTRH)
EOF
# --------------------------------------------------------------
#          2. Set up NAMELIST
# --------------------------------------------------------------
PHIC  =   24.6,      ; 模式中心緯度 (minus for southern hemisphere)
XLONC =  122.3,      ; 模式中心經度 (minus for western hemisphere)
IPROJ = 'LAMCON',		; 投影方式，預設為LAMBERT-CONFORMAL
;IPROJ = 'POLSTR',   	; POLAR STEREOGRAPHIC MAP PROJECTION
;IPROJ = 'MERCAT',		; MERCATOR MAP PROJECTION
MAXNES =    1,		; 標明本次有幾個Domain，標明2則以下設定僅前兩組有效
NESTIX = 	301,	 49,  136,  181,  211, 221, 	; Y方向上格點數
NESTJX = 	271,	 52,  181,  196,  211, 221,	; X方向上格點數
DIS    = 	2.,  30.,   9.,  3.0,  1.0, 1.0, 		; 網格間距(km)，以三倍變化
NUMNC  =	1,     1,    2,    3,    4,   5, 	; 標明其上一層Domain是誰
注意：MM5不能處理重疊的Domain
以上圖為例，應該就要設定為（不列出D05）；
NUMNC  =	1,	1,	1,	2
Domain 1最大，故一定是1，Domain2上一層為Domain1，故也為1…以此類推

NESTI  =    1,   10,   28,   35,   45,  50,  ;	該domain左下角位在上一層的
哪一點(i)，此設定表示D02位在D01中i=10之處，D03位在D02中i=28之處…以此類推
NESTJ  =    1,   17,   25,   65,   55,  50,  ; 	同上，但是為於j點之位置
RID    =  1.5,  1.5,  1.5,  3.1,  2.3,  2.3,	  ; 客觀分析時的影響半徑，於
(IFANAL=T)時才會生效
NTYPE  =    6,    3,    4,    6,    6,   6,  ; 輸入資料的解析度，請參照下表
;
;      1:  1 deg (~111 km) global terrain and landuse
;      2: 30 min ( ~56 km) global terrain and landuse
;      3: 10 min ( ~19 km) global terrain and landuse
;      4;  5 min (  ~9 km) global terrain and landuse
;      5;  2 min (  ~4 km) global terrain and landuse
;      6; 30 sec ( ~.9 km) global terrain and landuse
;


6. **製作地形資料** ``./terrain.deck``
TERRAIN執行後會有三種輸出檔，分別為：
 - 一個圖形檔 TER.PLT（如果有安裝 NCAR 的圖形包）可用 ``idt TER.PLT`` 預覽各 Domain 的地形、地表分類等等
 - 給模式用的二進位檔 TERRAIN_DOMAIN1, TERRAIN_DOMAIN2等等
 - 執行terrain.exe後得到的紀錄檔terrain.print.out
當程式正常執行，你將會在terrain.print.out末尾看到
"= = NORMAL TERMINATION OF TERRAIN PROGRAM = ="
若程式執行失敗，你也會在上述檔案中看到錯誤訊息。

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

REGRID之目的在讀取氣壓層上的氣象分析資料，並把分析資料由原有的格點和地圖投影插值到經由TERRAIN這支前處理程式所定義的網格點和地圖投影上，換句話說就是將NCEP/TOGA資料或是預報場資料，內插到MM5模式網格點上，形成模式初始猜測場。REGRID為MM5系統流程圖中的第二步，他需要來自TERRAIN程式的輸出作為其輸入，並為RAWINS，LITTLE_R，或是INTERPF準備輸入文件

REGRID概略圖

a.解壓縮REGRID.tar.gz：``tar –zxvf REGRID.tar.gz``
b.進行編譯（必要時請修改Makefile）：``make``
c.先執行pregrid
在REGRID/pregrid/下有一支shell script叫做pregrid.csh
請設定好你資料所在位置，以及時間，一般是使用GRIB格式資料
pregrid.csh裡面可能會需要修改的東西如下：

set DataDir = 你資料所在的位置
要讀入的資料格式
#   set SRC3D = ON84  # Old ON84-formatted NCEP GDAS analyses
#   set SRC3D = NCEP  # Newer GRIB-formatted NCEP GDAS analyses
set SRC3D = GRIB  	# Many GRIB-format datasets, 
若選用GRIB，則須更改檔案裡最下方的VT3D, VTSST, VTSNOW, VTSOIL的讀取格式名稱，例：
set VT3D = ( grib.misc/Vtable.ERA3D )
   set VTSST = ( grib.misc/Vtable.ERASST )
   set VTSNOW = ( grib.misc/Vtable.ERASNOW )
   set VTSOIL = ( grib.misc/Vtable.AVNSOIL )

Vtable為變數對照表，可至ECMWF查你需要的變數的code，再看你需要哪一個表，對照表可參考http://cf-pcmdi.llnl.gov/documents/cf-standard-names/ecmwf-grib-mapping

要讀入的資料名稱格式
set InFiles = ( ${DataDir}/EC* )
#   set InFiles = ( ${DataDir}/fnl* )
標明要使用哪種SST資料
#  set SRCSST = ON84
#  set SRCSST = NCEP
#  set SRCSST = NAVY
   set SRCSST = $SRC3D
標明要使用哪種雪的資料
set SRCSNOW = $SRC3D
#   set SRCSNOW = ON84
#   set SRCSNOW = GRIB
模擬起始時間
START_YEAR 	= 2001	# Year (Four digits)
START_MONTH= 09		# Month ( 01 - 12 )
START_DAY 	= 15		# Day ( 01 - 31 )
START_HOUR 	= 12		# Hour ( 00 - 23 )
模擬結束時間
END_YEAR  	= 2001	# Year (Four digits)
END_MONTH	= 09		# Month ( 01 - 12 )
END_DAY  	= 19		# Day ( 01 - 31 )
END_HOUR  	= 00		# Hour ( 00 - 23 )
#
決定處理時間，一般來說分析資料六小時一筆，所以用21600
# Define the time interval to process.
#
INTERVAL =  21600 # Time interval (seconds) to process.

	d.確定pregrid.csh可以執行 [chmod u+x pregrid.csh 此後該檔名應該為綠色字體]
	e.執行pregrid.csh [./pregird.csh]
	f.檢查輸出
確認pregrid程式產生了所需要時間的資料檔。在REGRID/pregrid/下，
檢查每個時間上都獲得了哪些變數場（ex: FILE:yyyy-mm-dd_hh, SNOW_FILE:yyyy-mm-dd_hh, SST_FILE:yyyy-mm-dd_hh等等）
g.修改namelist.input
修改在REGRID/regridder/下的namelist.input檔案，設定要與先前一致
&record1的部份為起始時間與結束時間
&record2的部份為模式物理參數基本設定
&record3的部份為資料來源
root的部份要放剛剛pregrid出來的資料
terrain_file_name則是放上地形檔
constant_full_name則是放上固定不變的場，比如說海溫資料有缺，只有第一筆可用，那就可以把他放進去
例：
root = ‘../pregrid/FILE’ ‘../pregrid/SST_FILE’ ‘../pregrid/SNOW_FILE’
terrain_file_name = ‘../../TERRAIN/TERRAIN_DOMAIN1’
constants_full_name = ‘ ’   /
&record4的部份則是讓你選擇要不要輸出各種除錯訊息
&record5為熱帶氣旋渦旋植入的部份
在namelist中，沒有SNOW的資料也可以，程式會自動略過
h.執行regridder
上述檔案修改完之後就可以執行./regridder
若執行成功將會產生檔案：”REGRID_DOMAIN#”

