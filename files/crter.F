      SUBROUTINE CRTER(HT,IX,JX,N,DSS,HTIN,ITER,JTER,ZLON,ZLAT,HTOB,             CRTER.1
     1                  NI,XLAT,XLON,                                            CRTER.2
     2                  INCR,NOBS,GRDLNMN,GRDLTMN,IMX,JMX)                       CRTER.3
C                                                                                CRTER.4
C   PURPOSE    : CREATE THE TERRAIN HEIGHT FIELD ON THE MESOSCALE                CRTER.5
C                GRIDS BY USING THE OVERLAPPING PARABOLIC                        CRTER.6
C                INTERPOLATION OR CRESSMAN-TYPE OBJECTIVE ANALYSIS               CRTER.7
C                METHOD WITH THE SOURCE TERRAIN HEIGHT DATA ON THE               CRTER.8
C                REGULAR LATITUDE-LONGITUDE MESH AS INPUT.                       CRTER.9
C   IX,JX      : THE DIMENSIONS OF THE DOMAIN N.                                 CRTER.10
C   N          : THE ID NUMBER OF THE MESOSCALE DOMAIN.                          CRTER.11
C   DSS        : THE GRID SIZE OF THE DOMAIN N.                                  CRTER.12
C   ITER,JTER  : THE DIMENSIONS OF THE FIELDS WITH THE REGULAR                   CRTER.13
C                LATITUDE AND LONGITUDE INTERVALS.                               CRTER.14
C   ZLON(NOBS) : LONGITUDES OF THE INPUT SOURCE DATA.                            CRTER.15
C   ZLAT(NOBS) : LATITUDES OF THE INPUT SOURCE DATA.                             CRTER.16
C   HTOB(NOBS) : THE INPUT TERRAIN HEIGHT SOURCE DATA.                           CRTER.17
C   NI         : THE ID NUMBER OF THE SOURCE DATA FILE.                          CRTER.18
C   XLAT(IX,JX): LATITUDES OF THE MESOSCALE GRID POINTS.                         CRTER.19
C   XLON(IX,JX): LONGITUDES OF THE MESOSCALE GRID POINTS.                        CRTER.20
C   INCR       : THE SOURCE DATA RESULOTION (IN \DEG).                           CRTER.21
C   NOBS       : THE NUMBER OF THE INPUT SOURCE DATA POINTS.                     CRTER.22
C   GRDLNMN    : THE MINIMUM LONGITUDE OF THE SOURCE DATA.                       CRTER.23
C   GRDLTMN    : THE MINIMUM LATITUDE OF THE SOURCE DATA.                        CRTER.24
C   IMX,JMX    : THE DIMENSIONS OF THE COARSE DOMAIN, INCLUDING THE              CRTER.25
C                EXTENDED INCREMENTS IF THE COARSE DOMAIN IS                     CRTER.26
C                EXPANDED (IEXP = .TRUE.).                                       CRTER.27
C   HT(IX,JX)  : THE TERRAIN HEIGHT FIELD ON THE MESOSCALE DOMAIN N.             CRTER.28
C                                                                                CRTER.29
C   CALLS THE SUBROUTINES INTERP, XYOBSLL, AND ANAL2.                            CRTER.30
C   CALLED BY SUBROUTINE TERDRV.                                                 CRTER.31
C                                                                                CRTER.32
C   COMMENTS :                                                                   CRTER.33
C IN ADDITION TO THE LIST OF ARGUMENTS, THIS SUBROUTINE GETS MORE                CRTER.34
C INFORMATION ABOUT THE DOMAIN SETTINGS AND THE OPTIONS FROM THE                 CRTER.35
C COMMON BLOCKS /NESTDMN/ AND /OPTION/. THERE ARE TWO OPTIONS TO                 CRTER.36
C CREATE THE TERRAIN HEIGHT FIELD: OVERLAPPING PARABOLIC INTERPOLATION           CRTER.37
C (IFANAL = .FALSE.) AND CRESSMAN-TYPE OBJECTIVE ANALYSIS (IFANAL =              CRTER.38
C .TRUE.). FOR OVERLAPPING PARABOLIC INTERPOLATION, THE ONE-DIMESIONAL           CRTER.39
C INPUT SOURCE DATA ARE PUT INTO A 2-DIMENSIONAL ARRAY HTIN(ITER,JTER)           CRTER.40
C PRIOR TO THE CALL TO SUBROUTINE INTERP. FOR CRESSMAN-TYPE OBJECTIVE            CRTER.41
C ANALYSIS, SUBROUTINE XYOBSLL IS CALLED FIRST TO CONVERT THE LATITUDES          CRTER.42
C AND LONGITUDES OF THE SOURCE DATA TO THE MESOSCALE GRID INDICES,               CRTER.43
C THEN SUBROUTINE ANAL2 IS CALLED TO GENERATE THE TERRAIN HEIGHT FIELD           CRTER.44
C HT(IX,JX) ON THE MESOSCALE DOMAIN FROM THE SOURCE DATA HTOB(NOBS).             CRTER.45
C                                                                                CRTER.46
C IF SET IPRINT = .TRUE., THE MINIMUM LONGITUDE AND LATITUDE AND THE             CRTER.47
C MAXIMUM AND MINIMUM HEIGHTS OF THE INPUT SOURCE DATA ARE PRINTED.              CRTER.48
# include <parame.incl>                                                          CRTER.49
# include <paramed.incl>                                                         CRTER.50
# include <io.incl>                                                              06NOV00.47
# include <nestdmn.incl>                                                         CRTER.51
# include <option.incl>                                                          CRTER.52
# include <ltdata.incl>                                                          CRTER.53
C                                                                                CRTER.54
      DIMENSION   HT(IX,JX),  XLAT(IX,JX), XLON(IX,JX),                          CRTER.55
     2            ZLAT(NOBS),    ZLON(NOBS),  HTOB(NOBS)                         CRTER.56
      DIMENSION XOBS(NOBT), YOBS(NOBT), HTIN(ITER,JTER)                          CRTER.57
