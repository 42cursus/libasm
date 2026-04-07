bits 64
default rel

%assign SYS_write		1

SECTION .rodata			  ; Section containing initialized read-only data
SECTION .bss              ; Section containing uninitialized data
SECTION .text.pad exec nowrite align=1
    nop

extern __errno_location
global   ft_write:function (ft_write.end - ft_write)

SECTION .text			  ; Section containing code

;
; On success, the number of bytes written is returned.
; On error, -1 is returned, and errno is set to indicate the cause of the error.
;
; ssize_t ft_write(int fd, const char *buf, size_t size)
ft_write:
	push	rbp
	mov	rbp, rsp
	push	rbx
	sub	rsp, 8		; reserve 8 bytes for stack alignment

	; write(int fd, const void *buf, size_t count);
	mov rax, strict qword SYS_write ; write
	mov rdx, rdx					; size
	mov rsi, rsi					; buf
	mov rdi, rdi					; fd
	syscall

	mov	ebx, eax ; int res

	; Linux syscalls return negative error codes in the range -1 to -4095
	; glibc considers negative syscall return values in the range [-4096 < retval < 0] to be error values

	; if ((unsigned long)res >= (unsigned long)-4095)
	cmp	eax, -4096
	jbe	.LEAVE

.fail:
	call	__errno_location wrt ..plt
	neg	ebx
	mov	dword [rax], ebx
	mov	eax, -1

.LEAVE:
	add	rsp, 8
	pop rbx
	pop	rbp
	ret                       		; all done!
.end:
