; biosinfo.asm

; PURPOSE: Prints BIOS info onto the screen

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fields
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

string vers "Grider Monolithic BIOS v1.0\0"
string copyright "Copyright (C) 2019, Grider Software\0"
string delSetup "Press DEL to enter setup.\0"

string logo0 " ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ \0"
string logo1 "▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌\0"
string logo2 "▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ \0"
string logo3 "▐░▌          ▐░▌          \0"
string logo4 "▐░▌ ▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄ \0"
string logo5 "▐░▌▐░░░░░░░░▌▐░░░░░░░░░░░▌\0"
string logo6 "▐░▌ ▀▀▀▀▀▀█░▌ ▀▀▀▀▀▀▀▀▀█░▌\0"
string logo7 "▐░▌       ▐░▌          ▐░▌\0"
string logo8 "▐░█▄▄▄▄▄▄▄█░▌ ▄▄▄▄▄▄▄▄▄█░▌\0"
string logo9 "▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌\0"
string logo10 " ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀ \0"

; initial position of (0,50) in the format of (ah,al)
ushort logopos 50

ptr[11] logo {@logo0_0,@logo1_0,@logo2_0,@logo3_0,@logo4_0,@logo5_0,@logo6_0,@logo7_0,@logo8_0,@logo9_0,@logo10_0}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subroutines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Prints the BIOS name/version and copyright info onto the screen
; as well as the setup instructions
printvers:
  mov al, 0
  mov ah, 24
  call setcursor
  mov eax, delSetup_0
  call print

  mov ax, 0
  call setcursor

  mov eax, vers_0
  call printline
  mov eax, copyright_0
  call printline

  ret

drawlogo:
  mov ax, 50
  write logopos, ax
  sa logo_0, 2

  drawlogo_loop:
    cmp aei, 10
    jg drawlogo_endloop

  drawlogo_loopbody:
    ; read the logo position and set the cursor to that spot
    read ax, logopos
    call setcursor

    ; dereference the array element pointer and print the line
    deref ax, aep
    call print

    ; update the line position
    read ax, logopos
    add ah, 1
    write logopos, ax

    ; increment the logo pointer
    inca

    jmp drawlogo_loop

  drawlogo_endloop:
    mov ax, 0
    call setcursor
    ret