C      DIMENSION   WORK1(NOBT),WORK2(NOBT),WORK3(NOBT)                           CRTER.58
C                                                                                CRTER.59
       IF (NOBS.GT.NOBT) THEN                                                    CRTER.60
         PRINT 2,NOBS,NOBT                                                       CRTER.61
  2      FORMAT('==> IN CRTER, NOBS=',I10,' > NOBT=',I10)                        CRTER.62
         STOP                                                                    CRTER.63
       ENDIF                                                                     CRTER.64
C                                                                                CRTER.65
C  GET THE MINIMUM AND MAXIMUM TERRAIN HEIGHT:                                   CRTER.66
C                                                                                CRTER.67
      HTMIN =  1.E12                                                             CRTER.68
      HTMAX = -1.E12                                                             CRTER.69
      DO 20 II = 1,NOBS                                                          CRTER.70
        XOBS(II)=ZLON(II)                                                        CRTER.71
        YOBS(II)=ZLAT(II)                                                        CRTER.72
        IF (HTOB(II).GT.HTMAX) HTMAX=HTOB(II)                                    CRTER.73
        IF (HTOB(II).LT.HTMIN) HTMIN=HTOB(II)                                    CRTER.74
20    CONTINUE                                                                   CRTER.75
        IF(IPRINT.EQ.1) THEN                                                     CRTER.76
        PRINT 22, GRDLNMN, GRDLTMN, HTMAX, HTMIN                                 CRTER.77
22      FORMAT(/2X,' ==< GRDLNMN=',F10.2,'   GRDLTMN=',F10.2,' >=='/             CRTER.78
     1          2X,' ==<   HTMAX=',F10.1,'     HTMIN=',F10.1,' >==')             CRTER.79
        ENDIF                                                                    CRTER.80
