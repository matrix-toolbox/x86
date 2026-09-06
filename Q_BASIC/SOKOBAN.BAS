REM SOKOBAN CLONE
REM
REM 1996-08-29 * [U] STABLE GRAY SCALE VERSION
REM 1997-07-14 * [U] LEVELS STORE IN A FILE
REM 2012-08-14 * [5] REFACTORING
REM 2012-08-14 * [7] NAMED LEVELS STORE IN DATA STRUCTURES
REM 2012-08-15 * [S] COLOR VERSION

DEFINT A-Z: SCREEN 13

GOTO SKIPTHIS

DEF SEG = &HA000
HERON:
DATA 00,00,00,00,00,15,00,00,00,00,00
DATA 00,00,00,00,00,15,00,00,00,00,00
DATA 00,00,00,00,15,15,15,00,00,00,00
DATA 00,00,00,00,15,15,15,00,00,00,00
DATA 00,00,00,15,00,15,00,15,00,00,00
DATA 00,00,00,15,00,15,00,15,00,00,00
DATA 00,00,00,00,00,15,00,00,00,00,00
DATA 00,00,00,00,00,15,00,00,00,00,00
DATA 00,00,00,00,00,15,00,00,00,00,00
DATA 00,00,00,00,00,15,00,00,00,00,00
DATA 00,00,00,00,00,15,00,00,00,00,00

RESTORE HERON:
FOR D = 0 TO 120
        READ PIXEL
        POKE (D MOD 11) + (D \ 11) * 320, PIXEL
        NEXT

SLEEP
END

SKIPTHIS:

REM DEFINE COLOURS:
CONST CHERO = 15
CONST CSLOT = 48
CONST CPACK1 = 66
CONST CPACK2 = 65
CONST CPACK3 = 42
CONST CPACK4 = 15

CONST CWOOD1 = 11

CONST CAVEX = 26
CONST CAVEY = 14

REM PREPARE GRAPHICS

DIM VOID(200)

GET (0, 0)-(10, 10), VOID

DIM HERON(200): REM RECOUNT COUNT IT (200)
DIM HEROS(200)
DIM HEROW(200)
DIM HEROE(200)

LINE (5, 0)-(5, 10), CHERO, B: LINE (4, 2)-(6, 3), CHERO, B
LINE (3, 4)-(3, 5), CHERO, B: LINE (7, 4)-(7, 5), CHERO, B
GET (0, 0)-(10, 10), HERON

PUT (0, 0), VOID, AND

LINE (5, 0)-(5, 10), CHERO, B: LINE (4, 7)-(6, 8), CHERO, B
LINE (3, 5)-(3, 6), CHERO, B: LINE (7, 5)-(7, 6), CHERO, B
GET (0, 0)-(10, 10), HEROS
PUT (0, 0), VOID, AND

LINE (0, 5)-(10, 5), CHERO, B: LINE (2, 4)-(3, 6), CHERO, B
LINE (4, 3)-(5, 3), CHERO, B: LINE (4, 7)-(5, 7), CHERO, B
GET (0, 0)-(10, 10), HEROW
PUT (0, 0), VOID, AND

LINE (0, 5)-(10, 5), CHERO, B: LINE (7, 4)-(8, 6), CHERO, B
LINE (5, 3)-(6, 3), CHERO, B: LINE (5, 7)-(6, 7), CHERO, B
GET (0, 0)-(10, 10), HEROE
PUT (0, 0), VOID, AND

DIM SLOT(200)
LINE (4, 4)-(6, 6), CSLOT, B
GET (0, 0)-(10, 10), SLOT

DIM WOOD(200)
LINE (0, 0)-(9, 9), 53, BF
LINE (1, 1)-(10, 10), 55, B
LINE (1, 1)-(9, 9), 54, BF
PSET (0, 10), 54
PSET (10, 0), 54
PSET (10, 10), 32
PSET (0, 0), 52
GET (0, 0)-(10, 10), WOOD

PUT (0, 0), VOID, AND

DIM PACK(200)
LINE (1, 1)-(9, 9), CPACK2, BF
LINE (1, 0)-(3, 0), CPACK1, BF
LINE (7, 0)-(9, 0), CPACK1, BF
LINE (0, 1)-(0, 3), CPACK1, BF
LINE (0, 7)-(0, 9), CPACK1, BF
LINE (1, 10)-(3, 10), CPACK3, BF
LINE (7, 10)-(9, 10), CPACK3, BF
LINE (10, 1)-(10, 3), CPACK3, BF
LINE (10, 7)-(10, 9), CPACK3, BF
LINE (3, 3)-(7, 7), CPACK3, B
LINE (4, 4)-(7, 7), CPACK1, B
LINE (4, 4)-(6, 6), 0, BF
PSET (7, 7), CPACK4
PSET (1, 1), CPACK4
GET (0, 0)-(10, 10), PACK

