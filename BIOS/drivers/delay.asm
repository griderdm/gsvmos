; delay.asm

; EAX - number of cycles to delay
delay:
    mov ebx, 0

    delay_loop:
        cmp ebx, eax
        jge delay_endloop

        add ebx, 1
        jmp delay_loop

    delay_endloop:
        ret
