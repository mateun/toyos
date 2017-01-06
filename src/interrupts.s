; This macro installs an interrupt handler
; at the given position within the idt. 
; 
; input parameters:
; 	%1 = handler function (just use the label directly, no strings...)
;	%2 = position in the IDT
;
%macro installIntHandler 2

	mov eax, %1 
	mov [idt_start + (%2*8)], ax
	mov word [idt_start + 2 + (%2*8)], cs
	mov word [idt_start + 4 + (%2*8)], 8e00h
	shr eax, 16
	mov [idt_start + 6 + (%2*8)], ax

%endmacro

section .data
idt_start:
	times 256 * 8 db 0	; one idt entry is 8 bytes, and we need 256 of them	
idt_end:


idtr:
	dw idt_end - idt_start - 1
	dd idt_start

section .text
global initInterrupts
initInterrupts:
	push ebp
	mov ebp, esp

	lidt [idtr]
	
	installIntHandler defaultIntHandler,0
	installIntHandler defaultIntHandler,1
	installIntHandler defaultIntHandler,2
	installIntHandler defaultIntHandler,3
	installIntHandler defaultIntHandler,7
	installIntHandler defaultIntHandler,8
	installIntHandler keyboardHandler,9
	
	; masking out all irqs but irq1 (the keyboard)
	mov al, 11111101b
	out 0x21, al
	out 0xa1, al


	mov esp, ebp
	pop ebp

	; turn on interrupts
	sti

	ret

defaultIntHandler:
	pusha
	extern cursorPos
	mov eax, [cursorPos]
	mov [ds:0b8000h + eax], word 0449h
	add word [cursorPos], 2
	popa
	iret	

keyboardHandler:
	pusha
	in al, 60h
	
	; ignore the "just released"
	; state for now
	test al, 80h
	jnz .endKbHandler

	extern cursorPos
	mov ebx, [cursorPos]
	mov [ds:0b8000h + ebx], word 0453h	
	add word [cursorPos], 2
	
.endKbHandler:
	mov al, 20h 
	out 20h, al	

	popa
	iret
