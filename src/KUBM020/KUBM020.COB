       IDENTIFICATION DIVISION.
       PROGRAM-ID. KUBM020.
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
      *OUTPUT 出力1順ファイル
           SELECT OTF-FILE ASSIGN TO EXTERNAL OTF.
      ********************************************************
       DATA DIVISION.
       FILE SECTION.
      *入力項目、コピー区
       FD ITF-FILE.
       01  ITF-REC.
           COPY KUCF010.
      *出力項目、空
       FD OTF-FILE.
       01  OTF-REC.
           COPY KUCF020.

      *変数定義　入出力カウント　入力停止の条件式用
       WORKING-STORAGE SECTION.
       01  ITF-CNT PIC 9 VALUE ZERO.
       01  OTF-CNT PIC 9 VALUE ZERO.
       01  ITF-END-FLG PIC X VALUE SPACE.

       01 SAVE.
           03 SAVE-TOKU-COD PIC X(4) VALUE SPACE.
           03 SAVE-JUCHU-DATE.
              05 SAVE-JUCHU-YY PIC 9(4) VALUE ZERO.
              05 SAVE-JUCHU-MM PIC 9(2) VALUE ZERO.
              05 SAVE-JUCHU-DD PIC 9(2) VALUE ZERO.
           03 SAVE-KINGAKU PIC S9(9) PACKED-DECIMAL.

      ********************************************************
       PROCEDURE DIVISION.
      *サブルーチン呼び出し
           DISPLAY "*** START ***".
           PERFORM INITIAL-RTN.
           PERFORM INPUT-RTN.
           PERFORM UNTIL ITF-END-FLG = "E"
               PERFORM OUTPUT-RTN
               PERFORM INPUT-RTN
           END-PERFORM.
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
           DISPLAY "出力1数 OTF= " OTF-CNT.
           CLOSE ITF-FILE.
           CLOSE OTF-FILE.
           EXIT.
      *------------------------------------------------------
      *入力
       INPUT-RTN SECTION.
           READ ITF-FILE
               AT END
                   MOVE "E" TO ITF-END-FLG
               NOT AT END
                   ADD 1 TO ITF-CNT
           END-READ.
           EXIT.
         
      *出力   ITF-REC ? OTF-REC.
       OUTPUT-RTN SECTION.
           MOVE SPACE TO OTF-REC. 
           PERFORM SAM-RTN.
           ADD 1 TO OTF-CNT.
           EXIT.
      *------------------------------------------------------
      *集計処理　得意先コード(=) 受注年月(=) ITF-END-FLG(E)
       SAM-RTN SECTION.
      *全ての保存先には値が入っていない
           DISPLAY "010 $ " UF010-KINGAKU "|Keep $ " SAVE-KINGAKU.
           DISPLAY "Total $ " UF020-KINGAKU.
      *    DISPLAY UF010-TOKU-COD "|" SAVE-TOKU-COD.
      *    DISPLAY UF010-JUCHU-DATE "|" SAVE-JUCHU-DATE.
           DISPLAY UF010-TOKU-COD "|" SAVE-TOKU-COD.
      *    DISPLAY UF010-JUCHU-DATE "|" SAVE-JUCHU-DATE.
           IF (UF010-TOKU-COD = SAVE-TOKU-COD) AND 
              (UF010-JUCHU-DATE = SAVE-JUCHU-DATE) THEN
      *       (ITF-END-FLG = "E") THEN
              DISPLAY UF010-DATA-KBN
              DISPLAY UF010-TOKU-COD "|" SAVE-TOKU-COD
              DISPLAY UF010-JUCHU-DATE "|" SAVE-JUCHU-DATE
              PERFORM DATA-RTN
           ELSE
      *       DISPLAY UF010-DATA-KBN
      *       DISPLAY UF010-TOKU-COD "|" SAVE-TOKU-COD
      *       DISPLAY UF010-JUCHU-DATE "|" SAVE-JUCHU-DATE
      *得意先コード　　　　ITF　　　 →　　　保存　　　　　　　　
              MOVE UF010-TOKU-COD TO SAVE-TOKU-COD
      *受注年月コード　　　　ITF　　　 →　　　保存　　　　　　　　
              MOVE UF010-JUCHU-DATE TO SAVE-JUCHU-DATE
      *       DISPLAY UF010-TOKU-COD "|" SAVE-TOKU-COD
      *       DISPLAY UF010-JUCHU-DATE "|" SAVE-JUCHU-DATE      
      *金額集計　　保存:合計金額　 →　　　OTF
              MOVE SAVE-KINGAKU TO UF020-KINGAKU
              DISPLAY "Sam " UF020-KINGAKU
              WRITE OTF-REC
              PERFORM SPACE-RTN
      *       DISPLAY UF010-TOKU-COD "|" SAVE-TOKU-COD
      *       DISPLAY UF010-JUCHU-DATE "|" SAVE-JUCHU-DATE
              DISPLAY "--------------"
           END-IF.
           EXIT.

      *データ区分処理    ★ここに、そもそも処理が来ていない
       DATA-RTN SECTION.
      *(+)
           IF ( UF010-DATA-KBN  = "1") THEN
      *                ITF             SAVE
              ADD UF010-KINGAKU TO SAVE-KINGAKU
              DISPLAY UF010-KINGAKU "|" SAVE-KINGAKU
      *(-)
           ELSE IF ( UF010-DATA-KBN  = "9") THEN
      *                     ITF             SAVE
              SUBTRACT UF010-KINGAKU FROM SAVE-KINGAKU
              DISPLAY UF010-KINGAKU "|" SAVE-KINGAKU
           END-IF.
           DISPLAY "--------------"
           EXIT.

      *スペース処理
       SPACE-RTN SECTION.
      *(0 → 金額)
           MOVE 0 TO SAVE-KINGAKU.
      *    DISPLAY SAVE-KINGAKU.
      *次の集計キーを設定
           MOVE UF010-TOKU-COD TO SAVE-TOKU-COD.
           MOVE UF010-JUCHU-DATE TO SAVE-JUCHU-DATE.
      *    DISPLAY UF010-TOKU-COD "|" SAVE-TOKU-COD.
      *    DISPLAY UF010-JUCHU-DATE "|" SAVE-JUCHU-DATE.
           EXIT.
