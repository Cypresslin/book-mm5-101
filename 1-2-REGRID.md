# MM5 模式的前置資料處理程序 - REGRID

在這個章節中基本上會以開始一個新的模擬為基準，依序說明各階段的操作步驟。

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

