; 2009-03-26
; wojciech bruzda @ IFUJ
;
; External Interrupts
;
; Scheme:
; - choose an interrupt to be handled
; - make a handler for the IRQ
; - establish a label for an appropriate IRQ array offset: RJMP INTX_HANDLER
; - use RETI or NOP for remaining offsets 
;----------------------------------------------------------------------------
.INCLUDE "M8535DEF.INC"
.INCLUDE "A8536.INC"

.CSEG
.ORG 0X0000
    RJMP RESET
    RJMP IRQ_INT0         ; PD2
.ORG INT_VECTORS_SIZE
;----------------------------------------------------------------------------
SET_IRQ:                  ; handling interrupt:
    LDI R21, (1 << INT0)  ; set the GICR/GIMSK bit responsible for INT0
    OUT GICR, R21         ; interrupt acceptation
    LDI R21, 0X02         ; set the "sensitivity" of int.
    OUT MCUCR, R21        ; namely: which slope is used to generate IRQ
    RET
;----------------------------------------------------------------------------
SET_PORTS:                ; HARDWARE -> connect PD2 via SWITCH to the mass
    CLR R21               ; entire D gate is set up for input
    OUT DDRD, R21         ;
    SER R21               ; pull-up resistors
    OUT PORTD, R21        ;
    OUT DDRA, R21         ; port A as output (R2x is already set to 0XFF)
    OUT PORTA, R21        ; and connected with leds
    COM R21               ; later R21 is a counter for IRQ, so set it to zero
    RET
;----------------------------------------------------------------------------
RESET:
    STACK_INIT RAMEND     ; stack
    RCALL SET_IRQ         ; set INT0
    RCALL SET_PORTS       ; set the gates
    SEI                   ; turn on interrupts
;----------------------------------------------------------------------------
MAIN_LOOP:
    OUT PORTA, R21        ; when SWITCH is pressed the INT0 is released
    RJMP MAIN_LOOP        ; and the "LED-counter" increments :)
;----------------------------------------------------------------------------
IRQ_INT0:
    INC R21               ; counter++
    RETI
;----------------------------------------------------------------------------
