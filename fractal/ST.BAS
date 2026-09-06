' AUTHOR$ = "WOJTEK" + CHR$(&H40) + "BITOLOGIA.ORG"
'
' 2020-07-29 SIERPINSKI TRIANGLE
' 2020-08-02 CLEAN CODE
'
' SEE ALSO ST.ASM

SCREEN 13 ' VGA 320x200x256
DEFINT A-Z
DO
        R = INT(RND * 3)
        x = x / 2
        y = y / 2
        IF R > 0 THEN x = x + 160
        IF R = 2 THEN y = y + 100
        PSET (x, y), R + 2
LOOP UNTIL INKEY$ = CHR$(27) ' ESC TO EXIT

