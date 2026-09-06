REM wojtek[at]bitologia.org
REM
REM 2020-08-27
REM Iterative version until the problem of recursion is solved.
REM
REM 2021-02-26
REM "full screen" and classic rotation of RGB palette.

SCREEN 13

REM prepare RGB palette, see: QB CULT MAGAZINE at http://qbcm.hybd.net/issues/1-1/#5-3

FOR c% = 0 TO 63
    OUT &H3C8, c%
    OUT &H3C9, c%
    OUT &H3C9, 0
    OUT &H3C9, 0
NEXT

FOR c% = 64 TO 127
    OUT &H3C8, c%
    OUT &H3C9, 63 - c%
    OUT &H3C9, c%
    OUT &H3C9, 0
NEXT

FOR c% = 128 TO 191
    OUT &H3C8, c%
    OUT &H3C9, 0
    OUT &H3C9, 63 - c%
    OUT &H3C9, c%
NEXT

FOR c% = 192 TO 255
    OUT &H3C8, c%
    OUT &H3C9, 0
    OUT &H3C9, 0
    OUT &H3C9, 63 - c%
NEXT

' preview:
' FOR j = 0 TO 255
'     LINE (j, 10)-(j, 74), j, BF
' NEXT


LET L = 128
DIM plasma(L + 1, L + 1) AS INTEGER


NOISE = 128: REM the smaller noise the flatter plasma

RANDOMIZE TIMER

FOR j = 0 TO L + 1
FOR k = 0 TO L + 1
    plasma(j, k) = 0
NEXT: NEXT

S = 0
plasma(0, 0) = RND * 256 ' initialize corners
plasma(0, L) = RND * 256
plasma(L, 0) = RND * 256
plasma(L, L) = RND * 256

DO
    S = S + 1
    x = L / 2 ^ (S - 1)
    y = L / 2 ^ (S - 1)
    N = 2 ^ (S - 1) - 1
              
    PRINT "step: "; S
               
    FOR j = 0 TO N
    FOR k = 0 TO N
        plasma(x * j + x / 2, y * k + y / 2) = (plasma(x * j, y * k) + plasma(x * j + x, y * k) + plasma(x * j, y * k + y) + plasma(x * j + x, y * k + y)) / 4 + RND * NOISE
    NEXT: NEXT

    FOR j = 0 TO N
    FOR k = 0 TO N
	xj = x * j
	yk = y * k
        plasma(xj + x / 2, yk) = (plasma(xj, yk) + plasma(xj + x, yk) + plasma(xj + x / 2, yk + y / 2)) / 3 + RND * NOISE
        plasma(xj + x / 2, yk + y) = (plasma(xj + x / 2, yk + y / 2) + plasma(xj, yk + y) + plasma(xj + x, yk + y)) / 3 + RND * NOISE
        plasma(xj, yk + y / 2) = (plasma(xj, yk) + plasma(xj, yk + y) + plasma(xj + x / 2, yk + y / 2)) / 3 + RND * NOISE
        plasma(xj + x, yk + y / 2) = (plasma(xj + x, yk) + plasma(xj + x, yk + y) + plasma(xj + x / 2, yk + y / 2)) / 3 + RND * NOISE
    NEXT: NEXT
    NOISE = NOISE / 2
LOOP WHILE x > 2
  


'    original LxL square
'    FOR j = 0 TO L
'    FOR k = 0 TO L
'        PSET (j, k), PLASMA(j, k)
'    NEXT: NEXT


'   rescaled to fit the screen (320x200)
'    FOR x = 0 TO 319
'    FOR y = 0 TO 199
'       PSET (x, y), plasma(INT(L * x / 319), INT(L * y / 199))
'    NEXT
'    NEXT

'   alternative method (not much faster)
    DEF SEG = &HA000
    FOR offset = 0 TO 64000
        x = offset MOD 320
        y = INT(offset / 320)
        POKE (offset), plasma(INT(L * x / 319), INT(L * y / 199))
    NEXT



REM RGB palette rotation
k% = 0
DO
    FOR c% = 0 TO 63
        OUT &H3C8, c% + k%
        OUT &H3C9, c%
        OUT &H3C9, 0
        OUT &H3C9, 0
    NEXT

    FOR c% = 64 TO 127
        OUT &H3C8, c% + k%
        OUT &H3C9, 63 - c%
        OUT &H3C9, c%
        OUT &H3C9, 0
    NEXT

    FOR c% = 128 TO 191
        OUT &H3C8, c% + k%
        OUT &H3C9, 0
        OUT &H3C9, 63 - c%
        OUT &H3C9, c%
    NEXT

    FOR c% = 192 TO 255
        OUT &H3C8, c% + k%
        OUT &H3C9, 0
        OUT &H3C9, 0
        OUT &H3C9, 63 - c%
    NEXT

    k% = (k% + 1) MOD 255

LOOP UNTIL INKEY$ = CHR$(27)


