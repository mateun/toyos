#include <stdint.h>

void foo() {
	// just a dummy func
	uint16_t *vidmem = (uint16_t*) 0xB8006;
	vidmem[0] = 0x444;


}
