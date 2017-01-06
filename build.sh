export PATH="/home/martin/programming/c/i386-cross-compiler/bin/:$PATH"

# assembler compilation
nasm -felf32 -o build/boot.o src/boot.s
nasm -felf32 -o build/assembler_utils.o src/assembler_utils.s
nasm -felf32 -o build/interrupts.o src/interrupts.s

/home/martin/programming/c/i386-cross-compiler/bin/i686-elf-gcc -c src/kernel.c src/foo.c -ffreestanding -std=gnu99 -Wall -Wextra

mv *.o build


/home/martin/programming/c/i386-cross-compiler/bin/i686-elf-gcc -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib  build/boot.o  build/interrupts.o build/assembler_utils.o  build/foo.o build/kernel.o -lgcc

cp myos.bin isodir/boot/myos.bin

grub-mkrescue -o myos.iso isodir

cp myos.iso /mnt/Projects/osdev/toyos/
