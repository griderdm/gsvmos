; idt.asm
; Interrupt descriptor table
; https://en.wikipedia.org/wiki/Interrupt_descriptor_table

ushort[256] __idt {default}

; Initializes the IDT
init_idt:
	mov idt, __idt_0
	ret
	
; Sets an IDT value.
; AL - interrupt to set
; EBX - address to set it to
set_idt:
	pusha
	mov ecx, idt
	mult ax, 2
	add ecx, ax
	write ecx, ebx
	popa
	ret
	