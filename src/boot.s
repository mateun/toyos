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
	;call idtTest
	;call idtTest

	lidt [idtr]
	;mov eax, defaultIntHandler
	;mov [idt_start], ax
	;mov word [idt_start +2], cs
	;mov word [idt_start +4], 8e00h
	;shr eax, 16
	;mov [idt_start + 6], ax
	mov eax, defaultIntHandler
	push eax
	push word 0
	mov ebx, [esp]
	mov eax, [esp + 4]
	;call installIntHandler

	;int 0

	call idtTest

        ;cli
.hang:  hlt
        jmp .hang
.end:

installIntHandler:
	;pop ebx		; our handler number
	;pop eax		; our handler address
	;mov ebx, [sp + 4]
	;mov eax, [sp + 8]
	mov ebx, [esp + 4]
	pusha
	mov eax, defaultIntHandler
	mov [idt_start + ebx], ax
	mov word [idt_start + ebx + 2], cs
	mov word [idt_start + ebx + 4], 8e00h
	shr eax, 16
	mov [idt_start + ebx + 6], ax
	popa
	ret

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

