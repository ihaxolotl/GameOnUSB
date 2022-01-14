[org 0x7c00]
[bits 16]

boot:
	cli
	cld

	mov [drive], dl

	; set the important segment registers
	; we cannot assume which values are stored
	xor ax, ax 
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov bp, 0x7c00 ; set up the stack
	mov sp, bp     ; 0x1000 to 0x7c00 will be our stack space 
	sti

	mov ax, 0x0003
	int 0x10

.read_kernel:
	mov ax, KERNEL_ADDR
	mov es, ax
	mov bx, 0x0
	mov ax, 0x0264  ; ah = read mode (2), al = number of sectors to read (100)
	mov cx, 0x0002  ; ch = cylinder index (0), cl = sector index (2)
	mov dl, [drive]
	mov dh, 0x0     ; head index
	int 0x13        ; interrupt for disk operations

.enable_a20:
	in al, 0x92  ; check if the A20 line has already been enabled
	test al, 0x2 ; if A20 is enabled, skip trying to enable it.
	jnz .enter_protected_mode 

	or al, 0x2   
	and al, 0xfe
	out 0x92, al ; enable the A20 line

.enter_protected_mode:
	cli
	lgdt [gdt_desc]

	mov eax, cr0
	or eax, 0x1
	mov cr0, eax

	jmp CODE_SEGMENT:start32

[bits 32]
start32:
	mov ax, DATA_SEGMENT
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax

	jmp KERNEL_START 

align 16
gdt_desc:				; gdt descriptor (48 bits)
dw gdt_end - gdt32 - 1	; limit of GDT (size minus one)
dd gdt32				; linear address of GDT

gdt32:
null_desc: dw 0x0000, 0x0000, 0x0000, 0x0000 ; null desciptor
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
