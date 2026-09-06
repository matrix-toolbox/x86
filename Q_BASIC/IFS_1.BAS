REM
REM CLASSIC IFS

SCREEN 12

DO: r = 1 + INT(RND * 9)

    ON r GOTO 10, 20, 30, 40, 50, 60, 70, 80

    xn = -.2 * yo + 1!
    yn = .625 * xo + .07
    GOTO 90

10  xn = -.2 * yo + 2.8
    yn = .625 * xo + .07
    GOTO 90

20  xn = .2 * xo + 2.8
    yn = .15 * yo + .12
    GOTO 90

30  xn = .16 * xo + 2.8
    yn = .15 * yo + 1.91
    GOTO 90

40  xn = .275 * xo + 5!
    yn = .15 * yo + .12
    GOTO 90

50  xn = .16 * yo + 5.01
    yn = .16 * xo + .79
    GOTO 90

60  xn = .275 * xo + 5!
    yn = .15 * yo + 1.91
    GOTO 90

70  xn = .16 * -yo + 6.92
    yn = .17 * xo + 2.57
    GOTO 90

80  xn = .275 * xo + 5!
    yn = .15 * yo + 3.74

90  PSET (xn * 90, yn * 105), r
    xo = xn
    yo = yn
    LOOP

