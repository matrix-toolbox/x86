; wojtek[at]bitologia.org
; 2020-08-09 BASED ON LORENZ.BAS
; 2021-02-27 CORRECT VGA ADDRESSING
;
;          ----------------
;          - REQUIRES NPU -
;          ----------------

.MODEL TINY
.CODE
        ORG 100H
START:  PUSH CS
        POP DS
        MOV AX, 0013H   ; VGA MODE 320x200x256
        INT 10H
        MOV CX, 0A000H  ; VGA ADDRESS
        MOV ES, CX
MAIN:   FINIT
        FLD YN
        FSUB XN
        FMUL SIGMA
        FMUL H
        FADD XN
        FST XN          ; XN = XN + H * SIGMA * (YN - XN)
                        ; IT SHOULD BE RATHER:
                        ; XN = XO + H * SIGMA * (YO - XO)
                        ;
                        ; IT IS A LITTLE CHEAT, BECAUSE WE DO NOT USE
                        ; ADDITIONAL VARIABLES (*O) TO PASS
                        ; OLD-TO-NEW VALUES (TO *N)
                        ; -- SEE LORENZ.BAS HOW IT IS SOLVED THERE
        FLD R
        FSUB ZN
        FMUL XN
        FSUB YN
        FMUL H
        FADD YN
        FST YN          ; YN = YN + H * (R * XN - YN - XN * ZN)

        FLD ZN
        FMUL B
        FLD XN
        FMUL YN
        FSUB ST(0), ST(1)
        FMUL H
        FADD ZN
        FST ZN          ; ZN = ZN + H * (XN * YN - B * ZN)

        JMP L2
L1:     JMP MAIN
L2:     FLD YN
        FMUL XS
        FADD XT
        FRNDINT
        FIST CS:[XP]

        FLD XN
        FADD ZN
        FMUL YS
        FADD YT
        FRNDINT
        FIST CS:[YP]

        MOV AX, CS:[YP]
        MOV BX, CS:[XP] ; PSET (XT + XS * YN, YT + YS * (ZN + XN)), C
        MOV CX, 320
        MUL CX
        ADD AX, BX
        MOV DI, AX
        MOV ES:[DI], BYTE PTR 4
        MOV ES:[DI+1], BYTE PTR 0
        IN AL, 60H      ; RUN UNTIL ESC-PRESSED
        CMP AL, 1
        JNE L1
        MOV AX, 0003H   ; RESTORE TEXT MODE
        INT 10H
        MOV AH, 4CH     ; TERMINATE
        INT 21H

H       DQ 0.0009765625 ; = 1/1024

XN      DQ 0.0          ; INITIAL VALUES
YN      DQ 1.0
ZN      DQ 0.0

XP      DW ?            ; INTEGER COORDS TO BE PLOTTED
YP      DW ?

XT      DQ 140.0        ; SCALE AND TRANSLATION
YT      DQ 180.0
XS      DQ 3.0
YS      DQ -2.5

SIGMA   DQ 10.0         ; LORENZ CLASSIC PARAMETERS
R       DQ 28.0
B       DQ 2.66666666   ; 8/3

END START
