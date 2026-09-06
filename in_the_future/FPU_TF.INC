; (C) 1994 ...
;
; 2020-08-15 TRIG. FUNCTION MACROS FOR 80287 OR LESS
;            ST(0) <-- FTAN287(ST(0)) FOR 0 < ST(0) < PI_4 FOR 80287
;            ST(0) <-- FCOS287(ST(0)) FOR 0 < ST(0) < PI_4 FOR 80287

.286
.287
FTAN287 MACRO
        LOCAL T1, T2, T3, T4, T5, T6, PI_2, PI_4, LP
        MOV BH, 0
        FTST
        FJGE LP
        INC BH
LP:     FABS
        FLDPI
        FXCH ST(1)
        FPREM
        FXCH ST(1)
        FSTP ST(0)
        FLD TBYTE PTR CS:PI_2
        FCOMP ST(1)
        FJG T1
        FJE T6
        FLDPI
        FSUBRP ST(1), ST
        INC BH
T1:     FTST
        FJNE T2
T6:     FSTP ST(0)
        FLDZ
        JMP T3
T2:     FLD TBYTE PTR CS:PI_4
        FCOMP ST(1)
        FJG T5
        FLD TBYTE PTR CS:PI_2
        FSUBRP ST(1), ST
        FPTAN
        FXCH ST(1)
        JMP T4

PI_2 DB 00H, 80H, 2AH, 92H, 0A2H, 0DAH, 0FH, 0C9H, 0FFH, 3FH ; PI/2
PI_4 DB 00H, 70H, 2AH, 92H, 0A2H, 0DAH, 0FH, 0C9H, 0FEH, 3FH ; PI/4

T5:     FPTAN
T4:     FDIVP ST(1), ST
        AND BH, 1
        JZ T3
        FCHS
T3:     LABEL NEAR
        ENDM

FCOS287 MACRO
        LOCAL C1, C2, C3, C4, C5, C6, C7, C8, C9, PI_2, PI_4
        MOV BH, 0
        FABS
        FLDPI
        FADD ST, ST(0)
        FXCH ST(1)
        FPREM
        FXCH ST(1)
        FLDPI
        FCOM ST(1)
        FJGE C1
        INC BH
        FSUB ST(1), ST
C1:     FSTP ST(0)
        FLD TBYTE PTR CS:PI_2
        FCOMP ST(1)
        FJG C2
        FJNE C6
        FSTP ST(0)
        FLDZ
        JMP SHORT C4
C6:     FLDPI
        FSUBRP ST(1), ST
        INC BH
C2:     FTST
        FJNE C7
        FSTP ST(0)
        FLD1
        JMP SHORT C41
C7:     FLD TBYTE PTR CS:PI_4
        FCOMP ST(1)
        FJG C3
        FJNE C8
        FSTP ST(0)
        FLD1
        JMP SHORT C9
C8:     FLD TYTE PTR CS:PI_2
        FSUBRP ST(1), ST
        FPTAN
        PXCH ST(1)
        JMP SHORT C5

PI_2 DB 00H, 80H, 2AH, 92H, 0A2H, 0DAH, 0FH, 0C9H, 0FFH, 3FH ; PI/2
PI_4 DB 00H, 70H, 2AH, 92H, 0A2H, 0DAH, 0FH, 0C9H, 0FEH, 3FH ; PI/4

C3:     FPTAN
C5:     FDIVP ST(1), ST
C9:     FMUL ST, ST(0)
        FLD1
        FADD ST(1), ST
        FDIV ST, ST(1)
        FXCH ST(1)
        FSTP ST(0)
        FSQRT
C41:    AND BH, 1
        JZ SHORT C4
        FCHS
C4:     LABEL NEAR
        ENDM

FJE MACRO _JMP
        LOCAL STATUS, _NEXT
        FSTSW CS:STATUS
        FWAIT
        MOV AX, WORD PTR CS:STATUS
        TEST AX, 4000H
        JNZ _JMP
        JMP _NEXT
        STATUS DW 0
_NEXT:  LABEL NEAR
        ENDM

FJNE MACRO _JMP
        LOCAL STATUS, _NEXT
        FSTSW CS:STATUS
        FWAIT
        MOV AX, WORD PTR CS:STATUS
        TEST AX, 4000H
        JZ _JMP
        JMP _NEXT
        STATUS DW 0
_NEXT:  LABEL NEAR
        ENDM

FJG MACRO _JMP
        LOCAL STATUS, _NEXT
        FSTSW CS:STATUS
        FWAIT
        MOV AX, WORD PTR CS:STATUS
        TEST AX, 4100H
        JZ _JMP
        JMP _NEXT
        STATUS DW 0
_NEXT:  LABEL NEAR
        ENDM

FJL MACRO _JMP
        LOCAL STATUS, _NEXT
        FSTSW CS:STATUS
        FWAIT
        MOV AX, WORD PTR CS:STATUS
        AND AX, 4100H
        CMP AX, 100H
        JZ _JMP
        JMP _NEXT
        STATUS DW 0
_NEXT:  LABEL NEAR
        ENDM

FJGE MACRO _JMP
        LOCAL STATUS, _NEXT
        FSTSW CS:STATUS
        FWAIT
        MOV AX, WORD PTR CS:STATUS
        TEST AX, 100H
        JZ _JMP
        JMP _NEXT
        STATUS DW 0
_NEXT:  LABEL NEAR
        ENDM

