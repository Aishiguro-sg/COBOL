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
           SELECT OTF-FILE ASSIGN TO EXTERNAL OTF
                           ORGANIZATION IS LINE SEQUENTIAL.

      * ファイルのレコード�?��?ータ�?目�?、一時的に利用する�?ータ�?目を定義
       DATA DIVISION.
       FILE SECTION.
       FD OTF-FILE.
       01  OTF-HENSU PIC X(6).

       WORKING-STORAGE SECTION.
       01  HENSU.
         03  WRK-I PIC 999 VALUE ZERO.

      * 実際のプログラ�?の開始地点
       PROCEDURE DIVISION.
           PERFORM OUTPUT-TEXT UNTIL WRK-I > 100.
           STOP RUN.

       OUTPUT-TEXT SECTION.
           IF FUNCTION REM(WRK-I, 3) = 0 AND FUNCTION REM(WRK-I, 5) = 0 THEN
      *         DISPLAY "FooBar"
               MOVE "FooBar" TO OTF-HENSU
           ELSE IF FUNCTION REM(WRK-I, 5) = 0 THEN
      *         DISPLAY "Bar"
               MOVE "Bar" TO OTF-HENSU
           ELSE IF FUNCTION REM(WRK-I, 3) = 0 THEN
      *         DISPLAY "Foo"
               MOVE "Foo" TO OTF-HENSU
           ELSE
      *         DISPLAY WRK-I
               MOVE WRK-I TO OTF-HENSU
           END-IF.
           ADD 1 TO WRK-I.
           PERFORM EXTEND-FILE.
           EXIT.

       EXTEND-FILE SECTION.
           OPEN EXTEND OTF-FILE.
           WRITE OTF-HENSU.
           CLOSE OTF-FILE.
           EXIT.
