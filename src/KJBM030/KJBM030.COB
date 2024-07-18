       IDENTIFICATION             DIVISION.
       PROGRAM-ID.                KJBM030.
      ********************************************************
      * システム名    ：研修
      * サブシステム名：受注
      * プログラム名  ：受注データ商品番号チェック
      * 作成日／作成者：2024年7月18日  石黒茜
      * 変更日／変更者：
      *       変更内容：個人的見易さ
      ********************************************************
       ENVIRONMENT                DIVISION.
       INPUT-OUTPUT               SECTION.
       FILE-CONTROL.
           SELECT  ITF-FILE  ASSIGN TO  EXTERNAL  ITF.
           SELECT  IMF-FILE  ASSIGN TO  EXTERNAL  IMF.
           SELECT  OTF-FILE  ASSIGN TO  EXTERNAL  OTF.
      *----------------------------------------------------------------
       DATA                       DIVISION.
       FILE                       SECTION.
       FD  ITF-FILE.
       01  ITF-REC.
           COPY  KJCF020.
       FD  IMF-FILE.
       01  IMF-REC.
           COPY  KCCFSHO.
       FD  OTF-FILE.
       01  OTF-REC.
           COPY  KJCF020.
      *----------------------------------------------------------------
       WORKING-STORAGE            SECTION.
       01  ITF-CNT                PIC  9(1)    VALUE  0.
       01  IMF-CNT                PIC  9(1)    VALUE  0.
       01  OTF-CNT                PIC  9(1)    VALUE  0.
      *---------------
       01  ITF-KEY.
         02  WK-ITF-SHOHIN-NO     PIC   X(5)          VALUE  LOW-VALUE.
       01  ILD-KEY.
         02  WK-ILD-SHOHIN-NO     PIC   X(5)          VALUE  LOW-VALUE.
      *---------------
       01  IMF-KEY.
         02  WK-IMF-SHOHIN-NO     PIC   X(5)          VALUE  LOW-VALUE.
       01  MLD-KEY.
         02  WK-MLD-SHOHIN-NO     PIC   X(5)          VALUE  LOW-VALUE.
      *
      ********************************************************
      * 入）+（出
      ********************************************************
       PROCEDURE                  DIVISION.
           PERFORM  INIT-RTN.
           PERFORM  EDIT-RTN
             UNTIL  (IMF-KEY = HIGH-VALUE) OR (ITF-KEY = HIGH-VALUE).
           PERFORM  END-RTN.
           STOP  RUN.
      ********************************************************
      *編集
      ********************************************************
       EDIT-RTN                   SECTION.
           PERFORM  WRITE-RTN.
           PERFORM  READ-I-RTN.
       EXT.
           EXIT.    
      ********************************************************
      * 開始処理
      ********************************************************
       INIT-RTN                   SECTION.
           DISPLAY  "*** START ***".
           OPEN  INPUT   ITF-FILE.
           OPEN  INPUT   IMF-FILE.
           OPEN  OUTPUT  OTF-FILE.
           PERFORM  READ-I-RTN.
           PERFORM  READ-M-RTN.
       EXT.
           EXIT.
      ********************************************************
      * 入力処理　1　ITF
      ********************************************************
       READ-I-RTN                   SECTION.
           READ  ITF-FILE
           AT  END
             MOVE  HIGH-VALUE  TO  ITF-KEY
           NOT  AT  END
             ADD  1  TO  ITF-CNT
             MOVE JF020-SHOHIN-NO OF ITF-REC TO  WK-ITF-SHOHIN-NO
           END-READ.
       EXT.
           EXIT.
      ********************************************************
      * 入力処理　2　IMF
      ********************************************************
       READ-M-RTN                   SECTION.
           READ  IMF-FILE
           AT  END
             MOVE  HIGH-VALUE  TO  IMF-KEY
           NOT  AT  END
             ADD  1  TO  IMF-CNT
             MOVE  CFSHO-SHOHIN-NO  TO  WK-MLD-SHOHIN-NO
           END-READ.
       EXT.
           EXIT.

      ********************************************************
      * 出力処理
      ********************************************************
       WRITE-RTN                  SECTION.
           PERFORM SHOHINBANGOU-RTN.
           ADD  1  TO  OTF-CNT.
           WRITE  OTF-REC.
       EXT.
           EXIT.
      ********************************************************
      * 終了処理
      ********************************************************
       END-RTN                   SECTION.
           CLOSE  OTF-FILE.
           CLOSE  ITF-FILE.
           CLOSE  IMF-FILE.
           DISPLAY  "*** END ***".
       EXT.
           EXIT.
      ********************************************************
      ********************************************************
      * 商品番号 マッチング 処理
      ********************************************************
       SHOHINBANGOU-RTN                SECTION.
           MOVE  SPACE  TO  OTF-REC.
      *
           MOVE  ITF-KEY      TO  ILD-KEY.
           MOVE  IMF-KEY      TO  MLD-KEY.
      *
           PERFORM  
             UNTIL (ITF-KEY NOT = ILD-KEY) OR (IMF-KEY NOT = MLD-KEY)
             PERFORM  READ-I-RTN
             PERFORM  MATCHING-RTN
           END-PERFORM.
       EXT.
           EXIT.
      ********************************************************
      * 比較 処理
      ********************************************************
       HIKAKU-RTN                   SECTION.
           IF  ITF-KEY = IMF-KEY THEN
             CONTINUE
           ELSE IF ITF-KEY < IMF-KEY THEN
             CONTINUE
           ELSE IF ITF-KEY > IMF-KEY THEN
             PERFORM  READ-M-RTN
           END-IF.
       EXT.
           EXIT.
      ********************************************************
      * マッチング 処理
      ********************************************************
       MATCHING-RTN                   SECTION.
           IF  JF020-ERR-KBN OF ITF-REC(5)  =  SPACE THEN
             PERFORM  HIKAKU-RTN
           END-IF.
       EXT.
           EXIT.
