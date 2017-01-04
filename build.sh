nasm -felf32 -o boot.o boot.s

/home/martin/programming/c/i386-cross-compiler/bin/i686-elf-gcc -c kernel.c foo.c -ffreestanding -std=gnu99 -Wall -Wextra


/home/martin/programming/c/i386-cross-compiler/bin/i686-elf-gcc -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o foo.o kernel.o -lgcc

cp myos.bin isodir/boot/myos.bin

grub-mkrescue -o myos.iso isodir

cp myos.iso /mnt/Projects/osdev/toyos/
