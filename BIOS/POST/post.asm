; post.asm

%include POST\memorycheck.asm
%include drivers\disk.asm
%include drivers\delay.asm
%include POST\hardwaredetect.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fields
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

string processor "Main Processor: \0"
string memorytest "Memory Testing: \0"
string ok " bytes OK\0"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

post:
    ; Print processor info
    mov eax, processor_0
    call print
    call printcpuid
    call newline

    ; Begin memory check
    mov eax, memorytest_0
    call print
    call memorycheck
    call printdec
    mov eax, ok_0
    call printline
    
    call newline

    ; Check for bootable disks
    ;call bootcheck

    mov eax, 15000
    call delay
    call clearscreen

    ; TODO: Setup devices
    ; Check for hardware
    call detect

    mov eax, 15000
    call delay
    call clearscreen
    
    ret

printcpuid:
    ; get the cursor address and put it in EBX. We'll put it in EAX later
    call getcursor
    push ebx

    ; Get the CPU name
    mov eax, 0
    cpuid

    ; Get the cursor address again
    pop eax

    ; Print the CPU name
    write eax, ebx
    add eax, 4
    write eax, ecx
    add eax, 4
    write eax, edx
    add eax, 4

    ; Save the cursor address
    push eax
    
    ; Get the CPU speed
    mov eax, 1
    cpuid
    
    ; Get the cursor address
    pop eax
    write eax, ebx
    add eax, 4
    write eax, ecx
    add eax, 4
    write eax, edx
    add eax, 4

    ret
