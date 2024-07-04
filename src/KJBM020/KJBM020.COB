       IDENTIFICATION DIVISION.
       PROGRAM-ID. KJBM020.
      ********************************************************
      * システム名    ：研修
      * サブシステム名：受注
      * プログラム名  ：受注チェックファイル作成
      * 作成日／作成者：２０２４年7月4日  石黒　茜
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
      *OCCURS 範囲1~10
       01  ERROR-CNT PIC X VALUE SPACE.
       01  ERROR-TBL OCCURS 1 TO 10 
                  DEPENDING ON ERROR-CNT
                  INDEXED BY TBL-IX.
           05 I PIC X(1).
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
       END-RTN SECTION.
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
           
      *出力　サブルーチン ITF-REC ? OTF-REC.
       OUTPUT-RTN SECTION.
           MOVE SPACE TO OTF-REC.
      *データ区分     
           PERFORM JF020-DATA-KBN-RTN.
      *受注番号－Ｘ
           PERFORM JF020-JUCHU-NO-X-RTN.
      *受注日付     
           PERFORM JF020-JUCHU-DATE-RTN.
      *得意先コード     
           PERFORM JF020-TOKU-COD-RTN.
      *商品番号     
           PERFORM JF020-SHOHIN-NO-RTN.
      *数量－Ｘ     
           PERFORM JF020-SURYO-X-RTN.
           WRITE OTF-REC.
           ADD 1 TO OTF-CNT.
           EXIT.
      *------------------------------------------------------     
      *データ区分 9
       JF020-DATA-KBN-RTN SECTION.
           IF JF020-DATA-KBN IS NUMERIC THEN
              CONTINUE
      *エラー(1)に1を入れる
           ELSE
              MOVE 1 TO ERROR-TBL(1)
           END-IF
           MOVE JF020-DATA-KBN TO JF020-DATA-KBN.
       EXIT.
      *------------------------------------------------------
      *受注番号 9 & x:ZERO
       JF020-JUCHU-NO-X-RTN SECTION.
           IF JF020-JUCHU-NO-X IS NUMERIC AND JF020-JUCHU-NO-X = NOT 0 THEN
              CONTINUE
      *エラー(2)に1を入れる
           ELSE
              MOVE 1 TO ERROR-TBL(2)
           END-IF
           MOVE JF020-JUCHU-NO-X TO JF020-JUCHU-NO-X.
       EXIT.
      *------------------------------------------------------
      *受注日付 9
       JF020-JUCHU-DATE-RTN SECTION.
           CALL 'KCBS010' USING KCBS010-P1.
           IF JF020-JUCHU-DATE IS NUMERIC THEN
              CONTINUE
      *エラー(3)に1を入れる
           ELSE
              MOVE 1 TO ERROR-TBL(3)
           END-IF    
           MOVE JF020-JUCHU-DATE TO JF020-JUCHU-DATE.
       EXIT.
      *------------------------------------------------------
      *得意先コード 9 & x:SPACE
       JF020-TOKU-COD-RTN SECTION.
           IF F020-TOKU-COD IS NUMERIC AND F020-TOKU-COD = SPACE THEN
              CONTINUE
      *エラー(4)に1を入れる
           ELSE
              MOVE 1 TO ERROR-TBL(4)
           END-IF
           MOVE JF020-TOKU-COD TO JF020-TOKU-COD.
       EXIT.
      *------------------------------------------------------
      *商品番号 9 & x:ZERO
       JF020-SHOHIN-NO-RTN SECTION.
           IF JF020-SHOHIN-NO IS NUMERIC AND JF020-SHOHIN-NO = NOT 0 THEN
              CONTINUE
      *エラー(5)に1を入れる
           ELSE
              MOVE 1 TO ERROR-TBL(5)
           END-IF
           MOVE JF020-SHOHIN-NO TO JF020-SHOHIN-NO.
       EXIT.
      *------------------------------------------------------
      *数量 9 & 999
       JF020-SURYO-X-RTN SECTION.
           IF JF020-SURYO-X IS NUMERIC AND JF020-SURYO-X <= 999 THEN
              CONTINUE
      *エラー(6)に1を入れる
           ELSE
              MOVE 1 TO ERROR-TBL(6)
           END-IF
           MOVE JF020-SURYO-X TO JF020-SURYO-X.
       EXIT.
       