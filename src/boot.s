%macro installIntHandler 2

	mov eax, %1 
	mov [idt_start + (%2*8)], ax
	mov word [idt_start + 2 + (%2*8)], cs
	mov word [idt_start + 4 + (%2*8)], 8e00h
	shr eax, 16
	mov [idt_start + 6 + (%2*8)], ax

%endmacro

%macro silly 2
	push %1
	push %2
%endmacro

MBALIGN equ 1<<0
MEMINFO equ 1<<1
FLAGS   equ MBALIGN | MEMINFO
MAGIC   equ 0x1BADB002
CHECKSUM equ -(MAGIC+FLAGS)

section .multiboot
align 4
        dd MAGIC
        dd FLAGS
        dd CHECKSUM

section .bss
align 4
stack_bottom:
resb 16384              ; 16 KiB
stack_top:



section .data

idt_start:
	times 256 * 8 db 0	; one idt entry is 8 bytes, and we need 256 of them	
idt_end:


idtr:
	dw idt_end - idt_start - 1
	dd idt_start


cursorPos: dw 0

section .text
global _start:function (_start.end - _start)
_start:
        mov esp, stack_top
	push dword 0b8000h
	xor edi, edi
	pop edi
	mov [ds:edi], word 441h
        ;extern kernel_start
        ;call kernel_start
	;mov [ds:edi+2], word 442h
	call idtTest

	lidt [idtr]

	installIntHandler defaultIntHandler,0
	installIntHandler defaultIntHandler,1
	installIntHandler defaultIntHandler,2
	installIntHandler defaultIntHandler,3
	
	
	int 0
	int 1
	int 2
	int 3

	call idtTest

        ;cli
.hang:  hlt
        jmp .hang
.end:

idtTest:
	pusha
	mov eax, [cursorPos]
	mov [ds:0b8000h + eax], word 0448h
	add word [cursorPos], 2
	popa
	ret

defaultIntHandler:
	pusha
	mov eax, [cursorPos]
	mov [ds:0b8000h + eax], word 0449h
	add word [cursorPos], 2
	popa
	iret	

