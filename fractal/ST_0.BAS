' AUTHOR$ = "WOJTEK" + CHR$(&H40) + "BITOLOGIA.ORG"
'
' 2020-07-29
' SIERPINSKI TRIANGLE
'
' SEE ALSO ST.ASM

SCREEN 13 ' VGA 320x200x256
DEFINT A-Z
DO
        R = INT(RND * 3)
        SELECT CASE R
        CASE 0
                X = X / 2
                Y = Y / 2
        CASE 1
                X = X + (320 - X) / 2
                Y = Y / 2
        CASE 2
                X = X + (320 - X) / 2
                Y = Y + (200 - Y) / 2
        END SELECT
        PSET (X, Y), R + 2
LOOP UNTIL INKEY$ = CHR$(27) ' ESC TO EXIT

