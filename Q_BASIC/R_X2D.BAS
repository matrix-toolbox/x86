REM 1996-08-28
REM RECURSIVE PROCEDURE FOR A 2-DIM X-LIKE FRACTAL
REM
REM THE VERY FIRST ATTEMPT TO UNDERSTANDING HOW
REM TO CREATE A FRACTAL-LIKE STRUCTURES VIA RECURSION
REM
REM DERIVATIONS: "R_X3D.BAS", "R_SC.BAS", "R_SP3D.BAS" AND "R_STB.BAS"
  
SCREEN 12: DEFINT A-Z

LET L = 3 ^ 5: REM 243 DEFAULT VALUE

REM RANK = 1 - 7
LET RANK = 5

LET XCENTER = 100
LET YCENTER = 100

LET R = RANK - 1: DIMENSION = 0

WHILE R > -1
      DIMENSION = DIMENSION + 5 ^ R: R = R - 1
      WEND

DIM x(DIMENSION)
DIM y(DIMENSION)

REM PREDEFINED COLOUR SCHEME

DIM colour(7)
    colour(0) = 8
    colour(1) = 10
    colour(2) = 2
    colour(3) = 4
    colour(4) = 12
    colour(5) = 5

INDEX = 1
SCALE = 1
I = 0

WHILE INDEX <> DIMENSION

    x(INDEX + 0) = x(I)
    y(INDEX + 0) = y(I) + 2 * L / 3 ^ SCALE

    x(INDEX + 1) = x(I) + 2 * L / 3 ^ SCALE
    y(INDEX + 1) = y(I) + 2 * L / 3 ^ SCALE

    x(INDEX + 2) = x(I) + 1 * L / 3 ^ SCALE
    y(INDEX + 2) = y(I) + 1 * L / 3 ^ SCALE

    x(INDEX + 3) = x(I)
    y(INDEX + 3) = y(I)

    x(INDEX + 4) = x(I) + 2 * L / 3 ^ SCALE
    y(INDEX + 4) = y(I)

    INDEX = INDEX + 5: I = INDEX / 5

    T1 = 0
    T2 = 0

    DO: T1 = T1 + 5 ^ T2: IF T1 = I THEN SCALE = SCALE + 1: EXIT DO
        T2 = T2 + 1
        LOOP WHILE T2 < 7
 
    WEND

R = 0
M = 0

DO: c = 5 ^ R: EDGE = L / 3 ^ R

DO: x = XCENTER + x(M)
    y = YCENTER + y(M)

    M = M + 1

    EX = x + EDGE
    EY = y + EDGE

    LINE (x, y)-(EX, EY), 0, B
    LINE (x + 1, y + 1)-(EX - 1, EY - 1), colour(R), BF
    c = c - 1
    LOOP WHILE c > 0

    R = R + 1

    LOOP UNTIL R = RANK

    SLEEP

