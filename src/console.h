#include <stdint.h>

void initConsole();
void printConsolePrompt(uint8_t row);
void incCursorPos();
void moveCursor(uint8_t row, uint8_t col);
