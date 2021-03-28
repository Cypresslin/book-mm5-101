      SUBROUTINE CRLWMSK(NLAT, NLON, RESOL, XLAT_MSK, XLON_MSK,                  CRLWMSK.1
     -                   NUNIT1,   NUNIT2,  IX,   JX, XLAT,  XLON,               CRLWMSK.2
     -                     ZLON,     ZLAT, ZLW,    N, LREC,                      CRLWMSK.3
     -                  GRDLNMN, GRDLTMN, FORCETER,YYY,NAME,IDW,IP)              05DEC01.1
C                                                                                CRLWMSK.5
# include <parame.incl>                                                          CRLWMSK.6
# include <paramesv.incl>                                                        CRLWMSK.7
# include <paramed.incl>                                                         CRLWMSK.8
# include <io.incl>                                                              06NOV00.10
# include <maps.incl>                                                            CRLWMSK.9
# include <nestdmn.incl>                                                         CRLWMSK.10
# include <ltdata.incl>                                                          CRLWMSK.11
C                                                                                06NOV00.11
      DIMENSION FORCETER(IX,JX), YYY(IX,JX,3),                                   CRLWMSK.12
     -          IBOX(NSIZE), JBOX(NSIZE)                                         CRLWMSK.13
      DIMENSION XLAT(IX,JX), XLON(IX,JX), ZLON(NOBT), ZLAT(NOBT),                CRLWMSK.14
     -          ZLW(NOBT)                                                        CRLWMSK.15
      DIMENSION WORK(NOBT),IWORK1(2160/4+2),IWORK2(2160/2+2)                     CRLWMSK.16
#if (defined(SUN) || defined(HP))
      INTEGER*2 IWORK3(43200)                                                    CRLWMSK.18
#else                                                                            CRLWMSK.19
      INTEGER*1 IWORK3(43200)                                                    CRLWMSK.20
#endif                                                                           CRLWMSK.21
      INTEGER*2 IWORK4(43200)                                                    CRLWMSK.22
      CHARACTER*1 IWORK3_CHR(43200)                                              CRLWMSK.23
      CHARACTER*2 IWORK4_CHR(43200)                                              CRLWMSK.24
      CHARACTER*(*) NAME                                                         CRLWMSK.25
C                                                                                CRLWMSK.26
C .. SIX RESOLUTIONS:                                                            06NOV00.12
C                                                                                06NOV00.13
      IRESO_SEC = NINT(60.*(RESOL*60.))                                          CRLWMSK.28
      IRESO_SEC = NINT(60.*(RESOL*60.))                                          06NOV00.14
      DO II = 1,max_type                                                         06NOV00.15
        JRESO_SEC = NINT(60.*(CENTER(II)*60.))                                   06NOV00.16
        IF (IRESO_SEC.EQ.JRESO_SEC) THEN                                         06NOV00.17
          NR = II                                                                06NOV00.18
          GO TO 8                                                                06NOV00.19
        ENDIF                                                                    06NOV00.20
      END DO                                                                     06NOV00.21
C                                                                                CRLWMSK.40
  8   IF (IP.EQ.1) PRINT 10,NAME,RESOL,NR,NUNIT1,N                               06NOV00.22
 10   FORMAT(/1X,'CALL CRLWMSK: FOR ',A8,2X,'RESOL=',F8.5,                       CRLWMSK.42
     -        '(NR=',I2,'),  UNIT=',I2,' DOMAIN ',I2)                            CRLWMSK.43
C                                                                                CRLWMSK.44
C calls check data only for SiB dataset: water cat = 15                          05DEC01.2
      IF (IDW.EQ.15)                                                             05DEC01.3
     -CALL CHECK_DATA(XMINLAT,XMAXLAT,XMINLON,XMAXLON,                           05DEC01.4
     -                XLAT_MSK, XLON_MSK,NLAT,NLON,RESOL,NAME)                   CRLWMSK.46
C                                                                                CRLWMSK.47
C  .. READ IN THE DATA:                                                          CRLWMSK.48
C                                                                                CRLWMSK.49
         CALL RDLDTR(1,NLON,NLAT,LREC,                                           CRLWMSK.50
     1            XLAT_MSK,XLON_MSK,CENTER(NR),GRDLTMN,GRDLNMN,                  CRLWMSK.51
     2            XMAXLAT,XMINLAT,XMAXLON,XMINLON, -1, 2, 1,                     CRLWMSK.52
     3             NUNIT1,LNDNAME(N), 0,NUNIT2,TERNAME(N),                       CRLWMSK.53
     4            IWORK1,IWORK2,IWORK3,IWORK4,                                   CRLWMSK.54
     5                          IWORK3_CHR,IWORK4_CHR,IP)                        06NOV00.23
      IF (IP.EQ.1) PRINT 5001,NAME,N,LREC                                        06NOV00.24
 5001 FORMAT(1X,'==> ',A8,' DATA READ IN FOR DOMAIN ',I2,'  LREC=',I8)           CRLWMSK.57
