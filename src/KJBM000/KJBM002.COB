       IDENTIFICATION DIVISION.
       PROGRAM-ID. KJBM002.
      ********************************************************   
       ENVIRONMENT DIVISION.
      * 
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 TBL-SIZE PIC 9(10) VALUE 10.
       01 TABLE-A OCCURS 0 TO 10 
                  DEPENDING ON TBL-SIZE 
                  INDEXED BY TBL-IDX.
           05 I PIC X(10).

       01 ABC.
           03 A OCCURS 5.
              05 AAA PIC X(2) VALUE ZERO.
              05 BBB PIC X(3) VALUE ZERO.
      *
       PROCEDURE DIVISION.
           MOVE "a" TO I OF TABLE-A(1).
           MOVE "i" TO TABLE-A(2).
           MOVE "u" TO TABLE-A(3).
           MOVE "e" TO TABLE-A(4).
           MOVE "o" TO TABLE-A(5).
           MOVE "aa" TO I OF TABLE-A(6).
           MOVE "ii" TO TABLE-A(7).
           MOVE "uu" TO TABLE-A(8).
           MOVE "ee" TO TABLE-A(9).
           MOVE "oo" TO TABLE-A(10).

           MOVE "ABCDE" TO ABC.
           DISPLAY ABC.
           MOVE "cde" TO BBB OF A(1).
           MOVE "cat" TO BBB OF A(2).
           DISPLAY ABC.
           DISPLAY BBB OF A(1).
           DISPLAY BBB OF A(2).
           STOP RUN.

