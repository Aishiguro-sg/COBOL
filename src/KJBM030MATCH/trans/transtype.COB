       IDENTIFICATION      DIVISION.
       PROGRAM-ID. TRZ2P.

       ENVIRONMENT         DIVISION.
       INPUT-OUTPUT        SECTION.
       FILE-CONTROL.
           SELECT ITF-FILE ASSIGN TO ITF
               ORGANIZATION LINE SEQUENTIAL.
           SELECT OTF-FILE ASSIGN TO OTF.
      *
       DATA                DIVISION.
       FILE                SECTION.
       FD ITF-FILE.
       01  ITF-REC.
      *    パック形式をゾーンで定義しなおしたCOPY句
      *    編集しやすいように行順で行末のFILLERは削除したものを定義する。
           COPY KCCFSHONOPD.

       FD OTF-FILE.
       01  OTF-REC.
      *    本来のCOPY句
           COPY KCCFSHO.

       WORKING-STORAGE      SECTION.
       01  ITF-END-FLG     PIC   X     VALUE  'N'.

       PROCEDURE           DIVISION.
           OPEN  INPUT   ITF-FILE.
           OPEN  OUTPUT  OTF-FILE.

           PERFORM  UNTIL  ITF-END-FLG  =  "Y"
             READ  ITF-FILE
               AT  END
                 MOVE  "Y"  TO  ITF-END-FLG
               NOT  AT  END
                 MOVE  CORR  ITF-REC  TO  OTF-REC 
                 WRITE  OTF-REC
             END-READ
           END-PERFORM.
                  
           CLOSE  OTF-FILE.
           CLOSE  ITF-FILE.
      *
           STOP RUN.
