REM FLUID
REM 1997-08-30
REM
REM SIMULATOR OF THE BUTTERFLY FROM BOULDER DASH

RANDOMIZE TIMER
DEFINT A-Z

LET F = 41

DIM d(F - 1), x(F - 1), y(F - 1), K(F - 1)
DIM vx(3) AS INTEGER, vy(3) AS INTEGER

    vx(0) = 0: vy(0) = -1
    vx(1) = 1: vy(1) = 0
    vx(2) = 0: vy(2) = 1
    vx(3) = -1: vy(3) = 0

PRINT "Wait - Initialize"; F; "Fluids randomly..."
FOR I = 0 TO F - 1
    d(I) = 0
    x(I) = 111 + INT(RND * 38)
    y(I) = 120 + INT(RND * 18)
    K(I) = 12 + INT(RND * 110)
NEXT

SCREEN 13

WHILE INKEY$ = "": REM PlayGround
    REM LINE (RND * 320, RND * 200)-(RND * 32, RND * 20), 1 + RND * 1, B
    REM LINE (RND * 320, RND * 200)-(RND * 32, RND * 20), 0, B
    q1 = RND * 320
    q2 = RND * 200
    LINE (q1, q2)-(q1 + 10, q2 + 100), 19 + RND, B, &HF2
    LINE (q1 + 1, q2 + 1)-(q1 + 10, q2 + 10), 0, B
WEND

WHILE INKEY$ = ""
    FOR I = 0 TO F - 1
        x = x(I)
        y = y(I)
        IF POINT(x + vx(d(I)), y + vy(d(I))) = 0 THEN
            PSET (x, y), 0
            x(I) = x + vx(d(I))
            y(I) = y + vy(d(I))
            PSET (x(I), y(I)), K(I)
            d(I) = (d(I) + 1) MOD 4
        ELSE
            d(I) = d(I) - 1
            IF d(I) = -1 THEN d(I) = 3
        END IF
    NEXT
WEND

