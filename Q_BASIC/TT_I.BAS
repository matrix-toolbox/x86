REM JUST AN INTERESTING PATTERN - SHOULD BE REWRITTEN USING "DATA"
REM
REM 1996-10-13

SCREEN 12
LET l = 11
    h = 5.5 * SQR(3): REM = SQR(L ^ 2 - (L / 2) ^ 2)
    x = 300
    y = 200

PSET (300, 200)
LINE -(300 + 4 * l, 200)
LINE -(300 + 2 * l, 200 - 4 * h)
LINE -(300 + 2.5 * l, 200 - 5 * h)
LINE -(300 + l * 9, 200 + 8 * h)
LINE -(300 + l * 9 + l / 2, 200 + 7 * h)
LINE -(300 + 2.5 * l, 200 - 7 * h)
LINE -(300 + l, 200 - 4 * h)
LINE -(300 + 3 * l, 200)
PSET (300, 200)
LINE -(300 + l / 2, 200 - h)
LINE -(300 + l, 200)
LINE (300 + 2 * l, 200)-(300, 200 - 4 * h)
LINE (x - l / 2, y + h)-(x + 4.5 * l, y + h)

LINE (x, y)-(x - 1.5 * l, y + 3 * h)
LINE -(x + 2.5 * l, y + 3 * h)
LINE -(x + 2 * l, y + 2 * h)
LINE -(x - l, y + 2 * h)
LINE (x + 2 * l, y + 2 * h)-(x + 5 * l, y + 2 * h)
LINE (x + 4 * l, y)-(x + 7.5 * l, y + 7 * h)
LINE -(x - 5.5 * l, y + 7 * h)
LINE -(x - 4.5 * l, y + 5 * h)
LINE -(x - 3.5 * l, y + 5 * h)
LINE -(x - 4 * l, y + 6 * h)
LINE -(x + 7 * l, y + 6 * h)
LINE (x - 5 * l, y + 8 * h)-(x - 5.5 * l, y + 7 * h)

LINE (x + l * 9, y + h * 8)-(x - 5 * l, y + h * 8)

LINE (x + l / 2, y - h)-(x - l, y - 4 * h)
LINE -(x - 3 * l, y)
LINE -(x - 2 * l, y)
LINE -(x - .5 * l, y - 3 * h)

LINE (x, y - 2 * h)-(x - 2.5 * l, y + 3 * h)
LINE -(x - 8.5 * l, y + 3 * h)
LINE -(x - 2 * l, y - 10 * h)
LINE -(x - 3 * l, y - 10 * h)
LINE -(x - 10 * l, y + 4 * h)
LINE -(x - 9.5 * l, y + 5 * h)
LINE -(x - 4.5 * l, y + 5 * h)

LINE (x - 10 * l, y + 4 * h)-(x + 3 * l, y + 4 * h)
LINE -(x + 2.5 * l, y + 3 * h)

LINE (x - 3.5 * l, y + 5 * h)-(x + 4.5 * l, y + 5 * h)
LINE -(x + 5 * l, y + 4 * h)
LINE -(x + 4 * l, y + 2 * h)

LINE (x + 3 * l, y + 2 * h)-(x + 4.5 * l, y + 5 * h)

LINE (x - 2.5 * l, y + 3 * h)-(x - 1.5 * l, y + 3 * h)

LINE (x - 2.5 * l, y + 5 * h)-(x - 3 * l, y + 6 * h)

LINE (x + 1.5 * l, y - 3 * h)-(x + 2 * l, y - 4 * h)

LINE (x - 1 * l, y - 4 * h)-(x + 2 * l, y - 10 * h)

LINE (x - 2 * l, y)-(x - 3.5 * l, y + 3 * h)

LINE (x - 2.5 * l, y + h)-(x - 5.5 * l, y + h)
LINE -(x - 5 * l, y + 2 * h)
LINE -(x - 3 * l, y + 2 * h)

LINE (x - 7.5 * l, y + 3 * h)-(x - 2 * l, y - 8 * h)
LINE -(x - 1.5 * l, y - 7 * h)
LINE -(x - 5.5 * l, y + h)

LINE (x - 3 * l, y)-(x - 4 * l, y)
LINE -(x + 2 * l, y - 12 * h)
          
LINE (x - 2.5 * l, y - 7 * h)-(x - 2 * l, y - 6 * h)

LINE (x - 2 * l, y - 10 * h)-(x - l, y - 8 * h)


LINE (x + 6.5 * l, y + h)-(x + 7.5 * l, y + h)
LINE -(x + 2 * l, y - 10 * h)

LINE (x + 6 * l, y)-(x + 7 * l, y)
LINE (x + 7 * l, y + 2 * h)-(x + 9 * l, y + 2 * h)
LINE -(x + 2.5 * l, y - 11 * h)
LINE -(x + 2 * l, y - 10 * h)
            
LINE (x + l, y - 4 * h)-(x, y - 6 * h)
LINE (x, y - 4 * h)-(x - l / 2, y - 5 * h)

LINE (x + l / 2, y - 5 * h)-(x + 1.5 * l, y - 7 * h)
LINE -(x + 2.5 * l, y - 7 * h)

LINE (x + 9 * l, y + 2 * h)-(x + 9.5 * l, y + h)
LINE -(x + 2.5 * l, y - 13 * h)
LINE -(x + 1.5 * l, y - 13 * h)
LINE -(x - 1.5 * l, y - 7 * h)
LINE (x + 2 * l, y - 12 * h)-(x + 2.5 * l, y - 13 * h)

SLEEP

