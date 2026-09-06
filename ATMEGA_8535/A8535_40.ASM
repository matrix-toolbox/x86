; 2009-03-19
; wojciech bruzda @ IFUJ
;
; When pressing a key, an appropriate symbol is shown on the segment display.
;
; The code shows the necessity of being flexible with respect to
; to the physics of the hardware: STROBE, NOP, etc.
;----------------------------------------------------------------------------
.INCLUDE "M8535DEF.INC" ; macros
.INCLUDE "A8536.INC"    ; custom macros

.EQU TABLE_SIZE = 32    ; static array size

.CSEG
.ORG 0x0000
    RJMP RESET
.ORG INT_VECTORS_SIZE   ; jump over the IRQs (see M8535DEF.INC)
;----------------------------------------------------------------------------
RESET:
    STACK_INIT RAMEND

    SER R20             ; set the direction (output) on the GATE C which
    OUT DDRC, R20       ; is a connection to the segment display
;----------------------------------------------------------------------------
READ_KEY:
    CLR R20             ; set zero on gate (loop counter) ~reset
    OUT PORTA, R20

GET_COLS:               ; set the directions of the first half ("out")...
    LDI R20, 0B11110000
                        ; ...of PORTA (the rest is set to "in"), then connect
    OUT DDRA, R20       ; LEDs with PORTA (actually PINA)
    OUT PORTA, R20

    IN R21, PINA        ; check the column in which the circuit is closed

;----------------------------------------------------------------------------
; WATCH OUT!
; gate and its pins are shifted in phase by at least one clock cycle
; that means:
; CLK --> "loading" PORTX --> CLK --> now it appears on PINX
;
; However, reading from PINX is "immediate"!
;----------------------------------------------------------------------------

    ANDI R21, 0B00001111
                        ; mask the second half of R21
    BREQ GET_COLS       ; at least one bit out of four (right ones) will be
                        ; set, if there was a key pressed
    LDI R20, 0B00001111
                        ; close the circuits (remember that R21
    OUT DDRA, R20       ; holds the info about columns...)

    OUT PORTA, R20      ; we are here, because a key was pressed, this means
                        ; the key was being held for some amount of time,
    NOP                 ; so we put NOPs for the processor to relax and
    NOP                 ; to (re)set the registers; if this happens too fast
                        ; the following instruction will read a mess from
                        ; another run

                        ; finally "quickly" check which row has been closed

    IN R23, PINA        ; rows are handled similar to columns
    ANDI R23, 0B11110000
                        ; masking a half...
                        ; surely some bit will be set, so it will jump
    BREQ READ_KEY       ; the loop is just in case of... lack of voltage :)

    OR R21, R23         ; R21 holds "coordinates" of the key that was
                        ; pressed in the form: R21 = rrrrcccc, for example:
                        ; R21=01001000=0100'+'1000 : 2nd row and 1st column

    RCALL LOAD_TABLE    ; first, take the pointer to the array containing
                        ; a string of bytes (alternate): BYTE_OF_COORD.. and
    READ_TABLE:         ; CODE_OF_SEGMENT_DIGIT

    LPM R29, Z+         ; increase pointer++

    CP R29, R21         ; check whether the NEXT array alement contains
                        ; the code of the key being pressed
    BREQ DISPLAY_SEG    ; if so - display the NEXT array alement
    DEC R16             ; R16 holds the size of the array: the counter that
                        ; tells us how far can we go using "Z"

    BRNE READ_TABLE     ; read until R16 != 0 - to the end of array or
                        ; untill the moment we find something matching R25

                        ; if we do not find anything, the segment displays
DISPLAY_SEG:            ; its last state

    LPM R29, Z+         ; we move on once more to get the byte of the
    OUT PORTC, R29      ; digit to be displayed on the segment

    RJMP READ_KEY       ; start the procedure anew
;----------------------------------------------------------------------------
LOAD_TABLE:
    LDI ZL, LOW(TABLE << 1)
                        ; load array address to the "Z" container
    LDI ZH, HIGH(TABLE << 1)
    LDI R16, TABLE_SIZE

    RET
;----------------------------------------------------------------------------
;       static array of bytes

;       TECHNICAL REMARK: AVR compiler allows to break lines but
;       after the break character (here: backslash) "\" there MUST NOT be
;       anything, not even a single space!

;       linear structure of the array:
;       KEY_COORDINATES, CODE_OF_THE_SEGMENT_DIGIG,
;       KEY_COORDINATES, ...

;       some of the (segment)~digit codes was not declared (11111111)

TABLE: .DB 0B10001000, 0B11111001, \
           0B10000100, 0B10011001, \
           0B10000010, 0B11111000, \
           0B10000001, 0B11111111, \
           0B01001000, 0B10100100, \
           0B01000100, 0B10010010, \
           0B01000010, 0B10000000, \
           0B01000001, 0B11000000, \
           0B00101000, 0B10110000, \
           0B00100100, 0B10000010, \
           0B00100010, 0B10010000, \
           0B00100001, 0B11111111, \
           0B00011000, 0B11111111, \
           0B00010100, 0B11111111, \
           0B00010010, 0B11111111, \
           0B00010001, 0B11111111
;---------------------------------------------------------------------------
