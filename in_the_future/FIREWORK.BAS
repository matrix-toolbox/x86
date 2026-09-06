REM 2021-03-11
REM FIREWORK - QB POC
REM WOJTEK [AT] BITOLOGIA.ORG

PI = 4 * ATN(1)


RANDOMIZE TIMER
s = 5
DIM a(2 ^ (s + 2) + 1) AS DOUBLE


FOR j = 0 TO 2 ^ (s + 2) STEP 2 ^ s
    a(j) = INT(RND * s * 4)
NEXT
a(2 ^ (s + 2)) = a(0)

FOR k = s - 1 TO 0 STEP -1
    FOR j = 2 ^ k TO 2 ^ (s + 2) - 2 ^ k STEP 2 ^ (k + 1)
        a(j) = (a(j - 2 ^ k) + a(j + 2 ^ k)) / 2 + INT(RND * k * 4)
    NEXT
NEXT


SCREEN 13



'FOR j = 0 TO 2 ^ (s + 2)
'PSET (j, 50 + a(j))
''PRINT a(j),
'NEXT


dp = 2 * PI / 2 ^ (s + 2)
x0 = 160
y0 = 100
r = 64
j = 0
FOR p = 0 TO 2 * PI STEP dp
LINE (x0, y0)-(x0 + COS(p) * (r + a(j)), y0 + SIN(p) * (r + a(j)))
j = j + 1
NEXT

