; config.asm

%include config.cfg

string cfg "SYSTEM CONFIGURATION\0"

config:
    call clearscreen
    mov eax, cfg_0
    call printline

    ; TODO: Switch keyboard interrupt to one for config

    hlt