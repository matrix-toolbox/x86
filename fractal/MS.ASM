; WOJTEK[AT]BITOLOGIA.ORG
;
; 2020-08-08 IT IS "VISIBLE" BUT IN 013H MODE FOR A MOMENT
; 2020-08-10 PORTS AND BIT-PLANES FINALLY UNDERSTOOD
;     https://wiki.osdev.org/VGA_Hardware
;
; ONE CAN EASILY SEE THAT INTEGER ARITHMETIC
; MAKES SOME FRAGMENTS OF THE SET SLIGHTLY DEFORMED, HOWEVER...
;
; 2020-08-15 EXE TO COM AND MODEL TINY
;
; SEE MS.BAS

.MODEL TINY
.CODE
        ORG 100H
PUT_PIXEL MACRO PX, PY
        MOV AX, 0A000H
        MOV ES, AX

        MOV AX, 0305H     ; MODE 3, INDEX 5 --> VGA SPEC.
        MOV DX, 03CEH
        OUT DX, AX

        MOV AH, BYTE PTR CS:[ITER]
        INC AH
        MOV AL, 0
        MOV DX, 03CEH
        OUT DX, AX

        ; L := LINEAR_INDEX = PY*80 + PX\8 : "TRUNCATE" TO AVOID OVERFLOWS
        ; => DI = L \ 8
        ;    BYTE_OFFSET = 7 - (L % 8)

        MOV AX, PY
        MOV CX, 80D
        MUL CX            ; AX = PY * 80
        MOV BX, AX

        MOV AX, PX
        MOV CL, 3
        SHR AX, CL        ; AX = PX \ 8
        ADD BX, AX        ; BX = PY * 80 + (PX \ 8)
        PUSH BX

        XOR DX, DX
        MOV AX, PX
        MOV CX, 8
        DIV CX            ; AX=AX\8   DX=AX%8

        SUB CL, DL        ; %
        DEC CL
        MOV BL, 1
        SHL BL, CL        ; AX = 7 - (L % 8)

        POP DI
        MOV AL, ES:DI     ; L[O]DS/STOSB
        OR AL, BL
        MOV ES:DI, BL
ENDM
START:
        MOV AX, CS
        MOV DS, AX
        MOV AX, 0012H
        INT 10H
        CLI
        PUSH DI
        PUSH SI
        XOR DI, DI        ; Y
        XOR SI, SI        ; X
MAIN_LOOP:
        INC DI
        CMP DI, 400D
        JNE PREPARE_DATA
        XOR DI, DI
        INC SI
        CMP SI, 400D
        JNE PREPARE_DATA
WAIT_FOR_ESC:
        IN AL, 60H        ; RUN UNTIL ESC-PRESSED
        CMP AL, 1
        JNE WAIT_FOR_ESC
        POP SI
        POP DI
        STI
        MOV AX, 0003H
        INT 10H
        MOV AH, 4CH
        INT 21H
PREPARE_DATA:
        MOV AX, SI
        SUB AX, 200D
        MOV CS:[REO], AX  ; REO = X - 200
        MOV AX, DI
        SUB AX, 200D
        MOV CS:[IMO], AX  ; IMO = Y - 200
        XOR CX, CX
        MOV CS:[ITER], CX
ITERATE:
        MOV CX, CS:[REO]
        MOV AX, CX
        IMUL CX
        MOV CX, 100D
        DIV CX
        MOV CS:[RES], AX  ; RES = REO * REO \ 100
        MOV CX, CS:[IMO]
        MOV AX, CX
        IMUL CX
        MOV CX, 100D
        DIV CX
        MOV CS:[IMS], AX  ; IMS = IMO * IMO \ 100
        JMP L04
L05:    JMP MAIN_LOOP
L04:    MOV CX, CS:[RES]
        ADD AX, CX        ; RES + IMS
        CMP AX, 400D
        JG DRAW

        MOV AX, CS:[RES]
        MOV CX, CS:[IMS]
        SUB AX, CX
        MOV CS:[REN], AX  ; REN = RES - IMS

        MOV DX, CS:[REO]
        PUSH DX

        ADD AX, SI
        SUB AX, 200D
        MOV CS:[REO], AX  ; REO = REN + X - 200
        JMP L02
L03:    JMP ITERATE
L02:    POP AX            ; RESTORE "PREVIOUS" REO
        MOV CX, CS:[IMO]
        IMUL CX           ; CHECK IF DX SHOULD BE ZEROED!
        MOV CX, 100D
        IDIV CX
        SHL AX, 1
        MOV CS:[IMN], AX  ; IMN = 2 * REO * IMO \ 100

        ADD AX, DI
        SUB AX, 200D
        MOV CS:[IMO], AX  ; IMO = IMN + Y - 200

        MOV CX, CS:[ITER]
        CMP CX, 32
        JE L05            ; MAIN_LOOP
        INC CX
        MOV CS:[ITER], CX
        JMP L03           ; JMP ITERATE
DRAW:   PUSH DI           ; SAVE Y
        PUT_PIXEL SI, DI  ; TODO: REPLACE THIS SHIT WITH PROCEDURE
        POP DI
        JMP MAIN_LOOP

REO DW ?
IMO DW ?
REN DW ?
IMN DW ?
RES DW ?
IMS DW ?
ITER DW ?

END START
