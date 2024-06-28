      * プログラ�?のIDなどをを記述する
       IDENTIFICATION DIVISION.
       PROGRAM-ID. KJBM001.
      ********************************************************
      * シス�?�?�?    ?���?�修
      * サブシス�?�?名：サンプルプログラ�?
      * プログラ�?�?  ?��サンプルプログラ�?
      * 作�?�日?��作�?��??��２０２４年?��月?��５日  シス�?�?技�?
      * 変更日?��変更�??�?
      *       変更�?容?�?
      ********************************************************       
      * アクセスファイルなどの�?報を記載す�?
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT OTF-FILE ASSIGN TO EXTERNAL OTF.

      * ファイルのレコード�?��?ータ�?目�?、一時的に利用する�?ータ�?目を定義
       DATA DIVISION.
       FILE SECTION.
       FD OTF-FILE.
       01  OTF-HENSU PIC X(100).

       WORKING-STORAGE SECTION.
       01  HENSU.
         03  WRK-I PIC 999 VALUE ZERO.

      * 実際のプログラ�?の開始地点
       PROCEDURE DIVISION.
           PERFORM OUTPUT-TEXT UNTIL WRK-I > 100.
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
