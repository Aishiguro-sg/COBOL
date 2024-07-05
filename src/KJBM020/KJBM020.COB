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
      *INPUT 入力順ファイル
           SELECT ITF-FILE ASSIGN TO EXTERNAL ITF.
      *OUTPUT 出力順ファイル
           SELECT OTF-FILE ASSIGN TO EXTERNAL OTF.
      ********************************************************
       DATA DIVISION.
       FILE SECTION.
      *入力項目、コピー区
       FD ITF-FILE.
       01  ITF-REC.
           COPY KJCF020.
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
      *01  ERROR-CNT PIC 9 VALUE ZERO.
      *01  ERROR-TBL OCCURS 1 TO 10 
      *           DEPENDING ON ERROR-CNT
      *           INDEXED BY TBL-IX.
      *    05 I PIC X(1).

       COPY KCBS010P.

      ********************************************************
       PROCEDURE DIVISION.
      *サブルーチン呼び出し
           DISPLAY "*** START ***".
           PERFORM INITIAL-RTN.
           PERFORM INPUT-RTN UNTIL ITF-END-FLG = "E".
           PERFORM END-RTN.
           DISPLAY "*** END ***".
           STOP RUN.
      *------------------------------------------------------ 
      *初期処理
       INITIAL-RTN SECTION.
           OPEN INPUT ITF-FILE.
           OPEN OUTPUT OTF-FILE.
       EXIT.

      *終了処理
       END-RTN SECTION.
           DISPLAY "入力数 ITF= " ITF-CNT.
           DISPLAY "出力数 OTF= " OTF-CNT.
           CLOSE ITF-FILE.
           CLOSE OTF-FILE.
       EXIT.
      *------------------------------------------------------
      *入力(+出力)
       INPUT-RTN SECTION.
           READ ITF-FILE
               AT END
                   MOVE "E" TO ITF-END-FLG
               NOT AT END
                   ADD 1 TO ITF-CNT
                   PERFORM OUTPUT-RTN
           END-READ.
       EXIT.
           
      *出力   ITF-REC ? OTF-REC.
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
      *残りの項目
           PERFORM EXCESS-RTN.
      *エラー項目の中身確認 
      *    DISPLAY JF020-ERR-KBN OF OTF-REC(6).
           WRITE OTF-REC.
           ADD 1 TO OTF-CNT.
           EXIT.
      *------------------------------------------------------
      *データ区分 9
       JF020-DATA-KBN-RTN SECTION.
           IF JF020-DATA-KBN OF ITF-REC IS NUMERIC THEN
              CONTINUE
           ELSE
              MOVE 1 TO JF020-ERR-KBN OF OTF-REC(1)
           END-IF
           MOVE JF020-DATA-KBN OF ITF-REC TO JF020-DATA-KBN OF OTF-REC.
       EXIT.
      *------------------------------------------------------
      *受注番号 9 & x:ZERO
       JF020-JUCHU-NO-X-RTN SECTION.
           IF (JF020-JUCHU-NO OF ITF-REC IS NUMERIC) AND 
              (JF020-JUCHU-NO OF ITF-REC NOT = 0) THEN
              CONTINUE
           ELSE
              MOVE 1 TO JF020-ERR-KBN OF OTF-REC(2)
           END-IF
           MOVE JF020-JUCHU-NO OF ITF-REC TO JF020-JUCHU-NO OF OTF-REC.
       EXIT.
      *------------------------------------------------------
      *受注日付 9
       JF020-JUCHU-DATE-RTN SECTION.
           MOVE JF020-JUCHU-Y2 OF ITF-REC TO S010-D6-Y2.
           MOVE JF020-JUCHU-MM OF ITF-REC TO S010-D6-MM.
           MOVE JF020-JUCHU-DD OF ITF-REC TO S010-D6-DD.
           CALL "KCBS010" USING KCBS010-P1.
      *ここ確認
           IF S010-RCD = "E" THEN
              MOVE 1 TO JF020-ERR-KBN OF OTF-REC(3)
           END-IF
           MOVE JF020-JUCHU-Y2 OF ITF-REC TO JF020-JUCHU-Y2 OF OTF-REC.
           MOVE JF020-JUCHU-MM OF ITF-REC TO JF020-JUCHU-MM OF OTF-REC.
           MOVE JF020-JUCHU-DD OF ITF-REC TO JF020-JUCHU-DD OF OTF-REC.
       EXIT.
      *------------------------------------------------------
      *得意先コード 9 & x:SPACE
       JF020-TOKU-COD-RTN SECTION.
           IF (JF020-TOKU-COD OF ITF-REC IS NUMERIC) AND
              (JF020-TOKU-COD OF ITF-REC = SPACE) THEN
              CONTINUE
           ELSE
              MOVE 1 TO JF020-ERR-KBN OF OTF-REC(4)
           END-IF
           MOVE JF020-TOKU-COD OF ITF-REC TO JF020-TOKU-COD OF OTF-REC.
       EXIT.
      *------------------------------------------------------
      *商品番号 9 & x:ZERO
       JF020-SHOHIN-NO-RTN SECTION.
           IF (JF020-SHOHIN-NO OF ITF-REC IS NUMERIC) AND
              (JF020-SHOHIN-NO OF ITF-REC NOT = 0) THEN
              NEXT SENTENCE
           ELSE
              MOVE 1 TO JF020-ERR-KBN OF OTF-REC(5)
           END-IF
      *    MOVE JF020-SHOHIN-NO OF ITF-REC TO JF020-SHOHIN-NO OF OTF-REC.
       EXIT.
      *------------------------------------------------------
      *数量 9 & 999
       JF020-SURYO-X-RTN SECTION.
           IF (JF020-SURYO OF ITF-REC IS NUMERIC) AND
              (JF020-SURYO OF ITF-REC <= 999) THEN
              NEXT SENTENCE
           ELSE
              MOVE 1 TO JF020-ERR-KBN OF OTF-REC(6)
           END-IF
      *    MOVE JF020-SURYO OF ITF-REC TO JF020-SURYO OF OTF-REC.
       EXIT.
       EXCESS-RTN SECTION.
           MOVE JF020-JUCHU-Y1 OF ITF-REC TO JF020-JUCHU-Y1 OF OTF-REC.
      *    MOVE JF020-TOKU-MEI OF ITF-REC TO JF020-TOKU-MEI OF OTF-REC.
      *    MOVE JF020-SHOHIN-MEI OF ITF-REC TO JF020-SHOHIN-MEI OF OTF-REC.
      *    MOVE JF020-TANKA OF ITF-REC TO JF020-TANKA OF OTF-REC.
      *    MOVE JF020-KINGAKU OF ITF-REC TO JF020-KINGAKU OF OTF-REC.
       EXIT.
