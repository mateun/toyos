#include <stddef.h>
#include <stdint.h>

void foo();
void _assfoo();
void initInterrupts();
void printk();
void printkc();
void moveCursor();

void kernel_start(void) {
	initInterrupts();

	// write a letter to videomemory
	//uint16_t *vidmem = (uint16_t*) 0xB8004;
	//vidmem[0] = 0x449;
	//printkc('T');

	printConsolePrompt(0);
	printConsolePrompt(1);
	printConsolePrompt(2);
	
	moveCursor(3, 1);
	moveCursor(8, 12);

	//foo();
	//_assfoo();
	
}
