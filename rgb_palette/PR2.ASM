; 2021-03-29
; wojtek[at]bitologia.org
;
; simple palette reader
;
; WARNING - THERE IS ABSOLUTELY NO ERROR HANDLING IN THIS VERSION!
; 1. it is supposed that the (full spectrum) pallete is stored in
;    a binary file of size 0300h
; 2. there should be only one space between program name and its argument, eg:
;    > PR2 LYAPUNOV.PAL
;
; -----------------------------------------------------------------------------

.model tiny
.code
.386
        org 100h
start:  xor bx, bx
        mov byte ptr bl, cs:[80h]
        cmp bl, 7Eh
        ja exit          ; https://en.wikipedia.org/wiki/Program_Segment_Prefix
        mov byte ptr cs:[bx + 81h], 0

        mov ax, 3d00h    ; open file for reading
        lea dx, cs:[82h]
        int 21h

        mov bx, ax       ; handler
        mov ah, 3fh
        mov cx, 0300h    ; 256*3=768 = 0300h
        lea dx, palette
        int 21h

        mov ax, 13h
        int 10h

        lea si, palette
        cli
        mov dx, 03c8h
        xor al, al
        out dx, al
        inc dx
        mov cx, 0300h
        rep outsb        ; [ds:si++] ---> [dx] (cx--)
        sti

        mov ah, 3eh      ; handler in BX
        int 21           ; close file


        mov ax, 0a000h   ; draw palette
        mov es, ax
        mov dl, 32       ; spectrum thickness
        mov di, 6400
draw_stripe:
        xor al, al
        mov cx, 0100h    ; full spectrum
show_palette:
        stosb
        inc al
        loop show_palette
        add di, 0040h
        dec dl
        jnz draw_stripe

ESC_:   in al, 60h
        cmp al, 1
        jne ESC_

        mov ax, 03
        int 10h
exit:   mov ah, 4ch
        int 21h

palette db 768 dup(?)    ; palette buffer

end start


