; An attempt at the BGGP4 challenge.
; creat("4\0", 0xfffffff) -> write(3, _start, size) -> exit(4)
; bah / Feb 2025

        BITS    64
        org     0x500000000

_header:

        db      0x7F                    ; e_ident
_start:
        db      "ELF"                   ; 3 REX prefixes (no effect)
; we initial start with a creat() call
        lea     rdi, [rel _name]        ; 7 bytes
        push    rdi                     ; 1 byte
        mov     al, 85                  ; 2 bytes
        jmp     _next                   ; 2 bytes
        
        dw      2                       ; e_type
        dw      62                      ; e_machine
_name: ; we get to overlay this with the version!
        dd      0x34                    ; e_version
phdr:
        dd      1                       ; e_entry       ; p_type
        dd      5                                       ; p_flags
        dq      phdr - $$               ; e_phoff       ; p_offset
        dq      phdr                    ; e_shoff       ; p_vaddr

_next:
; Now finishing up the creat() call
        dec     esi                     ; 2 bytes. yeah, this works for the
                                        ; mode. Just want to make all the bits
                                        ; 1.
        syscall                         ; 2 bytes
        jmp     _body

        dw      0x38                    ; e_phentsize
        dw      1                       ; e_phnum       ; p_filesz
        dw      0x40                    ; e_shentsize
        dw      0                       ; e_shnum
        dw      0                       ; e_shstrndx
        dq      0x00400001                              ; p_memsz
        ; p_align can be whatever

_body:
; Move onto write()'ing this to the file we created.
        pop     rsi                     ; 1 byte
        sub     sil, _name - $$         ; 4 bytes

        mov     dl, _end - $$           ; 2 bytes

        xchg    eax, edi                ; 1 byte
        mov     al, 1                   ; 2 bytes.
                                        ; rdi, which we get this from, is 
                                        ; 0x50000005e, we drop the higher bits
                                        ; by xchg'ing with 32bit regs.
                                        ; because edi is less than 255 we can
                                        ; just set the lower byte.
        syscall
; Now finish off with an exit(4)
        inc     edi                     ; 2 bytes. the fd is 3, so we can get 4
                                        ; by just inc'ing it.
        mov     al, 60                  ; 2 bytes.
        syscall                         ; 2 bytes

_end:
