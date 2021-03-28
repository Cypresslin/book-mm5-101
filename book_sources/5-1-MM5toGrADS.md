# 後處理 - 轉為 GrADS 格式

模擬出來的檔案可以透過 MM5toGrADS 這個程式轉換為 GrADS 繪圖軟體所用的格式。

## 編譯 MM5toGrADS
1. **解壓縮**： `tar –zxf MM5toGrADS.tar.gz`
2. **修改 Makefile 並編譯**： `make`  
   在 Makefile 中找到你的機器（例如 Linux），按照情況修改 FC flag。以 Linux 為例會需要修改的參數大概就是:
    * -tp px
    這後面要接你的處理器，如 px / athlon / k8-64 等等。或者把他刪掉也可以，預設會用編譯器所用的 CPU。
    * -byteswapio 
    資料大小頭的設定不用改,告訴電腦這是吃 swap 的
    編譯成功會出現 grads.exe,不過要注意編譯器有沒有吐錯誤訊息
3. **修改 namelist.input**： 
    在這可以選擇所要輸出的變數，以及所要採用的垂直座標等等
4. **修改並執行 mm5_to_grads.csh**： `./mm5_to_grads.csh` 
    在這個 csh 腳本檔裡指定你的輸出名稱以及輸入檔案的位置（輸入檔案可以是 TERRAIN、REGRID、MMINPUT、MMOUT等）接著就可以執行這個 csh 檔

## 進階修改 - 高度場之取得
由於 MM5toGrADS 雖然會計算出 σ 層距離地表之高度，但是卻沒有辦法繪製等高面之水平剖面。所以如果想要以等高座標繪製剖面就得自行寫程式進行座標轉
換，程式中計算高度的程式碼如下（位於 MM5toGrADS/src/grads.F 中，808 行的位置）：
```
    do k=1,kl
    do j=1,jlx
    do i=1,ilx
      ps0=p00*exp( (-1.*ts0/tlp)+(( ((ts0/tlp)**2.)-(2.*G*(ter(i,j)/(tlp*R))) )**0.5) )
      phydro=(ps0-ptop)*sigma(k)+ptop
      z(i,j,k)=-1.*( ((R*tlp/2./G)*((ALOG(phydro/p00)**2))) + ((R*ts0/G)*ALOG(phydro/p00)) )
      z(i,j,k)=z(i,j,k)-ter(i,j)
    enddo
    enddo
    enddo
```
可以看到最後求得的高度 z 是減去了地形高度 ter(i,j) 的距地表之高度。如果想要取得某變數在等高面上的值，大概是這樣處理的：
1. 先取得該 σ 層距離海平面之高度，也就是不要減去地形高度
2. 接著用這個高度值，配合對應的變數內插至想要的高度上即可
