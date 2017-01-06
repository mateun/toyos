#include <stdint.h>

void outportb(uint16_t port, uint8_t value) {
	asm ("outb %%al,%%dx" : : "d" (port), "a" (value));
}

uint8_t inportb(uint16_t port) {
	uint8_t result;
	asm ("inb %%dx, %%al" : "=a" (result) : "d" (port));
	return result;
}
