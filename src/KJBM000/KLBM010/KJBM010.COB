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
           SELECT ITF-FILE ASSIGN TO EXTERNAL ITF
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
      *変数定義　入出力カウント　入力停止の条件式用
       WORKING-STORAGE SECTION.
       01  ITF-CNT PIC 9 VALUE ZERO.
       01  OTF-CNT PIC 9 VALUE ZERO.
       01  ITF-END-FLG PIC X VALUE SPACE.
      ********************************************************
       PROCEDURE DIVISION.
           DISPLAY "*** START ***".
           PERFORM INITIAL-RTN.
      *編集処理　*受注チェック　ITF-END-FLG が "E"になるまで繰り返す
           PERFORM INPUT-RTN UNTIL ITF-END-FLG = "E".
           PERFORM END-RTN.
           DISPLAY "*** END ***".
           STOP RUN.
      *------------------------------------------------------ 
      *初期処理　サブルーチン
       INITIAL-RTN SECTION.
           OPEN INPUT ITF-FILE.
           OPEN OUTPUT OTF-FILE.
           EXIT.

      *終了処理　サブルーチン
       END-RN SECTION.
      *入出力カウント
           DISPLAY "入力数 ITF= " ITF-CNT.
           DISPLAY "出力数 OTF= " OTF-CNT.
      *処理を停止
           CLOSE ITF-FILE.
           CLOSE OTF-FILE.
           EXIT.
           
      *------------------------------------------------------
      *入力(+出力)　サブルーチン
       INPUT-RTN SECTION.
           READ ITF-FILE
               AT END
                   MOVE "E" TO ITF-END-FLG
               NOT AT END
                   ADD 1 TO ITF-CNT
                   PERFORM OUTPUT-RTN
           END-READ.
           EXIT.
           
      *出力　サブルーチン
       OUTPUT-RTN SECTION.
           MOVE SPACE TO OTF-REC.
      *    MOVE ITF-REC TO OTF-REC.
           MOVE JF010-DATA-KBN TO JF020-DATA-KBN.
           MOVE JF010-JUCHU-NO-X TO JF020-JUCHU-NO.
           MOVE JF010-JUCHU-YY TO JF020-JUCHU-Y2.
           MOVE JF010-JUCHU-MM TO JF020-JUCHU-MM.
           MOVE JF010-JUCHU-DD TO JF020-JUCHU-DD.
           MOVE JF010-TOKU-COD TO JF020-TOKU-COD.
           MOVE JF010-SHOHIN-NO TO JF020-SHOHIN-NO.
           MOVE JF010-SURYO TO JF020-SURYO.
           WRITE OTF-REC.
           ADD 1 TO OTF-CNT.
           EXIT.
           