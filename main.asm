[org 0x00010000]
[bits 32]

%define VGA_LEN (320 * 200)
%define VGA_ADDR 0x000a0000
%define COLOR_BLUE 0x1

start:
	mov ebx, VGA_ADDR 
	mov ecx, 0

.loop:
	cmp ecx, VGA_LEN 
	jz .done

	mov byte [ebx], COLOR_BLUE
	inc ebx
	inc ecx
	jmp .loop

.done:
	jmp $
