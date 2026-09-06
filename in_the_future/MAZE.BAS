REM 2021-02-05
REM MAZE
REM WOJTEK [AT] BITOLOGIA.ORG

SCREEN 13
RANDOMIZE TIMER

k = 2

y = 1
WHILE y < 200
    x = 1
    WHILE x < 320
        r = INT(RND * 4)
        IF r = 1 THEN
            PSET (x + 1, y), k
            PSET (x + 1, y + 1), k
            PSET (x + 2, y + 1), k
        ELSEIF r = 2 THEN
            PSET (x + 1, y + 1), k
            PSET (x + 2, y + 1), k
            PSET (x + 1, y + 2), k
        ELSEIF r = 3 THEN
            PSET (x, y + 1), k
            PSET (x + 1, y + 1), k
            PSET (x + 1, y + 2), k
        ELSEIF r = 4 THEN
            PSET (x, y + 1), k
            PSET (x + 1, y + 1), k
            PSET (x + 1, y), k
        END IF

        x = x + 3
    WEND
    y = y + 3
WEND


SLEEP


