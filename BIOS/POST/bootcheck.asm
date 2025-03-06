; bootcheck.asm
; Purpose: Queries the disk controller for operating disk drives

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fields
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; One boolean for each disk
int[5] workingDisks {default}
int diskCount 0

string detecting "Detecting disks...\0"
string drive0 "Disk 0 (CMOS)\0"
string drive1 "Disk 1\0"
string drive2 "Disk 2\0"
string drive3 "Disk 3\0"
string drive4 "Disk 4\0"
string noboot "!!! NO BOOT DISK DETECTED !!!\0"

ptr[5] drives {@drive0_0,@drive1_0,@drive2_0,@drive3_0,@drive4_0}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Checks how many disks are working
bootcheck:
    mov eax, detecting_0
    call printline

    ; EAX - working register
    ; EBX - stores current array index

    mov eax, 0
    mov ebx, 0

    sa workingDisks_0, 4

    bootcheck_loop:
        cmp aei, 5
        jge bootcheck_endloop

        mov ebx, aei
        sa workingDisks_0, 4
        sai ebx

        ; Handshake the drive. The handshake return is placed in EAX and should be 254.
        mov ebx, aei
        mov eax, ebx
        pusha
        call handshake
        cmp eax, 254
        popa
        jne bootcheck_loop_endif

        ; If the handshake is successful, count the drive
        read ax, diskCount
        add ax, 1
        write diskCount, ax

        ; Then mark the drive as working
        mov eax, 1
        write aep, eax
        
        ; Then print the drive to the screen
        ; -- Set up a new array iterator
        sa drives_0, 2
        ; -- Set the index
        sai ebx
        ; -- Print the drive
        deref eax, aep
        pusha
        call printline
        popa

        bootcheck_loop_endif:
            ; Increment pointers
            inca
            jmp bootcheck_loop

        bootcheck_endloop:
            mov eax, 0
            read ax, diskCount
            cmp ax, 1

            jg bootcheck_endif2

            ; If the disk count is zero
            call newline
            mov eax, noboot_0
            call printline
            hlt

            bootcheck_endif2:
                ret
        