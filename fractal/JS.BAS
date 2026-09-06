' WOJTEK[AT]BITOLOGIA.ORG
'
' 2020-08-14 - BASED ON JS_CG.BAS (JULIA SET AND CHAOS GAME)
' 2020-08-15 - CODE SIMPLIFIED (OBFUSCATED)
'
' SEE ALSO JS.ASM

SCREEN 13

NumberOfPoints = 256
REM SORRY FOR THIS JavaShitLikeCamelCase BUT
REM QBASIC DOES NOT ACCEPT UNDERSCORES_IN_VAR_NAMES

DIM xx(NumberOfPoints)
DIM yy(NumberOfPoints)
' points to show are stored in two arrays,
' when it comes to display a picture, data is read from xx and yy,
' plotted with black ("CLS") and new coordinates are being prepared,
' plotted in shades of gray and stored again in xx and yy,
' this makes a nice glittering effect without explicit CLS

DIM RR(NumberOfPoints)


LET XN = 0
LET YN = 0
LET ALPHA = 0

DO:     ALPHA = ALPHA + 1 / 64
        IF ALPHA >= 6.283185 THEN ALPHA = 0
        xc = .8 * COS(ALPHA)
        yc = SIN(ALPHA)
        REM EXPLORE MANDELBROT SET OVER THE ELLIPSE
        REM PARAMETRIZED WITH ALPHA

        FOR J = 1 TO NumberOfPoints
                A = XN - xc
                B = YN - yc
                C = B / 2
                R = INT(RND * 2)
1010            IF R THEN
1020                    XN = SQR((SQR(A * A + B * B) + A) / 2)
1030                    YN = C / XN
1040            ELSE
                        YN = SGN(B) * SQR((SQR(A * A + B * B) - A) / 2)
                        XN = C / YN
1050            END IF

                IF R THEN XN = -XN: YN = -YN

                PSET (xx(J), yy(J)), 0
                xxx = XN * 90 + 160
                yyy = YN * 60 + 100
                PSET (xxx, yyy), 16 + RND * 15
                xx(J) = xxx
                yy(J) = yyy
        NEXT J
LOOP UNTIL INKEY$ = CHR$(27)
END


' LINES 10XX CAN BE REMOVED AND IT STILL WORKS
' ANYBODY TO EXPLAIN THIS PHENOMENA?

