; WOJTEK[AT]BITOLOGIA.ORG
;
; ----------------
; - REQUIRES NPU -
; ----------------
;
; 2020-08-16 QBASIC-CODE ADAPTATION -- DRAWS STILL IMAGE
; 2020-08-21 CODE MERGED WITH CIRCLE.ASM AND UNEXPECTEDLY "SIMPLIFIED"
;            NOW JULIA MOVES AROUND
; 2020-08-22 NPU OPTIMIZATION

.MODEL TINY
.486                          ; TESTED ON Cy486DX2-66 AND DOSBOX
;.286                         ; TESTED ON i286...
;.287
.CODE
        ORG 100H
START:
        PUSH CS
        POP DS
        MOV AX, 0013H         ; VGA MODE 320x200x256
        INT 10H
        MOV AX, 0A000H        ; VGA ADDRESS AREA
        MOV ES, AX
MAIN:   MOV CX, 2048          ; NUMBER OF POINTS IN THE CLOUD
NEXT_J: FINIT
        CALL GET_PRND         ; --> [RANDOM]
        JMP L4
L3:     JMP NEXT_J            ; TODO: THIS SHIT MUST BE REMOVED!!!
L4:     FLD XN
        FSUB XC               ; A = XN - XC
        FST A
        FLD YN
        FSUB YC               ; B = YN - YC
        FST B
;       FOR SOME REASON ONLY ONE BRANCH IS REQUIRED :O
;       YN = SGN(B) * SQR((SQR(A * A + B * B) - A) / 2)
;       XN = C / YN
        FLD A
        FMUL ST, ST
        FLD B
        FMUL ST, ST
        FADD                  ; ST <-- ST + ST(1)
        FSQRT
        FLD A
        FCHS
        FADD
        FDIV CONST2
        FSQRT
        FLD B                 ; EXAMINE SGN(B)
        FTST
        WAIT         ; <-- THIS IS TO BE CHECKED
                     ; WHEN UNASSEMBLING WITH DEBUG.EXE
                     ; ONE CAN FIND DOUBLE WAITS ALONG WITH ESC
                     ; ALLEGEDLY ADDED AUTOMATICALY DURING COMPILATION
                     ; BUT SURELY IT MUST BE HANDLED EXPLICITLY WHEN
                     ; WORKING ON 80286/7
        PUSH AX
        FSTSW AX
        FWAIT
        FXCH                  ; SQRT -> ST(0)
        AND AH, 1
        CMP AH, 0
        JE PLUS
        FCHS
PLUS:   POP AX
        FST YN
        FWAIT
        FINIT                 ; ?
        FLD B
        FDIV CONST2
        FDIV YN               ; ST(0), ST(1)
        FST XN
        FWAIT
        JMP SHORT L2
L1:     JMP L3
L2:     CMP [RND], 0          ; TODO: THIS SHIT MUST BE REMOVED!!!
        JE DRAW
        FLD XN
        FCHS
        FST XN
        FWAIT
        FLD YN
        FCHS
        FST YN
        FWAIT
DRAW:   FLD XN
        FMUL XS
        FADD XT
        FRNDINT
        FIST XP
        FLD YN
        FMUL YS
        FADD YT
        FRNDINT
        FIST YP
        MOV AX, YP
        MOV BX, XP
        MOV DX, 320
        MUL DX
        ADD AX, BX
        MOV DL, CS:[RND] + 1  ; READ SHIT TO GET EVEN BETTER RANDOM
        MOV DI, AX
        MOV ES:[DI], DL
        LOOP L1
;----------------------------------------------------------------------------
        PUSH CX               ; CX HOLDS THE NUMBER OF POINTS
        XOR AX, AX
        MOV CX, 32000
        XOR DI, DI
        REP STOSW             ; CLEAR SCREEN
        POP CX
;----------------------------------------------------------------------------
        FLD ALPHA
        FADD ST, ST
        FLDPI
        FMUL ST, ST(1)        ; ST(0) = ALPHA * 2 * PI
        FSINCOS               ; ST(0) = COS(DA), ST(1) = SIN(DA)
        FSTP XC
        FSTP YC
        FINIT                 ; RESET FPU
        FLD ALPHA
        FADD DELTA_ALPHA      ; TODO: ALPHA MUST BE MOD 2PI
        FST ALPHA             ; TODO: OTHERWISE IT WILL EVENTUALLY OVERFLOW!
        FWAIT
;----------------------------------------------------------------------------
        IN AL, 60H            ; RUN UNTIL ESC-PRESSED
        CMP AL, 1
        JE ESC_
        JMP MAIN
ESC_:   MOV AX, 0003H         ; RESTORE TEXT MODE
        INT 10H
        MOV AH, 4CH
        INT 21H
        RET
;----------------------------------------------------------------------------
GET_PRND PROC NEAR
        PUSH CX
        MOV BX, [RND_SEED]
        ADD BX, 9248H
        MOV CL, 3
        ROR BX, CL
        MOV [RND_SEED], BX
        MOV AH, 02H
        INT 1AH
        OR AL, DH             ; MIX WITH TIMER TO GET BETTER RANDOMNESS
        OR AX, BX
        XOR DX, DX
        MOV BX, 3
        DIV BX                ; MOD CX
        MOV [RND], DL         ; SAVE PSEUDO-RANDOM 8-BIT INTEGER
        POP CX
        RETN
ENDP
;----------------------------------------------------------------------------
DELTA_ALPHA DQ 0.0078125      ; DA = 1/128
ALPHA DQ 0.0

XP DW 160
YP DW 100
XS DQ 90.0                    ; SCALING
YS DQ 60.0
XT DQ 160.0                   ; TRANSLATION
YT DQ 100.0

XC DQ 1.0
YC DQ 0.0
XN DQ 0.0
YN DQ 0.0
A DQ ?
B DQ ?
CONST2 DQ 2.0

RND DB ?
RND_SEED DW 1111H

END START
