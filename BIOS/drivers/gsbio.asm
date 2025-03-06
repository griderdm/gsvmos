; gsbio.asm
; PURPOSE: Driver for Generic Serial Bus

%define CTRL_READ 0
%define CTRL_WRITE 1
%define CTRL_ACK 2
%define CTRL_HS 3
%define CTRL_HSACK 4
%define CTRL_ERROR 5

serialrequest:
    byte sr_control 0
    uint sr_data 0

; Writes a control signal and value to the provided port
; Port: EAX
; Control byte: BL
; Data: ECX
serialout:
	write sr_control, bl
	write sr_data, ecx
	mov ebx, serialrequest
	out
	ret

; Reads a control signal and value from the provided port
; Stores the control value in BL and the data in ECX
; Port: EAX
serialin:
	mov ebx, serialrequest
	mov ecx, 5
	in
	read bl, sr_control
	read ecx, sr_data
	ret

; Performs a handshake on the provided port
; Port: EAX
; Control byte (OUT): BL
; Interrupt channel: ECX
serialhandshake:	
	; Send handshake and get response
	mov bl, CTRL_HS
	call serialout
	call serialin
	ret

