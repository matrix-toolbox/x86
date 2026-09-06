; 2009-03-11
; 2009-03-26
; wojciech bruzda @ IFUJ
;
; Contents:
;
;    - RESET
;    - STACK
;    - GATE operation
;    - jump and return from subroutine (RET vs. RJMP)
;    - DELAY
;    - static ARRAY in the code segment
;    - pointers to different arrays
;    - dynamical variable in the data segment
;    - SEGMENT display handling
;----------------------------------------------------------------------------
.INCLUDE "M8535DEF.INC"
.INCLUDE "A8536.INC"

.DEF TABLE_SIZE = R25          ; array size
.DSEG                          ; data segment for (FLASH) variables
    OFFSET_T1: .BYTE 2         ; reserve two-byte VARIABLES
    OFFSET_T2: .BYTE 2
.CSEG
.ORG 0X0000                    ; IRQ TABLE START
    RJMP RESET                 ; overload the 1st IRQ
.ORG INT_VECTORS_SIZE          ; IRQ END
;----------------------------------------------------------------------------
RESET:
    STACK_INIT RAMEND
;----------------------------------------------------------------------------
    LDI R20, 0XFF
    OUT DDRC, R20              ; PORTC (SEGMENT) set for output
INIT:
    RCALL LOAD_TABLES
DISPLAY_TABLE:
    LDS R30:R31, OFFSET_T1     ; pointer to TABLE_1
    LPM R20, Z+                ; load and shift the value
    OUT PORTC, R20             ; light the segment

    WAIT 0XFF

    LDS R30:R31, OFFSET_T2     ; the same for TABLE_2
    LPM R20, Z+
    OUT PORTC, R20

    WAIT 0XFF                  ; hold on a moment

    LDS R30:R31, OFFSET_T1     ; shift the OFFSET_T1 by one
    INC R30:R31                ;
    STS OFFSET_T1, R30:R31     ; (update)

    LDS R30:R31, OFFSET_T2     ; ... OFFSET_T2
    INC R30:R31
    STS OFFSET_T2, R30:R31

    DEC TABLE_SIZE             ; "count" the array elements
    BRNE DISPLAY_TABLE         ; show in turns: TABLE_1 and _2
    RJMP INIT

;----------------------------------------------------------------------------
;     1:     0           2           4           6           8
;     2:     1           3           5           7           9
TABLE_1: .DB 0B11000000, 0B10100100, 0B10011001, 0B10000010, 0B10000000
TABLE_2: .DB 0B11111001, 0B10110000, 0B10010010, 0B11111000, 0B10010000
;----------------------------------------------------------------------------

LOAD_TABLES:
    LDI ZL, LOW(TABLE_1 << 1)
    LDI ZH, HIGH(TABLE_1 << 1) ; pointer to TABLE_1
    STS OFFSET_T1, R30:R31     ; remember it as OFFSET_T1

    LDI ZL, LOW(TABLE_2 << 1)  ; ... TABLE_2
    LDI ZH, HIGH(TABLE_2 << 1)
    STS OFFSET_T2, R30:R31

    LDI TABLE_SIZE, 0X05       ; size of the array is set "manually"
    RET                        ; go back
;----------------------------------------------------------------------------