PUT (0, 0), VOID, AND

DIM IRON(200)
LINE (0, 0)-(9, 9), 53, BF
LINE (1, 1)-(10, 10), 55, B
LINE (1, 1)-(9, 9), 54, BF
PSET (0, 10), 54
PSET (10, 0), 54
PSET (10, 10), 32
PSET (0, 0), 52
PSET (2, 2), 55
PSET (8, 8), 55
PSET (2, 8), 55
PSET (8, 2), 55
GET (0, 0)-(10, 10), IRON

REM NOW THE GFX ELEMENTS ARE STORED IN MEMORY
REM WE CAN START TO PLAY

CLS

REM GOSUB WELCOMESCREEN

LEVEL = 1: GOSUB RESTART

DO: REM MAIN LOOP

REM "COMPLETED" COUNTS THE NUMBER OF FILLED SLOTS
REM WHILE "NUMBEROFSLOTS" IS TAKEN FROM THE CAVE DATA ARRAY
REM DURING "DRAWTHECAVE" PROCEDURE

IF COMPLETED = NUMBEROFSLOTS THEN LEVEL = LEVEL + 1: GOSUB HAPPYEND: GOSUB RESTART

DO: Q$ = INKEY$
        IF Q$ = CHR$(0) + "H" THEN GOSUB MOVEN: EXIT DO
        IF Q$ = CHR$(0) + "K" THEN GOSUB MOVEW: EXIT DO
        IF Q$ = CHR$(0) + "P" THEN GOSUB MOVES: EXIT DO
        IF Q$ = CHR$(0) + "M" THEN GOSUB MOVEE: EXIT DO

        IF Q$ = CHR$(32) THEN GOSUB RESTART
        IF Q$ = CHR$(27) THEN CLS : END
        LOOP

        IF POINT(HX + 4, HY + 4) = CSLOT THEN SF1 = 1: SX = HX: SY = HY

        REM UPDATE THE BOTTOM MENU WITH STATS...
        GOSUB MENU

        LOOP

REM FOUR PROCEDURES FOR MOVE IN N, W, S AND E DIRECTION

MOVEN:
IF DIRECTIONN = 0 THEN
        DIRECTIONN = 1
        DIRECTIONW = 0
        DIRECTIONS = 0
        DIRECTIONE = 0

        LINE (HX, HY)-(HX + 10, HY + 10), 0, BF
        PUT (HX, HY), HERON
ELSE
        IF POINT(HX, HY - 11) = 52 THEN
                REM CANNOT MOVE
                IF POINT(HX + 4, HY + 4) = CSLOT THEN SF3 = 1: REM PROBLEM HERE!
                ELSE
                REM CPACK4 COLOURS THE POINT [1, 1] / RELATIVE...
                IF POINT(HX + 1, HY - 10) = CPACK4 THEN
                IF POINT(HX, HY - 22) = 52 OR POINT(HX + 1, HY - 21) = CPACK4 THEN
                        REM PACK IS BLOCKED
                        IF POINT(HX + 4, HY + 4) = CSLOT THEN PUT (HX, HY), SLOT, XOR
                        ELSE
                        REM PACK IS MOVING
                        PUT (HX, HY), VOID, AND
                        HY = HY - 11
                        IF POINT(HX + 4, HY + 4) = CSLOT THEN SF2 = 1
                        PUT (HX, HY), VOID, AND
                        IF SF2 = 1 THEN PUT (HX, HY), SLOT, OR: SF2 = 0
                        PUT (HX, HY), HERON
                        PUT (HX, HY - 11), PACK
                        IF SF1 = 1 THEN PUT (SX, SY), SLOT, AND
                        GOSUB CHECKSLOTS
                        END IF
                ELSE
                PUT (HX, HY), VOID, AND
                HY = HY - 11
                PUT (HX, HY), HERON
                END IF
                END IF

END IF
IF SF1 = 1 THEN PUT (SX, SY), SLOT: SF1 = 0
IF SF3 = 1 THEN PUT (HX, HY), SLOT: SF3 = 0
RETURN

