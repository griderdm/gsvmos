; disk.asm
; Disk driver

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fields
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Disk Request Structure
dskreq:
	byte dr_read 0
	uint dr_address 0
	uint dr_length 0
	byte[512] dr_data {default}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Sets up the disk request
; EAX - Port
; EBX - Disk Address
; ECX - Length
; EDX - Memory Address
readdisk:
	; Preps the request
	write dr_read, 0
	write dr_address, ebx
	write dr_length, ecx

	; Send the disk request
	mov ebx, dskreq
	mov ecx, 9
	out

	; Get the requested data
	mov ecx, 521
	in

	; Copy the data to the destination with memcopy
	mov eax, edx
	mov ebx, dr_data_0
	read ecx, dr_length
	call memcopy

	ret