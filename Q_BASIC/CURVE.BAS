REM CURVE
REM BASED ON THE 1993 ATARI 800XL BASIC CODE

SCREEN 12

x0 = 420
y0 = 240: r = 0

FOR alpha = 0 TO 2 * 3.14 STEP .01
    x = x0 + r * COS(alpha)
    y = y0 + r * SIN(alpha)
    r = r + SIN(alpha)

    PSET (x, y), 2

NEXT

r = 70

DO: PSET (x0 + r - a, y0 - SQR(2 * r * a - a * a))
    PSET (x0 - r + a, y0 + SQR(2 * r * a - a * a))
    PSET (x0 + SQR(2 * r * a - a * a), y0 + r - a)
    PSET (x0 - SQR(2 * r * a - a * a), y0 - r + a)
    a = a + 1
    LOOP WHILE a < 2 * r




' 10 REM 1995 ATARI 800XL
' 20 DIM A$(40): INPUT A$
' 30 L = LEN(A$)
' 40 X = (40 - L) / 2
' 50 GR. 0: POKE 755, 0: POSITION INT(X), 12: REM CENTERED TEXT
' 60 ? A$
' 70 REM GOTO 60
' RUN