MOVEW:
IF DIRECTIONW = 0 THEN
        DIRECTIONN = 0
        DIRECTIONW = 1
        DIRECTIONS = 0
        DIRECTIONE = 0
        LINE (HX, HY)-(HX + 10, HY + 10), 0, BF
        PUT (HX, HY), HEROW
ELSE
        IF POINT(HX - 11, HY) = 52 THEN
                IF POINT(HX + 4, HY + 4) = CSLOT THEN SF3 = 1
                ELSE
                IF POINT(HX - 10, HY + 1) = CPACK4 THEN
                IF POINT(HX - 22, HY) = 52 OR POINT(HX - 21, HY + 1) = CPACK4 THEN
                        IF POINT(HX + 4, HY + 4) = CSLOT THEN PUT (HX, HY), SLOT, XOR
                        ELSE
                        PUT (HX, HY), VOID, AND
                        HX = HX - 11
                        IF POINT(HX + 4, HY + 4) = CSLOT THEN SF2 = 1
                        PUT (HX, HY), VOID, AND
                        IF SF2 = 1 THEN PUT (HX, HY), SLOT, OR: SF2 = 0
                        PUT (HX, HY), HEROW
                        PUT (HX - 11, HY), PACK
                        GOSUB CHECKSLOTS
                        END IF
                ELSE
                PUT (HX, HY), VOID, AND
                HX = HX - 11
                PUT (HX, HY), HEROW
                END IF
                END IF
END IF
IF SF1 = 1 THEN PUT (SX, SY), SLOT: SF1 = 0
IF SF3 = 1 THEN PUT (HX, HY), SLOT: SF3 = 0
RETURN

MOVES:
IF DIRECTIONS = 0 THEN
        DIRECTIONN = 0
        DIRECTIONW = 0
        DIRECTIONS = 1
        DIRECTIONE = 0
        LINE (HX, HY)-(HX + 10, HY + 10), 0, BF
        PUT (HX, HY), HEROS
ELSE
        IF POINT(HX, HY + 11) = 52 THEN
                IF POINT(HX + 4, HY + 4) = CSLOT THEN SF3 = 1
                ELSE
                IF POINT(HX + 1, HY + 12) = CPACK4 THEN
                IF POINT(HX, HY + 22) = 52 OR POINT(HX + 1, HY + 23) = CPACK4 THEN
                        IF POINT(HX + 4, HY + 4) = CSLOT THEN PUT (HX, HY), SLOT, XOR
                        ELSE
                        PUT (HX, HY), VOID, AND
                        HY = HY + 11
                        IF POINT(HX + 4, HY + 4) = CSLOT THEN SF2 = 1
                        PUT (HX, HY), VOID, AND
                        IF SF2 = 1 THEN PUT (HX, HY), SLOT, OR: SF2 = 0
                        PUT (HX, HY), HEROS
                        PUT (HX, HY + 11), PACK
                        GOSUB CHECKSLOTS
                        END IF
                ELSE
                PUT (HX, HY), VOID, AND
                HY = HY + 11
                PUT (HX, HY), HEROS
                END IF
                END IF

END IF
IF SF1 = 1 THEN PUT (SX, SY), SLOT: SF1 = 0
IF SF3 = 1 THEN PUT (HX, HY), SLOT: SF3 = 0
RETURN

MOVEE:
IF DIRECTIONE = 0 THEN
        DIRECTIONN = 0
        DIRECTIONW = 0
        DIRECTIONS = 0
        DIRECTIONE = 1
        LINE (HX, HY)-(HX + 10, HY + 10), 0, BF
        PUT (HX, HY), HEROE
ELSE
        IF POINT(HX + 11, HY) = 52 THEN
                IF POINT(HX + 4, HY + 4) = CSLOT THEN SF3 = 1
                ELSE
                IF POINT(HX + 12, HY + 1) = CPACK4 THEN
                IF POINT(HX + 22, HY) = 52 OR POINT(HX + 23, HY + 1) = CPACK4 THEN
                        IF POINT(HX + 4, HY + 4) = CSLOT THEN PUT (HX, HY), SLOT, XOR
                        ELSE
                        PUT (HX, HY), VOID, AND
                        HX = HX + 11
                        IF POINT(HX + 4, HY + 4) = CSLOT THEN SF2 = 1
                        PUT (HX, HY), VOID, AND
                        IF SF2 = 1 THEN PUT (HX, HY), SLOT, OR: SF2 = 0
                        PUT (HX, HY), HEROE
                        PUT (HX + 11, HY), PACK
                        GOSUB CHECKSLOTS
                        END IF
                ELSE
                PUT (HX, HY), VOID, AND
                HX = HX + 11
                PUT (HX, HY), HEROE
                END IF
                END IF