C                                                                                CRTER.81
      IF (.NOT.IFANAL) THEN                                                      CRTER.82
C                                                                                CRTER.83
C .. IF REQUESTED RAW DATA COVERAGE IS FROM -180. TO 180., THE ARRAY             CRTER.84
C    LNDIN HOLDING DATA SHOULD BE EXPANDED TO AVOID THE ERRORS OCCURED           CRTER.85
C    OVER THE GRID POINTS LOCATED IN AREA OF -180+DSGRID/2 TO                    CRTER.86
C    180-DSGRID/2.                         YONG-RUN  09/26/97                    CRTER.87
C                                                                                CRTER.88
         IF (ABS(XMAXLON-180.).LT.1.E-3  .AND.                                   CRTER.89
     1       ABS(XMINLON+180.).LT.1.E-3) THEN                                    CRTER.90
             START_J = 2.0                                                       CRTER.91
             PRINT 26,START_J,XMAXLON,XMINLON                                    CRTER.92
 26          FORMAT(/'START_J=',F6.1,' XMAXLON=',F8.2,' XMINLON=',F8.2)          CRTER.93
         ELSE                                                                    CRTER.94
             START_J = 1.0                                                       CRTER.95
         ENDIF                                                                   CRTER.96
C                                                                                CRTER.97
         DO 25 IT = 1,ITER                                                       CRTER.98
         DO 25 JT = 1,JTER                                                       CRTER.99
25       HTIN(IT,JT) = 0.0                                                       CRTER.100
C                                                                                CRTER.101
         IIMAXLND = -100000                                                      CRTER.102
         JIMAXLN  = -100000                                                      CRTER.103
         IIMINLND =  100000                                                      CRTER.104
         JIMINLN  =  100000                                                      CRTER.105
         DO 30 II=1,NOBS                                                         CRTER.106
         JINDEX = NINT((XOBS(II)-GRDLNMN)*INCR + START_J)                        CRTER.107
         IINDEX = (YOBS(II)-GRDLTMN)*INCR + 1.1                                  CRTER.108
C                                                                                CRTER.109
         IF (IINDEX.GT.IIMAXLND) IIMAXLND = IINDEX                               CRTER.110
         IF (JINDEX.GT.JIMAXLN ) JIMAXLN  = JINDEX                               CRTER.111
         IF (IINDEX.LT.IIMINLND) IIMINLND = IINDEX                               CRTER.112
         IF (JINDEX.LT.JIMINLN ) JIMINLN  = JINDEX                               CRTER.113
C                                                                                CRTER.114
         HTIN(IINDEX,JINDEX) = HTOB(II)/100.                                     CRTER.115
30       CONTINUE                                                                CRTER.116
C                                                                                CRTER.117
         IF (ABS(XMAXLON-180.).LT.1.E-3  .AND.                                   CRTER.118
     1       ABS(XMINLON+180.).LT.1.E-3) THEN                                    CRTER.119
             DO II = IIMINLND,IIMAXLND                                           CRTER.120
               HTIN(II,         1) = HTIN(II,JIMAXLN )                           CRTER.121
               HTIN(II,JIMAXLN +1) = HTIN(II,       2)                           CRTER.122
             END DO                                                              CRTER.123
             JIMINLND = 1                                                        CRTER.124
             JIMAXLND = JIMAXLN +1                                               CRTER.125
         ELSE                                                                    CRTER.126
             JIMINLND = JIMINLN                                                  CRTER.127
             JIMAXLND = JIMAXLN                                                  CRTER.128
         ENDIF                                                                   CRTER.129
C                                                                                CRTER.130
         IF(IPRINT.EQ.1)PRINT 24,GRDLTMN,GRDLNMN,ITER,JTER                       06NOV00.48
         IF(IPRINT.EQ.1)PRINT 23,IIMINLND,IIMAXLND,JIMINLND,JIMAXLND             06NOV00.49
 24      FORMAT(/'GRDLTMN=',F8.2,'  GRDLNMN=',F8.2,' ITER,JTER:',2I5)            CRTER.133
 23      FORMAT('IIMINLND,IIMAXLND:',2I5,                                        CRTER.134
     1          '  JIMINLND,JIMAXLND:',2I5)                                      CRTER.135
