' JULIA SET AND CHAOS GAME
'
' Taken from the book of fractals
' by H.-O. Peitgen, H. Juergens, D. Saupe (1996)
'
' 2020-06-06 (p.469)
' ----------------------------------------------------------------------------
' Algorithm for Julia set based on chaos game for inverse mappings.
' Iterative process of chaos game begins in a repulsive fixed point.
' Such point belongs to the Julia set.
' Fixed point of z --> z^2 + c is given by z = 1/2 +/- SQR(1/4 - c)
' Fixed point is said to be repulsive if |z| > 1/2; in such case
' the derivative of z --> z^2 + c is 2*z and |2*z| > 1.
' Hence, c in the root SQR(1/4 - c) such that Re(SQR(1/4 - c)) > 0,
' is a repulsive point.

' First, we assign a value to z = xn + i*yn.
' Then we calculate a square root of z - c (with positive real part).
' After the first iteration we add 1/2 which makes it a repulsive point
' and it is a starting point for next iterations.

' Once we have SQR(z - c) we randomly choose a branch/sign
' of +/- SQR(z - c). This is called "chaos game".

' Size of the picture was originally chosen that the unit
' circle (being a Julia set for c = 0) covers 2/3 of width
' of the full picture area.

' The source code is full of GOTOs and other shit; see JS.BAS instead!

SCREEN 12

REM INPUT "re-c,im-c:", xc, yc
xc = -1
yc = .1

REM draw (dotted) axes
LINE (0, 240)-(640, 240), 8, , &H1111
LINE (320, 0)-(320, 480), 8, , &H1111

REM calculate fixed points
LET xn = .25
LET yn = 0
LET i = 0

DO:     a = xn - xc
        b = yn - yc
        REM calculate a square root for which Re(root) >= 0
        IF a > 0 GOTO 100
        IF a < 0 GOTO 150
        xn = SQR(ABS(b) / 2)
        IF xn > 0 THEN yn = b / (2 * xn) ELSE yn = 0
        GOTO 200
100     xn = SQR((SQR(a * a + b * b) + a) / 2)
        yn = b / (2 * xn)
        GOTO 200
150     yn = SQR((SQR(a * a + b * b) - a) / 2)
        IF b < 0 THEN yn = -yn
        xn = b / (2 * yn)
        REM in the first step we calculate a repulsive fixed point
200     IF i = 1 THEN xn = xn + .5
        REM random choice for a root branch
        IF RND < .5 THEN GOTO 300
        xn = -xn
        yn = -yn
300     PSET (xn * 150 + 320, -yn * 150 + 240)
        LOOP UNTIL INKEY$ = CHR$(27)

        END



