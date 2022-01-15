[bits 32]
[extern main]

section .entry
global _start
_start:
	mov esp, stack_bottom
	mov ebp, esp
	call main
	hlt

section .bss
stack_bottom: equ $
	resb 16 * 1024 ; allocate 16KB for stack space
stack_end:
