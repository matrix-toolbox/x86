; wojtek[at]bitologia.org

; 2012-11-02 FASM VERSION
;
; 2020-07-29 IFSP: SIERPINSKI TRIANGLE AS A STOCHASTIC PROCESS
; 2020-07-31 PRNG IMPROVED #1 - GET DATA FROM TIMER (LOUSY)
; 2020-08-02 CLEAN CODE
; 2020-08-06 PRNG IMPROVED #2 - GET DATA FROM RAM
;            AS A SIDE EFFECT, TRY TO PRESS DIFFERENT KEYS
;            WHEN RUNNING TO GET "CHAOTIC" COLOR PATTERNS :)
; 2020-08-15 EXE TO COM AND MODEL TINY
;            ESC = EXIT
;
; SEE ALSO ST.BAS

.MODEL TINY
.CODE
        ORG 100H
START:
        MOV AX, 0013H         ; VGA MODE 320x200x256
        INT 10H
        CLI
MAIN:   CALL GET_RANDOM
        MOV BX, C_X
        MOV AX, C_Y
        MOV DL, RANDOM
        SHR BX, 1             ; X = X / 2
        SHR AX, 1             ; Y = Y / 2
        CMP DL, 0             ; DL=0D=00B ==> 0*320 0*200
        JE S0                 ; DL=1D=01B ==> 0*320 1*200
        CMP DL, 1             ; DL=2D=10B ==> 1*320 0*200
        JE Y100
X160:   ADD BX, 160D
Y100:   ADD AX, 100D
S0:     MOV [C_X], BX
        MOV [C_Y], AX
        CALL PUT_PIXEL
        IN AL, 60H            ; RUN UNTIL ESC-PRESSED
        CMP AL, 1
        JNE MAIN
        STI
        MOV AX, 0003H         ; RESTORE TEXT MODE
        INT 10H
        MOV AH, 4CH           ; TERMINATE
        INT 21H
        RET
ENDP

PUT_PIXEL PROC
        MOV CX, 0A000H        ; VIDEO ADDRESS AREA
        MOV ES, CX
        MOV AX, C_Y
        MOV BX, C_X
        MOV CX, 320
        MUL CX
        ADD AX, BX
        MOV DL, COLOR         ; RANDOM
                              ; ADD DL, 2 ; MAKE COLOR NON-TRIVIAL
        MOV DI, AX
        MOV ES:[DI], DL
        RET
PUT_PIXEL ENDP

GET_RANDOM PROC
        MOV BX, CS:[RANDOM_SEED]
        ADD BX, 9248H
        MOV CL, 3D
        ROR BX, CL
        MOV CS:[RANDOM_SEED], BX
        OR AX, BX             ; MIX GARBAGE TO GET BETTER RANDOMNESS
        XOR DX, DX
        MOV CX, 3             ; CAST TO TRIPLET
        DIV CX                ; MOD CX
        MOV [RANDOM], DL      ; SAVE PSEUDO-RANDOM 8-BIT INTEGER
        MOV [COLOR], AL       ; RANDOM COLOR
        RET
GET_RANDOM ENDP

RANDOM DB ?
COLOR DB ?
RANDOM_SEED DW 1111H
C_X DW 0                      ; INITIAL POINT SET TO (0, 0)
C_Y DW 0

END START
