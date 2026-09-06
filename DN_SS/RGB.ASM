; 2021-03-01
; wojtek[at]bitologia.org
; SS from DN

.model small
.code
        org 100h
start:  mov ax, 0b800h ; text mode only
        mov es, ax
        mov di, 1
        mov cx, 07d0h
        mov al, 7
        cld
_012b:  mov al, es:[di]
        mov bl, al
        and bl, 0fh
        cmp bl, 1
        jz _0158
        cmp bl, 8
        jz _0158
        cmp bl, 6
        jz _0158
        mov bl, al
        and bl, 0f0h
        cmp bl, 10h
        jz _015c
        cmp bl, 80h
        jz _015c
        cmp bl, 60h
        jz _015c
        jmp short _015e
_0158:  and al, 0f0h
        jmp short _015e
_015c:  and al, 0fh
_015e:  and al, 0f7h
        stosb
        inc di
        loop _012b
        in al, 60h
        mov cs:[_key], al
_0169:  mov bx, offset _ah; 0234h
        call _020f
        mov bx, offset _bl; 023fh
        call _020f
        mov bx, offset _bh; 023ah
        call _020f
        xor di, di
        call _0226
_0180:  mov bx, offset _ah
        call _01ed
        mov bx, offset _bl
        call _01ed
        mov bx, offset _bh
        call _01ed
        mov dx, 03c8h
        xor al, al
        out dx, al
        mov ah, cs:[_ah]; [0234]
        mov bl, cs:[_bl]; [023f]
        mov bh, cs:[_bh]; [024a]
        mov dx, 03dah
_01a7:  in al, dx
        rcr al, 1
        jnb _01a7
        mov dx, 03c9h
        mov al, ah
        out dx, al
        mov al, bl
        out dx, al
        mov al, bh
        out dx, al
        inc di
        cmp di, 0198h
        jnz _0180
        in al, 60h
        test al, 80h
        jnz _0169
        cmp al, cs:[_key]
        jnz _01ec
        jmp _0169
_01ec:  ret ; ---> DOS
_01ed:  xor ah, ah
        mov al, [bx + 01]
        mov dx, [bx + 03]
        sub dx, di
        cmp dx, +00
        jge _0202
        neg dx
        cmp dx, ax
        jg _020b
_0202:  cmp dx, ax
        jg _020b
        sub al, dl
        mov [bx], al
        ret
_020b:  mov byte ptr [bx], 00
        ret
_020f:  mov dx, [bx + 03]
        add dx, [bx + 05]
        cmp dx, [bx + 07]
        jle _021f
        cmp dx, [bx + 09]
        jl _0222
_021f:  neg word ptr [bx + 05]
_0222:  mov [bx + 03], dx
        ret
_0226:  mov dx, 03dah
_0229:  in al, dx
        test al, 08
        jz _0229
_022e:  in al, dx
        rcr al, 1
        jb _022e
        ret

        _ah db 00h, 3fh, 1h, 0cch, 0h, 0ffh, 0ffh, 4ah, 0h, 4eh, 1h
        _bl db 00h, 3fh, 1h, 0cch, 0h, 0feh, 0ffh, 4ah, 0h, 4eh, 1h
        _bh db 00h, 3fh, 1h, 0cch, 0h, 0fdh, 0ffh, 4ah, 0h, 4eh, 1h
        _key db ?

end start

