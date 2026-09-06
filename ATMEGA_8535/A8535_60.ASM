; 2009-04-29
; wojciech bruzda @ IFUJ
;
; WDR = Watch-Dog Reset
;----------------------------------------------------------------------------
.INCLUDE "M8535DEF.INC"
.INCLUDE "A8536.INC"

.CSEG
.ORG 0X0000
    RJMP RESET
.ORG INT_VECTORS_SIZE
;----------------------------------------------------------------------------
RESET:
    STACK_INIT RAMEND                  ; stack
;----------------------------------------------------------------------------
    LDI R20, 0X00
    OUT DDRA, R20
    OUT PORTA, R20
    NOP

    WDR
    LDI R20, (1 << WDE) | (1 << WDCE)  ; WDTCR register needs WD(C)E and
    OUT WDTCR, R20                     ; WDPx to be loaded in separate
    IN R21, WDTCR                      ; steps (clocks) - remember to OR!

    LDI R20, (1 << WDP0) | (1 << WDP1) | (1 << WDP2)
                                       ; after 2.2 sec. the device resets
    OR R20, R21
    OUT WDTCR, R20

    LDI R25, 0X00                      ; infinite loop: the LEDs display
                                       ; R25 values
LOOP:                                  ; until WD-clock strikes 2.2 sec.
    INC R25
    OUT PORTA, R25
    WAIT 0XC0
    RJMP LOOP
;----------------------------------------------------------------------------
