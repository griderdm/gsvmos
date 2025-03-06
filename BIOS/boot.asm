; boot.asm

%define _OS_ 10240

boot:
    mov eax, 0
    read eax, bootDiskPort
    mov ebx, 0
    mov ecx, 512
    mov edx, _OS_
    
    call readdisk

    jmp _OS_