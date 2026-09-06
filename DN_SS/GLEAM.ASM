; wojtek[at]bitologia.org
;
; 2021-03-01 disassembling GLEAM.EXE
; 2021-03-02 disassembling GLEAM.EXE
; 2021-03-03 disassembled! GLEAM.COM (919B)

.model small
.code
        org 100h
start:

; original fragments with mouse handling:
;
; ....:0000 ...... mov dx, DS_SEGMENT
;                  mov ds, dx
;                  mov bx, ss
;                  sub bx, dx
;                  shl bx, 1
;                  shl bx, 1
;                  shl bx, 1
;                  shl bx, 1
;                  cli
;                  mov ss, dx
;                  add sp, bx
;                  sti
;                  xor ax, ax
;                  int 33
;                  or ax, ax
;                  jz 0033
;                  cs:
;                  mov word ptr [0015], 9090 ; NOP NOP
;                  mov ax, 0003
;                  int 33
;                  mov cs:[_cx], cx
;                  mov cs:[_dx], dx
; ....:0033 FC     cld

_0033:  cld
        mov ax, 13h
        int 10h
        cli
        mov dx, 03c4h
        mov ax, 0604h
        out dx, ax
        mov ax, 0f02h
        out dx, ax
        mov dx, 03d4h
        mov ax, 0014h
        out dx, ax
        mov ax, 0e317h
        out dx, ax
        mov al, 9
        out dx, al
        inc dx
        in al, dx
        and al, 0e0h
        add al, 7
        out dx, al
        mov dx, 03c8h
        mov al, 80h
        out dx, al
        inc dx
        mov cx, 180h
        lea si, palette
_0067:  lodsb
        out dx, al
        loop _0067
        mov ax, 0a000h
        mov es, ax
        lea si, sine
_0073:  mov dx, 03dah
_0076:  in al, dx
        test al, 8
        jz _0076
_007b:  in al, dx
        test al, 8
        jnz _007b
        xor di, di
        mov ah, 32h
        mov cl, cs:[_40a]
        mov ch, cs:[_40b]
_008c:  push ax
        mov ah, 50h
        mov dl, cs:[_408]
        mov dh, cs:[_409]
        xor bp, bp ; extra line
_0097:  mov bx, bp
        mov al, bl
        xor bh, bh
        mov bl, dl
        add al, [bx + si]
        mov bl, dh
        add al, [bx + si]
        mov bl, cl
        add al, [bx + si]
        mov bl, ch
        add al, [bx + si]
        or al, 80h
        stosb
        add dl, 1
        add dh, 3
        dec ah
        jnz _0097
        add cl, 2
        add ch, 1
        pop ax
        dec ah
        jnz _008c
        dec bp
        mov bx, bp
        xor bl, bh
        xor bl, [di - 1]
        xor bl, cl
        xor bl, dl
        add bl, ch
        add bl, dh
        xor bh, bh
        mov di, 0280h
        test bl, 8
        jnz _00eb
        and bl, 3
        cmp byte ptr [bx + di], 3
        jg _00f5
        inc byte ptr [bx + di]
        jmp short _00f5
_00eb:  and bl, 03
        cmp byte ptr [bx + di], 0fdh
        jl _00f5
_00f3:  dec byte ptr [bx + di]
_00f5:  mov dl, cs:[_280]
        mov dh, cs:[_281]
        mov cl, cs:[_282]
        mov ch, cs:[_283]
        add cs:[_408], dl
        sub cs:[_409], dh
        add cs:[_40a], cl
        sub cs:[_40b], ch

; ....:0115        jmp 012c
;                  mov ax, 0003
;                  int 33
;                  or bx, bx
;                  jnz 0139
;                  cmp cx, cs:[_cx]
;                  jnz 0139
;                  cmp dx, cs:[_dx]
;                  jnz 0139

_012c:  mov ah, 1
        int 16h
        jnz _0135
        jmp _0073
_0135:  xor ah, ah
        int 16h
_0139:  mov ax, 3
        int 10h
        xor bh, bh
        mov dx, 1700h
        mov ah, 2
        int 10h
        mov ah, 4ch
        int 21h

        _280 db 2 ; magic constants
        _281 db 1
        _282 db 3
        _283 db 4

        _408 db ?; 0a7h ; other magic constants
        _409 db ?; 080h
        _40a db ?; 03eh
        _40b db ?; 018h

        include GLEAM_S.inc
        include GLEAM_P.inc
end start

