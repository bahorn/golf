; This calls getpid(), and either infloops if the parity of the pid is even or
; kills itself.
;
; bah / Feb 2025

        BITS 64

        org     0x500000000

_header:

        db      0x7F                    ; e_ident
_start:
        db      "ELF"                   ; 3 REX prefixes (no effect)
        push    9                       ; 2
        pop     rsi                     ; 1
        mov     al, 39                  ; 2
        syscall                         ; 2
        xchg    eax, edi                ; 1
        mov     al, 62                  ; 2
        jmp     _next                   ; 2

        dw      2                       ; e_type
        dw      62                      ; e_machine
        dd      1                       ; e_version
phdr:
        dd      1                       ; e_entry       ; p_type
        dd      5                                       ; p_flags
        dq      phdr - $$               ; e_phoff       ; p_offset
        dq      phdr                    ; e_shoff       ; p_vaddr

_next:
        test    edi, edi                ; 2
self:
        jpe     self                    ; 2
        syscall                         ; 2

        dw      0x38                    ; e_phentsize
        dw      1                       ; e_phnum       ; p_filesz
        dw      0x40                    ; e_shentsize
        dw      0                       ; e_shnum
        dw      0                       ; e_shstrndx
        dq      0x00400001                              ; p_memsz
        ; p_align can be whatever

_body:
        db      "bah/2025"              ; need to pad up 80 bytes.
