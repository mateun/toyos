#include <stdint.h>

void outportb(uint16_t port, uint8_t value) {
	asm ("outb %%al,%%dx" : : "d" (port), "a" (value));
}

uint8_t inportb(uint16_t port) {
	uint8_t result;
	asm ("inb %%dx, %%al" : "=a" (result) : "d" (port));
	return result;
}

void printkc(char c) {
	uint8_t *vidmem = (uint8_t*) 0xB8000;
	uint16_t idx = 0;
	vidmem[idx] = c;
	vidmem[idx+1] = 0x4;

}

// Very simple print function which
// just prints everything until it sees an ending 0.
void printk(char* text) {
	uint8_t *vidmem = (uint8_t*) 0xB8000;

	char c = text[0];
	uint16_t idx = 0;
	uint8_t idxText = 0;
	while (c != 0) {
		c = text[idxText];
		vidmem[idx] = c;
		vidmem[idx+1] = 0xF;
		idx += 2;
		idxText++;
	}
}
