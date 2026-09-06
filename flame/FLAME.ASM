; wojtek[at]bitologia.org
;
; The code is based entirely on the work of Kamil Dziekanowski (Dean/TS).
; The original code written in Turbo Pascal (6.0) supported by Assembler
; was printed in Bajtek, Feb. '96.
;
; 2021-02-23 translation from TP to pure Assembler
; 2021-02-24 it is burning!
; 2021-02-25 fix memory leaks
;
; Tested on DOSBOX and a real 80286. On AT it even performs faster! :)
;
; C:\> TASM FLAME.ASM
; C:\> TLINK /T FLAME.ASM
; C:\> FLAME.COM

.model tiny
.code
        fx_max equ 40
        fy_max equ 120
        no_sparks equ 8
        no_frames equ 1

        org 100h
start:  mov ax, 0013h ; 320x200x256
        int 10h
        call set_palette
main:   call make_frame
        call show_frame
        in al, 60h
        cmp al, 1
        jne main
        mov ax, 0003h
        int 10h
        mov ah, 4ch
        int 21h

frame1 db fx_max * fy_max dup(0)
frame2 db fx_max * fy_max dup(0)

r_seed dw 17aeh

get_random proc
        push ax
        push bx
        push cx
        mov bx, [r_seed]
        add bx, 9248h
        mov cl, 3
        ror bx, cl
        mov [r_seed], bx
        or ax, bx
        push ax
        xor ah, ah
        int 01ah
        pop ax
        or cx, dx
        rol bx, cl
        lea dx, [bx]
        xor cx, dx
        xor ax, cx
        xor dx, dx
        mov cx, fx_max - 10
        div cx ; dx <- result (remainder)
        pop cx
        pop bx
        pop ax
        ret
get_random endp

show_frame proc
        mov ax, 0a000h
        mov es, ax
        mov cx, no_frames
        xor bx, bx
next_frame:
        lea si, frame2
        xor di, di
;   mov di, ... ; centering
        add di, bx
        mov dx, fy_max
        push cx
line:   mov cx, fx_max / 2
        rep movsw
        add di, 320 - fx_max
        dec dx
        jnz line
        pop cx
        add bx, fx_max
        loop next_frame
        ret
show_frame endp

burn_pixel proc                   ; input: AX
        lea bx, frame1
        add bx, ax
        mov dl, [bx - 1]
        add dl, [bx]
        add dl, [bx + 1]
        add dl, [bx - 1 + fx_max]
        add dl, [bx + 1 + fx_max]
        add dl, [bx - 1 + fx_max * 2]
        add dl, [bx + fx_max * 2]
        add dl, [bx + 1 + fx_max * 2]
        ;
        ; actually it should be flipped vertically
        ;
        ; bx-1    | bx    | bx+1
        ; --------+-------+--------
        ; bx-1+40 |       | bx+1+40
        ; --------+-------+--------
        ; bx-1+80 | bx+80 | bx+1+80
        ;
        mov cl, 3
        shr dl, cl                ; dx <- (frame1[] + ... ) / 8
        lea bx, frame2
        add bx, ax
        mov [bx - fx_max * 2], dl ; lift up
        ret
burn_pixel endp

ignition proc
        mov cx, 3                 ; three lines to keep the fire
        xor ax, ax
fire_line:
        push cx
        mov cx, no_sparks
add_spark:
        lea bx, frame1
        add bx, fx_max * (fy_max - 5) ; put sparks at the three bottom lines
        add bx, 5                     ; bx + (fx_max - 30)/2 + rnd(30) [+ y*fx_max]
        add bx, ax
        call get_random           ; (30)
        add bx, dx
        mov [bx], word ptr 250d   ; should be 250 + rnd(55), but it works too
        loop add_spark
        pop cx
        add ax, fx_max
        loop fire_line
        ret
ignition endp

make_frame proc
        mov si, 1                 ; =y
inc_y:  inc si                    ; for y=2 to fy_max-1
        cmp si, fy_max
        je exit_f
        mov di, 1                 ; =x
inc_x:  inc di                    ; for x=2 to fx_max-1
        mov ax, si                ; prepare ax
        mov dx, fx_max
        mul dx
        add ax, di                ; ax <- x + y * fx_max
        call burn_pixel
        cmp di, fx_max
        je inc_y
        jmp short inc_x
exit_f: mov cx, fx_max * fy_max - 1
copy_f: lea bx, frame2
        add bx, cx
        mov ax, [bx - 1]
        lea bx, frame1
        add bx, cx
        mov [bx - 1], ax          ; frame1 = frame2
        loop copy_f
        call ignition
        ret
make_frame endp

set_palette proc
        mov cx, 16
        xor bl, bl
s1:     mov dx, 03c8h
        mov al, bl         ; color index
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
        mov al, bl         ; color index
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
        mov al, bl         ; color index
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
        ret
set_palette endp

end start


;      x=
;      12 4   8                            x=40
; y=1  L.......................................
; y=2  ........................................
; :    ........................................
; :    :
; :    ........................................
; :    ........................................
; y=87 ..####################################..
; y=88 ..####################################..
; y=89 ..####################################..
; y=90 ........................................
;
;
; y = 90 - 3 to 90 - 1
; x = 1 to 2
; array[ 5 + rnd(30) + 40*y] = 200 + rnd(55)
;
;
; L: lea bx, frame1     ; fx_max * (fy_max - 4)
;    add bx, 40*86      ; (fx_max - flame_width) / 2
;    add bx, 5
;    add bx, ax
;    push bx
;    push ax
;    mov [random_m], 30 ; fx_max - 10
;    call get_random
;    pop bx
;    pop ax
;    add bx, dx
;    mov [bx], 250d     ; spark's colour (should be as white as possible)
;    add ax, 40
;    loop L
;    ret

