#include <stdint.h>
#include "keymaps.h"

uint16_t cursorPosition=0;

void printk(char*);

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
	vidmem[cursorPosition] = c;
	vidmem[cursorPosition+1] = 0xF;
	cursorPosition += 2;

}

void itoan(int num, char* str) {
	char sign = 0;
	char temp[17];

	int temp_loc = 0;
	int digit;
	int str_loc = 0;

	if (num < 0) {
		sign = 1;
		num = -num;
	}

	do {
		digit = (uint32_t)num % 10;
		if (digit < 10) 
			temp[temp_loc++] = digit + '0';
		else 
			temp[temp_loc++] = digit - 10 + 'A';
		num = (((uint32_t)num) / 10);

		//printkc((char) digit);

	} while ((uint32_t)num > 0);

	if (sign) {
		temp[temp_loc] = '-';
	} else {
		temp_loc--;
	}

	while (temp_loc >= 0) {
		str[str_loc++] = temp[temp_loc--];

	}

	str[str_loc] = 0;
}

// This gets called from the
// assembler keyboard interrupt handler
void onKeyPressed(char scancode) {
	char nr[16]; 
	itoan(scancode, nr);
	
	// TODO lookup scancode in keymap
	char c = keymapGerman[scancode];
	printkc(c);
	printkc('(');
	printk(nr);
	printkc(')');
	printkc(' ');

	//cursorPosition += 2;	
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
		vidmem[cursorPosition] = c;
		vidmem[cursorPosition + 1] = 0xF;
		cursorPosition += 2;
		
		idxText++;
	}
	cursorPosition -= 2;
}
