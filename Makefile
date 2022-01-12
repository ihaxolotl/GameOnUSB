# The epic Makefile

AS = nasm
QEMU = qemu-system-x86_64

all = boot.bin

boot.bin: boot.asm
	$(AS) -f bin -o boot.bin boot.asm

run:
	$(QEMU) -drive format=raw,file=boot.bin -vga std

.PHONY: clean

clean:
	rm -f *.o *.bin *.iso *.img
