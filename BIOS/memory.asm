; memory.asm

; Copies the content of memory from one location to another
; AX - Destination
; BX - Source
; CX - Length
memcopy:
    ; dx is the counter
    mov edx, 0

    memcopy_loop:
        cmp edx, ecx
        jge memcopy_endloop

        push edx
        read dl, ebx
        write eax, dl
        pop edx

        add eax, 1
        add ebx, 1
        add edx, 1
        jmp memcopy_loop

    memcopy_endloop:
        ret
