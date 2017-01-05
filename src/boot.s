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
	installIntHandler keyboardHandler,7
	installIntHandler keyboardHandler,8
	installIntHandler keyboardHandler,9
	

	; init PIC
	;xor eax, eax
	;in al, 0x21
	;push eax
	;xor eax, eax
	;in al, 0xa1

	;mov al, 11
	;out 0x20, al 
	;out 0xa0, al

	;mov al, 8
	;out 0x21, al
	;mov al, 0x70
	;out 0xa1, al
	
	;mov al, 4
	;out 0x21, al
	;mov al, 2
	;out 0xa1, al
	
	;mov al, 1
	;out 0x21, al
	;out 0xa1, al		

	;xor eax, eax
	;pop eax
	;out 0x21, al
	;pop eax
	;out 0xa1, al
	
	mov al, 11111101b
	out 0x21, al
	out 0xa1, al

	call idtTest

       	;cli
	sti
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

keyboardHandler:
	pusha
	in al, 60h
	mov ebx, [cursorPos]
	mov [ds:0b8000h + ebx], word 0454h	
	add word [cursorPos], 2
	
	mov al, 20h 
	out 20h, al	

	popa
	iret
