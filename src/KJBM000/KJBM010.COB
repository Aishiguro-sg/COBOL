       IDENTIFICATION DIVISION.
       PROGRAM-ID. KJBM010.
      ********************************************************
      * システム名    ：研修
      * サブシステム名：受注
      * プログラム名  ：受注チェックファイル作成
      * 作成日／作成者：２０２４年7月２日  石黒　茜
      * 変更日／変更者：
      *       変更内容：
      ********************************************************       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      *INPUT 入力行順ファイル
           SELECT ITF-FILE ASSIGN TO '../../data/KJBM010I.txt'
                           ORGANIZATION IS LINE SEQUENTIAL.
      *OUTPUT 出力順ファイル
           SELECT OTF-FILE ASSIGN TO EXTERNAL OTF.
      ********************************************************
       DATA DIVISION.
       FILE SECTION.
      *入力項目、コピー区
       FD ITF-FILE.
       01  ITF-REC.
           COPY KJCF010.
      *出力項目、空
       FD OTF-FILE.
       01  OTF-REC.
           COPY KJCF020.

       WORKING-STORAGE SECTION.
       01  ITF-CNT PIC 9 VALUE ZERO.
       01  OTF-CNT PIC 9 VALUE ZERO.
       01  ITF-END-FLG PIC X VALUE SPACE.
      ********************************************************
       PROCEDURE DIVISION.
      *受注チェック　ITF-END-FLG = "E"になるまで繰り返す
           DISPLAY "*** STATE ***".
      *入力
           OPEN INPUT ITF-FILE.
           OPEN OUTPUT OTF-FILE.
           PERFORM INPUT-REN UNTIL ITF-END-FLG = "E".
           DISPLAY "入力数 ITF= " ITF-CNT.
      *出力
           DISPLAY "出力数 OTF= " OTF-CNT.
      *処理を停止
           CLOSE ITF-FILE.
           CLOSE OTF-FILE.

           DISPLAY "*** END ***".
           STOP RUN.

      *入力　サブルーチン
       INPUT-REN SECTION.
           READ ITF-FILE
               AT END
                   MOVE "E" TO ITF-END-FLG
               NOT AT END
                   ADD 1 TO ITF-CNT
                   PERFORM OUTPUT-REN
           END-READ.
           EXIT.
      *出力　サブルーチン
       OUTPUT-REN SECTION.
           MOVE SPACE TO OTF-REC.
      *    MOVE ITF-REC TO OTF-REC.
           MOVE JF010-DATA-KBN OF ITF-REC TO JF020-DATA-KBN OF OTF-REC.
           MOVE JF010-JUCHU-NO-X OF ITF-REC TO JF020-JUCHU-NO OF OTF-REC.
           MOVE JF010-JUCHU-YY OF ITF-REC TO JF020-JUCHU-Y2 OF OTF-REC.
           MOVE JF010-JUCHU-MM OF ITF-REC TO JF020-JUCHU-MM OF OTF-REC.
           MOVE JF010-JUCHU-DD OF ITF-REC TO JF020-JUCHU-DD OF OTF-REC.
           MOVE JF010-TOKU-COD OF ITF-REC TO JF020-TOKU-COD OF OTF-REC.
           MOVE JF010-SHOHIN-NO OF ITF-REC TO JF020-SHOHIN-NO OF OTF-REC.
           MOVE JF010-SURYO OF ITF-REC TO JF020-SURYO OF OTF-REC.

           WRITE OTF-REC.
           ADD 1 TO OTF-CNT.
           EXIT.
           