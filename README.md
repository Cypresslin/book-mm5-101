# 序

這份文件大概是在我碩班畢業後的暑假整理出來的，當時跟勇伯實驗室的同學一起為學弟妹開了幾天的教學課程，所以除了本文之外還有當時大家一起整理出來的 WRF、GrADS 與 RIP4 教學文件，剛好網路上有這個平台可以讓這些文件繼續活下去，未來有機會的話會把它們也放上來。

當初跑 MM5 試了不少有趣的組合，舉凡從原始碼編譯 32bit / 64bit、單機單核心 / 多核心以及單機 / 跨機多核心的版本，到實際去修改裡面的程式碼都碰過了，雖然還說不上熟到能夠倒背如流，不過應該是差不多能應付一般的狀況，跌跌撞撞後差不多也能把這些經驗撰寫成冊來分享一下。不過可惜用 MM5 的人似乎有越來越少的趨勢，哈哈！畢竟 NCAR 也已經[停止了 MM5 的開發](http://www2.mmm.ucar.edu/mm5/support/consult.html)。

總之，希望這份手冊能對有興趣的人有所幫助。手冊的編寫除了集合了 MM5 網站的[說明以及教學](http://www2.mmm.ucar.edu/mm5/documents/MM5_tut_Web_notes/tutorialTOC.htm)、每一次的教學內容以及自己的操作筆記之外，也參考了登舜學長在我當年剛進實驗室時給我的「MM5 簡要操作手冊」。此外建議中央的學弟妹若對模式有興趣，可以選修數值模擬或降水模擬（兩門課內容其實一樣）以及更為進階的降水模擬特論，來對數值模式有更多一點的認識。

### 系統環境

本文的編寫是以當初在實驗室裡的主機（Red Hat Enterprise Linux, 2.6.9-89.ELlargesmp）為基準。

### 修改與建議

如果在實際操作的過程中發現文中有什麼錯誤的地方，或是想加些別的說明，也歡迎至 [Github](https://github.com/Cypresslin/book-mm5-101) 送 Pull Request。

### 授權

採用創用 CC 姓名標示-非商業性-相同方式分享 4.0 國際 授權條款授權，您可以自[此網址](http://creativecommons.org/licenses/by-nc-sa/4.0/)取得授權條款全文。  
[![Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](images/cc-by-nc-sa.png)](http://creativecommons.org/licenses/by-nc-sa/4.0/)

