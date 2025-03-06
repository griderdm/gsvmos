; BOOTSTRAP
string noOS "Operating System Not Found\0"
bootstrap:
    mov eax, noOS_0
    int 18

    hlt
byte[435] empty {default}