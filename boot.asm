[org 0x7c00]
[bits 16]


boot:
	; al = 0x13, ah = 0x00 sets the graphics mode to 320x200
	; allowing for 8-bit color.
	mov ax, 0x0013
	int 0x10

	mov cx, 0
	mov ax, 0x0c01
	mov bx, 0x00

; paint the whole screen blue
.paint_blue:
	cmp cx, 0xfa00 ; 320x200
	mov dx, cx     ; cx = dx
	int 0x10

	inc cx
	jmp .paint_blue

.done:
	cli            ; do not allow interrupts
	hlt            ; sleep

times 510 - ($ - $$) db 0 ; padding
dw 0xaa55                 ; boot sector signature
