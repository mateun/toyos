#include <stdint.h>
#include "keys.h"

extern cursorPosition;

// This stores the entered command
// (there is only one active any time)
static char cmdBuf[80];
static char bufPos = 0;
static char consoleRow = 0;
static char consoleCol = 0;

void initConsole() {
	printConsolePrompt(0);
	consoleCol = 3; // our start position
}

void printConsolePrompt(uint8_t row) {
	uint8_t* vidmem = (uint8_t*) 0xb8000;
	uint16_t pos = row * 80 * 2;
	vidmem[pos] = '>';
	vidmem[pos + 1] = 0xF;

}

void incCursorPos() {
	cursorPosition += 2;

}

// 
void moveCursor(uint8_t row, uint8_t col) {
	uint16_t pos = (row * 80) + col;
	outportb(0x3D4, 0x0F);
	outportb(0x3D5, pos&0xFF);

	outportb(0x3D4, 0x0E);
	outportb(0x3D5, (pos>>8)&0xFF);

}

void printCommandBufferContents() {
	// calculate the cursor position
	cursorPosition = (consoleRow * 80) + consoleCol;
	char cmd[bufPos+2];
	uint8_t i = 0;
	for (i = 0; i <= bufPos; i++) {
		cmd[i] = cmdBuf[i];	
	}	
	cmd[i] = '\0';

	printk(cmd);
}

void consoleKeyEvent(uint8_t key, uint8_t keyState, uint8_t keyType) {
	if (keyType == KEY_TYPE_NON_FUNC) {
		//printkc(key);
		cmdBuf[bufPos++] = key;
		printCommandBufferContents();
	}

}
