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
       01  ERROR-CNT
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
      *データ区分
       JF020-DATA-KBN-RTN SECTION.
           IF JF020-DATA-KBN IS NUMERIC THEN
              CONTINUE
           ELSE
      *エラー1桁目(xxx-IX) に1を入れる
              MOVE 1 TO ERROR-TBL(1)
           END-IF
           MOVE JF020-DATA-KBN TO JF020-DATA-KBN.
       EXIT.
      *受注番号－Ｘ
       JF020-JUCHU-NO-X-RTN SECTION.
           MOVE JF020-JUCHU-NO-X TO JF020-JUCHU-NO-X.
       EXIT.
      *受注日付
       JF020-JUCHU-DATE-RTN SECTION.
           CALL 'KCBS010' USING KCBS010-P1.
           MOVE JF020-JUCHU-DATE TO JJF020-JUCHU-DATE.
       EXIT.
      *得意先コード
       JF020-TOKU-COD-RTN SECTION.
           MOVE JF020-TOKU-COD TO JF020-TOKU-COD.
       EXIT.
      *商品番号
       JF020-SHOHIN-NO-RTN SECTION.
           MOVE JF020-SHOHIN-NO TO JF020-SHOHIN-NO.
       EXIT.
      *数量－Ｘ
       JF020-SURYO-X-RTN SECTION.
           MOVE JF020-SURYO-X TO JF020-SURYO-X.
       EXIT.