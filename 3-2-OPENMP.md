# 平行化運算 - OpenMP

被 MPPMM5 搞瘋了嗎？沒關係，這裡還有一個能夠讓 MM5 多核的跑法就是 OpenMP。它的平行方式是屬於共享式記憶體，也就是讓很多顆處理器使用本機上同一塊記憶體，如下圖：
![OpenMP](/images/openmp.gif)

其優點在於不用透過網路所以不會受網路傳輸速度的限制（高速的 Fibre channel switch 可不便宜啊！），而且因為是存取同一個記憶體區塊，所以在針對在對記憶體區塊的存取較容易，不用透過網路所以也比較快，缺點則是在硬體上很難再擴充，如果還要再增加處理器的話，會造成處理器到記憶體 datapath 的 overload，因此使用越多處理器反而不一定能增加效能。且由於 OpenMP 是採用分享記憶體的方式，所以是不能跨機台使用的。

參考：[OpenMP與MPI的差別 - 雜七雜八的kewang部落格](http://kewang.pixnet.net/blog/post/2959194)

## 編譯 OpenMP MM5

OpenMP 的使用方式相對來說簡單不少，不需要下載和安裝，只要 CPU 以及編譯器有支援就可以了。

1. **修改 MM5/configure.user**：  
   OpenMP 的 configure.user 設定可使用單核的 configure.user (在 section 3i1 的部分，註解原本的 FCFLAGS 和 LDOPTIONS,再將有“-mp”的選項的 FCFLAGS 和
LDOPTIONS 註解掉,其他設定與單核的相同),並將基本的模式參數、物理參數設定完。
2. **編譯**：`make`
3. **製作並修改 mm5.deck**：`make mm5.deck`
4. **開始模擬**：  
   OpenMP 是使用 csh 的環境，如果是使用其他環境的話可以用 `csh` 指令切過去，用 `exit` 可以離開 csh。切換到 csh 後，先打 `unlimit`（此指令並非所有電腦都需要）
,再來是
選擇你要使用幾顆處理器[setenv OMP_NUM_THREADS #](#=幾顆 cpu),接下來
要告訴電腦你要切成的記憶體大小[setenv MPSTKZ #M] (#=記憶體大小,如: 256M),
設定完以後就可以執行 MM5 了[./mm5.deck]。
e.其他
1. 由於 OpenMP 是使用 csh,因此在編寫 qsub.sh 時,在最一開始要記得打上
#!/bin/csh
2. 如果你的設定中,ISOIL=2 的話,在做 OpenMP 時,你需要修改一些物理過程
的程式,否則會出現錯誤訊息。要修改的程式在 MM5/physics/pbl_sfc/osusfc
底下,有:
dcoef.F
hrt.Fhrtice.F
hstep.F
nopac.F
penman.F
sflx.F
smflx.F
snopac.F
srt.F
sstep.F
如何修改請自行參閱
http://www.mmm.ucar.edu/mm5/mm5v3/clues/mm5-openmp.html
