       IDENTIFICATION             DIVISION.
       PROGRAM-ID.                KUBM020.
      ********************************************************
      * システム名    ：研修
      * サブシステム名：売上
      * プログラム名  ：売上集計
      * 作成日／作成者：２０１３年４月３０日  システム技研
      * 変更日／変更者：2024 7 12 石黒茜
      *       変更内容：個人的見易さ
      ********************************************************
       ENVIRONMENT                DIVISION.
       INPUT-OUTPUT               SECTION.
       FILE-CONTROL.
           SELECT  ITF-FILE  ASSIGN TO  EXTERNAL  ITF.
           SELECT  OTF-FILE  ASSIGN TO  EXTERNAL  OTF.
      *
       DATA                       DIVISION.
       FILE                       SECTION.
       FD  ITF-FILE.
       01  ITF-REC.
           COPY  KUCF010.
       FD  OTF-FILE.
       01  OTF-REC.
           COPY  KUCF020.
      *
       WORKING-STORAGE            SECTION.
       01  ITF-CNT                PIC  9(1)    VALUE  0.
       01  OTF-CNT                PIC  9(1)    VALUE  0.
       01  ITF-KEY.
         02  WK-ITF-TOKU-KEY      PIC   X(4)          VALUE  LOW-VALUE.
         02  WK-ITF-DATE-KEY.
           03  WK-ITF-YY-KEY      PIC   X(4)          VALUE  LOW-VALUE.
           03  WK-ITF-MM-KEY      PIC   X(2)          VALUE  LOW-VALUE.
       01  OLD-KEY.
         02  WK-OLD-TOKU-KEY      PIC   X(4)          VALUE  LOW-VALUE.
         02  WK-OLD-DATE-KEY.
           03  WK-OLD-YY-KEY      PIC   X(4)          VALUE  LOW-VALUE.
           03  WK-OLD-MM-KEY      PIC   X(2)          VALUE  LOW-VALUE.
       01  KINGAKU             PIC  S9(9)  COMP-3  VALUE  +0.
      *
      ********************************************************
      * 売上集計
      ********************************************************
       PROCEDURE                  DIVISION.
           PERFORM  INIT-RTN.
           PERFORM  SYUUKEI-RTN
             UNTIL  ITF-KEY  =  HIGH-VALUE.
           PERFORM  TERM-RTN.
           STOP  RUN.
      ********************************************************
      * 開始処理
      ********************************************************
       INIT-RTN                   SECTION.
           DISPLAY  "*** START ***".
           OPEN  INPUT   ITF-FILE.
           OPEN  OUTPUT  OTF-FILE.
           PERFORM  READ-RTN.
       EXT.
           EXIT.
      ********************************************************
      * 入力処理
      ********************************************************
       READ-RTN                   SECTION.
           READ  ITF-FILE
           AT  END
             MOVE  HIGH-VALUE  TO  ITF-KEY
           NOT  AT  END
             ADD  1  TO  ITF-CNT
             MOVE  UF010-JUCHU-YY  TO  WK-ITF-YY-KEY
             MOVE  UF010-JUCHU-MM  TO  WK-ITF-MM-KEY
             MOVE  UF010-TOKU-COD  TO  WK-ITF-TOKU-KEY
           END-READ.
       EXT.
           EXIT.
      ********************************************************
      * 集計処理
      ********************************************************
       SYUUKEI-RTN                SECTION.
           MOVE  SPACE  TO  OTF-REC.
           MOVE  UF010-TOKU-COD  TO  UF020-TOKU-COD.
           MOVE  UF010-JUCHU-YY  TO  UF020-JUCHU-YY.
           MOVE  UF010-JUCHU-MM  TO  UF020-JUCHU-MM.
           MOVE       0         TO  KINGAKU.
           MOVE  ITF-KEY      TO  OLD-KEY.
      *入力処理
           PERFORM  UNTIL  ITF-KEY  NOT  =  OLD-KEY
             PERFORM  COMP-RTN
             PERFORM  READ-RTN
           END-PERFORM.
      *出力処理
           PERFORM  WRITE-RTN.
       EXT.
           EXIT.
      ********************************************************
      * 計算処理
      ********************************************************
       COMP-RTN                   SECTION.
           IF  UF010-DATA-KBN  =  "1"
             COMPUTE  KINGAKU  =  KINGAKU  +  UF010-KINGAKU
           ELSE
             COMPUTE  KINGAKU  =  KINGAKU  -  UF010-KINGAKU
           END-IF.
       EXT.
           EXIT.
      ********************************************************
      * 出力処理
      ********************************************************
       WRITE-RTN                  SECTION.
           MOVE  KINGAKU  TO  UF020-KINGAKU.
      *    DISPLAY UF020-TOKU-COD "|" UF020-JUCHU-DATE "|" UF020-KINGAKU
           WRITE  OTF-REC.
           ADD  1  TO  OTF-CNT.
       EXT.
           EXIT.
      ********************************************************
      * 終了処理
      ********************************************************
       TERM-RTN                   SECTION.
           CLOSE  OTF-FILE.
           CLOSE  ITF-FILE.
           DISPLAY  "ITF-CNT= "  ITF-CNT.
           DISPLAY  "OTF-CNT= "  OTF-CNT.
           DISPLAY  "*** END ***".
       EXT.
           EXIT.