C                                                                                CRTER.136
         IF (IIMAXLND.GT.ITER .OR. JIMAXLND.GT.JTER) THEN                        CRTER.137
            PRINT 31,IIMAXLND,ITER,JIMAXLND,JTER                                 CRTER.138
31          FORMAT(' IIMAX =',I8,' > ITER=',I8,' OR  JIMAX =',I8,                CRTER.139
     1          ' > JTER=',I8,' IN CRTER.F.')                                    CRTER.140
            STOP 30                                                              CRTER.141
         ENDIF                                                                   CRTER.142
C                                                                                CRTER.143
C--------ALL INCOMING DATA ARE GRIDDED IN ARRAY HTIN.                            CRTER.144
         IF(IPRINT.EQ.1) PRINT 32                                                06NOV00.50
         CALL INTERP(IX,JX,XLON,XLAT,HT,HTIN,                                    CRTER.146
     1               NI,GRDLTMN,GRDLNMN,ITER,JTER,START_J)                       CRTER.147
C                                                                                CRTER.148
32       FORMAT(1X,'**** CALL INTERP ****')                                      CRTER.149
C                                                                                CRTER.150
      ENDIF                                                                      CRTER.151
C                                                                                CRTER.152
C-----IF (IFANAL) BYPASSED INTERP AND CALL ANAL2                                 CRTER.153
C                                                                                CRTER.154
      IF (IFANAL) THEN                                                           CRTER.155
C                                                                                CRTER.156
        IF(IPRINT.EQ.1)PRINT 70                                                  06NOV00.51
C-----CONVERT XOBS AND YOBS FROM LON AND LAT TO X AND Y IN MESH                  CRTER.158
      CALL XYOBSLL(YOBS,XOBS,HTOB,NOBS,IMX,JMX,DIS(1),                           CRTER.159
     1             XSOUTH(N),XWEST(N),NRATIO(N),N-1,1)                           CRTER.160
        IF(IPRINT.EQ.1)PRINT 80                                                  06NOV00.52
      CALL ANAL2(HT,HTOB,XOBS,YOBS,IX,JX,NOBS,N,NI)                              CRTER.162
70    FORMAT(1X,'**** CALL XYOBSLL ****')                                        CRTER.163
80    FORMAT(1X,'**** CALL ANAL2 ****')                                          CRTER.164
C                                                                                CRTER.165
      ENDIF                                                                      CRTER.166
C                                                                                CRTER.167
      DO 50 I = 1,IX                                                             CRTER.168
      DO 50 J = 1,JX                                                             CRTER.169
        HT(I,J) = HT(I,J)*100.                                                   CRTER.170
50    CONTINUE                                                                   CRTER.171
                                                                                 CRTER.172
C                                                                                CRTER.173
! = MM5 Terrain modification,
! = Insert me between "continue" (CRTER.171) and "return" (CRTER.174) 
! = by Dennis and Cypresslin - https://github.com/Cypresslin
! ===========================================================================
      iActivate = 0  ! 1 - yes; 0 - no
      factor = 0.0   ! multiplier, 0.0 : no terrain; 50.0 : 50% terrain ... etc
      if ( iActivate .eq. 1 ) then
        do j = 1,JX
        do i = 1,IX
          ! Specify the area you want to modify 
          if ( XLAT(i,j) .gt.  21.5  .and. XLAT(i,j) .lt.  25.5  .and.
     &         XLON(i,j) .gt. 119.95 .and. XLON(i,j) .lt. 122.02) then
            HT(i,j) = HT(i,j) * factor
          endif
        enddo
        enddo
      endif

      RETURN                                                                     CRTER.174
      END                                                                        CRTER.175
