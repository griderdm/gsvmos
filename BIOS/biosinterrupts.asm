; biosinterrupts.asm

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
	
;int_keyboard:
;	jmp 0
;	ret

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