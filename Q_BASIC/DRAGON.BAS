REM 1998
REM L-SYSTEM DRAGON

CONST pi = 3.141539654#: M = 18000
DIM S(M) AS INTEGER
FOR i = 0 TO M: S(i) = 0: NEXT

FOR n = 1 TO 12
    i = 1
    FOR j = 2 ^ n TO 2 ^ (n + 1) - 2
        ' IF S(j - 2 * i) = 0 THEN S(j) = 1
        S(j) = (S(j - 2 * i) + 1) MOD 2
        i = i + 1
    NEXT
NEXT

SCREEN 11
x = 260: y = 370: A = 1
PSET (x, y)
FOR i = 0 TO 2 ^ n - 3
    IF S(i) = 0 THEN
       A = (A + 1) MOD 4
       ELSE
       A = (A - 1) MOD 4
       END IF
    x = x + 4 * COS(A * pi / 2)
    y = y + 4 * SIN(A * pi / 2)
    LINE -(x, y) ' COLOURISED IN CPP_9
    NEXT

SLEEP

