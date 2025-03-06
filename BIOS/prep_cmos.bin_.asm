nop
nop
nop
nop
nop
jmp main
int vidCol 0
int vidRow 0
byte[10] buffer {default}

setcursor:
write vidCol, al
write vidRow, ah
ret

getcursor:
push ecx
read ebx, vidRow
mult ebx, 80
read ecx, vidCol
add ebx, ecx
add ebx, svm
pop ecx
ret

inccursor:
push edx
read edx, vidCol
add edx, 1
write vidCol, edx
cmp edx, 80
jl inccursor_endif
call newline

inccursor_endif:
pop edx
ret

printc:
pusha
call getcursor
write ebx, al
add ebx, 1
call inccursor
popa
ret

print:
pusha
call getcursor

printloop:
read cl, eax
cmp cl, 0
je printloop_end
write ebx, cl
add eax, 1
add ebx, 1
call inccursor
jmp printloop

printloop_end:
popa
ret

printline:
call print
call newline
ret

newline:
push eax
mov eax, 0
write vidCol, eax
read eax, vidRow
add eax, 1
write vidRow, eax
cmp eax, 25
jne newline_endif
call clearscreen

newline_endif:
pop eax
ret

clearscreen:
pusha
mov eax, svm
mov ecx, 0

clearscreenloop:
cmp ecx, 2000
jge clearscreenloop_end
mov bl, 0
write eax, bl
add eax, 1
add ecx, 1
jmp clearscreenloop

clearscreenloop_end:
mov ax, 0
call setcursor
popa
ret

printdec:
pusha
mov ebx, 0
mov ecx, buffer_0
cmp eax, 0
je print_zero

printdec_loop1:
mov edx, eax
mod edx, 10
div eax, 10
add edx, 48
write ecx, dl
add ecx, 1
add ebx, 1
cmp eax, 0
jne printdec_loop1

printdec_loop2:
sub ebx, 1
sub ecx, 1
read al, ecx
call printc
cmp ebx, 0
jne printdec_loop2
jmp print_end

print_zero:
mov al, 48
call printc

print_end:
popa
ret
ushort[256] __idt {default}

init_idt:
mov idt, __idt_0
ret

set_idt:
pusha
mov ecx, idt
mult ax, 2
add ecx, ax
write ecx, ebx
popa
ret

serialrequest:
byte sr_control 0
uint sr_data 0

serialout:
write sr_control, bl
write sr_data, ecx
mov ebx, serialrequest
out
ret

serialin:
mov ebx, serialrequest
mov ecx, 5
in
read bl, sr_control
read ecx, sr_data
ret

serialhandshake:
mov bl, 3
call serialout
call serialin
ret

int_keyboard:
pusha
mov eax, 6
call readkeyboard
and eax, 46
cmp eax, 46
popa
jne int_keyboard_notdel
call config

int_keyboard_notdel:
ret

readkeyboard:
mov eax, 6
mov ebx, serialrequest
in
mov ebx, 0
read bl, sr_control
read eax, sr_data
ret

installKeyboard:
mov al, 6
mov ah, 17
write sbreq, ax
mov eax, 5
mov ebx, sbreq
out

int_unused:
ret

int_divByZero:
hlt
ret

int_trapFlag:
brk
ret

int_nmi:
ret

int_breakpoint:
ret

int_overflow:
ret

int_bounds:
ret

int_invalidOpcode:
ret

int_doubleFault:
ret

int_stackFault:
ret

int_generalProtectionFault:
ret

int_pageFault:
ret

int_mathFault:
ret

int_print:
call print
ret

int_printline:
call printline
ret

int_newline:
call newline
ret

int_clearscreen:
call clearscreen
ret

int_serialout:
call serialout
ret

int_serialin:
call serialin
ret

int_readdisk:
call readdisk
ret
ptr[25] biosidt {@int_divByZero,@int_trapFlag,@int_nmi,@int_breakpoint,@int_overflow,@int_bounds,@int_invalidOpcode,@int_unused,@int_doubleFault,@int_unused,@int_unused,@int_unused,@int_stackFault,@int_generalProtectionFault,@int_pageFault,@int_unused,@int_mathFault,@int_keyboard,@int_print,@int_printline,@int_newline,@int_clearscreen,@int_serialout,@int_serialin,@int_readdisk}

initbiosidt:
mov al, 0
mov ecx, biosidt_0

copyidt:
read ebx, ecx
call set_idt
add al, 1
add ecx, 2
cmp al, 25
jl copyidt
ret
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
ushort logopos 50
ptr[11] logo {@logo0_0,@logo1_0,@logo2_0,@logo3_0,@logo4_0,@logo5_0,@logo6_0,@logo7_0,@logo8_0,@logo9_0,@logo10_0}

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
read ax, logopos
call setcursor
deref ax, aep
call print
read ax, logopos
add ah, 1
write logopos, ax
inca
jmp drawlogo_loop

