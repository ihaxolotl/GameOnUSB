; boot.asm
; MBR bootloader for the game.

[org 0x7c00]
[bits 16]

%include "vesa.asm"
%define STACK_16 0x7c00 ; 0x6c00 - 0x7c00 (4KB) will be our stack space

; boot prepares the segment registers and real mode stack to be used
; by the boot loader.
boot:
	cli
	cld

	mov [drive], dl ; The BIOS stores the drive number in dl.

	; Set the important segment registers; we cannot assume the state of 
	; these registers at startup. 
	xor ax, ax 
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	mov bp, STACK_16
	mov sp, bp
	sti

; enable_a20 enables the A20 address line. If the A20 line has already been
; enabled, skip to setting up VBE.
enable_a20:
	in al, 0x92
	test al, 0x2
	jnz setup_vbe

	or al, 0x2
	and al, 0xfe
	out 0x92, al

; setup_vbe attempts to find and set an SVGA mode that matches a height, width
; and stride. First the BIOS is queried for the VBEInfoBlock structure, which
; contains a far pointer to a list of VESA modes supported by the graphics card.
; Each entry in this list is checked to see if it meets the the requirements;
; if so, set it. If the end of the list is reached, the code panics.
setup_vbe:
	; Clear the screen
	mov ax, 0x0003
	int 0x10

	push es ; Some VESA BIOSes clobber ES.
	mov ax, VESA_GET_INFO
	mov di, VBEInfoBlock
	int 0x10
	pop es

	cmp ax, VESA_OK
	jne panic

	mov ax, word [VBEInfoBlock.VideoModePtr]
	mov si, ax

	mov ax, word [VBEInfoBlock.VideoModePtr + 2]
	mov es, ax

.find_mode:
	mov dx, word [es:si]
	cmp word dx, VESA_INFO_END
	je .error

	; Get SVGA mode information.
	push es
	mov ax, VESA_GET_MODE_INFO
	mov cx,  dx
	mov di, VBEModeInfoBlock
	int 0x10
	pop es

	cmp ax, VESA_OK
	jne panic

	mov ax, VESA_MODE_WIDTH
	cmp ax, [VBEModeInfoBlock.XResolution]
	jne .next_mode

	mov ax, VESA_MODE_HEIGHT
	cmp ax, [VBEModeInfoBlock.YResolution]
	jne .next_mode

	mov al, VESA_MODE_BITS
	cmp al, [VBEModeInfoBlock.BitsPerPixel]
	jne .next_mode

	; Set SVGA mode.
	push es
	mov ax, VESA_SET_MODE
	mov bx, cx
	or bx, 0x4000 ; Set bit 14 (enable linear frame buffer)
	mov di, 0
	int 0x10
	pop es
	
	cmp ax, VESA_OK
	jne .error

	jmp read_kernel
.next_mode:
	add si, 2
	jmp .find_mode
.error:
	mov si, vga_error_msg
	call print16
	jmp panic

; read_kernel reads the disk and loads the kernel code into physical memory.
; For now, the kernel is limited in size, but soon it will be loaded at a
; much higher address (0x00100000).
read_kernel:
	mov ax, KERNEL_ADDR
	mov es, ax
	mov bx, 0x0
	mov ax, 0x0264  ; ah = read mode (2), al = number of sectors to read (100)
	mov cx, 0x0002  ; ch = cylinder index (0), cl = sector index (2)
	mov dl, [drive]
	mov dh, 0x0     ; head index
	int 0x13 

; enter_protected_mode performes the required operations to enable protected-mode.
; Disable interrupts, load the global descriptor table, set the protected-mode
; bit in cr0 and jump into protected mode.
enter_protected_mode:
	cli
	lgdt [gdt_desc]

	mov eax, cr0
	or eax, 0x1
	mov cr0, eax

	jmp CODE_SEGMENT:start32

print16:
	mov ah, 0x0e
.loop:
	lodsb
	cmp al, 0
	jz .done
	int 0x10
	jmp .loop
.done:
	ret

; panic is halts the computer's execution. It doesn't print anything, so this
; state would only be detected by a debugger.
panic:
	mov si, panic_msg
	call print16
	hlt	
	jmp $

[bits 32]
; start32 prepares the protected mode registers to start the "kernel".
start32:
	mov ax, DATA_SEGMENT
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax

	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	xor esp, esp
	xor ebp, ebp
	xor esi, esi
	xor edi, edi

	jmp KERNEL_START 

align 16
gdt_desc:              ; gdt descriptor (48 bits)
dw gdt_end - gdt32 - 1 ; limit of GDT (size minus one)
dd gdt32               ; linear address of GDT

gdt32:                                       ; 32-bit global descriptor table
null_desc: dw 0x0000, 0x0000, 0x0000, 0x0000 ; null descriptor
code_desc: dw 0xFFFF, 0x0000, 0x9A00, 0x00CF ; code descriptor
data_desc: dw 0xFFFF, 0x0000, 0x9200, 0x00CF ; data descriptor
gdt_end:

drive:  db 0x00
panic_msg:     db "Panic!", 0xd, 0xa, 0
vga_error_msg: db "SVGA mode not supported!", 0xd, 0xa, 0

CODE_SEGMENT equ code_desc - gdt32
DATA_SEGMENT equ data_desc - gdt32
KERNEL_ADDR equ 0x1000
KERNEL_START equ 0x10000

times 510 - ($ - $$) db 0 ; padding
dw 0xaa55                 ; boot sector signature
