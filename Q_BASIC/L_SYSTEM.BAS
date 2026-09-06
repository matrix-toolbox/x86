REM L-SYSTEM
REM SINGLE AXIOM: F ---> SUBSTITUTE$
REM
REM 1995-12-22
REM 2002-10-30 * DYNAMIC ARRAY SIZE FORMULA
REM 2012-08-20 * PARAMETERS KEPT IN DATA STRUCTURES
REM
REM WARNING:
REM THE SIZE OF "STRING * 1" ARRAY CANNOT EXCEED 2^15-1 VALUE!

REM
REM SELECT THE MODEL HERE
REM
RESTORE LSYSTEM1
        READ SUBSTITUTE$
        READ ANGLE
        READ DELTAANGLE
        READ XOO
        READ YOO
        READ NMAX
        READ R: REM LINE LENGTH
        READ RS: REM LINE SCALING

CONST PI = 3.141592654#

SCREEN 12

AXIOM$ = "F"

REM RECTANGULAR CURVE
LSYSTEM1:
DATA "F+F+++F--",0,2,10,345,8,64,2

REM VON KOCH CURVE
LSYSTEM2:
DATA "F+F++++F+F", 0, 3, 3, 300, 6, 70, 3

REM SIERPINSKI TRIANGLE: REDUNDANT
LSYSTEM3:
DATA "F++F++++F++++F++F", 0, 3, 60, 460, 6, 128, 2

L1 = 1: REM NOT USED
L2 = LEN(SUBSTITUTE$)

REM PREPARE AN ADDITIONAL ARRAY. TO BE USED IN
REM THE RECURSIVE CONSTRUCTION OF THE L-PATTERN
REM
REDIM LSYSTEMMIRROR(1 TO L2) AS STRING * 1
FOR K = 1 TO L2
        LSYSTEMMIRROR(K) = MID$(SUBSTITUTE$, K, 1)
        NEXT

REM AUX. VARIABLE: NUMBER OF AXIOM$ IN SUBSTITUTE$
REM
A = 0
FOR K = 1 TO L2
        IF MID$(SUBSTITUTE$, K, 1) = AXIOM$ THEN A = A + 1
        NEXT

REM RECURSION STARTS WITH SUBSTITUTE$
REM

LN = L2

LOCATE 1, 1: PRINT "PLEASE WAIT. HIGHER ORDERS TAKE LONGER..."

FOR N = 3 TO NMAX
        LOCATE 2, 1: PRINT "STEP ="; N; "OF"; NMAX
        LOCATE 1, 43: PRINT "PREPARING ARRAY..."
        LASTLN = LN

        REM CALCULATE THE LENGTH OF A NEXT PATTERN
        REM
        LN = L2 * A ^ (N - 2) + (L2 - A) * ((1 - A ^ (N - 2)) / (1 - A))

        REM ALLOCATE THE ARRAY
        REM AND FILL IT ACCORDING TO THE SUBSTITUTE$ CONTENT     
        REM
        REDIM LSYSTEM(1 TO LN) AS STRING * 1

        L = 1
        FOR K = 1 TO LASTLN
                IF LSYSTEMMIRROR(K) = "F" THEN
                        FOR T = 1 TO L2
                                LSYSTEM(L + T - 1) = LSYSTEMMIRROR(T)
                                NEXT T
                        L = L + L2
                        END IF
                IF LSYSTEMMIRROR(K) = "+" THEN
                        LSYSTEM(L) = "+"
                        L = L + 1
                        END IF
                IF LSYSTEMMIRROR(K) = "-" THEN
                        LSYSTEM(L) = "-"
                        L = L + 1
                        END IF
                NEXT K

        LOCATE 1, 43: PRINT "DRAWING...        "
        XO = XOO
        YO = YOO
        ANGLE = 0
        GOSUB LSYSTEMDRAW
        R = R / RS

        REM PREPARE ANOTHER ARRAY (AS ABOVE)
        REM TO BE USED IN THE NEXT STEP
        REM

        IF N = NMAX THEN EXIT FOR: REM SKIP THIS AT THE LAST STEP

        REDIM LSYSTEMMIRROR(1 TO LN) AS STRING * 1
        FOR K = 1 TO LN
                LSYSTEMMIRROR(K) = LSYSTEM(K)
                NEXT K
        NEXT N

PRINT
PRINT "DONE"
LOCATE 1, 43: PRINT "                  ": REM 18
SLEEP: END

REM "DRAW" THE STRING USING POLAR COORDINATE SYSTEM
LSYSTEMDRAW:

REM CHOOSE COLOURING METHOD
IF N = NMAX THEN C = 9 ELSE C = 8
REM C = C + 1

PSET (XO, YO), C

FOR K = 1 TO LN
        IF LSYSTEM(K) = "F" THEN
                YN = YO + R * SIN(ANGLE)
                XN = XO + R * COS(ANGLE)
                LINE -(XN, YN), C
                XO = XN
                YO = YN
                END IF
        IF LSYSTEM(K) = "+" THEN
                ANGLE = ANGLE - PI / DELTAANGLE
                IF ANGLE < 2 * PI THEN ANGLE = ANGLE + 2 * PI
                END IF
        IF LSYSTEM(K) = "-" THEN
                ANGLE = ANGLE + PI / DELTAANGLE
                IF ANGLE > 2 * PI THEN ANGLE = ANGLE - 2 * PI
                END IF
        NEXT

RETURN

