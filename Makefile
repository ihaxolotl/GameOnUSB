# The epic Makefile

AS = nasm
CC = gcc
CFLAGS = -O2 -m32 -ffreestanding \
		 -fno-stack-protector \
		 -fno-pie \
		 -nostdlib \
		 -std=c11 \
		 -Wall \
		 -Wextra \
		 -Werror \
		 -pedantic

EMU = qemu-system-i386
EMUFLAGS = -vga std -boot d -m 4096 -hda game.img #-enable-kvm -cpu host

all = game.img

game.img: boot.bin main.bin
	cat $^ > game.bin && \
	dd if=/dev/zero of=game.img bs=512 count=2880 && \
	dd if=game.bin of=game.img seek=0 conv=notrunc

boot.bin: boot.asm
	$(AS) -f bin -o $@ $^

main.bin: main.o graphics.o entry.o
	$(CC) $(CFLAGS) -T linker.ld -o $@ $^

main.o: main.c
	$(CC) $(CFLAGS) -c $^

graphics.o: graphics.c graphics.h
	$(CC) $(CFLAGS) -c $<

entry.o: entry.asm
	$(AS) -f elf32 -o $@ $^

run:
	$(EMU) $(EMUFLAGS)

debug:
	$(EMU) $(EMUFLAGS) -S -s

.PHONY: clean

clean:
	rm -f *.o *.bin *.iso *.img *.gch
