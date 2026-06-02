bits 64
default rel

SECTION .rodata			  ; Section containing initialized read-only data
SECTION .bss              ; Section containing uninitialized data

section .text.pad exec nowrite align=1
    nop

global   ft_strlen:function (ft_strlen.end - ft_strlen)

SECTION .text			  ; Section containing code

; size_t ft_strlen(const char *src);
ft_strlen:
	push  rbx				; save any registers that
	push  rcx				; we will trash in here

	; save arguments
	mov   rbx, rdi			; rbx = rdi == const char *src

	; calculating the length
	xor   al, al			; the byte that the scan will compare to is zero
	cld						; left to right or auto-increment mode
	xor   ecx,ecx			; rcx = 0 (same as [sub  ecx,ecx])
	dec   rcx				; rcx = -1 (0xFFFFFFFFFFFFFFFF)
							; assuming any string will have the maximum number of bytes is 4gb
repne scasb					; while [rdi] != al, keep scanning
	sub   rdi, rbx			; length = dist2 - dist1
	sub   rdi, 0x1			; fix that into "string length" (-1 for '\0')
	mov   rax, rdi			; rax now holds our length

	; restore saved registers
	pop   rcx
	pop   rbx
	ret                       ; all done!
.end:
