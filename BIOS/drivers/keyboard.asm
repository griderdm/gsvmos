; keyboard.asm
; PURPOSE: Keyboard driver

; Keyboard interrupt handler for the BIOS
int_keyboard:
    pusha
    mov eax, 6
    call readkeyboard

    and eax, 46
    cmp eax, 46

    popa
    jne int_keyboard_notdel
    ; If the key is delete
    call config

    int_keyboard_notdel:
        ret

; Reads a value from the keyboard and stores the result in EAX with the error in BL
readkeyboard:
    mov eax, 6
	mov ebx, serialrequest
	in

    mov ebx, 0
    read bl, sr_control
    read eax, sr_data

	ret

; Sets up the keyboard's interrupt channel
installKeyboard:
    mov al, 6
    mov ah, 17
    write sbreq, ax
    mov eax, 5
    mov ebx, sbreq
    out