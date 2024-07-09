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

      ********************************************************
       PROCEDURE DIVISION.
      *サブルーチン呼び出し
           DISPLAY "*** START ***".
           PERFORM INITIAL-RTN.
           PERFORM INPUT-RTN UNTIL ITF-END-FLG = "E".
      *    PERFORM OUTPUT-RTN
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
      *エラー区分
           PERFORM JF020-DATA-KBN-RTN.
      *エラー項目の中身確認 
      *    DISPLAY JF020-ERR-KBN OF OTF-REC(6).
           WRITE OTF-REC.
           ADD 1 TO OTF-CNT.
           EXIT.
      *------------------------------------------------------
      *データ区分 1|9
       JF020-DATA-KBN-RTN SECTION.
          IF JF020-ERR-KBN-TBL OF ITF-REC = SPACE THEN
              DISPLAY "if"
           ELSE
              DISPLAY "else"
           END-IF
           EXIT.
      