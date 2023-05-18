VERSION = 1.0.0

build: clean
	-mkdir build
	-mkdir out
	-mkdir build/isodir
	-mkdir build/isodir/boot
	-mkdir build/isodir/boot/grub
	nasm -f elf32 boot.s -o build/boot.o
#	nasm -f elf32 kmain.s -o build/kmain.o
	i686-elf-gcc -c kmain.c -o build/kmain.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
	i686-elf-gcc -T link.ld -o build/kernel -ffreestanding -O2 -nostdlib build/boot.o build/kmain.o
	cp build/kernel build/isodir/boot/kernel
	cp grub.cfg build/isodir/boot/grub/grub.cfg
	grub-mkrescue -o out/kernel-${VERSION}.iso build/isodir

run: build
	qemu-system-x86_64 -cdrom out/kernel-${VERSION}.iso

clean:
	-rm -rf build
	-rm -rf out