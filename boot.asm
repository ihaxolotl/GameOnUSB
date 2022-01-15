; boot.asm
; MBR bootloader for the game.

[org 0x7c00]
[bits 16]

%define VGA_OK 0x004F   ; return code of a successful SVGA interupt
%define VGA_MODE 0x4118 ; 1024x768x24bit
%define STACK_16 0x7c00 ; 0x6c00 - 0x7c00 (4KB) will be our stack space

; boot prepares the cpu state.
boot:
	cli
	cld

	; The BIOS stores the drive number in dl, so it makes sense to save it.
	mov [drive], dl 

	; Set the important segment registers; we cannot assume the state of 
	; these registers at startup. 
	xor ax, ax 
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov bp, STACK_16
	mov sp, bp
	sti

; enable_a20 enables the A20 address line. If the A20 line has already been
; enabled, skip it and jump to setting up VBE. 
.enable_a20:
	in al, 0x92
	test al, 0x2
	jnz .setup_vbe

	or al, 0x2
	and al, 0xfe
	out 0x92, al 

; setup_vbe gets the required VBE information and sets the desired SVGA mode.
; If the SVGA mode is not supported by the BIOS, the loader will panic.
.setup_vbe:
	; Get SVGA mode information.
	mov di, VBEModeInfoBlock 
	mov ax, 0x4F01
	mov cx, VGA_MODE
	mov bx, cx
	int 0x10

	cmp ax, VGA_OK 
	jne panic

	; Check the bits-per-pixel in the VBE info block.
	cmp byte [VBEModeInfoBlock.BitsPerPixel], 24
	jne panic
 
	; Set SVGA mode.
	or bx, 0x4000 ; Set bit 14 (enable linear frame buffer)
	mov ax, 0x4f02
	int 0x10
	
	cmp ax, VGA_OK
	jne panic 

; read_kernel reads the disk and loads the kernel code into physical memory.
; For now, the kernel is limited in size, but soon it will be loaded at a
; much higher address (0x00100000).
.read_kernel:
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
.enter_protected_mode:
	cli
	lgdt [gdt_desc]

	mov eax, cr0
	or eax, 0x1
	mov cr0, eax

	jmp CODE_SEGMENT:start32

; panic is halts the computer's execution. It doesn't print anything, so this
; state would only be detected by a debugger.
panic:
	hlt	
	jmp $

[bits 32]
start32:
	; Set all segment registers to be the offset of the data descriptor
	; in the global offset table.
	mov ax, DATA_SEGMENT
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax

	; Reset all general purpose registers.
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	xor esp, esp
	xor ebp, ebp
	xor esi, esi
	xor edi, edi

	; Jump into kernel space.
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

drive: db 0x00

CODE_SEGMENT equ code_desc - gdt32
DATA_SEGMENT equ data_desc - gdt32
KERNEL_ADDR equ 0x1000
KERNEL_START equ 0x10000

times 510 - ($ - $$) db 0 ; padding
dw 0xaa55                 ; boot sector signature

; 0x5c00 is an arbitrary address in free memory which will store the VESA BIOS
; Extensions mode information structure. 
VBEModeInfoBlock: equ 0x5c00
VBEModeInfoBlock.BitsPerPixel equ VBEModeInfoBlock + 25 ; byte  - bits per pixel
VBEModeInfoBlock.FrameBuffer  equ VBEModeInfoBlock + 40 ; dword - physical address for linear frame buffer
