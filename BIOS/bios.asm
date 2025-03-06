; bios.asm

; The first thing CPU1 does is perform a speed test
; The speed test requires 5 operations. NOP is fastest.
; I'm not going to use a loop because the jump instructions
; would count towards the operation count.
nop
nop
nop
nop
nop

; Next, the computer needs to jump to the entry point.
; The main function is going to get stuck at the end of all the includes.
jmp main

%include drivers\video.asm
%include idt.asm
%include drivers\gsbio.asm
%include drivers\keyboard.asm
%include biosinterrupts.asm
%include biosinfo.asm
%include POST\post.asm
%include memory.asm
%include boot.asm
%include config.asm

string inttest "INTTEST\0"
string inttesx "        "

ushort sbreq 0

main:
    ; INITIALIZATION
    ; setup video memory
    mov svm, VIDEO
  
    ; setup interrupt table
    call init_idt
    call initbiosidt

    ; install keyboard
    call installKeyboard    
    
    ; Draw the screen
    call drawlogo
    call printvers
    call newline

    ; Begin POST
    call post

    ; Boot disk
    mov eax, 100
    call delay
    jmp boot

    hlt