; video.asm
; Basic video output driver

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Definitions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%define VIDEO 8192

%define COLS 80
%define ROWS 25

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fields
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

int vidCol 0
int vidRow 0
byte[10] buffer {default}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subroutines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Moves the cursor to the location {AL, AH}
; AL - Column (horizontal)
; AH - Row (vertical)
setcursor:
  write vidCol, al
  write vidRow, ah
  ret

; Gets the current cursor position as a pointer and stores it in EBX
; NOTE: This subroutine IS NOT register-safe. It modifies EBX.
getcursor:
  push ecx
  ; EBX is the write address. We have to calculate it.
  ; Start by multiplying the row by the columns per row
  read ebx, vidRow
  mult ebx, COLS
  
  ; Next add the current column
  read ecx, vidCol
  add ebx, ecx
  
  ; Lastly, add the shared video memory address
  add ebx, svm
  pop ecx
  ret

; Increments the cursor, and creates a new line if nessesary
inccursor:
  push edx
  ; Update the column
  read edx, vidCol
  add edx, 1
  write vidCol, edx
  ; Check if we've reached the end of the line
  cmp edx, COLS
  jl inccursor_endif
  call newline
  inccursor_endif:
    pop edx
    ret
  
; Prints the provided character to the current cell
; AL - Literal character to print
printc:
  pusha
  
  ; EBX is the write address
  call getcursor
  
  ; Write the character to memory
  write ebx, al
  
  ; This looks like it increments the pointer. Do I really need this?!
  ; TODO: Test to see if this line is nesessary
  add ebx, 1

  ; Increment the cursor
  call inccursor
  
  popa
  ret

; Prints the provided c-string
; EAX - Address of the first character of the string
print:
  pusha
  ; EBX is the write address
  call getcursor

  printloop:
    ; Read the first
    read cl, eax
    cmp cl, 0
    je printloop_end

    ; write to video memory
    write ebx, cl

    ; increment pointers
    add eax, 1
    add ebx, 1
    call inccursor

    jmp printloop

  printloop_end:
    popa
    ret

; Prints the provided c-string followed by a line break
; EAX - Address of the first character of the string
printline:
  call print
  call newline
  ret

; Prints a line feed and a carriage return
newline:
  push eax
  mov eax, 0
  write vidCol, eax
  read eax, vidRow
  add eax, 1
  write vidRow, eax
  
  cmp eax, ROWS
  jne newline_endif
  call clearscreen

  newline_endif:
  pop eax
  ret


; Clears the screen
clearscreen:
  pusha

  ; EBX is the write address
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

; Print EAX to the screen as a decimal integer
printdec:
  pusha

  ; EBX is the counter
  mov ebx, 0

  ; ECX is the buffer pointer
  mov ecx, buffer_0

  ; DL is the digit/character
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
