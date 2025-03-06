; memorycheck.asm

%define FLAG_MEMERR 32

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fields
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

int m_col 0
int m_row 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

memorycheck:
    read eax, vidCol
    write m_col, eax
    read eax, vidRow
    write m_row, eax

    mov eax, 0

    ; Start loop
    memorycheck_loop:
        mov ebx, flags
        and ebx, FLAG_MEMERR
        cmp ebx, FLAG_MEMERR
        je memorycheck_endloop

        read bl, ax

        ; print value
        push eax
        mod ax, 16
        cmp ax, 0
        pop eax
        jne memorycheck_endif
        
        push eax
        read eax, m_col
        write vidCol, eax
        read eax, m_row
        write vidRow, eax
        pop eax
        call printdec

        memorycheck_endif:
            add eax, 1

            ; Check if overflow
            ; 16-bit addresses only hold 0-65535
            cmp eax, 65535
            jg memorycheck_endloop

            jmp memorycheck_loop
        
    memorycheck_endloop:
        push eax
        read eax, m_col
        write vidCol, eax
        read eax, m_row
        write vidRow, eax
        pop eax
        ret
