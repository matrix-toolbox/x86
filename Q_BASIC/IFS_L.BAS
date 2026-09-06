REM IFS LETTERS
REM
REM 1995-01-03
REM
REM IT READS THE ASCII CODE FROM ROM
REM AND USES ITS BIT PATTERN AS COORDINATES FOR THE
REM ITERATED FUNCTION SYSTEM MECHANISM
REM
REM ONCE THE ARRAY OF ASCII IS PREPARED A LOOP BEIGNS
REM AND RANDOM CHARACTERS ARE BEING SELECTED TO BE DRAWN ON THE SCREEN
REM
REM HIT CONTROL+SCROLL_LOCK TO STOP

DIM A(127) AS INTEGER

REM ADDITIONAL ARRAY FOR A POKE-LIKE DRAWING:
REM
DIM T(7): P = 1: FOR C = 0 TO 7: T(C) = P: P = P + P: NEXT

XSCALE = 40
YSCALE = 61

SCREEN 12: RANDOMIZE TIMER

DO: DEF SEG = &HF000

    index% = 0
    offset% = 8 * INT(RND * 127)
    FOR byte% = 0 TO 7
        value% = PEEK(&HFA76 + offset% + byte%)
        FOR P% = 0 TO 7
            temp% = value% MOD 2
            IF temp% = 1 THEN
               A(index%) = 7 - P%
               A(index% + 1) = byte%
               index% = index% + 2
               END IF
            value% = (value% - temp%) / 2
            NEXT
        NEXT
        CLS
        WHILE INKEY$ = ""
              i% = 2 * INT(RND * index% / 2)
              X = X / 10 + A(i%)
              Y = Y / 10 + A(i% + 1)

            ' PSET (X * XSCALE, Y * YSCALE)
              XX = INT(X * XSCALE)
              YY = INT(Y * YSCALE)

              DEF SEG = &HA000
              S = XX \ 8 + YY * 80
              POKE S, PEEK(S) OR T(7 - XX MOD 8)

              WEND
    LOOP


