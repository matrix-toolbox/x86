REM WOJTEK[AT]BITOLOGIA.ORG
REM
REM 2020-08-29 BASED ON THE "NA" (EULER) CODE FROM 2005-05-27
REM            SEE ALSO LORENZ.ASM

REM OTHER FORGOTTEN YET INTERESTING REFERENCES:
REM  * KACPER NOWICKI IFUW 1989 - ANAGLYPH ALGORITHM
REM  * DELTA 4/1989
REM  * A. S. Kleczkowski "DETERMINISTIC CHAOS" 1987

H = 1 / 256                           ' STEP
XO = 0: YO = 1: ZO = 0                ' INITIAL VALUES
XT = 140: YT = 180: XS = 3: YS = -2.5 ' DISPLAY PARAMETERS
SIGMA = 10: R = 28: B = 8 / 3         ' LORENZ PARAMETERS

LL = 4096                             ' NUMBER OF POINTS IN CHAIN
DIM LORENZX(LL) AS DOUBLE
DIM LORENZY(LL) AS DOUBLE

J = 0
SCREEN 13
DO:     XN = XO + H * SIGMA * (YO - XO)
        YN = YO + H * (R * XO - YO - XO * ZO)
        ZN = ZO + H * (XO * YO - B * ZO)

        REM VISUALLY IT IS A BIT BETTER THAN XN = XN + H ...

        PSET (LORENZX(J), LORENZY(J)), 0
        LORENZX(J) = XT + XS * YN
        LORENZY(J) = YT + YS * (ZN + XN)
        PSET (LORENZX(J), LORENZY(J)), 1 + RND * 255
        J = (J + 1) MOD LL

        XO = XN
        YO = YN
        ZO = ZN

LOOP WHILE INKEY$ = ""





