; BOOTSTRAP
; This section MUST BE 486 bytes long
; Each instruction is 8 bytes
; MAXIMUM of 60 instructions

; The OS is at address 10240
; Let's make a pointer to a 512 byte segment of memory after this boot sector
;   where we can load the first sector of the file table
ptr filetable 10752
; Then another one where we can load the boot file
%define BOOTFILE 11264
uint32 bootfile_ptr 11264

uint32 bootfile_address 0
uint16 bootfile_length 0

bootstrap:
    popa

    ; first, let's load the file table
    ; it's located at address 512 on the disk
    ; we'll use interrupt 24
    ; The disk should be on port 2  (we'll grab the actual disk port later)
    mov eax, 2
    mov ebx, 512
    mov ecx, 512
    deref edx, filetable
    int 24

    ; we're also going to assume that boot.sys is the first file in the table
    ; so let's grab the file's location and its length
    mov ebx, 0
    mov ecx, 0
    deref edx, filetable
    add edx, 28
    read bx, edx
    mult ebx, 512
    write bootfile_address, ebx
    add edx, 2
    read cx, edx
    write bootfile_length, cx

    ; next, we're going to begin to load the file into memory
    read_bootfile:
        read ebx, bootfile_address
        read cx, bootfile_length

        ; Check if we're done loading the file
        cmp cx, 0
        je read_done

        ; Check if the file length remaining is greater than 512. If it's not, load the sector
        cmp cx, 512
        jle loadsector

        ; If it is, set CX to a full sector length
        mov cx, 512
        
        ; Load the sector
        loadsector:
            mov eax, 2
            read edx, bootfile_ptr
            int 24

            ; Increment the address and decrement the length
            add ebx, cx
            write bootfile_address, ebx
            mov ebx, 0
            read bx, bootfile_length
            sub bx, cx
            write bootfile_length, bx
            read edx, bootfile_ptr
            add edx, cx
            write bootfile_ptr, edx
            jmp read_bootfile

        read_done:
            jmp BOOTFILE

byte[178] empty {default}
;byte[486] empty {default}