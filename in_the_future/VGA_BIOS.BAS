REM 2021-01-06
REM WOJTEK [AT] BITOLOGIA.ORG
REM
REM VGA BIOS ROM READER.
REM IT RETRIEVES DATA FROM C000:0000 ROM AREA.
REM IT ALSO CAN BE DONE USING > DEBUG:
REM > debug
REM > d c000:0000
    

CLS

a1 = &H0
a2 = &H7FFF - 0

DEF SEG = &HC000
OPEN "BIOS.VGA" FOR OUTPUT AS #1
FOR j = a1 TO a2
        v = PEEK(&H0 + j)
        IF v > 31 AND v < 128 THEN PRINT CHR$(v);  ELSE PRINT CHR$(176);
        PRINT #1, CHR$(v);
        NEXT j
CLOSE #1


PRINT
PRINT
PRINT "***************************************************************"
PRINT

SLEEP

FOR j = 0 TO 15
PRINT USING "### "; j;
NEXT j
PRINT "---------------------------------------------------------------"

DEF SEG = &HC000
k = 0
FOR j = a1 TO a2
        v = PEEK(&H0 + j)
        IF LEN(HEX$(v)) = 1 THEN PRINT "  ";  ELSE PRINT " ";
        PRINT HEX$(v); " ";
        IF (k + 1) MOD 16 = 0 THEN PRINT
        k = k + 1: REM  we need additional variable since j starts
        REM at different offsets (not a multiple of 0x0F) and thus
        REM lines are not being broken correctly!
        NEXT j

PRINT "bytes processed: "; k




