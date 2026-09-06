.model tiny
.code
        org 100h
start:  finit
        mov test_FPU, 55AAh      ; junk value for comparison
        fnstsw test_FPU          ; status word
        cmp test_FPU, 0
        jne short no_FPU
        fnstcw test_FPU          ; control word
        mov ax, test_FPU         ; check expected bits
        and ax, 103Fh
        cmp ax, 3Fh
        jne short no_FPU
        lea dx, FPU_OK
        jmp short PRINT
no_FPU: lea dx, FPU_error
PRINT:  mov ah, 09
        int 21h
        mov ah, 4ch
        int 21h

FPU_error db 'no PFU$'
FPU_OK db 'FPU is present$'      ; actually this shit is not universal and returns mess!
test_FPU dw 00h

end start