END IF
IF SF1 = 1 THEN PUT (SX, SY), SLOT: SF1 = 0
IF SF3 = 1 THEN PUT (HX, HY), SLOT: SF3 = 0
RETURN

RESTART:
CLS
SF1 = 0: REM RESET SLOT FLAGS
SF2 = 0
'REM DRAW THE FRAME AROUND THE CAVE
'FOR K = 0 TO 27: PUT (K * 11, 0), SLOT: PUT (K * 11, 15 * 11), IRON: NEXT
'FOR K = 1 TO 14: PUT (0, K * 11), IRON: PUT (27 * 11, K * 11), IRON: NEXT
DIRECTIONN = 0: REM RESET DIRECTION FLAGS
DIRECTIONW = 0
DIRECTIONS = 0
DIRECTIONE = 0
COMPLETED = 0: REM AND RESET LEVEL VARIABLES
NUMBEROFSLOTS = 0
MOVES = 0

REM HERE GO THE LEVEL LABELS
ON LEVEL GOSUB LEVEL01, LEVEL02, LEVEL03
RETURN

REM AND HERE GO THE LEVEL DATA
LEVEL01: LEVEL = 1
DATA "WARM UP"
DATA 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
DATA 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1
DATA 1,0,0,0,0,0,0,0,0,0,0,3,3,3,0,0,1,1,1,1,1,1,1,1,1,1
DATA 1,0,0,0,0,0,0,0,0,0,0,4,4,4,0,0,1,1,1,1,1,1,1,1,1,1
DATA 1,0,0,0,2,0,0,0,0,0,3,4,0,4,3,0,1,1,1,1,1,1,1,1,1,1
DATA 1,0,0,0,0,0,0,0,0,0,0,4,4,4,0,0,1,1,1,1,1,1,1,1,1,1
DATA 1,0,0,0,0,0,0,0,0,0,0,3,3,3,0,0,1,1,1,1,1,1,1,1,1,1
DATA 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1
DATA 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
DATA 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
DATA 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
DATA 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
DATA 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
DATA 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
RESTORE LEVEL01: GOSUB DRAWTHECAVE: RETURN

LEVEL02: LEVEL = 2
DATA "CLASSIC SOKOBAN"
DATA 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
DATA 1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,2,0,1,1,1,1,1,1,1,1,1
DATA 1,1,1,1,1,1,1,0,0,5,0,5,0,5,3,3,3,3,0,0,1,1,1,1,1,1
DATA 1,1,1,1,0,0,0,3,0,3,4,4,4,0,0,0,0,0,0,0,1,1,1,1,1,1
DATA 1,1,1,1,0,0,0,1,0,5,4,3,4,5,1,1,1,1,1,1,1,1,0,0,1,1
DATA 1,1,1,1,0,3,3,0,3,0,4,4,4,4,4,3,0,3,0,0,0,0,3,0,1,1
DATA 1,1,1,1,0,0,0,1,0,5,0,5,4,5,4,5,0,5,3,0,3,0,3,0,1,1
DATA 1,1,1,1,1,1,1,1,0,0,0,1,4,4,4,4,4,0,0,0,1,0,0,0,0,1
DATA 1,1,1,1,1,1,1,1,1,1,1,1,3,5,4,3,4,5,1,1,1,3,0,1,0,1
DATA 1,1,1,1,1,1,1,1,1,1,1,0,0,0,4,4,4,3,0,0,0,0,0,0,0,1
DATA 1,1,1,1,1,1,1,1,1,1,1,0,3,5,0,5,0,5,3,1,1,1,1,1,1,1
DATA 1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,0,0,0,1,1,1,1,1,1,1
DATA 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
DATA 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
RESTORE LEVEL02: GOSUB DRAWTHECAVE: RETURN

