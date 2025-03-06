;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; BOOT SECTOR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
bootsector:
jmp bootstrap
string volumelabel VOLUMELABEL
string fsLabel "VMFS1\0\0\0"
; BOOTSTRAP
%include OS\bootstrap.asm
;%include OS\noboot.asm
ushort sig 47974