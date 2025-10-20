; An attempt at the BGGP4 challenge.
; creat("4\0", 0xfffffff) -> write(3, _start, size) -> exit(4)
; bah / Feb 2025

        BITS    64

_header:

        db      0x7F                    ; e_ident
_start:
        db      "ELF"                   ; 3 REX prefixes (no effect)
; we initial start with a creat() call
        lea     rdi, [rel _name]        ; 7 bytes
        push    rdi                     ; 1 byte
        mov     al, 85                  ; 2 bytes
        jmp     _skip                   ; 2 bytes
        
        dw      2                       ; e_type
        dw      62                      ; e_machine
_skip: ; we get to overlay this with e_version
        dec esi                         ; 2 bytes. yeah, this works for the
                                        ; mode. Just want to make all the bits
                                        ; 1.
        jmp _next
phdr:
        dd      1                       ; e_entry       ; p_type
        dd      7                                       ; p_flags
        dq      phdr - $$               ; e_phoff       ; p_offset
        dq      0x700000000 + phdr - $$ ; e_shoff       ; p_vaddr

_next:
; Now finishing up the creat() call
        syscall                         ; 2 bytes
        pop     rsi                     ; 1 byte
        push    rdi
        jmp     _body                   ; 2 bytes

        dw      0x38                    ; e_phentsize
        dw      1                       ; e_phnum       ; p_filesz
_name:
        dw      0x36                    ; e_shentsize
        dw      0                       ; e_shnum
        dw      0                       ; e_shstrndx
        dq      0x00360001                              ; p_memsz
        ; p_align can be whatever

_body:
        xchg eax, edi
; Move onto write()'ing this to the file we created.
        sub     sil, _name - $$         ; 4 bytes

        mov     dl, _end - $$           ; 2 bytes

        mov     al, 1                   ; 2 bytes.
                                        ; rdi, which we get this from, is 
                                        ; 0x50000005e, we drop the higher bits
                                        ; by xchg'ing with 32bit regs.
                                        ; because edi is less than 255 we can
                                        ; just set the lower byte.
        syscall
        pop rdi
        push rbx
        add di, bin - _name
        mov         al, 59                  ; 2 bytes
; we need rdx to be zeronfor environ, and it makes a good way of getting a null
; word onto the stack
        push        rdi                     ; 1 byte
        pop         rcx                     ; 1 byte
        sub         cl, bin - argv_1    ; 3 bytes
        push        rcx                            ; 1 byte
        inc cl
        push rcx
        inc cl
        push        rcx
        push        rdi
        push        rsp                     ; 1 byte
        pop         rsi                     ; 1 byte
        xor edx, edx
        syscall
argv_0:
argv_1:
        db         "-L"
argv_2:
argv_3:
        db "binary.golf/5/5#"
bin:
        db "/bin/curl"
_end:
