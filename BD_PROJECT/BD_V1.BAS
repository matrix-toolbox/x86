REM wojtek[at]bitologia.org
REM 2020-02-20
REM 2020-02-21 fixed flies' path but too slow in QB!


SCREEN 13

LINE (0, 199)-(319, 199), 8, B

RANDOMIZE TIMER
DEFINT A-Z

LET xMax = 19
LET yMax = 11
LET L = 16

LET BDVoid = 0
LET BDGrass = 1
LET BDWall = 2
LET BDStone = 7
LET BDXFly = 4
LET BDYFly = 5
LET BDIron = 8


x = 1: y = 1
LINE (x * L, y * L)-((x + 1) * L - 1, (y + 1) * L - 1), BDXFly, BF
LINE (x * L + 2, y * L + 2)-((x + 1) * L - 3, (y + 1) * L - 3), 0, BF
LINE (x * L + 4, y * L + 4)-((x + 1) * L - 5, (y + 1) * L - 5), BDXFly, BF
LINE (x * L + 6, y * L + 6)-((x + 1) * L - 7, (y + 1) * L - 7), 0, BF
DIM gBDXFly(256) AS INTEGER
GET (x * L, y * L)-((x + 1) * L - 1, (y + 1) * L - 1), gBDXFly


LINE (x * L, y * L)-((x + 1) * L - 1, (y + 1) * L - 1), BDYFly, BF
LINE (x * L + 2, y * L + 2)-((x + 1) * L - 3, (y + 1) * L - 3), 0, BF
LINE (x * L + 4, y * L + 4)-((x + 1) * L - 5, (y + 1) * L - 5), BDYFly, BF
LINE (x * L + 6, y * L + 6)-((x + 1) * L - 7, (y + 1) * L - 7), 0, BF
DIM gBDYFly(256) AS INTEGER
GET (x * L, y * L)-((x + 1) * L - 1, (y + 1) * L - 1), gBDYFly


LINE (x * L, y * L)-((x + 1) * L - 1, (y + 1) * L - 1), BDGrass, BF
LINE (x * L + 1, y * L + 1)-((x + 1) * L - 2, (y + 1) * L - 2), 0, B
DIM gBDGrass(256) AS INTEGER
GET (x * L, y * L)-((x + 1) * L - 1, (y + 1) * L - 1), gBDGrass

LINE (x * L, y * L)-((x + 1) * L - 1, (y + 1) * L - 1), BDIron, BF
LINE (x * L + 1, y * L + 1)-((x + 1) * L - 2, (y + 1) * L - 2), 0, B
DIM gBDIron(256) AS INTEGER
GET (x * L, y * L)-((x + 1) * L - 1, (y + 1) * L - 1), gBDIron


LINE (x * L, y * L)-((x + 1) * L - 1, (y + 1) * L - 1), BDStone, BF
LINE (x * L + 1, y * L + 1)-((x + 1) * L - 2, (y + 1) * L - 2), 0, B
DIM gBDStone(256) AS INTEGER
GET (x * L, y * L)-((x + 1) * L - 1, (y + 1) * L - 1), gBDStone

LINE (x * L, y * L)-((x + 1) * L - 1, (y + 1) * L - 1), BDWall, BF
LINE (x * L + 1, y * L + 1)-((x + 1) * L - 2, (y + 1) * L - 2), 0, B
DIM gBDWall(256) AS INTEGER
GET (x * L, y * L)-((x + 1) * L - 1, (y + 1) * L - 1), gBDWall

LINE (x * L, y * L)-((x + 1) * L - 1, (y + 1) * L - 1), BDVoid, BF
'LINE (x * L + 1, y * L + 1)-((x + 1) * L - 2, (y + 1) * L - 2), 0, B
DIM gBDVoid(256) AS INTEGER
GET (x * L, y * L)-((x + 1) * L - 1, (y + 1) * L - 1), gBDVoid


REM $STATIC
DIM BDArray(xMax, yMax) AS INTEGER
DIM BDArray2(xMax, yMax) AS INTEGER


LET FX = 10
LET FY = 2

DIM x(FX - 1), y(FX - 1), d(FX - 1) AS INTEGER
DIM x2(FY - 1), y2(FY - 1), d2(FY - 1) AS INTEGER
DIM dx(3) AS INTEGER, dy(3) AS INTEGER
dx(0) = 0: dy(0) = -1
dx(1) = 1: dy(1) = 0
dx(2) = 0: dy(2) = 1
dx(3) = -1: dy(3) = 0

DIM dx2(3) AS INTEGER, dy2(3) AS INTEGER
dx2(0) = 0: dy2(0) = -1
dx2(1) = -1: dy2(1) = 0
dx2(2) = 0: dy2(2) = 1
dx2(3) = 1: dy2(3) = 0


FOR k = 0 TO FX - 1
d(k) = 0
NEXT

FOR k = 0 TO FY - 1
d2(k) = 0
NEXT


FOR t = 1 TO 100
    BDArray(1 + INT(RND * xMax), 1 + INT(RND * yMax)) = 1 + INT(RND * 2)
NEXT



