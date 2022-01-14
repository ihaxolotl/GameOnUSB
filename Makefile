# The epic Makefile

AS = nasm
QEMU = qemu-system-i386
QEMUFLAGS = -vga std -boot c -m 256 -fda game.img #-enable-kvm -cpu host

all = game.img

game.img: boot.bin main.bin
	cat $^ > game.img

boot.bin: boot.asm
	$(AS) -f bin -o boot.bin boot.asm

main.bin: main.asm
	$(AS) -f bin -o main.bin main.asm

run:
	$(QEMU) $(QEMUFLAGS) 

debug:
	$(QEMU) $(QEMUFLAGS) -S -s

.PHONY: clean

clean:
	rm -f *.o *.bin *.iso *.img
