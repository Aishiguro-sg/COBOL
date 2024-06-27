      * プログラムのIDなどをを記述する
       IDENTIFICATION DIVISION.
       PROGRAM-ID. KJBM001.
      ********************************************************
      * システム名    ：研修
      * サブシステム名：サンプルプログラム
      * プログラム名  ：サンプルプログラム
      * 作成日／作成者：２０２４年６月２５日  システム技研
      * 変更日／変更者：
      *       変更内容：
      ********************************************************       
      * アクセスファイルなどの情報を記載する
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT OTF-FILE ASSIGN TO EXTERNAL OTF.

      * ファイルのレコードのデータ項目や、一時的に利用するデータ項目を定義
       DATA DIVISION.
       FILE SECTION.
       FD OTF-FILE.
       01  OTF-HENSU PIC X(100).

       WORKING-STORAGE SECTION.
       01  HENSU.
         03  WRK-I PIC 999 VALUE ZERO.

      * 実際のプログラムの開始地点
       PROCEDURE DIVISION.
           PERFORM OUTPUT-TEXT UNTIL WRK-I >= 100.
           PERFORM OUTPUT-FILE
           STOP RUN.

       OUTPUT-TEXT SECTION.
           IF FUNCTION REM(WRK-I, 3) = 0 AND FUNCTION REM(WRK-I, 5) = 0 THEN
               DISPLAY "FooBar"
           ELSE IF FUNCTION REM(WRK-I, 5) = 0 THEN
               DISPLAY "Bar"
           ELSE IF FUNCTION REM(WRK-I, 3) = 0 THEN
               DISPLAY "Foo"
           ELSE
               DISPLAY WRK-I
           END-IF.
           ADD 1 TO WRK-I.
           EXIT.

       OUTPUT-FILE SECTION.
           MOVE HENSU TO OTF-HENSU.
           OPEN OUTPUT OTF-FILE.
           WRITE OTF-HENSU.
           CLOSE OTF-FILE.
           EXIT.