BDArray(3, 2) = BDIron
BDArray(3, 3) = BDXFly
x(0) = 3: y(0) = 3
BDArray(3, 4) = BDStone
BDArray(2, 3) = BDStone
'BDArray(4, 3) = BDStone

BDArray(4, 4) = BDStone
BDArray(5, 6) = BDStone
BDArray(7, 8) = BDXFly
x(1) = 7: y(1) = 8
BDArray(7, 9) = BDXFly
x(2) = 7: y(2) = 9

BDArray(6, 6) = BDXFly
x(3) = 6: y(3) = 6

BDArray(12, 7) = BDXFly
x(4) = 12: y(4) = 7
BDArray(13, 8) = BDXFly
x(5) = 13: y(5) = 8
BDArray(14, 9) = BDXFly
x(6) = 14: y(6) = 9
BDArray(13, 4) = BDXFly
x(7) = 13: y(7) = 4
BDArray(13, 5) = BDXFly
x(8) = 13: y(8) = 5
BDArray(13, 6) = BDXFly
x(9) = 13: y(9) = 6

BDArray(10, 4) = BDYFly
x2(0) = 10: y2(0) = 4
BDArray(10, 5) = BDYFly
x2(1) = 10: y2(1) = 5



FOR t = 0 TO xMax
    BDArray(t, 0) = BDIron
    BDArray(t, yMax) = BDIron
NEXT
FOR t = 0 TO yMax
    BDArray(0, t) = BDIron
    BDArray(xMax, t) = BDIron
NEXT


DO
    GOSUB drawBDArray
    GOSUB refreshBDArray
    GOSUB refresh8psbm
LOOP UNTIL INKEY$ = CHR$(27)


STOP

drawBDArray:
    FOR y = 0 TO yMax
    FOR x = 0 TO xMax
        SELECT CASE BDArray(x, y)
        CASE BDVoid
            PUT (x * L, y * L), gBDVoid, PSET
        CASE BDXFly
            PUT (x * L, y * L), gBDXFly, PSET
        CASE BDYFly
            PUT (x * L, y * L), gBDYFly, PSET
        CASE BDStone
            PUT (x * L, y * L), gBDStone, PSET
        CASE BDGrass
            PUT (x * L, y * L), gBDGrass, PSET
        CASE BDIron
            PUT (x * L, y * L), gBDIron, PSET
        CASE BDWall
            PUT (x * L, y * L), gBDWall, PSET
        END SELECT

    NEXT
    NEXT
RETURN



refreshBDArray:

    FOR y = 0 TO yMax
    FOR x = 0 TO xMax
        IF (BDArray(x, y) <> BDXFly AND BDArray(x, y) <> BDYFly) THEN BDArray2(x, y) = BDArray(x, y)
    NEXT
    NEXT
 

    FOR i = 0 TO FX - 1
        x = x(i)
        y = y(i)
        k = 0
        DO WHILE k <= 3
            c1 = BDArray(x + dx(d(i)), y + dy(d(i)))
            c2 = BDArray2(x + dx(d(i)), y + dy(d(i)))
            IF c1 = BDVoid AND c2 = BDVoid THEN
                BDArray2(x, y) = BDVoid
                x(i) = x + dx(d(i))
                y(i) = y + dy(d(i))
                BDArray2(x(i), y(i)) = BDXFly
        d(i) = (d(i) + 1) MOD 4
                EXIT DO
            ELSE
                BDArray2(x, y) = BDXFly
                BDArray(x, y) = BDXFly
                d(i) = d(i) - 1
                IF d(i) = -1 THEN d(i) = 3
            END IF
            k = k + 1
        LOOP
'        d(i) = (d(i) + 1) MOD 4

    NEXT
  


    FOR i = 0 TO FY - 1
        x = x2(i)
        y = y2(i)
        k = 0
        DO WHILE k <= 3
            c1 = BDArray(x + dx2(d2(i)), y + dy2(d2(i)))
            c2 = BDArray2(x + dx2(d2(i)), y + dy2(d2(i)))
            IF c1 = BDVoid AND c2 = BDVoid THEN
                BDArray2(x, y) = BDVoid
                x2(i) = x + dx2(d2(i))
                y2(i) = y + dy2(d2(i))
                BDArray2(x2(i), y2(i)) = BDYFly
        d2(i) = (d2(i) + 1) MOD 4
                EXIT DO
            ELSE
                BDArray2(x, y) = BDYFly
                BDArray(x, y) = BDYFly
                d2(i) = d2(i) - 1
                IF d2(i) = -1 THEN d2(i) = 3
            END IF
            k = k + 1
        LOOP
'        d2(i) = (d2(i) + 1) MOD 4

    NEXT



    FOR y = 0 TO yMax
    FOR x = 0 TO xMax
        BDArray(x, y) = BDArray2(x, y)
    NEXT
    NEXT

RETURN




refresh8psbm:
      FOR k = 1 TO 8
          r = INT(RND * 2)
          IF r = 0 THEN c = 2 ELSE c = 8
          LINE (-4 + k * 8, 194)-(-6 + k * 8, 196), c, BF
      NEXT
RETURN