C                                                                                CRLWMSK.58
C       DO I = 1,LREC                                                            05DEC01.5
CC          PRINT 5010,I,ZLAT(I),ZLON(I),ZLW(I)                                  CRLWMSK.60
 5010     FORMAT('I=',I8,' LAT,LON,ZLW:',3F10.2)                                 CRLWMSK.61
C       END DO                                                                   05DEC01.6
C                                                                                CRLWMSK.63
      DO I = 1,IX                                                                CRLWMSK.64
        DO J = 1,JX                                                              CRLWMSK.65
          FORCETER(I,J) = 0.                                                     CRLWMSK.66
          DO NC = 1,3                                                            CRLWMSK.67
            YYY(I,J,NC) = 0.0                                                    CRLWMSK.68
          END DO                                                                 CRLWMSK.69
        END DO                                                                   CRLWMSK.70
      END DO                                                                     CRLWMSK.71
C                                                                                CRLWMSK.72
      DSGRID = RESOL                                                             CRLWMSK.73
      INCR = 1./DSGRID+0.001                                                     CRLWMSK.74
      IF(IP.EQ.1) PRINT 6, RESOL,INCR                                            06NOV00.25
6     FORMAT(/2X,'CREATE LAND-WATER MASK-RESOLUTION =',F8.5,3X,                  06NOV00.26
     1       'INCR=',I3)                                                         CRLWMSK.77
      IF(IP.EQ.1) PRINT 7, LREC,GRDLNMN, GRDLTMN                                 06NOV00.27
7     FORMAT(2X,' NOBS=',I8,4X,' ==< GRDLNMN=',F10.2,                            06NOV00.28
     1                            '   GRDLTMN=',F10.2,'>==')                     CRLWMSK.80
C                                                                                CRLWMSK.81
C-----CONVERT ZLON AND ZLAT FROM LON AND LAT TO X AND Y IN MESH                  CRLWMSK.82
C                                                                                CRLWMSK.83
      CALL XYOBSLL(ZLAT,ZLON,ZLW,LREC,IXEX,JXEX,DIS(1),                          CRLWMSK.84
     1             XSOUTH(N),XWEST(N),NRATIO(N),N-1,1)                           CRLWMSK.85
C                                                                                CRLWMSK.86
      NIX = 0                                                                    CRLWMSK.87
      DO MM = 1,LREC                                                             CRLWMSK.88
        IF (ZLAT(MM).GE.0.0 .AND. ZLAT(MM).LE.IX .AND.                           CRLWMSK.89
     1      ZLON(MM).GE.0.0 .AND. ZLON(MM).LE.JX) THEN                           CRLWMSK.90
        NIX = NIX+1                                                              CRLWMSK.91
CC        PRINT 1002,NIX,MM,ZLAT(MM),ZLON(MM),ZLW(MM)                            CRLWMSK.92
 1002   FORMAT('NIX=',I6,2X,I6,' YIC,XIC,ZLW:',3F12.4)                           CRLWMSK.93
C                                                                                CRLWMSK.94
        ICAT = NINT(ZLW(MM)*100.) + 2                                            CRLWMSK.95
        I0 = INT(ZLAT(MM)+0.5)                                                   CRLWMSK.96
        J0 = INT(ZLON(MM)+0.5)                                                   CRLWMSK.97
          IF (I0.GE.1 .AND. I0.LE.IX-1 .AND.                                     CRLWMSK.98
     1        J0.GE.1 .AND. J0.LE.JX-1 ) THEN                                    CRLWMSK.99
              YYY(I0,J0,ICAT) = YYY(I0,J0,ICAT) + 1.0                            CRLWMSK.100
          ENDIF                                                                  CRLWMSK.101
        ENDIF                                                                    CRLWMSK.102
      END DO                                                                     CRLWMSK.103
C                                                                                CRLWMSK.104
      NBOX = 0                                                                   CRLWMSK.105
      DO I = 1,IX-1                                                              CRLWMSK.106
      DO J = 1,JX-1                                                              CRLWMSK.107
        POINTS = 0.0                                                             CRLWMSK.108
        DO NC = 1,3                                                              CRLWMSK.109
          POINTS = POINTS + YYY(I,J,NC)                                          CRLWMSK.110
        END DO                                                                   CRLWMSK.111
        IF (POINTS.GT.0.0) THEN                                                  CRLWMSK.112
          DO NC = 1, 3                                                           CRLWMSK.113
            YYY(I,J,NC) = YYY(I,J,NC)/POINTS*100.                                CRLWMSK.114
          END DO                                                                 CRLWMSK.115
        ELSE                                                                     CRLWMSK.116
          NBOX = NBOX+1                                                          CRLWMSK.117
          IBOX(NBOX) = I                                                         CRLWMSK.118
          JBOX(NBOX) = J                                                         CRLWMSK.119
        ENDIF                                                                    CRLWMSK.120
      END DO                                                                     CRLWMSK.121
      END DO                                                                     CRLWMSK.122
C                                                                                CRLWMSK.123
      IF (NBOX.GT.0) THEN                                                        CRLWMSK.124
