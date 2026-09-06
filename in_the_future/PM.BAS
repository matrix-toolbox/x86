REM 2021-03-15
REM WOJTEK [AT] BITOLOGIA.ORG
REM PROJECTILE MOTION


SCREEN 12

RANDOMIZE TIMER
pi = 4 * ATN(1)
x0 = 320
y0 = -200
g = 9.81

DO
    theta = RND * 2 * pi
    v0 = INT(RND * 150)
    t = 0
    DO
        x = x0 + v0 * t * COS(theta)
        y = y0 + v0 * t * SIN(theta) - g * t ^ 2 / 2
        PSET (x, -y), 7
        t = t + .1
    IF x < 0 THEN EXIT DO
    IF x > 640 THEN EXIT DO
    LOOP UNTIL y < -480

    CLS
LOOP UNTIL INKEY$ = CHR$(27)