LEVEL03: LEVEL = 3
DATA "CLASSIC SOKOBAN"
DATA 0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0
DATA 1,1,1,1,1,0,0,1,0,0,0,0,0,3,0,3,0,1,0,0,0,0,0,0,0,0
DATA 1,0,0,0,1,1,1,1,1,0,3,1,1,0,1,0,1,1,0,0,0,0,0,0,0,0
DATA 1,0,3,0,1,1,0,0,0,1,0,1,1,0,3,0,0,1,0,0,0,0,0,0,0,0
DATA 1,0,3,0,0,2,3,3,0,1,0,1,1,3,3,3,0,1,0,0,0,0,0,0,0,0
DATA 1,1,0,1,1,1,0,0,0,1,0,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0
DATA 0,1,0,1,0,0,0,1,1,1,0,1,1,1,1,1,3,1,0,0,0,0,0,0,0,0
DATA 1,1,0,1,0,0,0,0,0,3,0,0,1,4,4,4,4,1,0,0,0,0,0,0,0,0
DATA 1,0,0,1,1,1,0,1,1,0,3,0,1,4,4,4,4,1,1,0,0,0,0,0,0,0
DATA 1,0,3,0,0,0,3,0,1,0,0,0,1,4,4,3,4,0,1,0,0,0,0,0,0,0
DATA 1,0,0,1,1,0,3,0,1,0,0,1,1,4,4,4,4,0,1,0,0,0,0,0,0,0
DATA 1,1,1,1,1,0,0,0,1,1,1,1,1,1,4,4,4,1,1,0,0,0,0,0,0,0
DATA 0,0,0,0,1,1,1,1,1,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0
RESTORE LEVEL03: GOSUB DRAWTHECAVE: RETURN

DRAWTHECAVE:
REM 0 = VOID
REM 1 = IRON
REM 2 = HERO
REM 3 = PACK
REM 4 = SLOT
REM 5 = WOOD

READ CAVENAME$
KX = 0
KY = 0
FOR K = 0 TO CAVEX * CAVEY - 1
        IF K MOD CAVEX = 0 THEN KX = 0: KY = KY + 11
        KX = KX + 11
        READ ELEMENT
        SELECT CASE ELEMENT
               CASE 0: PUT (KX, KY), VOID
               CASE 1: PUT (KX, KY), IRON
               CASE 2: PUT (KX, KY), HERON: HX = KX: HY = KY
               CASE 3: PUT (KX, KY), PACK
               CASE 4: PUT (KX, KY), SLOT: NUMBEROFSLOTS = NUMBEROFSLOTS + 1
               CASE 5: PUT (KX, KY), WOOD
        END SELECT
        NEXT

REM UPDATE BOTTOM MENU AND SET THE HERO TO INITIAL POSITION (LOOKING NORTH)
GOSUB MENU
GOSUB MOVEN
RETURN

REM CHECK HOW MANY PACKS ARE IN POSITION
REM AND IF COMPLETED = NUMBEROFSLOTS THEN LEVEL IS COMPLETED
CHECKSLOTS:
COMPLETED = 0
FOR KX = 0 TO CAVEX - 1
FOR KY = 0 TO CAVEY - 1
        IF POINT(KX * 11 + 4, KY * 11 + 4) = CSLOT AND POINT(KX * 11 + 1, KY * 11 + 1) = CPACK4 THEN COMPLETED = COMPLETED + 1
        NEXT: NEXT

REM ALSO UPDATE THE PACKAGE MOVES
MOVES = MOVES + 1
RETURN

REM DRAW THE MENU BELOW THE CAVE
MENU:
COLOR 2
LOCATE 22, 3: PRINT "LABEL: "; : PRINT CAVENAME$
COLOR 15
LOCATE 23, 3: PRINT "LEVEL:"; LEVEL; "SLOTS:"; NUMBEROFSLOTS; "/"; COMPLETED;
PRINT "MOVES:"; MOVES

RETURN

HAPPYEND:
FOR KX = 1 TO CAVEX
FOR KY = 1 TO CAVEY
        IF POINT(KX * 11 + 4, KY * 11 + 4) = CSLOT THEN
                X = KX * 11 + 5
                Y = KY * 11 + 5
                LINE (X - 5, Y - 5)-(X + 5, Y + 5), 0, BF
                GOSUB MAKESOUND
                PSET (X, Y): GOSUB MAKESOUND: PSET (X - 1, Y): PSET (X + 1, Y): PSET (X, Y - 1): PSET (X, Y + 1)
                GOSUB MAKESOUND: PSET (X, Y), 0: PSET (X - 2, Y): PSET (X + 2, Y): PSET (X, Y - 2): PSET (X, Y + 2)
                GOSUB MAKESOUND: PSET (X - 1, Y), 0: PSET (X + 1, Y), 0: PSET (X, Y - 1), 0: PSET (X, Y + 1), 0
                GOSUB MAKESOUND: PSET (X - 2, Y), 0: PSET (X + 2, Y), 0: PSET (X, Y - 2), 0: PSET (X, Y + 2), 0
                END IF
        NEXT
        NEXT
RETURN

MAKESOUND:
SOUND 7000 + RND * 10000, 1
RETURN

