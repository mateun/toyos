section .text
global _assfoo:function (_assfoo.end - _assfoo)
_assfoo:
	push dword 0b8000h
	xor edi, edi
	pop edi
	mov [ds:edi+0ah], word 459h

.end:

