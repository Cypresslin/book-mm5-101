# 附錄 - 進階修改：修改 MM5 海溫資料

**以下的修改皆需要動到 MM5 內的 Fortran 程式碼，請三思而後行，此外修改後記得要重新編譯來讓變更生效。**

由於將地表分類替換為海洋後，經由模式自行內插出來的表面溫度（海溫）可能不合理，比如說原本是陸地的部份變成了相對周遭海域較冷的異常區域，這種情況在海洋上不大可能出現。所以可能會需要修改模擬所用的海溫資料。

## 進行修改：

首先要先準備好已經修改好的海溫資料（以此為例叫做 SSTok.dat,二進位檔，其實這檔案就只是個格點數跟模式設定一樣的二維溫度分佈場），要準備這資料最簡單的方式就是拿原本模式輸出的的海溫資料來修改。

修改要由 INTERPF/src/modual_all_io.F 這裡開始。(供模式模擬用的海溫資料似乎是會出現在 MMINPUT 以及 LOWBDY 這兩個檔案裡面)
會需要修改裡面的 add_lbc 以及 outmodel 這兩個副程式

* 若手邊沒有海溫資料...
可以先在這檔案裡面加入一段程式碼讓它輸出 tseasfc 這個變數（應該是 Temperature - Sea Surface 的縮寫吧）再把這裡的值改成你想要的分佈情況。

* 修改 add_lbc
首先在 add_lbc 這支副程式底下（我猜這是 add lower bounday condition 的縮寫）找到下面這段：
    ```
    WRITE ( unit_lowerbc )
    tseasfc_sh%num_dims , tseasfc_sh%start_dims ,
    tseasfc_sh%end_dims , tseasfc_sh%xtime , &
    tseasfc_sh%staggering , tseasfc_sh%ordering ,&
    tseasfc_sh%current_date , tseasfc_sh%name,&
    tseasfc_sh%units , tseasfc_sh%description
    ! 以下這個部份大概只有 i,j 需要另外宣告,tseasfc 是原本放海溫資料的地方
    !===== Overwrite SST from here by Cypresslin
    ! 修改開始
    ! I think this is for LOWBDY
    ! MMINPUT SST should be modified at subroutine outmodel for readin SST data
    open(99,file="SSTok.dat",access="direct",form="unformatted",recl=4*ie*je,status="old")
        read(99,rec=1) ((tseasfc(i,j),j=1,je),i=1,ie)
        ! 讀進新的海溫資料
        print*,"=== Modifing LOWBDY SST ==="
    close(99)
    all_2d(16)%array(is:ie,js:je)=tseasfc
    ! 隨後程式會在這把它寫入 LOWBDY 中
    ! 海溫資料在 all_2d 中是第 16 筆，在這把它放進去
    ! 修改結束
    WRITE ( unit_lowerbc ) tseasfc ! Specific things for surface air temperature small header.
    ```

* 修改 outmodel
於 WRITE ( immout ) ps0 的後面加入讀取海溫資料的程式碼，作法跟前面大致一樣，如下:
    ```
    ! (這裡除了宣告 i,j 還有 tseasfc 要宣告)
    integer :: i,j
    real :: tseasfc(ie,je) ! for Read-In SST Dat
    WRITE ( immout )
    WRITE ( immout )
    num_dims , start_dims , end_dims , xtime , staggering , &
    ordering , current_date , name , units , description
    ps0
    ! Since we do not want to do lots of name checking, the easiest thing to
    ! do is pass all of the 2d fields through. We have to modify the size of
    ! the arrays (possibly) to account for the expanded / unexpanded input.
    ! 修改開始,作法跟先前一樣,讀入海溫然後替換資料
    ! Cypresslin for readin SST data
    open(99,file="SSTok.dat",access="direct",form="unformatted",recl=4*ie*je,status="old")
        read(99,rec=1) ((tseasfc(i,j),j=1,je),i=1,ie)
        print*,"=== Modifing LOWBDY SST ==="
    close(99)
    all_2d(16)%array(is:ie,js:je)=tseasfc ! 2D field number 16 is the SST field in MMINPUT
    ! 修改結束
    ! 後面就是程式自己用 do loop 寫入資料了,不用管他
    DO loop = 1 , num_2d
        IF ( all_2d(loop)%small_header%ordering(1:2) .EQ. 'YX' ) THEN
        WRITE ( immout ) sh_flag
    ```

## 驗證修改結果
在修改結束之後，強烈建議用 MM5toGrADS 等軟體將結果畫出來看看海溫的分佈是不是一如預期的那樣有成功的被修改。

