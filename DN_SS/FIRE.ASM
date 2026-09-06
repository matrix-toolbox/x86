; 2021-03-05
; 2021-03-08
; 2021-03-10 disassembled
; 2021-03-11 fixed and simplified
;
; wojtek[at]bitologia.org

.model tiny
.code
.286
        org 100h
start:
_00b7:  cld
        xor ax, ax
        mov di, 46f2h
        mov cx, 56*320
        repz stosw
        mov di, 6a40h
        mov cx, 56*320
        repz stosw

        mov ax, 0a000h
        mov es, ax
        mov ax, 13h
        int 10h

_00f6:  mov ah, 2ch
        int 21h
        mov [_0002], cx
        mov [_0004], dx
        call _005a
_0105:  mov cx, 013fh
_0108:  push cx
        call _0000
        pop cx
        jnz _012b
        push cx
        call _0000
        pop cx
        mov bx, 00ffh
        imul bx
        mov bx, 0080h
        idiv bx
        mov di, 8e80h
        add di, cx
        mov [di + 00f2h], dl
_012b:  loop _0108
        mov cx, 4600h + 0280h ; + 280h(640d) hide artifacts in two upper lines
        mov si, 00f2h + 8e80h - 1
        xor ah, ah
        xor bh, bh
_0146:  mov bl, [si + 013fh]
        add bl, [si + 0140h]
        mov al, [si + 0141h]
        add al, [si]
        add bx, ax
        shr bx, 2
        jz _015c
        dec bx
_015c:  mov [si], bl
        dec si
        loop _0146
        mov di, 6a40h + 320*3 ; fill three bottom lines
        mov si, 00f2h + 4600h
        mov ax, 0038h

; (si) 46f2h + (38h x 140h) = 8cf2h
; (di) 6a40h + (38h x 140h) x 2 = f640h

_0185:  mov cx, 00a0h
        repz movsw
        mov cx, 00a0h
        sub si, 0140h
        repz movsw
        dec ax
        jnz _0185
_01b5:  mov ah, 01
        int 16h
        jnz _01be
        jmp short _0105
_01be:  mov ax, 0003
        int 10h
        ret
        ;mov ah, 4ch
        ;int 21h ; ret

_0000:  ; fire seeds (sparks)
        mov ax, [_0002]
        mov bx, [_0004]
        mov cx, ax
;       mul word ptr ds:[0006]
        shl cx, 1
        shl cx, 1
        shl cx, 1
        add ch, cl
        add dx, cx
        add dx, bx
        shl bx, 1
        shl bx, 1
        add dx, bx
        add dh, bl
        mov cl, 05
        shl bx, cl
        add dh, bl
        inc ax
        adc dx, +00
        mov [_0002], ax
        mov [_0004], dx
        mov cx, dx
        mov bx, 0004
        mul bx
        mov ax, cx
        mov cx, dx
        mul bx
        add ax, cx
        adc dx, +00
        mov ax, dx
        ret

_005a:  ; set palette
        xor al, al
        mov dx, 03c8h
        out dx, al
        xor ax, ax
        mov [index], ax
        jmp short _0078
_0075:  inc word ptr [index]
_0078:  mov ax, [index]
        cwd
        mov cx, 0002
        idiv cx
        mov dx, 03c9h
        out dx, al
        imul ax, [index], +16h
        cwd
        mov cx, 00ffh ; color of fire
                      ; 0080 = orange (original)
                      ; 00ff = red
                      ; 002a = green
        idiv cx
        mov dx, 03c9h
        out dx, al
        cmp word ptr [index], +08
        jge _00a8
        mov ax, [index]
        cwd
        mov cx, 0002
        idiv cx
        mov dx, 03c9h
        out dx, al
        jmp short _00ae
_00a8:  mov al, 00
        mov dx, 03c9h
        out dx, al
_00ae:  cmp word ptr [index], 0080h
        jnz _0075
        ret

        _0002 dw ? ; clock data (for "randomness")
        _0004 dw ? ; clock data
        _0006 db ?

        index dw ?

end start

