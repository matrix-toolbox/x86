.model tiny
.code
        org 100h
start:
        mov ax, 0013h ; 320x200x256
        int 10h

        mov bx, 0a000h
        mov es, bx

        mov ax, 142d

        mov cx, 320
        mov si, 64000-320*9
draw_hr:mov byte ptr [es:si], 8
        inc si
        loop draw_hr


        mov cx, 8
        mov si,64000-320*6+2
        mov dx, ax
draw:   push dx
        and dx, 10000000b
        rol dl, 1
        call put_binary_dot
        add si, 4
        pop dx
        shl dx, 1
        loop draw

esc_:
        in al, 60h
        cmp al, 1
        jne esc_

        mov ax, 0003h
        int 10h

        mov ah, 4ch
        int 21h

hash db 00010100b, 00111110b, 00010100b, 00111110b, 00010100b


put_binary_dot proc
        or dl, 8
        push cx
        mov cx, 4
fat_dot:mov byte ptr [es:si], dl
        mov byte ptr [es:si+320], dl
        mov byte ptr [es:si+640], dl
        mov byte ptr [es:si+960], dl
        inc si
        loop fat_dot
        pop cx
        ret
put_binary_dot endp


end start