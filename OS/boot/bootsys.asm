; Offset to the OS position
%pragma offset 11264

jmp bootstrap

string noOS "Welcome to GSVMOS\0"
bootstrap:
    mov eax, noOS_0
    int 18

    hlt
