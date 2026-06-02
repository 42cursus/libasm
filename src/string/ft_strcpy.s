bits 64
default rel

%define NULL  0

%define dest            qword[rbp - 24] ; QWORD PTR -24[rbp]
%define src       		qword[rbp - 32] ; QWORD PTR -32[rbp]

SECTION .rodata			  ; Section containing initialized read-only data
SECTION .bss              ; Section containing uninitialized data

section .text.pad exec nowrite align=1
    nop

global   ft_strcpy:function (ft_strcpy.end - ft_strcpy)

SECTION .text			  ; Section containing code

ft_strcpy:
	push	rbp
	mov	rbp, rsp
	push  rbx
	sub	rsp, 24

	; save arguments
	mov	dest, rdi
	mov	rbx, rdi
	mov	src, rsi

.strcpy_loop_start:
	jmp	.strcpy_loop_iter

.strcpy_loop_body:
	mov	rdx, src				; const char *old_src = src;
	lea	rax, 1[rdx]				; const char *new_src = src + 1;
	mov	src, rax				; src = new_src;

	mov	rax, dest				; char *old_dest = dest;
	lea	rcx, 1[rax]				; char *new_dest = dest + 1;
	mov	dest, rcx				; dest = new_dest;

	movzx	edx, byte[rdx]		; char tmp = *old_src;
	mov	byte[rax], dl			; *old_dest = tmp;

.strcpy_loop_iter:
	mov	rax, src
	cmp	byte[rax], 0
	jne	.strcpy_loop_body

.strcpy_loop_end:
	mov	rax, dest
	mov	byte[rax], 0
	mov	rax, rbx
	mov	rbx, qword[rbp]
	leave
	ret
.end:
