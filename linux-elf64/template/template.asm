; 12 / 6 / 8+ template, the haiku format of ELF64

        BITS    64

        org     0x500000000

_header:

        db      0x7F                    ; e_ident
_start:
        db      "ELF"                   ; 3 REX prefixes (no effect)
        db      0x90, 0x90
        db      0x90, 0x90        
        db      0x90, 0x90
        db      0x90, 0x90   
        
        db      0x90, 0x90
        jmp     _skip

        dw      2                       ; e_type
        dw      62                      ; e_machine
; e_version
_skip:
        db      0x90, 0x90
        jmp     _next
phdr:
        dd      1                       ; e_entry       ; p_type
        dd      5                                       ; p_flags
        dq      phdr - $$               ; e_phoff       ; p_offset
        dq      phdr                    ; e_shoff       ; p_vaddr

_next:
        db      0x90, 0x90
        db      0x90, 0x90
        jmp     _body

        dw      0x38                    ; e_phentsize
        dw      1                       ; e_phnum       ; p_filesz
        dw      0x40                    ; e_shentsize
        dw      0                       ; e_shnum
        dw      0                       ; e_shstrndx
        dq      0x00400001                              ; p_memsz
        ; p_align can be whatever

_body:
        db      0x90, 0x90
        db      0x90, 0x90        
        db      0x90, 0x90
_self:
        jmp     _self
