    ;---------------------------------------------------------------------------
    ; Microcontroller is a microprocessor system in a form of single electronic
    ; circuit with CPU, RAM, ROM, and I/O ports which constitutes a useful and
    ; autonomical device with no additional elements required for traditional
    ; microprocessor. The name originates from the main area of applications that
    ; is a supervision of electronic devices. The most popular and powerful
    ; language to program mircrocontrollers is a native assembler.
    ;
    ; Typical in-built microcontroller functional blocks are:
    ; - computational unit ALU
    ; - RAM
    ; - program memory
    ; - universal I/O ports
    ; - time-counter systems
    ; - IRQ controllers
    ; - controllers of serial and parallel transmission:
    ;   UART, SPI, I2C, CAN, 1-WIRE, ...
    ; - simple converters ADC and/or DAC
    ; - area of non-volatile memory EEPROM
    ; - RTC clock
    ; - WATCHDOG = a work control system;
    ;   eg. provides RESET in the case of a system halt
    ; - non-electric value sensors, eg. temperature sensor
    ;
    ; Atmel AVR = a family of 8-bit microcontrollers based on the RISC arch.,
    ; Harvard architecture and 32-bit registers. It is characterized by a simple
    ; instruction set structure and high performance computing; most of the
    ; instructions are executed in a single CPU cycle. AVR microcontrollers are
    ; equipped with the supervision system called WATCHDOG, including a clock
    ; driven by a generator of 1 MHz frequency (Vcc = 5V) which is independent
    ; on the system clock. Between the clock and the generator there is
    ; a prescaler controlling the frequency of restarts.
    ;---------------------------------------------------------------------------

    ;---------------------------------------------------------------------------
    ; TO LOAD THIS FILE, PUT THE FOLLOWING COMMAND IN THE PREPROCESSOR SECTION:
    ;
    ; .INCLUDE "A8535.INC"
    ;
    ; IT CONTAINS VARIABLE DECLARATIONS, CONSTANTS AND MACROS.
    ; IT IS STRONGLY RECOMMENDED TO GO THROUGH THE 'M8525DEF.INC' FILE.
    ; THERE ARE MANY DEFINITIONS CONCERNING ATMEGA8535, IN PARTICULAR:
    ; RAMEND, INT_VECTORS_SIZE, GICR/GIMSK, MCUCR, AND MANY OTHERS...
    ;---------------------------------------------------------------------------

    .DEF AL = R15            ; CUSTOM VARIABLES
    .DEF AH = R16
    .DEF BL = R17
    .DEF BH = R18
    .DEF CL = R19
    .DEF CH = R20
    .DEF DL = R21
    .DEF DH = R22

    .DEF TMP = R25
    ;---------------------------------------------------------------------------
    .EQU PI = 0X3141         ; CONSTANTS
    .EQU HALF = 0B11110000
    ;---------------------------------------------------------------------------
    .MACRO STACK_INIT        ; STACK INITIALIZATION: STACK_INIT RAMEND
        LDI AH, HIGH(@0)
        OUT SPH, AH
        LDI AL, LOW(@0)
        OUT SPL, AL
    .ENDMACRO
    ;---------------------------------------------------------------------------
    .MACRO WAIT              ; WAIT 0xFF 0xFF
        PUSH CL              ; SAVE "CX"...
        PUSH CH
        LDI CL, (@0)
        LDI CH, (@1)
WAIT_LOOP:
        NOP
        NOP
        NOP
        DEC CL
        BRNE WAIT_LOOP
        NOP
        NOP
        NOP
        LDI CL, (@0)
        DEC CH
        BRNE WAIT_LOOP
        POP CH
        POP CL
    .ENDMACRO
    ;---------------------------------------------------------------------------
    .MACRO WAIT_02           ; ALTERNATIVE DELAY
        DEC @0               ; [CODE] LOOP:
        BRNE @1              ; [CODE] NOP
    .ENDMACRO                ; [CODE] WAIT 0XFA LOOP
    ;---------------------------------------------------------------------------
