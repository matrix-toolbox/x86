; WOJTEK[AT]BITOLOGIA.ORG
;
; 2020-08-15 CIRCLE AND NPU
;            JUST A SNIPPET TO BE USED IN JS.ASM

.MODEL TINY
.486
.CODE
        ORG 100H
START:  MOV AX, 0013H     ; VGA MODE 320x200x256
        INT 10H
        MOV AX, 0A000H    ; VIDEO ADDRESS AREA
        MOV ES, AX

        MOV CX, 64        ; NUMBER OF POINTS

L0:     FINIT
        FLD ALPHA
        FADD ST, ST       ; FMUL CONST2
        FLDPI
        FMUL              ; ST(0) = ALPHA * 2 * PI
        FSINCOS           ; ST(0) = COS(DA), ST(1) = SIN(DA)
        FMUL X_SCALE
        FADD X_T
        FRNDINT
        FISTP XP          ; STORE XP = [COS(A) * XS + XT] ...
        FMUL Y_SCALE      ; ... AND BUMP FPU STACK BY ONE ...
        FADD Y_T          ; ... SO THAT ST(0) <-- SIN(DA)
        FRNDINT
        FISTP YP          ; YP = [SIN(A) * YS + YT]
        FWAIT

        PUSH CX           ; PUT_PIXEL
        MOV AX, YP
        MOV BX, XP
        MOV CX, 320
        MUL CX
        ADD AX, BX
        MOV DL, 3
        MOV DI, AX
        MOV ES:[DI], DL
        POP CX

        FLD ALPHA
        FADD DELTA_ALPHA  ; THIS CAN BE SIMPLIFIED!
        FST ALPHA         ; TO AVOID UNNECESSARY STORING OF ALPHA
        LOOP L0

WAIT_FOR_ESC:
        IN AL, 60H        ; RUN UNTIL ESC-PRESSED
        CMP AL, 1
        JNE WAIT_FOR_ESC

        MOV AX, 0003H     ; RESTORE TEXT MODE
        INT 10H
        MOV AH, 4CH
        INT 21H
        RET

DELTA_ALPHA DQ 0.015625; 0.0078125
ALPHA DQ 0.0
XP DW ?
YP DW ?
X_SCALE DQ 60.0
Y_SCALE DQ 60.0
X_T DQ 160.0
Y_T DQ 100.0
END START
