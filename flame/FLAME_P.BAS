
SCREEN 13


FOR c% = 0 TO 15
    OUT &H3C8, c%
    OUT &H3C9, INT(c% * 4)
    OUT &H3C9, 0
    OUT &H3C9, 0
NEXT

FOR c% = 16 TO 78
    OUT &H3C8, c%
    OUT &H3C9, 60
    OUT &H3C9, c% - 15
    OUT &H3C9, 0
NEXT


FOR c% = 79 TO 255
    OUT &H3C8, c%
    OUT &H3C9, 60
    OUT &H3C9, 63
    OUT &H3C9, INT(c% / 3) - 26
NEXT



FOR x% = 0 TO 255
    LINE (x%, 1)-(x%, 200), x%, BF
NEXT

SLEEP

