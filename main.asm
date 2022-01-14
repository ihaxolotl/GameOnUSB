[org 0x00010000]
[bits 32]

start:
	mov ebx, 0xb8000
	mov esi, msg

.loop:
	lodsb
	cmp al, 0
	jz .done

	or ax, 0x0f00
	mov word [ebx], ax
	add ebx, 2
	jmp .loop

.done:
	jmp $

align 4 
msg: db "Hello, world!", 0
