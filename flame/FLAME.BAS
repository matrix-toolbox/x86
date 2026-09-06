REM 2021-02-23
REM
REM wojtek[at]bitologia.org
REM
REM FIRE, based on KD's source (Bajtek, 1996-02)
REM and qbcm.hybd.net/issues/1-1/#5-3
REM ...
REM it works, but too slowly - see FIRE.ASM

SCREEN 13


FOR col% = 0 TO 255
    OUT &H3C8, col%
    OUT &H3C9, INT(col%)
    OUT &H3C9, 0
    OUT &H3C9, 0
NEXT


DEFINT A-Z
d = 90 * 40
DIM tab1(d) AS INTEGER
DIM tab2(d) AS INTEGER


FOR j = 0 TO d - 1
    tab1(j) = 0
    tab2(j) = 0
NEXT

DO
    GOSUB getFrame
    GOSUB setVga
LOOP UNTIL INKEY$ = CHR$(27)
STOP


getFrame:
    FOR y = 2 TO 90 - 1 - 2
    FOR x = 2 TO 40 - 1 - 2
        z = x + y * 40
        tab2(z) = (tab1(z - 1) + tab1(z) + tab1(z + 1) + tab1(z - 1 + 40) + tab1(z + 1 + 40) + tab1(z - 1 + 80) + tab1(z + 80) + tab1(z + 1 + 80)) / 8
    NEXT
    NEXT

    FOR j = 0 TO 3600 - 1
        tab1(j) = tab2(j)
    NEXT

    FOR y = 87 TO 89
    FOR x = 1 TO 2
        tab1(5 + INT(RND * 30) + 40 * y) = 200 + INT(RND * 55)
    NEXT
    NEXT
RETURN

setVga:
    j = 0
    FOR y = 0 TO 90 - 1
    FOR x = 0 TO 40 - 1
        PSET (x, y), tab2(j)
        j = j + 1
    NEXT
    NEXT
RETURN

