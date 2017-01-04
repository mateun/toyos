#include <stddef.h>
#include <stdint.h>

void foo();
void _assfoo();


void kernel_start(void) {
	// no op here...		
	//while(1) {
	//
	//}

	// write a letter to videomemory
	uint16_t *vidmem = (uint16_t*) 0xB8004;
	vidmem[0] = 0x449;

	foo();
	_assfoo();
	
}