C .. SEARCH RADIUS:                                                              CRLWMSK.125
        KK = NINT((DSGRID*110.0)/DIS(N))                                         CRLWMSK.126
        IF (KK.LT.1) KK = 1                                                      CRLWMSK.127
        IF (IP.EQ.1) PRINT 11,N,DIS(N),KK,NBOX                                   06NOV00.29
 11     FORMAT(/3X,'DOMAIN ',I2,' DS=',F8.3,' KM. N-DIFF_GRID=',I4,              CRLWMSK.129
     1     ' ===>',I5,' GRID-BOXES WITH NO DATA INSIDE.'/)                       CRLWMSK.130
        RMAX = 0.0                                                               CRLWMSK.131
        DO NB = 1,NBOX                                                           CRLWMSK.132
          I0 = IBOX(NB)                                                          CRLWMSK.133
          J0 = JBOX(NB)                                                          CRLWMSK.134
CC          PRINT 1003,NB,I0,J0,(YYY(I0,J0,NC),NC=1,3)                           CRLWMSK.135
 1003     FORMAT(/'N =',I4,' I0=',I3,' J0=',I3,' YYY:',3F8.1)                    CRLWMSK.136
C                                                                                CRLWMSK.137
          RMIN = 1.E8                                                            CRLWMSK.138
          MMIN = 0                                                               CRLWMSK.139
          NPP = 0                                                                CRLWMSK.140
          DO MM = 1,LREC                                                         CRLWMSK.141
            IOBS = INT(ZLAT(MM))                                                 CRLWMSK.142
            JOBS = INT(ZLON(MM))                                                 CRLWMSK.143
            IF (ABS(I0-IOBS).LE.KK .AND. ABS(J0-JOBS).LE.KK) THEN                CRLWMSK.144
              NPP = NPP+1                                                        CRLWMSK.145
              RXX = ZLON(MM) - J0                                                CRLWMSK.146
              RYY = ZLAT(MM) - I0                                                CRLWMSK.147
              RR = SQRT(RXX*RXX + RYY*RYY)                                       CRLWMSK.148
              IF (RR.LT.RMIN) THEN                                               CRLWMSK.149
                RMIN = RR                                                        CRLWMSK.150
                MMIN = MM                                                        CRLWMSK.151
              ENDIF                                                              CRLWMSK.152
            ENDIF                                                                CRLWMSK.153
          END DO                                                                 CRLWMSK.154
C                                                                                CRLWMSK.155
          IF (RMIN.GT.RMAX) RMAX = RMIN                                          CRLWMSK.156
          DO NC = 1,3                                                            CRLWMSK.157
            YYY(I0,J0,NC) = 0.0                                                  CRLWMSK.158
          END DO                                                                 CRLWMSK.159
          ICAT = NINT(ZLW(MMIN)*100.) + 2                                        CRLWMSK.160
          YYY(I0,J0,ICAT) = 100.                                                 CRLWMSK.161
CC          PRINT 1004,NPP,MMIN,RMIN,                                            CRLWMSK.162
CC     1               ZLAT(MMIN),ZLON(MMIN),ZLW(MMIN),ICAT                      CRLWMSK.163
 1004     FORMAT('SEARCH ',I4,' DATA POINTS. THE CLOSET POINT INDEX=',           CRLWMSK.164
     1         I6,' DIST.=',F8.2,' ZLAT,ZLON,ZLW=',3F8.3,' ICAT=',I3)            CRLWMSK.165
        END DO                                                                   CRLWMSK.166
        IF (IP.EQ.1) PRINT *,'THE MAXIMUM DISTANCE =',RMAX                       06NOV00.30
      ENDIF                                                                      CRLWMSK.168
C                                                                                CRLWMSK.169
      DO I = 1,IX-1                                                              CRLWMSK.170
      DO J = 1,JX-1                                                              CRLWMSK.171
C  ... OVER THE LAND:                                                            CRLWMSK.172
          IF (YYY(I,J,3).GE.50.) THEN                                            CRLWMSK.173
            FORCETER(I,J) = 9E9                                                  CRLWMSK.174
          ENDIF                                                                  CRLWMSK.175
! ===========================================================================
! = MM5 Land-Water mask modification,
! = Insert me between "ENDIF" (CRLWMSK.175) and "ENDDO" (CRLWMSK.176) 
! = by Cypresslin - https://github.com/Cypresslin
! ===========================================================================
      iActivate = 1
      if ( iActivate .eq. 1 ) then
          ! Specify the area you want to modify 
          if ( XLAT(i,j) .gt.  21.5  .and. XLAT(i,j) .lt.  25.5  .and.
     &         XLON(i,j) .gt. 119.95 .and. XLON(i,j) .lt. 122.02) then
            FORCETER(i,j) = 0.001
          endif
      endif

      END DO                                                                     CRLWMSK.176
      END DO                                                                     CRLWMSK.177
C                                                                                CRLWMSK.178
      RETURN                                                                     CRLWMSK.179
      END                                                                        CRLWMSK.180
