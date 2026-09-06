; 2021-02-24 fire palette

.model tiny
.code
        org 100h
start:
        mov ax, 0013h ; 320x200x256
        int 10h
        mov bx, 0a000h
        mov es, bx
        mov cx, 16
        xor bl, bl
s1:     mov dx, 03c8h
        mov al, bl ; color index
        out dx, al
        inc dx
        mov al, bl
        shl al, 1
        shl al, 1
        out dx, al
        xor al, al
        out dx, al
        out dx, al
        inc bl
        loop s1
        mov cx, 63
s2:     mov dx, 03c8h
        mov al, bl ; color index
        out dx, al
        inc dx
        mov al, 60
        out dx, al
        mov al, bl
        sub al, 15
        out dx, al
        xor al, al
        out dx, al
        inc bl
        loop s2
        mov cx, 177
s3:     mov dx, 03c8h
        mov al, bl ; color index
        out dx, al
        inc dx
        mov al, 60
        out dx, al
        or al, 3 ; al <- 63
        out dx, al
        mov al, bl
        xor dx, dx
        push cx
        mov cx, 3
        div cx
        pop cx
        sub al, 26
        mov dx, 03c9h
        out dx, al
        inc bl
        loop s3

        mov cx, 256
        xor si, si
draw:   mov [es:si], si
        mov [es:si+320*1], si
        mov [es:si+320*2], si
        mov [es:si+320*3], si
        mov [es:si+320*4], si
        mov [es:si+320*5], si
        mov [es:si+320*6], si
        mov [es:si+320*7], si
        mov [es:si+320*8], si
        mov [es:si+320*9], si
        inc si
        loop draw
main:   in al, 60h
        cmp al, 1
        jne main
        mov ax, 0003h
        int 10h
        mov ah, 4ch
        int 21h

end start
