REM SIMPLE IFS ROUTINE

SCREEN 11
DIM array(47) AS INTEGER

DATA 0,0,0,1,0,2,0,3,0,4,2,0,2,1,2,2,2,3,2,4,3,0,3,2
DATA 4,0,6,0,6,1,6,2,6,4,7,0,7,2,7,4,8,0,8,2,8,3,8,4

FOR i = 0 TO 47
    READ j
    array(i) = j
    NEXT

    DO: i = 2 * INT(RND * 24)
        x = x / 10 + array(i) * 68
        y = y / 6 + array(i + 1) * 90
        PSET (x + 10, y + 20)
        LOOP WHILE INKEY$ = ""

