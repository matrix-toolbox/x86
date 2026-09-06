REM ARCANOID
REM
REM 1998-03-22 * V.3.45
REM
REM A BALL IS PLACED IN THE MIDDLE OF SCREEN
REM AND STARTS TO MOVE DIAGONALLY 45 DEGREES DOWNWARD
REM WITH RESPECT TO THE BOUNDARY CONDITIONS
REM
REM 10 X = X + 1, Y = Y + 1
REM    IF X = XMAX GOTO 20
REM    IF Y = YMAX GOTO 30
REM    GOTO 10
REM
REM 20 X = X - 1, Y = Y + 1
REM    IF X = XMIN GOTO 10
REM    IF Y = YMAX GOTO 40
REM    GOTO 20
REM
REM 30 X = X + 1, Y = Y - 1
REM    IF X = XMAX GOTO 40
REM    IF Y = YMIN GOTO 10
REM    GOTO 30
REM
REM 40 X = X - 1, Y = Y - 1
REM    IF X = XMIN GOTO 30
REM    IF Y = YMIN GOTO 20
REM    GOTO 40

SCREEN 11

DEFINT A-Z: RANDOMIZE TIMER

N = 11

DIM X(N), Y(N), R(N), XO(N), YO(N), A(N)

DIM Mx(3), My(3)

Mx(0) = 1
My(0) = -1
Mx(1) = -1
My(1) = -1
Mx(2) = -1
My(2) = 1
Mx(3) = 1
My(3) = 1

FOR B = 0 TO N - 1
        X(B) = 5 + RND * 630
        Y(B) = 5 + RND * 470
        R(B) = 1 + RND * 13
        A(B) = RND * 3
        NEXT


WHILE INP(96) <> 1

    FOR B = 0 TO N - 1

        A = A(B)
        X = X(B)
        Y = Y(B)
        R = R(B)
        X = X + Mx(A)

        IF X > 630 - R OR X < R AND A = 1 THEN A = ABS(A - 1): GOTO L
        IF X < R AND A = 2 THEN A = 3: GOTO L

        Y = Y + My(A)

        IF Y < R OR Y > 470 - R THEN A = ABS(A - 3)

L:      X(B) = X
        Y(B) = Y
        A(B) = A

        CIRCLE (XO(B), YO(B)), R, 0

        XO(B) = X(B)
        YO(B) = Y(B)

        CIRCLE (X(B), Y(B)), R
    NEXT
WEND
