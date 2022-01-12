[org 0x7c00]
[bits 16]

boot:
	mov ax, 0x0003 ; al = 0x03, ah = 0x00 clears the screen
	int 0x10       ; invoke video interrupt 

	mov ah, 0x0e   ; 'Write character' interrupt code
	mov si, msg    ; Load the address of the string into SI

.loop:
	lodsb          ; load DS:SI 
	cmp al, 0      ; check for NULL terminator
	jz .done       ; ready to hang
	mov bh, 0x00   ; page number = 0
	int 0x10       ; video interrupt
	jmp .loop

.done:
	cli            ; do not allow interrupts
	hlt            ; sleep

msg:
	db "Hello, world!", 0

times 510 - ($ - $$) db 0 ; padding
dw 0xaa55                 ; boot sector signature
