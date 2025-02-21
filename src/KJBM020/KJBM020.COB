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
       COPY KCBS010P.
       01  DATA-CNT PIC 9 VALUE ZERO.
      *型確認の変数
      *01  INT-CHECK-CNT PIC 9 VALUE 1.

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
      *残りの項目
           MOVE ITF-REC TO OTF-REC. 
      *データ区分
           PERFORM JF020-DATA-KBN-RTN.
      *受注番号−Ｘ
           PERFORM JF020-JUCHU-NO-X-RTN.
      *受注日付
           PERFORM JF020-JUCHU-DATE-RTN.
      *得意先コード
           PERFORM JF020-TOKU-COD-RTN.
      *商品番号
           PERFORM JF020-SHOHIN-NO-RTN.
      *数量−Ｘ
           PERFORM JF020-SURYO-X-RTN.
      *エラー項目の中身確認 
      *    DISPLAY JF020-ERR-KBN OF OTF-REC(6).
           WRITE OTF-REC.
           ADD 1 TO OTF-CNT.
           EXIT.
      *------------------------------------------------------
      *データ区分 1|9
       JF020-DATA-KBN-RTN SECTION.
           MOVE FUNCTION NUMVAL(JF020-DATA-KBN OF ITF-REC) TO DATA-CNT.
      *英数字型を数字型に変換
      *    IF INT-CHECK-CNT = DATA-CNT THEN
      *       DISPLAY DATA-CNT
      *    ELSE
      *       DISPLAY "X"
      *    END-IF
          IF (DATA-CNT IS NUMERIC) AND 
              ((DATA-CNT = 1) OR (DATA-CNT = 9)) THEN
              CONTINUE
           ELSE
              MOVE "1" TO JF020-ERR-KBN OF OTF-REC(1)
           END-IF
           EXIT.
      *------------------------------------------------------
      *受注番号 9 & x:ZERO
       JF020-JUCHU-NO-X-RTN SECTION.
           MOVE FUNCTION NUMVAL(JF020-JUCHU-NO OF ITF-REC) TO DATA-CNT.
           IF (JF020-JUCHU-NO OF ITF-REC IS NUMERIC) AND 
              (JF020-JUCHU-NO OF ITF-REC NOT = 0) THEN
              CONTINUE
           ELSE
              MOVE "1" TO JF020-ERR-KBN OF OTF-REC(2)
           END-IF
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
              MOVE "1" TO JF020-ERR-KBN OF OTF-REC(3)
           END-IF
           EXIT.
      *------------------------------------------------------
      *得意先コード x:SPACE
       JF020-TOKU-COD-RTN SECTION.
           IF (JF020-TOKU-COD OF ITF-REC NOT = SPACE) THEN
              CONTINUE
           ELSE
              MOVE "1" TO JF020-ERR-KBN OF OTF-REC(4)
           END-IF
           EXIT.
      *------------------------------------------------------
      *商品番号 9 & x:ZERO
       JF020-SHOHIN-NO-RTN SECTION.
           MOVE FUNCTION NUMVAL(JF020-SHOHIN-NO OF ITF-REC) TO DATA-CNT.
           IF (JF020-SHOHIN-NO OF ITF-REC IS NUMERIC) AND
              (JF020-SHOHIN-NO OF ITF-REC NOT = 0) THEN
              CONTINUE
           ELSE
              MOVE "1" TO JF020-ERR-KBN OF OTF-REC(5)
           END-IF
       EXIT.
      *------------------------------------------------------
      *数量 9 & 999
       JF020-SURYO-X-RTN SECTION.
           MOVE FUNCTION NUMVAL(JF020-SURYO OF ITF-REC) TO DATA-CNT.
           IF (JF020-SURYO OF ITF-REC IS NUMERIC) AND
              ((JF020-SURYO OF ITF-REC >= 1) AND
              (JF020-SURYO OF ITF-REC <= 999)) THEN
              CONTINUE
           ELSE
              MOVE "1" TO JF020-ERR-KBN OF OTF-REC(6)
           END-IF
       EXIT.
