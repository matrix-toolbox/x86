; 2021-03-29
; wojtek[at]bitologia.org
;
; simple palette reader
;
; -----------------------------------------------------------------------------
; retrieve hex comma-sep. data from binary files under *NIX with:
;
; $ xxd -l 768 -g 1 VOLCANO.PAL | cut -c 11- | cut -c -47 | sed -e "s/ /, /g"
;
; requires a little additional effort to produce well formatted DB data
; -----------------------------------------------------------------------------

.model tiny
.code
.386
        org 100h
start:
        mov ax, 13h
        int 10h

        lea si, cs:[palette]
        cli
        mov dx, 03c8h
        xor al, al
        out dx, al
        inc dx
        mov cx, 771d
        rep outsb            ; [ds:si++] ---> [dx] (cx--)
        sti

        mov ax, 0a000h
        mov es, ax
        mov dl, 32           ; spectrum thickness
        mov di, 6400
draw_stripe:
        xor al, al
        mov cx, 0100h        ; full spectrum
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
        mov ah, 4ch
        int 21h

palette db 000h, 000h, 000h, 0fch, 0fch, 0fch, 0f8h, 0fch, 0fch, 0fch, 0f8h, 0fch, 0fch, 0f8h, 0f8h, 0f8h
        db 0f8h, 0f8h, 0f4h, 0f8h, 0f8h, 0f8h, 0f4h, 0fch, 0f8h, 0f4h, 0f4h, 0f4h, 0f4h, 0f4h, 0f0h, 0f4h
        db 0f4h, 0f4h, 0f0h, 0f8h, 0f4h, 0f0h, 0f0h, 0f0h, 0f0h, 0f0h, 0ech, 0f0h, 0f0h, 0f0h, 0ech, 0f4h
        db 0f0h, 0ech, 0ech, 0ech, 0ech, 0ech, 0e8h, 0ech, 0ech, 0ech, 0e8h, 0f0h, 0ech, 0e8h, 0e8h, 0e8h
        db 0e8h, 0e8h, 0e4h, 0e8h, 0e8h, 0e8h, 0e4h, 0ech, 0e8h, 0e4h, 0e4h, 0e4h, 0e4h, 0e4h, 0e0h, 0e4h
        db 0e4h, 0e4h, 0e0h, 0e8h, 0e4h, 0e0h, 0e0h, 0e0h, 0e0h, 0e0h, 0dch, 0e0h, 0e0h, 0e0h, 0dch, 0e4h
        db 0e0h, 0dch, 0dch, 0dch, 0dch, 0dch, 0d8h, 0dch, 0dch, 0dch, 0d8h, 0e0h, 0dch, 0d8h, 0d8h, 0d8h
        db 0d8h, 0d8h, 0d4h, 0d8h, 0d8h, 0d8h, 0d4h, 0dch, 0d8h, 0d4h, 0d4h, 0d4h, 0d4h, 0d4h, 0d0h, 0d4h
        db 0d4h, 0d4h, 0d0h, 0d8h, 0d4h, 0d0h, 0d0h, 0d0h, 0d0h, 0d0h, 0cch, 0d0h, 0d0h, 0d0h, 0cch, 0d4h
        db 0d0h, 0cch, 0cch, 0cch, 0cch, 0cch, 0c8h, 0cch, 0cch, 0cch, 0c8h, 0d0h, 0cch, 0c8h, 0c8h, 0c8h
        db 0c8h, 0c8h, 0c4h, 0c8h, 0c8h, 0c8h, 0c4h, 0cch, 0c8h, 0c4h, 0c4h, 0c4h, 0c4h, 0c4h, 0c0h, 0c4h
        db 0c4h, 0c4h, 0c0h, 0c8h, 0c4h, 0c0h, 0c0h, 0c0h, 0c0h, 0c0h, 0bch, 0c0h, 0c0h, 0c0h, 0bch, 0c4h
        db 0c0h, 0bch, 0bch, 0bch, 0bch, 0bch, 0b8h, 0bch, 0bch, 0bch, 0b8h, 0c0h, 0bch, 0b8h, 0b8h, 0b8h
        db 0b8h, 0b8h, 0b4h, 0b8h, 0b8h, 0b8h, 0b4h, 0bch, 0b8h, 0b4h, 0b4h, 0b4h, 0b4h, 0b4h, 0b0h, 0b4h
        db 0b4h, 0b4h, 0b0h, 0b8h, 0b4h, 0b0h, 0b0h, 0b0h, 0b0h, 0b0h, 0ach, 0b0h, 0b0h, 0b0h, 0ach, 0b4h
        db 0b0h, 0ach, 0ach, 0ach, 0ach, 0ach, 0a8h, 0ach, 0ach, 0ach, 0a8h, 0b0h, 0ach, 0a8h, 0a8h, 0a8h
        db 0a8h, 0a8h, 0a4h, 0a8h, 0a8h, 0a8h, 0a4h, 0ach, 0a8h, 0a4h, 0a4h, 0a4h, 0a4h, 0a4h, 0a0h, 0a4h
        db 0a4h, 0a4h, 0a0h, 0a8h, 0a4h, 0a0h, 0a0h, 0a0h, 0a0h, 0a0h, 09ch, 0a0h, 0a0h, 0a0h, 09ch, 0a4h
        db 0a0h, 09ch, 09ch, 09ch, 09ch, 09ch, 098h, 09ch, 09ch, 09ch, 098h, 0a0h, 09ch, 098h, 098h, 098h
        db 098h, 098h, 094h, 098h, 098h, 098h, 094h, 09ch, 098h, 094h, 094h, 094h, 094h, 094h, 090h, 094h
        db 094h, 094h, 090h, 098h, 094h, 090h, 090h, 090h, 090h, 090h, 08ch, 090h, 090h, 090h, 08ch, 094h
        db 090h, 08ch, 08ch, 08ch, 08ch, 08ch, 088h, 08ch, 08ch, 08ch, 088h, 090h, 08ch, 088h, 088h, 088h
        db 088h, 088h, 084h, 088h, 088h, 088h, 084h, 08ch, 088h, 084h, 084h, 084h, 084h, 084h, 080h, 084h
        db 084h, 084h, 080h, 088h, 084h, 080h, 080h, 080h, 080h, 080h, 07ch, 080h, 080h, 080h, 07ch, 084h
        db 080h, 07ch, 07ch, 07ch, 07ch, 07ch, 078h, 07ch, 07ch, 07ch, 078h, 080h, 07ch, 078h, 078h, 078h
        db 078h, 078h, 074h, 078h, 078h, 078h, 074h, 07ch, 078h, 074h, 074h, 074h, 074h, 074h, 070h, 074h
        db 074h, 074h, 070h, 078h, 074h, 070h, 070h, 070h, 070h, 070h, 06ch, 070h, 070h, 070h, 06ch, 074h
        db 070h, 06ch, 06ch, 06ch, 06ch, 06ch, 068h, 06ch, 06ch, 06ch, 068h, 070h, 06ch, 068h, 068h, 068h
        db 068h, 068h, 064h, 068h, 068h, 068h, 064h, 06ch, 068h, 064h, 064h, 064h, 064h, 064h, 060h, 064h
        db 064h, 064h, 060h, 068h, 064h, 060h, 060h, 060h, 060h, 060h, 05ch, 060h, 060h, 060h, 05ch, 064h
        db 060h, 05ch, 05ch, 05ch, 05ch, 05ch, 058h, 05ch, 05ch, 05ch, 058h, 060h, 05ch, 058h, 058h, 058h
        db 058h, 058h, 054h, 058h, 058h, 058h, 054h, 05ch, 058h, 054h, 054h, 054h, 054h, 054h, 050h, 054h
        db 054h, 054h, 050h, 058h, 054h, 050h, 050h, 050h, 050h, 050h, 04ch, 050h, 050h, 050h, 04ch, 054h
        db 050h, 04ch, 04ch, 04ch, 04ch, 04ch, 048h, 04ch, 04ch, 04ch, 048h, 050h, 04ch, 048h, 048h, 048h
        db 048h, 048h, 044h, 048h, 048h, 048h, 044h, 04ch, 048h, 044h, 044h, 044h, 044h, 044h, 040h, 044h
        db 044h, 044h, 040h, 048h, 044h, 040h, 040h, 040h, 040h, 040h, 03ch, 040h, 040h, 040h, 03ch, 044h
        db 040h, 03ch, 03ch, 03ch, 03ch, 03ch, 038h, 03ch, 03ch, 03ch, 038h, 040h, 03ch, 038h, 038h, 038h
        db 038h, 038h, 034h, 038h, 038h, 038h, 034h, 03ch, 038h, 034h, 034h, 034h, 034h, 034h, 030h, 034h
        db 034h, 034h, 030h, 038h, 034h, 030h, 030h, 030h, 030h, 030h, 02ch, 030h, 030h, 030h, 02ch, 034h
        db 030h, 02ch, 02ch, 02ch, 02ch, 02ch, 028h, 02ch, 02ch, 02ch, 028h, 030h, 02ch, 028h, 028h, 028h
        db 028h, 028h, 024h, 028h, 028h, 028h, 024h, 02ch, 028h, 024h, 024h, 024h, 024h, 024h, 020h, 024h
        db 024h, 024h, 020h, 028h, 024h, 020h, 020h, 020h, 020h, 020h, 01ch, 020h, 020h, 020h, 01ch, 024h
        db 020h, 01ch, 01ch, 01ch, 01ch, 01ch, 018h, 01ch, 01ch, 01ch, 018h, 020h, 01ch, 018h, 018h, 018h
        db 018h, 018h, 014h, 018h, 018h, 018h, 014h, 01ch, 018h, 014h, 014h, 014h, 014h, 014h, 010h, 014h
        db 014h, 014h, 010h, 018h, 014h, 010h, 010h, 010h, 010h, 010h, 00ch, 010h, 010h, 010h, 00ch, 014h
        db 010h, 00ch, 00ch, 00ch, 00ch, 00ch, 008h, 00ch, 00ch, 00ch, 008h, 010h, 00ch, 008h, 008h, 008h
        db 008h, 008h, 004h, 008h, 008h, 008h, 004h, 00ch, 008h, 004h, 004h, 004h, 004h, 004h, 000h, 004h
        db 004h, 004h, 000h, 008h, 004h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h

end start