drawlogo_endloop:
mov ax, 0
call setcursor
ret
int m_col 0
int m_row 0

memorycheck:
read eax, vidCol
write m_col, eax
read eax, vidRow
write m_row, eax
mov eax, 0

memorycheck_loop:
mov ebx, flags
and ebx, 32
cmp ebx, 32
je memorycheck_endloop
read bl, ax
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

dskreq:
byte dr_read 0
uint dr_address 0
uint dr_length 0
byte[512] dr_data {default}

readdisk:
write dr_read, 0
write dr_address, ebx
write dr_length, ecx
mov ebx, dskreq
mov ecx, 9
out
mov ecx, 521
in
mov eax, edx
mov ebx, dr_data_0
read ecx, dr_length
call memcopy
ret

delay:
mov ebx, 0

delay_loop:
cmp ebx, eax
jge delay_endloop
add ebx, 1
jmp delay_loop

delay_endloop:
ret
ushort[32] deviceType {default}
ushort[32] deviceID {default}
uint[32] interruptChannel {default}
uint lastIDT 25
string detectingDevices "Detecting devices...\0"
string gsb "Generic Serial Bus (\0"
string sb "Southbridge Controller (\0"
string hdd "Disk (\0"
string kb "Keyboard (\0"
ptr[4] deviceTypes {@gsb_0,@sb_0,@hdd_0,@kb_0}
string detected_0 "Detected \0"
string detected_1 ") on port \0"
string detected_2 ", IDT channel \0"

detect:
mov eax, detectingDevices_0
call printline
sa deviceType_0, 2

detect_loop:
cmp aei, 32
jg detect_endloop
call hwhs
cmp edx, 555
je detect_endloop
inca
jmp detect_loop

detect_endloop:
ret

hwhs:
mov eax, 0
mov ebx, 0
mov ecx, 0
mov edx, 0
mov eax, aei
read ecx, lastIDT
jmp hwhs_loop

hwhs_prep:
read ecx, lastIDT
add ecx, 1
write lastIDT, ecx
cmp ecx, 256
je hwhs_idtErr

hwhs_loop:
call serialhandshake
cmp bl, 4
jne hwhs_prep
call storehw
jmp hwhs_end

hwhs_idtErr:
mov edx, 555

hwhs_end:
read ecx, lastIDT
add ecx, 1
write lastIDT, ecx
ret

storehw:
push eax
mov eax, detected_0_0
call print
pop eax
write aep, cx
sa deviceTypes_0, 2
sai cx
push eax
deref eax, aep
call print
pop eax
sa deviceID_0
sai eax
ls ecx, 16
write aep, cx
push eax
mov eax, 0
mov ax, cx
call printdec
pop eax
push eax
mov eax, detected_1_0
call print
pop eax
call printdec
push eax
mov eax, detected_2_0
call print
pop eax
sa interruptChannel_0
sai eax
read ecx, lastIDT
write aep, ecx
push eax
mov eax, 0
mov ax, cx
call printdec
pop eax
call printline
ret
string processor "Main Processor: \0"
string memorytest "Memory Testing: \0"
string ok " bytes OK\0"

post:
mov eax, processor_0
call print
call printcpuid
call newline
mov eax, memorytest_0
call print
call memorycheck
call printdec
mov eax, ok_0
call printline
call newline
mov eax, 15000
call delay
call clearscreen
call detect
mov eax, 15000
call delay
call clearscreen
ret

printcpuid:
call getcursor
push ebx
mov eax, 0
cpuid
pop eax
write eax, ebx
add eax, 4
write eax, ecx
add eax, 4
write eax, edx
add eax, 4
push eax
mov eax, 1
cpuid
pop eax
write eax, ebx
add eax, 4
write eax, ecx
add eax, 4
write eax, edx
add eax, 4
ret

memcopy:
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

boot:
mov eax, 0
read eax, bootDiskPort
mov ebx, 0
mov ecx, 512
mov edx, 10240
call readdisk
jmp 10240

BOOTCONFIG:
uint bootDiskPort 2
string cfg "SYSTEM CONFIGURATION\0"

config:
call clearscreen
mov eax, cfg_0
call printline
hlt
string inttest "INTTEST\0"
string inttesx "        "
ushort sbreq 0

main:
mov svm, 8192
call init_idt
call initbiosidt
call installKeyboard
call drawlogo
call printvers
call newline
call post
mov eax, 100
call delay
jmp boot
hlt
