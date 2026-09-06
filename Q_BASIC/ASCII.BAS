REM ASCII-PCX
REM 1996

REM INCLUDE "ASCII.B"

DIM B(8) AS INTEGER

SCREEN 11

REM     DEF SEG = &HF000
        DEF SEG = &HC000

        C10$ = CHR$(10)
        C13$ = CHR$(13)

        OPEN "ASCII.B" FOR BINARY AS #1
        REC = 1

        PRINT "START READING DATA:"
        PRINT

        range = 127 * 8

    FOR offset% = 0 TO range STEP 8
    FOR byte% = 0 TO 7
        A = PEEK(&H2D20 + offset% + byte%)
        FOR i = 0 TO 7: B(7 - i) = A MOD 2: A = INT(A / 2): NEXT
        FOR i = 0 TO 7
        REM PRINT B(i)
        LOCATE 1, 20: PRINT offset%; : PRINT "of"; : PRINT range

        B(i) = B(i) + 48: PUT #1, REC, B(i): REC = REC + 1: NEXT: REM PRINT
        NEXT
        PUT #1, REC, C13$
        REC = REC + 1
        PUT #1, REC, C10$
        REC = REC + 1

REM     PRINT
        NEXT

        CLOSE #1
        PRINT "DATA READ SUCCESSFULLY. PRESS ANY KEY..."

'10 CLS
'20 DEF SEG = &HF000
'30 DIM P AS STRING * 1
'40 OPEN "C:\W_98\QB\ASCII.B" FOR BINARY AS #1
'50 FOR I = &HFA6E TO &HFE6D
'60 P = CHR$(PEEK(I))
'70 PUT #1, I - &HFA6F, P
'80 NEXT
'90 CLOSE #1

