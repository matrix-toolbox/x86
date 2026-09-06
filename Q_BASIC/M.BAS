REM MANDELBROT SET

SCREEN 12

LET MaxIterations = 128

DEFINT L, X-Y
DIM colour(16) AS INTEGER

DATA 01, 09, 03, 02, 10, 14, 12, 04
DATA 06, 08, 01, 02, 01, 02, 01, 02

FOR i = 0 TO 15
    READ colour(i)
NEXT

LINE (0, 0)-(404, 0), 9: LINE (0, 0)-(0, 404), 9
LINE (404, 0)-(404, 404), 9: LINE (0, 404)-(404, 404), 9
PSET (102, 1), 9: PSET (202, 1), 9: PSET (302, 1), 9
PSET (102, 403), 9: PSET (202, 403), 9: PSET (302, 403), 9
PSET (1, 102), 9: PSET (1, 202), 9: PSET (1, 302), 9
PSET (403, 102), 9: PSET (403, 202), 9: PSET (403, 302), 9

FOR y = -200 TO 200 STEP 1
    FOR x = -200 TO 200 STEP 1
        ImO = y / 100
        ReO = x / 100
        FOR L = 0 TO MaxIterations
            ReS = ReO * ReO
            ImS = ImO * ImO
            IF ReS + ImS > 4 THEN PSET (x + 202, y + 202), colour(L MOD 16): EXIT FOR
            ReN = ReS - ImS
            ImN = 2 * ReO * ImO
            ReO = ReN + x / 100
            ImO = ImN + y / 100
        NEXT
    NEXT
NEXT

