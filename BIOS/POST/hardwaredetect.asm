; hardwaredetect.asm
; Detects attached hardware and registers it with the BIOS.

; List of device types, one for each possible device
ushort[32] deviceType {default}
; List of device 
ushort[32] deviceID {default}
; List of interrupt channels, one for each possible device
uint[32] interruptChannel {default}
; Last used IDT
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

    ; Initialize the array manager
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

; EAX - hardware port
hwhs:
    ; Clear the registers
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

        ; Check if handshake acknowledged (HSACK)
        cmp bl, 4
        ; If it failed, increment the interrupt and try again.
        jne hwhs_prep
        ; Otherwise, store the data and then move to next device
        call storehw
        jmp hwhs_end

    hwhs_idtErr:
        mov edx, 555
    
    hwhs_end:
        read ecx, lastIDT
        add ecx, 1
        write lastIDT, ecx
        ret

; Device Port: EAX
; Device Type: CX
; Device ID: CX << 3
; Interrupt Port: lastIDT
storehw:
    push eax
    mov eax, detected_0_0
    call print
    pop eax

    ; Store device type
    write aep, cx

    ; Print device type
    sa deviceTypes_0, 2
    sai cx
    push eax
    deref eax, aep
    call print
    pop eax
    
    ; Store device ID
    sa deviceID_0
    sai eax
    ls ecx, 16
    write aep, cx

    ; Print device ID
    push eax
    mov eax, 0
    mov ax, cx
    call printdec
    pop eax

    ; Print device port
    push eax
    mov eax, detected_1_0
    call print
    pop eax
    call printdec
    push eax
    mov eax, detected_2_0
    call print
    pop eax

    ; Store device interrupt
    sa interruptChannel_0
    sai eax
    read ecx, lastIDT
    write aep, ecx

    ; Print interrupt
    push eax
    mov eax, 0
    mov ax, cx
    call printdec
    pop eax
    call printline

    ret